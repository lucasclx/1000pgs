package br.com.livraria.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.sql.Connection;
import java.sql.SQLException;

public class ConexaoDBTest {

    @Test
    void testObterConexao() {
        try (Connection conn = ConexaoDB.obterConexao()) {
            assertNotNull(conn, "A conexão não deve ser nula");
            assertFalse(conn.isClosed(), "A conexão deve estar aberta");
        } catch (SQLException e) {
            fail("Erro ao obter conexão com o banco de dados: " + e.getMessage());
        }
    }

    @Test
    void testFecharConexao() {
        Connection conn = null;
        try {
            conn = ConexaoDB.obterConexao();
            assertNotNull(conn);
            assertFalse(conn.isClosed());
            
            ConexaoDB.fecharConexao(conn);
            assertTrue(conn.isClosed(), "A conexão deve ser fechada");
        } catch (SQLException e) {
            fail("Erro durante o teste de fechar conexão: " + e.getMessage());
        }
    }

    @Test
    void testTestarConexao() {
        // Este teste pressupõe que seu banco de dados esteja em execução e acessível.
        // Se não estiver, este teste falhará, o que indica um problema de conexão.
        assertTrue(ConexaoDB.testarConexao(), "A conexão com o banco de dados deve ser bem-sucedida");
    }
}