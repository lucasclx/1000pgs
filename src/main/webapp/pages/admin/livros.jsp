<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administração de Livros - Livraria Online</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        
        .livro-row {
            transition: background-color 0.3s ease;
        }
        
        .livro-row:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .livro-img-small {
            width: 50px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
        }
        
        .btn-action {
            margin: 0 2px;
            padding: 5px 10px;
            font-size: 0.8rem;
        }
        
        .modal-lg {
            max-width: 800px;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
        }
        
        .badge-status {
            font-size: 0.75rem;
            padding: 0.4rem 0.8rem;
        }
        
        .img-preview {
            max-width: 200px;
            max-height: 250px;
            border-radius: 10px;
            margin: 10px 0;
        }
        
        .search-box {
            background: white;
            border-radius: 10px;
            padding: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h1><i class="fas fa-books me-2"></i>Administração de Livros</h1>
                    <p class="mb-0">Gerencie o catálogo de livros da livraria</p>
                </div>
                <div>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-light me-2">
                        <i class="fas fa-home me-1"></i>Site
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light">
                        <i class="fas fa-sign-out-alt me-1"></i>Sair
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Estatísticas -->
    <div class="container py-4">
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number">${totalLivros}</div>
                    <div class="text-muted">Total de Livros</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-success">${livrosAtivos}</div>
                    <div class="text-muted">Livros Ativos</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-warning">${livrosDestaque}</div>
                    <div class="text-muted">Em Destaque</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card">
                    <div class="stats-number text-danger">${livrosEsgotados}</div>
                    <div class="text-muted">Esgotados</div>
                </div>
            </div>
        </div>

        <!-- Filtros e Busca -->
        <div class="search-box">
            <form method="get" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="busca" class="form-label">Buscar Livros</label>
                    <input type="text" class="form-control" id="busca" name="busca" 
                           placeholder="Título, autor ou ISBN..." value="${param.busca}">
                </div>
                <div class="col-md-3">
                    <label for="categoria" class="form-label">Categoria</label>
                    <select class="form-select" id="categoria" name="categoria">
                        <option value="">Todas as categorias</option>
                        <c:forEach items="${categorias}" var="categoria">
                            <option value="${categoria.id}" ${param.categoria == categoria.id ? 'selected' : ''}>
                                ${categoria.nome}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="status" class="form-label">Status</label>
                    <select class="form-select" id="status" name="status">
                        <option value="">Todos os status</option>
                        <option value="ativo" ${param.status == 'ativo' ? 'selected' : ''}>Ativo</option>
                        <option value="inativo" ${param.status == 'inativo' ? 'selected' : ''}>Inativo</option>
                        <option value="destaque" ${param.status == 'destaque' ? 'selected' : ''}>Destaque</option>
                        <option value="esgotado" ${param.status == 'esgotado' ? 'selected' : ''}>Esgotado</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-1"></i>Buscar
                    </button>
                </div>
            </form>
        </div>

        <!-- Ações -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3>Lista de Livros (${totalLivros} encontrados)</h3>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#livroModal" onclick="novoLivro()">
                <i class="fas fa-plus me-2"></i>Novo Livro
            </button>
        </div>

        <!-- Tabela de Livros -->
        <div class="bg-white rounded-3 shadow-sm">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Imagem</th>
                            <th>Título</th>
                            <th>Autor</th>
                            <th>Categoria</th>
                            <th>Preço</th>
                            <th>Estoque</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty livros}">
                                <tr>
                                    <td colspan="8" class="text-center py-5">
                                        <i class="fas fa-books fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Nenhum livro encontrado</h5>
                                        <p class="text-muted">Tente ajustar os filtros ou adicione um novo livro.</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach items="${livros}" var="livro">
                                    <tr class="livro-row">
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty livro.capa}">
                                                    <img src="${livro.capa}" alt="${livro.titulo}" class="livro-img-small">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="livro-img-small bg-light d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-book text-muted"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="fw-bold">${livro.titulo}</div>
                                            <small class="text-muted">ISBN: ${livro.isbn}</small>
                                        </td>
                                        <td>${livro.autorNome}</td>
                                        <td>${livro.categoriaNome}</td>
                                        <td>
                                            <c:if test="${livro.temPromocao()}">
                                                <div class="text-decoration-line-through text-muted small">
                                                    <fmt:formatNumber value="${livro.preco}" type="currency" currencySymbol="R$ "/>
                                                </div>
                                            </c:if>
                                            <div class="fw-bold">
                                                <fmt:formatNumber value="${livro.precoFinal}" type="currency" currencySymbol="R$ "/>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge ${livro.estoque > 0 ? 'bg-success' : 'bg-danger'}">
                                                ${livro.estoque} unidades
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column gap-1">
                                                <span class="badge ${livro.ativo ? 'bg-success' : 'bg-secondary'} badge-status">
                                                    ${livro.ativo ? 'Ativo' : 'Inativo'}
                                                </span>
                                                <c:if test="${livro.destaque}">
                                                    <span class="badge bg-warning badge-status">Destaque</span>
                                                </c:if>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="btn-group" role="group">
                                                <button class="btn btn-outline-primary btn-action" 
                                                        onclick="editarLivro(${livro.id})" title="Editar">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="btn btn-outline-warning btn-action"
                                                        onclick="toggleDestaque(${livro.id}, ${!livro.destaque})" 
                                                        title="${livro.destaque ? 'Remover destaque' : 'Adicionar destaque'}">
                                                    <i class="fas fa-star"></i>
                                                </button>
                                                <button class="btn btn-outline-danger btn-action"
                                                        onclick="excluirLivro(${livro.id})" title="Remover">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal de Livro -->
    <div class="modal fade" id="livroModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="livroModalTitle">Novo Livro</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form id="livroForm" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" id="livroId" name="id">
                        
                        <div class="row g-3">
                            <!-- Informações Básicas -->
                            <div class="col-12">
                                <h6 class="text-primary">Informações Básicas</h6>
                                <hr>
                            </div>
                            
                            <div class="col-md-8">
                                <label for="titulo" class="form-label">Título *</label>
                                <input type="text" class="form-control" id="titulo" name="titulo" required>
                            </div>
                            
                            <div class="col-md-4">
                                <label for="isbn" class="form-label">ISBN</label>
                                <input type="text" class="form-control" id="isbn" name="isbn">
                            </div>
                            
                            <div class="col-12">
                                <label for="descricao" class="form-label">Descrição</label>
                                <textarea class="form-control" id="descricao" name="descricao" rows="3"></textarea>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="autorId" class="form-label">Autor *</label>
                                <select class="form-select" id="autorId" name="autorId" required>
                                    <option value="">Selecione um autor</option>
                                    <c:forEach items="${autores}" var="autor">
                                        <option value="${autor.id}">${autor.nome}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="categoriaId" class="form-label">Categoria *</label>
                                <select class="form-select" id="categoriaId" name="categoriaId" required>
                                    <option value="">Selecione uma categoria</option>
                                    <c:forEach items="${categorias}" var="categoria">
                                        <option value="${categoria.id}">${categoria.nome}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="editora" class="form-label">Editora</label>
                                <input type="text" class="form-control" id="editora" name="editora">
                            </div>
                            
                            <div class="col-md-3">
                                <label for="paginas" class="form-label">Páginas</label>
                                <input type="number" class="form-control" id="paginas" name="paginas" min="1">
                            </div>
                            
                            <div class="col-md-3">
                                <label for="anoPublicacao" class="form-label">Ano</label>
                                <input type="number" class="form-control" id="anoPublicacao" name="anoPublicacao" 
                                       min="1900" max="2030">
                            </div>
                            
                            <!-- Preços e Estoque -->
                            <div class="col-12 mt-4">
                                <h6 class="text-primary">Preços e Estoque</h6>
                                <hr>
                            </div>
                            
                            <div class="col-md-4">
                                <label for="preco" class="form-label">Preço *</label>
                                <div class="input-group">
                                    <span class="input-group-text">R$</span>
                                    <input type="number" class="form-control" id="preco" name="preco" 
                                           step="0.01" min="0" required>
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <label for="precoPromocional" class="form-label">Preço Promocional</label>
                                <div class="input-group">
                                    <span class="input-group-text">R$</span>
                                    <input type="number" class="form-control" id="precoPromocional" name="precoPromocional" 
                                           step="0.01" min="0">
                                </div>
                            </div>
                            
                            <div class="col-md-4">
                                <label for="estoque" class="form-label">Estoque *</label>
                                <input type="number" class="form-control" id="estoque" name="estoque" 
                                       min="0" required>
                            </div>
                            
                            <!-- Imagem -->
                            <div class="col-12 mt-4">
                                <h6 class="text-primary">Imagem da Capa</h6>
                                <hr>
                            </div>
                            
                            <div class="col-md-6">
                                <label for="capaUrl" class="form-label">URL da Imagem</label>
                                <input type="url" class="form-control" id="capaUrl" name="capaUrl" 
                                       placeholder="https://exemplo.com/imagem.jpg">
                            </div>
                            
                            <div class="col-md-6">
                                <label for="capa" class="form-label">Ou envie um arquivo</label>
                                <input type="file" class="form-control" id="capa" name="capa" 
                                       accept="image/*">
                            </div>
                            
                            <div class="col-12">
                                <div id="imagemPreview"></div>
                            </div>
                            
                            <!-- Configurações -->
                            <div class="col-12 mt-4">
                                <h6 class="text-primary">Configurações</h6>
                                <hr>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="ativo" name="ativo" checked>
                                    <label class="form-check-label" for="ativo">
                                        Livro ativo (visível no site)
                                    </label>
                                </div>
                            </div>
                            
                            <div class="col-md-6">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="destaque" name="destaque">
                                    <label class="form-check-label" for="destaque">
                                        Livro em destaque
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Cancelar
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save me-2"></i>Salvar Livro
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Preview de imagem
            $('#capaUrl, #capa').on('change', function() {
                previewImagem();
            });
            
            // Submit do formulário
            $('#livroForm').on('submit', function(e) {
                e.preventDefault();
                salvarLivro();
            });
        });
        
        function novoLivro() {
            $('#livroModalTitle').text('Novo Livro');
            $('#livroForm')[0].reset();
            $('#livroId').val('');
            $('#imagemPreview').empty();
        }
        
        function editarLivro(id) {
            $('#livroModalTitle').text('Editar Livro');
            
            // Buscar dados do livro
            $.ajax({
                url: '/1000pgs/admin/livros/buscar',
                method: 'GET',
                data: { id: id },
                dataType: 'json',
                success: function(livro) {
                    if (livro.erro) {
                        alert(livro.erro);
                        return;
                    }
                    
                    // Preencher formulário
                    $('#livroId').val(livro.id);
                    $('#titulo').val(livro.titulo);
                    $('#descricao').val(livro.descricao);
                    $('#isbn').val(livro.isbn);
                    $('#autorId').val(livro.autorId);
                    $('#categoriaId').val(livro.categoriaId);
                    $('#editora').val(livro.editora);
                    $('#paginas').val(livro.paginas);
                    $('#anoPublicacao').val(livro.anoPublicacao);
                    $('#preco').val(livro.preco);
                    $('#precoPromocional').val(livro.precoPromocional);
                    $('#estoque').val(livro.estoque);
                    $('#capaUrl').val(livro.capa);
                    $('#ativo').prop('checked', livro.ativo);
                    $('#destaque').prop('checked', livro.destaque);
                    
                    previewImagem();
                    $('#livroModal').modal('show');
                },
                error: function() {
                    alert('Erro ao carregar dados do livro');
                }
            });
        }
        
        function salvarLivro() {
            const formData = new FormData($('#livroForm')[0]);
            const isEdicao = $('#livroId').val() !== '';
            const url = isEdicao ? '/1000pgs/admin/livros/editar' : '/1000pgs/admin/livros/adicionar';
            
            $.ajax({
                url: url,
                method: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        alert(response.mensagem);
                        $('#livroModal').modal('hide');
                        location.reload();
                    } else {
                        alert(response.mensagem || 'Erro ao salvar livro');
                    }
                },
                error: function() {
                    alert('Erro de conexão ao salvar livro');
                }
            });
        }
        
        function excluirLivro(id) {
            if (confirm('Tem certeza que deseja remover este livro? Esta ação não pode ser desfeita.')) {
                $.ajax({
                    url: '/1000pgs/admin/livros/excluir',
                    method: 'POST',
                    data: { id: id },
                    dataType: 'json',
                    success: function(response) {
                        if (response.sucesso) {
                            alert(response.mensagem);
                            location.reload();
                        } else {
                            alert(response.mensagem || 'Erro ao remover livro');
                        }
                    },
                    error: function() {
                        alert('Erro de conexão ao remover livro');
                    }
                });
            }
        }
        
        function toggleDestaque(id, destaque) {
            $.ajax({
                url: '/1000pgs/admin/livros/toggle-destaque',
                method: 'POST',
                data: { 
                    id: id, 
                    destaque: destaque 
                },
                dataType: 'json',
                success: function(response) {
                    if (response.sucesso) {
                        location.reload();
                    } else {
                        alert(response.mensagem || 'Erro ao atualizar destaque');
                    }
                },
                error: function() {
                    alert('Erro de conexão');
                }
            });
        }
        
        function previewImagem() {
            const url = $('#capaUrl').val();
            const file = $('#capa')[0].files[0];
            
            if (url) {
                $('#imagemPreview').html(`
                    <img src="${url}" alt="Preview" class="img-preview">
                `);
            } else if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $('#imagemPreview').html(`
                        <img src="${e.target.result}" alt="Preview" class="img-preview">
                    `);
                };
                reader.readAsDataURL(file);
            } else {
                $('#imagemPreview').empty();
            }
        }
    </script>
</body>
</html>