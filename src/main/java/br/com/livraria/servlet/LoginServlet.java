package br.com.livraria.servlet;

import br.com.livraria.dao.UsuarioDAO;
import br.com.livraria.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * Servlet para autenticação de usuários
 */
 @WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        
        Usuario usuario = usuarioDAO.autenticar(email, senha);
        
        if (usuario != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            session.setAttribute("usuarioId", usuario.getId());
            session.setAttribute("usuarioNome", usuario.getNome());
            session.setAttribute("isAdmin", usuario.isAdmin());
            
            response.sendRedirect(request.getContextPath() + "/");
        } else {
            request.setAttribute("erro", "Email ou senha inválidos");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        }
    }
}