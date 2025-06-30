package br.com.livraria.servlet;

import br.com.livraria.dao.CarrinhoDAO;
import br.com.livraria.model.Carrinho;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.math.BigDecimal;

/**
 * Servlet para operações do carrinho
 */
 @WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {
    private CarrinhoDAO carrinhoDAO = new CarrinhoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        List<Carrinho> itens = carrinhoDAO.listarItens(usuarioId);
        BigDecimal total = carrinhoDAO.calcularTotal(usuarioId);
        
        request.setAttribute("itens", itens);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/pages/carrinho.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        String acao = request.getParameter("acao");
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int livroId;
            int quantidade;
            boolean sucesso;
            BigDecimal novoTotal;
            int totalItens;

            switch (acao) {
                case "adicionar":
                    livroId = Integer.parseInt(request.getParameter("livroId"));
                    quantidade = Integer.parseInt(request.getParameter("quantidade"));
                    
                    sucesso = carrinhoDAO.adicionarItem(usuarioId, livroId, quantidade);
                    novoTotal = carrinhoDAO.calcularTotal(usuarioId);
                    totalItens = carrinhoDAO.contarItens(usuarioId);
                    
                    out.print("{\"sucesso\": " + sucesso + ", \"novoTotal\": " + novoTotal + ", \"totalItens\": " + totalItens + "}");
                    break;
                    
                case "atualizar":
                    livroId = Integer.parseInt(request.getParameter("livroId"));
                    quantidade = Integer.parseInt(request.getParameter("quantidade"));
                    
                    sucesso = carrinhoDAO.atualizarQuantidade(usuarioId, livroId, quantidade);
                    novoTotal = carrinhoDAO.calcularTotal(usuarioId);
                    
                    out.print("{\"sucesso\": " + sucesso + ", \"novoTotal\": " + novoTotal + "}");
                    break;
                    
                case "remover":
                    livroId = Integer.parseInt(request.getParameter("livroId"));
                    
                    sucesso = carrinhoDAO.removerItem(usuarioId, livroId);
                    novoTotal = carrinhoDAO.calcularTotal(usuarioId);
                    totalItens = carrinhoDAO.contarItens(usuarioId);
                    
                    out.print("{\"sucesso\": " + sucesso + ", \"novoTotal\": " + novoTotal + ", \"totalItens\": " + totalItens + "}");
                    break;
                    
                default:
                    out.print("{\"erro\": \"Ação inválida\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"Parâmetros inválidos\"}");
        }
        
        out.flush();
    }
}