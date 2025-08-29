AutoFlow 离线安装包目录
========================

此目录包含已编译好的Python wheel包，支持完全离线安装。

当前包含的预编译包:
✅ undetected_playwright_patch-1.40.0.post1700587210000-py3-none-win_amd64.whl

支持的系统:
- Windows 64位 (AMD64)
- Python 3.8+

完整离线安装包列表:
1. undetected_playwright_patch-1.40.0.post1700587210000-py3-none-win_amd64.whl (已包含)
2. typing_extensions-4.8.0-py3-none-any.whl (需要时自动安装)
3. greenlet-3.0.1-cp311-cp311-win_amd64.whl (需要时自动安装)
4. pyee-11.0.1-py3-none-any.whl (需要时自动安装)

如需添加更多预编译包:
- 从 https://pypi.org 下载对应的 win_amd64 版本
- 放入此目录即可

方法3: 使用国内镜像
如果网络问题导致下载失败，可以尝试:
- 清华大学镜像: https://pypi.tuna.tsinghua.edu.cn/simple/
- 阿里云镜像: https://mirrors.aliyun.com/pypi/simple/
- 中科大镜像: https://pypi.mirrors.ustc.edu.cn/simple/

使用方法:
1. 将wheel文件放入此目录
2. 运行 precompiled-setup.bat
3. 或运行 install-from-wheels.bat (如果存在)

注意事项:
- 确保下载的wheel文件与您的Python版本兼容
- win32版本适用于32位和64位Windows系统
- 如果您的Python版本较新，可能需要下载对应版本的wheel文件

技术支持:
如果遇到问题，请查看项目根目录下的 README.md 或 manual.md 文件。