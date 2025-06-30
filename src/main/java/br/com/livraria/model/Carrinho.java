package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Carrinho
class Carrinho {
    private int id;
    private int usuarioId;
    private int livroId;
    private int quantidade;
    private LocalDateTime dataAdicao;
    
    // Campos relacionados
    private String livroTitulo;
    private String livroAutor;
    private String livroCapa;
    private BigDecimal livroPreco;
    private BigDecimal livroPrecoPromocional;
    private int livroEstoque;
    
    public Carrinho() {}
    
    public Carrinho(int usuarioId, int livroId, int quantidade) {
        this.usuarioId = usuarioId;
        this.livroId = livroId;
        this.quantidade = quantidade;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    
    public int getLivroId() { return livroId; }
    public void setLivroId(int livroId) { this.livroId = livroId; }
    
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    
    public LocalDateTime getDataAdicao() { return dataAdicao; }
    public void setDataAdicao(LocalDateTime dataAdicao) { this.dataAdicao = dataAdicao; }
    
    public String getLivroTitulo() { return livroTitulo; }
    public void setLivroTitulo(String livroTitulo) { this.livroTitulo = livroTitulo; }
    
    public String getLivroAutor() { return livroAutor; }
    public void setLivroAutor(String livroAutor) { this.livroAutor = livroAutor; }
    
    public String getLivroCapa() { return livroCapa; }
    public void setLivroCapa(String livroCapa) { this.livroCapa = livroCapa; }
    
    public BigDecimal getLivroPreco() { return livroPreco; }
    public void setLivroPreco(BigDecimal livroPreco) { this.livroPreco = livroPreco; }
    
    public BigDecimal getLivroPrecoPromocional() { return livroPrecoPromocional; }
    public void setLivroPrecoPromocional(BigDecimal livroPrecoPromocional) { this.livroPrecoPromocional = livroPrecoPromocional; }
    
    public int getLivroEstoque() { return livroEstoque; }
    public void setLivroEstoque(int livroEstoque) { this.livroEstoque = livroEstoque; }
    
    public BigDecimal getPrecoFinal() {
        return livroPrecoPromocional != null ? livroPrecoPromocional : livroPreco;
    }
    
    public BigDecimal getSubtotal() {
        return getPrecoFinal().multiply(BigDecimal.valueOf(quantidade));
    }
}