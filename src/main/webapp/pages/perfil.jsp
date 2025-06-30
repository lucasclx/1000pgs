<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Meu Perfil - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        
        .profile-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            padding: 2rem;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #667eea;
            padding: 3px;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 16px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .btn-primary {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            padding: 12px 25px;
            font-weight: 600;
            transition: transform 0.3s ease;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
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
        <h2 class="mb-4"><i class="fas fa-user-circle me-3"></i>Meu Perfil</h2>
        
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="profile-card">
                    <div class="text-center mb-4">
                        <img src="https://via.placeholder.com/120/667eea/FFFFFF?text=User" alt="Avatar do Usuário" class="profile-avatar mb-3">
                        <h3>${usuario.nome}</h3>
                        <p class="text-muted">${usuario.email}</p>
                    </div>
                    
                    <c:if test="${not empty sucesso}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sucesso}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty erro}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${erro}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form method="post" action="${pageContext.request.contextPath}/perfil">
                        <div class="mb-3">
                            <label for="nome" class="form-label">Nome Completo</label>
                            <input type="text" class="form-control" id="nome" name="nome" value="${usuario.nome}" required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" name="email" value="${usuario.email}" required>
                        </div>
                        <div class="mb-3">
                            <label for="telefone" class="form-label">Telefone</label>
                            <input type="text" class="form-control" id="telefone" name="telefone" value="${usuario.telefone}">
                        </div>
                        <div class="mb-3">
                            <label for="endereco" class="form-label">Endereço</label>
                            <input type="text" class="form-control" id="endereco" name="endereco" value="${usuario.endereco}">
                        </div>
                        <div class="mb-3">
                            <label for="cep" class="form-label">CEP</label>
                            <input type="text" class="form-control" id="cep" name="cep" value="${usuario.cep}">
                        </div>
                        
                        <h4 class="mt-5 mb-3">Alterar Senha</h4>
                        <div class="mb-3">
                            <label for="senhaAtual" class="form-label">Senha Atual</label>
                            <input type="password" class="form-control" id="senhaAtual" name="senhaAtual">
                        </div>
                        <div class="mb-3">
                            <label for="novaSenha" class="form-label">Nova Senha</label>
                            <input type="password" class="form-control" id="novaSenha" name="novaSenha">
                        </div>
                        <div class="mb-4">
                            <label for="confirmarNovaSenha" class="form-label">Confirmar Nova Senha</label>
                            <input type="password" class="form-control" id="confirmarNovaSenha" name="confirmarNovaSenha">
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-100">Salvar Alterações</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Máscara para telefone (ex: (99) 99999-9999)
            $('#telefone').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                if (value.length > 10) {
                    value = value.replace(/^(\d{2})(\d{5})(\d{4}).*/, '($1) $2-$3');
                } else if (value.length > 5) {
                    value = value.replace(/^(\d{2})(\d{4})(\d{0,4}).*/, '($1) $2-$3');
                } else if (value.length > 2) {
                    value = value.replace(/^(\d{2})(\d{0,5}).*/, '($1) $2');
                } else {
                    value = value.replace(/^(\d*)/, '($1');
                }
                $(this).val(value);
            });

            // Máscara para CEP
            $('#cep').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                value = value.replace(/^(?:(\d{5}))?(\d{3})?$/, '$1-$2');
                $(this).val(value);
            });

            // Validação do formulário
            $('form').on('submit', function(e) {
                const nome = $('#nome').val().trim();
                const email = $('#email').val().trim();
                const senhaAtual = $('#senhaAtual').val();
                const novaSenha = $('#novaSenha').val();
                const confirmarNovaSenha = $('#confirmarNovaSenha').val();

                if (!nome) {
                    e.preventDefault();
                    showError('Por favor, informe seu nome completo.');
                    $('#nome').focus();
                    return false;
                }

                if (!email) {
                    e.preventDefault();
                    showError('Por favor, informe seu email.');
                    $('#email').focus();
                    return false;
                }

                if (!isValidEmail(email)) {
                    e.preventDefault();
                    showError('Por favor, informe um email válido.');
                    $('#email').focus();
                    return false;
                }

                // Validação de alteração de senha
                if (novaSenha || confirmarNovaSenha) { // Se uma das novas senhas for preenchida
                    if (!senhaAtual) {
                        e.preventDefault();
                        showError('Para alterar a senha, informe sua senha atual.');
                        $('#senhaAtual').focus();
                        return false;
                    }
                    if (novaSenha.length < 6) {
                        e.preventDefault();
                        showError('A nova senha deve ter pelo menos 6 caracteres.');
                        $('#novaSenha').focus();
                        return false;
                    }
                    if (novaSenha !== confirmarNovaSenha) {
                        e.preventDefault();
                        showError('A nova senha e a confirmação não coincidem.');
                        $('#confirmarNovaSenha').focus();
                        return false;
                    }
                }
            });
        });

        function isValidEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function showError(message) {
            $('.alert').remove(); // Remove alertas anteriores
            const alertHtml = `
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            $('.profile-card').prepend(alertHtml);
        }
    </script>
</body>
</html>