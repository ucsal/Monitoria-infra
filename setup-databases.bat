@echo off
chcp 65001 > nul
echo ==========================================
echo Setup de Bancos de Dados PostgreSQL
echo ==========================================
echo.

REM Verificar se psql está disponível
where psql >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] PostgreSQL não está instalado ou não está no PATH!
    echo Instale o PostgreSQL e adicione ao PATH do sistema.
    pause
    exit /b 1
)

echo [OK] PostgreSQL encontrado
echo.

echo ==========================================
echo Criando bancos de dados...
echo ==========================================
echo.

REM Criar os bancos de dados
echo [INFO] Criando banco: auth_service_db...
createdb -U postgres auth_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] auth_service_db criado
) else (
    echo [INFO] auth_service_db já existe ou erro ao criar
)

echo [INFO] Criando banco: academic_service_db...
createdb -U postgres academic_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] academic_service_db criado
) else (
    echo [INFO] academic_service_db já existe ou erro ao criar
)

echo [INFO] Criando banco: student_service_db...
createdb -U postgres student_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] student_service_db criado
) else (
    echo [INFO] student_service_db já existe ou erro ao criar
)

echo [INFO] Criando banco: monitoring_service_db...
createdb -U postgres monitoring_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] monitoring_service_db criado
) else (
    echo [INFO] monitoring_service_db já existe ou erro ao criar
)

echo [INFO] Criando banco: attendance_service_db...
createdb -U postgres attendance_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] attendance_service_db criado
) else (
    echo [INFO] attendance_service_db já existe ou erro ao criar
)

echo [INFO] Criando banco: content_service_db...
createdb -U postgres content_service_db 2>nul
if %errorlevel% equ 0 (
    echo [OK] content_service_db criado
) else (
    echo [INFO] content_service_db já existe ou erro ao criar
)

echo.
echo ==========================================
echo [OK] Setup de bancos de dados concluído!
echo ==========================================
echo.
echo Bancos criados na porta 5432:
echo   - auth_service_db
echo   - academic_service_db
echo   - student_service_db
echo   - monitoring_service_db
echo   - attendance_service_db
echo   - content_service_db
echo.
echo Próximo passo: Execute start-services.bat
echo.
pause
