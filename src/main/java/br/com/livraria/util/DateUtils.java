package br.com.livraria.util;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

/**
 * Utilitário para formatação de datas
 */
public class DateUtils {
    
    private static final DateTimeFormatter FORMATTER_COMPLETO = 
        DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm", new Locale("pt", "BR"));
    
    private static final DateTimeFormatter FORMATTER_DATA = 
        DateTimeFormatter.ofPattern("dd/MM/yyyy", new Locale("pt", "BR"));
    
    private static final DateTimeFormatter FORMATTER_HORA = 
        DateTimeFormatter.ofPattern("HH:mm", new Locale("pt", "BR"));
    
    /**
     * Formata LocalDateTime para string completa (data e hora)
     */
    public static String formatarDataHora(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(FORMATTER_COMPLETO);
    }
    
    /**
     * Formata LocalDateTime para string de data apenas
     */
    public static String formatarData(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(FORMATTER_DATA);
    }
    
    /**
     * Formata LocalDateTime para string de hora apenas
     */
    public static String formatarHora(LocalDateTime dateTime) {
        if (dateTime == null) {
            return "";
        }
        return dateTime.format(FORMATTER_HORA);
    }
}