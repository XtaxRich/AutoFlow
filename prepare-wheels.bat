@echo off
chcp 65001 >nul
echo ========================================
echo     准备预编译Wheel包
echo ========================================
echo.
echo 此脚本将下载适用于Windows x86的预编译包
echo 下载后可以离线安装，完全避免编译
echo.

:: 创建wheels目录
if not exist "wheels" mkdir wheels
cd wheels

echo [1/4] 清理旧文件...
if exist "*.whl" del *.whl
echo ✅ 清理完成

echo [2/4] 下载playwright预编译包...
echo 正在下载适用于Windows的playwright包...

:: 下载不同Python版本的包
echo 下载Python 3.8版本...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 38 --abi cp38 --no-deps --dest .
echo 下载Python 3.9版本...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 39 --abi cp39 --no-deps --dest .
echo 下载Python 3.10版本...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 310 --abi cp310 --no-deps --dest .
echo 下载Python 3.11版本...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 311 --abi cp311 --no-deps --dest .
echo 下载Python 3.12版本...
python -m pip download playwright==1.40.0 --only-binary=:all: --platform win32 --python-version 312 --abi cp312 --no-deps --dest .

:: 如果上面失败，尝试通用下载
if not exist "playwright-*.whl" (
    echo 特定版本下载失败，尝试通用下载...
    python -m pip download playwright==1.40.0 --only-binary=:all: --no-deps --dest .
)

echo [3/4] 下载依赖包...
echo 下载typing-extensions...
python -m pip download typing-extensions --only-binary=:all: --no-deps --dest .
echo 下载greenlet...
python -m pip download greenlet --only-binary=:all: --platform win32 --no-deps --dest .
echo 下载pyee...
python -m pip download pyee --only-binary=:all: --no-deps --dest .

echo [4/4] 创建安装脚本...
cd ..

:: 创建离线安装脚本
echo @echo off > install-from-wheels.bat
echo chcp 65001 ^>nul >> install-from-wheels.bat
echo echo 使用预下载的wheel包安装playwright... >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo :: 检查Python >> install-from-wheels.bat
echo python --version ^>nul 2^>^&1 >> install-from-wheels.bat
echo if errorlevel 1 ^( >> install-from-wheels.bat
echo     echo ❌ 未找到Python >> install-from-wheels.bat
echo     pause >> install-from-wheels.bat
echo     exit /b 1 >> install-from-wheels.bat
echo ^) >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo :: 创建虚拟环境 >> install-from-wheels.bat
echo if exist "venv_offline" rmdir /s /q venv_offline >> install-from-wheels.bat
echo python -m venv venv_offline >> install-from-wheels.bat
echo call venv_offline\Scripts\activate.bat >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo :: 升级pip >> install-from-wheels.bat
echo python -m pip install --upgrade pip >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo :: 安装wheel包 >> install-from-wheels.bat
echo echo 安装预编译包... >> install-from-wheels.bat
echo python -m pip install wheels\*.whl --force-reinstall --no-index --find-links wheels >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo :: 安装浏览器 >> install-from-wheels.bat
echo echo 安装浏览器组件... >> install-from-wheels.bat
echo python -m playwright install chromium >> install-from-wheels.bat
echo. >> install-from-wheels.bat
echo echo ✅ 离线安装完成！ >> install-from-wheels.bat
echo echo 使用方法: >> install-from-wheels.bat
echo echo 1. call venv_offline\Scripts\activate.bat >> install-from-wheels.bat
echo echo 2. python autoflow.py >> install-from-wheels.bat
echo pause >> install-from-wheels.bat

echo.
echo ========================================
echo     🎉 预编译包准备完成！
echo ========================================
echo.
echo 生成的文件:
echo - wheels\ 目录: 包含所有预编译包
echo - install-from-wheels.bat: 离线安装脚本
echo.
echo 使用方法:
echo 1. 将整个项目文件夹复制到目标电脑
echo 2. 在目标电脑上运行 install-from-wheels.bat
echo 3. 完全离线安装，无需编译
echo.
echo 检查下载的包:
dir wheels\*.whl
echo.
pause