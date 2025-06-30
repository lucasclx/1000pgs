package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Livro
class Livro {
    private int id;
    private String titulo;
    private String descricao;
    private String isbn;
    private BigDecimal preco;
    private BigDecimal precoPromocional;
    private int estoque;
    private int paginas;
    private int anoPublicacao;
    private String editora;
    private String capa;
    private int categoriaId;
    private int autorId;
    private boolean destaque;
    private boolean ativo;
    private LocalDateTime dataCadastro;
    
    // Campos relacionados (para views)
    private String categoriaNome;
    private String autorNome;
    private double mediaAvaliacoes;
    private int totalAvaliacoes;
    
    public Livro() {}
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public BigDecimal getPreco() { return preco; }
    public void setPreco(BigDecimal preco) { this.preco = preco; }
    
    public BigDecimal getPrecoPromocional() { return precoPromocional; }
    public void setPrecoPromocional(BigDecimal precoPromocional) { this.precoPromocional = precoPromocional; }
    
    public int getEstoque() { return estoque; }
    public void setEstoque(int estoque) { this.estoque = estoque; }
    
    public int getPaginas() { return paginas; }
    public void setPaginas(int paginas) { this.paginas = paginas; }
    
    public int getAnoPublicacao() { return anoPublicacao; }
    public void setAnoPublicacao(int anoPublicacao) { this.anoPublicacao = anoPublicacao; }
    
    public String getEditora() { return editora; }
    public void setEditora(String editora) { this.editora = editora; }
    
    public String getCapa() { return capa; }
    public void setCapa(String capa) { this.capa = capa; }
    
    public int getCategoriaId() { return categoriaId; }
    public void setCategoriaId(int categoriaId) { this.categoriaId = categoriaId; }
    
    public int getAutorId() { return autorId; }
    public void setAutorId(int autorId) { this.autorId = autorId; }
    
    public boolean isDestaque() { return destaque; }
    public void setDestaque(boolean destaque) { this.destaque = destaque; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    
    public LocalDateTime getDataCadastro() { return dataCadastro; }
    public void setDataCadastro(LocalDateTime dataCadastro) { this.dataCadastro = dataCadastro; }
    
    public String getCategoriaNome() { return categoriaNome; }
    public void setCategoriaNome(String categoriaNome) { this.categoriaNome = categoriaNome; }
    
    public String getAutorNome() { return autorNome; }
    public void setAutorNome(String autorNome) { this.autorNome = autorNome; }
    
    public double getMediaAvaliacoes() { return mediaAvaliacoes; }
    public void setMediaAvaliacoes(double mediaAvaliacoes) { this.mediaAvaliacoes = mediaAvaliacoes; }
    
    public int getTotalAvaliacoes() { return totalAvaliacoes; }
    public void setTotalAvaliacoes(int totalAvaliacoes) { this.totalAvaliacoes = totalAvaliacoes; }
    
    public BigDecimal getPrecoFinal() {
        return precoPromocional != null ? precoPromocional : preco;
    }
    
    public boolean temPromocao() {
        return precoPromocional != null && precoPromocional.compareTo(preco) < 0;
    }
    
    public boolean temEstoque() {
        return estoque > 0;
    }
}