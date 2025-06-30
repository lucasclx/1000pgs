package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Categoria
class Categoria {
    private int id;
    private String nome;
    private String descricao;
    private boolean ativo;
    
    public Categoria() {}
    
    public Categoria(String nome, String descricao) {
        this.nome = nome;
        this.descricao = descricao;
        this.ativo = true;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
}