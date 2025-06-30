package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;
import java.math.BigDecimal;

/**
 * Testes para a classe ItemPedido
 */
class ItemPedidoTest {
    
    private ItemPedido item;
    
    @BeforeEach
    void setUp() {
        item = new ItemPedido(1, 3, new BigDecimal("25.50"));
    }
    
    @Test
    void testConstrutorItemPedido() {
        assertEquals(1, item.getLivroId());
        assertEquals(3, item.getQuantidade());
        assertEquals(new BigDecimal("25.50"), item.getPrecoUnitario());
        assertEquals(new BigDecimal("76.50"), item.getSubtotal());
    }
    
    @Test
    void testSettersItemPedido() {
        item.setLivroTitulo("Dom Casmurro");
        item.setLivroAutor("Machado de Assis");
        
        assertEquals("Dom Casmurro", item.getLivroTitulo());
        assertEquals("Machado de Assis", item.getLivroAutor());
    }
}