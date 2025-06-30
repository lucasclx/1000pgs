package br.com.livraria.servlet;

import br.com.livraria.dao.PedidoDAO;
import br.com.livraria.model.Pedido;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para histórico de pedidos
 */
 @WebServlet("/meus-pedidos")
public class MeusPedidosServlet extends HttpServlet {
    private PedidoDAO pedidoDAO = new PedidoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        List<Pedido> pedidos = pedidoDAO.listarPorUsuario(usuarioId);
        
        request.setAttribute("pedidos", pedidos);
        request.getRequestDispatcher("/pages/meus-pedidos.jsp").forward(request, response);
    }
}