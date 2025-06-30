package br.com.livraria.dao;

import br.com.livraria.model.Autor;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO para operações com autores
 */
class AutorDAO {
    
    public List<Autor> listarTodos() {
        List<Autor> autores = new ArrayList<>();
        String sql = "SELECT * FROM autores ORDER BY nome";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Autor autor = new Autor();
                autor.setId(rs.getInt("id"));
                autor.setNome(rs.getString("nome"));
                autor.setBiografia(rs.getString("biografia"));
                autor.setFoto(rs.getString("foto"));
                autores.add(autor);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return autores;
    }
    
    public Autor buscarPorId(int id) {
        String sql = "SELECT * FROM autores WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Autor autor = new Autor();
                autor.setId(rs.getInt("id"));
                autor.setNome(rs.getString("nome"));
                autor.setBiografia(rs.getString("biografia"));
                autor.setFoto(rs.getString("foto"));
                return autor;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}