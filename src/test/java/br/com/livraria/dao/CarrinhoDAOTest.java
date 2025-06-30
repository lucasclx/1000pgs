package br.com.livraria.dao;

import br.com.livraria.model.*;
import br.com.livraria.util.ConexaoDB;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Testes para CarrinhoDAO
 */
class CarrinhoDAOTest {

    private CarrinhoDAO carrinhoDAO;
    private UsuarioDAO usuarioDAO;
    private LivroDAO livroDAO;
    private Connection conn;
    private int usuarioTesteId;
    private int livroTesteId;

    @BeforeEach
    void setUp() throws SQLException {
        carrinhoDAO = new CarrinhoDAO();
        usuarioDAO = new UsuarioDAO();
        livroDAO = new LivroDAO();
        conn = ConexaoDB.obterConexao();
        
        // Criar usuário e livro para teste
        Usuario usuario = new Usuario("User Teste", "teste@carrinho.com", "senha123");
        usuarioDAO.cadastrar(usuario);
        Usuario usuarioCriado = usuarioDAO.buscarPorEmail("teste@carrinho.com");
        usuarioTesteId = usuarioCriado.getId();
        
        // Criar livro básico para teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO categorias (nome) VALUES ('Cat Teste')",
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.executeUpdate();
            var rs = stmt.getGeneratedKeys();
            rs.next();
            int catId = rs.getInt(1);
            
            try (PreparedStatement stmt2 = conn.prepareStatement(
                    "INSERT INTO autores (nome) VALUES ('Autor Teste')",
                    PreparedStatement.RETURN_GENERATED_KEYS)) {
                stmt2.executeUpdate();
                var rs2 = stmt2.getGeneratedKeys();
                rs2.next();
                int autorId = rs2.getInt(1);
                
                try (PreparedStatement stmt3 = conn.prepareStatement(
                        "INSERT INTO livros (titulo, preco, estoque, categoria_id, autor_id) VALUES ('Livro Carrinho', 25.50, 10, ?, ?)",
                        PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmt3.setInt(1, catId);
                    stmt3.setInt(2, autorId);
                    stmt3.executeUpdate();
                    var rs3 = stmt3.getGeneratedKeys();
                    rs3.next();
                    livroTesteId = rs3.getInt(1);
                }
            }
        }
    }

    @AfterEach
    void tearDown() throws SQLException {
        carrinhoDAO.limpar(usuarioTesteId);
        
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM usuarios WHERE email = 'teste@carrinho.com'")) {
            stmt.executeUpdate();
        }
        
        ConexaoDB.fecharConexao(conn);
    }

    @Test
    void testAdicionarItem() {
        assertTrue(carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 2));
        
        List<Carrinho> itens = carrinhoDAO.listarItens(usuarioTesteId);
        assertFalse(itens.isEmpty());
        assertEquals(2, itens.get(0).getQuantidade());
    }

    @Test
    void testAtualizarQuantidade() {
        carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 1);
        
        assertTrue(carrinhoDAO.atualizarQuantidade(usuarioTesteId, livroTesteId, 5));
        
        List<Carrinho> itens = carrinhoDAO.listarItens(usuarioTesteId);
        assertEquals(5, itens.get(0).getQuantidade());
    }

    @Test
    void testRemoverItem() {
        carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 1);
        
        assertTrue(carrinhoDAO.removerItem(usuarioTesteId, livroTesteId));
        
        List<Carrinho> itens = carrinhoDAO.listarItens(usuarioTesteId);
        assertTrue(itens.isEmpty());
    }

    @Test
    void testContarItens() {
        carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 3);
        
        int total = carrinhoDAO.contarItens(usuarioTesteId);
        assertEquals(3, total);
    }

    @Test
    void testCalcularTotal() {
        carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 2);
        
        BigDecimal total = carrinhoDAO.calcularTotal(usuarioTesteId);
        assertEquals(new BigDecimal("51.00"), total); // 25.50 * 2
    }

    @Test
    void testLimparCarrinho() {
        carrinhoDAO.adicionarItem(usuarioTesteId, livroTesteId, 2);
        
        carrinhoDAO.limpar(usuarioTesteId);
        
        List<Carrinho> itens = carrinhoDAO.listarItens(usuarioTesteId);
        assertTrue(itens.isEmpty());
    }
}