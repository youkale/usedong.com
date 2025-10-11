---
title: "智能体设计模式"
date: 2025-10-10
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "本文翻译并解读了常见的 Agent 设计模式，包括 ReAct、Chain of Thought、Plan-and-Execute 等，帮助你构建更加稳定和可靠的 AI Agent"
original_author: "Multiple Sources"
---

# 智能体设计模式
**Agentic Design Patterns**

一份构建智能系统的实操指南
A Hands-On Guide to Building Intelligent Systems

- **作者：** [Antonio Gulli]
- [原文地址](https://docs.google.com/document/d/1rsaK53T3Lg5KoGwvf8ukOUvbELRtH-V0LnOIFDxBryE/mobilebasic#)

## 📚 目录总览

> 全书共 424 页，涵盖从基础到高级的智能体设计模式

---

### 🎯 前言与基础

**献词、致谢、序言、思想领袖视角：权力与责任、引言** · 9 页

**什么是"代理"AI系统？** · 9 页

---

### 第一部分：基础代理模式 _（103 页）_

1. **[提示链 Prompt Chaining](/translations/agent-design-patterns-part1-01/)** · 12 页
   _通过链式提示构建复杂任务流程_

2. **[路由 Routing](/translations/agent-design-patterns-part1-02/)** · 13 页
   _智能路由，让 AI 做出正确的选择_

3. **[并行化 Parallelization](/translations/agent-design-patterns-part1-03/)** · 15 页
   _并行处理，提升效率_

4. **反思 Reflection** · 13 页
   _让 AI 自我审视与改进_

5. **工具使用 Tool Use** · 20 页
   _赋予 AI 使用外部工具的能力_

6. **规划 Planning** · 13 页
   _战略规划与任务分解_

7. **多智能体 Multi-Agent** · 17 页
   _多个智能体协同工作_

---

### 第二部分：记忆与适应 _（61 页）_

8. **记忆管理 Memory Management** · 21 页
   _构建智能体的记忆系统_

9. **学习与适应 Learning and Adaptation** · 12 页
   _从经验中学习，持续进化_

10. **模型上下文协议 Model Context Protocol (MCP)** · 16 页
    _标准化的上下文管理_

11. **目标设定与监控 Goal Setting and Monitoring** · 12 页
    _设定目标并追踪执行_

---

### 第三部分：可靠性与知识 _（34 页）_

12. **异常处理与恢复 Exception Handling and Recovery** · 8 页
    _优雅地处理错误情况_

13. **人机协作 Human-in-the-Loop** · 9 页
    _在关键环节引入人类决策_

14. **知识检索 RAG** · 17 页
    _检索增强生成技术_

---

### 第四部分：高级与性能 _（114 页）_

15. **智能体间通信 Inter-Agent Communication (A2A)** · 15 页
    _智能体之间的通信协议_

16. **资源感知优化 Resource-Aware Optimization** · 15 页
    _优化资源使用，降低成本_

17. **推理技术 Reasoning Techniques** · 24 页
    _高级推理与思维链_

18. **护栏/安全模式 Guardrails/Safety Patterns** · 19 页
    _确保 AI 系统的安全性_

19. **评估与监控 Evaluation and Monitoring** · 18 页
    _量化评估智能体性能_

20. **优先级管理 Prioritization** · 10 页
    _智能任务优先级排序_

21. **探索与发现 Exploration and Discovery** · 13 页
    _探索未知领域_

---

### 📖 附录：补充与参考 _（74 页）_

- **附录 A: 高级提示工程技术** · 28 页
- **附录 B: AI 代理化：从图形界面到现实世界环境** · 6 页
- **附录 C: 代理框架快速概览** · 8 页
- **附录 D: 使用 AgentSpace 构建代理** _（仅限线上）_ · 6 页
- **附录 E: 命令行界面的 AI 代理** _（仅限线上）_ · 5 页
- **附录 F: 幕后揭秘：代理推理引擎的内部运作** · 14 页
- **附录 G: 编写代理代码** · 7 页

---

### 📝 总结与索引

**结论、词汇表、术语索引** · 20 页

**在线资源：在线贡献 - 常见问题解答**

*脚注：所有版税将捐赠给救助儿童会 (Save the Children)。*
