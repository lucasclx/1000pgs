package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Avaliacao
class Avaliacao {
    private int id;
    private int livroId;
    private int usuarioId;
    private int nota;
    private String comentario;
    private boolean aprovado;
    private LocalDateTime dataAvaliacao;
    
    // Campos relacionados
    private String usuarioNome;
    private String livroTitulo;
    
    public Avaliacao() {}
    
    public Avaliacao(int livroId, int usuarioId, int nota, String comentario) {
        this.livroId = livroId;
        this.usuarioId = usuarioId;
        this.nota = nota;
        this.comentario = comentario;
        this.aprovado = false;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getLivroId() { return livroId; }
    public void setLivroId(int livroId) { this.livroId = livroId; }
    
    public int getUsuarioId() { return usuarioId; }
    public void setUsuarioId(int usuarioId) { this.usuarioId = usuarioId; }
    
    public int getNota() { return nota; }
    public void setNota(int nota) { this.nota = nota; }
    
    public String getComentario() { return comentario; }
    public void setComentario(String comentario) { this.comentario = comentario; }
    
    public boolean isAprovado() { return aprovado; }
    public void setAprovado(boolean aprovado) { this.aprovado = aprovado; }
    
    public LocalDateTime getDataAvaliacao() { return dataAvaliacao; }
    public void setDataAvaliacao(LocalDateTime dataAvaliacao) { this.dataAvaliacao = dataAvaliacao; }
    
    public String getUsuarioNome() { return usuarioNome; }
    public void setUsuarioNome(String usuarioNome) { this.usuarioNome = usuarioNome; }
    
    public String getLivroTitulo() { return livroTitulo; }
    public void setLivroTitulo(String livroTitulo) { this.livroTitulo = livroTitulo; }
}