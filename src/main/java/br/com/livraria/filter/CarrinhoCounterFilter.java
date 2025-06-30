package br.com.livraria.filter;

import br.com.livraria.dao.CarrinhoDAO;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro para atualizar contador do carrinho
 */
public class CarrinhoCounterFilter implements Filter {
    private CarrinhoDAO carrinhoDAO = new CarrinhoDAO();
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession(false);
        
        // Se usuário está logado, atualizar contador do carrinho
        if (session != null && session.getAttribute("usuarioId") != null) {
            Integer usuarioId = (Integer) session.getAttribute("usuarioId");
            Integer contadorAtual = (Integer) session.getAttribute("totalItensCarrinho");
            
            // Atualizar apenas se não existe ou periodicamente
            if (contadorAtual == null) {
                int totalItens = carrinhoDAO.contarItens(usuarioId);
                session.setAttribute("totalItensCarrinho", totalItens);
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}