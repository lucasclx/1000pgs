package br.com.livraria.dao;

import br.com.livraria.model.Usuario;
import br.com.livraria.util.ConexaoDB;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class UsuarioDAOTest {

    private UsuarioDAO usuarioDAO;
    private Connection conn;

    @BeforeEach
    void setUp() throws SQLException {
        usuarioDAO = new UsuarioDAO();
        conn = ConexaoDB.obterConexao();
        // Limpa dados de teste antes de cada teste para garantir um estado consistente
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM usuarios WHERE email LIKE 'testuser%' OR email LIKE 'updateduser%'")) {
            stmt.executeUpdate();
        }
    }

    @AfterEach
    void tearDown() throws SQLException {
        // Limpa dados de teste depois de cada teste
        try (PreparedStatement stmt = conn.prepareStatement("DELETE FROM usuarios WHERE email LIKE 'testuser%' OR email LIKE 'updateduser%'")) {
            stmt.executeUpdate();
        }
        ConexaoDB.fecharConexao(conn);
    }

    @Test
    void testCadastrarUsuario() {
        Usuario usuario = new Usuario("Test User", "testuser@example.com", "password123");
        usuario.setTelefone("11987654321");
        usuario.setEndereco("Rua Teste, 123");
        usuario.setCidade("Cidade Teste");
        usuario.setEstado("TS");
        usuario.setCep("12345-678");

        assertTrue(usuarioDAO.cadastrar(usuario));

        // Verifica se o usuário foi realmente criado no banco
        Usuario foundUser = usuarioDAO.buscarPorEmail("testuser@example.com");
        assertNotNull(foundUser);
        assertEquals("Test User", foundUser.getNome());
        assertEquals("testuser@example.com", foundUser.getEmail());
        // Não é recomendado afirmar a senha diretamente, pois ela é criptografada
        assertEquals("cliente", foundUser.getTipo());
        assertTrue(foundUser.isAtivo());
    }

    @Test
    void testAutenticarUsuario_sucesso() {
        Usuario usuario = new Usuario("Auth User", "testuser_auth@example.com", "securepass");
        usuarioDAO.cadastrar(usuario);

        Usuario authenticatedUser = usuarioDAO.autenticar("testuser_auth@example.com", "securepass");
        assertNotNull(authenticatedUser);
        assertEquals("Auth User", authenticatedUser.getNome());
    }

    @Test
    void testAutenticarUsuario_falhaEmailInvalido() {
        Usuario authenticatedUser = usuarioDAO.autenticar("nonexistent@example.com", "anypass");
        assertNull(authenticatedUser);
    }

    @Test
    void testAutenticarUsuario_falhaSenhaInvalida() {
        Usuario usuario = new Usuario("Auth User 2", "testuser_auth2@example.com", "correctpass");
        usuarioDAO.cadastrar(usuario);

        Usuario authenticatedUser = usuarioDAO.autenticar("testuser_auth2@example.com", "wrongpass");
        assertNull(authenticatedUser);
    }

    @Test
    void testBuscarPorId() {
        Usuario usuario = new Usuario("Find User", "testuser_find@example.com", "findpass");
        usuarioDAO.cadastrar(usuario); // Isso atribuirá um ID

        // Recupera o ID após a criação
        Usuario createdUser = usuarioDAO.buscarPorEmail("testuser_find@example.com");
        assertNotNull(createdUser);
        
        Usuario foundUser = usuarioDAO.buscarPorId(createdUser.getId());
        assertNotNull(foundUser);
        assertEquals(createdUser.getNome(), foundUser.getNome());
    }

    @Test
    void testBuscarPorEmail() {
        Usuario usuario = new Usuario("Email User", "testuser_email@example.com", "emailpass");
        usuarioDAO.cadastrar(usuario);

        Usuario foundUser = usuarioDAO.buscarPorEmail("testuser_email@example.com");
        assertNotNull(foundUser);
        assertEquals("Email User", foundUser.getNome());
    }

    @Test
    void testAtualizarUsuario() {
        Usuario usuario = new Usuario("Original Name", "testuser_update@example.com", "oldpass");
        usuarioDAO.cadastrar(usuario);

        Usuario userToUpdate = usuarioDAO.buscarPorEmail("testuser_update@example.com");
        assertNotNull(userToUpdate);

        userToUpdate.setNome("Updated Name");
        userToUpdate.setTelefone("9988776655");
        userToUpdate.setEndereco("Nova Rua, 456");
        userToUpdate.setCidade("Nova Cidade");
        userToUpdate.setEstado("SP");
        userToUpdate.setCep("98765-432");

        assertTrue(usuarioDAO.atualizar(userToUpdate));

        Usuario updatedUser = usuarioDAO.buscarPorEmail("testuser_update@example.com");
        assertNotNull(updatedUser);
        assertEquals("Updated Name", updatedUser.getNome());
        assertEquals("9988776655", updatedUser.getTelefone());
        assertEquals("Nova Rua, 456", updatedUser.getEndereco());
        assertEquals("Nova Cidade", updatedUser.getCidade());
        assertEquals("SP", updatedUser.getEstado());
        assertEquals("98765-432", updatedUser.getCep());
    }

    @Test
    void testAlterarSenha() {
        Usuario usuario = new Usuario("Password User", "testuser_pass@example.com", "oldpassword");
        usuarioDAO.cadastrar(usuario);

        Usuario createdUser = usuarioDAO.buscarPorEmail("testuser_pass@example.com");
        assertNotNull(createdUser);

        assertTrue(usuarioDAO.alterarSenha(createdUser.getId(), "newsecurepassword"));

        // Tenta autenticar com a senha antiga (deve falhar)
        assertNull(usuarioDAO.autenticar("testuser_pass@example.com", "oldpassword"));
        // Tenta autenticar com a nova senha (deve ter sucesso)
        assertNotNull(usuarioDAO.autenticar("testuser_pass@example.com", "newsecurepassword"));
    }
    
    @Test
    void testListarTodos() {
        // Garante que há pelo menos dois usuários para listagem
        Usuario user1 = new Usuario("List User 1", "testuser_list1@example.com", "pass1");
        Usuario user2 = new Usuario("List User 2", "testuser_list2@example.com", "pass2");
        usuarioDAO.cadastrar(user1);
        usuarioDAO.cadastrar(user2);
        
        List<Usuario> usuarios = usuarioDAO.listarTodos();
        assertNotNull(usuarios);
        assertTrue(usuarios.size() >= 2); // Pelo menos os dois que adicionamos mais quaisquer outros que possam existir
        
        // Verifica se os usuários adicionados estão na lista
        assertTrue(usuarios.stream().anyMatch(u -> u.getEmail().equals("testuser_list1@example.com")));
        assertTrue(usuarios.stream().anyMatch(u -> u.getEmail().equals("testuser_list2@example.com")));
    }
}