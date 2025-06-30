<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meus Pedidos - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .pedido-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 1.5rem;
        }
        
        .pedido-header {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 1rem;
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .pedido-status {
            font-weight: bold;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.9rem;
        }
        
        .status-pendente {
            background-color: #ffc107;
            color: #343a40;
        }
        
        .status-processando {
            background-color: #17a2b8;
            color: white;
        }
        
        .status-enviado {
            background-color: #007bff;
            color: white;
        }
        
        .status-entregue {
            background-color: #28a745;
            color: white;
        }
        
        .status-cancelado {
            background-color: #dc3545;
            color: white;
        }
        
        .item-pedido {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding-bottom: 1rem;
            border-bottom: 1px dashed #e9ecef;
        }
        
        .item-pedido:last-child {
            border-bottom: none;
            margin-bottom: 0;
            padding-bottom: 0;
        }
        
        .item-img {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1rem;
        }
        
        .item-details {
            flex-grow: 1;
        }
        
        .item-titulo {
            font-weight: bold;
            margin-bottom: 0.2rem;
        }
        
        .item-quantidade {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .item-preco {
            font-weight: bold;
            color: #28a745;
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
        <h2 class="mb-4"><i class="fas fa-box me-3"></i>Meus Pedidos</h2>
        
        <c:choose>
            <c:when test="${empty pedidos}">
                <div class="alert alert-info text-center py-5" role="alert">
                    <i class="fas fa-box-open fa-5x text-muted mb-3"></i>
                    <h3>Você ainda não fez nenhum pedido.</h3>
                    <p class="lead">Que tal explorar nosso catálogo e encontrar seu próximo livro?</p>
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary btn-lg">
                        <i class="fas fa-book me-2"></i>Explorar Livros
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${pedidos}" var="pedido">
                    <div class="pedido-card">
                        <div class="pedido-header">
                            <div>
                                <h5 class="mb-0">Pedido #${pedido.id}</h5>
                                <small class="text-muted">Data: <fmt:formatDate value="${pedido.dataPedido}" pattern="dd/MM/yyyy HH:mm"/></small>
                            </div>
                            <span class="pedido-status 
                                <c:choose>
                                    <c:when test="${pedido.status == 'PENDENTE'}">status-pendente</c:when>
                                    <c:when test="${pedido.status == 'PROCESSANDO'}">status-processando</c:when>
                                    <c:when test="${pedido.status == 'ENVIADO'}">status-enviado</c:when>
                                    <c:when test="${pedido.status == 'ENTREGUE'}">status-entregue</c:when>
                                    <c:when test="${pedido.status == 'CANCELADO'}">status-cancelado</c:when>
                                    <c:otherwise>badge-secondary</c:otherwise>
                                </c:choose>
                            ">
                                ${pedido.status}
                            </span>
                        </div>
                        
                        <h6>Itens do Pedido:</h6>
                        <div class="mb-3">
                            <c:forEach items="${pedido.itens}" var="item">
                                <div class="item-pedido">
                                    <img src="${item.livroCapa != null ? item.livroCapa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                         alt="${item.livroTitulo}" class="item-img">
                                    <div class="item-details">
                                        <div class="item-titulo">${item.livroTitulo}</div>
                                        <div class="item-quantidade">Qtd: ${item.quantidade}</div>
                                    </div>
                                    <div class="item-preco">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$ "/>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <h5>Total do Pedido:</h5>
                            <h5><fmt:formatNumber value="${pedido.valorTotal}" type="currency" currencySymbol="R$ "/></h5>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
</body>
</html>