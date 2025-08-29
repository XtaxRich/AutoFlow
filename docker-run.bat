@echo off
echo ========================================
echo     AutoFlow Docker Runner
echo ========================================
echo.

echo Checking Docker installation...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker not found!
    echo Please run docker-setup.bat first.
    pause
    exit /b 1
)

echo Checking Docker service...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker service not running!
    echo Please start Docker Desktop and try again.
    pause
    exit /b 1
)

echo Checking AutoFlow Docker image...
docker images autoflow:latest --format "table {{.Repository}}:{{.Tag}}" | findstr "autoflow:latest" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: AutoFlow Docker image not found!
    echo Please run docker-setup.bat first to build the image.
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Starting AutoFlow in Docker
echo ========================================
echo.
echo Docker image: autoflow:latest
echo Environment: Isolated container
echo Browser: Chromium (headless mode)
echo.
echo Note: The program will run in the container.
echo Logs and screenshots will be saved inside the container.
echo.
echo Starting container...
echo.

:: Run the Docker container with interactive mode
:: Mount current directory to access updated config and data files
docker run -it --rm ^^
    -v "%cd%\config.json:/app/config.json:ro" ^^
    -v "%cd%\data:/app/data:ro" ^^
    -v "%cd%\logs:/app/logs" ^^
    autoflow:latest

if %errorlevel% neq 0 (
    echo.
    echo ERROR: Container execution failed!
    echo.
    echo Common causes:
    echo 1. Configuration file issues
    echo 2. Data file problems
    echo 3. Network connectivity issues
    echo 4. Docker resource constraints
    echo.
    echo Solutions:
    echo 1. Check config.json format
    echo 2. Verify data files exist
    echo 3. Ensure stable internet connection
    echo 4. Increase Docker memory allocation
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Container Finished
echo ========================================
echo.
echo The AutoFlow container has completed execution.
echo Check the logs folder for any screenshots or error information.
echo.
pause