#!/bin/bash

echo "🔧 Script de Build e Teste - E-commerce Livraria"
echo "================================================"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para logging
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 1. Verificar se MySQL Connector está OK
log_info "Verificando MySQL Connector..."
if [ ! -f "lib/mysql-connector-j-8.1.0.jar" ]; then
    log_warning "MySQL Connector não encontrado, executando script de correção..."
    ./fix_mysql_connector.sh
fi

# Verificar se o JAR é válido
if file lib/mysql-connector-j-8.1.0.jar | grep -q "Java archive"; then
    log_success "MySQL Connector OK"
else
    log_error "MySQL Connector corrompido"
    exit 1
fi

# 2. Limpar builds anteriores
log_info "Limpando builds anteriores..."
rm -rf build/classes build/test-classes
mkdir -p build/classes build/test-classes

# 3. Verificar estrutura de diretórios
log_info "Verificando estrutura de diretórios..."
if [ ! -d "src/main/java" ]; then
    log_error "Diretório src/main/java não encontrado"
    exit 1
fi

if [ ! -d "src/test/java" ]; then
    log_error "Diretório src/test/java não encontrado"
    exit 1
fi

# 4. Compilar classes principais
log_info "Compilando classes principais..."

# Primeiro, tentar compilar apenas models e utils (sem servlets)
log_info "Compilando models e utils..."
javac -d build/classes -cp "lib/*" \
    src/main/java/br/com/livraria/model/*.java \
    src/main/java/br/com/livraria/util/*.java

if [ $? -eq 0 ]; then
    log_success "Models e utils compilados com sucesso"
    
    # Agora tentar compilar DAOs
    log_info "Compilando DAOs..."
    javac -d build/classes -cp "lib/*:build/classes" \
        src/main/java/br/com/livraria/dao/*.java
    
    if [ $? -eq 0 ]; then
        log_success "DAOs compilados com sucesso"
        
        # Tentar compilar servlets (pode falhar se não tiver servlet-api)
        log_info "Compilando servlets e filtros..."
        javac -d build/classes -cp "lib/*:build/classes" \
            src/main/java/br/com/livraria/servlet/**/*.java \
            src/main/java/br/com/livraria/filter/*.java \
            src/main/java/br/com/livraria/listener/*.java 2>/dev/null
        
        if [ $? -eq 0 ]; then
            log_success "Servlets compilados com sucesso"
        else
            log_warning "Servlets falharam (servlet-api pode estar faltando)"
            log_info "Continuando apenas com models, utils e DAOs..."
        fi
    else
        log_error "Erro na compilação dos DAOs"
        exit 1
    fi
    
    # Verificar quantas classes foram geradas
    class_count=$(find build/classes -name "*.class" | wc -l)
    log_info "Total de classes compiladas: $class_count"
    
    if [ $class_count -eq 0 ]; then
        log_error "Nenhuma classe foi compilada"
        exit 1
    fi
else
    log_error "Erro na compilação dos models e utils"
    exit 1
fi

# 5. Listar algumas classes compiladas para verificação
log_info "Verificando classes compiladas..."
echo "Principais classes encontradas:"
find build/classes -name "*.class" | head -10 | sed 's/build\/classes\///g' | sed 's/\.class$//g' | sed 's/\//./g'

# 6. Compilar classes de teste
log_info "Compilando classes de teste..."
javac -d build/test-classes -cp "lib/*:build/classes" src/test/java/br/com/livraria/**/*.java

if [ $? -eq 0 ]; then
    log_success "Classes de teste compiladas com sucesso"
    
    test_class_count=$(find build/test-classes -name "*.class" | wc -l)
    log_info "Total de classes de teste compiladas: $test_class_count"
else
    log_error "Erro na compilação das classes de teste"
    log_warning "Tentando compilar testes individuais para identificar problemas..."
    
    # Tentar compilar cada arquivo de teste individualmente
    for test_file in src/test/java/br/com/livraria/**/*Test.java; do
        if [ -f "$test_file" ]; then
            echo "Tentando compilar: $test_file"
            javac -d build/test-classes -cp "lib/*:build/classes" "$test_file" 2>&1 | head -5
            echo "---"
        fi
    done
    
    exit 1
fi

# 7. Verificar se JUnit está disponível
log_info "Verificando JUnit..."
if [ ! -f "lib/junit-platform-console-standalone-1.9.2.jar" ]; then
    log_error "JUnit não encontrado em lib/"
    exit 1
else
    log_success "JUnit encontrado"
fi

# 8. Executar testes
log_info "Executando testes..."
echo "========================================"

# Primeiro tentar executar apenas testes de model e util (que não dependem de servlet)
log_info "Executando testes de Model e Util (sem dependências externas)..."

java -jar lib/junit-platform-console-standalone-1.9.2.jar \
  --class-path "lib/*:build/classes:build/test-classes" \
  --select-package br.com.livraria.model \
  --select-package br.com.livraria.util \
  --details=tree

model_test_result=$?

echo ""
echo "========================================"

if [ $model_test_result -eq 0 ]; then
    log_success "Testes de Model/Util executados com sucesso!"
else
    log_warning "Alguns testes de Model/Util falharam (código: $model_test_result)"
fi

# Tentar executar testes de DAO (que dependem de banco de dados)
log_info "Executando testes de DAO (requerem banco de dados)..."

java -jar lib/junit-platform-console-standalone-1.9.2.jar \
  --class-path "lib/*:build/classes:build/test-classes" \
  --select-package br.com.livraria.dao \
  --details=tree

dao_test_result=$?

echo ""
echo "========================================"

if [ $dao_test_result -eq 0 ]; then
    log_success "Testes de DAO executados com sucesso!"
else
    log_warning "Alguns testes de DAO falharam - verifique se o banco de dados está rodando (código: $dao_test_result)"
fi

# 9. Estatísticas finais
log_info "Estatísticas finais:"
echo "- Classes principais: $(find build/classes -name "*.class" | wc -l)"
echo "- Classes de teste: $(find build/test-classes -name "*.class" | wc -l)"
echo "- Arquivos JAR em lib: $(ls lib/*.jar | wc -l)"

# 10. Verificar conexão com banco (opcional)
log_info "Verificando conectividade com banco de dados..."
java -cp "lib/*:build/classes" br.com.livraria.util.ConexaoDB 2>/dev/null
if [ $? -eq 0 ]; then
    log_success "Conexão com banco de dados OK"
else
    log_warning "Problema na conexão com banco de dados (tests de integração podem falhar)"
fi

echo ""
log_success "Build concluído! ✨"
echo ""
echo "Para executar apenas testes específicos:"
echo "java -jar lib/junit-platform-console-standalone-1.9.2.jar \\"
echo "  --class-path \"lib/*:build/classes:build/test-classes\" \\"
echo "  --select-class br.com.livraria.model.LivroTest"
echo ""
echo "Para executar apenas testes que não precisam de banco:"
echo "java -jar lib/junit-platform-console-standalone-1.9.2.jar \\"
echo "  --class-path \"lib/*:build/classes:build/test-classes\" \\"
echo "  --select-package br.com.livraria.model"
