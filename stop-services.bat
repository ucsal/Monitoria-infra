@echo off
chcp 65001 > nul
echo ==========================================
echo Parando Microsserviços UCSAL
echo ==========================================
echo.

REM Parar processos Java relacionados aos serviços
echo [INFO] Procurando e parando processos Java...
echo.

REM Listar processos Java com Spring Boot
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq java.exe" /fo list ^| findstr /i "PID:"') do (
    echo [INFO] Parando processo Java (PID: %%a)
    taskkill /F /PID %%a >nul 2>nul
)

REM Parar processos Maven
for /f "tokens=2" %%a in ('tasklist /fi "imagename eq mvn.cmd" /fo list ^| findstr /i "PID:"') do (
    echo [INFO] Parando processo Maven (PID: %%a)
    taskkill /F /PID %%a >nul 2>nul
)

REM Fechar janelas CMD dos serviços
taskkill /FI "WINDOWTITLE eq Eureka Server*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Auth Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Academic Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Student Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Monitoring Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Attendance Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq Content Service*" /F >nul 2>nul
taskkill /FI "WINDOWTITLE eq API Gateway*" /F >nul 2>nul

echo.
echo ==========================================
echo [OK] Todos os serviços foram parados!
echo ==========================================
echo.
pause
