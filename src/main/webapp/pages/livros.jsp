<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livros - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .livro-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            height: 100%; /* Garante que todos os cards tenham a mesma altura */
            display: flex;
            flex-direction: column;
        }
        
        .livro-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.15);
        }
        
        .livro-img {
            width: 100%;
            height: 250px; /* Altura fixa para a imagem */
            object-fit: cover;
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
        }
        
        .livro-body {
            padding: 1.5rem;
            flex-grow: 1; /* Faz o corpo do card crescer para preencher o espaço */
            display: flex;
            flex-direction: column;
            justify-content: space-between; /* Empurra o botão para baixo */
        }
        
        .livro-titulo {
            font-size: 1.25rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .livro-autor {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .livro-preco {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
            margin-bottom: 1rem;
        }
        
        .btn-adicionar {
            width: 100%;
            border-radius: 50px;
            font-weight: bold;
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
        <h2 class="mb-4"><i class="fas fa-book me-3"></i>Nosso Catálogo</h2>
        
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-4">
            <c:choose>
                <c:when test="${empty livros}">
                    <div class="col-12 text-center py-5">
                        <i class="fas fa-exclamation-circle fa-5x text-muted mb-3"></i>
                        <h3>Nenhum livro encontrado.</h3>
                        <p class="lead">Tente ajustar seus filtros de busca.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${livros}" var="livro">
                        <div class="col">
                            <div class="livro-card">
                                <a href="${pageContext.request.contextPath}/livro-detalhes?id=${livro.id}">
                                    <img src="${livro.capa != null ? livro.capa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                         class="card-img-top livro-img" alt="${livro.titulo}">
                                </a>
                                <div class="livro-body">
                                    <div>
                                        <h5 class="livro-titulo">${livro.titulo}</h5>
                                        <p class="livro-autor">${livro.autorNome}</p>
                                    </div>
                                    <div class="mt-auto">
                                        <div class="livro-preco">
                                            <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                                        </div>
                                        <button class="btn btn-primary btn-adicionar" 
                                                data-livro-id="${livro.id}" 
                                                data-livro-titulo="${livro.titulo}">
                                            <i class="fas fa-cart-plus me-2"></i>Adicionar ao Carrinho
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            $('.btn-adicionar').click(function() {
                const livroId = $(this).data('livro-id');
                const livroTitulo = $(this).data('livro-titulo');
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/carrinho',
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