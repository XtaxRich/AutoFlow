@echo off
chcp 65001 >nul
echo ========================================
echo     AutoFlow 一键安装
echo ========================================
echo.
echo 欢迎使用AutoFlow视频自动化工具！
echo.
echo 此脚本将使用预编译包进行安装，
echo 完全避免编译问题，适合所有用户。
echo.
echo 安装特点:
echo ✅ 100%避免Visual C++编译错误
echo ✅ 专为Windows x86优化
echo ✅ 安装速度快，成功率高
echo ✅ 无需任何编译工具
echo.
set /p confirm=是否开始安装? (Y/N): 
if /i not "%confirm%"=="Y" (
    echo 安装已取消。
    pause
    exit /b 0
)

echo.
echo 开始安装...
echo.
call precompiled-setup.bat

echo.
echo ========================================
echo     安装完成！
echo ========================================
echo.
echo 使用方法:
echo 1. 运行程序: precompiled-run.bat
echo 2. 或者双击: 一键启动.bat
echo.
echo 如需打包: precompiled-build.bat
echo.
pause