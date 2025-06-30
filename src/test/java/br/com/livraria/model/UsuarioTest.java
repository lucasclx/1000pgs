package br.com.livraria.model;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import static org.junit.jupiter.api.Assertions.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Testes adicionais para a classe Usuario
 */
public class UsuarioTest {
    
    private Usuario usuario;
    
    @BeforeEach
    void setUp() {
        usuario = new Usuario("João Silva", "joao@email.com", "senha123");
    }
    
    @Test
    void testConstrutorComParametros() {
        assertEquals("João Silva", usuario.getNome());
        assertEquals("joao@email.com", usuario.getEmail());
        assertEquals("senha123", usuario.getSenha());
        assertEquals("cliente", usuario.getTipo());
        assertTrue(usuario.isAtivo());
    }
    
    @Test
    void testIsAdmin_usuarioCliente() {
        usuario.setTipo("cliente");
        assertFalse(usuario.isAdmin());
    }
    
    @Test
    void testIsAdmin_usuarioAdmin() {
        usuario.setTipo("admin");
        assertTrue(usuario.isAdmin());
    }
    
    @Test
    void testSettersAndGetters() {
        usuario.setTelefone("11999888777");
        usuario.setEndereco("Rua das Flores, 123");
        usuario.setCidade("São Paulo");
        usuario.setEstado("SP");
        usuario.setCep("01234-567");
        
        assertEquals("11999888777", usuario.getTelefone());
        assertEquals("Rua das Flores, 123", usuario.getEndereco());
        assertEquals("São Paulo", usuario.getCidade());
        assertEquals("SP", usuario.getEstado());
        assertEquals("01234-567", usuario.getCep());
    }
    
    @Test
    void testUsuarioInativo() {
        usuario.setAtivo(false);
        assertFalse(usuario.isAtivo());
    }
}