package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe ItemPedido
public class ItemPedido {
    private int id;
    private int pedidoId;
    private int livroId;
    private int quantidade;
    private BigDecimal precoUnitario;
    private BigDecimal subtotal;
    
    // Campos relacionados
    private String livroTitulo;
    private String livroAutor;
    private String livroCapa;
    
    public ItemPedido() {}
    
    public ItemPedido(int livroId, int quantidade, BigDecimal precoUnitario) {
        this.livroId = livroId;
        this.quantidade = quantidade;
        this.precoUnitario = precoUnitario;
        this.subtotal = precoUnitario.multiply(BigDecimal.valueOf(quantidade));
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getPedidoId() { return pedidoId; }
    public void setPedidoId(int pedidoId) { this.pedidoId = pedidoId; }
    
    public int getLivroId() { return livroId; }
    public void setLivroId(int livroId) { this.livroId = livroId; }
    
    public int getQuantidade() { return quantidade; }
    public void setQuantidade(int quantidade) { this.quantidade = quantidade; }
    
    public BigDecimal getPrecoUnitario() { return precoUnitario; }
    public void setPrecoUnitario(BigDecimal precoUnitario) { this.precoUnitario = precoUnitario; }
    
    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }
    
    public String getLivroTitulo() { return livroTitulo; }
    public void setLivroTitulo(String livroTitulo) { this.livroTitulo = livroTitulo; }
    
    public String getLivroAutor() { return livroAutor; }
    public void setLivroAutor(String livroAutor) { this.livroAutor = livroAutor; }
    
    public String getLivroCapa() { return livroCapa; }
    public void setLivroCapa(String livroCapa) { this.livroCapa = livroCapa; }
}