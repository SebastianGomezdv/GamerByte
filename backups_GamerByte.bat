@echo off
setlocal enabledelayedexpansion

:: CONFIGURACIÓN 
set "backup_dir=C:\Users\Usuario\Desktop\GamerByte_backups"
set "project_dir=%CD%"
set "project_name=GamerByte"

:: Crear carpeta de backups si no existe
if not exist "%backup_dir%" (
    mkdir "%backup_dir%"
)

: : Fecha y hora 
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set day=%%a
    set month=%%b
    set year=%%c
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set hour=%%a
    set min=%%b
)

:: Formatear fecha/hora para nombre del zip
set "timestamp=%year%-%month%-%day%_%hour%-%min%"
set "zip_name=%project_name%_%timestamp%.zip"
set "zip_path=%backup_dir%\%zip_name%"
set "commit_msg=Backup automático - %timestamp%"

:: commit a git
git add .
git commit -m "%commit_msg%"
git push origin main

:: crea archivo .zip
powershell -Command "Compress-Archive -Path '%project_dir%\*' -DestinationPath '%zip_path%' -Force"

echo.
echo ✅ Backup creado: %zip_path%
echo ✅ Commit enviado con mensaje: %commit_msg%
pause
