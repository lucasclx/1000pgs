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
            switch (acao) {
                case "adicionar":
                    adicionarItem(request, response, out, usuarioId);
                    break;
                    
                case "atualizar":
                    atualizarItem(request, response, out, usuarioId);
                    break;
                    
                case "remover":
                    removerItem(request, response, out, usuarioId);
                    break;
                    
                case "contar":
                    contarItens(request, response, out, usuarioId);
                    break;
                    
                default:
                    out.print("{\"erro\": \"Ação inválida\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"Parâmetros inválidos\"}");
        }
        
        out.flush();
    }
    
    private void adicionarItem(HttpServletRequest request, HttpServletResponse response, 
                              PrintWriter out, int usuarioId) {
        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));
            
            boolean sucesso = carrinhoDAO.adicionarItem(usuarioId, livroId, quantidade);
            BigDecimal novoTotal = carrinhoDAO.calcularTotal(usuarioId);
            int totalItens = carrinhoDAO.contarItens(usuarioId);
            
            out.print("{\"sucesso\": " + sucesso + 
                     ", \"novoTotal\": " + novoTotal + 
                     ", \"totalItens\": " + totalItens + "}");
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"Parâmetros inválidos\"}");
        }
    }
    
    private void atualizarItem(HttpServletRequest request, HttpServletResponse response, 
                              PrintWriter out, int usuarioId) {
        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            int quantidade = Integer.parseInt(request.getParameter("quantidade"));
            
            boolean sucesso = carrinhoDAO.atualizarQuantidade(usuarioId, livroId, quantidade);
            BigDecimal novoTotal = carrinhoDAO.calcularTotal(usuarioId);
            int totalItens = carrinhoDAO.contarItens(usuarioId);
            
            out.print("{\"sucesso\": " + sucesso + 
                     ", \"novoTotal\": " + novoTotal + 
                     ", \"totalItens\": " + totalItens + "}");
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"Parâmetros inválidos\"}");
        }
    }
    
    private void removerItem(HttpServletRequest request, HttpServletResponse response, 
                            PrintWriter out, int usuarioId) {
        try {
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            
            boolean sucesso = carrinhoDAO.removerItem(usuarioId, livroId);
            BigDecimal novoTotal = carrinhoDAO.calcularTotal(usuarioId);
            int totalItens = carrinhoDAO.contarItens(usuarioId);
            
            out.print("{\"sucesso\": " + sucesso + 
                     ", \"novoTotal\": " + novoTotal + 
                     ", \"totalItens\": " + totalItens + "}");
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"Parâmetros inválidos\"}");
        }
    }
    
    private void contarItens(HttpServletRequest request, HttpServletResponse response, 
                            PrintWriter out, int usuarioId) {
        int totalItens = carrinhoDAO.contarItens(usuarioId);
        out.print("{\"totalItens\": " + totalItens + "}");
    }
}