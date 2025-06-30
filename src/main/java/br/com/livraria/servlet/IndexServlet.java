package br.com.livraria.servlet;

import br.com.livraria.dao.LivroDAO;
import br.com.livraria.dao.CategoriaDAO;
import br.com.livraria.model.Livro;
import br.com.livraria.model.Categoria;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.util.List;

/**
 * Servlet para página inicial
 */
 @WebServlet("")
public class IndexServlet extends HttpServlet {
    private LivroDAO livroDAO = new LivroDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Livro> livrosDestaque = livroDAO.listarDestaques();
        List<Categoria> categorias = categoriaDAO.listarTodas();
        
        request.setAttribute("livrosDestaque", livrosDestaque);
        request.setAttribute("categorias", categorias);
        
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}