package cn.keking.service.impl;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SimTextFilePreviewImplTest {

    @Test
    void textData() throws Exception {
        assertFalse(SimTextFilePreviewImpl.textData("pom.xml").isEmpty());
        assertTrue(SimTextFilePreviewImpl.textData("file-not-exists.txt").isEmpty());
    }
}