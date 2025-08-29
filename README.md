# AutoFlow 视频制作工具

🎬 一个智能的自动化视频制作工具，帮助您批量制作教学视频。

## 📖 项目介绍

AutoFlow 是一个基于 Python 和 Playwright 的自动化视频制作工具，专为教学视频批量制作而设计。它可以：

- 🎯 **自动化操作**：模拟用户在网页上的点击、输入等操作
- 📹 **视频录制**：自动录制操作过程并生成视频文件
- 📚 **批量处理**：支持批量处理多个课件数据
- 🔧 **灵活配置**：通过 JSON 配置文件自定义操作流程
- 💻 **跨平台**：支持 Windows 系统

## 🛠️ 手动安装步骤

### 环境要求

- Windows 系统
- Python 3.8 或更高版本
- 网络连接（用于下载依赖）

### 安装步骤

1. **克隆或下载项目**
   ```bash
   git clone <repository-url>
   cd autoflow
   ```

2. **创建虚拟环境（推荐）**
   ```bash
   python -m venv venv
   venv\Scripts\activate
   ```

3. **安装依赖**
   ```bash
   pip install -r requirements.txt
   ```

4. **安装 Playwright 浏览器**
   ```bash
   playwright install chromium
   ```

5. **配置登录信息**
   - 编辑 `config.json` 文件
   - 修改其中的用户名和密码
   ```json
   {
     "username": "您的用户名",
     "password": "您的密码"
   }
   ```

6. **准备数据文件**
   - 将课件数据文件放入 `data` 文件夹
   - 文件命名格式：`1.1.json`、`2.3.json` 等

## 🚀 使用方法

1. **启动程序**
   ```bash
   python autoflow.py
   ```

2. **按提示操作**
   - 输入要处理的章节号
   - 程序会自动读取对应的数据文件
   - 开始自动化视频制作过程

3. **查看结果**
   - 生成的视频文件会保存在项目目录中
   - 日志文件保存在 `logs` 文件夹中

## 📁 项目结构

```
autoflow/
├── autoflow.py          # 主程序文件
├── config.json          # 配置文件
├── requirements.txt     # Python 依赖列表
├── data/               # 课件数据文件夹
│   ├── 1.1.json
│   ├── 1.2.json
│   └── ...
├── logs/               # 日志和截图文件夹
└── README.md           # 项目说明文档
```

## 📝 数据文件格式

数据文件采用 JSON 格式，包含课件的操作步骤和配置信息。示例：

```json
{
  "title": "课件标题",
  "steps": [
    {
      "action": "click",
      "selector": "#button-id",
      "description": "点击按钮"
    },
    {
      "action": "input",
      "selector": "#input-field",
      "value": "输入内容",
      "description": "输入文本"
    }
  ]
}
```

## ⚠️ 注意事项

- 首次运行可能需要较长时间下载浏览器组件
- 确保网络连接稳定，避免下载中断
- 建议在虚拟环境中运行，避免依赖冲突
- 运行过程中请勿操作鼠标键盘，以免干扰自动化流程

## 🔧 故障排除

### 常见问题

1. **Python 版本过低**
   - 确保使用 Python 3.8 或更高版本
   - 使用 `python --version` 检查版本

2. **依赖安装失败**
   - 尝试升级 pip：`python -m pip install --upgrade pip`
   - 使用国内镜像：`pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple/`

3. **浏览器下载失败**
   - 检查网络连接
   - 重试命令：`playwright install chromium`

4. **程序运行错误**
   - 检查 `logs` 文件夹中的错误日志
   - 确认数据文件格式正确
   - 验证配置文件中的登录信息

## 📄 许可证

本项目采用开源许可证，具体信息请查看 LICENSE 文件。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

---

如有问题，请查看日志文件或联系开发者。