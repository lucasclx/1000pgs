package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Autor
class Autor {
    private int id;
    private String nome;
    private String biografia;
    private String foto;
    
    public Autor() {}
    
    public Autor(String nome, String biografia) {
        this.nome = nome;
        this.biografia = biografia;
    }
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }
    
    public String getBiografia() { return biografia; }
    public void setBiografia(String biografia) { this.biografia = biografia; }
    
    public String getFoto() { return foto; }
    public void setFoto(String foto) { this.foto = foto; }
}