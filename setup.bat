@echo off
echo ========================================
echo     AutoFlow Setup Wizard
echo ========================================
echo.
echo Welcome to AutoFlow Video Tool!
echo This wizard will help you setup the environment.
echo.
pause

echo [1/5] Checking Python environment...
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
echo [2/5] Checking Visual C++ Build Tools...
where cl >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: Visual C++ Build Tools not found
    echo This is required for installing some Python packages
    echo.
    choice /C YN /M "Do you want to install Visual C++ Build Tools now? (Y/N)"
    if errorlevel 2 (
        echo Skipping Visual C++ Build Tools installation
        echo You can install them later by running: install-vcpp-buildtools.bat
    ) else (
        echo Starting Visual C++ Build Tools installation...
        call install-vcpp-buildtools.bat
        if %errorlevel% neq 0 (
            echo Visual C++ Build Tools installation failed
            echo Continuing with package installation...
        )
    )
) else (
    echo OK: Visual C++ Build Tools are available
)

echo.
echo [3/5] Installing required packages...
echo Installing playwright...
pip install playwright==1.40.0
if %errorlevel% neq 0 (
    echo ERROR: Package installation failed
    echo.
    echo This might be due to missing Visual C++ Build Tools.
    echo Trying alternative solutions:
    echo.
    echo 1. Using pre-compiled wheels from China mirror...
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple playwright==1.40.0
    if %errorlevel% neq 0 (
        echo.
        echo 2. Trying to install without build dependencies...
        pip install --only-binary=all playwright==1.40.0
        if %errorlevel% neq 0 (
            echo.
            echo ERROR: All installation methods failed.
            echo.
            echo Please install Microsoft Visual C++ Build Tools:
            echo 1. Visit: https://visualstudio.microsoft.com/visual-cpp-build-tools/
            echo 2. Download and install "C++ build tools"
            echo 3. Restart this setup after installation
            echo.
            echo Alternative: Install Visual Studio Community with C++ workload
            pause
            exit /b 1
        )
    )
)
echo OK: Package installation completed

echo.
echo [4/5] Installing browser components...
echo Downloading Chromium browser (may take a few minutes)...
playwright install chromium
if %errorlevel% neq 0 (
    echo ERROR: Browser installation failed
    echo Please check network connection and retry
    pause
    exit /b 1
)
echo OK: Browser installation completed

echo.
echo [5/5] Creating necessary folders...
if not exist "logs" mkdir logs
if not exist "data" mkdir data
echo OK: Folders created

echo.
echo ========================================
echo     Setup Complete!
echo ========================================
echo.
echo Next steps:
echo 1. Put your data files in data folder
echo 2. Edit config.json with your login info
echo 3. Double-click run.bat to start
echo.
echo For detailed instructions, see: manual.md
echo.
pause