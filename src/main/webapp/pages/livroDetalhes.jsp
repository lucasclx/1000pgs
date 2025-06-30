<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${livro.titulo} - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .livro-detalhes-img {
            width: 100%;
            max-height: 500px;
            object-fit: contain;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .livro-info {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .livro-titulo {
            font-size: 2.5rem;
            font-weight: bold;
            color: #343a40;
        }
        
        .livro-autor {
            font-size: 1.2rem;
            color: #6c757d;
            margin-bottom: 1rem;
        }
        
        .livro-preco {
            font-size: 2.8rem;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 1.5rem;
        }
        
        .btn-adicionar-carrinho {
            padding: 15px 30px;
            font-size: 1.2rem;
            border-radius: 50px;
            font-weight: bold;
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            transition: all 0.3s ease;
        }
        
        .btn-adicionar-carrinho:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .section-title {
            font-size: 1.8rem;
            font-weight: bold;
            color: #343a40;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 0.5rem;
        }
        
        .avaliacao-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        
        .rating .fas {
            color: #ffc107;
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
                <a href="${pageContext.request.contextPath}/carrinho" class="btn btn-outline-light me-2">
                    <i class="fas fa-shopping-cart me-1"></i>Carrinho
                    <c:if test="${sessionScope.totalItensCarrinho > 0}">
                        <span class="badge bg-danger ms-1">${sessionScope.totalItensCarrinho}</span>
                    </c:if>
                </a>
                
                <div class="dropdown">
                    <button class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        <i class="fas fa-user me-1"></i>
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioNome}">
                                ${sessionScope.usuarioNome}
                            </c:when>
                            <c:otherwise>
                                Minha Conta
                            </c:otherwise>
                        </c:choose>
                    </button>
                    <ul class="dropdown-menu">
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioNome}">
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
                            </c:when>
                            <c:otherwise>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/login">
                                    <i class="fas fa-sign-in-alt me-2"></i>Login
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/cadastro">
                                    <i class="fas fa-user-plus me-2"></i>Cadastre-se
                                </a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </div>
            </div>
        </div>
    </nav>

    <!-- Conteúdo Principal -->
    <div class="container py-5">
        <c:if test="${empty livro}">
            <div class="alert alert-warning text-center" role="alert">
                <h4 class="alert-heading">Livro não encontrado!</h4>
                <p>O livro que você está procurando pode ter sido removido ou não existe.</p>
                <hr>
                <p class="mb-0">Que tal explorar nosso <a href="${pageContext.request.contextPath}/livros" class="alert-link">catálogo completo</a>?</p>
            </div>
        </c:if>
        
        <c:if test="${not empty livro}">
            <div class="row">
                <div class="col-md-5 mb-4">
                    <img src="${livro.capa != null ? livro.capa : pageContext.request.contextPath}/img/livro-default.jpg" 
                         alt="${livro.titulo}" class="livro-detalhes-img">
                </div>
                <div class="col-md-7 mb-4">
                    <div class="livro-info">
                        <h1 class="livro-titulo">${livro.titulo}</h1>
                        <h2 class="livro-autor">por ${livro.autorNome}</h2>
                        
                        <div class="d-flex align-items-center mb-3">
                            <div class="rating me-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star <c:if test="${i > livro.mediaAvaliacoes}">text-muted</c:if>"></i>
                                </c:forEach>
                            </div>
                            <span class="text-muted">(${livro.totalAvaliacoes} avaliações)</span>
                        </div>
                        
                        <p class="lead mb-4">${livro.descricaoCurta}</p>
                        
                        <div class="livro-preco">
                            <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                        </div>
                        
                        <button class="btn btn-primary btn-adicionar-carrinho w-100" 
                                data-livro-id="${livro.id}" 
                                data-livro-titulo="${livro.titulo}">
                            <i class="fas fa-cart-plus me-2"></i>Adicionar ao Carrinho
                        </button>
                        
                        <div class="mt-4 small text-muted">
                            <p class="mb-1"><i class="fas fa-check-circle text-success me-2"></i>Em estoque: ${livro.estoque} unidades</p>
                            <p class="mb-1"><i class="fas fa-truck text-primary me-2"></i>Frete grátis para todo o Brasil</p>
                            <p class="mb-0"><i class="fas fa-undo text-info me-2"></i>Devolução fácil em até 30 dias</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row mt-5">
                <div class="col-12">
                    <h3 class="section-title">Descrição Completa</h3>
                    <p>${livro.descricaoCompleta}</p>
                </div>
            </div>
            
            <div class="row mt-5">
                <div class="col-12">
                    <h3 class="section-title">Avaliações de Clientes</h3>
                    
                    <c:if test="${empty avaliacoes}">
                        <div class="alert alert-info text-center" role="alert">
                            Ainda não há avaliações para este livro. Seja o primeiro a avaliar!
                        </div>
                    </c:if>
                    
                    <c:forEach items="${avaliacoes}" var="avaliacao">
                        <div class="avaliacao-card">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <h6 class="mb-0">${avaliacao.nomeUsuario}</h6>
                                <small class="text-muted">${avaliacao.data}</small>
                            </div>
                            <div class="rating mb-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star <c:if test="${i > avaliacao.nota}">text-muted</c:if>"></i>
                                </c:forEach>
                            </div>
                            <p>${avaliacao.comentario}</p>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('.btn-adicionar-carrinho').click(function() {
                const livroId = $(this).data('livro-id');
                const livroTitulo = $(this).data('livro-titulo');
                
                $.ajax({
                    url: '${pageContext.request.context.Path}/carrinho',
                    method: 'POST',
                    data: {
                        acao: 'adicionar',
                        livroId: livroId,
                        quantidade: 1
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.sucesso) {
                            showNotification(`"${livroTitulo}" adicionado ao carrinho!`, 'success');
                            // Atualizar contador do carrinho na navbar
                            $('.badge').text(response.totalItensCarrinho);
                        } else {
                            showNotification(response.mensagem || 'Erro ao adicionar ao carrinho', 'error');
                        }
                    },
                    error: function() {
                        showNotification('Erro de conexão ao adicionar ao carrinho', 'error');
                    }
                });
            });
        });
        
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
    </script>
</body>
</html>