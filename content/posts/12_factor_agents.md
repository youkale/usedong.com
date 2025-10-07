---
title: "读完 12 Factor Agents，我的一些思考"
date: 2025-10-01
tags: ["LLM", "Agent", "架构"]
image: "https://opengraph.githubassets.com/1/humanlayer/12-factor-agents"
github: "https://github.com/humanlayer/12-factor-agents"
summary: "看了 humanlayer 的 12 Factor Agents，感觉就像当年的 12 Factor App 一样，给 AI Agent 开发提供了一套最佳实践"
---

最近在研究 AI Agent 的架构设计，偶然看到 humanlayer 团队总结的 [12 Factor Agents](https://github.com/humanlayer/12-factor-agents)。感觉就像当年 Heroku 提出的 12 Factor App 一样，这次是专门针对 AI Agent 的最佳实践。

读完之后，我整理了一些个人理解和思考。

## 为什么需要这 12 条原则？

现在大家都在做 Agent，但很多时候都是"能跑就行"的状态。随着项目复杂度上升，问题就来了：
- Prompt 管理混乱
- 上下文爆炸
- 无法控制执行流程
- 错误处理一团糟

这 12 条原则，其实是在解决这些痛点。

## 我的理解和总结

### 1. 自然语言 → 工具调用

**核心思想**：把 LLM 当作"意图识别器"，输出结构化的函数调用。

这个我深有体会。以前直接让 LLM 生成代码或者执行命令，结果各种幻觉。后来改成先识别意图，再调用定义好的工具，稳定性提升了一个数量级。

### 2. 拥有你的 Prompt

**核心思想**：Prompt 是代码，要像管理代码一样管理它。

之前我把 Prompt 写在字符串里，改起来特别痛苦。现在我会：
- 用模板引擎管理 Prompt
- 版本控制
- 单元测试（是的，Prompt 也需要测试）

### 3. 控制上下文窗口

**核心思想**：别让上下文无限增长，主动管理。

Token 是要钱的！而且上下文太长，LLM 也容易"走神"。我的做法：
- 定期总结历史对话
- 只保留相关上下文
- 重要信息放到 System Prompt

### 4. 工具就是结构化输出

**核心思想**：别把工具看得太复杂，就是 JSON Schema。

这个观点很有意思。工具调用本质上就是让 LLM 输出符合特定格式的 JSON。理解这一点后，调试和扩展都变简单了。

### 5. 执行状态 = 业务状态

**核心思想**：Agent 的状态要和你的业务数据库同步。

这点太重要了！我之前做过一个订单处理 Agent，执行状态和订单状态分开存，结果经常对不上。后来直接把 Agent 状态和订单状态合并，世界清静了。

### 6. 简单的生命周期 API

**核心思想**：提供 `start()` / `pause()` / `resume()` 接口。

想象一下，如果你的 Agent 跑飞了，但没有办法暂停它？这就是为什么需要生命周期管理。我会在每个 Agent 里加上这些接口，方便调试和运维。

### 7. "联系人类"也是工具

**核心思想**：Human-in-the-loop 就是一种特殊的工具调用。

这个设计很优雅。Agent 不知道怎么办时，调用 `ask_human()` 工具，等待人类响应，然后继续。就像你写代码时遇到问题，问同事一样自然。

### 8. 拥有控制流

**核心思想**：别让 LLM 完全控制流程，你要有最终决定权。

我吃过亏。一开始让 LLM 自己决定下一步干什么，结果它可能陷入循环，或者跳过关键步骤。现在我会定义清晰的工作流，LLM 只负责填空。

### 9. 错误压缩

**核心思想**：把错误信息简化，别把完整堆栈丢给 LLM。

LLM 看不懂你的 500 行堆栈信息。我会提取关键错误信息：
```
Error: Database connection failed
Reason: Timeout after 30s
Suggestion: Check network or retry
```

简洁、清晰、可操作。

### 10. 小而专注的 Agent

**核心思想**：Unix 哲学，一个 Agent 只做一件事。

别试图做一个"超级 Agent"。我现在的做法：
- 订单处理 Agent：只管订单
- 客服 Agent：只管客服
- 分析 Agent：只管数据分析

需要协作时，让它们互相调用。

### 11. 多渠道触发

**核心思想**：Agent 可以从任何地方启动，在任何地方响应。

我的 Agent 可以通过：
- Webhook（外部事件）
- Cron（定时任务）
- API（手动触发）
- 消息队列（异步任务）

用户在哪里，Agent 就在哪里。

### 12. 无状态的 Reducer

**核心思想**：`(state, input) => (new_state, action)`

这是我最喜欢的一条。熟悉 Redux 的同学应该秒懂。Agent 的核心就是一个纯函数：
- 输入：当前状态 + 新输入
- 输出：新状态 + 下一步动作

这样的设计，测试、调试、重放都非常方便。

## 我的实践建议

如果你现在就要开始做 Agent，我建议：

**先关注这几条**：
1. ✅ Factor 1：先把工具调用做好
2. ✅ Factor 3：控制上下文，省钱又高效
3. ✅ Factor 8：别让 LLM 完全控制流程
4. ✅ Factor 10：从小 Agent 开始

**然后逐步完善**：
- 加上生命周期管理
- 引入人类反馈
- 优化错误处理

## 最后

这 12 条原则不是教条，而是踩坑经验的总结。

就像 12 Factor App 不是银弹一样，12 Factor Agents 也需要根据你的场景调整。但核心思想是对的：**把 Agent 当作一个可控、可测、可维护的系统来设计**。

完整内容可以看原项目：{{< linkcard url="https://github.com/humanlayer/12-factor-agents"
image="https://opengraph.githubassets.com/1/humanlayer/12-factor-agents" title="12 Factor Agents"  description="Design principles for building production-ready AI agents" site="github.com" >}}

---

你在做 Agent 时遇到过什么坑？欢迎交流 💬
