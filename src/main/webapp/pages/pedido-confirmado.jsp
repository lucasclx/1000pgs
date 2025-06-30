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
    <title>Pedido Confirmado - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 3rem 0;
            text-align: center;
        }
        
        .success-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }
        
        .pedido-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .item-pedido {
            display: flex;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .item-pedido:last-child {
            border-bottom: none;
        }
        
        .item-img {
            width: 80px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
            margin-right: 1rem;
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
            background: #28a745;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 1.5rem;
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
        
        .btn-action {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Header de Sucesso -->
    <div class="success-header">
        <div class="container">
            <i class="fas fa-check-circle success-icon"></i>
            <h1 class="display-4 fw-bold">Pedido Confirmado!</h1>
            <p class="lead">Obrigado por escolher nossa livraria. Seu pedido foi processado com sucesso!</p>
        </div>
    </div>

    <!-- Conteúdo Principal -->
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- Informações do Pedido -->
                <div class="pedido-card">
                    <div class="text-center mb-4">
                        <h3 class="text-primary">
                            <i class="fas fa-receipt me-2"></i>
                            Pedido #${pedido.numeroPedido}
                        </h3>
                        <p class="text-muted mb-0">
                            Realizado em 
                            <c:choose>
                                <c:when test="${not empty pedido.dataPedido}">
                                    <%
                                        // Formatação manual da data
                                        java.time.LocalDateTime dataPedido = (java.time.LocalDateTime) pageContext.getAttribute("dataPedido");
                                        if (dataPedido == null) {
                                            dataPedido = ((br.com.livraria.model.Pedido) request.getAttribute("pedido")).getDataPedido();
                                        }
                                        if (dataPedido != null) {
                                            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy 'às' HH:mm", new Locale("pt", "BR"));
                                            pageContext.setAttribute("dataFormatada", dataPedido.format(formatter));
                                        }
                                    %>
                                    ${dataFormatada}
                                </c:when>
                                <c:otherwise>
                                    ${pedido.dataPedido}
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <!-- Status e Rastreamento -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-info-circle text-primary me-2"></i>
                                <strong>Status:</strong>
                                <span class="badge bg-success ms-2">Confirmado</span>
                            </div>
                            
                            <c:if test="${not empty pedido.codigoRastreio}">
                                <div class="d-flex align-items-center">
                                    <i class="fas fa-truck text-primary me-2"></i>
                                    <strong>Código de Rastreamento:</strong>
                                    <code class="ms-2">${pedido.codigoRastreio}</code>
                                </div>
                            </c:if>
                        </div>
                        <div class="col-md-6">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-credit-card text-primary me-2"></i>
                                <strong>Total:</strong>
                                <span class="fs-4 text-success ms-2">
                                    <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ "/>
                                </span>
                            </div>
                            
                            <div class="d-flex align-items-center">
                                <i class="fas fa-box text-primary me-2"></i>
                                <strong>Itens:</strong>
                                <span class="ms-2">${pedido.totalItens} livro(s)</span>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Endereço de Entrega -->
                    <div class="mb-4">
                        <h5><i class="fas fa-map-marker-alt text-primary me-2"></i>Endereço de Entrega</h5>
                        <p class="text-muted mb-0">${pedido.enderecoEntrega}</p>
                    </div>
                    
                    <!-- Itens do Pedido -->
                    <div class="mb-4">
                        <h5><i class="fas fa-list text-primary me-2"></i>Itens do Pedido</h5>
                        <c:forEach items="${pedido.itens}" var="item">
                            <div class="item-pedido">
                                <img src="${item.livroCapa != null ? item.livroCapa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                     alt="${item.livroTitulo}" class="item-img">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${item.livroTitulo}</h6>
                                    <p class="text-muted mb-1">por ${item.livroAutor}</p>
                                    <small class="text-muted">Quantidade: ${item.quantidade}</small>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold text-success">
                                        <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$ "/>
                                    </div>
                                    <small class="text-muted">
                                        <fmt:formatNumber value="${item.precoUnitario}" type="currency" currencySymbol="R$ "/> cada
                                    </small>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Resumo Financeiro -->
                    <div class="border-top pt-3">
                        <div class="row">
                            <div class="col-md-6">
                                <!-- Timeline de Entrega -->
                                <h6>Próximos Passos:</h6>
                                <div class="timeline">
                                    <div class="timeline-item">
                                        <strong>Confirmação do Pagamento</strong>
                                        <small class="d-block text-muted">Em até 1 hora</small>
                                    </div>
                                    <div class="timeline-item">
                                        <strong>Preparação do Pedido</strong>
                                        <small class="d-block text-muted">1-2 dias úteis</small>
                                    </div>
                                    <div class="timeline-item">
                                        <strong>Envio</strong>
                                        <small class="d-block text-muted">Código de rastreamento será enviado</small>
                                    </div>
                                    <div class="timeline-item">
                                        <strong>Entrega</strong>
                                        <small class="d-block text-muted">5-7 dias úteis</small>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-end">
                                    <c:if test="${pedido.desconto > 0}">
                                        <div class="d-flex justify-content-between mb-2">
                                            <span>Subtotal:</span>
                                            <span><fmt:formatNumber value="${pedido.total + pedido.desconto}" type="currency" currencySymbol="R$ "/></span>
                                        </div>
                                        <div class="d-flex justify-content-between mb-2 text-success">
                                            <span>Desconto:</span>
                                            <span>- <fmt:formatNumber value="${pedido.desconto}" type="currency" currencySymbol="R$ "/></span>
                                        </div>
                                        <hr>
                                    </c:if>
                                    
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>Frete:</span>
                                        <span class="text-success">GRÁTIS</span>
                                    </div>
                                    
                                    <hr>
                                    
                                    <div class="d-flex justify-content-between">
                                        <h5>Total:</h5>
                                        <h5 class="text-success">
                                            <fmt:formatNumber value="${pedido.total}" type="currency" currencySymbol="R$ "/>
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Ações -->
                <div class="text-center">
                    <div class="row g-3">
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/meus-pedidos" class="btn btn-outline-primary w-100">
                                <i class="fas fa-list me-2"></i>Meus Pedidos
                            </a>
                        </div>
                        <div class="col-md-3">
                            <c:if test="${not empty pedido.codigoRastreio}">
                                <button class="btn btn-outline-info w-100" onclick="rastrearPedido('${pedido.codigoRastreio}')">
                                    <i class="fas fa-search me-2"></i>Rastrear
                                </button>
                            </c:if>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-outline-success w-100" onclick="compartilhar()">
                                <i class="fas fa-share me-2"></i>Compartilhar
                            </button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/livros" class="btn btn-action w-100">
                                <i class="fas fa-book me-2"></i>Continuar Comprando
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Informações Adicionais -->
                <div class="pedido-card mt-4">
                    <h5 class="text-primary mb-3">
                        <i class="fas fa-info-circle me-2"></i>Informações Importantes
                    </h5>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6><i class="fas fa-envelope text-primary me-2"></i>Confirmação por Email</h6>
                                <p class="small text-muted mb-0">
                                    Um email de confirmação foi enviado para ${sessionScope.usuarioNome} 
                                    com todos os detalhes do seu pedido.
                                </p>
                            </div>
                            
                            <div class="mb-3">
                                <h6><i class="fas fa-truck text-primary me-2"></i>Prazo de Entrega</h6>
                                <p class="small text-muted mb-0">
                                    Seu pedido será entregue em 5-7 dias úteis. 
                                    Você receberá o código de rastreamento assim que o produto for despachado.
                                </p>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <h6><i class="fas fa-shield-alt text-primary me-2"></i>Garantia</h6>
                                <p class="small text-muted mb-0">
                                    Todos os nossos livros possuem garantia de qualidade. 
                                    Caso haja algum problema, entre em contato conosco.
                                </p>
                            </div>
                            
                            <div class="mb-3">
                                <h6><i class="fas fa-undo text-primary me-2"></i>Política de Troca</h6>
                                <p class="small text-muted mb-0">
                                    Você tem até 30 dias para solicitar troca ou devolução, 
                                    conforme nossos termos e condições.
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Sugestões -->
                <div class="pedido-card">
                    <h5 class="text-primary mb-3">
                        <i class="fas fa-heart me-2"></i>Que tal estes livros também?
                    </h5>
                    <p class="text-muted">
                        Baseado em sua compra, selecionamos alguns livros que você pode gostar. 
                        <a href="${pageContext.request.contextPath}/livros" class="text-decoration-none">
                            Explore nosso catálogo completo
                        </a> e descubra sua próxima leitura!
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Animação de entrada
            $('.pedido-card').addClass('animate__animated animate__fadeInUp');
            
            // Confete de celebração (opcional)
            setTimeout(() => {
                showCelebration();
            }, 500);
        });
        
        function rastrearPedido(codigo) {
            // Integração com serviços de rastreamento
            const url = `https://www.correios.com.br/precos-e-prazos/rastreamento?objeto=${codigo}`;
            window.open(url, '_blank');
        }
        
        function compartilhar() {
            if (navigator.share) {
                navigator.share({
                    title: 'Minha Compra na Livraria Online',
                    text: 'Acabei de fazer uma compra incrível na Livraria Online!',
                    url: window.location.href
                });
            } else {
                alert('Compartilhamento realizado! Link copiado para área de transferência.');
                navigator.clipboard.writeText(window.location.href);
            }
        }
        
        function showCelebration() {
            // Efeito de confete simples
            const colors = ['#667eea', '#764ba2', '#28a745', '#ffc107', '#dc3545'];
            
            for (let i = 0; i < 30; i++) {
                setTimeout(() => {
                    createConfetti(colors[Math.floor(Math.random() * colors.length)]);
                }, i * 50);
            }
        }
        
        function createConfetti(color) {
            const confetti = $('<div>')
                .css({
                    position: 'fixed',
                    top: '-10px',
                    left: Math.random() * window.innerWidth + 'px',
                    width: '10px',
                    height: '10px',
                    backgroundColor: color,
                    borderRadius: '50%',
                    zIndex: 9999,
                    pointerEvents: 'none'
                })
                .appendTo('body');
            
            confetti.animate({
                top: window.innerHeight + 'px',
                left: '+=' + (Math.random() * 200 - 100) + 'px'
            }, 3000, function() {
                $(this).remove();
            });
        }
        
        // Auto-scroll suave para mostrar todo o conteúdo
        $('html, body').animate({
            scrollTop: 0
        }, 1000);
        
        // Salvar dados do pedido simplificado
        try {
            const pedidoData = {
                numero: '${pedido.numeroPedido}',
                total: '${pedido.total}',
                status: 'Confirmado',
                rastreamento: '${pedido.codigoRastreio}'
            };
            
            const pedidosOffline = JSON.parse(localStorage.getItem('pedidosOffline') || '[]');
            pedidosOffline.unshift(pedidoData);
            localStorage.setItem('pedidosOffline', JSON.stringify(pedidosOffline.slice(0, 10)));
        } catch (e) {
            console.log('Não foi possível salvar dados offline');
        }
    </script>
</body>
</html>