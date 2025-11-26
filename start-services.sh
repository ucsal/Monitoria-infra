#!/bin/bash

# Script para iniciar todos os microsserviços em sequência
# Execute este script para rodar a aplicação completa sem Docker

echo "=========================================="
echo "Iniciando Microsserviços UCSAL"
echo "=========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Verificar se Java está instalado
if ! command -v java &> /dev/null; then
    echo -e "${RED}[ERRO] Java não está instalado!${NC}"
    echo "Instale Java 17 ou superior"
    exit 1
fi

JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d. -f1)
if [ "$JAVA_VERSION" -lt 17 ]; then
    echo -e "${RED}[ERRO] Java 17 ou superior é necessário. Versão atual: $JAVA_VERSION${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] Java $JAVA_VERSION encontrado${NC}"
echo ""

# Verificar se Maven está instalado
if ! command -v mvn &> /dev/null; then
    echo -e "${RED}[ERRO] Maven não está instalado!${NC}"
    echo "Instale Maven com: sudo apt-get install maven"
    exit 1
fi

echo -e "${GREEN}[OK] Maven encontrado${NC}"
echo ""

# Verificar se PostgreSQL está rodando
if ! sudo systemctl is-active --quiet postgresql; then
    echo -e "${RED}[ERRO] PostgreSQL não está rodando!${NC}"
    echo "Inicie com: sudo systemctl start postgresql"
    exit 1
fi

echo -e "${GREEN}[OK] PostgreSQL está rodando${NC}"
echo ""

# Criar diretório para logs
mkdir -p logs

# Função para iniciar um serviço
start_service() {
    local SERVICE_NAME=$1
    local SERVICE_DIR=$2
    local WAIT_TIME=$3

    echo -e "${BLUE}=========================================="
    echo -e "Iniciando ${SERVICE_NAME}..."
    echo -e "==========================================${NC}"
    echo ""

    cd "$SERVICE_DIR"

    # Compilar o serviço
    echo -e "${YELLOW}[INFO] Compilando ${SERVICE_NAME}...${NC}"
    mvn clean package -DskipTests > "../logs/${SERVICE_NAME}-build.log" 2>&1

    if [ $? -ne 0 ]; then
        echo -e "${RED}[ERRO] Falha ao compilar ${SERVICE_NAME}!${NC}"
        echo "Verifique o log: logs/${SERVICE_NAME}-build.log"
        cd ..
        return 1
    fi

    echo -e "${GREEN}[OK] ${SERVICE_NAME} compilado com sucesso${NC}"

    # Iniciar o serviço em background
    echo -e "${YELLOW}[INFO] Iniciando ${SERVICE_NAME}...${NC}"
    nohup mvn spring-boot:run > "../logs/${SERVICE_NAME}.log" 2>&1 &
    local PID=$!
    echo $PID > "../logs/${SERVICE_NAME}.pid"

    echo -e "${GREEN}[OK] ${SERVICE_NAME} iniciado (PID: $PID)${NC}"
    echo -e "${YELLOW}[INFO] Log: logs/${SERVICE_NAME}.log${NC}"
    echo ""

    cd ..

    # Aguardar o serviço inicializar
    if [ $WAIT_TIME -gt 0 ]; then
        echo -e "${YELLOW}[INFO] Aguardando ${WAIT_TIME} segundos para ${SERVICE_NAME} inicializar...${NC}"
        sleep $WAIT_TIME
        echo ""
    fi
}

# Ordem de inicialização dos serviços
echo -e "${BLUE}=========================================="
echo -e "Ordem de Inicialização:"
echo -e "==========================================${NC}"
echo "1. Eureka Server (Service Discovery)"
echo "2. Auth Service"
echo "3. Academic Service"
echo "4. Student Service"
echo "5. Monitoring Service"
echo "6. Attendance Service"
echo "7. Content Service"
echo "8. API Gateway"
echo ""
echo -e "${YELLOW}Pressione ENTER para continuar ou CTRL+C para cancelar...${NC}"
read

# Iniciar os serviços em sequência
start_service "Eureka Server" "eureka-server" 30
start_service "Auth Service" "auth-service" 20
start_service "Academic Service" "academic-service" 15
start_service "Student Service" "student-service" 15
start_service "Monitoring Service" "monitoring-service" 15
start_service "Attendance Service" "attendance-service" 15
start_service "Content Service" "content-service" 15
start_service "API Gateway" "api-gateway" 10

echo ""
echo -e "${GREEN}=========================================="
echo -e "Todos os serviços foram iniciados!"
echo -e "==========================================${NC}"
echo ""
echo "URLs dos serviços:"
echo "  - Eureka Server:       http://localhost:8761"
echo "  - API Gateway:         http://localhost:8080"
echo "  - Auth Service:        http://localhost:8081"
echo "  - Academic Service:    http://localhost:8082"
echo "  - Student Service:     http://localhost:8083"
echo "  - Monitoring Service:  http://localhost:8084"
echo "  - Attendance Service:  http://localhost:8085"
echo "  - Content Service:     http://localhost:8086"
echo ""

# Criar usuário admin automaticamente
echo "=========================================="
echo "Criando usuário admin..."
echo "=========================================="
echo ""
echo -e "${YELLOW}[INFO] Aguardando 5 segundos para garantir que Auth Service está pronto...${NC}"
sleep 5

response=$(curl -s -X POST http://localhost:8080/auth-service/api/auth/register \
    -H "Content-Type: application/json" \
    -d '{"username":"admin","password":"admin123","email":"admin@ucsal.br","fullName":"Administrador do Sistema","role":"ADMIN"}' \
    -w "\n%{http_code}" 2>/dev/null)

http_code=$(echo "$response" | tail -n1)

if [ "$http_code" = "200" ] || [ "$http_code" = "201" ]; then
    echo -e "${GREEN}[OK] Usuário admin criado com sucesso!${NC}"
    echo ""
    echo "Credenciais de acesso:"
    echo "  Username: admin"
    echo "  Password: admin123"
else
    echo -e "${YELLOW}[INFO] Usuário admin já existe ou erro ao criar.${NC}"
    echo -e "${YELLOW}[INFO] Execute ./create-admin-user.sh se necessário.${NC}"
fi

echo ""
echo "Logs disponíveis em: logs/"
echo ""
echo -e "${YELLOW}Para parar todos os serviços, execute: ./stop-services.sh${NC}"
echo ""
