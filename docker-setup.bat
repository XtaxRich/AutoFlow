@echo off
echo ========================================
echo     AutoFlow Docker Setup
echo ========================================
echo.
echo This setup uses Docker to avoid compilation issues.
echo Docker provides a pre-configured environment with all dependencies.
echo.
echo Prerequisites:
echo - Docker Desktop for Windows
echo - At least 4GB RAM available for Docker
echo.
pause

echo [1/4] Checking Docker installation...
docker --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker not found!
    echo.
    echo Please install Docker Desktop first:
    echo 1. Visit: https://www.docker.com/products/docker-desktop/
    echo 2. Download Docker Desktop for Windows
    echo 3. Install and restart your computer
    echo 4. Start Docker Desktop
    echo 5. Run this script again
    echo.
    pause
    exit /b 1
)
echo OK: Docker is installed

echo.
echo [2/4] Checking Docker service...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Docker service is not running!
    echo.
    echo Please start Docker Desktop:
    echo 1. Open Docker Desktop application
    echo 2. Wait for it to start (may take a few minutes)
    echo 3. Look for "Docker Desktop is running" in system tray
    echo 4. Run this script again
    echo.
    pause
    exit /b 1
)
echo OK: Docker service is running

echo.
echo [3/4] Building AutoFlow Docker image...
echo This may take 5-10 minutes on first run...
echo.
docker build -t autoflow:latest .
if %errorlevel% neq 0 (
    echo ERROR: Docker build failed!
    echo.
    echo Common causes:
    echo 1. Network connection issues
    echo 2. Insufficient disk space
    echo 3. Docker configuration problems
    echo.
    echo Solutions:
    echo 1. Check internet connection
    echo 2. Free up disk space (need ~2GB)
    echo 3. Restart Docker Desktop
    echo 4. Try running as administrator
    echo.
    pause
    exit /b 1
)

echo.
echo [4/4] Testing Docker image...
docker run --rm autoflow:latest python -c "import playwright; print('Playwright version:', playwright.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Docker image test failed
    echo The image was built but may have issues
    echo You can still try running it with docker-run.bat
) else (
    echo OK: Docker image is working correctly
)

echo.
echo ========================================
echo     Docker Setup Complete!
echo ========================================
echo.
echo AutoFlow Docker image has been created successfully.
echo.
echo To run the program:
echo 1. Use: docker-run.bat
echo 2. Or manually: docker run -it --rm autoflow:latest
echo.
echo Benefits of Docker approach:
echo - No compilation issues
echo - Isolated environment
echo - Consistent behavior across systems
echo - Easy to distribute and deploy
echo.
echo ========================================
echo.
pause