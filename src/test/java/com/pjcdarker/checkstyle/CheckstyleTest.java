package com.pjcdarker.checkstyle;


import static org.junit.jupiter.api.Assertions.assertFalse;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class CheckstyleTest {


    private Checkstyle checkstyle;

    @BeforeEach
    void setUp() {
        checkstyle = new Checkstyle();
    }

    @Test
    void should_check() {
        assertFalse(checkstyle.check());
    }

    // @Test
    // void should_check2() {
    //     assertFalse(checkstyle.check2());
    // }
    //
    // @Test
    // void should_check3() {
    //     assertFalse(checkstyle.check3());
    // }
}