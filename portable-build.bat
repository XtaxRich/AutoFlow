@echo off
echo ========================================
echo     AutoFlow Portable Build Script
echo ========================================
echo.
echo This script builds a standalone executable using the virtual environment.
echo This avoids compilation issues by using pre-installed packages.
echo.
pause

echo [1/6] Checking virtual environment...
if not exist "venv\Scripts\activate.bat" (
    echo ERROR: Virtual environment not found!
    echo.
    echo Please run portable-setup.bat first to create the environment.
    echo.
    pause
    exit /b 1
)

echo [2/6] Activating virtual environment...
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo ERROR: Failed to activate virtual environment
    pause
    exit /b 1
)

echo [3/6] Checking dependencies...
python -c "import playwright" >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Playwright not found in virtual environment
    echo Please run portable-setup.bat first
    pause
    exit /b 1
)

echo [4/6] Installing PyInstaller in virtual environment...
pip install pyinstaller
if %errorlevel% neq 0 (
    echo ERROR: PyInstaller installation failed
    pause
    exit /b 1
)

echo [5/6] Building executable...
echo This may take several minutes...
echo.
pyinstaller --clean build.spec
if %errorlevel% neq 0 (
    echo ERROR: Build failed
    echo.
    echo Common causes:
    echo 1. Insufficient disk space
    echo 2. Antivirus interference
    echo 3. Missing dependencies
    echo.
    echo Solutions:
    echo 1. Free up disk space (need ~1GB)
    echo 2. Temporarily disable antivirus
    echo 3. Run as administrator
    echo.
    pause
    exit /b 1
)

echo [6/6] Copying additional files...
if not exist "dist\AutoFlow视频制作工具" (
    echo ERROR: Build output directory not found
    pause
    exit /b 1
)

echo Copying configuration and data files...
copy config.json "dist\AutoFlow视频制作工具\" >nul 2>&1
xcopy data "dist\AutoFlow视频制作工具\data\" /E /I /Y >nul 2>&1
xcopy logs "dist\AutoFlow视频制作工具\logs\" /E /I /Y >nul 2>&1

echo Creating user guide...
echo # AutoFlow 便携版使用说明 > "dist\AutoFlow视频制作工具\使用说明.txt"
echo. >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo 1. 双击 AutoFlow视频制作工具.exe 启动程序 >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo 2. 根据提示输入章节号（如：1.1） >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo 3. 程序将自动处理对应的视频制作任务 >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo. >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo 注意事项： >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo - 确保网络连接稳定 >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo - 首次运行可能需要下载浏览器组件 >> "dist\AutoFlow视频制作工具\使用说明.txt"
echo - 如有问题请查看 logs 文件夹中的截图 >> "dist\AutoFlow视频制作工具\使用说明.txt"

echo.
echo ========================================
echo     Build Complete!
echo ========================================
echo.
echo Executable location: dist\AutoFlow视频制作工具\AutoFlow视频制作工具.exe
echo.
echo The portable version includes:
echo - Main executable
echo - Configuration files
echo - Data files
echo - User guide
echo.
echo You can now distribute the entire 'dist\AutoFlow视频制作工具' folder
echo to users without requiring them to install Python or dependencies.
echo.
echo ========================================
echo.
pause