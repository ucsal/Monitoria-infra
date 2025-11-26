#!/bin/bash

# Script simplificado para configurar bancos de dados PostgreSQL locais
# Este script NÃO usa sudo - funciona com o usuário atual

echo "=========================================="
echo "Setup Simplificado de Bancos de Dados"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar se PostgreSQL está instalado
if ! command -v psql &> /dev/null; then
    echo -e "${RED}[ERRO] PostgreSQL não está instalado!${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] PostgreSQL encontrado${NC}"
echo ""

# Função para criar um banco de dados
create_database() {
    local DB_NAME=$1

    echo -e "${YELLOW}[INFO] Criando banco de dados: ${DB_NAME}...${NC}"

    # Tentar criar o banco de dados (funciona se você tem permissões)
    createdb "$DB_NAME" 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[OK] Banco de dados $DB_NAME criado com sucesso!${NC}"
    else
        # Verificar se já existe
        psql -lqt 2>/dev/null | cut -d \| -f 1 | grep -qw "$DB_NAME"
        if [ $? -eq 0 ]; then
            echo -e "${YELLOW}[INFO] Banco de dados $DB_NAME já existe.${NC}"
        else
            echo -e "${RED}[ERRO] Falha ao criar banco de dados $DB_NAME${NC}"
            echo -e "${YELLOW}[INFO] Tente executar manualmente: createdb $DB_NAME${NC}"
        fi
    fi
    echo ""
}

# Criar os bancos de dados
echo "=========================================="
echo "Criando bancos de dados na porta 5432..."
echo "=========================================="
echo ""

create_database "auth_service_db"
create_database "academic_service_db"
create_database "student_service_db"
create_database "monitoring_service_db"
create_database "attendance_service_db"
create_database "content_service_db"

echo "=========================================="
echo -e "${GREEN}Setup de bancos de dados concluído!${NC}"
echo "=========================================="
echo ""
echo "Bancos de dados criados na porta 5432:"
echo "  - auth_service_db"
echo "  - academic_service_db"
echo "  - student_service_db"
echo "  - monitoring_service_db"
echo "  - attendance_service_db"
echo "  - content_service_db"
echo ""
echo -e "${GREEN}Próximo passo: Execute ./start-services.sh${NC}"
echo ""
