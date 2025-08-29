@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 预编译版打包器
echo ========================================
echo.

:: 检查预编译环境
if not exist "venv_precompiled" (
    echo ❌ 未找到预编译环境
    echo 请先运行: precompiled-setup.bat
    pause
    exit /b 1
)

:: 激活预编译环境
echo [1/6] 激活预编译环境...
call venv_precompiled\Scripts\activate.bat
if errorlevel 1 (
    echo ❌ 激活环境失败
    pause
    exit /b 1
)
echo ✅ 环境激活成功

:: 安装PyInstaller
echo [2/6] 安装PyInstaller...
python -m pip install pyinstaller
if errorlevel 1 (
    echo ❌ PyInstaller安装失败
    pause
    exit /b 1
)
echo ✅ PyInstaller安装成功

:: 清理旧的构建文件
echo [3/6] 清理旧构建文件...
if exist "dist" rmdir /s /q dist
if exist "build" rmdir /s /q build
if exist "*.spec" del *.spec
echo ✅ 清理完成

:: 创建spec文件
echo [4/6] 创建打包配置...
echo # -*- mode: python ; coding: utf-8 -*- > autoflow_precompiled.spec
echo. >> autoflow_precompiled.spec
echo block_cipher = None >> autoflow_precompiled.spec
echo. >> autoflow_precompiled.spec
echo a = Analysis( >> autoflow_precompiled.spec
echo     ['autoflow.py'], >> autoflow_precompiled.spec
echo     pathex=[], >> autoflow_precompiled.spec
echo     binaries=[], >> autoflow_precompiled.spec
echo     datas=[('config.json', '.'), ('data', 'data'), ('logs', 'logs')], >> autoflow_precompiled.spec
echo     hiddenimports=['playwright', 'playwright.sync_api'], >> autoflow_precompiled.spec
echo     hookspath=[], >> autoflow_precompiled.spec
echo     hooksconfig={}, >> autoflow_precompiled.spec
echo     runtime_hooks=[], >> autoflow_precompiled.spec
echo     excludes=[], >> autoflow_precompiled.spec
echo     win_no_prefer_redirects=False, >> autoflow_precompiled.spec
echo     win_private_assemblies=False, >> autoflow_precompiled.spec
echo     cipher=block_cipher, >> autoflow_precompiled.spec
echo     noarchive=False, >> autoflow_precompiled.spec
echo ^) >> autoflow_precompiled.spec
echo. >> autoflow_precompiled.spec
echo pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher^) >> autoflow_precompiled.spec
echo. >> autoflow_precompiled.spec
echo exe = EXE( >> autoflow_precompiled.spec
echo     pyz, >> autoflow_precompiled.spec
echo     a.scripts, >> autoflow_precompiled.spec
echo     a.binaries, >> autoflow_precompiled.spec
echo     a.zipfiles, >> autoflow_precompiled.spec
echo     a.datas, >> autoflow_precompiled.spec
echo     [], >> autoflow_precompiled.spec
echo     name='AutoFlow', >> autoflow_precompiled.spec
echo     debug=False, >> autoflow_precompiled.spec
echo     bootloader_ignore_signals=False, >> autoflow_precompiled.spec
echo     strip=False, >> autoflow_precompiled.spec
echo     upx=True, >> autoflow_precompiled.spec
echo     upx_exclude=[], >> autoflow_precompiled.spec
echo     runtime_tmpdir=None, >> autoflow_precompiled.spec
echo     console=True, >> autoflow_precompiled.spec
echo     disable_windowed_traceback=False, >> autoflow_precompiled.spec
echo     target_arch=None, >> autoflow_precompiled.spec
echo     codesign_identity=None, >> autoflow_precompiled.spec
echo     entitlements_file=None, >> autoflow_precompiled.spec
echo ^) >> autoflow_precompiled.spec

echo ✅ 配置文件创建完成

:: 开始打包
echo [5/6] 开始打包...
echo 这可能需要几分钟时间，请耐心等待...
echo.
pyinstaller autoflow_precompiled.spec --clean
if errorlevel 1 (
    echo ❌ 打包失败
    echo.
    echo 可能的解决方案:
    echo 1. 检查所有依赖是否正确安装
    echo 2. 确保没有其他程序占用相关文件
    echo 3. 尝试以管理员身份运行
    echo.
    pause
    exit /b 1
)

echo ✅ 打包完成

:: 复制必要文件
echo [6/6] 复制必要文件...
if not exist "dist\AutoFlow" (
    echo ❌ 打包输出目录不存在
    pause
    exit /b 1
)

:: 确保数据目录存在
if not exist "dist\AutoFlow\data" mkdir "dist\AutoFlow\data"
if not exist "dist\AutoFlow\logs" mkdir "dist\AutoFlow\logs"

:: 复制数据文件
if exist "data\*.json" copy "data\*.json" "dist\AutoFlow\data\"
if exist "config.json" copy "config.json" "dist\AutoFlow\"

:: 创建启动说明
echo 创建使用说明...
echo AutoFlow 视频自动化工具 > "dist\AutoFlow\使用说明.txt"
echo. >> "dist\AutoFlow\使用说明.txt"
echo 使用方法: >> "dist\AutoFlow\使用说明.txt"
echo 1. 确保config.json配置正确 >> "dist\AutoFlow\使用说明.txt"
echo 2. 双击AutoFlow.exe启动程序 >> "dist\AutoFlow\使用说明.txt"
echo 3. 按照程序提示操作 >> "dist\AutoFlow\使用说明.txt"
echo. >> "dist\AutoFlow\使用说明.txt"
echo 注意事项: >> "dist\AutoFlow\使用说明.txt"
echo - 首次运行可能需要下载浏览器组件 >> "dist\AutoFlow\使用说明.txt"
echo - 确保网络连接正常 >> "dist\AutoFlow\使用说明.txt"
echo - 日志文件保存在logs目录中 >> "dist\AutoFlow\使用说明.txt"

echo ✅ 文件复制完成

echo.
echo ========================================
echo     🎉 打包成功！
echo ========================================
echo.
echo 输出位置: dist\AutoFlow\
echo 主程序: dist\AutoFlow\AutoFlow.exe
echo.
echo 分发说明:
echo 1. 将整个 dist\AutoFlow 文件夹复制给用户
echo 2. 用户只需双击 AutoFlow.exe 即可运行
echo 3. 无需安装Python或其他依赖
echo.
echo 测试建议:
echo 1. 在另一台没有Python的电脑上测试
echo 2. 确保config.json配置正确
echo 3. 检查所有数据文件是否包含
echo.
set /p open=是否打开输出目录? (Y/N): 
if /i "%open%"=="Y" (
    explorer "dist\AutoFlow"
)

pause