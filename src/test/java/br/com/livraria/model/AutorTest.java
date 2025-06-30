package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Testes para a classe Autor
 */
class AutorTest {
    
    private Autor autor;
    
    @BeforeEach
    void setUp() {
        autor = new Autor("Machado de Assis", "Escritor brasileiro do século XIX");
    }
    
    @Test
    void testConstrutorAutor() {
        assertEquals("Machado de Assis", autor.getNome());
        assertEquals("Escritor brasileiro do século XIX", autor.getBiografia());
    }
    
    @Test
    void testSetFoto() {
        autor.setFoto("/img/machado.jpg");
        assertEquals("/img/machado.jpg", autor.getFoto());
    }
}