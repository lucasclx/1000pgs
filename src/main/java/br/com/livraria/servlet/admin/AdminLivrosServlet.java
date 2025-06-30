package br.com.livraria.servlet.admin;

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
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.io.File;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder; // Importação adicionada
import com.google.gson.TypeAdapter; // Importação adicionada
import com.google.gson.stream.JsonReader; // Importação adicionada
import com.google.gson.stream.JsonWriter; // Importação adicionada
import com.google.gson.stream.JsonToken; // Importação adicionada
import java.time.LocalDateTime; // Importação adicionada

/**
 * Servlet para administração de livros
 */
@WebServlet({"/admin/livros", "/admin/livros/*"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AdminLivrosServlet extends HttpServlet {
    private LivroDAO livroDAO = new LivroDAO();
    private CategoriaDAO categoriaDAO = new CategoriaDAO();
    private AutorDAO autorDAO = new AutorDAO();
    private Gson gson; // Alterado para não inicializar aqui

    // Construtor adicionado para configurar o Gson
    public AdminLivrosServlet() {
        GsonBuilder gsonBuilder = new GsonBuilder();
        // Registra um TypeAdapter para LocalDateTime para lidar com a serialização/desserialização
        gsonBuilder.registerTypeAdapter(LocalDateTime.class, new TypeAdapter<LocalDateTime>() {
            @Override
            public void write(JsonWriter out, LocalDateTime value) throws IOException {
                if (value == null) {
                    out.nullValue();
                } else {
                    out.value(value.toString()); // Converte LocalDateTime para String para JSON
                }
            }

            @Override
            public LocalDateTime read(JsonReader in) throws IOException {
                if (in.peek() == JsonToken.NULL) {
                    in.nextNull();
                    return null;
                }
                return LocalDateTime.parse(in.nextString()); // Converte String de JSON para LocalDateTime
            }
        });
        this.gson = gsonBuilder.create();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Verificar se é admin
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null && pathInfo.equals("/buscar")) {
            buscarLivro(request, response);
            return;
        }
        
        // Parâmetros de filtro
        String busca = request.getParameter("busca");
        String categoriaIdStr = request.getParameter("categoria");
        String status = request.getParameter("status");
        
        Integer categoriaId = null;
        if (categoriaIdStr != null && !categoriaIdStr.isEmpty()) {
            try {
                categoriaId = Integer.parseInt(categoriaIdStr);
            } catch (NumberFormatException e) {
                // Ignora erro
            }
        }
        
        // Buscar livros com filtros
        List<Livro> livros = livroDAO.buscar(busca, categoriaId, null);
        
        // Aplicar filtro de status
        if (status != null && !status.isEmpty()) {
            livros = livros.stream()
                .filter(livro -> {
                    switch (status) {
                        case "ativo":
                            return livro.isAtivo();
                        case "inativo":
                            return !livro.isAtivo();
                        case "destaque":
                            return livro.isDestaque();
                        case "esgotado":
                            return livro.getEstoque() == 0;
                        default:
                            return true;
                    }
                })
                .collect(java.util.stream.Collectors.toList());
        }
        
        // Carregar dados auxiliares
        List<Categoria> categorias = categoriaDAO.listarTodas();
        List<Autor> autores = autorDAO.listarTodos();
        
        // Calcular estatísticas
        int totalLivros = livros.size();
        int livrosAtivos = (int) livros.stream().filter(Livro::isAtivo).count();
        int livrosDestaque = (int) livros.stream().filter(Livro::isDestaque).count();
        int livrosEsgotados = (int) livros.stream().filter(l -> l.getEstoque() == 0).count();
        
        // Definir atributos
        request.setAttribute("livros", livros);
        request.setAttribute("categorias", categorias);
        request.setAttribute("autores", autores);
        request.setAttribute("totalLivros", totalLivros);
        request.setAttribute("livrosAtivos", livrosAtivos);
        request.setAttribute("livrosDestaque", livrosDestaque);
        request.setAttribute("livrosEsgotados", livrosEsgotados);
        
        request.getRequestDispatcher("/pages/admin/livros.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo != null) {
            switch (pathInfo) {
                case "/adicionar":
                    adicionarLivro(request, response);
                    break;
                case "/editar":
                    editarLivro(request, response);
                    break;
                case "/excluir":
                    excluirLivro(request, response);
                    break;
                case "/toggle-destaque":
                    toggleDestaque(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    
    private void buscarLivro(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String idStr = request.getParameter("id");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            int id = Integer.parseInt(idStr);
            Livro livro = livroDAO.buscarPorId(id);
            
            if (livro != null) {
                out.print(gson.toJson(livro));
            } else {
                out.print("{\"erro\": \"Livro não encontrado\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"erro\": \"ID inválido\"}");
        }
        
        out.flush();
    }
    
    private void adicionarLivro(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            Livro livro = extrairDadosLivro(request);
            
            if (livroDAO.cadastrar(livro)) {
                out.print("{\"sucesso\": true, \"mensagem\": \"Livro adicionado com sucesso!\"}");
            } else {
                out.print("{\"sucesso\": false, \"mensagem\": \"Erro ao adicionar livro\"}");
            }
        } catch (Exception e) {
            out.print("{\"sucesso\": false, \"mensagem\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    private void editarLivro(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            Livro livro = extrairDadosLivro(request);
            String idStr = request.getParameter("id");
            
            if (idStr != null && !idStr.isEmpty()) {
                livro.setId(Integer.parseInt(idStr));
                
                if (livroDAO.atualizar(livro)) {
                    out.print("{\"sucesso\": true, \"mensagem\": \"Livro atualizado com sucesso!\"}");
                } else {
                    out.print("{\"sucesso\": false, \"mensagem\": \"Erro ao atualizar livro\"}");
                }
            } else {
                out.print("{\"sucesso\": false, \"mensagem\": \"ID do livro não fornecido\"}");
            }
        } catch (Exception e) {
            out.print("{\"sucesso\": false, \"mensagem\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    private void excluirLivro(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idStr = request.getParameter("id");
            int id = Integer.parseInt(idStr);
            
            // Em vez de excluir, marcar como inativo
            Livro livro = livroDAO.buscarPorId(id);
            if (livro != null) {
                livro.setAtivo(false);
                if (livroDAO.atualizar(livro)) {
                    out.print("{\"sucesso\": true, \"mensagem\": \"Livro removido com sucesso!\"}");
                } else {
                    out.print("{\"sucesso\": false, \"mensagem\": \"Erro ao remover livro\"}");
                }
            } else {
                out.print("{\"sucesso\": false, \"mensagem\": \"Livro não encontrado\"}");
            }
        } catch (Exception e) {
            out.print("{\"sucesso\": false, \"mensagem\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    private void toggleDestaque(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String idStr = request.getParameter("id");
            String destaqueStr = request.getParameter("destaque");
            
            int id = Integer.parseInt(idStr);
            boolean destaque = Boolean.parseBoolean(destaqueStr);
            
            Livro livro = livroDAO.buscarPorId(id);
            if (livro != null) {
                livro.setDestaque(destaque);
                if (livroDAO.atualizar(livro)) {
                    out.print("{\"sucesso\": true}");
                } else {
                    out.print("{\"sucesso\": false, \"mensagem\": \"Erro ao atualizar status\"}");
                }
            } else {
                out.print("{\"sucesso\": false, \"mensagem\": \"Livro não encontrado\"}");
            }
        } catch (Exception e) {
            out.print("{\"sucesso\": false, \"mensagem\": \"" + e.getMessage() + "\"}");
        }
        
        out.flush();
    }
    
    private Livro extrairDadosLivro(HttpServletRequest request) throws ServletException, IOException {
        Livro livro = new Livro();
        
        // Dados básicos
        livro.setTitulo(request.getParameter("titulo"));
        livro.setDescricao(request.getParameter("descricao"));
        livro.setIsbn(request.getParameter("isbn"));
        livro.setEditora(request.getParameter("editora"));
        
        // IDs de relacionamento
        livro.setAutorId(Integer.parseInt(request.getParameter("autorId")));
        livro.setCategoriaId(Integer.parseInt(request.getParameter("categoriaId")));
        
        // Valores numéricos
        livro.setPreco(new BigDecimal(request.getParameter("preco")));
        
        String precoPromocionalStr = request.getParameter("precoPromocional");
        if (precoPromocionalStr != null && !precoPromocionalStr.isEmpty()) {
            livro.setPrecoPromocional(new BigDecimal(precoPromocionalStr));
        }
        
        livro.setEstoque(Integer.parseInt(request.getParameter("estoque")));
        
        String paginasStr = request.getParameter("paginas");
        if (paginasStr != null && !paginasStr.isEmpty()) {
            livro.setPaginas(Integer.parseInt(paginasStr));
        }
        
        String anoStr = request.getParameter("anoPublicacao");
        if (anoStr != null && !anoStr.isEmpty()) {
            livro.setAnoPublicacao(Integer.parseInt(anoStr));
        }
        
        // Checkboxes
        livro.setAtivo(request.getParameter("ativo") != null);
        livro.setDestaque(request.getParameter("destaque") != null);
        
        // Processar imagem
        String capaUrl = request.getParameter("capaUrl");
        if (capaUrl != null && !capaUrl.isEmpty()) {
            livro.setCapa(capaUrl);
        } else {
            // Processar upload de arquivo
            Part filePart = request.getPart("capa");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "img" + File.separator + "livros";
                
                // Criar diretório se não existir
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Gerar nome único para o arquivo
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;
                String filePath = uploadPath + File.separator + uniqueFileName;
                
                // Salvar arquivo
                filePart.write(filePath);
                
                // Definir URL relativa da imagem
                livro.setCapa(request.getContextPath() + "/img/livros/" + uniqueFileName);
            }
        }
        
        return livro;
    }
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && 
               session.getAttribute("isAdmin") != null && 
               (Boolean) session.getAttribute("isAdmin");
    }
}