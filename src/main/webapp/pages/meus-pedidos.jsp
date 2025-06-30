<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.Locale" %>
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
            transition: transform 0.3s ease;
        }
        
        .pedido-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
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
            color: #343a40;
        }
        
        .item-autor {
            color: #6c757d;
            font-size: 0.9rem;
            margin-bottom: 0.2rem;
        }
        
        .item-quantidade {
            font-size: 0.9rem;
            color: #6c757d;
        }
        
        .item-preco {
            font-weight: bold;
            color: #28a745;
            text-align: right;
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
        
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
            color: #6c757d;
        }
        
        .empty-state i {
            font-size: 5rem;
            margin-bottom: 2rem;
            opacity: 0.3;
        }
        
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 0.5rem;
            top: 0;
            bottom: 0;
            width: 2px;
            background: #e9ecef;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 1rem;
        }
        
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -0.8rem;
            top: 0.2rem;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: #28a745;
            border: 2px solid white;
            box-shadow: 0 0 0 2px #28a745;
        }
        
        .timeline-item.inactive::before {
            background: #e9ecef;
            box-shadow: 0 0 0 2px #e9ecef;
        }
        
        .btn-details {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-details:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
                                <span class="cart-badge">${sessionScope.totalItensCarrinho}</span>
                            </c:if>
                        </a>
                    </div>
                    
                    <div class="dropdown">
                        <button class="btn btn-outline-light dropdown-toggle" type="button" data-bs-toggle="dropdown">
                            <i class="fas fa-user me-1"></i>${sessionScope.usuarioNome}
                        </button>
                        <ul class="dropdown-menu">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/perfil">
                                <i class="fas fa-user-edit me-2"></i>Meu Perfil
                            </a></li>
                            <li><a class="dropdown-item active" href="${pageContext.request.contextPath}/meus-pedidos">
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
        </div>
    </nav>

    <!-- Conteúdo Principal -->
    <div class="container py-5">
        <div class="row">
            <div class="col-12">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h2><i class="fas fa-box me-3 text-primary"></i>Meus Pedidos</h2>
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Fazer Novo Pedido
                    </a>
                </div>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty pedidos}">
                <!-- Estado Vazio -->
                <div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>Você ainda não fez nenhum pedido</h3>
                    <p class="lead mb-4">Que tal explorar nosso catálogo e encontrar seu próximo livro favorito?</p>
                    <a href="${pageContext.request.contextPath}/livros" class="btn btn-primary btn-lg">
                        <i class="fas fa-book me-2"></i>Explorar Livros
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Lista de Pedidos -->
                <div class="row">
                    <c:forEach items="${pedidos}" var="pedido">
                        <div class="col-12">
                            <div class="pedido-card">
                                <!-- Header do Pedido -->
                                <div class="pedido-header">
                                    <div>
                                        <h5 class="mb-1">
                                            <i class="fas fa-receipt text-primary me-2"></i>
                                            Pedido #${pedido.numeroPedido}
                                        </h5>
                                        <small class="text-muted">
                                            <i class="fas fa-calendar me-1"></i>
                                            <%
                                                // Formatação da data do pedido
                                                br.com.livraria.model.Pedido pedidoAtual = (br.com.livraria.model.Pedido) pageContext.getAttribute("pedido");
                                                if (pedidoAtual != null && pedidoAtual.getDataPedido() != null) {
                                                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm", new Locale("pt", "BR"));
                                                    pageContext.setAttribute("dataFormatada", pedidoAtual.getDataPedido().format(formatter));
                                                }
                                            %>
                                            ${not empty dataFormatada ? dataFormatada : pedido.dataPedido}
                                        </small>
                                    </div>
                                    <div class="text-end">
                                        <span class="pedido-status 
                                            <c:choose>
                                                <c:when test="${pedido.status == 'pendente'}">status-pendente</c:when>
                                                <c:when test="${pedido.status == 'processando'}">status-processando</c:when>
                                                <c:when test="${pedido.status == 'enviado'}">status-enviado</c:when>
                                                <c:when test="${pedido.status == 'entregue'}">status-entregue</c:when>
                                                <c:when test="${pedido.status == 'cancelado'}">status-cancelado</c:when>
                                                <c:otherwise>status-pendente</c:otherwise>
                                            </c:choose>
                                        ">
                                            <c:choose>
                                                <c:when test="${pedido.status == 'pendente'}">
                                                    <i class="fas fa-clock me-1"></i>Pendente
                                                </c:when>
                                                <c:when test="${pedido.status == 'processando'}">
                                                    <i class="fas fa-cog fa-spin me-1"></i>Processando
                                                </c:when>
                                                <c:when test="${pedido.status == 'enviado'}">
                                                    <i class="fas fa-truck me-1"></i>Enviado
                                                </c:when>
                                                <c:when test="${pedido.status == 'entregue'}">
                                                    <i class="fas fa-check-circle me-1"></i>Entregue
                                                </c:when>
                                                <c:when test="${pedido.status == 'cancelado'}">
                                                    <i class="fas fa-times-circle me-1"></i>Cancelado
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-clock me-1"></i>Pendente
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                        <div class="mt-1">
                                            <small class="text-muted">${pedido.totalItens} item(s)</small>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Timeline do Status -->
                                <c:if test="${pedido.status != 'cancelado'}">
                                    <div class="mb-4">
                                        <h6 class="mb-3">Status do Pedido:</h6>
                                        <div class="timeline">
                                            <div class="timeline-item ${pedido.status == 'pendente' || pedido.status == 'processando' || pedido.status == 'enviado' || pedido.status == 'entregue' ? '' : 'inactive'}">
                                                <strong>Pedido Confirmado</strong>
                                                <small class="d-block text-muted">Seu pedido foi recebido</small>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'processando' || pedido.status == 'enviado' || pedido.status == 'entregue' ? '' : 'inactive'}">
                                                <strong>Em Preparação</strong>
                                                <small class="d-block text-muted">Separando os livros</small>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'enviado' || pedido.status == 'entregue' ? '' : 'inactive'}">
                                                <strong>Enviado</strong>
                                                <small class="d-block text-muted">
                                                    <c:if test="${not empty pedido.codigoRastreio}">
                                                        Código: ${pedido.codigoRastreio}
                                                    </c:if>
                                                </small>
                                            </div>
                                            <div class="timeline-item ${pedido.status == 'entregue' ? '' : 'inactive'}">
                                                <strong>Entregue</strong>
                                                <small class="d-block text-muted">Pedido finalizado</small>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                                
                                <!-- Itens do Pedido -->
                                <div class="mb-4">
                                    <h6 class="mb-3">Itens do Pedido:</h6>
                                    <c:forEach items="${pedido.itens}" var="item">
                                        <div class="item-pedido">
                                            <img src="${item.livroCapa != null ? item.livroCapa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                                 alt="${item.livroTitulo}" class="item-img">
                                            <div class="item-details">
                                                <div class="item-titulo">${item.livroTitulo}</div>
                                                <div class="item-autor">por ${item.livroAutor}</div>
                                                <div class="item-quantidade">Quantidade: ${item.quantidade}</div>
                                            </div>
                                            <div class="item-preco">
                                                <div class="fw-bold">
                                                    <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$ "/>
                                                </div>
                                                <small class="text-muted">
                                                    <fmt:formatNumber value="${item.precoUnitario}" type="currency" currencySymbol="R$ "/> cada
                                                </small>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                
                                <!-- Resumo do Pedido -->
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6>Endereço de Entrega:</h6>
                                        <p class="text-muted mb-3">${pedido.enderecoEntrega}</p>
                                        
                                        <c:if test="${not empty pedido.codigoRastreio}">
                                            <h6>Código de Rastreamento:</h6>
                                            <p class="mb-3">
                                                <code>${pedido.codigoRastreio}</code>
                                                <a href="#" class="btn btn-sm btn-outline-primary ms-2" onclick="rastrearPedido('${pedido.codigoRastreio}')">
                                                    <i class="fas fa-search me-1"></i>Rastrear
                                                </a>
                                            </p>
                                        </c:if>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="text-end">
                                            <c:if test="${pedido.desconto > 0}">
                                                <div class="d-flex justify-content-between">
                                                    <span>Subtotal:</span>
                                                    <span><fmt:formatNumber value="${pedido.total + pedido.desconto}" type="currency" currencySymbol="R$ "/></span>
                                                </div>
                                                <div class="d-flex justify-content-between text-success">
                                                    <span>Desconto:</span>
                                                    <span>- <fmt:formatNumber value="${pedido.desconto}" type="currency" currencySymbol="R$ "/></span>
                                                </div>
                                                <hr>
                                            </c:if>
                                            <div class="d-flex justify-content-between">
                                                <h5>Total:</h5>
                                                <h5 class="text-primary">
                                                    <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ "/>
                                                </h5>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <!-- Ações -->
                                <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                                    <div>
                                        <c:if test="${pedido.status == 'entregue'}">
                                            <button class="btn btn-outline-success btn-sm me-2" onclick="avaliarPedido('${pedido.id}')">
                                                <i class="fas fa-star me-1"></i>Avaliar Compra
                                            </button>
                                        </c:if>
                                        
                                        <c:if test="${pedido.status == 'pendente'}">
                                            <button class="btn btn-outline-danger btn-sm" onclick="cancelarPedido('${pedido.id}')">
                                                <i class="fas fa-times me-1"></i>Cancelar Pedido
                                            </button>
                                        </c:if>
                                    </div>
                                    
                                    <div>
                                        <button class="btn btn-details btn-sm" onclick="verDetalhes('${pedido.numeroPedido}')">
                                            <i class="fas fa-eye me-1"></i>Ver Detalhes
                                        </button>
                                        
                                        <button class="btn btn-outline-primary btn-sm ms-2" onclick="comprarNovamente('${pedido.id}')">
                                            <i class="fas fa-redo me-1"></i>Comprar Novamente
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Animações de entrada
            $('.pedido-card').each(function(index) {
                $(this).delay(index * 100).queue(function() {
                    $(this).addClass('animate__animated animate__fadeInUp');
                    $(this).dequeue();
                });
            });
        });
        
        function rastrearPedido(codigo) {
            const url = `https://www.correios.com.br/precos-e-prazos/rastreamento?objeto=${codigo}`;
            window.open(url, '_blank');
        }
        
        function avaliarPedido(pedidoId) {
            window.location.href = `${pageContext.request.contextPath}/avaliar-pedido?id=${pedidoId}`;
        }
        
        function cancelarPedido(pedidoId) {
            if (confirm('Tem certeza que deseja cancelar este pedido?')) {
                // Implementar cancelamento via AJAX
                showNotification('Pedido cancelado com sucesso!', 'success');
            }
        }
        
        function verDetalhes(numeroPedido) {
            window.location.href = `${pageContext.request.contextPath}/pedido-detalhes?numero=${numeroPedido}`;
        }
        
        function comprarNovamente(pedidoId) {
            if (confirm('Deseja adicionar todos os itens deste pedido ao seu carrinho?')) {
                // Implementar via AJAX
                showNotification('Itens adicionados ao carrinho!', 'success');
            }
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
            
            $('.alert').remove();
            $('body').append(alertHtml);
            
            setTimeout(() => {
                $('.alert').fadeOut();
            }, 3000);
        }
    </script>
</body>
</html>