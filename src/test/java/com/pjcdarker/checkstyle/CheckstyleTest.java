package com.pjcdarker.checkstyle;


import static org.junit.jupiter.api.Assertions.assertFalse;

import org.junit.jupiter.api.Test;

class CheckstyleTest {

    @Test
    void should_check() {
        Checkstyle checkstyle = new Checkstyle();

        assertFalse(checkstyle.check());
    }
}