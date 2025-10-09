---
title: "RAG 已死？聊聊 AWE-Agent 和现代检索工具"
date: 2025-10-09
tags: ["AI", "Agent", "RAG", "LLM"]
summary: "传统 RAG 太重了，现在我们只需要 markitdown、context7、grep 和 ast-grep 就能做更好的代码检索"
---

最近在重新思考 RAG（Retrieval-Augmented Generation）这件事。

说实话，传统的 RAG 方案，**太重了**。

## 传统 RAG 的痛点

我之前做过一个项目，完整的 RAG pipeline：
- 🔧 Vector Database（Pinecone/Weaviate）
- 🔧 Embedding Model（OpenAI/sentence-transformers）
- 🔧 Chunking Strategy（各种复杂的分块逻辑）
- 🔧 Reranking Model（再排序提升准确率）
- 🔧 定期同步和更新索引

部署下来：
- 💰 每月几百美元的基础设施成本
- ⏱️ 索引构建需要几小时
- 🐛 维护各种依赖和版本兼容
- 📊 还要监控向量库的健康状态

**问题是**：对于代码检索这个场景，真的需要这么复杂吗？

## AWE-Agent 的启发

最近关注到 **AWE-Agent（Autonomous Workflow Engine Agent）** 的概念。

核心思想很简单：**不要为了用 AI 而用 AI**。

很多时候，传统工具 + 合理的编排，比复杂的 AI Pipeline 更靠谱：
- 更快
- 更便宜
- 更可控
- 更容易调试

## 我现在用什么做"RAG"

答案很简单：**4 个工具就够了**。

### 1. markitdown

把各种文档转成 Markdown。

```bash
markitdown document.pdf > document.md
```

**为什么好用**：
- 支持 PDF、Word、PPT、Excel...
- 输出纯文本，LLM 友好
- 不需要复杂的文档解析

微软开源的，质量很稳定。

### 2. context7

智能的上下文提取工具。

**它能干什么**：
- 自动识别文件类型
- 提取代码结构（函数、类、模块）
- 生成简洁的上下文摘要
- 只保留 LLM 需要的信息

相比传统 RAG 的固定分块，context7 理解代码语义，提取的上下文更精准。

### 3. grep（ripgrep）

最快的文本搜索工具。

```bash
rg "function.*authenticate" --type ts
```

**为什么还在用 grep**：
- 极快（1 秒搜索整个代码库）
- 支持正则表达式
- 精确匹配，零幻觉
- 支持文件类型过滤

很多时候，你知道要找什么，grep 比向量搜索准确 10 倍。

### 4. ast-grep

基于 AST 的代码搜索。

```bash
ast-grep --pattern 'function $NAME($$$ARGS) { $$$ }'
```

**强大在哪里**：
- 理解代码语法结构
- 不受格式化影响
- 可以做复杂的代码模式匹配
- 支持结构化查询

找"所有返回 Promise 的异步函数"？ast-grep 一行搞定。

## 实际工作流

我现在的代码检索流程：

**Step 1**: 用户问问题
```
"我们的认证逻辑在哪里？"
```

**Step 2**: Agent 决策
```python
# 关键词搜索
rg "auth|authentication|login" --type ts

# 代码结构搜索
ast-grep --pattern 'class $NAME { $$$ authenticate($$$) $$$ }'

# 提取相关上下文
context7 extract src/auth/
```

**Step 3**: 组装上下文给 LLM
```
Found 3 relevant files:
1. src/auth/AuthService.ts - Main authentication service
2. src/middleware/auth.ts - Auth middleware
3. src/utils/token.ts - Token generation

[精简的代码上下文]

Question: 我们的认证逻辑在哪里？
```

**结果**：
- ⚡ 1-2 秒完成检索（传统 RAG 需要 5-10 秒）
- 💰 零基础设施成本
- 🎯 准确率更高（精确匹配 + 语义理解）
- 🔧 易于调试（每个步骤都清晰可见）

## RAG 真的死了吗？

**不是**。

准确说，是 **"All-in Vector Database"** 的方案该被重新审视了。

向量检索有它的价值：
- 模糊的语义查询
- 跨语言检索
- 大规模文档库

但对于代码检索，特别是在 Agent 场景下：
- grep/ast-grep 能解决 80% 的问题
- context7 能做智能上下文提取
- markitdown 能处理各种文档格式
- 只在真正需要语义搜索时，才加入向量检索

## 我的建议

如果你在做代码相关的 AI Agent：

**从简单开始**：
1. ✅ 先用 grep + ast-grep
2. ✅ 加上 context7 做上下文优化
3. ✅ 遇到非代码文档，用 markitdown

**按需升级**：
- 只有在简单工具不够用时，才考虑向量检索
- 即使要用，也考虑轻量级方案（如 sqlite-vec）
- 混合检索：传统工具 + 向量检索 = 最佳实践

## 工具链接

- **markitdown**: [github.com/microsoft/markitdown](https://github.com/microsoft/markitdown)
- **context7**: [context7.com](https://context7.com)
- **ripgrep**: [github.com/BurntSushi/ripgrep](https://github.com/BurntSushi/ripgrep)
- **ast-grep**: [ast-grep.github.io](https://ast-grep.github.io/)

## 最后

技术选型的本质，是 **trade-off**。

传统 RAG 不是不好，而是很多场景下，我们**根本不需要那么复杂**。

AWE-Agent 的理念提醒我们：**工具是为了解决问题，不是为了显示我们会用 AI**。

简单、快速、可靠，永远是好架构的第一原则。
