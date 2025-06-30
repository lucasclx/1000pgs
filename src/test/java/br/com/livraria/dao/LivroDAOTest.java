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
 * Testes para LivroDAO
 */
public class LivroDAOTest {

    private LivroDAO livroDAO;
    private CategoriaDAO categoriaDAO;
    private AutorDAO autorDAO;
    private Connection conn;
    private int categoriaTesteId;
    private int autorTesteId;

    @BeforeEach
    void setUp() throws SQLException {
        livroDAO = new LivroDAO();
        categoriaDAO = new CategoriaDAO();
        autorDAO = new AutorDAO();
        conn = ConexaoDB.obterConexao();
        
        // Criar categoria e autor para teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO categorias (nome, descricao) VALUES ('Teste Cat', 'Categoria de teste')",
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.executeUpdate();
            var rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                categoriaTesteId = rs.getInt(1);
            }
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(
                "INSERT INTO autores (nome, biografia) VALUES ('Autor Teste', 'Biografia teste')",
                PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.executeUpdate();
            var rs = stmt.getGeneratedKeys();
            if (rs.next()) {
                autorTesteId = rs.getInt(1);
            }
        }
        
        // Limpar livros de teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM livros WHERE titulo LIKE 'Livro Teste%'")) {
            stmt.executeUpdate();
        }
    }

    @AfterEach
    void tearDown() throws SQLException {
        // Limpar dados de teste
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM livros WHERE titulo LIKE 'Livro Teste%'")) {
            stmt.executeUpdate();
        }
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM categorias WHERE id = ?")) {
            stmt.setInt(1, categoriaTesteId);
            stmt.executeUpdate();
        }
        try (PreparedStatement stmt = conn.prepareStatement(
                "DELETE FROM autores WHERE id = ?")) {
            stmt.setInt(1, autorTesteId);
            stmt.executeUpdate();
        }
        ConexaoDB.fecharConexao(conn);
    }

    @Test
    void testCadastrarLivro() {
        Livro livro = criarLivroTeste("Livro Teste 1");
        
        assertTrue(livroDAO.cadastrar(livro));
        
        // Verificar se foi realmente cadastrado
        List<Livro> livros = livroDAO.buscar("Livro Teste 1", null, null);
        assertFalse(livros.isEmpty());
        assertEquals("Livro Teste 1", livros.get(0).getTitulo());
    }

    @Test
    void testBuscarPorId() {
        Livro livro = criarLivroTeste("Livro Teste 2");
        livroDAO.cadastrar(livro);
        
        // Buscar o livro criado
        List<Livro> livros = livroDAO.buscar("Livro Teste 2", null, null);
        assertFalse(livros.isEmpty());
        
        int livroId = livros.get(0).getId();
        Livro livroEncontrado = livroDAO.buscarPorId(livroId);
        
        assertNotNull(livroEncontrado);
        assertEquals("Livro Teste 2", livroEncontrado.getTitulo());
    }

    @Test
    void testAtualizarLivro() {
        Livro livro = criarLivroTeste("Livro Teste 3");
        livroDAO.cadastrar(livro);
        
        // Buscar o livro criado
        List<Livro> livros = livroDAO.buscar("Livro Teste 3", null, null);
        Livro livroParaAtualizar = livros.get(0);
        
        // Atualizar
        livroParaAtualizar.setTitulo("Livro Teste 3 Atualizado");
        livroParaAtualizar.setPreco(new BigDecimal("99.99"));
        
        assertTrue(livroDAO.atualizar(livroParaAtualizar));
        
        // Verificar atualização
        Livro livroAtualizado = livroDAO.buscarPorId(livroParaAtualizar.getId());
        assertEquals("Livro Teste 3 Atualizado", livroAtualizado.getTitulo());
        assertEquals(new BigDecimal("99.99"), livroAtualizado.getPreco());
    }

    @Test
    void testBuscarPorCategoria() {
        Livro livro = criarLivroTeste("Livro Teste Categoria");
        livroDAO.cadastrar(livro);
        
        List<Livro> livros = livroDAO.buscar(null, categoriaTesteId, null);
        
        assertFalse(livros.isEmpty());
        assertTrue(livros.stream().anyMatch(l -> l.getTitulo().equals("Livro Teste Categoria")));
    }

    @Test
    void testBuscarPorAutor() {
        Livro livro = criarLivroTeste("Livro Teste Autor");
        livroDAO.cadastrar(livro);
        
        List<Livro> livros = livroDAO.buscar(null, null, autorTesteId);
        
        assertFalse(livros.isEmpty());
        assertTrue(livros.stream().anyMatch(l -> l.getTitulo().equals("Livro Teste Autor")));
    }

    @Test
    void testListarDestaques() {
        Livro livro = criarLivroTeste("Livro Teste Destaque");
        livro.setDestaque(true);
        livroDAO.cadastrar(livro);
        
        List<Livro> destaques = livroDAO.listarDestaques();
        
        assertTrue(destaques.stream().anyMatch(l -> l.getTitulo().equals("Livro Teste Destaque")));
    }

    private Livro criarLivroTeste(String titulo) {
        Livro livro = new Livro();
        livro.setTitulo(titulo);
        livro.setDescricao("Descrição do " + titulo);
        livro.setIsbn("978-" + System.currentTimeMillis());
        livro.setPreco(new BigDecimal("29.90"));
        livro.setEstoque(10);
        livro.setPaginas(200);
        livro.setAnoPublicacao(2023);
        livro.setEditora("Editora Teste");
        livro.setCategoriaId(categoriaTesteId);
        livro.setAutorId(autorTesteId);
        livro.setAtivo(true);
        return livro;
    }
}