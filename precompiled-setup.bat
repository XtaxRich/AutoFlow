@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 预编译安装 (x86专用)
echo ========================================
echo.
echo 此安装方式使用预编译的包，完全避免编译过程
echo 适用于 Windows x86 系统
echo.

:: 检查Python
echo [1/5] 检查Python环境...
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
echo [2/5] 检查系统架构...
python -c "import platform; print(platform.machine())" > temp_arch.txt
set /p ARCH=<temp_arch.txt
del temp_arch.txt
echo ✅ 系统架构: %ARCH%

if not "%ARCH%"=="x86" if not "%ARCH%"=="i386" if not "%ARCH%"=="AMD64" (
    echo ⚠️  警告: 检测到架构为 %ARCH%，此脚本主要为x86优化
    echo 是否继续? (Y/N)
    set /p continue=
    if /i not "%continue%"=="Y" exit /b 1
)

:: 创建预编译包目录
echo [3/5] 准备预编译包目录...
if not exist "precompiled" mkdir precompiled
cd precompiled

:: 下载预编译的playwright包
echo [4/5] 下载预编译包...
echo 正在下载 playwright 预编译包...

:: 尝试从多个源下载预编译包
echo 尝试从官方源下载...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 311 --abi cp311 --no-deps
if errorlevel 1 (
    echo 官方源失败，尝试清华源...
    python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 311 --abi cp311 --no-deps -i https://pypi.tuna.tsinghua.edu.cn/simple/
)
if errorlevel 1 (
    echo 清华源失败，尝试阿里源...
    python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 311 --abi cp311 --no-deps -i https://mirrors.aliyun.com/pypi/simple/
)
if errorlevel 1 (
    echo ❌ 所有源都失败了，尝试通用下载...
    python -m pip download playwright==1.40.0 --only-binary=:all: --no-deps
)

:: 检查是否下载成功
if not exist "playwright-*.whl" (
    echo ❌ 下载预编译包失败
    echo.
    echo 备选方案:
    echo 1. 检查网络连接
    echo 2. 使用Docker方案: docker-setup.bat
    echo 3. 使用云端方案: 查看 cloud-solution.md
    echo.
    pause
    exit /b 1
)

echo ✅ 预编译包下载成功

:: 返回主目录
cd ..

:: 创建虚拟环境
echo [5/5] 设置运行环境...
if exist "venv_precompiled" (
    echo 删除旧的虚拟环境...
    rmdir /s /q venv_precompiled
)

echo 创建新的虚拟环境...
python -m venv venv_precompiled
if errorlevel 1 (
    echo ❌ 创建虚拟环境失败
    pause
    exit /b 1
)

:: 激活虚拟环境
echo 激活虚拟环境...
call venv_precompiled\Scripts\activate.bat

:: 升级pip
echo 升级pip...
python -m pip install --upgrade pip

:: 安装预编译包
echo 安装预编译的playwright包...
for %%f in (precompiled\playwright-*.whl) do (
    python -m pip install "%%f" --force-reinstall --no-deps
)

if errorlevel 1 (
    echo ❌ 安装预编译包失败
    pause
    exit /b 1
)

:: 安装playwright依赖
echo 安装playwright运行时依赖...
python -m pip install typing-extensions

:: 安装浏览器
echo 下载浏览器组件...
python -m playwright install chromium
if errorlevel 1 (
    echo ❌ 浏览器安装失败，但程序可能仍可运行
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
echo     🎉 预编译安装完成！
echo ========================================
echo.
echo 使用方法:
echo 1. 运行程序: precompiled-run.bat
echo 2. 打包程序: precompiled-build.bat
echo.
echo 注意事项:
echo - 此环境使用预编译包，避免了编译过程
echo - 虚拟环境位置: venv_precompiled\
echo - 预编译包位置: precompiled\
echo.
pause