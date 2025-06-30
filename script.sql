-- ============================================
-- SCRIPT COMPLETO DO BANCO E-COMMERCE LIVRARIA
-- ============================================

-- Criar banco de dados (se não existir)
DROP DATABASE IF EXISTS ecommerce_livraria;
CREATE DATABASE ecommerce_livraria 
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE ecommerce_livraria;

-- ============================================
-- TABELAS PRINCIPAIS
-- ============================================

-- Tabela de Categorias
CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Autores
CREATE TABLE IF NOT EXISTS autores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    biografia TEXT,
    foto VARCHAR(255),
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Livros
CREATE TABLE IF NOT EXISTS livros (
    id INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT,
    isbn VARCHAR(20) UNIQUE,
    preco DECIMAL(10,2) NOT NULL,
    preco_promocional DECIMAL(10,2),
    estoque INT DEFAULT 0,
    paginas INT,
    ano_publicacao INT,
    editora VARCHAR(150),
    capa VARCHAR(255),
    categoria_id INT NOT NULL,
    autor_id INT NOT NULL,
    destaque BOOLEAN DEFAULT FALSE,
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id),
    FOREIGN KEY (autor_id) REFERENCES autores(id),
    INDEX idx_categoria (categoria_id),
    INDEX idx_autor (autor_id),
    INDEX idx_destaque (destaque),
    INDEX idx_ativo (ativo)
);

-- Tabela de Usuários
CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    endereco TEXT,
    cidade VARCHAR(100),
    estado CHAR(2),
    cep VARCHAR(10),
    tipo ENUM('cliente', 'admin') DEFAULT 'cliente',
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_tipo (tipo)
);

-- Tabela de Carrinho
CREATE TABLE IF NOT EXISTS carrinho (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    data_adicao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    UNIQUE KEY uk_usuario_livro (usuario_id, livro_id),
    INDEX idx_usuario (usuario_id)
);

-- Tabela de Cupons
CREATE TABLE IF NOT EXISTS cupons (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    descricao VARCHAR(255),
    tipo ENUM('percentual', 'valor') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    valor_minimo DECIMAL(10,2) DEFAULT 0,
    data_inicio DATETIME,
    data_fim DATETIME,
    usos_limite INT DEFAULT 0,
    usos_realizados INT DEFAULT 0,
    ativo BOOLEAN DEFAULT TRUE,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_codigo (codigo),
    INDEX idx_ativo (ativo)
);

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_pedido VARCHAR(50) NOT NULL UNIQUE,
    usuario_id INT NOT NULL,
    status ENUM('pendente', 'confirmado', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
    total DECIMAL(10,2) NOT NULL,
    desconto DECIMAL(10,2) DEFAULT 0,
    endereco_entrega TEXT NOT NULL,
    codigo_rastreio VARCHAR(50),
    cupom_id INT,
    data_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
    FOREIGN KEY (cupom_id) REFERENCES cupons(id),
    INDEX idx_numero (numero_pedido),
    INDEX idx_usuario (usuario_id),
    INDEX idx_status (status)
);

-- Tabela de Itens do Pedido
CREATE TABLE IF NOT EXISTS itens_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    livro_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
    FOREIGN KEY (livro_id) REFERENCES livros(id),
    INDEX idx_pedido (pedido_id),
    INDEX idx_livro (livro_id)
);

-- Tabela de Avaliações
CREATE TABLE IF NOT EXISTS avaliacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    livro_id INT NOT NULL,
    usuario_id INT NOT NULL,
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    aprovado BOOLEAN DEFAULT FALSE,
    data_avaliacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (livro_id) REFERENCES livros(id) ON DELETE CASCADE,
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE,
    UNIQUE KEY uk_usuario_livro_avaliacao (usuario_id, livro_id),
    INDEX idx_livro (livro_id),
    INDEX idx_aprovado (aprovado)
);

