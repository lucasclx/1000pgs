package br.com.livraria.dao;

import br.com.livraria.model.Avaliacao;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com avaliações
 */
public class AvaliacaoDAO {
    
    public boolean criarAvaliacao(Avaliacao avaliacao) {
        String sql = "INSERT INTO avaliacoes (livro_id, usuario_id, nota, comentario) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, avaliacao.getLivroId());
            stmt.setInt(2, avaliacao.getUsuarioId());
            stmt.setInt(3, avaliacao.getNota());
            stmt.setString(4, avaliacao.getComentario());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Avaliacao> listarPorLivro(int livroId) {
        List<Avaliacao> avaliacoes = new ArrayList<>();
        String sql = "SELECT a.*, u.nome as usuario_nome " +
                    "FROM avaliacoes a JOIN usuarios u ON a.usuario_id = u.id " +
                    "WHERE a.livro_id = ? AND a.aprovado = TRUE " +
                    "ORDER BY a.data_avaliacao DESC";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, livroId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Avaliacao avaliacao = new Avaliacao();
                avaliacao.setId(rs.getInt("id"));
                avaliacao.setLivroId(rs.getInt("livro_id"));
                avaliacao.setUsuarioId(rs.getInt("usuario_id"));
                avaliacao.setNota(rs.getInt("nota"));
                avaliacao.setComentario(rs.getString("comentario"));
                avaliacao.setAprovado(rs.getBoolean("aprovado"));
                avaliacao.setDataAvaliacao(rs.getTimestamp("data_avaliacao").toLocalDateTime());
                avaliacao.setUsuarioNome(rs.getString("usuario_nome"));
                avaliacoes.add(avaliacao);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return avaliacoes;
    }
    
    public boolean usuarioComprou(int usuarioId, int livroId) {
        String sql = "SELECT COUNT(*) as total FROM pedidos p " +
                    "JOIN itens_pedido ip ON p.id = ip.pedido_id " +
                    "WHERE p.usuario_id = ? AND ip.livro_id = ? AND p.status IN ('entregue', 'enviado')";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, livroId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total") > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}