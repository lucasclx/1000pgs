<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
        }
        
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .login-header {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            padding: 3rem 2rem 2rem;
            text-align: center;
        }
        
        .login-form {
            padding: 2rem;
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
        
        .btn-login {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: transform 0.3s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .divider {
            position: relative;
            text-align: center;
            margin: 2rem 0;
        }
        
        .divider::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 1px;
            background: #dee2e6;
        }
        
        .divider span {
            background: white;
            padding: 0 1rem;
            color: #6c757d;
        }
        
        .social-login {
            display: flex;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        
        .btn-social {
            flex: 1;
            border-radius: 10px;
            padding: 12px;
            border: 2px solid #e9ecef;
            background: white;
            transition: all 0.3s ease;
        }
        
        .btn-social:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .floating-label {
            position: relative;
            margin-bottom: 1.5rem;
        }
        
        .floating-label input {
            padding-top: 1.5rem;
            padding-bottom: 0.5rem;
        }
        
        .floating-label label {
            position: absolute;
            top: 50%;
            left: 16px;
            transform: translateY(-50%);
            transition: all 0.3s ease;
            pointer-events: none;
            color: #6c757d;
        }
        
        .floating-label input:focus + label,
        .floating-label input:not(:placeholder-shown) + label {
            top: 0.5rem;
            font-size: 0.75rem;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-5 col-md-7">
                <div class="login-card">
                    <!-- Header -->
                    <div class="login-header">
                        <h2 class="mb-0">
                            <i class="fas fa-book-open me-2"></i>
                            Bem-vindo de volta!
                        </h2>
                        <p class="mb-0 mt-2 opacity-75">Entre em sua conta para continuar</p>
                    </div>
                    
                    <!-- Form -->
                    <div class="login-form">
                        <!-- Mensagens -->
                        <c:if test="${not empty erro}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>${erro}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty sucesso}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${sucesso}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <form method="post" id="loginForm">
                            <div class="floating-label">
                                <input type="email" class="form-control" id="email" name="email" 
                                       placeholder=" " required>
                                <label for="email">
                                    <i class="fas fa-envelope me-2"></i>Email
                                </label>
                            </div>
                            
                            <div class="floating-label">
                                <input type="password" class="form-control" id="senha" name="senha" 
                                       placeholder=" " required>
                                <label for="senha">
                                    <i class="fas fa-lock me-2"></i>Senha
                                </label>
                            </div>
                            
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="lembrar">
                                    <label class="form-check-label" for="lembrar">
                                        Lembrar-me
                                    </label>
                                </div>
                                <a href="#" class="text-decoration-none">
                                    Esqueceu a senha?
                                </a>
                            </div>
                            
                            <button type="submit" class="btn btn-primary btn-login w-100 mb-3">
                                <i class="fas fa-sign-in-alt me-2"></i>Entrar
                            </button>
                        </form>
                        
                        <div class="divider">
                            <span>ou continue com</span>
                        </div>
                        
                        <div class="social-login">
                            <button class="btn btn-social">
                                <i class="fab fa-google text-danger"></i>
                            </button>
                            <button class="btn btn-social">
                                <i class="fab fa-facebook text-primary"></i>
                            </button>
                            <button class="btn btn-social">
                                <i class="fab fa-twitter text-info"></i>
                            </button>
                        </div>
                        
                        <div class="text-center">
                            <p class="mb-0">
                                Não tem uma conta? 
                                <a href="${pageContext.request.contextPath}/cadastro" class="text-decoration-none fw-bold">
                                    Cadastre-se aqui
                                </a>
                            </p>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>Voltar ao site
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Validação do formulário
            $('#loginForm').on('submit', function(e) {
                const email = $('#email').val().trim();
                const senha = $('#senha').val();
                
                if (!email) {
                    e.preventDefault();
                    showError('Por favor, informe seu email');
                    $('#email').focus();
                    return false;
                }
                
                if (!isValidEmail(email)) {
                    e.preventDefault();
                    showError('Por favor, informe um email válido');
                    $('#email').focus();
                    return false;
                }
                
                if (!senha) {
                    e.preventDefault();
                    showError('Por favor, informe sua senha');
                    $('#senha').focus();
                    return false;
                }
                
                if (senha.length < 6) {
                    e.preventDefault();
                    showError('A senha deve ter pelo menos 6 caracteres');
                    $('#senha').focus();
                    return false;
                }
            });
            
            // Efeito de foco nos inputs
            $('.form-control').on('focus', function() {
                $(this).parent().addClass('focused');
            });
            
            $('.form-control').on('blur', function() {
                if (!$(this).val()) {
                    $(this).parent().removeClass('focused');
                }
            });
            
            // Mostrar/ocultar senha
            $('<button type="button" class="btn btn-outline-secondary position-absolute end-0 top-50 translate-middle-y me-2" style="border: none; background: none;"><i class="fas fa-eye"></i></button>')
                .insertAfter('#senha')
                .on('click', function() {
                    const senhaInput = $('#senha');
                    const icon = $(this).find('i');
                    
                    if (senhaInput.attr('type') === 'password') {
                        senhaInput.attr('type', 'text');
                        icon.removeClass('fa-eye').addClass('fa-eye-slash');
                    } else {
                        senhaInput.attr('type', 'password');
                        icon.removeClass('fa-eye-slash').addClass('fa-eye');
                    }
                });
        });
        
        function isValidEmail(email) {
            const emailRegex = /^[^
@]+@[^
@]+\.[^
@]+$/;
            return emailRegex.test(email);
        }
        
        function showError(message) {
            // Remove alertas existentes
            $('.alert').remove();
            
            const alertHtml = `
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            $('.login-form').prepend(alertHtml);
        }
        
        // Animações de entrada
        $(window).on('load', function() {
            $('.login-card').addClass('animate__animated animate__fadeInUp');
        });
    </script>
</body>
</html>