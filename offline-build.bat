@echo off
chcp 65001 >nul
echo ========================================
echo       AutoFlow 离线版打包器
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

:: 检查pyinstaller
echo 检查打包工具...
python -c "import PyInstaller" 2>nul
if errorlevel 1 (
    echo 安装PyInstaller...
    python -m pip install pyinstaller
    if errorlevel 1 (
        echo ❌ PyInstaller安装失败
        pause
        exit /b 1
    )
)

echo ✅ 打包工具准备完成
echo.
echo 开始打包...
echo ========================================
echo.

:: 创建打包目录
if not exist "dist" mkdir dist
if not exist "build" mkdir build

:: 使用pyinstaller打包
echo 正在打包AutoFlow...
python -m PyInstaller --onefile --windowed --name="AutoFlow-离线版" autoflow.py

if errorlevel 1 (
    echo ❌ 打包失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo     🎉 打包完成！
echo ========================================
echo.
echo 打包文件位置: dist\AutoFlow-离线版.exe
echo.
echo 注意事项:
echo - 可执行文件已包含所有依赖
echo - 首次运行可能需要下载浏览器组件
echo - 建议在目标机器上测试运行
echo.
pause