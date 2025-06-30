<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrinho de Compras - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .carrinho-item {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .carrinho-item:hover {
            transform: translateY(-2px);
        }
        
        .produto-img {
            width: 100px;
            height: 120px;
            object-fit: cover;
            border-radius: 10px;
        }
        
        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn-quantity {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 0;
        }
        
        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid #e9ecef;
            border-radius: 8px;
        }
        
        .resumo-pedido {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            position: sticky;
            top: 20px;
        }
        
        .btn-finalizar {
            background: white;
            color: #667eea;
            border: none;
            border-radius: 50px;
            padding: 15px 30px;
            font-weight: bold;
            width: 100%;
            transition: all 0.3s ease;
        }
        
        .btn-finalizar:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        
        .carrinho-vazio {
            text-align: center;
            padding: 5rem 0;
            color: #6c757d;
        }
        
        .carrinho-vazio i {
            font-size: 5rem;
            margin-bottom: 2rem;
            opacity: 0.3;
        }
        
        .preco-item {
            font-weight: bold;
            color: #28a745;
        }
        
        .btn-remover {
            background: none;
            border: none;
            color: #dc3545;
            padding: 5px;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .btn-remover:hover {
            background: #dc3545;
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-book-open me-2"></i>Livraria Online
            </a>
            
            <div class="d-flex align-items-center">
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-outline-light me-2">
                    <i class="fas fa-book me-1"></i>Continuar Comprando
                </a>
                
                <div class="dropdown">
                    <button class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>${sessionScope.usuarioNome}
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">
                            <i class="fas fa-user-edit me-2"></i>Meu Perfil
                        </a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/meus-pedidos">
                            <i class="fas fa-box me-2"></i>Meus Pedidos
                        </a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i>Sair
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Conteúdo Principal -->
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <div class="d-flex align-items-center mb-4">
                    <h2><i class="fas fa-shopping-cart me-3"></i>Meu Carrinho</h2>
                    <span class="badge bg-primary ms-3">${itens.size()} itens</span>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty itens}">
                <!-- Carrinho Vazio -->
                <div class="carrinho-vazio">
                    <i class="fas fa-shopping-cart"></i>
                    <h3>Seu carrinho está vazio</h3>
                    <p class="lead">Que tal explorar nosso catálogo e encontrar livros incríveis?</p>
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary btn-lg">
                        <i class="fas fa-book me-2"></i>Explorar Livros
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <!-- Lista de Itens -->
                    <div class="col-lg-8">
                        <div class="d-flex flex-column gap-3">
                            <c:forEach items="${itens}" var="item">
                                <div class="carrinho-item item-carrinho p-4" data-livro-id="${item.livroId}">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <img src="${item.livroCapa != null ? item.livroCapa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                                 alt="${item.livroTitulo}" class="produto-img">
                                        </div>
                                        
                                        <div class="col-md-4">
                                            <h6 class="fw-bold mb-1">${item.livroTitulo}</h6>
                                            <p class="text-muted mb-0">por ${item.livroAutor}</p>
                                            <c:if test="${item.livroEstoque < 5}">
                                                <small class="text-warning">
                                                    <i class="fas fa-exclamation-triangle me-1"></i>
                                                    Apenas ${item.livroEstoque} em estoque
                                                </small>
                                            </c:if>
                                        </div>
                                        
                                        <div class="col-md-2">
                                            <div class="preco-item">
                                                <fmt:formatNumber value="${item.precoFinal}" type="currency" currencySymbol="R$ "/>
                                            </div>
                                        }
                                        
                                        <div class="col-md-3">
                                            <div class="quantity-controls">
                                                <button class="btn btn-outline-secondary btn-quantity btn-diminuir" 
                                                        data-livro-id="${item.livroId}">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                                <input type="number" class="form-control quantity-input quantidade-input" 
                                                       value="${item.quantidade}" min="1" max="${item.livroEstoque}"
                                                       data-livro-id="${item.livroId}">
                                                <button class="btn btn-outline-secondary btn-quantity btn-aumentar" 
                                                        data-livro-id="${item.livroId}" 
                                                        data-estoque="${item.livroEstoque}">
                                                    <i class="fas fa-plus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-1">
                                            <div class="d-flex flex-column align-items-center gap-2">
                                                <div class="fw-bold subtotal-item">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$ "/>
                                                </div>
                                                <button class="btn-remover btn-remover-item" 
                                                        data-livro-id="${item.livroId}"
                                                        title="Remover item">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                    
                    <!-- Resumo do Pedido -->
                    <div class="col-lg-4">
                        <div class="resumo-pedido">
                            <h4 class="mb-4">
                                <i class="fas fa-receipt me-2"></i>Resumo do Pedido
                            </h4>
                            
                            <div class="d-flex justify-content-between mb-3">
                                <span>Subtotal:</span>
                                <span id="subtotal-valor">
                                    <fmt:formatNumber value="${total}" type="currency" currencySymbol="R$ "/>
                                </span>
                            </div>
                            
                            <div class="d-flex justify-content-between mb-3">
                                <span>Frete:</span>
                                <span class="text-success">GRÁTIS</span>
                            </div>
                            
                            <hr class="my-4" style="border-color: rgba(255,255,255,0.3);">
                            
                            <div class="d-flex justify-content-between mb-4">
                                <h5>Total:</h5>
                                <h5 id="total-valor">
                                    <fmt:formatNumber value="${total}" type="currency" currencySymbol="R$ "/>
                                </h5>
                            </div>
                            
                            <div class="mb-4">
                                <p class="small mb-2">
                                    <i class="fas fa-shield-alt me-2"></i>Compra 100% segura
                                </p>
                                <p class="small mb-2">
                                    <i class="fas fa-truck me-2"></i>Entrega em todo o Brasil
                                </p>
                                <p class="small mb-0">
                                    <i class="fas fa-undo me-2"></i>30 dias para troca
                                </p>
                            </div>
                            
                            <a href="${pageContext.request.contextPath}/checkout" class="btn btn-finalizar">
                                <i class="fas fa-credit-card me-2"></i>Finalizar Compra
                            </a>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Aumentar quantidade
            $('.btn-aumentar').click(function() {
                const livroId = $(this).data('livro-id');
                const estoque = $(this).data('estoque');
                const input = $(this).siblings('.quantidade-input');
                const quantidadeAtual = parseInt(input.val());
                
                if (quantidadeAtual < estoque) {
                    input.val(quantidadeAtual + 1);
                    atualizarQuantidade(livroId, quantidadeAtual + 1);
                } else {
                    showNotification('Quantidade máxima em estoque atingida', 'warning');
                }
            });
            
            // Diminuir quantidade
            $('.btn-diminuir').click(function() {
                const livroId = $(this).data('livro-id');
                const input = $(this).siblings('.quantidade-input');
                const quantidadeAtual = parseInt(input.val());
                
                if (quantidadeAtual > 1) {
                    input.val(quantidadeAtual - 1);
                    atualizarQuantidade(livroId, quantidadeAtual - 1);
                }
            });
            
            // Mudança manual na quantidade
            $('.quantidade-input').change(function() {
                const livroId = $(this).data('livro-id');
                const quantidade = parseInt($(this).val());
                const estoque = $(this).siblings('.btn-aumentar').data('estoque');
                
                if (quantidade < 1) {
                    $(this).val(1);
                    atualizarQuantidade(livroId, 1);
                } else if (quantidade > estoque) {
                    $(this).val(estoque);
                    atualizarQuantidade(livroId, estoque);
                    showNotification('Quantidade ajustada para o máximo disponível em estoque', 'warning');
                } else {
                    atualizarQuantidade(livroId, quantidade);
                }
            });
            
            // Remover item
            $('.btn-remover-item').click(function() {
                const livroId = $(this).data('livro-id');
                
                if (confirm('Deseja realmente remover este item do carrinho?')) {
                    removerItem(livroId);
                }
            });
        });
        
        function atualizarQuantidade(livroId, quantidade) {
            $.ajax({
                url: '${pageContext.request.contextPath}/carrinho',
                method: 'POST',
                data: {
                    acao: 'atualizar',
                    livroId: livroId,
                    quantidade: quantidade
                },
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        // Atualizar subtotal do item
                        const item = $(`[data-livro-id="${livroId}"]`);
                        const precoUnitario = parseFloat(item.find('.preco-item').text().replace('R$ ', '').replace(',', '.'));
                        const novoSubtotal = (precoUnitario * quantidade).toFixed(2);
                        
                        item.find('.subtotal-item').text('R$ ' + novoSubtotal.replace('.', ','));
                        
                        // Atualizar total
                        $('#subtotal-valor').text('R$ ' + response.novoTotal.toFixed(2).replace('.', ','));
                        $('#total-valor').text('R$ ' + response.novoTotal.toFixed(2).replace('.', ','));
                        
                        showNotification('Quantidade atualizada!', 'success');
                    } else {
                        showNotification('Erro ao atualizar quantidade', 'error');
                    }
                },
                error: function() {
                    showNotification('Erro de conexão', 'error');
                }
            });
        }
        
        function removerItem(livroId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/carrinho',
                method: 'POST',
                data: {
                    acao: 'remover',
                    livroId: livroId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        // Remover item da tela
                        $(`[data-livro-id="${livroId}"]`).fadeOut(300, function() {
                            $(this).remove();
                            
                            // Verificar se carrinho ficou vazio
                            if ($('.item-carrinho').length === 0) {
                                location.reload();
                            }
                        });
                        
                        // Atualizar totais
                        $('#subtotal-valor').text('R$ ' + response.novoTotal.toFixed(2).replace('.', ','));
                        $('#total-valor').text('R$ ' + response.novoTotal.toFixed(2).replace('.', ','));
                        
                        // Atualizar contador de itens
                        const novoContador = response.totalItens;
                        $('.badge').text(novoContador + ' itens');
                        
                        showNotification('Item removido do carrinho', 'success');
                    } else {
                        showNotification('Erro ao remover item', 'error');
                    }
                },
                error: function() {
                    showNotification('Erro de conexão', 'error');
                }
            });
        }
        
        function showNotification(message, type) {
            let alertClass;
            let icon;
            
            switch(type) {
                case 'success':
                    alertClass = 'alert-success';
                    icon = 'fas fa-check-circle';
                    break;
                case 'warning':
                    alertClass = 'alert-warning';
                    icon = 'fas fa-exclamation-triangle';
                    break;
                case 'error':
                    alertClass = 'alert-danger';
                    icon = 'fas fa-times-circle';
                    break;
                default:
                    alertClass = 'alert-info';
                    icon = 'fas fa-info-circle';
            }
            
            const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 9999; min-width: 300px;" role="alert">
                    <i class="${icon}" me-2></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            // Remove alertas existentes
            $('.alert').remove();
            $('body').append(alertHtml);
            
            // Remove automaticamente após 3 segundos
            setTimeout(() => {
                $('.alert').fadeOut();
            }, 3000);
        }
        
        // Animações de entrada
        $(window).on('load', function() {
            $('.carrinho-item').each(function(index) {
                $(this).delay(index * 100).queue(function() {
                    $(this).addClass('animate__animated animate__fadeInUp');
                    $(this).dequeue();
                });
            });
        });
        
        // Validação antes de finalizar compra
        $('.btn-finalizar').click(function(e) {
            const totalItens = $('.item-carrinho').length;
            
            if (totalItens === 0) {
                e.preventDefault();
                showNotification('Adicione itens ao carrinho antes de finalizar a compra', 'warning');
                return false;
            }
            
            // Verificar se todas as quantidades estão válidas
            let temErro = false;
            $('.quantidade-input').each(function() {
                const quantidade = parseInt($(this).val());
                const estoque = $(this).siblings('.btn-aumentar').data('estoque');
                
                if (quantidade > estoque || quantidade < 1) {
                    temErro = true;
                    return false;
                }
            });
            
            if (temErro) {
                e.preventDefault();
                showNotification('Verifique as quantidades dos itens no carrinho', 'warning');
                return false;
            }
        });
    </script>
</body>
</html>