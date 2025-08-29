@echo off
chcp 65001 >nul
echo ========================================
echo        AutoFlow 离线版启动器
echo ========================================
echo.

:: 检查虚拟环境
if not exist "venv_offline" (
    echo ❌ 未找到离线虚拟环境
    echo 请先运行 offline-setup.bat 进行安装
    pause
    exit /b 1
)

:: 激活虚拟环境
echo 激活离线环境...
call venv_offline\Scripts\activate.bat

:: 检查playwright安装
echo 检查playwright环境...
python -c "import playwright" 2>nul
if errorlevel 1 (
    echo ❌ Playwright未正确安装
    echo 请重新运行 offline-setup.bat
    pause
    exit /b 1
)

echo ✅ 环境检查完成
echo.
echo 启动AutoFlow...
echo ========================================
echo.

:: 运行主程序
python autoflow.py

:: 程序结束后暂停
echo.
echo ========================================
echo 程序已结束
pause