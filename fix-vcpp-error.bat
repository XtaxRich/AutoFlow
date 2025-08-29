@echo off
echo ========================================
echo     Visual C++ Build Tools Fix
echo ========================================
echo.
echo This script will try to fix the Visual C++ build tools error
echo that occurs when installing Python packages with C extensions.
echo.
pause

echo [1/3] Trying to install playwright with pre-compiled wheels...
pip install --only-binary=all playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Installation successful with pre-compiled wheels
    goto :success
)

echo [2/3] Trying China mirror with pre-compiled wheels...
pip install --only-binary=all -i https://pypi.tuna.tsinghua.edu.cn/simple playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Installation successful with China mirror
    goto :success
)

echo [3/3] Trying to upgrade pip and setuptools first...
pip install --upgrade pip setuptools wheel
pip install playwright==1.40.0
if %errorlevel% equ 0 (
    echo OK: Installation successful after upgrading tools
    goto :success
)

echo.
echo ========================================
echo     Manual Installation Required
echo ========================================
echo.
echo All automatic fixes failed. You need to install Visual C++ Build Tools:
echo.
echo Option 1 - Automated Installation (Recommended):
echo 1. Run: install-vcpp-buildtools.bat
echo 2. Follow the installation wizard
echo 3. Restart your computer after installation
echo 4. Run setup.bat again
echo.
echo Option 2 - Manual Installation:
echo 1. Visit: https://visualstudio.microsoft.com/visual-cpp-build-tools/
echo 2. Download "Build Tools for Visual Studio"
echo 3. Run installer and select "C++ build tools" workload
echo 4. Restart your computer after installation
echo 5. Run setup.bat again
echo.
echo Option 2 - Visual Studio Community (Full IDE):
echo 1. Visit: https://visualstudio.microsoft.com/vs/community/
echo 2. Download Visual Studio Community
echo 3. During installation, select "Desktop development with C++"
echo 4. Restart your computer after installation
echo 5. Run setup.bat again
echo.
echo Option 3 - Use WSL (Windows Subsystem for Linux):
echo 1. Enable WSL in Windows Features
echo 2. Install Ubuntu from Microsoft Store
echo 3. Run the Python script in WSL environment
echo.
goto :end

:success
echo.
echo ========================================
echo     Fix Successful!
echo ========================================
echo.
echo Playwright has been installed successfully.
echo You can now run setup.bat to complete the installation,
echo or run run.bat to start the program.
echo.

:end
pause