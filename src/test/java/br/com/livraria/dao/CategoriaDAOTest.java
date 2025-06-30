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
import java.util.List;

/**
 * Testes para CategoriaDAO
 */
class CategoriaDAOTest {

    private CategoriaDAO categoriaDAO;
    private Connection conn;

    @BeforeEach
    void setUp() throws SQLException {
        categoriaDAO = new CategoriaDAO();
        conn = ConexaoDB.obterConexao();
        
        // Limpar categorias de teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM categorias WHERE nome LIKE 'Categoria Teste%'")) {
            stmt.executeUpdate();
        }
    }

    @AfterEach
    void tearDown() throws SQLException {
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM categorias WHERE nome LIKE 'Categoria Teste%'")) {
            stmt.executeUpdate();
        }
        ConexaoDB.fecharConexao(conn);
    }

    @Test
    void testListarTodas() {
        // Adicionar categoria de teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO categorias (nome, descricao, ativo) VALUES ('Categoria Teste', 'Descrição teste', TRUE)")) {
            stmt.executeUpdate();
        } catch (SQLException e) {
            fail("Erro ao criar categoria de teste");
        }
        
        List<Categoria> categorias = categoriaDAO.listarTodas();
        
        assertNotNull(categorias);
        assertTrue(categorias.stream().anyMatch(c -> c.getNome().equals("Categoria Teste")));
    }

    @Test
    void testBuscarPorId() {
        // Criar categoria e buscar seu ID
        int categoriaId = 0;
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO categorias (nome, descricao) VALUES ('Categoria Teste 2', 'Teste')",
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.executeUpdate();
            var rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                categoriaId = rs.getInt(1);
            }
        } catch (SQLException e) {
            fail("Erro ao criar categoria");
        }
        
        Categoria categoria = categoriaDAO.buscarPorId(categoriaId);
        
        assertNotNull(categoria);
        assertEquals("Categoria Teste 2", categoria.getNome());
    }
}