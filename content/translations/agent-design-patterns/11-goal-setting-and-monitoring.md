---
title: "第十一章：目标设定与监控（Goal Setting and Monitoring）"
date: 2025-10-12
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "通过明确的目标设定和持续监控使智能体具备目的性和自我评估能力"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 11
---

[← 上一章：模型上下文协议](../10-model-context-protocol/) | [返回目录](../)

---

# 第十一章：目标设定与监控（Goal Setting and Monitoring）
要使 AI 代理（AI agents）真正有效且具有目的性，它们需要的不仅仅是信息处理或工具使用的能力；它们还需要清晰的方向感，以及知道自己是否正在成功的途径。这就是目标设定与监控（Goal Setting and Monitoring）模式发挥作用的地方。它旨在为代理提供要努力实现的特定目标，并为其配备追踪进度和判断目标是否达成的手段。

## 目标设定与监控模式概述
设想一下规划一次旅行。你不会凭空出现在目的地。你会决定想去哪里（目标状态），弄清楚从哪里出发（初始状态），考虑可用的选项（交通、路线、预算），然后规划一系列步骤：订票、打包行李、前往机场/车站、登机/乘车、抵达、寻找住宿等。这种一步步的过程，通常会考虑到依赖关系和限制，就是我们在代理系统中所说的规划（planning）的本质。

在 AI 代理的背景下，规划通常涉及一个代理接受一个高层次目标，然后自主地或半自主地生成一系列中间步骤或子目标。这些步骤可以按顺序执行，也可以在一个更复杂的流程中执行，可能涉及其他模式，如工具使用、路由或多代理协作。规划机制可能包括复杂的搜索算法、逻辑推理，或越来越多地利用大型语言模型（LLMs）的能力，根据其训练数据和对任务的理解来生成合理且有效的计划。

良好的规划能力使代理能够解决非简单的、单步查询的问题。它使代理能够处理多方面的请求、通过重新规划来适应不断变化的环境，并协调复杂的工作流程。它是一个基本模式，支撑着许多高级的代理行为，将一个简单的响应式系统转变为一个可以主动朝着既定目标工作的系统。

## 实际应用与用例
目标设定与监控模式对于构建能够在复杂、真实世界场景中自主且可靠运行的代理至关重要。以下是一些实际应用：

**客户支持自动化：** 代理的目标可能是“解决客户的账单查询”。它监控对话，检查数据库条目，并使用工具调整账单。通过确认账单更改并收到客户积极反馈来监控成功。如果问题未解决，则进行升级。

**个性化学习系统：** 一个学习代理的目标可能是“提高学生对代数的理解”。它监控学生在练习上的进度，调整教学材料，并追踪准确率和完成时间等性能指标，如果学生遇到困难，则调整其方法。

**项目管理助手：** 一个代理可能被分配任务“确保项目里程碑 X 在日期 Y 前完成”。它监控任务状态、团队沟通和资源可用性，在目标面临风险时标记延迟并建议纠正措施。

**自动化交易机器人：** 一个交易代理的目标可能是“在保持风险承受能力的前提下最大化投资组合收益”。它持续监控市场数据、当前的投资组合价值和风险指标，在条件与其目标一致时执行交易，并在风险阈值被突破时调整策略。

**机器人技术和自动驾驶汽车：** 自动驾驶汽车的首要目标是“安全地将乘客从 A 运送到 B”。它不断监控其环境（其他车辆、行人、交通信号）、自身状态（速度、燃油）以及沿规划路线的进度，调整其驾驶行为以安全有效地实现目标。

**内容审核：** 代理的目标可能是“识别并删除平台 X 上的有害内容”。它监控传入内容，应用分类模型，并跟踪误报/漏报等指标，调整其过滤标准或将模棱两可的案例升级给人工审核员。

这种模式对于需要可靠运行、实现特定结果并适应动态条件的代理至关重要，为智能的自我管理提供了必要的框架。

## 动手代码示例
为了说明目标设定与监控模式，我们提供了一个使用 LangChain 和 OpenAI API 的示例。这个 Python 脚本概述了一个自主 AI 代理，该代理被设计用于生成和完善 Python 代码。其核心功能是为指定的问 题生成解决方案，确保遵守用户定义的质量基准。

它采用“目标设定与监控”模式，即它不只生成一次代码，而是进入一个迭代的创建、自我评估和改进的循环。代理的成功是通过其自身的 AI 驱动的判断来衡量的，即生成的代码是否成功地满足了初始目标。最终的输出是一个经过润色、带有注释且可供使用的 Python 文件，代表了这一完善过程的顶点。

```shell
Dependencies:
pip install langchain_openai openai python-dotenv
.env file with key in OPENAI_API_KEY
```

