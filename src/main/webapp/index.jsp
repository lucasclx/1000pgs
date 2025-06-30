<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livraria Online - Sua próxima leitura está aqui!</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #667eea;
            --secondary-color: #764ba2;
            --accent-color: #f093fb;
        }
        
        .hero-section {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
            color: white;
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" opacity="0.1"><polygon points="0,100 1000,0 1000,100"/></svg>');
            background-size: cover;
        }
        
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .search-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 1rem 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        
        .category-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            height: 100%;
        }
        
        .category-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .category-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
        }
        
        .book-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            transition: all 0.3s ease;
            border: none;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            height: 100%;
        }
        
        .book-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        }
        
        .book-image {
            height: 250px;
            object-fit: cover;
            width: 100%;
        }
        
        .book-card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            height: calc(100% - 250px);
        }
        
        .book-title {
            font-weight: bold;
            margin-bottom: 0.5rem;
            flex-grow: 1;
        }
        
        .book-author {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }
        
        .book-price {
            font-size: 1.25rem;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .price-original {
            text-decoration: line-through;
            color: #6c757d;
            font-size: 0.9rem;
            margin-right: 0.5rem;
        }
        
        .btn-primary {
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .stats-section {
            background: #f8f9fa;
            padding: 3rem 0;
        }
        
        .stat-item {
            text-align: center;
            padding: 1rem;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--primary-color);
            display: block;
        }
        
        .stat-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .footer {
            background: #2c3e50;
            color: white;
            padding: 3rem 0 1rem;
        }
        
        .footer h5 {
            color: var(--accent-color);
            margin-bottom: 1rem;
        }
        
        .footer a {
            color: #bdc3c7;
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .footer a:hover {
            color: white;
        }
        
        .social-icons a {
            display: inline-block;
            width: 40px;
            height: 40px;
            background: var(--primary-color);
            color: white;
            text-align: center;
            line-height: 40px;
            border-radius: 50%;
            margin-right: 0.5rem;
            transition: all 0.3s ease;
        }
        
        .social-icons a:hover {
            background: var(--secondary-color);
            transform: translateY(-2px);
        }
        
        .badge-promocao {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #e74c3c;
            color: white;
            border-radius: 15px;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
            font-weight: bold;
        }
        
        .rating {
            color: #ffc107;
            margin-bottom: 0.5rem;
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
    </style>
</head>
<body>
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
                        <a class="nav-link active" href="${pageContext.request.contextPath}/">Início</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/livros">Catálogo</a>
                    </li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                            Categorias
                        </a>
                        <ul class="dropdown-menu">
                            <c:forEach items="${categorias}" var="categoria">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/livros?categoria=${categoria.id}">${categoria.nome}</a></li>
                            </c:forEach>
                        </ul>
                    </li>
                </ul>
                
                <div class="d-flex align-items-center">
                    <div class="position-relative me-2">
                        <a href="${pageContext.request.contextPath}/carrinho" class="btn btn-outline-light">
                            <i class="fas fa-shopping-cart"></i>
                            <span class="cart-badge" id="cart-count" style="display: none;">0</span>
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

    <!-- Hero Section -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">
                        Sua próxima <span class="text-warning">aventura literária</span> começa aqui!
                    </h1>
                    <p class="lead mb-4">
                        Descubra milhares de livros dos mais variados gêneros. 
                        Entrega grátis, preços incríveis e a melhor experiência de compra online.
                    </p>
                    <div class="d-flex gap-3 mb-5">
                        <a href="${pageContext.request.contextPath}/livros" class="btn btn-light btn-lg">
                            <i class="fas fa-book me-2"></i>Explorar Catálogo
                        </a>
                        <a href="#destaques" class="btn btn-outline-light btn-lg">
                            <i class="fas fa-star me-2"></i>Ver Destaques
                        </a>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="search-box">
                        <form action="${pageContext.request.contextPath}/livros" method="get">
                            <div class="input-group">
                                <input type="text" class="form-control border-0" name="busca" 
                                       placeholder="Busque por título, autor ou gênero...">
                                <button class="btn btn-primary" type="submit">
                                    <i class="fas fa-search"></i>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Estatísticas -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <span class="stat-number">10,000+</span>
                        <span class="stat-label">Livros Disponíveis</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <span class="stat-number">5,000+</span>
                        <span class="stat-label">Clientes Satisfeitos</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <span class="stat-number">24h</span>
                        <span class="stat-label">Atendimento</span>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <span class="stat-number">100%</span>
                        <span class="stat-label">Seguro</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Categorias -->
    <section class="py-5">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold">Explore por Categorias</h2>
                <p class="lead text-muted">Encontre exatamente o que você está procurando</p>
            </div>
            
            <div class="row g-4">
                <c:forEach items="${categorias}" var="categoria" varStatus="status">
                    <div class="col-md-6 col-lg-3">
                        <a href="${pageContext.request.contextPath}/livros?categoria=${categoria.id}" class="text-decoration-none">
                            <div class="category-card">
                                <c:choose>
                                    <c:when test="${status.index % 6 == 0}">
                                        <i class="fas fa-magic category-icon text-primary"></i>
                                    </c:when>
                                    <c:when test="${status.index % 6 == 1}">
                                        <i class="fas fa-heart category-icon text-danger"></i>
                                    </c:when>
                                    <c:when test="${status.index % 6 == 2}">
                                        <i class="fas fa-rocket category-icon text-info"></i>
                                    </c:when>
                                    <c:when test="${status.index % 6 == 3}">
                                        <i class="fas fa-graduation-cap category-icon text-warning"></i>
                                    </c:when>
                                    <c:when test="${status.index % 6 == 4}">
                                        <i class="fas fa-globe category-icon text-success"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-book category-icon text-secondary"></i>
                                    </c:otherwise>
                                </c:choose>
                                <h5 class="mb-2">${categoria.nome}</h5>
                                <p class="text-muted mb-0">${categoria.descricao}</p>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Livros em Destaque -->
    <section class="py-5 bg-light" id="destaques">
        <div class="container">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold">Livros em Destaque</h2>
                <p class="lead text-muted">Os mais vendidos e bem avaliados pelos nossos clientes</p>
            </div>
            
            <div class="row g-4">
                <c:forEach items="${livrosDestaque}" var="livro">
                    <div class="col-md-6 col-lg-3">
                        <div class="book-card position-relative">
                            <c:if test="${livro.temPromocao()}">
                                <span class="badge-promocao">PROMOÇÃO</span>
                            </c:if>
                            
                            <img src="${livro.capa != null ? livro.capa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                 alt="${livro.titulo}" class="book-image">
                            
                            <div class="book-card-body">
                                <c:if test="${livro.mediaAvaliacoes > 0}">
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= livro.mediaAvaliacoes}">
                                                    <i class="fas fa-star"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="far fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <small class="text-muted ms-1">(${livro.totalAvaliacoes})</small>
                                    </div>
                                </c:if>
                                
                                <h6 class="book-title">${livro.titulo}</h6>
                                <p class="book-author">por ${livro.autorNome}</p>
                                
                                <div class="d-flex justify-content-between align-items-center mt-auto">
                                    <div class="book-price">
                                        <c:if test="${livro.temPromocao()}">
                                            <span class="price-original">
                                                <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                                            </span>
                                        </c:if>
                                        <fmt:formatNumber value="${livro.precoFinal}" type="currency" currencySymbol="R$ "/>
                                    </div>
                                    <div>
                                        <a href="${pageContext.request.contextPath}/livro?id=${livro.id}" 
                                           class="btn btn-sm btn-outline-primary me-1">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn btn-sm btn-primary btn-add-cart" 
                                                data-livro-id="${livro.id}" 
                                                ${livro.temEstoque() ? '' : 'disabled'}>
                                            <i class="fas fa-cart-plus"></i>
                                        </button>
                                    </div>
                                </div>
                                
                                <c:if test="${!livro.temEstoque()}">
                                    <small class="text-danger">Esgotado</small>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <div class="text-center mt-5">
                <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary btn-lg">
                    <i class="fas fa-books me-2"></i>Ver Todos os Livros
                </a>
            </div>
        </div>
    </section>

    <!-- Newsletter -->
    <section class="py-5" style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 text-white">
                    <h3 class="fw-bold mb-3">Fique por dentro das novidades!</h3>
                    <p class="mb-0">Receba em primeira mão lançamentos, promoções exclusivas e recomendações personalizadas.</p>
                </div>
                <div class="col-lg-6">
                    <form class="d-flex" id="newsletter-form">
                        <input type="email" class="form-control me-2" placeholder="Seu melhor e-mail" id="newsletter-email">
                        <button class="btn btn-light" type="submit">
                            <i class="fas fa-paper-plane me-1"></i>Inscrever
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <h5><i class="fas fa-book-open me-2"></i>Livraria Online</h5>
                    <p class="mb-3">Sua livraria digital de confiança, oferecendo os melhores livros com entrega rápida e segura em todo o Brasil.</p>
                    <div class="social-icons">
                        <a href="#"><i class="fab fa-facebook-f"></i></a>
                        <a href="#"><i class="fab fa-twitter"></i></a>
                        <a href="#"><i class="fab fa-instagram"></i></a>
                        <a href="#"><i class="fab fa-youtube"></i></a>
                    </div>
                </div>
                
                <div class="col-lg-2 col-md-6 mb-4">
                    <h5>Navegação</h5>
                    <ul class="list-unstyled">
                        <li><a href="${pageContext.request.contextPath}/">Início</a></li>
                        <li><a href="${pageContext.request.contextPath}/livros">Catálogo</a></li>
                        <li><a href="${pageContext.request.contextPath}/carrinho">Carrinho</a></li>
                        <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-2 col-md-6 mb-4">
                    <h5>Categorias</h5>
                    <ul class="list-unstyled">
                        <c:forEach items="${categorias}" var="categoria" end="3">
                            <li><a href="${pageContext.request.contextPath}/livros?categoria=${categoria.id}">${categoria.nome}</a></li>
                        </c:forEach>
                    </ul>
                </div>
                
                <div class="col-lg-2 col-md-6 mb-4">
                    <h5>Suporte</h5>
                    <ul class="list-unstyled">
                        <li><a href="#">Central de Ajuda</a></li>
                        <li><a href="#">Fale Conosco</a></li>
                        <li><a href="#">Política de Troca</a></li>
                        <li><a href="#">Rastreamento</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-2 col-md-6 mb-4">
                    <h5>Contato</h5>
                    <ul class="list-unstyled">
                        <li><i class="fas fa-phone me-2"></i>(11) 1234-5678</li>
                        <li><i class="fas fa-envelope me-2"></i>contato@livraria.com</li>
                        <li><i class="fas fa-map-marker-alt me-2"></i>São Paulo, SP</li>
                    </ul>
                </div>
            </div>
            
            <hr class="my-4" style="border-color: #34495e;">
            
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p class="mb-0">&copy; 2025 Livraria Online. Todos os direitos reservados.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="me-3">Termos de Uso</a>
                    <a href="#" class="me-3">Política de Privacidade</a>
                    <a href="#">Cookies</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Adicionar ao carrinho
            $('.btn-add-cart').click(function() {
                const livroId = $(this).data('livro-id');
                
                // Verificar se usuário está logado
                <c:choose>
                    <c:when test="${empty sessionScope.usuarioId}">
                        // Redirecionar para login
                        window.location.href = '${pageContext.request.contextPath}/login';
                        return;
                    </c:when>
                    <c:otherwise>
                        adicionarAoCarrinho(livroId);
                    </c:otherwise>
                </c:choose>
            });
            
            // Atualizar contador do carrinho ao carregar a página
            atualizarContadorCarrinho();
            
            // Animações de entrada
            animateOnScroll();
            
            // Newsletter
            $('#newsletter-form').on('submit', function(e) {
                e.preventDefault();
                const email = $('#newsletter-email').val();
                
                if (email && isValidEmail(email)) {
                    showNotification('Email cadastrado com sucesso! Você receberá nossas novidades.', 'success');
                    $('#newsletter-email').val('');
                } else {
                    showNotification('Por favor, informe um email válido.', 'error');
                }
            });
        });
        
        function adicionarAoCarrinho(livroId) {
            const btn = $(`[data-livro-id="${livroId}"]`);
            const originalHtml = btn.html();
            
            // Mostrar loading
            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i>');
            
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
                        showNotification('Livro adicionado ao carrinho!', 'success');
                        
                        // Atualizar contador do carrinho
                        if (response.totalItens > 0) {
                            $('#cart-count').text(response.totalItens).show();
                        } else {
                            $('#cart-count').hide();
                        }
                        
                        // Animar botão
                        btn.html('<i class="fas fa-check"></i>').addClass('btn-success').removeClass('btn-primary');
                        
                        setTimeout(() => {
                            btn.html(originalHtml).removeClass('btn-success').addClass('btn-primary').prop('disabled', false);
                        }, 2000);
                    } else {
                        showNotification('Erro ao adicionar ao carrinho', 'error');
                        btn.html(originalHtml).prop('disabled', false);
                    }
                },
                error: function() {
                    showNotification('Erro de conexão', 'error');
                    btn.html(originalHtml).prop('disabled', false);
                }
            });
        }
        
        function atualizarContadorCarrinho() {
            <c:if test="${not empty sessionScope.usuarioId}">
                $.ajax({
                    url: '${pageContext.request.contextPath}/carrinho',
                    method: 'POST',
                    data: { acao: 'contar' },
                    dataType: 'json',
                    success: function(response) {
                        if (response.totalItens > 0) {
                            $('#cart-count').text(response.totalItens).show();
                        } else {
                            $('#cart-count').hide();
                        }
                    },
                    error: function() {
                        console.log('Erro ao buscar contador do carrinho');
                    }
                });
            </c:if>
        }
        
        function showNotification(message, type) {
            let alertClass, icon;
            
            switch(type) {
                case 'success':
                    alertClass = 'alert-success';
                    icon = 'fas fa-check-circle';
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
            
            // Remove alertas existentes
            $('.alert').remove();
            $('body').append(alertHtml);
            
            // Remove automaticamente após 3 segundos
            setTimeout(() => {
                $('.alert').fadeOut();
            }, 3000);
        }
        
        function animateOnScroll() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });
            
            // Animar cards de livros e categorias
            document.querySelectorAll('.book-card, .category-card').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'all 0.6s ease';
                observer.observe(el);
            });
        }
        
        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }
        
        // Contador animado de estatísticas
        function animateCounters() {
            $('.stat-number').each(function() {
                const $this = $(this);
                const countTo = parseInt($this.text().replace(/[^\d]/g, ''));
                
                $({ countNum: 0 }).animate({
                    countNum: countTo
                }, {
                    duration: 2000,
                    easing: 'swing',
                    step: function() {
                        const num = Math.floor(this.countNum);
                        const originalText = $this.text();
                        
                        if (originalText.includes('+')) {
                            $this.text(num.toLocaleString() + '+');
                        } else if (originalText.includes('%')) {
                            $this.text(num + '%');
                        } else if (originalText.includes('h')) {
                            $this.text(num + 'h');
                        } else {
                            $this.text(num.toLocaleString());
                        }
                    },
                    complete: function() {
                        const originalText = $this.text();
                        if (originalText.includes('+')) {
                            $this.text(countTo.toLocaleString() + '+');
                        } else if (originalText.includes('%')) {
                            $this.text(countTo + '%');
                        } else if (originalText.includes('h')) {
                            $this.text(countTo + 'h');
                        } else {
                            $this.text(countTo.toLocaleString());
                        }
                    }
                });
            });
        }
        
        // Ativar animação dos contadores quando a seção de stats estiver visível
        const statsObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    animateCounters();
                    statsObserver.unobserve(entry.target);
                }
            });
        });
        
        const statsSection = document.querySelector('.stats-section');
        if (statsSection) {
            statsObserver.observe(statsSection);
        }
        
        // Busca com auto-complete (opcional)
        $('input[name="busca"]').on('input', function() {
            const termo = $(this).val();
            if (termo.length >= 3) {
                // Implementar sugestões de busca aqui
                // $.ajax({ ... });
            }
        });
        
        // Smooth scroll para âncoras
        $('a[href^="#"]').on('click', function(e) {
            e.preventDefault();
            const target = $(this.getAttribute('href'));
            if (target.length) {
                $('html, body').animate({
                    scrollTop: target.offset().top - 80
                }, 800);
            }
        });
        
        // Efeito paralaxe no hero
        $(window).scroll(function() {
            const scrolled = $(this).scrollTop();
            const rate = scrolled * -0.5;
            $('.hero-section').css('transform', `translate3d(0, ${rate}px, 0)`);
        });
        
        // Lazy loading para imagens
        if ('IntersectionObserver' in window) {
            const imageObserver = new IntersectionObserver((entries, observer) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        const img = entry.target;
                        img.src = img.dataset.src || img.src;
                        img.classList.remove('lazy');
                        imageObserver.unobserve(img);
                    }
                });
            });
            
            document.querySelectorAll('img[data-src]').forEach(img => {
                imageObserver.observe(img);
            });
        }
        
        // Prevenção de double-click nos botões
        $('.btn').on('click', function() {
            const btn = $(this);
            if (btn.hasClass('processing')) {
                return false;
            }
            btn.addClass('processing');
            setTimeout(() => {
                btn.removeClass('processing');
            }, 1000);
        });
        
        // Melhorar UX do carrinho
        function updateCartUI() {
            <c:if test="${not empty sessionScope.usuarioId}">
                // Atualizar periodicamente o contador do carrinho
                setInterval(atualizarContadorCarrinho, 30000); // A cada 30 segundos
            </c:if>
        }
        
        // Inicializar melhorias de UX
        updateCartUI();
        
        // Animação de entrada da página
        $(window).on('load', function() {
            $('.hero-section h1').addClass('animate__animated animate__fadeInLeft');
            $('.hero-section p').addClass('animate__animated animate__fadeInLeft animate__delay-1s');
            $('.search-box').addClass('animate__animated animate__fadeInUp animate__delay-2s');
        });
        
        // Tooltip para botões desabilitados
        $('[data-bs-toggle="tooltip"]').tooltip();
        
        // Feedback visual melhorado
        $('.btn-add-cart').hover(
            function() {
                if (!$(this).prop('disabled')) {
                    $(this).find('i').addClass('fa-bounce');
                }
            },
            function() {
                $(this).find('i').removeClass('fa-bounce');
            }
        );
        
        // Confirmação de ações importantes
        $('.btn-danger').on('click', function(e) {
            if (!confirm('Tem certeza que deseja realizar esta ação?')) {
                e.preventDefault();
                return false;
            }
        });
        
        // Melhorar acessibilidade
        $('.book-card').on('keypress', function(e) {
            if (e.which === 13) { // Enter key
                $(this).find('a').first()[0].click();
            }
        });
        
        // Auto-hide de notificações após tempo
        $(document).on('shown.bs.alert', '.alert', function() {
            const alert = $(this);
            setTimeout(() => {
                alert.fadeOut('slow', function() {
                    $(this).remove();
                });
            }, 5000);
        });
    </script>
</body>
</html>