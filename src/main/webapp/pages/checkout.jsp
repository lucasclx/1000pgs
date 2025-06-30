<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finalizar Compra - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .checkout-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 3rem;
        }
        
        .step {
            display: flex;
            align-items: center;
            color: #6c757d;
        }
        
        .step.active {
            color: #667eea;
        }
        
        .step.completed {
            color: #28a745;
        }
        
        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            font-weight: bold;
        }
        
        .step.active .step-number {
            background: #667eea;
            color: white;
        }
        
        .step.completed .step-number {
            background: #28a745;
            color: white;
        }
        
        .step-line {
            width: 100px;
            height: 2px;
            background: #e9ecef;
            margin: 0 1rem;
        }
        
        .step.completed + .step-line {
            background: #28a745;
        }
        
        .form-section {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
        
        .resumo-compra {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            position: sticky;
            top: 20px;
        }
        
        .item-resumo {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .item-resumo:last-child {
            border-bottom: none;
        }
        
        .cupom-section {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        
        .payment-option {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-option:hover {
            border-color: #667eea;
        }
        
        .payment-option.selected {
            border-color: #667eea;
            background: #f8f9fa;
        }
        
        .btn-finalizar {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            border-radius: 50px;
            padding: 15px 30px;
            color: white;
            font-weight: bold;
            width: 100%;
            font-size: 1.1rem;
        }
        
        .btn-finalizar:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
    </style>
</head>
<body class="bg-light">
    <!-- Header -->
    <div class="checkout-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <h2><i class="fas fa-credit-card me-2"></i>Finalizar Compra</h2>
                <a href="${pageContext.request.contextPath}/carrinho" class="btn btn-outline-light">
                    <i class="fas fa-arrow-left me-1"></i>Voltar ao Carrinho
                </a>
            </div>
        </div>
    </div>

    <!-- Indicador de Passos -->
    <div class="container py-3">
        <div class="step-indicator">
            <div class="step completed">
                <div class="step-number">1</div>
                <span>Carrinho</span>
            </div>
            <div class="step-line"></div>
            <div class="step active">
                <div class="step-number">2</div>
                <span>Dados de Entrega</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-number">3</div>
                <span>Pagamento</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-number">4</div>
                <span>Confirmação</span>
            </div>
        </div>
    </div>

    <div class="container pb-5">
        <div class="row">
            <!-- Formulário de Checkout -->
            <div class="col-lg-8">
                <form method="post" id="checkoutForm">
                    <!-- Dados de Entrega -->
                    <div class="form-section">
                        <h4 class="mb-4">
                            <i class="fas fa-shipping-fast me-2 text-primary"></i>
                            Dados de Entrega
                        </h4>
                        
                        <div class="row">
                            <div class="col-md-8 mb-3">
                                <label for="endereco" class="form-label">Endereço *</label>
                                <input type="text" class="form-control" id="endereco" name="endereco" 
                                       placeholder="Rua, número, complemento" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="cep" class="form-label">CEP *</label>
                                <input type="text" class="form-control" id="cep" name="cep" 
                                       placeholder="00000-000" maxlength="9" required>
                            </div>
                            <div class="col-md-8 mb-3">
                                <label for="cidade" class="form-label">Cidade *</label>
                                <input type="text" class="form-control" id="cidade" name="cidade" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label for="estado" class="form-label">Estado *</label>
                                <select class="form-select" id="estado" name="estado" required>
                                    <option value="">Selecione</option>
                                    <option value="AC">Acre</option>
                                    <option value="AL">Alagoas</option>
                                    <option value="AP">Amapá</option>
                                    <option value="AM">Amazonas</option>
                                    <option value="BA">Bahia</option>
                                    <option value="CE">Ceará</option>
                                    <option value="DF">Distrito Federal</option>
                                    <option value="ES">Espírito Santo</option>
                                    <option value="GO">Goiás</option>
                                    <option value="MA">Maranhão</option>
                                    <option value="MT">Mato Grosso</option>
                                    <option value="MS">Mato Grosso do Sul</option>
                                    <option value="MG">Minas Gerais</option>
                                    <option value="PA">Pará</option>
                                    <option value="PB">Paraíba</option>
                                    <option value="PR">Paraná</option>
                                    <option value="PE">Pernambuco</option>
                                    <option value="PI">Piauí</option>
                                    <option value="RJ">Rio de Janeiro</option>
                                    <option value="RN">Rio Grande do Norte</option>
                                    <option value="RS">Rio Grande do Sul</option>
                                    <option value="RO">Rondônia</option>
                                    <option value="RR">Roraima</option>
                                    <option value="SC">Santa Catarina</option>
                                    <option value="SP">São Paulo</option>
                                    <option value="SE">Sergipe</option>
                                    <option value="TO">Tocantins</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Cupom de Desconto -->
                    <div class="form-section">
                        <h5 class="mb-3">
                            <i class="fas fa-ticket-alt me-2 text-success"></i>
                            Cupom de Desconto
                        </h5>
                        
                        <div class="row">
                            <div class="col-md-8">
                                <input type="text" class="form-control" id="cupom" name="cupom" 
                                       placeholder="Digite o código do cupom">
                            </div>
                            <div class="col-md-4">
                                <button type="button" class="btn btn-outline-success w-100" id="btn-validar-cupom">
                                    <i class="fas fa-check me-1"></i>Aplicar
                                </button>
                            </div>
                        </div>
                        
                        <div id="cupom-resultado" class="mt-2"></div>
                    </div>

                    <!-- Método de Pagamento -->
                    <div class="form-section">
                        <h4 class="mb-4">
                            <i class="fas fa-credit-card me-2 text-primary"></i>
                            Método de Pagamento
                        </h4>
                        
                        <div class="payment-option selected" data-payment="cartao">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-credit-card fa-2x text-primary me-3"></i>
                                <div>
                                    <h6 class="mb-1">Cartão de Crédito</h6>
                                    <small class="text-muted">Visa, Mastercard, Elo</small>
                                </div>
                                <div class="ms-auto">
                                    <i class="fas fa-check-circle text-success"></i>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-option" data-payment="pix">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-qrcode fa-2x text-info me-3"></i>
                                <div>
                                    <h6 class="mb-1">PIX</h6>
                                    <small class="text-muted">Pagamento instantâneo</small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="payment-option" data-payment="boleto">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-barcode fa-2x text-warning me-3"></i>
                                <div>
                                    <h6 class="mb-1">Boleto Bancário</h6>
                                    <small class="text-muted">Vencimento em 3 dias úteis</small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Detalhes do Cartão (mostrado apenas quando cartão selecionado) -->
                        <div id="cartao-detalhes" class="mt-3">
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label for="numero-cartao" class="form-label">Número do Cartão</label>
                                    <input type="text" class="form-control" id="numero-cartao" 
                                           placeholder="0000 0000 0000 0000" maxlength="19">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="text" class="form-control" id="cvv" 
                                           placeholder="000" maxlength="4">
                                </div>
                                <div class="col-md-8 mb-3">
                                    <label for="nome-cartao" class="form-label">Nome no Cartão</label>
                                    <input type="text" class="form-control" id="nome-cartao" 
                                           placeholder="Como impresso no cartão">
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label for="validade" class="form-label">Validade</label>
                                    <input type="text" class="form-control" id="validade" 
                                           placeholder="MM/AA" maxlength="5">
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Resumo da Compra -->
            <div class="col-lg-4">
                <div class="resumo-compra">
                    <h5 class="mb-4">
                        <i class="fas fa-receipt me-2"></i>Resumo da Compra
                    </h5>
                    
                    <!-- Itens -->
                    <c:forEach items="${itens}" var="item">
                        <div class="item-resumo">
                            <div class="d-flex align-items-center">
                                <img src="${item.livroCapa != null ? item.livroCapa : pageContext.request.contextPath}/img/livro-default.jpg" 
                                     alt="${item.livroTitulo}" class="me-2" style="width: 50px; height: 60px; object-fit: cover; border-radius: 5px;">
                                <div>
                                    <h6 class="mb-0 small">${item.livroTitulo}</h6>
                                    <small class="text-muted">Qtd: ${item.quantidade}</small>
                                </div>
                            </div>
                            <div class="text-end">
                                <fmt:formatNumber value="${item.subtotal}" type="currency" currencySymbol="R$ "/>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <hr>
                    
                    <!-- Valores -->
                    <div class="d-flex justify-content-between mb-2">
                        <span>Subtotal:</span>
                        <span id="subtotal-checkout">
                            <fmt:formatNumber value="${total}" type="currency" currencySymbol="R$ "/>
                        </span>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2" id="desconto-linha" style="display: none !important;">
                        <span>Desconto:</span>
                        <span class="text-success" id="desconto-valor">R$ 0,00</span>
                    </div>
                    
                    <div class="d-flex justify-content-between mb-2">
                        <span>Frete:</span>
                        <span class="text-success">GRÁTIS</span>
                    </div>
                    
                    <hr>
                    
                    <div class="d-flex justify-content-between mb-4">
                        <h5>Total:</h5>
                        <h5 id="total-checkout">
                            <fmt:formatNumber value="${total}" type="currency" currencySymbol="R$ "/>
                        </h5>
                    </div>
                    
                    <!-- Benefícios -->
                    <div class="mb-4">
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-shield-alt text-success me-2"></i>
                            <small>Compra 100% segura</small>
                        </div>
                        <div class="d-flex align-items-center mb-2">
                            <i class="fas fa-truck text-primary me-2"></i>
                            <small>Entrega em 5-7 dias úteis</small>
                        </div>
                        <div class="d-flex align-items-center">
                            <i class="fas fa-undo text-info me-2"></i>
                            <small>30 dias para troca</small>
                        </div>
                    </div>
                    
                    <button type="submit" form="checkoutForm" class="btn btn-finalizar">
                        <i class="fas fa-lock me-2"></i>Finalizar Compra
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Máscara para CEP
            $('#cep').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                value = value.replace(/^(?:(\d{5}))?(\d{3})?$/, '$1-$2');
                $(this).val(value);
                
                // Buscar endereço por CEP
                if (value.length === 9) {
                    buscarCEP(value);
                }
            });
            
            // Máscara para cartão
            $('#numero-cartao').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                value = value.replace(/(\d{4})(?=\d)/g, '$1 ');
                $(this).val(value);
            });
            
            // Máscara para validade
            $('#validade').on('input', function() {
                let value = $(this).val().replace(/\D/g, '');
                value = value.replace(/^(?:(\d{2}))?(\d{2})?$/, '$1/$2');
                $(this).val(value);
            });
            
            // Seleção do método de pagamento
            $('.payment-option').click(function() {
                $('.payment-option').removeClass('selected');
                $(this).addClass('selected');
                
                const paymentType = $(this).data('payment');
                
                if (paymentType === 'cartao') {
                    $('#cartao-detalhes').show();
                } else {
                    $('#cartao-detalhes').hide();
                }
            });
            
            // Validar cupom
            $('#btn-validar-cupom').click(function() {
                const cupom = $('#cupom').val().trim();
                const total = parseFloat('${total}');
                
                if (!cupom) {
                    showCupomResult('Digite um código de cupom', 'error');
                    return;
                }
                
                $.ajax({
                    url: '${pageContext.request.contextPath}/checkout',
                    method: 'POST',
                    data: {
                        acao: 'validar-cupom',
                        cupom: cupom,
                        valor: total
                    },
                    dataType: 'json',
                    success: function(response) {
                        if (response.valido) {
                            showCupomResult('Cupom aplicado: ' + response.descricao, 'success');
                            
                            // Mostrar desconto
                            $('#desconto-linha').show();
                            $('#desconto-valor').text('- R$ ' + response.desconto.toFixed(2).replace('.', ','));
                            $('#total-checkout').text('R$ ' + response.novoTotal.toFixed(2).replace('.', ','));
                            
                            // Desabilitar campo e botão
                            $('#cupom').prop('readonly', true);
                            $('#btn-validar-cupom').prop('disabled', true).html('<i class="fas fa-check me-1"></i>Aplicado');
                        } else {
                            showCupomResult(response.mensagem, 'error');
                        }
                    },
                    error: function() {
                        showCupomResult('Erro ao validar cupom', 'error');
                    }
                });
            });
            
            // Validação do formulário
            $('#checkoutForm').on('submit', function(e) {
                e.preventDefault();
                
                if (validarFormulario()) {
                    // Simular processamento
                    const btn = $('.btn-finalizar');
                    const originalText = btn.html();
                    
                    btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin me-2"></i>Processando...');
                    
                    setTimeout(() => {
                        this.submit();
                    }, 2000);
                }
            });
        });
        
        function buscarCEP(cep) {
            $.ajax({
                url: `https://viacep.com.br/ws/${cep.replace('-', '')}/json/`,
                method: 'GET',
                success: function(data) {
                    if (!data.erro) {
                        $('#endereco').val(data.logradouro);
                        $('#cidade').val(data.localidade);
                        $('#estado').val(data.uf);
                    }
                }
            });
        }
        
        function showCupomResult(message, type) {
            const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
            const icon = type === 'success' ? 'fas fa-check-circle' : 'fas fa-times-circle';
            
            $('#cupom-resultado').html(`
                <div class="alert ${alertClass} alert-sm">
                    <i class="${icon}" me-2></i>${message}
                </div>
            `);
        }
        
        function validarFormulario() {
            let isValid = true;
            
            // Validar endereço
            if (!$('#endereco').val().trim()) {
                showError('Por favor, informe o endereço de entrega');
                $('#endereco').focus();
                return false;
            }
            
            if (!$('#cep').val().trim() || $('#cep').val().length !== 9) {
                showError('Por favor, informe um CEP válido');
                $('#cep').focus();
                return false;
            }
            
            if (!$('#cidade').val().trim()) {
                showError('Por favor, informe a cidade');
                $('#cidade').focus();
                return false;
            }
            
            if (!$('#estado').val()) {
                showError('Por favor, selecione o estado');
                $('#estado').focus();
                return false;
            }
            
            // Validar pagamento se cartão selecionado
            const selectedPayment = $('.payment-option.selected').data('payment');
            if (selectedPayment === 'cartao') {
                if (!$('#numero-cartao').val().trim() || $('#numero-cartao').val().replace(/\s/g, '').length !== 16) {
                    showError('Por favor, informe um número de cartão válido');
                    $('#numero-cartao').focus();
                    return false;
                }
                
                if (!$('#cvv').val().trim() || $('#cvv').val().length < 3) {
                    showError('Por favor, informe o CVV do cartão');
                    $('#cvv').focus();
                    return false;
                }
                
                if (!$('#nome-cartao').val().trim()) {
                    showError('Por favor, informe o nome impresso no cartão');
                    $('#nome-cartao').focus();
                    return false;
                }
                
                if (!$('#validade').val().trim() || $('#validade').val().length !== 5) {
                    showError('Por favor, informe a validade do cartão');
                    $('#validade').focus();
                    return false;
                }
                
                // Validar se não está vencido
                const validade = $('#validade').val();
                const [mes, ano] = validade.split('/');
                const dataValidade = new Date('20' + ano, mes - 1);
                const agora = new Date();
                
                if (dataValidade < agora) {
                    showError('Cartão vencido. Verifique a data de validade');
                    $('#validade').focus();
                    return false;
                }
            }
            
            return true;
        }
        
        function showError(message) {
            const alertHtml = `
                <div class="alert alert-danger alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 9999; min-width: 350px;" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `;
            
            // Remove alertas existentes
            $('.alert-danger').remove();
            $('body').append(alertHtml);
            
            // Remove automaticamente após 5 segundos
            setTimeout(() => {
                $('.alert-danger').fadeOut();
            }, 5000);
        }
        
        // Animações e efeitos visuais
        $(window).on('load', function() {
            $('.form-section').each(function(index) {
                $(this).delay(index * 200).queue(function() {
                    $(this).addClass('animate__animated animate__fadeInUp');
                    $(this).dequeue();
                });
            });
        });
        
        // Auto-complete do endereço baseado em dados do usuário (se houver)
        $(document).ready(function() {
            // Aqui você pode preencher automaticamente com dados do perfil do usuário
            // Exemplo: buscar via AJAX os dados do usuário logado
        });
        
        // Validação em tempo real
        $('#cep').on('blur', function() {
            const cep = $(this).val();
            if (cep.length === 9) {
                $(this).addClass('is-valid');
            } else {
                $(this).addClass('is-invalid');
            }
        });
        
        $('#numero-cartao').on('blur', function() {
            const numero = $(this).val().replace(/\s/g, '');
            if (numero.length === 16) {
                $(this).addClass('is-valid');
                
                // Detectar bandeira do cartão
                const firstDigit = numero.charAt(0);
                let bandeira = '';
                
                if (firstDigit === '4') {
                    bandeira = 'Visa';
                } else if (firstDigit === '5') {
                    bandeira = 'Mastercard';
                } else if (firstDigit === '3') {
                    bandeira = 'American Express';
                }
                
                if (bandeira) {
                    $(this).after(`<small class="text-success mt-1">${bandeira} detectado</small>`);
                }
            } else {
                $(this).addClass('is-invalid');
            }
        });
        
        // Prevenção de fraude - simples validação de Luhn
        function validarCartao(numero) {
            const digits = numero.replace(/\D/g, '').split('').map(Number);
            let sum = 0;
            let isEven = false;
            
            for (let i = digits.length - 1; i >= 0; i--) {
                let digit = digits[i];
                
                if (isEven) {
                    digit *= 2;
                    if (digit > 9) {
                        digit -= 9;
                    }
                }
                
                sum += digit;
                isEven = !isEven;
            }
            
            return sum % 10 === 0;
        }
        
        // Aplicar validação de Luhn no cartão
        $('#numero-cartao').on('change', function() {
            const numero = $(this).val().replace(/\s/g, '');
            if (numero.length === 16 && !validarCartao(numero)) {
                $(this).addClass('is-invalid');
                showError('Número de cartão inválido');
            }
        });
    </script>
</body>
</html>