-- ============================================
-- VIEWS
-- ============================================

-- View de Livros Completos
CREATE OR REPLACE VIEW vw_livros_completos AS
SELECT 
    l.id,
    l.titulo,
    l.descricao,
    l.isbn,
    l.preco,
    l.preco_promocional,
    l.estoque,
    l.paginas,
    l.ano_publicacao,
    l.editora,
    l.capa,
    l.categoria_id,
    l.autor_id,
    l.destaque,
    l.ativo,
    l.data_cadastro,
    c.nome as categoria_nome,
    a.nome as autor_nome,
    COALESCE(AVG(av.nota), 0) as media_avaliacoes,
    COUNT(av.id) as total_avaliacoes
FROM livros l
LEFT JOIN categorias c ON l.categoria_id = c.id
LEFT JOIN autores a ON l.autor_id = a.id
LEFT JOIN avaliacoes av ON l.id = av.livro_id AND av.aprovado = TRUE
GROUP BY l.id, l.titulo, l.descricao, l.isbn, l.preco, l.preco_promocional, 
         l.estoque, l.paginas, l.ano_publicacao, l.editora, l.capa, 
         l.categoria_id, l.autor_id, l.destaque, l.ativo, l.data_cadastro,
         c.nome, a.nome;

-- View de Pedidos Completos
CREATE OR REPLACE VIEW vw_pedidos_completos AS
SELECT 
    p.id,
    p.numero_pedido,
    p.usuario_id,
    p.status,
    p.total,
    p.desconto,
    p.endereco_entrega,
    p.codigo_rastreio,
    p.data_pedido,
    p.data_atualizacao,
    u.nome as usuario_nome,
    u.email as usuario_email,
    COUNT(ip.id) as total_itens
FROM pedidos p
LEFT JOIN usuarios u ON p.usuario_id = u.id
LEFT JOIN itens_pedido ip ON p.id = ip.pedido_id
GROUP BY p.id, p.numero_pedido, p.usuario_id, p.status, p.total, p.desconto,
         p.endereco_entrega, p.codigo_rastreio, p.data_pedido, p.data_atualizacao,
         u.nome, u.email;

-- ============================================
-- STORED PROCEDURES
-- ============================================

