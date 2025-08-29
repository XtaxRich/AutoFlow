@echo off
echo ========================================
echo     Visual C++ Build Tools Installer
echo ========================================
echo.
echo This script will download and install Microsoft Visual C++ Build Tools
echo which are required for compiling Python packages with C extensions.
echo.
echo IMPORTANT: This will download approximately 1-3 GB of data.
echo Make sure you have a stable internet connection.
echo.
pause

echo [1/4] Checking if Visual C++ Build Tools are already installed...
where cl >nul 2>&1
if %errorlevel% equ 0 (
    echo OK: Visual C++ Build Tools are already installed
    echo You can now run setup.bat to install the application
    pause
    exit /b 0
)

echo [2/4] Creating temporary download directory...
set TEMP_DIR=%TEMP%\vcpp_buildtools
if not exist "%TEMP_DIR%" mkdir "%TEMP_DIR%"
cd /d "%TEMP_DIR%"

echo [3/4] Downloading Visual C++ Build Tools installer...
echo This may take several minutes depending on your internet speed...
echo.
echo Downloading from: https://aka.ms/vs/17/release/vs_buildtools.exe
echo.
powershell -Command "& {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_buildtools.exe' -OutFile 'vs_buildtools.exe'}"
if %errorlevel% neq 0 (
    echo ERROR: Failed to download Visual C++ Build Tools installer
    echo.
    echo Please try one of these alternatives:
    echo 1. Download manually from: https://visualstudio.microsoft.com/visual-cpp-build-tools/
    echo 2. Check your internet connection and try again
    echo 3. Use a VPN if the download is blocked in your region
    pause
    exit /b 1
)

echo [4/4] Installing Visual C++ Build Tools...
echo.
echo IMPORTANT NOTES:
 echo - The installer will open in a new window
 echo - Select "C++ build tools" workload when prompted
 echo - The installation may take 30-60 minutes
 echo - Your computer may restart during installation
echo.
echo Starting installer...
start /wait vs_buildtools.exe --quiet --wait --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended
if %errorlevel% neq 0 (
    echo.
    echo Installation may have failed or been cancelled.
    echo If you cancelled, you can run this script again later.
    echo If it failed, try running the installer manually:
    echo.
    echo 1. Navigate to: %TEMP_DIR%
    echo 2. Run: vs_buildtools.exe
    echo 3. Select "C++ build tools" workload
    echo 4. Click Install
    pause
    exit /b 1
)

echo.
echo ========================================
echo     Installation Complete!
echo ========================================
echo.
echo Visual C++ Build Tools have been installed successfully.
echo You may need to restart your computer for changes to take effect.
echo.
echo Next steps:
echo 1. Restart your computer (recommended)
echo 2. Run setup.bat to install the AutoFlow application
echo 3. If you still encounter errors, run fix-vcpp-error.bat
echo.
echo Cleaning up temporary files...
cd /d %USERPROFILE%
rmdir /s /q "%TEMP_DIR%" >nul 2>&1
echo.
pause