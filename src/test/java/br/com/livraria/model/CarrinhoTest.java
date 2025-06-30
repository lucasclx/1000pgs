package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;
import java.math.BigDecimal;

/**
 * Testes para a classe Carrinho
 */
class CarrinhoTest {
    
    private Carrinho carrinho;
    
    @BeforeEach
    void setUp() {
        carrinho = new Carrinho(1, 1, 2);
    }
    
    @Test
    void testConstrutorCarrinho() {
        assertEquals(1, carrinho.getUsuarioId());
        assertEquals(1, carrinho.getLivroId());
        assertEquals(2, carrinho.getQuantidade());
    }
    
    @Test
    void testPrecoFinal_semPromocao() {
        carrinho.setLivroPreco(new BigDecimal("50.00"));
        carrinho.setLivroPrecoPromocional(null);
        
        assertEquals(new BigDecimal("50.00"), carrinho.getPrecoFinal());
    }
    
    @Test
    void testPrecoFinal_comPromocao() {
        carrinho.setLivroPreco(new BigDecimal("50.00"));
        carrinho.setLivroPrecoPromocional(new BigDecimal("40.00"));
        
        assertEquals(new BigDecimal("40.00"), carrinho.getPrecoFinal());
    }
    
    @Test
    void testSubtotal() {
        carrinho.setLivroPreco(new BigDecimal("25.00"));
        carrinho.setQuantidade(3);
        
        assertEquals(new BigDecimal("75.00"), carrinho.getSubtotal());
    }
    
    @Test
    void testSubtotal_comPromocao() {
        carrinho.setLivroPreco(new BigDecimal("30.00"));
        carrinho.setLivroPrecoPromocional(new BigDecimal("20.00"));
        carrinho.setQuantidade(2);
        
        assertEquals(new BigDecimal("40.00"), carrinho.getSubtotal());
    }
}