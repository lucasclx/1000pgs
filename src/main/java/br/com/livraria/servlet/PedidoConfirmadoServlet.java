package br.com.livraria.servlet;

import br.com.livraria.dao.PedidoDAO;
import br.com.livraria.model.Pedido;
import br.com.livraria.model.ItemPedido;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para confirmação de pedido
 */
 @WebServlet("/pedido-confirmado")
public class PedidoConfirmadoServlet extends HttpServlet {
    private PedidoDAO pedidoDAO = new PedidoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String numeroPedido = request.getParameter("numero");
        
        if (numeroPedido == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        Pedido pedido = pedidoDAO.buscarPorNumero(numeroPedido);
        if (pedido == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }
        
        List<ItemPedido> itens = pedidoDAO.listarItensPedido(pedido.getId());
        pedido.setItens(itens);
        
        // Gerar código de rastreio simulado
        String codigoRastreio = "BR" + System.currentTimeMillis() % 1000000000L + "BR";
        pedidoDAO.definirCodigoRastreio(pedido.getId(), codigoRastreio);
        pedido.setCodigoRastreio(codigoRastreio);
        
        request.setAttribute("pedido", pedido);
        request.getRequestDispatcher("/pages/pedido-confirmado.jsp").forward(request, response);
    }
}