package br.com.livraria.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet para detalhes de um pedido específico
 */
public class PedidoDetalhesServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        String numeroPedido = request.getParameter("numero");
        
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Detalhes do Pedido</title>");
        out.println("</head>");
        out.println("<body>");
        out.println("<h1>Detalhes do Pedido</h1>");
        
        if (numeroPedido != null) {
            out.println("<p>Número do Pedido: " + numeroPedido + "</p>");
        } else {
            out.println("<p>Nenhum número de pedido fornecido</p>");
        }
        
        out.println("<p><a href='" + request.getContextPath() + "/'>Voltar ao início</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
}