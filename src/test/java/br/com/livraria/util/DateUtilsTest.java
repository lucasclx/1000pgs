package br.com.livraria.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

public class DateUtilsTest {

    @Test
    void testFormatarDataHora() {
        LocalDateTime dateTime = LocalDateTime.of(2025, 6, 30, 14, 30);
        assertEquals("30/06/2025 às 14:30", DateUtils.formatarDataHora(dateTime));
        assertEquals("", DateUtils.formatarDataHora(null));
    }

    @Test
    void testFormatarData() {
        LocalDateTime dateTime = LocalDateTime.of(2025, 6, 30, 14, 30);
        assertEquals("30/06/2025", DateUtils.formatarData(dateTime));
        assertEquals("", DateUtils.formatarData(null));
    }

    @Test
    void testFormatarHora() {
        LocalDateTime dateTime = LocalDateTime.of(2025, 6, 30, 14, 30);
        assertEquals("14:30", DateUtils.formatarHora(dateTime));
        assertEquals("", DateUtils.formatarHora(null));
    }
}