package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Testes para a classe Avaliacao
 */
class AvaliacaoTest {
    
    private Avaliacao avaliacao;
    
    @BeforeEach
    void setUp() {
        avaliacao = new Avaliacao(1, 1, 5, "Excelente livro!");
    }
    
    @Test
    void testConstrutorAvaliacao() {
        assertEquals(1, avaliacao.getLivroId());
        assertEquals(1, avaliacao.getUsuarioId());
        assertEquals(5, avaliacao.getNota());
        assertEquals("Excelente livro!", avaliacao.getComentario());
        assertFalse(avaliacao.isAprovado()); // Deve começar não aprovado
    }
    
    @Test
    void testAprovarAvaliacao() {
        avaliacao.setAprovado(true);
        assertTrue(avaliacao.isAprovado());
    }
}  