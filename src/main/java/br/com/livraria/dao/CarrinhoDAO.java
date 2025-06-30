package br.com.livraria.dao;

import br.com.livraria.model.Carrinho;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * DAO para operações com carrinho
 */
class CarrinhoDAO {
    
    public boolean adicionarItem(int usuarioId, int livroId, int quantidade) {
        String sql = "INSERT INTO carrinho (usuario_id, livro_id, quantidade) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE quantidade = quantidade + ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, livroId);
            stmt.setInt(3, quantidade);
            stmt.setInt(4, quantidade);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean atualizarQuantidade(int usuarioId, int livroId, int quantidade) {
        String sql = "UPDATE carrinho SET quantidade = ? WHERE usuario_id = ? AND livro_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, quantidade);
            stmt.setInt(2, usuarioId);
            stmt.setInt(3, livroId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean removerItem(int usuarioId, int livroId) {
        String sql = "DELETE FROM carrinho WHERE usuario_id = ? AND livro_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setInt(2, livroId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<Carrinho> listarItens(int usuarioId) {
        List<Carrinho> itens = new ArrayList<>();
        String sql = "SELECT c.*, l.titulo, l.preco, l.preco_promocional, l.capa, l.estoque, a.nome as autor_nome " +
                    "FROM carrinho c " +
                    "JOIN livros l ON c.livro_id = l.id " +
                    "JOIN autores a ON l.autor_id = a.id " +
                    "WHERE c.usuario_id = ? ORDER BY c.data_adicao DESC";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Carrinho item = new Carrinho();
                item.setId(rs.getInt("id"));
                item.setUsuarioId(rs.getInt("usuario_id"));
                item.setLivroId(rs.getInt("livro_id"));
                item.setQuantidade(rs.getInt("quantidade"));
                item.setDataAdicao(rs.getTimestamp("data_adicao").toLocalDateTime());
                item.setLivroTitulo(rs.getString("titulo"));
                item.setLivroPreco(rs.getBigDecimal("preco"));
                item.setLivroPrecoPromocional(rs.getBigDecimal("preco_promocional"));
                item.setLivroCapa(rs.getString("capa"));
                item.setLivroEstoque(rs.getInt("estoque"));
                item.setLivroAutor(rs.getString("autor_nome"));
                itens.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itens;
    }
    
    public BigDecimal calcularTotal(int usuarioId) {
        String sql = "SELECT SUM(c.quantidade * COALESCE(l.preco_promocional, l.preco)) as total " +
                    "FROM carrinho c JOIN livros l ON c.livro_id = l.id WHERE c.usuario_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal("total");
                return total != null ? total : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
    
    public int contarItens(int usuarioId) {
        String sql = "SELECT SUM(quantidade) as total FROM carrinho WHERE usuario_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public void limpar(int usuarioId) {
        String sql = "DELETE FROM carrinho WHERE usuario_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}