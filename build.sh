#!/bin/bash

echo "🔧 Corrigindo MySQL Connector corrompido..."
echo ""

# Definir o caminho da pasta lib. Usa o primeiro argumento se fornecido, senão o padrão.
LIB_DIR=${1:-"./src/main/webapp/WEB-INF/lib"} # Padrão para a nova localização

# Verificar se pasta lib existe
if [ ! -d "${LIB_DIR}" ]; then
    mkdir -p "${LIB_DIR}"
    echo "📁 Pasta ${LIB_DIR} criada"
fi

# Remover arquivos MySQL corrompidos
echo "🗑️  Removendo arquivos corrompidos em ${LIB_DIR}..."
rm -f "${LIB_DIR}"/mysql-connector-*.jar

# Lista de URLs para tentar (do mais recente para o mais antigo)
urls=(
    "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.1.0/mysql-connector-j-8.1.0.jar"
    "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar"
    "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.32/mysql-connector-java-8.0.32.jar"
)

nomes=(
    "mysql-connector-j-8.1.0.jar"
    "mysql-connector-java-8.0.33.jar"
    "mysql-connector-java-8.0.32.jar"
)

JUNIT_JAR="junit-platform-console-standalone-1.10.1.jar" # Usando a versão que você mencionou

# Tentar cada URL
for i in "${!urls[@]}"; do
    url="${urls[$i]}"
    nome="${nomes[$i]}"
    
    echo "📥 Tentando baixar: $nome para ${LIB_DIR}"
    
    # Corrigido: Usar ${LIB_DIR} para o caminho de saída
    if curl -L -o "${LIB_DIR}/$nome" "$url"; then
        # Corrigido: Usar ${LIB_DIR} para verificar o arquivo
        if file "${LIB_DIR}/$nome" | grep -q "Java archive"; then
            echo "✅ $nome baixado e verificado com sucesso!"
            
            # Testar se consegue usar no classpath (usar LIB_DIR aqui também)
            if java -cp "${LIB_DIR}/$nome" -version &>/dev/null || [ $? -eq 1 ]; then
                echo "✅ JAR válido para uso!"
                echo ""
                echo "📋 Arquivo final: ${LIB_DIR}/$nome"
                ls -lh "${LIB_DIR}/$nome"
                exit 0
            fi
        else
            echo "❌ $nome corrompido, tentando próximo..."
            # Corrigido: Usar ${LIB_DIR} para remover o arquivo
            rm -f "${LIB_DIR}/$nome"
        fi
    else
        echo "❌ Falha no download de $nome"
    fi
done

echo "❌ Todos os downloads falharam. Tentando método alternativo..."

# Método alternativo: wget
if command -v wget &> /dev/null; then
    echo "📥 Tentando com wget..."
    # Corrigido: Usar ${LIB_DIR} para o caminho de saída
    wget -O "${LIB_DIR}/mysql-connector-java-8.0.33.jar" \
         "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar"
    
    # Corrigido: Usar ${LIB_DIR} para verificar o arquivo
    if [ -f "${LIB_DIR}/mysql-connector-java-8.0.33.jar" ] && file "${LIB_DIR}/mysql-connector-java-8.0.33.jar" | grep -q "Java"; then
        echo "✅ Download com wget bem-sucedido!"
        exit 0
    fi
fi

echo ""
echo "❌ Não foi possível baixar o MySQL Connector automaticamente."
echo ""
echo "🔧 SOLUÇÃO MANUAL:"
echo "1. Acesse: https://dev.mysql.com/downloads/connector/j/"
echo "2. Baixe o MySQL Connector/J"
echo "3. Salve como: ${LIB_DIR}/mysql-connector-j-8.1.0.jar (ou a versão que você baixou)"
echo ""
echo "OU execute apenas os testes que não precisam de banco:"
echo "java -jar ${LIB_DIR}/${JUNIT_JAR} \\"
echo "  --class-path \"build/classes:build/test-classes\" \\"
echo "  --select-class br.com.livraria.model.LivroTest"
echo ""
echo "  --select-class br.com.livraria.util.DateUtilsTest"
