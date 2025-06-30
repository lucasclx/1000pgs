<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://livraria.com/functions" prefix="fn" %>
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
        
        .cart-badge {
            position: absolute;
            top: -8px;
            right: -8px;
            background: #dc3545;
            color: white;
            border-radius: 50%;
            min-width: 20px;
            height: 20px;
            font-size: 0.8rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .price-original {
            text-decoration: line-through;
            color: #6c757d;
            font-size: 1.5rem;
            margin-right: 1rem;
        }
        
        .livro-detalhes {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .livro-detalhes .row {
            margin-bottom: 1rem;
        }
        
        .avaliacao-form {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 2rem;
        }
        
        .star-rating {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
        }
        
        .star-rating .star {
            font-size: 2rem;
            color: #ddd;
            cursor: pointer;
            transition: color 0.3s ease;
        }
        
        .star-rating .star:hover,
        .star-rating .star.active {
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
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Início</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/livros">Catálogo</a>
                    </li>
                </ul>
                
                <div class="d-flex align-items-center">
                    <div class="position-relative me-2">
                        <a href="${pageContext.request.contextPath}/carrinho" class="btn btn-outline-light">
                            <i class="fas fa-shopping-cart"></i>
                            <c:if test="${sessionScope.totalItensCarrinho > 0}">
                                <span class="cart-badge" id="cart-count">${sessionScope.totalItensCarrinho}</span>
                            </c:if>
                        </a>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.usuarioNome}">
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
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light me-2">
                                <i class="fas fa-sign-in-alt me-1"></i>Login
                            </a>
                            <a href="${pageContext.request.contextPath}/cadastro" class="btn btn-primary">
                                <i class="fas fa-user-plus me-1"></i>Cadastre-se
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

    <!-- Breadcrumb -->
    <div class="container mt-3">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/">Início</a></li>
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/livros">Livros</a></li>
                <li class="breadcrumb-item active" aria-current="page">${livro.titulo}</li>
            </ol>
        </nav>
    </div>

    <!-- Conteúdo Principal -->
    <div class="container py-4">
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
                <!-- Imagem do Livro -->
                <div class="col-md-5 mb-4">
                    <div class="position-relative">
                        <img src="${livro.capa != null ? livro.capa : pageContext.request.contextPath}/img/livro-default.jpg" 
                             alt="${livro.titulo}" class="livro-detalhes-img">
                        
                        <c:if test="${livro.temPromocao()}">
                            <span class="position-absolute top-0 end-0 badge bg-danger m-3 p-2">
                                <i class="fas fa-percent me-1"></i>PROMOÇÃO
                            </span>
                        </c:if>
                    </div>
                </div>
                
                <!-- Informações do Livro -->
                <div class="col-md-7 mb-4">
                    <div class="livro-info">
                        <h1 class="livro-titulo">${livro.titulo}</h1>
                        <h2 class="livro-autor">por ${livro.autorNome}</h2>
                        
                        <!-- Avaliações -->
                        <div class="d-flex align-items-center mb-3">
                            <div class="rating me-2">
                                <c:forEach begin="1" end="5" var="i">
                                    <i class="fas fa-star <c:if test="${i > livro.mediaAvaliacoes}">text-muted</c:if>"></i>
                                </c:forEach>
                            </div>
                            <span class="text-muted">(${livro.totalAvaliacoes} avaliações)</span>
                            <span class="badge bg-primary ms-2">${livro.categoriaNome}</span>
                        </div>
                        
                        <!-- Preço -->
                        <div class="livro-preco">
                            <c:if test="${livro.temPromocao()}">
                                <span class="price-original">
                                    <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                                </span>
                            </c:if>
                            <fmt:formatNumber value="${livro.precoFinal}" type="currency" currencySymbol="R$ "/>
                        </div>
                        
                        <!-- Descrição Resumida -->
                        <p class="lead mb-4">${livro.descricao}</p>
                        
                        <!-- Status de Estoque -->
                        <div class="mb-4">
                            <c:choose>
                                <c:when test="${livro.temEstoque()}">
                                    <div class="d-flex align-items-center text-success mb-2">
                                        <i class="fas fa-check-circle me-2"></i>
                                        <span>Em estoque: ${livro.estoque} unidades disponíveis</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="d-flex align-items-center text-danger mb-2">
                                        <i class="fas fa-times-circle me-2"></i>
                                        <span>Produto esgotado</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Botão Adicionar ao Carrinho -->
                        <c:choose>
                            <c:when test="${not empty sessionScope.usuarioId}">
                                <button class="btn btn-primary btn-adicionar-carrinho w-100 mb-3" 
                                        data-livro-id="${livro.id}" 
                                        ${livro.temEstoque() ? '' : 'disabled'}>
                                    <i class="fas fa-cart-plus me-2"></i>
                                    ${livro.temEstoque() ? 'Adicionar ao Carrinho' : 'Produto Esgotado'}
                                </button>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-adicionar-carrinho w-100 mb-3">
                                    <i class="fas fa-sign-in-alt me-2"></i>Faça Login para Comprar
                                </a>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Garantias e Benefícios -->
                        <div class="row small text-muted">
                            <div class="col-md-6 mb-2">
                                <i class="fas fa-truck text-primary me-2"></i>Frete grátis para todo o Brasil
                            </div>
                            <div class="col-md-6 mb-2">
                                <i class="fas fa-undo text-info me-2"></i>Devolução fácil em até 30 dias
                            </div>
                            <div class="col-md-6 mb-2">
                                <i class="fas fa-shield-alt text-success me-2"></i>Compra 100% segura
                            </div>
                            <div class="col-md-6 mb-2">
                                <i class="fas fa-headset text-warning me-2"></i>Atendimento 24/7
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Detalhes Técnicos -->
            <div class="row mt-5">
                <div class="col-12">
                    <h3 class="section-title">Detalhes do Livro</h3>
                    <div class="livro-detalhes">
                        <div class="row">
                            <div class="col-md-6">
                                <strong>ISBN:</strong> ${livro.isbn}
                            </div>
                            <div class="col-md-6">
                                <strong>Páginas:</strong> ${livro.paginas}
                            </div>
                            <div class="col-md-6">
                                <strong>Ano de Publicação:</strong> ${livro.anoPublicacao}
                            </div>
                            <div class="col-md-6">
                                <strong>Editora:</strong> ${livro.editora}
                            </div>
                            <div class="col-md-6">
                                <strong>Categoria:</strong> ${livro.categoriaNome}
                            </div>
                            <div class="col-md-6">
                                <strong>Autor:</strong> ${livro.autorNome}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Avaliações -->
            <div class="row mt-5">
                <div class="col-12">
                    <h3 class="section-title">Avaliações de Clientes</h3>
                    
                    <!-- Formulário de Avaliação (apenas se usuário logado e comprou o livro) -->
                    <c:if test="${not empty sessionScope.usuarioId and podeAvaliar}">
                        <div class="avaliacao-form">
                            <h5 class="mb-3">Deixe sua avaliação</h5>
                            <form id="form-avaliacao">
                                <input type="hidden" name="livroId" value="${livro.id}">
                                
                                <div class="mb-3">
                                    <label class="form-label">Sua nota:</label>
                                    <div class="star-rating" id="star-rating">
                                        <i class="fas fa-star star" data-rating="1"></i>
                                        <i class="fas fa-star star" data-rating="2"></i>
                                        <i class="fas fa-star star" data-rating="3"></i>
                                        <i class="fas fa-star star" data-rating="4"></i>
                                        <i class="fas fa-star star" data-rating="5"></i>
                                    </div>
                                    <input type="hidden" name="nota" id="nota-selecionada" value="">
                                </div>
                                
                                <div class="mb-3">
                                    <label for="comentario" class="form-label">Seu comentário:</label>
                                    <textarea class="form-control" id="comentario" name="comentario" rows="4" 
                                             placeholder="Conte sobre sua experiência com este livro..."></textarea>
                                </div>
                                
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-star me-2"></i>Enviar Avaliação
                                </button>
                            </form>
                        </div>
                    </c:if>
                    
                    <!-- Lista de Avaliações -->
                    <c:choose>
                        <c:when test="${empty avaliacoes}">
                            <div class="alert alert-info text-center" role="alert">
                                <i class="fas fa-star fa-2x mb-3 text-muted"></i>
                                <h5>Ainda não há avaliações para este livro</h5>
                                <p class="mb-0">Seja o primeiro a avaliar este livro e ajude outros leitores!</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${avaliacoes}" var="avaliacao">
                                <div class="avaliacao-card">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <div>
                                            <h6 class="mb-1">${avaliacao.usuarioNome}</h6>
                                            <div class="rating mb-2">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star <c:if test="${i > avaliacao.nota}">text-muted</c:if>"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <small class="text-muted">
                                            ${fn:formatarData(avaliacao.dataAvaliacao)}
                                        </small>
                                    </div>
                                    <p class="mb-0">${avaliacao.comentario}</p>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:if>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Adicionar ao carrinho
            $('.btn-adicionar-carrinho').click(function() {
                const livroId = $(this).data('livro-id');
                
                if (!livroId) return; // Se não tem ID, é link de login
                
                adicionarAoCarrinho(livroId);
            });
            
            // Sistema de rating com estrelas
            $('.star').click(function() {
                const rating = $(this).data('rating');
                $('#nota-selecionada').val(rating);
                
                $('.star').removeClass('active');
                for (let i = 1; i <= rating; i++) {
                    $(`.star[data-rating="${i}"]`).addClass('active');
                }
            });
            
            // Hover effect nas estrelas
            $('.star').hover(function() {
                const rating = $(this).data('rating');
                $('.star').removeClass('active');
                for (let i = 1; i <= rating; i++) {
                    $(`.star[data-rating="${i}"]`).addClass('active');
                }
            }, function() {
                $('.star').removeClass('active');
                const selectedRating = $('#nota-selecionada').val();
                for (let i = 1; i <= selectedRating; i++) {
                    $(`.star[data-rating="${i}"]`).addClass('active');
                }
            });
            
            // Formulário de avaliação
            $('#form-avaliacao').submit(function(e) {
                e.preventDefault();
                
                const nota = $('#nota-selecionada').val();
                const comentario = $('#comentario').val();
                
                if (!nota) {
                    showNotification('Por favor, selecione uma nota de 1 a 5 estrelas.', 'warning');
                    return;
                }
                
                if (!comentario.trim()) {
                    showNotification('Por favor, escreva um comentário sobre o livro.', 'warning');
                    return;
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/avaliar',
                    method: 'POST',
                    data: $(this).serialize(),
                    dataType: 'json',
                    success: function(response) {
                        if (response.sucesso) {
                            showNotification(response.mensagem, 'success');
                            $('#form-avaliacao')[0].reset();
                            $('.star').removeClass('active');
                            $('#nota-selecionada').val('');
                        } else {
                            showNotification(response.mensagem, 'error');
                        }
                    },
                    error: function() {
                        showNotification('Erro de conexão ao enviar avaliação.', 'error');
                    }
                });
            });
        });
        
        function adicionarAoCarrinho(livroId) {
            const btn = $('.btn-adicionar-carrinho');
            const originalHtml = btn.html();
            
            // Mostrar loading
            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Adicionando...');
            
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
                        showNotification('Livro adicionado ao carrinho com sucesso!', 'success');
                        
                        // Atualizar contador do carrinho
                        if (response.totalItens > 0) {
                            $('#cart-count').text(response.totalItens).show();
                        }
                        
                        // Mostrar feedback de sucesso
                        btn.html('<i class="fas fa-check me-2"></i>Adicionado!').addClass('btn-success').removeClass('btn-primary');
                        
                        setTimeout(() => {
                            btn.html(originalHtml).removeClass('btn-success').addClass('btn-primary').prop('disabled', false);
                        }, 3000);
                    } else {
                        showNotification('Erro ao adicionar livro ao carrinho.', 'error');
                        btn.html(originalHtml).prop('disabled', false);
                    }
                },
                error: function() {
                    showNotification('Erro de conexão.', 'error');
                    btn.html(originalHtml).prop('disabled', false);
                }
            });
        }
        
        function showNotification(message, type) {
            let alertClass, icon;
            
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
                    <i class="${icon} me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            $('.alert').remove();
            $('body').append(alertHtml);
            
            setTimeout(() => {
                $('.alert').fadeOut();
            }, 5000);
        }
    </script>
</body>
</html>