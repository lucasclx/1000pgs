package br.com.livraria.servlet;

import br.com.livraria.dao.LivroDAO;
import br.com.livraria.dao.CategoriaDAO;
import br.com.livraria.dao.AutorDAO;
import br.com.livraria.model.Livro;
import br.com.livraria.model.Categoria;
import br.com.livraria.model.Autor;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import com.google.gson.Gson;

/**
 * Servlet para listagem e busca de livros
 */
 @WebServlet("/livros")
public class LivrosServlet extends HttpServlet {
    private LivroDAO livroDAO = new LivroDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private AutorDAO autorDAO = new AutorDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String termo = request.getParameter("busca");
        String categoriaIdStr = request.getParameter("categoria");
        String autorIdStr = request.getParameter("autor");
        String ajax = request.getParameter("ajax");
        
        Integer categoriaId = null;
        Integer autorId = null;
        
        try {
            if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
                categoriaId = Integer.parseInt(categoriaIdStr);
            }
            if (autorIdStr != null && !autorIdStr.isEmpty()) {
                autorId = Integer.parseInt(autorIdStr);
            }
        } catch (NumberFormatException e) {
            // Ignora erros de conversão
        }
        
        List<Livro> livros;
        if (termo != null || categoriaId != null || autorId != null) {
            livros = livroDAO.buscar(termo, categoriaId, autorId);
        } else {
            livros = livroDAO.listarTodos();
        }
        
        // Se for uma requisição AJAX, retorna apenas os livros em JSON
        if ("true".equals(ajax)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            out.print(gson.toJson(livros));
            out.flush();
            return;
        }
        
        // Carrega dados para os filtros
        List<Categoria> categorias = categoriaDAO.listarTodas();
        List<Autor> autores = autorDAO.listarTodos();
        
        request.setAttribute("livros", livros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("autores", autores);
        request.setAttribute("termoBusca", termo);
        request.setAttribute("categoriaId", categoriaId);
        request.setAttribute("autorId", autorId);
        
        request.getRequestDispatcher("/pages/livros.jsp").forward(request, response);
    }
}