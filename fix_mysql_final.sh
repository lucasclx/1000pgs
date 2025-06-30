#!/bin/bash

echo "🔧 Corrigindo MySQL Connector definitivamente..."
echo ""

LIB_DIR="src/main/webapp/WEB-INF/lib"

# Remover todos os drivers MySQL antigos
echo "🗑️  Removendo drivers MySQL antigos..."
rm -f ${LIB_DIR}/mysql-connector-*.jar

# Lista de URLs para tentar
urls=(
    "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.1.0/mysql-connector-j-8.1.0.jar"
    "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/8.0.33/mysql-connector-j-8.0.33.jar"
    "https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.33/mysql-connector-java-8.0.33.jar"
)

nomes=(
    "mysql-connector-j-8.1.0.jar"
    "mysql-connector-j-8.0.33.jar"  
    "mysql-connector-java-8.0.33.jar"
)

# Tentar cada URL
for i in "${!urls[@]}"; do
    url="${urls[$i]}"
    nome="${nomes[$i]}"
    
    echo "📥 Tentando baixar: $nome"
    
    if curl -L -o "${LIB_DIR}/$nome" "$url"; then
        # Verificar se o arquivo é válido
        if file "${LIB_DIR}/$nome" | grep -q "Java archive\|Zip archive"; then
            echo "✅ $nome baixado e verificado com sucesso!"
            
            # Testar se consegue carregar a classe
            if java -cp "${LIB_DIR}/$nome" -jar /dev/null 2>/dev/null || [ $? -eq 1 ]; then
                echo "✅ JAR válido para uso!"
                echo ""
                echo "📋 Arquivo final: ${LIB_DIR}/$nome"
                ls -lh "${LIB_DIR}/$nome"
                
                # Testar se consegue encontrar o driver
                echo ""
                echo "🧪 Testando se o driver é carregável..."
                java -cp "${LIB_DIR}/$nome" -Djava.awt.headless=true CheckDriver 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo "✅ Driver MySQL carregado com sucesso!"
                else
                    echo "⚠️  Driver baixado mas pode ter problemas de compatibilidade"
                fi
                
                echo ""
                echo "🎯 Agora execute os testes:"
                echo "java -jar src/main/webapp/WEB-INF/lib/junit-platform-console-standalone-1.10.1.jar \\"
                echo "  --class-path \"${LIB_DIR}/*:build/classes:build/test-classes\" \\"
                echo "  --select-package br.com.livraria.dao \\"
                echo "  --details=tree"
                
                exit 0
            fi
        else
            echo "❌ $nome corrompido, tentando próximo..."
            rm -f "${LIB_DIR}/$nome"
        fi
    else
        echo "❌ Falha no download de $nome"
    fi
done

echo "❌ Todos os downloads falharam."
echo ""
echo "🔧 SOLUÇÃO MANUAL:"
echo "1. Vá para: https://dev.mysql.com/downloads/connector/j/"
echo "2. Baixe o MySQL Connector/J"
echo "3. Salve como: ${LIB_DIR}/mysql-connector-j-8.1.0.jar"
echo ""
echo "📋 Ou execute apenas testes que NÃO precisam de banco:"
echo "java -jar ${LIB_DIR}/junit-platform-console-standalone-1.10.1.jar \\"
echo "  --class-path \"${LIB_DIR}/*:build/classes:build/test-classes\" \\"
echo "  --select-package br.com.livraria.model \\"
echo "  --exclude-class-name-pattern \".*ConexaoDBTest\" \\"
echo "  --details=tree"
