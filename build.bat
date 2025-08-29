@echo off
echo ========================================
echo     AutoFlow Build Script
echo ========================================
echo.

echo [1/5] Checking Python environment...
python --version
if %errorlevel% neq 0 (
    echo ERROR: Python not found, please install Python 3.8+
    pause
    exit /b 1
)

echo [2/5] Installing dependencies...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ERROR: Failed to install dependencies
    echo.
    echo This might be due to missing Visual C++ Build Tools.
    echo Trying alternative installation methods...
    echo.
    pip install --only-binary=all -r requirements.txt
    if %errorlevel% neq 0 (
        pip install -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt
        if %errorlevel% neq 0 (
            echo.
            echo ERROR: All installation methods failed.
            echo Please run fix-vcpp-error.bat for detailed solutions.
            pause
            exit /b 1
        )
    )
)

echo [3/5] Installing PyInstaller...
pip install pyinstaller
if %errorlevel% neq 0 (
    echo ERROR: PyInstaller installation failed
    pause
    exit /b 1
)

echo [4/5] Installing Playwright browsers...
playwright install chromium
if %errorlevel% neq 0 (
    echo ERROR: Playwright browser installation failed
    pause
    exit /b 1
)

echo [5/5] Building executable...
pyinstaller build.spec
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Build Complete!
echo ========================================
echo Executable location: dist\AutoFlow.exe
echo.
pause