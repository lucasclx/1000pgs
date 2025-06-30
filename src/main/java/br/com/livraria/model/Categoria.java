package br.com.livraria.model;

/**
 * Classe Categoria - Representa as categorias de livros
 */
public class Categoria {
    private int id;
    private String nome;
    private String descricao;
    private boolean ativo;
    
    // Construtor padrão
    public Categoria() {}
    
    // Construtor com parâmetros
    public Categoria(String nome, String descricao) {
        this.nome = nome;
        this.descricao = descricao;
        this.ativo = true;
    }
    
    // Getters e Setters
    public int getId() { 
        return id; 
    }
    
    public void setId(int id) { 
        this.id = id; 
    }
    
    public String getNome() { 
        return nome; 
    }
    
    public void setNome(String nome) { 
        this.nome = nome; 
    }
    
    public String getDescricao() { 
        return descricao; 
    }
    
    public void setDescricao(String descricao) { 
        this.descricao = descricao; 
    }
    
    public boolean isAtivo() { 
        return ativo; 
    }
    
    public void setAtivo(boolean ativo) { 
        this.ativo = ativo; 
    }
    
    @Override
    public String toString() {
        return "Categoria{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", descricao='" + descricao + '\'' +
                ", ativo=" + ativo +
                '}';
    }
}