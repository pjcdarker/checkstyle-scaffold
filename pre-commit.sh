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

function check_mvn_result() {
  local result=$1
  local msg=$2
  echo "$msg result: $result"
  if [[ $result -ne 0 ]]
  then
    echo "$msg fail"
    exit 1
  fi
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

echo "mvn git-build-hook:install"
mvn git-build-hook:install

echo "mvn clean compile"
mvn clean compile
result=$?
check_mvn_result $result "mvn compile"

echo "mvn checkstyle:check"
mvn -q -pl "$modules_arg" checkstyle:check
mvn checkstyle:check
result=$?
check_mvn_result $result "checkstyle:check"

echo "mvn spotbugs:check"
mvn -q -pl "$modules_arg" spotbugs:check
result=$?
check_mvn_result $result "spotbugs:check"

echo "run git pre commit hook finish..."