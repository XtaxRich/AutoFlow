@echo off
echo ========================================
echo     AutoFlow Installation Wizard
echo ========================================
echo.
echo Welcome to AutoFlow Video Automation Tool!
echo.
echo Please choose your preferred installation method:
echo.
echo 1. 离线安装 (最佳选择 - 完全离线)
echo    - 使用本地预编译包，无需网络下载
echo    - 专为Win64优化，100%避免编译
echo    - 安装速度最快，成功率最高
echo.
echo 2. 预编译安装 (推荐 - 完全无编译)
echo    - 使用预编译包，100%避免编译问题
echo    - 专为x86优化，最稳定可靠
echo    - 适合所有用户
echo.
echo 3. Portable Setup
echo    - 虚拟环境安装
echo    - 大多数情况下无需编译
echo    - 备选方案
echo.
echo 4. Standard Setup
echo    - 传统安装方式
echo    - 可能需要Visual C++构建工具
echo    - 包含自动修复
echo.
echo 5. Docker Setup
echo    - 适合技术用户
echo    - 需要Docker Desktop
echo    - 完全隔离环境
echo.
echo 6. Cloud Solutions
echo    - 无需本地安装
echo    - GitHub Codespaces, Google Colab等
echo    - 查看文档
echo.
echo 7. Exit
echo.
set /p choice=Enter your choice (1-7): 

if "%choice%"=="1" goto offline
if "%choice%"=="2" goto precompiled
if "%choice%"=="3" goto portable
if "%choice%"=="4" goto standard
if "%choice%"=="5" goto docker
if "%choice%"=="6" goto cloud
if "%choice%"=="7" goto exit

echo Invalid choice. Please enter 1, 2, 3, 4, 5, 6, or 7.
pause
goto start

:offline
echo.
echo ========================================
echo     离线安装 (最佳选择)
echo ========================================
echo.
echo 此方法使用本地预编译包，完全离线安装。
echo 无需网络下载，安装速度最快，成功率最高。
echo.
echo 特点:
echo - 使用本地预编译包，无需网络下载
echo - 专为Windows 64位优化
echo - 100%避免编译问题
echo - 安装速度最快
echo - 支持完全离线环境
echo.
echo 要求:
echo - Windows 64位系统
echo - Python 3.8+
echo - wheels目录中包含预编译包
echo.
pause
call offline-setup.bat
goto end

:precompiled
echo.
echo ========================================
echo     预编译安装 (推荐)
echo ========================================
echo.
echo 此方法使用预编译的wheel包，完全避免编译过程。
echo 这是最稳定可靠的安装方式，适合所有用户。
echo.
echo 特点:
echo - 100%避免Visual C++编译问题
echo - 专为Windows x86优化
echo - 安装速度快，成功率高
echo - 无需任何编译工具
echo.
pause
call precompiled-setup.bat
goto end

:portable
echo.
echo ========================================
echo     Starting Portable Setup
echo ========================================
echo.
echo This method uses a virtual environment to avoid compilation issues.
echo It's the most reliable option for most users.
echo.
pause
call portable-setup.bat
goto end

:standard
echo.
echo ========================================
echo     Starting Standard Setup
echo ========================================
echo.
echo This method may require Visual C++ build tools.
echo The script will try to install them automatically if needed.
echo.
set /p lang=Choose language - Chinese (C) or English (E): 
if /i "%lang%"=="C" (
    call 安装.bat
) else (
    call setup.bat
)
goto end

:docker
echo.
echo ========================================
echo     Starting Docker Setup
echo ========================================
echo.
echo This method requires Docker Desktop to be installed.
echo It provides a completely isolated environment.
echo.
echo Prerequisites:
echo - Docker Desktop for Windows
echo - At least 4GB RAM for Docker
echo.
set /p confirm=Do you have Docker Desktop installed? (Y/N): 
if /i "%confirm%"=="Y" (
    call docker-setup.bat
) else (
    echo.
    echo Please install Docker Desktop first:
    echo 1. Visit: https://www.docker.com/products/docker-desktop/
    echo 2. Download and install Docker Desktop
    echo 3. Start Docker Desktop
    echo 4. Run this script again
    echo.
    pause
)
goto end

:cloud
echo.
echo ========================================
echo     Cloud Solutions Information
echo ========================================
echo.
echo Cloud solutions allow you to run AutoFlow without local installation.
echo.
echo Available options:
echo 1. GitHub Codespaces (Recommended)
echo    - Free 60 hours per month
    - Browser-based development environment
echo    - Automatic setup
echo.
echo 2. Google Colab
echo    - Free Google service
echo    - Jupyter notebook interface
echo    - Good for experimentation
echo.
echo 3. Replit
echo    - Online IDE
echo    - Easy to use
echo    - Free tier available
echo.
echo 4. WSL (Windows Subsystem for Linux)
echo    - Run Linux on Windows
echo    - Avoids Windows compilation issues
echo    - Local but isolated
echo.
echo For detailed instructions, please read: cloud-solution.md
echo.
set /p open=Open cloud-solution.md documentation? (Y/N): 
if /i "%open%"=="Y" (
    start notepad cloud-solution.md
)
goto end

:exit
echo.
echo Thank you for using AutoFlow!
echo You can run this script again anytime to choose a different setup method.
echo.
goto end

:end
echo.
echo ========================================
echo     Setup Wizard Complete
echo ========================================
echo.
echo If you need help:
echo - Read the user manual: manual.md
echo - Check troubleshooting: README.md
echo - View cloud solutions: cloud-solution.md
echo.
pause