通过将此脚本想象成一个被分配到项目中的自主 AI 程序员（见图 1），你可以最好地理解它。当你向 AI 提供一个详细的项目摘要（即它需要解决的特定编码问题）时，流程就开始了。

```python
# MIT License
# Copyright (c) 2025 Mahtab Syed
# https://www.linkedin.com/in/mahtabsyed/

"""
Hands-On Code Example - Iteration 2
- To illustrate the Goal Setting and Monitoring pattern, we have an example using LangChain and OpenAI APIs:

Objective: Build an AI Agent which can write code for a specified use case based on specified goals:
- Accepts a coding problem (use case) in code or can be as input.
- Accepts a list of goals (e.g., "simple", "tested", "handles edge cases")  in code or can be input.
- Uses an LLM (like GPT-4o) to generate and refine Python code until the goals are met. (I am using max 5 iterations, this could be based on a set goal as well)
- To check if we have met our goals I am asking the LLM to judge this and answer just True or False which makes it easier to stop the iterations.
- Saves the final code in a .py file with a clean filename and a header comment.
"""

import os
import random
import re
from pathlib import Path
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv, find_dotenv

# 🔐 Load environment variables
_ = load_dotenv(find_dotenv())
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
if not OPENAI_API_KEY:
   raise EnvironmentError("❌ Please set the OPENAI_API_KEY environment variable.")

# ✅ Initialize OpenAI model
print("📡 Initializing OpenAI LLM (gpt-4o)...")
llm = ChatOpenAI(
   model="gpt-4o", # If you dont have access to got-4o use other OpenAI LLMs
   temperature=0.3,
   openai_api_key=OPENAI_API_KEY,
)

# --- Utility Functions ---

def generate_prompt(
   use_case: str, goals: list[str], previous_code: str = "", feedback: str = ""
) -> str:
   print("📝 Constructing prompt for code generation...")
   base_prompt = f"""
You are an AI coding agent. Your job is to write Python code based on the following use case:

Use Case: {use_case}

Your goals are:
{chr(10).join(f"- {g.strip()}" for g in goals)}
"""
   if previous_code:
       print("🔄 Adding previous code to the prompt for refinement.")
       base_prompt += f"\nPreviously generated code:\n{previous_code}"
   if feedback:
       print("📋 Including feedback for revision.")
       base_prompt += f"\nFeedback on previous version:\n{feedback}\n"

   base_prompt += "\nPlease return only the revised Python code. Do not include comments or explanations outside the code."
   return base_prompt

def get_code_feedback(code: str, goals: list[str]) -> str:
   print("🔍 Evaluating code against the goals...")
   feedback_prompt = f"""
You are a Python code reviewer. A code snippet is shown below. Based on the following goals:

{chr(10).join(f"- {g.strip()}" for g in goals)}

Please critique this code and identify if the goals are met. Mention if improvements are needed for clarity, simplicity, correctness, edge case handling, or test coverage.

Code:
{code}
"""
   return llm.invoke(feedback_prompt)

def goals_met(feedback_text: str, goals: list[str]) -> bool:
   """
   Uses the LLM to evaluate whether the goals have been met based on the feedback text.
   Returns True or False (parsed from LLM output).
   """
   review_prompt = f"""
You are an AI reviewer.

Here are the goals:
{chr(10).join(f"- {g.strip()}" for g in goals)}

Here is the feedback on the code:
\"\"\"
{feedback_text}
\"\"\"

Based on the feedback above, have the goals been met?

Respond with only one word: True or False.
"""
   response = llm.invoke(review_prompt).content.strip().lower()
   return response == "true"

def clean_code_block(code: str) -> str:
   lines = code.strip().splitlines()
   if lines and lines.strip().startswith("```"):
       lines = lines[1:]
   if lines and lines[-1].strip() == "```":
       lines = lines[:-1]
   return "\n".join(lines).strip()

def add_comment_header(code: str, use_case: str) -> str:
   comment = f"# This Python program implements the following use case:\n# {use_case.strip()}\n"
   return comment + "\n" + code

def to_snake_case(text: str) -> str:
   text = re.sub(r"[^a-zA-Z0-9 ]", "", text)
   return re.sub(r"\s+", "_", text.strip().lower())

def save_code_to_file(code: str, use_case: str) -> str:
   print("💾 Saving final code to file...")

   summary_prompt = (
       f"Summarize the following use case into a single lowercase word or phrase, "
       f"no more than 10 characters, suitable for a Python filename:\n\n{use_case}"
   )
   raw_summary = llm.invoke(summary_prompt).content.strip()
   short_name = re.sub(r"[^a-zA-Z0-9_]", "", raw_summary.replace(" ", "_").lower())[:10]

   random_suffix = str(random.randint(1000, 9999))
   filename = f"{short_name}_{random_suffix}.py"
   filepath = Path.cwd() / filename

   with open(filepath, "w") as f:
       f.write(code)

   print(f"✅ Code saved to: {filepath}")
   return str(filepath)

