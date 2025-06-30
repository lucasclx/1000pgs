package br.com.livraria.dao;

import br.com.livraria.model.Livro;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * DAO para operações com livros
 */
class LivroDAO {
    
    public List<Livro> listarTodos() {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM vw_livros_completos WHERE ativo = TRUE ORDER BY titulo";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                livros.add(mapearLivroCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return livros;
    }
    
    public List<Livro> listarDestaques() {
        List<Livro> livros = new ArrayList<>();
        String sql = "SELECT * FROM vw_livros_completos WHERE ativo = TRUE AND destaque = TRUE ORDER BY titulo LIMIT 8";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                livros.add(mapearLivroCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return livros;
    }
    
    public List<Livro> buscar(String termo, Integer categoriaId, Integer autorId) {
        List<Livro> livros = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM vw_livros_completos WHERE ativo = TRUE");
        List<Object> parametros = new ArrayList<>();
        
        if (termo != null && !termo.trim().isEmpty()) {
            sql.append(" AND (titulo LIKE ? OR descricao LIKE ? OR autor_nome LIKE ?)");
            String termoBusca = "%" + termo.trim() + "%";
            parametros.add(termoBusca);
            parametros.add(termoBusca);
            parametros.add(termoBusca);
        }
        
        if (categoriaId != null && categoriaId > 0) {
            sql.append(" AND categoria_id = ?");
            parametros.add(categoriaId);
        }
        
        if (autorId != null && autorId > 0) {
            sql.append(" AND autor_id = ?");
            parametros.add(autorId);
        }
        
        sql.append(" ORDER BY titulo");
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parametros.size(); i++) {
                stmt.setObject(i + 1, parametros.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                livros.add(mapearLivroCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return livros;
    }
    
    public Livro buscarPorId(int id) {
        String sql = "SELECT * FROM vw_livros_completos WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearLivroCompleto(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean cadastrar(Livro livro) {
        String sql = "INSERT INTO livros (titulo, descricao, isbn, preco, preco_promocional, estoque, paginas, ano_publicacao, editora, capa, categoria_id, autor_id, destaque) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getDescricao());
            stmt.setString(3, livro.getIsbn());
            stmt.setBigDecimal(4, livro.getPreco());
            stmt.setBigDecimal(5, livro.getPrecoPromocional());
            stmt.setInt(6, livro.getEstoque());
            stmt.setInt(7, livro.getPaginas());
            stmt.setInt(8, livro.getAnoPublicacao());
            stmt.setString(9, livro.getEditora());
            stmt.setString(10, livro.getCapa());
            stmt.setInt(11, livro.getCategoriaId());
            stmt.setInt(12, livro.getAutorId());
            stmt.setBoolean(13, livro.isDestaque());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean atualizar(Livro livro) {
        String sql = "UPDATE livros SET titulo = ?, descricao = ?, isbn = ?, preco = ?, preco_promocional = ?, estoque = ?, paginas = ?, ano_publicacao = ?, editora = ?, capa = ?, categoria_id = ?, autor_id = ?, destaque = ? WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, livro.getTitulo());
            stmt.setString(2, livro.getDescricao());
            stmt.setString(3, livro.getIsbn());
            stmt.setBigDecimal(4, livro.getPreco());
            stmt.setBigDecimal(5, livro.getPrecoPromocional());
            stmt.setInt(6, livro.getEstoque());
            stmt.setInt(7, livro.getPaginas());
            stmt.setInt(8, livro.getAnoPublicacao());
            stmt.setString(9, livro.getEditora());
            stmt.setString(10, livro.getCapa());
            stmt.setInt(11, livro.getCategoriaId());
            stmt.setInt(12, livro.getAutorId());
            stmt.setBoolean(13, livro.isDestaque());
            stmt.setInt(14, livro.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Livro mapearLivroCompleto(ResultSet rs) throws SQLException {
        Livro livro = new Livro();
        livro.setId(rs.getInt("id"));
        livro.setTitulo(rs.getString("titulo"));
        livro.setDescricao(rs.getString("descricao"));
        livro.setIsbn(rs.getString("isbn"));
        livro.setPreco(rs.getBigDecimal("preco"));
        livro.setPrecoPromocional(rs.getBigDecimal("preco_promocional"));
        livro.setEstoque(rs.getInt("estoque"));
        livro.setPaginas(rs.getInt("paginas"));
        livro.setAnoPublicacao(rs.getInt("ano_publicacao"));
        livro.setEditora(rs.getString("editora"));
        livro.setCapa(rs.getString("capa"));
        livro.setCategoriaId(rs.getInt("categoria_id"));
        livro.setAutorId(rs.getInt("autor_id"));
        livro.setDestaque(rs.getBoolean("destaque"));
        livro.setAtivo(rs.getBoolean("ativo"));
        livro.setCategoriaNome(rs.getString("categoria_nome"));
        livro.setAutorNome(rs.getString("autor_nome"));
        livro.setMediaAvaliacoes(rs.getDouble("media_avaliacoes"));
        livro.setTotalAvaliacoes(rs.getInt("total_avaliacoes"));
        return livro;
    }
}