-- Procedure para criar pedido
DELIMITER //
CREATE PROCEDURE sp_criar_pedido(
    IN p_usuario_id INT,
    IN p_endereco_entrega TEXT,
    IN p_codigo_cupom VARCHAR(50),
    OUT p_pedido_id INT,
    OUT p_numero_pedido VARCHAR(50)
)
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0;
    DECLARE v_desconto DECIMAL(10,2) DEFAULT 0;
    DECLARE v_cupom_id INT DEFAULT NULL;
    DECLARE v_numero VARCHAR(50);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION 
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Calcular total do carrinho
    SELECT SUM(c.quantidade * COALESCE(l.preco_promocional, l.preco))
    INTO v_total
    FROM carrinho c
    JOIN livros l ON c.livro_id = l.id
    WHERE c.usuario_id = p_usuario_id;
    
    -- Validar cupom se fornecido
    IF p_codigo_cupom IS NOT NULL AND p_codigo_cupom != '' THEN
        SELECT id INTO v_cupom_id
        FROM cupons
        WHERE codigo = p_codigo_cupom 
          AND ativo = TRUE
          AND (data_inicio IS NULL OR data_inicio <= NOW())
          AND (data_fim IS NULL OR data_fim >= NOW())
          AND (usos_limite = 0 OR usos_realizados < usos_limite)
          AND v_total >= valor_minimo;
        
        IF v_cupom_id IS NOT NULL THEN
            SELECT 
                CASE 
                    WHEN tipo = 'percentual' THEN v_total * valor / 100
                    ELSE valor
                END
            INTO v_desconto
            FROM cupons WHERE id = v_cupom_id;
            
            -- Atualizar uso do cupom
            UPDATE cupons 
            SET usos_realizados = usos_realizados + 1 
            WHERE id = v_cupom_id;
        END IF;
    END IF;
    
    -- Gerar número do pedido
    SET v_numero = CONCAT('PED', YEAR(NOW()), MONTH(NOW()), DAY(NOW()), '-', LPAD(LAST_INSERT_ID(), 6, '0'));
    
    -- Criar pedido
    INSERT INTO pedidos (numero_pedido, usuario_id, total, desconto, endereco_entrega, cupom_id)
    VALUES (v_numero, p_usuario_id, v_total - v_desconto, v_desconto, p_endereco_entrega, v_cupom_id);
    
    SET p_pedido_id = LAST_INSERT_ID();
    SET p_numero_pedido = v_numero;
    
    -- Atualizar número do pedido com ID real
    SET v_numero = CONCAT('PED', YEAR(NOW()), MONTH(NOW()), DAY(NOW()), '-', LPAD(p_pedido_id, 6, '0'));
    UPDATE pedidos SET numero_pedido = v_numero WHERE id = p_pedido_id;
    SET p_numero_pedido = v_numero;
    
    -- Criar itens do pedido
    INSERT INTO itens_pedido (pedido_id, livro_id, quantidade, preco_unitario, subtotal)
    SELECT 
        p_pedido_id,
        c.livro_id,
        c.quantidade,
        COALESCE(l.preco_promocional, l.preco),
        c.quantidade * COALESCE(l.preco_promocional, l.preco)
    FROM carrinho c
    JOIN livros l ON c.livro_id = l.id
    WHERE c.usuario_id = p_usuario_id;
    
    -- Atualizar estoque
    UPDATE livros l
    JOIN carrinho c ON l.id = c.livro_id
    SET l.estoque = l.estoque - c.quantidade
    WHERE c.usuario_id = p_usuario_id;
    
    -- Limpar carrinho
    DELETE FROM carrinho WHERE usuario_id = p_usuario_id;
    
    COMMIT;
END //
DELIMITER ;

-- ============================================
-- DADOS INICIAIS
-- ============================================

-- Inserir categorias
INSERT IGNORE INTO categorias (nome, descricao) VALUES
('Ficção', 'Livros de ficção e literatura'),
('Romance', 'Livros românticos'),
('Fantasia', 'Livros de fantasia e magia'),
('Suspense', 'Livros de suspense e mistério'),
('Biografia', 'Biografias e autobiografias'),
('Técnico', 'Livros técnicos e educacionais'),
('História', 'Livros de história'),
('Ciência', 'Livros científicos'),
('Autoajuda', 'Livros de desenvolvimento pessoal'),
('Juvenil', 'Literatura juvenil');

-- Inserir autores
INSERT IGNORE INTO autores (nome, biografia) VALUES
('J.K. Rowling', 'Autora britânica, conhecida pela série Harry Potter'),
('Stephen King', 'Autor americano de terror e suspense'),
('Agatha Christie', 'Escritora britânica de mistério'),
('George R.R. Martin', 'Autor americano de fantasia épica'),
('Jane Austen', 'Romancista inglesa do século XIX'),
('Machado de Assis', 'Escritor brasileiro, um dos maiores da literatura nacional'),
('Clarice Lispector', 'Escritora brasileira modernista'),
('José Saramago', 'Escritor português, ganhador do Nobel de Literatura'),
('Gabriel García Márquez', 'Escritor colombiano, mestre do realismo mágico'),
('Paulo Coelho', 'Escritor brasileiro, autor de O Alquimista');

