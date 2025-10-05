---
title: "McFly - 让终端历史搜索变得智能"
date: 2024-10-08
tags: ["Shell", "Terminal", "Rust", "CLI"]
image: "https://opengraph.githubassets.com/1/cantino/mcfly"
github: "https://github.com/cantino/mcfly"
summary: "一款基于神经网络的智能终端历史搜索工具，彻底改变 Ctrl-R 的使用体验"
---

# McFly - 智能的 Shell 历史搜索工具

🚀 Fly through your shell history. Great Scott!

{{< linkcard
  url="https://github.com/cantino/mcfly"
  title="McFly - GitHub"
  description="Fly through your shell history. Great Scott! 智能的终端历史搜索工具"
  image="https://opengraph.githubassets.com/1/cantino/mcfly"
  site="github.com"
>}}

## 为什么我开始使用 McFly

作为一个开发者，每天在终端里输入大量的命令。传统的 `Ctrl-R` 历史搜索虽然能用，但体验真的很一般：

- 只能简单的字符串匹配
- 结果按时间倒序，不够智能
- 界面简陋，一次只显示一条
- 无法考虑当前工作目录的上下文

直到遇到 [McFly](https://github.com/cantino/mcfly)，这一切都改变了。

## McFly 是什么

McFly 是一款用 Rust 编写的智能终端历史搜索工具，它使用小型神经网络来预测和排序你最可能需要的命令。名字来源于《回到未来》（Back to the Future）中的主角 Marty McFly，寓意在历史中快速穿梭。

**项目数据**：
- ⭐ Stars: 7.4k+
- 🍴 Forks: 183
- 📝 License: MIT
- 🦀 语言: Rust (87.9%)

## 核心特性

### 1. 智能排序 🧠

McFly 不是简单的按时间排序，而是通过神经网络考虑多个因素：

- **当前目录**：优先显示在当前目录执行过的命令
- **命令退出状态**：更偏好成功执行的命令
- **使用频率**：经常使用的命令排名更高
- **最近使用时间**：结合历史和近期的使用模式
- **目录上下文**：理解目录之间的关联性

### 2. 小型神经网络

McFly 使用训练好的小型神经网络来预测你下一步最可能需要的命令。这听起来很复杂，但实际使用中你会发现：

> 它几乎总能猜对你要找的命令！

### 3. 优雅的界面

与传统 `Ctrl-R` 相比，McFly 提供了更友好的交互界面：

```
$ [你的搜索词]
────────────────────────────────────────
> git commit -m "feat: add new feature"
  git push origin main
  git status
  git log --oneline
  git diff HEAD
────────────────────────────────────────
[5/127 commands shown]
```

### 4. 多 Shell 支持

- ✅ Bash
- ✅ Zsh
- ✅ Fish
- ✅ PowerShell

## 我的实际使用体验

### 场景 1: 查找复杂命令

以前我经常需要查找类似这样的 Docker 命令：

```bash
docker run -it --rm -v $(pwd):/app -w /app node:16 npm install
```

**使用传统 Ctrl-R**：
- 需要记住命令的开头
- 要按很多次 `Ctrl-R` 翻找
- 有时候找不到，只能翻笔记

**使用 McFly**：
- 只需输入 `docker node` 或者 `npm install`
- 立即找到这条命令
- 因为我经常在当前项目目录使用，所以排序很靠前

### 场景 2: 目录相关的命令

在 `/Users/sean/dev_projects/blog` 目录下，我输入 `hugo`，McFly 会优先显示：

```bash
hugo server -D
hugo new posts/my-article.md
hugo --minify
```

而不是其他项目目录下执行的 `hugo` 命令。这种**目录感知能力**非常实用！

### 场景 3: 模糊搜索

启用模糊搜索后，即使记不清完整命令，也能找到：

- 搜索 `git cm` → 找到 `git commit -m "..."`
- 搜索 `dkr ps` → 找到 `docker ps -a`
- 搜索 `npm i` → 找到 `npm install --save-dev ...`

## 安装配置

### 安装

**macOS (Homebrew)**:
```bash
brew install mcfly
```

**Linux (使用 Homebrew)**:
```bash
brew install mcfly
```

**从源码编译**:
```bash
cargo install mcfly
```

**Arch Linux**:
```bash
yay -S mcfly
```

### 配置 Shell

**Bash** - 在 `~/.bashrc` 添加:
```bash
eval "$(mcfly init bash)"
```

**Zsh** - 在 `~/.zshrc` 添加:
```bash
eval "$(mcfly init zsh)"
```

**Fish** - 在 `~/.config/fish/config.fish` 添加:
```fish
mcfly init fish | source
```

**PowerShell** - 在配置文件添加:
```powershell
Invoke-Expression -Command $(mcfly init powershell | out-string)
```

### 重新加载配置

```bash
# Bash/Zsh
source ~/.bashrc  # 或 ~/.zshrc

# Fish
source ~/.config/fish/config.fish
```

## 我的个性化配置

在 `~/.zshrc` 中，我添加了这些配置：

```bash
# 初始化 McFly
eval "$(mcfly init zsh)"

# 启用模糊搜索（值越大，越偏好短匹配）
export MCFLY_FUZZY=2

# 显示更多结果
export MCFLY_RESULTS=50

# 使用 Vim 键位
export MCFLY_KEY_SCHEME=vim

# 自定义提示符
export MCFLY_PROMPT="❯"

# macOS 深色/浅色模式自动切换
if [[ "$(defaults read -g AppleInterfaceStyle 2&>/dev/null)" != "Dark" ]]; then
    export MCFLY_LIGHT=TRUE
fi
```

## 使用技巧

### 1. 基本搜索

按 `Ctrl-R` 启动 McFly，然后输入搜索词：

```bash
# 搜索包含 "docker" 的命令
<Ctrl-R> docker

# 搜索多个关键词（空格分隔）
<Ctrl-R> git commit feature
```

### 2. 键盘操作

**Emacs 模式**（默认）:
- `Ctrl-N` / `↓` - 下一条命令
- `Ctrl-P` / `↑` - 上一条命令
- `Enter` - 选择命令
- `Ctrl-C` / `ESC` - 退出

**Vim 模式**:
- `j` - 下一条命令
- `k` - 上一条命令
- `Enter` - 选择命令
- `ESC` - 退出

### 3. 删除历史记录

在 McFly 界面中：
- `F2` - 删除选中的命令（会要求确认）

或者设置无需确认：
```bash
export MCFLY_DELETE_WITHOUT_CONFIRM=true
```

### 4. 查看和管理历史

**查看所有历史**:
```bash
mcfly search
```

**搜索特定命令**:
```bash
mcfly search docker
```

**导出历史记录**:
```bash
# 导出为 JSON
mcfly dump > history.json

# 导出为 CSV
mcfly dump --format csv > history.csv

# 导出特定时间范围
mcfly dump --since '2024-01-01' --before '2024-12-31'

# 使用正则表达式过滤
mcfly dump -r '^git commit'
```

### 5. 训练和优化

McFly 会自动学习你的使用模式：

- 每次成功执行命令都会增加其权重
- 失败的命令权重降低
- 在特定目录频繁使用的命令在该目录优先级更高

## 高级功能

### 界面视图切换

默认结果显示在顶部，可以切换到底部：

```bash
export MCFLY_INTERFACE_VIEW=BOTTOM
```

### 结果排序方式

```bash
# 按智能排名（默认）
export MCFLY_RESULTS_SORT=RANK

# 按最近使用时间
export MCFLY_RESULTS_SORT=LAST_RUN
```

### 限制历史记录数量

如果历史记录太多导致启动缓慢：

```bash
export MCFLY_HISTORY_LIMIT=10000
```

### 数据库位置

McFly 将历史记录存储在 SQLite 数据库中：

- **macOS**: `~/Library/Application Support/McFly/history.db`
- **Linux**: `~/.local/share/mcfly/history.db`
- **Windows**: `%LOCALAPPDATA%\McFly\data\history.db`

## 与其他工具对比

| 特性 | McFly | fzf | Ctrl-R | atuin |
|------|-------|-----|--------|-------|
| 智能排序 | ✅ 神经网络 | ❌ | ❌ | ✅ |
| 目录上下文 | ✅ | ❌ | ❌ | ✅ |
| 模糊搜索 | ✅ | ✅ | ❌ | ✅ |
| 多 Shell | ✅ | ✅ | ✅ | ✅ |
| 云同步 | ❌ | ❌ | ❌ | ✅ |
| 学习能力 | ✅ | ❌ | ❌ | ✅ |
| 性能 | 🚀 快 | 🚀 快 | 🐌 慢 | 🚀 快 |

**我的选择理由**：
- McFly 的智能排序在日常使用中最符合直觉
- 不需要云同步（我更关注本地体验）
- Rust 编写，性能优秀
- 配置简单，开箱即用

## 实用场景

### 开发工作流

```bash
# 快速找到测试命令
<Ctrl-R> test

# 找到构建命令
<Ctrl-R> build

# 找到部署命令
<Ctrl-R> deploy
```

### 系统管理

```bash
# 找到复杂的 systemctl 命令
<Ctrl-R> systemctl

# 找到网络配置命令
<Ctrl-R> ip addr

# 找到进程管理命令
<Ctrl-R> ps aux
```

### 数据库操作

```bash
# 找到 psql 连接命令
<Ctrl-R> psql

# 找到数据库导入导出命令
<Ctrl-R> pg_dump
```

## 注意事项

### 1. HISTTIMEFORMAT

McFly 目前不解析 `HISTTIMEFORMAT`，会使用自己的时间戳格式。

### 2. 历史记录迁移

首次使用时，McFly 会自动导入现有的 shell 历史记录。

### 3. Linux Kernel 6.2+ 兼容性

新版本 Linux 内核禁用了 TIOCSTI，McFly 使用了变通方案。如果遇到问题，可以参考项目文档配置。

### 4. 性能优化

如果历史记录非常多（10 万+条），可以：
- 设置 `MCFLY_HISTORY_LIMIT` 限制搜索范围
- 定期清理无用的历史记录

## 总结与推荐

使用 McFly 几个月后，我已经完全离不开它了。它不是简单地替换 `Ctrl-R`，而是**重新定义了终端历史搜索的体验**。

### 适合你的场景

✅ **推荐使用**：
- 每天大量使用终端
- 经常需要查找历史命令
- 在多个项目目录间切换
- 喜欢高效的工作流

❌ **可能不需要**：
- 很少使用终端
- 命令历史记录很少
- 更喜欢简单工具
- 系统资源非常有限

### 我的评分

- **易用性**: ⭐⭐⭐⭐⭐
- **智能性**: ⭐⭐⭐⭐⭐
- **性能**: ⭐⭐⭐⭐⭐
- **稳定性**: ⭐⭐⭐⭐☆
- **文档**: ⭐⭐⭐⭐☆

**总分**: 4.8/5

### 最后的建议

1. **先试用默认配置** - 开箱即用的体验已经很好
2. **启用模糊搜索** - `MCFLY_FUZZY=2` 是个好的起点
3. **调整显示数量** - 如果屏幕大，可以显示更多结果
4. **定期清理** - 使用 `F2` 删除无用的历史记录
5. **耐心学习** - 给 McFly 一周时间学习你的使用模式

## 相关资源

- **GitHub**: https://github.com/cantino/mcfly
- **最新版本**: v0.9.3 (2025-02-11)
- **问题反馈**: https://github.com/cantino/mcfly/issues
- **更新日志**: https://github.com/cantino/mcfly/blob/master/CHANGELOG.txt

## 替代工具

如果 McFly 不适合你，可以考虑：

- **fzf**: 通用的模糊查找工具，也可用于历史搜索
- **atuin**: 支持云同步的历史搜索工具
- **hstr**: 另一个智能历史搜索工具
- **zsh-autosuggestions**: Zsh 的自动建议插件

---

**总之**，McFly 让我的终端工作效率提升了不少。如果你也经常在终端中"翻历史记录"，强烈建议试试 McFly！

Great Scott! 🚀
