package br.com.livraria.servlet;

import br.com.livraria.dao.CarrinhoDAO;
import br.com.livraria.dao.PedidoDAO;
import br.com.livraria.dao.CupomDAO;
import br.com.livraria.model.Carrinho;
import br.com.livraria.model.Cupom;
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
 * Servlet para checkout e finalização de pedidos
 */
 @WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private CarrinhoDAO carrinhoDAO = new CarrinhoDAO();
    private PedidoDAO pedidoDAO = new PedidoDAO();
    private CupomDAO cupomDAO = new CupomDAO();
    
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
        
        if (itens.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/carrinho");
            return;
        }
        
        BigDecimal total = carrinhoDAO.calcularTotal(usuarioId);
        
        request.setAttribute("itens", itens);
        request.setAttribute("total", total);
        
        request.getRequestDispatcher("/pages/checkout.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuarioId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String acao = request.getParameter("acao");
        
        if ("validar-cupom".equals(acao)) {
            validarCupom(request, response);
            return;
        }
        
        // Finalizar pedido
        int usuarioId = (Integer) session.getAttribute("usuarioId");
        String endereco = request.getParameter("endereco");
        String cidade = request.getParameter("cidade");
        String estado = request.getParameter("estado");
        String cep = request.getParameter("cep");
        String codigoCupom = request.getParameter("cupom");
        
        String enderecoCompleto = endereco + ", " + cidade + " - " + estado + ", CEP: " + cep;
        
        String numeroPedido = pedidoDAO.criarPedido(usuarioId, enderecoCompleto, codigoCupom);
        
        if (numeroPedido != null) {
            response.sendRedirect(request.getContextPath() + "/pedido-confirmado?numero=" + numeroPedido);
        } else {
            request.setAttribute("erro", "Erro ao processar pedido. Tente novamente.");
            doGet(request, response);
        }
    }
    
    private void validarCupom(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        String codigoCupom = request.getParameter("cupom");
        String valorStr = request.getParameter("valor");
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            BigDecimal valorPedido = new BigDecimal(valorStr);
            Cupom cupom = cupomDAO.buscarPorCodigo(codigoCupom);
            
            if (cupom == null) {
                out.print("{\"valido\": false, \"mensagem\": \"Cupom não encontrado\"}");
            } else if (!cupom.isValido()) {
                out.print("{\"valido\": false, \"mensagem\": \"Cupom inválido ou expirado\"}");
            } else if (valorPedido.compareTo(cupom.getValorMinimo()) < 0) {
                out.print("{\"valido\": false, \"mensagem\": \"Valor mínimo de R$ " + cupom.getValorMinimo() + " não atingido\"}");
            } else {
                BigDecimal desconto = cupom.calcularDesconto(valorPedido);
                BigDecimal novoTotal = valorPedido.subtract(desconto);
                out.print("{\"valido\": true, \"desconto\": " + desconto + ", \"novoTotal\": " + novoTotal + ", \"descricao\": \"" + cupom.getDescricao() + "\"}");
            }
        } catch (NumberFormatException e) {
            out.print("{\"valido\": false, \"mensagem\": \"Erro interno\"}");
        }
        
        out.flush();
    }
}