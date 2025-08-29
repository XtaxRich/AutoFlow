@echo off
echo ========================================
echo     AutoFlow Portable Setup
echo ========================================
echo.
echo This is a simplified setup that avoids complex build tools.
echo It uses pre-compiled packages and virtual environment.
echo.
pause

echo [1/6] Checking Python environment...
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found
    echo.
    echo Please install Python 3.8+ first:
    echo 1. Visit https://www.python.org/downloads/
    echo 2. Download and install latest Python
    echo 3. Check "Add Python to PATH" during installation
    echo.
    pause
    exit /b 1
)
echo OK: Python environment check passed

echo.
echo [2/6] Creating virtual environment...
if exist "venv" (
    echo Virtual environment already exists, skipping creation
) else (
    python -m venv venv
    if %errorlevel% neq 0 (
        echo ERROR: Failed to create virtual environment
        pause
        exit /b 1
    )
    echo OK: Virtual environment created
)

echo.
echo [3/6] Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)
echo OK: Virtual environment activated

echo.
echo [4/6] Upgrading pip and installing wheel...
python -m pip install --upgrade pip wheel setuptools
if %errorlevel% neq 0 (
    echo WARNING: Failed to upgrade pip, continuing...
)

echo.
echo [5/6] Installing playwright with pre-compiled wheels...
echo Trying multiple sources for maximum compatibility...
echo.

echo Method 1: Using official PyPI with binary-only installation...
pip install --only-binary=all playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Playwright installed successfully
    goto :install_browser
)

echo Method 2: Using Tsinghua University mirror...
pip install --only-binary=all -i https://pypi.tuna.tsinghua.edu.cn/simple playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Playwright installed successfully from mirror
    goto :install_browser
)

echo Method 3: Using Aliyun mirror...
pip install --only-binary=all -i https://mirrors.aliyun.com/pypi/simple playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Playwright installed successfully from Aliyun
    goto :install_browser
)

echo Method 4: Trying without binary restriction (last resort)...
pip install playwright==1.40.0
if %errorlevel% neq 0 (
    echo.
    echo ERROR: All installation methods failed.
    echo.
    echo This usually means one of the following:
    echo 1. Network connection issues
    echo 2. Python version incompatibility
    echo 3. Missing system dependencies
    echo.
    echo Suggested solutions:
    echo 1. Check your internet connection
    echo 2. Try running as administrator
    echo 3. Use the full setup with Visual C++ tools: setup.bat
    echo 4. Contact technical support
    echo.
    pause
    exit /b 1
)

:install_browser
echo.
echo [6/6] Installing browser components...
echo Downloading Chromium browser (may take a few minutes)...
playwright install chromium
if %errorlevel% neq 0 (
    echo ERROR: Browser installation failed
    echo This might be due to network issues or insufficient disk space
    echo.
    echo Suggested solutions:
    echo 1. Check internet connection
    echo 2. Ensure at least 500MB free disk space
    echo 3. Try running as administrator
    echo 4. Retry the installation
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Setup Complete!
echo ========================================
echo.
echo AutoFlow has been successfully set up in a virtual environment.
echo.
echo To run the program:
echo 1. Use: portable-run.bat
echo 2. Or manually: venv\Scripts\activate.bat then python autoflow.py
echo.
echo The virtual environment isolates this installation from your
echo system Python, avoiding conflicts and compilation issues.
echo.
echo ========================================
echo.
pause