package br.com.livraria.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro de autorização para área administrativa
 */
class AdminAuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Verificar se é administrador
        boolean isAdmin = (session != null && 
                          session.getAttribute("isAdmin") != null && 
                          (Boolean) session.getAttribute("isAdmin"));
        
        if (!isAdmin) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso negado");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}