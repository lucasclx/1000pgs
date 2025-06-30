package br.com.livraria.dao;

import br.com.livraria.model.Categoria;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com categorias
 */
class CategoriaDAO {
    
    public List<Categoria> listarTodas() {
        List<Categoria> categorias = new ArrayList<>();
        String sql = "SELECT * FROM categorias WHERE ativo = TRUE ORDER BY nome";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Categoria categoria = new Categoria();
                categoria.setId(rs.getInt("id"));
                categoria.setNome(rs.getString("nome"));
                categoria.setDescricao(rs.getString("descricao"));
                categoria.setAtivo(rs.getBoolean("ativo"));
                categorias.add(categoria);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorias;
    }
    
    public Categoria buscarPorId(int id) {
        String sql = "SELECT * FROM categorias WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Categoria categoria = new Categoria();
                categoria.setId(rs.getInt("id"));
                categoria.setNome(rs.getString("nome"));
                categoria.setDescricao(rs.getString("descricao"));
                categoria.setAtivo(rs.getBoolean("ativo"));
                return categoria;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}