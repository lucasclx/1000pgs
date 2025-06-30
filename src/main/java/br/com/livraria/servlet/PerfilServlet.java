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
 * Servlet para área do usuário
 */
 @WebServlet("/perfil")
public class PerfilServlet extends HttpServlet {
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("/pages/perfil.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        String acao = request.getParameter("acao");
        
        if ("atualizar-dados".equals(acao)) {
            Usuario usuario = usuarioDAO.buscarPorId(usuarioId);
            usuario.setNome(request.getParameter("nome"));
            usuario.setTelefone(request.getParameter("telefone"));
            usuario.setEndereco(request.getParameter("endereco"));
            usuario.setCidade(request.getParameter("cidade"));
            usuario.setEstado(request.getParameter("estado"));
            usuario.setCep(request.getParameter("cep"));
            
            if (usuarioDAO.atualizar(usuario)) {
                session.setAttribute("usuarioNome", usuario.getNome());
                request.setAttribute("sucesso", "Dados atualizados com sucesso!");
            } else {
                request.setAttribute("erro", "Erro ao atualizar dados.");
            }
        } else if ("alterar-senha".equals(acao)) {
            String senhaAtual = request.getParameter("senhaAtual");
            String novaSenha = request.getParameter("novaSenha");
            String confirmarSenha = request.getParameter("confirmarSenha");
            
            Usuario usuario = usuarioDAO.buscarPorId(usuarioId);
            
            // Verificar senha atual
            if (usuarioDAO.autenticar(usuario.getEmail(), senhaAtual) == null) {
                request.setAttribute("erro", "Senha atual incorreta.");
            } else if (!novaSenha.equals(confirmarSenha)) {
                request.setAttribute("erro", "Nova senha e confirmação não coincidem.");
            } else if (usuarioDAO.alterarSenha(usuarioId, novaSenha)) {
                request.setAttribute("sucesso", "Senha alterada com sucesso!");
            } else {
                request.setAttribute("erro", "Erro ao alterar senha.");
            }
        }
        
        doGet(request, response);
    }
}