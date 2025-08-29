# AutoFlow 视频制作工具

🎬 一个智能的自动化视频制作工具，帮助您批量制作教学视频。

## 🚀 快速开始

### 安装方式选择

我们提供多种安装方式，您可以根据自己的情况选择：

#### 方式1：离线安装（最佳选择，完全离线）
```bash
# 使用本地预编译包，无需网络下载
offline-setup.bat
```
**特点：**
- 使用本地预编译包，无需网络下载
- 专为Windows 64位优化
- 100%避免编译问题
- 安装速度最快，成功率最高
- 支持完全离线环境

#### 方式2：预编译安装（推荐，完全无编译）
```bash
# 使用预编译包，100%避免编译问题
precompiled-setup.bat
```

#### 方式3：便携式安装（备选方案）
```bash
# 使用虚拟环境，大多数情况下避免编译问题
portable-setup.bat
```

#### 方式4：标准安装
```bash
# 中文版
安装.bat

# 英文版  
setup.bat
```

#### 方式5：Docker容器（适合技术用户）
```bash
# 使用Docker避免所有依赖问题
docker-setup.bat
```

#### 方式6：云端运行（无需本地安装）
- GitHub Codespaces
- Google Colab
- Replit
- WSL（Windows子系统）

详见：[云端解决方案说明](cloud-solution.md)

### 对于普通用户（无技术背景）

1. **下载程序包**
   - 下载完整的程序包到您的电脑
   - 解压到一个专门的文件夹中

2. **初始化设置**
   ```
   双击运行：安装.bat
   ```
   - 自动检测并安装Visual C++构建工具（如需要）
   - 安装Python依赖包
   - 下载浏览器组件
   - 首次安装可能需要几分钟时间

3. **配置登录信息**
   - 用记事本打开 `config.json` 文件
   - 修改其中的用户名和密码
   - 保存文件

4. **准备数据文件**
   - 将您的课件数据文件放入 `data` 文件夹
   - 文件命名格式：`1.1.json`、`2.3.json` 等

5. **开始使用**
   ```
   双击运行：启动程序.bat
   ```
   - 按提示输入章节号
   - 程序会自动完成视频制作

### 运行

根据您选择的安装方式，使用对应的启动方法：

#### 预编译安装
```bash
precompiled-run.bat
```

#### 便携式安装
```bash
portable-run.bat
```

#### 标准安装
```bash
# 中文版（推荐）
启动程序.bat

# 英文版
run.bat
```

#### Docker容器
```bash
docker-run.bat
```

#### 云端运行
直接在云端环境中运行：
```bash
python autoflow.py
```

### 对于开发者

1. **环境要求**
   - Python 3.8+
   - pip 包管理器

2. **安装依赖**
   ```bash
   pip install -r requirements.txt
   playwright install chromium
   ```

3. **运行程序**
   ```bash
   python autoflow.py
   ```

4. **打包程序**
   ```bash
   # Windows
   build.bat
   
   # 或手动打包
   pyinstaller build.spec
   ```

## 📁 文件结构

```
AutoFlow/
├── autoflow.py          # 主程序文件
├── config.json          # 配置文件
├── requirements.txt     # Python依赖列表
├── build.spec          # PyInstaller配置
├── 安装.bat             # 环境安装脚本
├── 启动程序.bat         # 程序启动脚本
├── build.bat           # 打包脚本
├── 用户手册.md          # 详细使用说明
├── README.md           # 项目说明
├── data/               # 数据文件夹
│   ├── 1.1.json
│   ├── 1.2.json
│   └── ...
└── logs/               # 日志文件夹
    ├── debug_*.png
    └── error_*.png
```

## ⚙️ 配置说明

### config.json 配置文件

```json
{
  "login": {
    "username": "您的用户名",
    "password": "您的密码"
  },
  "settings": {
    "target_avatar_id": "410a1f0",
    "headless_mode": false,
    "max_retries": 3,
    "base_timeout": 60000
  }
}
```

### 数据文件格式

```json
{
  "slides": [
    {
      "chapter": 1,
      "section": 1,
      "main_title": "课程标题",
      "slide_number": 1,
      "video_script": "视频脚本内容"
    }
  ]
}
```

## 🔧 功能特性

- ✅ **智能重试机制** - 自动处理网络超时和临时错误
- ✅ **网络状况检测** - 根据网络情况自动调整等待时间
- ✅ **批量处理** - 一次性处理整个章节的所有视频
- ✅ **进度监控** - 实时显示处理进度和成功率
- ✅ **错误恢复** - 自动保存错误截图，支持断点续传
- ✅ **配置灵活** - 支持自定义登录信息和各种参数
- ✅ **用户友好** - 提供图形化安装和启动脚本

## 📋 系统要求

- **操作系统：** Windows 10/11
- **内存：** 至少 4GB RAM
- **硬盘：** 至少 2GB 可用空间
- **网络：** 稳定的互联网连接

## 🆘 常见问题

### Q: 安装依赖包时出现Visual C++错误怎么办？
A: 我们提供多种解决方案：
1. **强烈推荐**：使用预编译安装 `precompiled-setup.bat` - 100%避免编译问题
2. **备选方案**：使用便携式安装 `portable-setup.bat`
3. **技术用户**：使用Docker方案 `docker-setup.bat`
4. **云端方案**：使用GitHub Codespaces或其他云端环境
5. **传统方案**：运行`fix-vcpp-error.bat`获取自动修复方案

### Q: 程序提示"未找到数据文件"
A: 请检查 `data` 文件夹中是否存在对应的 JSON 文件，文件名格式应为 `章节号.json`

### Q: 登录失败
A: 请检查 `config.json` 中的用户名和密码是否正确

### Q: 网络超时频繁
A: 程序会自动检测网络状况并调整等待时间，建议在网络稳定时使用

### Q: 程序运行中断
A: 查看 `logs` 文件夹中的错误截图，重新运行程序会从中断处继续

## 📖 详细文档

更多详细信息请查看：[用户手册.md](用户手册.md)

## 🔄 版本信息

- **当前版本：** v1.0.0
- **更新日期：** 2024年1月
- **兼容性：** Windows 10/11

## 📞 技术支持

如遇问题，请：
1. 查看 `logs` 文件夹中的错误信息
2. 参考用户手册中的常见问题解答
3. 联系技术支持并提供详细的错误信息

---

**注意：** 首次使用请务必运行 `安装.bat` 进行环境初始化！