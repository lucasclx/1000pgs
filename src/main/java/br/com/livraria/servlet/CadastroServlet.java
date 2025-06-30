package br.com.livraria.servlet;

import br.com.livraria.dao.UsuarioDAO;
import br.com.livraria.model.Usuario;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

/**
 * Servlet para cadastro de usuários
 */
 @WebServlet("/cadastro")
public class CadastroServlet extends HttpServlet {
    private UsuarioDAO usuarioDAO = new UsuarioDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");
        String confirmarSenha = request.getParameter("confirmarSenha");
        String telefone = request.getParameter("telefone");
        String endereco = request.getParameter("endereco");
        String cidade = request.getParameter("cidade");
        String estado = request.getParameter("estado");
        String cep = request.getParameter("cep");
        
        // Validações
        if (!senha.equals(confirmarSenha)) {
            request.setAttribute("erro", "As senhas não coincidem");
            request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
            return;
        }
        
        if (usuarioDAO.buscarPorEmail(email) != null) {
            request.setAttribute("erro", "Já existe um usuário cadastrado com este email");
            request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
            return;
        }
        
        Usuario usuario = new Usuario(nome, email, senha);
        usuario.setTelefone(telefone);
        usuario.setEndereco(endereco);
        usuario.setCidade(cidade);
        usuario.setEstado(estado);
        usuario.setCep(cep);
        
        if (usuarioDAO.cadastrar(usuario)) {
            request.setAttribute("sucesso", "Cadastro realizado com sucesso! Faça login para continuar.");
            request.getRequestDispatcher("/pages/login.jsp").forward(request, response);
        } else {
            request.setAttribute("erro", "Erro ao realizar cadastro. Tente novamente.");
            request.getRequestDispatcher("/pages/cadastro.jsp").forward(request, response);
        }
    }
}