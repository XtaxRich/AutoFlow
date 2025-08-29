# AutoFlow Video Tool - User Manual

## Overview
AutoFlow is an automated video creation tool that helps you generate educational videos from course materials.

## System Requirements
- Windows 10/11
- Python 3.8 or higher
- Internet connection
- At least 2GB free disk space

## Quick Start

### Step 1: Installation Options

Choose the installation method that works best for you:

#### Option 1: Portable Setup (Recommended - No Build Tools Required)
```bash
portable-setup.bat
```
Uses virtual environment and pre-compiled packages to avoid compilation issues.

#### Option 2: Standard Installation
```bash
# For Chinese users
安装.bat

# For English users  
setup.bat
```
Traditional installation with automatic Visual C++ Build Tools setup.

#### Option 3: Docker Container
```bash
docker-setup.bat
```
Uses Docker to provide a pre-configured environment.

#### Option 4: Cloud Solutions
- GitHub Codespaces
- Google Colab
- Replit
- WSL (Windows Subsystem for Linux)

See [cloud-solution.md](cloud-solution.md) for detailed instructions.

### Step 2: Configuration
1. Open `config.json` in a text editor
2. Update the login credentials:
   ```json
   {
     "username": "your_username",
     "password": "your_password",
     "target_anchor_id": "your_target_id",
     "headless": false,
     "max_retries": 3,
     "base_timeout": 30000,
     "data_folder": "data",
     "logs_folder": "logs"
   }
   ```

### Step 3: Prepare Data
1. Put your course data files (JSON format) in the `data` folder
2. Each JSON file should contain course information with the following structure:
   ```json
   {
     "chapter": "1",
     "section": "1",
     "main_title": "Course Title",
     "slide_number": 1
   }
   ```

### Step 4: Run the Program
1. Double-click `run.bat` (or the Chinese version `启动程序.bat`)
2. The program will automatically:
   - Login to the platform
   - Process each course file
   - Generate videos
   - Save screenshots and logs

## File Structure
```
autoflow/
├── autoflow.py          # Main program
├── config.json          # Configuration file
├── requirements.txt     # Python dependencies
├── setup.bat           # Installation script (English)
├── 安装.bat            # Installation script (Chinese)
├── run.bat             # Startup script (English)
├── 启动程序.bat        # Startup script (Chinese)
├── build.bat           # Build script for creating executable
├── data/               # Course data files
├── logs/               # Screenshots and error logs
└── manual.md           # This manual
```

## Configuration Options

- `username`: Your platform username
- `password`: Your platform password
- `target_anchor_id`: Target broadcaster ID
- `headless`: Run browser in background (true/false)
- `max_retries`: Maximum retry attempts for failed operations
- `base_timeout`: Base timeout in milliseconds
- `data_folder`: Folder containing course data files
- `logs_folder`: Folder for saving logs and screenshots

## Troubleshooting

### Common Issues

1. **Python not found**
   - Install Python 3.8 or higher from python.org
   - Make sure Python is added to PATH during installation

2. **Package installation fails with Visual C++ error**
   - This is a common issue on Windows when packages need to compile C extensions
   - **Quick Fix**: Run `fix-vcpp-error.bat` for automated solutions
   - **Manual Fix**: Install Microsoft Visual C++ Build Tools:
     - Visit: https://visualstudio.microsoft.com/visual-cpp-build-tools/
     - Download "Build Tools for Visual Studio"
     - Install "C++ build tools" workload
     - Restart computer and try again

3. **Package installation fails (other reasons)**
   - Check internet connection
   - Try running setup.bat as administrator
   - Use China mirror if needed

4. **Browser installation failed**
   - Check internet connection
   - Run `playwright install chromium` manually

5. **Login failed**
   - Verify username and password in config.json
   - Check if the platform is accessible

6. **Video generation failed**
   - Check data file format
   - Verify target_anchor_id is correct
   - Check logs folder for error screenshots

### Log Files
- Error screenshots are saved in the `logs` folder
- File names indicate the type of error and affected course
- Use these screenshots to diagnose issues

## Building Executable

To create a standalone executable:
1. Run `build.bat`
2. Find the executable in `dist/AutoFlow.exe`
3. Distribute the entire `dist` folder to users

## Support

For technical support:
1. Check the logs folder for error screenshots
2. Verify your configuration settings
3. Ensure all data files are in correct JSON format
4. Make sure your internet connection is stable

## Version Information
- Version: 1.0
- Last Updated: 2024
- Compatible with: Windows 10/11, Python 3.8+