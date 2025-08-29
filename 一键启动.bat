@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 一键启动
echo ========================================
echo.

:: 检查是否已安装
if not exist "venv_precompiled" (
    echo ❌ 未找到预编译环境
    echo.
    echo 请先运行安装:
    echo 1. 一键安装.bat (推荐)
    echo 2. precompiled-setup.bat
    echo 3. choose-setup.bat (选择安装方式)
    echo.
    pause
    exit /b 1
)

echo 🚀 启动AutoFlow...
echo.
call precompiled-run.bat