# --- Main Agent Function ---

def run_code_agent(use_case: str, goals_input: str, max_iterations: int = 5) -> str:
   goals = [g.strip() for g in goals_input.split(",")]

   print(f"\n🎯 Use Case: {use_case}")
   print("🎯 Goals:")
   for g in goals:
       print(f"  - {g}")

   previous_code = ""
   feedback = ""

   for i in range(max_iterations):
       print(f"\n=== 🔁 Iteration {i + 1} of {max_iterations} ===")
       prompt = generate_prompt(use_case, goals, previous_code, feedback if isinstance(feedback, str) else feedback.content)

       print("🚧 Generating code...")
       code_response = llm.invoke(prompt)
       raw_code = code_response.content.strip()
       code = clean_code_block(raw_code)
       print("\n🧾 Generated Code:\n" + "-" * 50 + f"\n{code}\n" + "-" * 50)

       print("\n📤 Submitting code for feedback review...")
       feedback = get_code_feedback(code, goals)
       feedback_text = feedback.content.strip()
       print("\n📥 Feedback Received:\n" + "-" * 50 + f"\n{feedback_text}\n" + "-" * 50)

       if goals_met(feedback_text, goals):
           print("✅ LLM confirms goals are met. Stopping iteration.")
           break

       print("🛠️ Goals not fully met. Preparing for next iteration...")
       previous_code = code

   final_code = add_comment_header(code, use_case)
   return save_code_to_file(final_code, use_case)

# --- CLI Test Run ---

if __name__ == "__main__":
   print("\n🧠 Welcome to the AI Code Generation Agent")

   # Example 1
   use_case_input = "Write code to find BinaryGap of a given positive integer"
   goals_input = "Code simple to understand, Functionally correct, Handles comprehensive edge cases, Takes positive integer input only, prints the results with few examples"
   run_code_agent(use_case_input, goals_input)

   # Example 2
   # use_case_input = "Write code to count the number of files in current directory and all its nested sub directories, and print the total count"
   # goals_input = (
   #     "Code simple to understand, Functionally correct, Handles comprehensive edge cases, Ignore recommendations for performance, Ignore recommendations for test suite use like unittest or pytest"
   # )
   # run_code_agent(use_case_input, goals_input)

   # Example 3
   # use_case_input = "Write code which takes a command line input of a word doc or docx file and opens it and counts the number of words, and characters in it and prints all"
   # goals_input = "Code simple to understand, Functionally correct, Handles edge cases"
   # run_code_agent(use_case_input, goals_input)
