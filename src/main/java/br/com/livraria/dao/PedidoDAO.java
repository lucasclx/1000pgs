package br.com.livraria.dao;

import br.com.livraria.model.Pedido;
import br.com.livraria.model.ItemPedido;
import br.com.livraria.util.ConexaoDB;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * DAO para operações com pedidos
 */
public class PedidoDAO {
    
    public String criarPedido(int usuarioId, String enderecoEntrega, String codigoCupom) {
        String sql = "CALL sp_criar_pedido(?, ?, ?, @pedido_id, @numero_pedido)";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            stmt.setString(2, enderecoEntrega);
            stmt.setString(3, codigoCupom);
            
            stmt.execute();
            
            // Buscar os valores de saída
            try (PreparedStatement selectStmt = conn.prepareStatement("SELECT @numero_pedido as numero")) {
                ResultSet rs = selectStmt.executeQuery();
                if (rs.next()) {
                    return rs.getString("numero");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Pedido> listarPorUsuario(int usuarioId) {
        List<Pedido> pedidos = new ArrayList<>();
        String sql = "SELECT * FROM vw_pedidos_completos WHERE usuario_id = ? ORDER BY data_pedido DESC";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, usuarioId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                pedidos.add(mapearPedidoCompleto(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pedidos;
    }
    
    public Pedido buscarPorNumero(String numeroPedido) {
        String sql = "SELECT * FROM vw_pedidos_completos WHERE numero_pedido = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, numeroPedido);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearPedidoCompleto(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<ItemPedido> listarItensPedido(int pedidoId) {
        List<ItemPedido> itens = new ArrayList<>();
        String sql = "SELECT ip.*, l.titulo, l.capa, a.nome as autor_nome " +
                    "FROM itens_pedido ip " +
                    "JOIN livros l ON ip.livro_id = l.id " +
                    "JOIN autores a ON l.autor_id = a.id " +
                    "WHERE ip.pedido_id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, pedidoId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                ItemPedido item = new ItemPedido();
                item.setId(rs.getInt("id"));
                item.setPedidoId(rs.getInt("pedido_id"));
                item.setLivroId(rs.getInt("livro_id"));
                item.setQuantidade(rs.getInt("quantidade"));
                item.setPrecoUnitario(rs.getBigDecimal("preco_unitario"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                item.setLivroTitulo(rs.getString("titulo"));
                item.setLivroCapa(rs.getString("capa"));
                item.setLivroAutor(rs.getString("autor_nome"));
                itens.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itens;
    }
    
    public boolean atualizarStatus(int pedidoId, String novoStatus) {
        String sql = "UPDATE pedidos SET status = ? WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, novoStatus);
            stmt.setInt(2, pedidoId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean definirCodigoRastreio(int pedidoId, String codigoRastreio) {
        String sql = "UPDATE pedidos SET codigo_rastreio = ?, status = 'enviado' WHERE id = ?";
        
        try (Connection conn = ConexaoDB.obterConexao();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, codigoRastreio);
            stmt.setInt(2, pedidoId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private Pedido mapearPedidoCompleto(ResultSet rs) throws SQLException {
        Pedido pedido = new Pedido();
        pedido.setId(rs.getInt("id"));
        pedido.setNumeroPedido(rs.getString("numero_pedido"));
        pedido.setStatus(rs.getString("status"));
        pedido.setTotal(rs.getBigDecimal("total"));
        pedido.setDesconto(rs.getBigDecimal("desconto"));
        pedido.setEnderecoEntrega(rs.getString("endereco_entrega"));
        pedido.setCodigoRastreio(rs.getString("codigo_rastreio"));
        pedido.setDataPedido(rs.getTimestamp("data_pedido").toLocalDateTime());
        pedido.setUsuarioNome(rs.getString("usuario_nome"));
        pedido.setUsuarioEmail(rs.getString("usuario_email"));
        pedido.setTotalItens(rs.getInt("total_itens"));
        return pedido;
    }
}