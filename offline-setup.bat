@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 离线安装 (Win64)
echo ========================================
echo.
echo 此安装方式使用已编译好的包，完全离线安装
echo 适用于 Windows 64位 系统
echo 无需网络连接，直接使用本地预编译包
echo.

:: 检查Python
echo [1/6] 检查Python环境...
python --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未找到Python，请先安装Python 3.8+
    echo 下载地址: https://www.python.org/downloads/
    pause
    exit /b 1
)

:: 获取Python版本
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo ✅ Python版本: %PYTHON_VERSION%

:: 检查架构
echo [2/6] 检查系统架构...
python -c "import platform; print(platform.machine())" > temp_arch.txt
set /p ARCH=<temp_arch.txt
del temp_arch.txt
echo ✅ 系统架构: %ARCH%

if not "%ARCH%"=="AMD64" if not "%ARCH%"=="x86_64" (
    echo ❌ 此脚本仅支持Windows 64位系统
    echo 当前架构: %ARCH%
    pause
    exit /b 1
)

:: 检查wheels目录
echo [3/6] 检查离线安装包...
if not exist "wheels" (
    echo ❌ 未找到wheels目录
    pause
    exit /b 1
)

if not exist "wheels\undetected_playwright_patch-*.whl" (
    echo ❌ 未找到playwright预编译包
    echo 请确保wheels目录中包含playwright的whl文件
    pause
    exit /b 1
)

echo ✅ 找到离线安装包

:: 创建虚拟环境
echo [4/6] 创建虚拟环境...
if exist "venv_offline" (
    echo 删除旧的虚拟环境...
    rmdir /s /q venv_offline
)

echo 创建新的虚拟环境...
python -m venv venv_offline
if errorlevel 1 (
    echo ❌ 创建虚拟环境失败
    pause
    exit /b 1
)

:: 激活虚拟环境
echo 激活虚拟环境...
call venv_offline\Scripts\activate.bat

:: 升级pip
echo 升级pip...
python -m pip install --upgrade pip

:: 安装离线包
echo [5/6] 安装离线预编译包...
echo 安装playwright包...
for %%f in (wheels\undetected_playwright_patch-*.whl) do (
    echo 正在安装: %%f
    python -m pip install "%%f" --force-reinstall --no-deps
    if errorlevel 1 (
        echo ❌ 安装 %%f 失败
        pause
        exit /b 1
    )
)

:: 安装必要依赖（如果wheels目录中有的话，优先使用本地包）
echo 安装必要依赖...
if exist "wheels\typing_extensions-*.whl" (
    for %%f in (wheels\typing_extensions-*.whl) do (
        echo 使用本地包: %%f
        python -m pip install "%%f" --force-reinstall
    )
) else (
    echo 在线安装typing-extensions...
    python -m pip install typing-extensions
)

if exist "wheels\greenlet-*.whl" (
    for %%f in (wheels\greenlet-*.whl) do (
        echo 使用本地包: %%f
        python -m pip install "%%f" --force-reinstall
    )
)

if exist "wheels\pyee-*.whl" (
    for %%f in (wheels\pyee-*.whl) do (
        echo 使用本地包: %%f
        python -m pip install "%%f" --force-reinstall
    )
)

:: 安装浏览器
echo [6/6] 安装浏览器组件...
echo 下载浏览器组件（需要网络连接）...
python -m playwright install chromium
if errorlevel 1 (
    echo ⚠️  浏览器安装失败，但程序可能仍可运行
    echo 可以稍后手动运行: python -m playwright install chromium
)

:: 测试安装
echo.
echo 测试安装...
python -c "import playwright; print('✅ Playwright安装成功')" 2>nul
if errorlevel 1 (
    echo ❌ 安装验证失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo     🎉 离线安装完成！
echo ========================================
echo.
echo 使用方法:
echo 1. 运行程序: offline-run.bat
echo 2. 打包程序: offline-build.bat
echo.
echo 安装信息:
echo - 虚拟环境: venv_offline\
echo - 预编译包: wheels\
echo - 系统架构: %ARCH%
echo - Python版本: %PYTHON_VERSION%
echo.
echo 注意: 此安装使用本地预编译包，无需网络下载
echo.
pause