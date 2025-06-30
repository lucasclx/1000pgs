#!/bin/bash

echo "🔧 Corrigindo MySQL Connector corrompido..."
echo ""

# Verificar se pasta lib existe
if [ ! -d "lib" ]; then
    mkdir -p lib
    echo "📁 Pasta lib criada"
fi

# Remover arquivos MySQL corrompidos
echo "🗑️  Removendo arquivos corrompidos..."
rm -f lib/mysql-connector-*.jar

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

# Tentar cada URL
for i in "${!urls[@]}"; do
    url="${urls[$i]}"
    nome="${nomes[$i]}"
    
    echo "📥 Tentando baixar: $nome"
    
    if curl -L -o "lib/$nome" "$url"; then
        # Verificar se o arquivo é válido
        if file "lib/$nome" | grep -q "Java archive"; then
            echo "✅ $nome baixado e verificado com sucesso!"
            
            # Testar se consegue usar no classpath
            if java -cp "lib/$nome" -version &>/dev/null || [ $? -eq 1 ]; then
                echo "✅ JAR válido para uso!"
                echo ""
                echo "📋 Arquivo final: lib/$nome"
                ls -lh "lib/$nome"
                exit 0
            fi
        else
            echo "❌ $nome corrompido, tentando próximo..."
            rm -f "lib/$nome"
        fi
    else
        echo "❌ Falha no download de $nome"
    fi
done

echo "❌ Todos os downloads falharam. Tentando método alternativo..."

# Método alternativo: wget
if command -v wget &> /dev/null; then
    echo "📥 Tentando com wget..."
    wget -O lib/mysql-connector-java-8.0.33.jar \
         "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar"
    
    if [ -f "lib/mysql-connector-java-8.0.33.jar" ] && file lib/mysql-connector-java-8.0.33.jar | grep -q "Java"; then
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
echo "3. Salve como: lib/mysql-connector-java-8.0.33.jar"
echo ""
echo "OU execute apenas os testes que não precisam de banco:"
echo "java -jar lib/junit-platform-console-standalone-1.9.2.jar \\"
echo "  --class-path \"build/classes:build/test-classes\" \\"
echo "  --select-class br.com.livraria.model.LivroTest \\"
echo "  --select-class br.com.livraria.util.DateUtilsTest"