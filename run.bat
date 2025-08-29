@echo off
echo ========================================
echo     AutoFlow Video Tool
echo ========================================
echo.

:: Check Python environment
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Python not found, please run setup.bat first
    pause
    exit /b 1
)

:: Check required files
if not exist "autoflow.py" (
    echo ERROR: Main program file autoflow.py not found
    pause
    exit /b 1
)

if not exist "config.json" (
    echo ERROR: Configuration file config.json not found
    echo Please make sure config file exists with correct login info
    pause
    exit /b 1
)

if not exist "data" (
    echo ERROR: Data folder not found
    echo Please create data folder and put your course files in it
    pause
    exit /b 1
)

echo OK: Environment check passed, starting program...
echo.

:: Run main program
python autoflow.py

echo.
echo Program finished, press any key to close...
pause >nul