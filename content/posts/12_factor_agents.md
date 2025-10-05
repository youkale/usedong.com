---
title: "humanlayer - 12 factor agents"
date: 2025-10-01
tags: ["LLM", "Agent"]
---

这里是humanlayer的Agent的设计的一些思路，总共有12条，
好比软件时代“设计模式”，总结下来有如下几条：

- Factor 1	自然语言到工具调用	将自然语言输入转化为结构化的工具调用。
- Factor 2	拥有你的提示词	对你的提示词（Prompt）拥有完全的控制和管理。
- Factor 3	拥有你的上下文窗口	主动管理和控制Agent的上下文窗口（Context Window）。
- Factor 4	工具只是结构化输出	将Agent使用的工具视为LLM产生的结构化输出（如JSON）。
- Factor 5	统一执行状态和业务状态	将Agent的执行状态与实际的业务状态保持同步和统一管理。
- Factor 6	通过简单的API启动/暂停/恢复	为Agent提供简单且可控的API来管理其生命周期（启动、暂停、恢复）。
- Factor 7	通过工具调用联系人类	将“联系人类”视为Agent可以调用的一种特殊工具。
- Factor 8	拥有你的控制流	避免完全依赖LLM的循环决策，对Agent的工作流程拥有确定性的控制。
- Factor 9	将错误压缩到上下文窗口中	以简洁、易于LLM理解的方式处理并报告错误，将其高效地纳入上下文。
- Factor 10	小型、专注的代理	构建职责单一、功能聚焦的小型Agent，而非一个包罗万象的巨型Agent。
- Factor 11	从任何地方触发，在用户所在之处提供服务	确保Agent可以从多种渠道（如Webhook、消息、Cron等）触发，并在用户最方便的地方与之交互。
- Factor 12	让你的代理成为一个无状态的归约器	设计Agent的核心逻辑为一个无状态的函数（类似于Reducer），它接收输入和历史状态，并产生下一步的动作。

有兴趣可以到这个[地址](https://github.com/humanlayer/12-factor-agents)阅读了解一下
