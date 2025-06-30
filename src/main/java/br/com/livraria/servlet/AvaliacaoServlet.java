package br.com.livraria.servlet;

import br.com.livraria.dao.AvaliacaoDAO;
import br.com.livraria.model.Avaliacao;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet para avaliações
 */
 @WebServlet("/avaliar")
public class AvaliacaoServlet extends HttpServlet {
    private AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int usuarioId = (Integer) session.getAttribute("usuarioId");
            int livroId = Integer.parseInt(request.getParameter("livroId"));
            int nota = Integer.parseInt(request.getParameter("nota"));
            String comentario = request.getParameter("comentario");
            
            // Verifica se o usuário comprou o livro
            if (!avaliacaoDAO.usuarioComprou(usuarioId, livroId)) {
                out.print("{\"sucesso\": false, \"mensagem\": \"Você precisa comprar o livro para avaliá-lo\"}");
                out.flush();
                return;
            }
            
            Avaliacao avaliacao = new Avaliacao(livroId, usuarioId, nota, comentario);
            boolean sucesso = avaliacaoDAO.criarAvaliacao(avaliacao);
            
            if (sucesso) {
                out.print("{\"sucesso\": true, \"mensagem\": \"Avaliação enviada com sucesso! Será analisada antes da publicação.\"}");
            } else {
                out.print("{\"sucesso\": false, \"mensagem\": \"Erro ao enviar avaliação. Você já pode ter avaliado este livro.\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"sucesso\": false, \"mensagem\": \"Dados inválidos\"}");
        }
        
        out.flush();
    }
}