```

除了这份摘要，你还提供了一份严格的质量清单，它代表了最终代码必须满足的目标——例如，“解决方案必须简单”、“必须在功能上正确”或“需要处理意外的边缘情况”等标准。

![图片](/images/translations/agent-design-patterns/p2-11-goal-setting-and-monitoring-01.png)

图 1：目标设定与监控示例

有了这份任务，AI 程序员开始工作，并生成了它的第一个代码草稿。然而，它并没有立即提交这个初始版本，而是停下来执行了一个关键的步骤：严格的自我审查。它一丝不苟地将自己的成果与你提供的质量清单上的每一项进行比较，充当它自己的质量保证检查员。经过这次检查，它对自己的进度给出了一个简单、公正的裁决：“True”（真）如果作品符合所有标准，或者“False”（假）如果它未能达标。

如果裁决是“False”，AI 并不会放弃。它进入一个深思熟虑的修订阶段，利用自我批评的洞察力来找出弱点并智能地重写代码。这个起草、自我审查和完善的循环持续进行，每一次迭代都旨在更接近目标。这个过程会重复，直到 AI 最终通过满足每一个要求而达到“True”的状态，或直到它达到预定的尝试限制，就像一个在截止日期前工作的开发者一样。一旦代码通过了最终检查，脚本就会打包这个经过润色的解决方案，添加有用的注释，并将其保存到一个干净的新 Python 文件中，以供使用。

**注意事项与考量：** 重要的是，请注意这仅仅是一个示例性的说明，而非可用于生产的代码。对于实际应用，必须考虑几个因素。LLM 可能无法完全理解一个目标的预期含义，并可能错误地评估自己的表现为成功。即使目标被很好地理解，模型也可能产生“幻觉”（hallucinate）。当同一个 LLM 既负责编写代码又负责评判其质量时，它可能会更难发现自己正在走向错误的方向。

归根结底，LLMs 不会奇迹般地产生完美无瑕的代码；你仍然需要运行和测试生成的代码。此外，简单示例中的“监控”是基础的，存在过程永久运行的潜在风险。

**充当一位深谙产出简洁、正确和简单代码的专家代码审查员。你的核心任务是通过确保每一个建议都基于现实和最佳实践来消除代码的“幻觉”。**

**当我为你提供一段代码片段时，我希望你：**

**-- 识别并纠正错误：** 指出任何逻辑缺陷、错误或潜在的运行时错误。

**-- 简化和重构：** 建议在不牺牲正确性的前提下，使代码更具可读性、效率和可维护性的更改。

**-- 提供清晰解释：** 对于每一个建议的更改，解释为什么它是一种改进，并引用**简洁代码、性能或安全性**的原则。

**-- 提供修正后的代码：** 展示你建议更改的“之前”和“之后”，以便改进清晰可见。

**你的反馈应该是直接的、建设性的，并且始终以提高代码质量为目标。**

一种更健壮的方法涉及通过赋予一组代理特定的角色来分离这些关注点。例如，我使用 Gemini 构建了一个个人 AI 代理团队，其中每个代理都有一个特定的角色：

*   **同行程序员（The Peer Programmer）：** 帮助编写和集思广益代码。
*   **代码审查员（The Code Reviewer）：** 发现错误并提出改进建议。
*   **文档撰写者（The Documenter）：** 生成清晰简洁的文档。
*   **测试用例作者（The Test Writer）：** 创建全面的单元测试。
*   **提示词优化师（The Prompt Refiner）：** 优化与 AI 的交互。

在这个多代理系统中，代码审查员作为一个独立于程序员代理的实体，其提示词与示例中的评判者类似，这显著提高了客观评估。这种结构自然地导向更好的实践，因为测试用例作者代理可以履行编写单元测试的需求，以测试同行程序员生成的代码。

我将添加这些更复杂的控制并使代码更接近生产就绪的任务留给感兴趣的读者。

## 概要速览（At a Glance）

### 是什么 (What)

AI 代理通常缺乏清晰的方向，这使得它们无法超越简单的响应式任务而有目的地行动。没有明确定义的目标，它们无法独立应对复杂的、多步骤的问题或协调精密的工作流程。此外，它们没有固有的机制来判断它们的行动是否正在导向成功的成果。这限制了它们的自主性，并阻止了它们在仅凭任务执行是不够的动态、真实世界场景中真正发挥作用。

---

### 为什么 (Why)

目标设定与监控模式通过在代理系统中嵌入目的感和自我评估机制，提供了一个标准化的解决方案。它涉及为代理明确定义清晰、可衡量的目标。同时，它建立了一个监控机制，持续追踪代理的进度及其环境状态与这些目标的对比。这创建了一个至关重要的反馈回路，使代理能够评估其表现、纠正其进程，并在偏离成功路径时调整其计划。通过实施这种模式，开发者可以将简单的响应式代理转变为主动的、目标导向的系统，能够自主且可靠地运行。

---

### 经验法则 (Rule of thumb)

当一个 AI 代理必须**自主执行多步骤任务**、**适应动态条件**并**可靠地达成特定的、高层次目标**而无需持续的人工干预时，请使用此模式。

---

## 视觉摘要

![图片](/images/translations/agent-design-patterns/p2-11-goal-setting-and-monitoring-02.png)

图 2：目标设计模式

## 关键要点（Key takeaways）
关键要点包括：

*   目标设定与监控为代理赋予了目的和追踪进度的机制。
*   目标应是具体的（Specific）、可衡量的（Measurable）、可实现的（Achievable）、相关的（Relevant）和有时限的（Time-bound）（SMART）。
*   清晰定义指标和成功标准对于有效监控至关重要。
*   监控涉及观察代理的行动、环境状态和工具输出。
*   来自监控的反馈回路允许代理适应、修改计划或升级问题。
*   在 Google 的 ADK 中，目标通常通过代理指令传达，并通过状态管理和工具交互来完成监控。

## 结论
本章重点讨论了目标设定与监控这一关键范式。我强调了这一概念如何将 AI 代理从单纯的响应式系统转变为主动的、目标驱动的实体。文本强调了定义清晰、可衡量的目标和建立严格的监控程序以追踪进度的重要性。实际应用展示了这一范式如何在包括客户服务和机器人技术在内的各个领域支持可靠的自主操作。一个概念性的代码示例阐述了在结构化框架内实现这些原则，利用代理指令和状态管理来指导和评估代理对其指定目标的实现情况。最终，赋予代理制定和监督目标的能力，是构建真正智能且负责任的 AI 系统的基础步骤。

## 参考资料
[SMART Goals Framework. https://en.wikipedia.org/wiki/SMART_criteria](https://en.wikipedia.org/wiki/SMART_criteria)
