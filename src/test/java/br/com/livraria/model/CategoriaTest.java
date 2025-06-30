package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Testes para a classe Categoria
 */
class CategoriaTest {
    
    private Categoria categoria;
    
    @BeforeEach
    void setUp() {
        categoria = new Categoria("Ficção", "Livros de ficção científica");
    }
    
    @Test
    void testConstrutorCategoria() {
        assertEquals("Ficção", categoria.getNome());
        assertEquals("Livros de ficção científica", categoria.getDescricao());
        assertTrue(categoria.isAtivo()); // Deve começar ativo
    }
    
    @Test
    void testCategoriaInativa() {
        categoria.setAtivo(false);
        assertFalse(categoria.isAtivo());
    }
    
    @Test
    void testToString() {
        String expected = "Categoria{id=0, nome='Ficção', descricao='Livros de ficção científica', ativo=true}";
        assertEquals(expected, categoria.toString());
    }
}