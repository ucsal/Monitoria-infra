@echo off
chcp 65001 > nul
echo ==========================================
echo Criar Usuário Admin
echo ==========================================
echo.

REM Verificar se curl está disponível
where curl >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] curl não está disponível!
    echo No Windows 10/11, o curl já vem instalado.
    echo Se não funcionar, atualize o Windows.
    pause
    exit /b 1
)

echo [INFO] Aguardando serviços iniciarem...
echo [INFO] Tentando criar usuário admin...
echo.

REM Tentar criar o usuário (máximo 10 tentativas)
set /a count=0
:retry
set /a count+=1

curl -X POST http://localhost:8080/auth-service/api/auth/register -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"admin123\",\"email\":\"admin@ucsal.br\",\"fullName\":\"Administrador do Sistema\",\"role\":\"ADMIN\"}" 2>nul

if %errorlevel% equ 0 (
    echo.
    echo ==========================================
    echo [OK] Usuário admin criado com sucesso!
    echo ==========================================
    echo.
    echo Credenciais de acesso:
    echo   Username: admin
    echo   Password: admin123
    echo.
    echo Acesse: http://localhost:5173
    echo.
    goto :end
)

if %count% lss 10 (
    echo [INFO] Tentativa %count%/10 falhou. Aguardando 5 segundos...
    timeout /t 5 /nobreak >nul
    goto :retry
)

echo.
echo ==========================================
echo [ERRO] Não foi possível criar o usuário!
echo ==========================================
echo.
echo Verifique se os serviços estão rodando:
echo   - Auth Service deve estar ativo na porta 8081
echo   - API Gateway deve estar ativo na porta 8080
echo.
echo Você pode tentar criar manualmente com este comando:
echo.
echo curl -X POST http://localhost:8080/auth-service/api/auth/register -H "Content-Type: application/json" -d "{\"username\":\"admin\",\"password\":\"admin123\",\"email\":\"admin@ucsal.br\",\"fullName\":\"Administrador do Sistema\",\"role\":\"ADMIN\"}"
echo.

:end
pause
