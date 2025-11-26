@echo off
chcp 65001 > nul
echo ==========================================
echo Iniciando Microsserviços UCSAL
echo ==========================================
echo.

REM Verificar Java
where java >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Java não está instalado!
    echo Instale Java 17 ou superior
    pause
    exit /b 1
)

echo [OK] Java encontrado
echo.

REM Verificar Maven
where mvn >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Maven não está instalado!
    echo Instale Maven e adicione ao PATH
    pause
    exit /b 1
)

echo [OK] Maven encontrado
echo.

REM Criar diretório de logs
if not exist logs mkdir logs

echo ==========================================
echo Ordem de Inicialização:
echo ==========================================
echo 1. Eureka Server (Service Discovery)
echo 2. Auth Service
echo 3. Academic Service
echo 4. Student Service
echo 5. Monitoring Service
echo 6. Attendance Service
echo 7. Content Service
echo 8. API Gateway
echo.
echo Pressione qualquer tecla para continuar...
pause >nul

REM Iniciar Eureka Server
echo.
echo ==========================================
echo Iniciando Eureka Server...
echo ==========================================
cd eureka-server
start "Eureka Server" cmd /c "mvn spring-boot:run > ..\logs\eureka-server.log 2>&1"
cd ..
echo [OK] Eureka Server iniciado
echo [INFO] Aguardando 30 segundos...
timeout /t 30 /nobreak >nul

REM Iniciar Auth Service
echo.
echo ==========================================
echo Iniciando Auth Service...
echo ==========================================
cd auth-service
start "Auth Service" cmd /c "mvn spring-boot:run > ..\logs\auth-service.log 2>&1"
cd ..
echo [OK] Auth Service iniciado
echo [INFO] Aguardando 20 segundos...
timeout /t 20 /nobreak >nul

REM Iniciar Academic Service
echo.
echo ==========================================
echo Iniciando Academic Service...
echo ==========================================
cd academic-service
start "Academic Service" cmd /c "mvn spring-boot:run > ..\logs\academic-service.log 2>&1"
cd ..
echo [OK] Academic Service iniciado
echo [INFO] Aguardando 15 segundos...
timeout /t 15 /nobreak >nul

REM Iniciar Student Service
echo.
echo ==========================================
echo Iniciando Student Service...
echo ==========================================
cd student-service
start "Student Service" cmd /c "mvn spring-boot:run > ..\logs\student-service.log 2>&1"
cd ..
echo [OK] Student Service iniciado
echo [INFO] Aguardando 15 segundos...
timeout /t 15 /nobreak >nul

REM Iniciar Monitoring Service
echo.
echo ==========================================
echo Iniciando Monitoring Service...
echo ==========================================
cd monitoring-service
start "Monitoring Service" cmd /c "mvn spring-boot:run > ..\logs\monitoring-service.log 2>&1"
cd ..
echo [OK] Monitoring Service iniciado
echo [INFO] Aguardando 15 segundos...
timeout /t 15 /nobreak >nul

REM Iniciar Attendance Service
echo.
echo ==========================================
echo Iniciando Attendance Service...
echo ==========================================
cd attendance-service
start "Attendance Service" cmd /c "mvn spring-boot:run > ..\logs\attendance-service.log 2>&1"
cd ..
echo [OK] Attendance Service iniciado
echo [INFO] Aguardando 15 segundos...
timeout /t 15 /nobreak >nul

REM Iniciar Content Service
echo.
echo ==========================================
echo Iniciando Content Service...
echo ==========================================
cd content-service
start "Content Service" cmd /c "mvn spring-boot:run > ..\logs\content-service.log 2>&1"
cd ..
echo [OK] Content Service iniciado
echo [INFO] Aguardando 15 segundos...
timeout /t 15 /nobreak >nul

REM Iniciar API Gateway
echo.
echo ==========================================
echo Iniciando API Gateway...
echo ==========================================
cd api-gateway
start "API Gateway" cmd /c "mvn spring-boot:run > ..\logs\api-gateway.log 2>&1"
cd ..
echo [OK] API Gateway iniciado
echo [INFO] Aguardando 10 segundos...
timeout /t 10 /nobreak >nul

echo.
echo ==========================================
echo Todos os serviços foram iniciados!
echo ==========================================
echo.
echo URLs dos serviços:
echo   - Eureka Server:       http://localhost:8761
echo   - API Gateway:         http://localhost:8080
echo   - Auth Service:        http://localhost:8081
echo   - Academic Service:    http://localhost:8082
echo   - Student Service:     http://localhost:8083
echo   - Monitoring Service:  http://localhost:8084
echo   - Attendance Service:  http://localhost:8085
echo   - Content Service:     http://localhost:8086
echo.

REM Criar usuário admin automaticamente
echo ==========================================
echo Criando usuário admin...
echo ==========================================
echo.
echo [INFO] Aguardando 5 segundos para garantir que Auth Service está pronto...
timeout /t 5 /nobreak >nul

curl -X POST http://localhost:8080/auth-service/api/auth/register -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"admin123\",\"email\":\"admin@ucsal.br\",\"fullName\":\"Administrador do Sistema\",\"role\":\"ADMIN\"}" 2>nul >nul

if %errorlevel% equ 0 (
    echo [OK] Usuário admin criado com sucesso!
    echo.
    echo Credenciais de acesso:
    echo   Username: admin
    echo   Password: admin123
) else (
    echo [INFO] Usuário admin já existe ou erro ao criar.
    echo [INFO] Execute create-admin-user.bat se necessário.
)

echo.
echo Logs disponíveis em: logs\
echo.
echo Para parar todos os serviços, execute: stop-services.bat
echo.
pause
