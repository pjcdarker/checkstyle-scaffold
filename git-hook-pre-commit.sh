#!/bin/bash -e

echo "run git pre commit hook starting..."

function get_module() {
  local path=$1
  while true; do
    path=$(dirname $path)
    if [ -f "$path/pom.xml" ]; then
      echo "$path"
      return
    elif [[ "./" =~ "$path" ]]; then
      return
    fi
  done
}

modules=()

for file in $(git diff --name-only --cached \*.java); do
  module=$(get_module "$file")
  if [ "" != "$module" ] \
      && [[ ! " ${modules[@]} " =~ " $module " ]]; then
    modules+=("$module")
  fi
done

if [ ${#modules[@]} -eq 0 ]; then
  exit
fi

modules_arg=$(printf ",%s" "${modules[@]}")
modules_arg=${modules_arg:1}

export MAVEN_OPTS="-client
  -XX:+TieredCompilation
  -XX:TieredStopAtLevel=1
  -Xverify:none"

mvn clean

echo "run checkstyle:check"
mvn -q -pl "$modules_arg" checkstyle:check

echo "run spotbugs:check"
mvn -q -pl "$modules_arg" spotbugs:check

echo "run git pre commit hook finish..."