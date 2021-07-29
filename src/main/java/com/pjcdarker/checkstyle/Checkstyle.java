package com.pjcdarker.checkstyle;

public class Checkstyle {

    public static void main(String[] args) {
        System.out.println("Hi Checkstyle v3.4.");
    }

    public void spotbugs_check_NullPointerException() {
        String text = null;
        System.out.println(text.toLowerCase());
    }
}
