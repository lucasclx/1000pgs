package br.com.livraria.listener;

import br.com.livraria.util.ConexaoDB;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

 @WebListener
public class ApplicationListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== Inicializando E-commerce Livraria ===");
        
        // Testar conexão com banco de dados
        if (ConexaoDB.testarConexao()) {
            System.out.println("✓ Conexão com banco de dados estabelecida");
        } else {
            System.err.println("✗ Erro ao conectar com banco de dados");
        }
        
        // Configurar timezone
        System.setProperty("user.timezone", "America/Sao_Paulo");
        
        System.out.println("=== E-commerce Livraria inicializado com sucesso ===");
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== Finalizando E-commerce Livraria ===");
    }
}