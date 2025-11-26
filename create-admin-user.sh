#!/bin/bash

# Script para criar usuário admin

echo "=========================================="
echo "Criar Usuário Admin"
echo "=========================================="
echo ""

# Cores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar se curl está disponível
if ! command -v curl &> /dev/null; then
    echo -e "${RED}[ERRO] curl não está instalado!${NC}"
    echo "Instale com: sudo apt-get install curl"
    exit 1
fi

echo -e "${YELLOW}[INFO] Tentando criar usuário admin...${NC}"
echo ""

# Tentar criar o usuário (máximo 10 tentativas)
count=0
max_attempts=10

while [ $count -lt $max_attempts ]; do
    count=$((count + 1))

    response=$(curl -s -X POST http://localhost:8080/auth-service/api/auth/register \
        -H "Content-Type: application/json" \
        -d '{"username":"admin","password":"admin123","email":"admin@ucsal.br","fullName":"Administrador do Sistema","role":"ADMIN"}' \
        -w "\n%{http_code}" 2>/dev/null)

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
        echo ""
        echo "=========================================="
        echo -e "${GREEN}[OK] Usuário admin criado com sucesso!${NC}"
        echo "=========================================="
        echo ""
        echo "Credenciais de acesso:"
        echo "  Username: admin"
        echo "  Password: admin123"
        echo ""
        echo "Acesse: http://localhost:5173"
        echo ""
        exit 0
    fi

    if [ $count -lt $max_attempts ]; then
        echo -e "${YELLOW}[INFO] Tentativa $count/$max_attempts falhou. Aguardando 5 segundos...${NC}"
        sleep 5
    fi
done

echo ""
echo "=========================================="
echo -e "${RED}[ERRO] Não foi possível criar o usuário!${NC}"
echo "=========================================="
echo ""
echo "Verifique se os serviços estão rodando:"
echo "  - Auth Service deve estar ativo na porta 8081"
echo "  - API Gateway deve estar ativo na porta 8080"
echo ""
echo "Você pode tentar criar manualmente com este comando:"
echo ""
echo "curl -X POST http://localhost:8080/auth-service/api/auth/register -H \"Content-Type: application/json\" -d '{\"username\":\"admin\",\"password\":\"admin123\",\"email\":\"admin@ucsal.br\",\"fullName\":\"Administrador do Sistema\",\"role\":\"ADMIN\"}'"
echo ""
