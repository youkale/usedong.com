---
title: "macOS 清理工具 - Mole"
date: 2025-10-06
tags: ["macOS", "Terminal", "Clean", "Shell"]
image: "https://camo.githubusercontent.com/8271a8b39cdff5be525cc0c942694d8d377b0b6d4dd33c4a87f8a481cefc0aca/68747470733a2f2f63646e2e747739332e66756e2f696d672f6d6f6c652e6a706567"
github: "https://github.com/tw93/Mole"
summary: "像鼹鼠一样深入挖掘来清理你的 Mac，基于终端的轻量级系统清理工具"
---

# Mole - Mac 系统清理工具

🐹 像鼹鼠一样深入挖掘来清理你的 Mac。

{{< linkcard
  url="https://github.com/tw93/Mole"
  title="Mole - GitHub"
  description="Dig deep like a mole to clean your Mac. 像鼹鼠一样深入挖掘来清理你的 Mac"
  image="https://opengraph.githubassets.com/1/tw93/Mole"
  site="github.com"
>}}

## 项目简介

[Mole](https://github.com/tw93/Mole) 是一款基于终端的轻量级 Mac 清理工具，由 [@tw93](https://github.com/tw93) 开发。它可以深度清理系统缓存、日志和临时文件，彻底卸载应用程序，并提供交互式磁盘分析功能。

**项目数据**:
- ⭐ Stars: 2.4k+
- 🍴 Forks: 82
- 📝 License: MIT

## 核心特性

### 1. 🐦 深度系统清理

- 清除隐藏的缓存、日志和临时文件
- 支持浏览器缓存清理（Chrome、Safari）
- 开发工具缓存清理（Xcode、Node.js）
- 第三方应用缓存（Dropbox、Spotify 等）
- 可释放几十 GB 甚至上百 GB 空间

### 2. 📦 彻底卸载应用

- 清理 **22+** 个相关位置的文件
- 远超系统标准卸载（仅清理 1 个位置）
- 比 CleanMyMac/Lemon 更彻底
- 清理内容包括：
  - 应用支持文件和缓存
  - 偏好设置和日志
  - WebKit 存储和 Cookies
  - 扩展和插件
  - 系统级文件（需要 sudo）

### 3. 📊 交互式磁盘分析器

- 像文件管理器一样导航文件夹
- 快速找到并删除大文件
- 可视化显示目录大小
- 实时显示释放的空间

### 4. ⚡️ 快速轻量

- 基于终端，零臃肿
- 使用箭头键导航
- 支持分页显示
- 运行速度快

## 快速开始

### 安装方式

**方式 1: 使用 curl 安装**

```bash
curl -fsSL https://raw.githubusercontent.com/tw93/mole/main/install.sh | bash
```

**方式 2: 使用 Homebrew 安装**

```bash
brew install tw93/tap/mole
```

### 使用方法

```bash
# 交互式菜单
mo

# 系统清理
mo clean

# 预览模式（推荐首次使用）
mo clean --dry-run

# 管理受保护的缓存白名单
mo clean --whitelist

# 卸载应用
mo uninstall

# 磁盘分析
mo analyze

# 更新 Mole
mo update

# 从系统中移除 Mole
mo remove

# 显示帮助
mo --help

# 显示版本
mo --version
```

## 使用示例

### 深度系统清理

运行 `mo clean` 后的输出示例：

```
▶ System essentials
  ✓ User app cache (45.2GB)
  ✓ User app logs (2.1GB)
  ✓ Trash (12.3GB)

▶ Browser cleanup
  ✓ Chrome cache (8.4GB)
  ✓ Safari cache (2.1GB)

▶ Developer tools
  ✓ Xcode derived data (9.1GB)
  ✓ Node.js cache (14.2GB)

▶ Others
  ✓ Dropbox cache (5.2GB)
  ✓ Spotify cache (3.1GB)

====================================================================
🎉 CLEANUP COMPLETE!
💾 Space freed: 95.50GB | Free space now: 223.5GB
====================================================================
```

### 智能应用卸载

运行 `mo uninstall` 后的交互界面：

```
🗑️  Select Apps to Remove
═══════════════════════════
▶ ☑ Adobe Creative Cloud      (12.4G) | Old
  ☐ WeChat                    (2.1G) | Recent
  ☐ Final Cut Pro             (3.8G) | Recent

🗑️  Uninstalling: Adobe Creative Cloud
  ✓ Removed application              # /Applications/
  ✓ Cleaned 52 related files         # ~/Library/ across 12 locations
    - Support files & caches
    - Preferences & logs
    - WebKit storage & cookies
    - Extensions & plugins
    - System files with sudo

====================================================================
🎉 UNINSTALLATION COMPLETE!
💾 Space freed: 12.8GB
====================================================================
```

### 磁盘空间分析

运行 `mo analyze` 后的输出：

```
📊 Analyzing: /Users/You
═══════════════════════════════════════════════════════
Total: 156.8GB

├─ 📁 Library                                        45.2GB
│  ├─ 📁 Caches                                      28.4GB
│  └─ 📁 Application Support                         16.8GB
├─ 📁 Downloads                                      32.6GB
│  ├─ 📄 Xcode-14.3.1.dmg                            12.3GB
│  ├─ 📄 backup_2023.zip                             8.6GB
│  └─ 📦 old_projects.tar.gz                         5.2GB
├─ 📁 Movies                                         28.9GB
│  ├─ 📄 vacation_2023.mov                           15.4GB
│  └─ 📄 screencast_raw.mp4                          8.8GB
├─ 📁 Documents                                      18.4GB
└─ 📁 Desktop                                        12.7GB
```

## 安全建议

### 首次使用建议

1. **预览模式**: 使用 `mo clean --dry-run` 预览将要删除的内容
2. **白名单管理**: 使用 `mo clean --whitelist` 保护重要缓存
3. **渐进使用**: 先从小范围清理开始，逐步熟悉工具

### 默认保护的缓存

Mole 默认会保护一些重要的缓存：
- Playwright 浏览器缓存
- HuggingFace 模型文件
- 其他关键开发工具缓存

### 重要提示

⚠️ **安全第一**: 如果这台 Mac 对你非常重要，建议等 Mole 更成熟时再使用。

## FAQ

### 1. Mole 安全吗？

Mole 主要清理缓存和日志文件，不会触碰：
- 应用设置
- 用户文档
- 系统文件

建议首次使用 `mo clean --dry-run` 预览将被删除的内容。

### 2. 多久清理一次？

建议：
- 每月清理一次
- 或者在磁盘空间不足时清理

### 3. 可以保护特定缓存吗？

可以。运行 `mo clean --whitelist` 可以交互式选择要保留的缓存。

### 4. 如何更新 Mole？

```bash
mo update
```

### 5. 如何完全卸载 Mole？

```bash
mo remove
```

## 与其他清理工具对比

| 特性 | Mole | CleanMyMac | Lemon | 系统卸载 |
|------|------|------------|-------|----------|
| 清理位置 | 22+ | ~15 | ~10 | 1 |
| 开源免费 | ✅ | ❌ | ❌ | ✅ |
| 终端工具 | ✅ | ❌ | ❌ | ❌ |
| 磁盘分析 | ✅ | ✅ | ✅ | ❌ |
| 轻量级 | ✅ | ❌ | ❌ | ✅ |
| 白名单 | ✅ | ✅ | ❌ | ❌ |

## 适用场景

### 开发者

- 清理 Xcode derived data
- 清理 Node.js/npm 缓存
- 清理 Python/pip 缓存
- 清理 Docker 临时文件

### 日常用户

- 清理浏览器缓存
- 清理应用程序残留
- 清理下载的大文件
- 分析磁盘空间占用

### 系统管理员

- 批量清理多台 Mac
- 定期维护脚本
- 磁盘空间监控

## 技术栈

- **语言**: Shell Script (100%)
- **平台**: macOS
- **依赖**: 系统内置工具（无需额外依赖）

## 项目结构

```
Mole/
├── bin/           # 二进制文件
├── lib/           # 库文件
├── mo             # 主命令（短命令）
├── mole           # 主命令（完整命令）
├── install.sh     # 安装脚本
├── GUIDE.md       # 使用指南
└── README.md      # 项目说明
```

## 参与贡献

如果 Mole 帮助你释放了磁盘空间：

1. ⭐ 给项目 Star
2. 📢 分享给需要清理 Mac 的朋友
3. 🐛 通过 GitHub Issues 报告问题
4. 🔨 提交 Pull Request 改进功能

## 相关资源

- **GitHub**: https://github.com/tw93/Mole
- **小白使用指南**: [GUIDE.md](https://github.com/tw93/Mole/blob/main/GUIDE.md)
- **最新版本**: v1.6.4 (2025-10-05)

## 许可证

MIT License - 自由享受和参与开源。

## 总结

Mole 是一款：
- ✅ **开源免费** 的 Mac 清理工具
- ✅ **功能强大** 可清理 22+ 位置
- ✅ **操作简单** 基于终端的交互式界面
- ✅ **安全可靠** 支持预览和白名单
- ✅ **轻量高效** 无 GUI 臃肿，运行快速

如果你的 Mac 磁盘空间不足，或者想要彻底卸载应用程序，Mole 是一个值得尝试的工具！

---

**温馨提示**: 使用前建议先用 `mo clean --dry-run` 预览，确保不会删除重要文件。
