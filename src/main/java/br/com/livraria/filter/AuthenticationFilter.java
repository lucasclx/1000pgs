package br.com.livraria.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filtro de autenticação para páginas protegidas
 */
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Verificar se o usuário está logado
        boolean isLoggedIn = (session != null && session.getAttribute("usuarioId") != null);
        
        if (!isLoggedIn) {
            // Salvar URL de destino para redirecionar após login
            String requestURL = httpRequest.getRequestURL().toString();
            String queryString = httpRequest.getQueryString();
            
            if (queryString != null) {
                requestURL += "?" + queryString;
            }
            
            session = httpRequest.getSession(true);
            session.setAttribute("redirectAfterLogin", requestURL);
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {}
}