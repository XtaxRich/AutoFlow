@echo off
echo ========================================
echo     AutoFlow Portable Launcher
echo ========================================
echo.

echo Checking virtual environment...
if not exist "venv\Scripts\activate.bat" (
    echo ERROR: Virtual environment not found!
    echo.
    echo Please run portable-setup.bat first to create the environment.
    echo.
    pause
    exit /b 1
)

echo Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment
    echo.
    echo Please try running portable-setup.bat again.
    echo.
    pause
    exit /b 1
)

echo Checking playwright installation...
python -c "import playwright; print('Playwright version:', playwright.__version__)" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Playwright not properly installed
    echo.
    echo Please run portable-setup.bat again to reinstall.
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Starting AutoFlow...
echo ========================================
echo.
echo Virtual environment: ACTIVE
echo Playwright: READY
echo.
echo Starting the video automation tool...
echo.

python autoflow.py

echo.
echo ========================================
echo     Program Finished
echo ========================================
echo.
echo The AutoFlow session has ended.
echo Virtual environment will remain active until you close this window.
echo.
pause