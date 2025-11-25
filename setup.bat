@echo off
echo Verificando arquivo .env...

if not exist .env (
    echo Criando arquivo .env...
    (
        echo # Database Configuration
        echo POSTGRES_USER=postgres
        echo POSTGRES_PASSWORD=postgres
        echo.
        echo # Auth Service
        echo AUTH_DB_NAME=auth_db
        echo AUTH_DB_PORT=5432
        echo.
        echo # Academic Service
        echo ACADEMIC_DB_NAME=academic_db
        echo ACADEMIC_DB_PORT=5433
        echo.
        echo # Student Service
        echo STUDENT_DB_NAME=student_db
        echo STUDENT_DB_PORT=5434
        echo.
        echo # Monitoring Service
        echo MONITORING_DB_NAME=monitoring_db
        echo MONITORING_DB_PORT=5435
        echo.
        echo # Attendance Service
        echo ATTENDANCE_DB_NAME=attendance_db
        echo ATTENDANCE_DB_PORT=5436
        echo.
        echo # Content Service
        echo CONTENT_DB_NAME=content_db
        echo CONTENT_DB_PORT=5437
    ) > .env
    echo Arquivo .env criado com sucesso!
) else (
    echo Arquivo .env ja existe.
)

echo Subindo containers Docker...
docker-compose -f docker-compose-complete.yml up -d --build

echo Setup concluido!
pause
