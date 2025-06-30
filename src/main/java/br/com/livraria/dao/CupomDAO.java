package br.com.livraria.dao;

import br.com.livraria.model.Cupom;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.math.BigDecimal;

/**
 * DAO para operações com cupons
 */
public class CupomDAO {
    
    public Cupom buscarPorCodigo(String codigo) {
        String sql = "SELECT * FROM cupons WHERE codigo = ? AND ativo = TRUE";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, codigo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                Cupom cupom = new Cupom();
                cupom.setId(rs.getInt("id"));
                cupom.setCodigo(rs.getString("codigo"));
                cupom.setDescricao(rs.getString("descricao"));
                cupom.setTipo(rs.getString("tipo"));
                cupom.setValor(rs.getBigDecimal("valor"));
                cupom.setValorMinimo(rs.getBigDecimal("valor_minimo"));
                cupom.setUsosLimite(rs.getInt("usos_limite"));
                cupom.setUsosRealizados(rs.getInt("usos_realizados"));
                cupom.setAtivo(rs.getBoolean("ativo"));
                return cupom;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}