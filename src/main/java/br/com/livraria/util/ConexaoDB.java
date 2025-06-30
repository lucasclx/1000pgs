package br.com.livraria.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Classe utilitária para gerenciar conexões com o banco de dados MySQL
 */
public class ConexaoDB {
    
    private static final String URL = "jdbc:mysql://localhost:3306/ecommerce_livraria?useSSL=false&serverTimezone=America/Sao_Paulo&allowPublicKeyRetrieval=true";
    private static final String USUARIO = "root";
    private static final String SENHA = ""; // Altere conforme sua configuração
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    
    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL não encontrado", e);
        }
    }
    
    /**
     * Obtém uma conexão com o banco de dados
     * @return Connection
     * @throws SQLException
     */
    public static Connection obterConexao() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, SENHA);
    }
    
    /**
     * Fecha a conexão com o banco de dados
     * @param connection
     */
    public static void fecharConexao(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    /**
     * Testa a conexão com o banco de dados
     * @return boolean
     */
    public static boolean testarConexao() {
        try (Connection conn = obterConexao()) {
            return conn != null && !conn.isClosed();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}