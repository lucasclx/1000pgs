
package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.math.BigDecimal;

public class LivroTest {

    @Test
    void testGetPrecoFinal_comPromocao() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(new BigDecimal("40.00"));
        assertEquals(new BigDecimal("40.00"), livro.getPrecoFinal());
    }

    @Test
    void testGetPrecoFinal_semPromocao() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(null);
        assertEquals(new BigDecimal("50.00"), livro.getPrecoFinal());
    }
    
    @Test
    void testGetPrecoFinal_precoPromocionalMaiorQuePreco() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(new BigDecimal("60.00")); // Should still use promotional if set
        assertEquals(new BigDecimal("60.00"), livro.getPrecoFinal());
    }

    @Test
    void testTemPromocao_comPromocaoValida() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(new BigDecimal("40.00"));
        assertTrue(livro.temPromocao());
    }

    @Test
    void testTemPromocao_semPromocao() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(null);
        assertFalse(livro.temPromocao());
    }
    
    @Test
    void testTemPromocao_precoPromocionalIgualAoPreco() {
        Livro livro = new Livro();
        livro.setPreco(new BigDecimal("50.00"));
        livro.setPrecoPromocional(new BigDecimal("50.00"));
        assertFalse(livro.temPromocao());
    }

    @Test
    void testTemEstoque_comEstoque() {
        Livro livro = new Livro();
        livro.setEstoque(10);
        assertTrue(livro.temEstoque());
    }

    @Test
    void testTemEstoque_semEstoque() {
        Livro livro = new Livro();
        livro.setEstoque(0);
        assertFalse(livro.temEstoque());
    }
}