-- Inserir livros
INSERT IGNORE INTO livros (titulo, descricao, isbn, preco, preco_promocional, estoque, paginas, ano_publicacao, editora, categoria_id, autor_id, destaque) VALUES
('Harry Potter e a Pedra Filosofal', 'O primeiro livro da famosa série sobre o bruxo Harry Potter', '9788532511010', 35.90, 29.90, 50, 264, 1997, 'Rocco', 3, 1, TRUE),
('O Iluminado', 'Romance de terror sobre um homem que enlouquece em um hotel isolado', '9788581050614', 42.50, NULL, 30, 464, 1977, 'Suma', 4, 2, TRUE),
('Assassinato no Expresso do Oriente', 'Um dos maiores clássicos do mistério', '9788525052520', 38.90, 32.90, 25, 256, 1934, 'Globo', 4, 3, FALSE),
('A Guerra dos Tronos', 'Primeiro livro da série As Crônicas de Gelo e Fogo', '9788544102121', 55.00, 49.90, 40, 720, 1996, 'Leya', 3, 4, TRUE),
('Orgulho e Preconceito', 'Romance clássico sobre Elizabeth Bennet e Mr. Darcy', '9788525431516', 28.90, NULL, 35, 424, 1813, 'Globo', 2, 5, FALSE),
('Dom Casmurro', 'Clássico da literatura brasileira', '9788594318602', 25.50, 22.90, 60, 176, 1899, 'Principis', 1, 6, TRUE),
('A Hora da Estrela', 'Romance sobre Macabéa, uma jovem nordestina', '9788520925829', 32.90, NULL, 20, 96, 1977, 'Saraiva', 1, 7, FALSE),
('Ensaio sobre a Cegueira', 'Alegoria sobre uma epidemia de cegueira', '9788535902777', 45.90, 39.90, 30, 352, 1995, 'Companhia das Letras', 1, 8, TRUE),
('Cem Anos de Solidão', 'Obra-prima do realismo mágico', '9788501051998', 48.90, 42.90, 25, 432, 1967, 'Record', 1, 9, TRUE),
('O Alquimista', 'Fábula sobre a busca pelos sonhos', '9788576657569', 29.90, 24.90, 80, 163, 1988, 'Planeta', 9, 10, TRUE);

-- Inserir usuário administrador
INSERT IGNORE INTO usuarios (nome, email, senha, tipo) VALUES
('Administrador', 'admin@livraria.com', SHA2('admin123', 256), 'admin');

-- Inserir usuário teste
INSERT IGNORE INTO usuarios (nome, email, senha, telefone, endereco, cidade, estado, cep) VALUES
('João Silva', 'joao@teste.com', SHA2('123456', 256), '(11) 99999-9999', 'Rua das Flores, 123', 'São Paulo', 'SP', '01234-567');

-- Inserir cupons de teste
INSERT IGNORE INTO cupons (codigo, descricao, tipo, valor, valor_minimo, ativo) VALUES
('DESCONTO10', '10% de desconto', 'percentual', 10.00, 50.00, TRUE),
('FRETE20', 'R$ 20 de desconto', 'valor', 20.00, 100.00, TRUE),
('BEMVINDO15', '15% para novos clientes', 'percentual', 15.00, 0.00, TRUE);

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger para atualizar data de modificação dos livros
DELIMITER //
CREATE TRIGGER tr_livros_update 
    BEFORE UPDATE ON livros
    FOR EACH ROW
BEGIN
    SET NEW.data_atualizacao = NOW();
END //
DELIMITER ;

-- ============================================
-- ÍNDICES ADICIONAIS
-- ============================================

-- Índices para melhor performance
CREATE INDEX idx_livros_preco ON livros(preco);
CREATE INDEX idx_livros_estoque ON livros(estoque);
CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_avaliacoes_nota ON avaliacoes(nota);

-- ============================================
-- VERIFICAÇÕES FINAIS
-- ============================================

-- Mostrar tabelas criadas
SHOW TABLES;

-- Mostrar views criadas
SHOW FULL TABLES WHERE Table_type = 'VIEW';

-- Verificar se a view principal existe
SELECT COUNT(*) as total_livros FROM vw_livros_completos;