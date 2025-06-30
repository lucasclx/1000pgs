package br.com.livraria.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

// Classe Cupom
class Cupom {
    private int id;
    private String codigo;
    private String descricao;
    private String tipo;
    private BigDecimal valor;
    private BigDecimal valorMinimo;
    private LocalDateTime dataInicio;
    private LocalDateTime dataFim;
    private int usosLimite;
    private int usosRealizados;
    private boolean ativo;
    
    public Cupom() {}
    
    // Getters e Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    
    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }
    
    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }
    
    public BigDecimal getValor() { return valor; }
    public void setValor(BigDecimal valor) { this.valor = valor; }
    
    public BigDecimal getValorMinimo() { return valorMinimo; }
    public void setValorMinimo(BigDecimal valorMinimo) { this.valorMinimo = valorMinimo; }
    
    public LocalDateTime getDataInicio() { return dataInicio; }
    public void setDataInicio(LocalDateTime dataInicio) { this.dataInicio = dataInicio; }
    
    public LocalDateTime getDataFim() { return dataFim; }
    public void setDataFim(LocalDateTime dataFim) { this.dataFim = dataFim; }
    
    public int getUsosLimite() { return usosLimite; }
    public void setUsosLimite(int usosLimite) { this.usosLimite = usosLimite; }
    
    public int getUsosRealizados() { return usosRealizados; }
    public void setUsosRealizados(int usosRealizados) { this.usosRealizados = usosRealizados; }
    
    public boolean isAtivo() { return ativo; }
    public void setAtivo(boolean ativo) { this.ativo = ativo; }
    
    public boolean isValido() {
        LocalDateTime agora = LocalDateTime.now();
        return ativo && 
               (dataInicio == null || agora.isAfter(dataInicio)) &&
               (dataFim == null || agora.isBefore(dataFim)) &&
               (usosLimite == 0 || usosRealizados < usosLimite);
    }
    
    public BigDecimal calcularDesconto(BigDecimal valorPedido) {
        if (!isValido() || valorPedido.compareTo(valorMinimo) < 0) {
            return BigDecimal.ZERO;
        }
        
        if ("percentual".equals(tipo)) {
            return valorPedido.multiply(valor).divide(BigDecimal.valueOf(100));
        } else {
            return valor;
        }
    }
}