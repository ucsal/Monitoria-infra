#!/bin/bash

# Script para parar todos os microsserviços

echo "=========================================="
echo "Parando Microsserviços UCSAL"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Lista de serviços
SERVICES=(
    "eureka-server"
    "auth-service"
    "academic-service"
    "student-service"
    "monitoring-service"
    "attendance-service"
    "content-service"
    "api-gateway"
)

# Função para parar um serviço
stop_service() {
    local SERVICE_NAME=$1
    local PID_FILE="logs/${SERVICE_NAME}.pid"

    if [ -f "$PID_FILE" ]; then
        local PID=$(cat "$PID_FILE")

        if ps -p $PID > /dev/null 2>&1; then
            echo -e "${YELLOW}[INFO] Parando ${SERVICE_NAME} (PID: $PID)...${NC}"
            kill $PID

            # Aguardar o processo terminar
            local COUNTER=0
            while ps -p $PID > /dev/null 2>&1 && [ $COUNTER -lt 10 ]; do
                sleep 1
                COUNTER=$((COUNTER + 1))
            done

            if ps -p $PID > /dev/null 2>&1; then
                echo -e "${YELLOW}[INFO] Forçando parada de ${SERVICE_NAME}...${NC}"
                kill -9 $PID
            fi

            echo -e "${GREEN}[OK] ${SERVICE_NAME} parado${NC}"
        else
            echo -e "${YELLOW}[INFO] ${SERVICE_NAME} não está rodando (PID $PID não encontrado)${NC}"
        fi

        rm "$PID_FILE"
    else
        echo -e "${YELLOW}[INFO] Arquivo PID não encontrado para ${SERVICE_NAME}${NC}"
    fi
    echo ""
}

# Parar todos os serviços na ordem inversa
echo "Parando serviços..."
echo ""

for SERVICE in "${SERVICES[@]}"; do
    stop_service "$SERVICE"
done

# Limpar processos Java remanescentes relacionados aos serviços
echo -e "${YELLOW}[INFO] Verificando processos Java remanescentes...${NC}"
JAVA_PIDS=$(ps aux | grep -E "spring-boot:run|eureka-server|auth-service|academic-service|student-service|monitoring-service|attendance-service|content-service|api-gateway" | grep -v grep | awk '{print $2}')

if [ ! -z "$JAVA_PIDS" ]; then
    echo -e "${YELLOW}[INFO] Encontrados processos Java remanescentes, encerrando...${NC}"
    echo "$JAVA_PIDS" | xargs kill -9 2>/dev/null
    echo -e "${GREEN}[OK] Processos encerrados${NC}"
else
    echo -e "${GREEN}[OK] Nenhum processo remanescente encontrado${NC}"
fi

echo ""
echo -e "${GREEN}=========================================="
echo -e "Todos os serviços foram parados!"
echo -e "==========================================${NC}"
echo ""
