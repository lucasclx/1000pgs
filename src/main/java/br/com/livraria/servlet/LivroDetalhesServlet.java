package br.com.livraria.servlet;

import br.com.livraria.dao.LivroDAO;
import br.com.livraria.dao.AvaliacaoDAO;
import br.com.livraria.model.Livro;
import br.com.livraria.model.Avaliacao;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para detalhes do livro
 */
 @WebServlet("/livro")
public class LivroDetalhesServlet extends HttpServlet {
    private LivroDAO livroDAO = new LivroDAO();
    private AvaliacaoDAO avaliacaoDAO = new AvaliacaoDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        try {
            int livroId = Integer.parseInt(idStr);
            Livro livro = livroDAO.buscarPorId(livroId);
            
            if (livro == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            List<Avaliacao> avaliacoes = avaliacaoDAO.listarPorLivro(livroId);
            
            // Verifica se o usuário já comprou o livro
            HttpSession session = request.getSession(false);
            boolean podeAvaliar = false;
            if (session != null && session.getAttribute("usuarioId") != null) {
                int usuarioId = (Integer) session.getAttribute("usuarioId");
                podeAvaliar = avaliacaoDAO.usuarioComprou(usuarioId, livroId);
            }
            
            request.setAttribute("livro", livro);
            request.setAttribute("avaliacoes", avaliacoes);
            request.setAttribute("podeAvaliar", podeAvaliar);
            
            request.getRequestDispatcher("/pages/livro-detalhes.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}