package br.com.livraria.servlet;

import br.com.livraria.dao.PedidoDAO;
import br.com.livraria.model.Pedido;
import br.com.livraria.model.ItemPedido;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para detalhes de um pedido específico
 */
@WebServlet("/pedido-detalhes")
public class PedidoDetalhesServlet extends HttpServlet {
    private PedidoDAO pedidoDAO = new PedidoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String numeroPedido = request.getParameter("numero");
        
        if (numeroPedido == null || numeroPedido.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/meus-pedidos");
            return;
        }
        
        Pedido pedido = pedidoDAO.buscarPorNumero(numeroPedido);
        
        if (pedido == null) {
            request.setAttribute("erro", "Pedido não encontrado");
            request.getRequestDispatcher("/pages/erro.jsp").forward(request, response);
            return;
        }
        
        // Verificar se o pedido pertence ao usuário logado
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        if (pedido.getUsuarioId() != usuarioId) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        // Buscar itens do pedido
        List<ItemPedido> itens = pedidoDAO.listarItensPedido(pedido.getId());
        pedido.setItens(itens);
        
        request.setAttribute("pedido", pedido);
        request.getRequestDispatcher("/pages/pedido-detalhes.jsp").forward(request, response);
    }
}