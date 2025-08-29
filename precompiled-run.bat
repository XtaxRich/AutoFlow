@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 预编译版启动器
echo ========================================
echo.

:: 检查预编译环境
if not exist "venv_precompiled" (
    echo ❌ 未找到预编译环境
    echo 请先运行: precompiled-setup.bat
    pause
    exit /b 1
)

:: 检查主程序
if not exist "autoflow.py" (
    echo ❌ 未找到主程序 autoflow.py
    pause
    exit /b 1
)

:: 检查配置文件
if not exist "config.json" (
    echo ❌ 未找到配置文件 config.json
    echo 请确保配置文件存在
    pause
    exit /b 1
)

:: 激活预编译环境
echo [1/3] 激活预编译环境...
call venv_precompiled\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 激活环境失败
    pause
    exit /b 1
)
echo ✅ 环境激活成功

:: 验证playwright
echo [2/3] 验证Playwright安装...
python -c "import playwright; print('✅ Playwright可用')" 2>nul
if errorlevel 1 (
    echo ❌ Playwright验证失败
    echo 请重新运行: precompiled-setup.bat
    pause
    exit /b 1
)

:: 检查浏览器
echo [3/3] 检查浏览器组件...
python -c "from playwright.sync_api import sync_playwright; p = sync_playwright().start(); print('✅ 浏览器可用'); p.stop()" 2>nul
if errorlevel 1 (
    echo ⚠️  浏览器组件可能未安装，尝试安装...
    python -m playwright install chromium
    if errorlevel 1 (
        echo ❌ 浏览器安装失败，但程序可能仍可运行
    )
)

echo.
echo ========================================
echo     🚀 启动 AutoFlow
echo ========================================
echo.
echo 程序正在启动，请稍候...
echo 如需停止程序，请关闭浏览器窗口或按 Ctrl+C
echo.

:: 启动主程序
python autoflow.py

echo.
echo ========================================
echo     程序已结束
echo ========================================
echo.
pause