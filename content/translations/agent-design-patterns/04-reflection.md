---
title: "第四章：反思（Reflection）"
date: 2025-10-12
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "通过自我评估和迭代优化机制提升智能体输出质量和准确性"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 4
---

[← 上一章：并行化](../03-parallelization/) | [返回目录](../) | [下一章：工具使用 →](../05-tool_use/)

---

# 第四章：反思（Reflection）

## 反思模式概述

在前几章中，我们探讨了基本的智能体模式：用于顺序执行的**链式（Chaining）**、用于动态路径选择的**路由（Routing）**，以及用于并发任务执行的**并行化（Parallelization）**。这些模式使智能体能够更高效、更灵活地执行复杂任务。然而，即使工作流程再复杂，智能体的初始输出或计划也可能并非最优、准确或完整。这时，**反思（Reflection）**模式就发挥了作用。

反思模式涉及智能体**评估自身的工作、输出或内部状态**，并利用该评估来**改进其性能或优化其响应**。它是一种自我校正或自我完善的形式，允许智能体根据反馈、内部批判或与期望标准的比较，**迭代地**改进其输出或调整其方法。反思有时可以通过一个独立的智能体来协助完成，该智能体的特定职责是分析初始智能体的输出。

与将输出直接传递到下一步的简单链式结构或选择路径的路由不同，反思引入了一个**反馈回路**。智能体不仅产生输出，还会**检查**该输出（或生成它的过程），**识别**潜在问题或改进领域，并利用这些见解生成一个**更好的版本或修改其未来的行动**。

该过程通常包括：

1. **执行（Execution）：** 智能体执行任务或生成初始输出。
2. **评估/批判（Evaluation/Critique）：** 智能体（通常是另一次 LLM 调用或一组规则）分析上一步的结果。此评估可能检查事实准确性、连贯性、风格、完整性、对指令的遵守或其他相关标准。
3. **反思/优化（Reflection/Refinement）：** 根据批判，智能体确定如何改进。这可能涉及生成优化后的输出、调整后续步骤的参数，甚至修改整体计划。
4. **迭代（Iteration）（可选但常见）：** 然后可以执行优化后的输出或调整后的方法，并重复反思过程，直到达到满意的结果或满足停止条件。

反思模式的一个关键且高效的实现方式，是将该过程分离为两个不同的逻辑角色：**生产者（Producer）**和**批判者（Critic）**。这通常被称为“生成者-批判者”或“生产者-审阅者”模型。虽然单个智能体可以进行自我反思，但使用两个专门的智能体（或使用不同系统提示的两次独立 LLM 调用）通常能产生更稳健、更公正的结果。

1. **生产者智能体（The Producer Agent）：** 该智能体的主要职责是执行任务的初始阶段。它完全专注于生成内容，无论是编写代码、起草博客文章还是创建计划。它接受初始提示并产出第一个版本的输出。
2. **批判者智能体（The Critic Agent）：** 该智能体的唯一目的是评估生产者生成的输出。它被赋予一组不同的指令，通常是一个不同的角色（例如，“你是一名高级软件工程师”、“你是一名一丝不苟的事实核查员”）。批判者的指令引导它根据特定标准，例如事实准确性、代码质量、文体要求或完整性，来分析生产者的工作。它的设计目的是**找出缺陷、提出改进建议并提供结构化的反馈**。

这种关注点的分离非常强大，因为它**防止了智能体审查自身工作时产生的“认知偏见”**。批判者智能体以全新的视角处理输出，完全致力于发现错误和可改进之处。批判者的反馈随后被传递回生产者智能体，生产者将其作为指南来生成一个新的、优化后的版本。提供的 LangChain 和 ADK 代码示例都实现了这种双智能体模型：LangChain 示例使用特定的 `"reflector_prompt"` 来创建一个批判者角色，而 ADK 示例则明确定义了一个生产者和一个审阅者智能体。

实现反思通常需要构建智能体的工作流程，以包含这些反馈回路。这可以通过代码中的迭代循环来实现，或使用支持状态管理和基于评估结果进行条件转换的框架。虽然一个评估和优化步骤可以实现在 LangChain/LangGraph、ADK 或 Crew.AI 的任一链中，但**真正的迭代反思通常涉及更复杂的编排**。

反思模式对于构建能够产出高质量输出、处理细微任务并展现一定程度自我意识和适应性的智能体至关重要。它推动智能体超越简单地执行指令，走向一种更复杂的解决问题和内容生成形式。

值得注意的是，反思与**目标设定和监控**（参见第 11 章）的交集。目标为智能体的自我评估提供了最终的基准，而监控则跟踪其进度。在许多实际案例中，反思随后可能充当**校正引擎**，利用受监控的反馈来分析偏差并调整其策略。这种协同作用将智能体从被动的执行者转变为一个有目的地、适应性地努力实现其目标的系统。

此外，当 LLM **保留对话记忆**（参见第 8 章）时，反思模式的有效性会显著增强。这种对话历史为评估阶段提供了**关键的上下文**，允许智能体不仅孤立地评估其输出，还要对照先前的互动、用户反馈和不断演变的目标来评估。它使智能体能够从过去的批判中学习并避免重复错误。没有记忆，每一次反思都是一个独立的事件；有了记忆，反思就变成了一个**累积过程**，每一次循环都建立在上次的基础之上，从而实现更智能、更具上下文意识的优化。

## 实际应用和用例

反思模式在输出质量、准确性或遵守复杂约束至关重要的场景中非常有价值：

1. **创意写作和内容生成：**
    * 优化生成的文本、故事、诗歌或营销文案。
    * **用例：** 智能体撰写一篇博客文章。
    * **反思：** 生成草稿，批判其流畅性、语气和清晰度，然后根据批判进行重写。重复此过程直到文章符合质量标准。
    * **益处：** 产出更精致、更有效的内容。

2. **代码生成和调试：**
    * 编写代码、识别错误并修复它们。
    * **用例：** 智能体编写一个 Python 函数。
    * **反思：** 编写初始代码，运行测试或静态分析，识别错误或低效之处，然后根据发现修改代码。
    * **益处：** 生成更健壮和功能完善的代码。

3. **复杂问题解决：**
    * 在多步骤推理任务中评估中间步骤或提议的解决方案。
    * **用例：** 智能体解决一个逻辑谜题。
    * **反思：** 提出一个步骤，评估它是否更接近解决方案或引入矛盾，如有必要则回溯或选择不同的步骤。
    * **益处：** 提高智能体驾驭复杂问题空间的能力。

4. **摘要和信息综合：**
    * 优化摘要的准确性、完整性和简洁性。
    * **用例：** 智能体总结一篇长文档。
    * **反思：** 生成初始摘要，将其与原始文档中的关键点进行比较，优化摘要以包含缺失信息或提高准确性。
    * **益处：** 创建更准确、更全面的摘要。

5. **规划和战略：**
    * 评估拟议的计划并识别潜在的缺陷或改进。
    * **用例：** 智能体规划实现一系列行动以达成目标。
    * **反思：** 生成一个计划，模拟其执行或根据约束评估其可行性，根据评估修改计划。
    * **益处：** 制定更有效和更现实的计划。

6. **对话式智能体：**
    * 审阅对话中的先前回合，以保持上下文、纠正误解或提高响应质量。
    * **用例：** 客户支持聊天机器人。
    * **反思：** 在用户响应后，审阅对话历史和最后生成的消息，以确保连贯性并准确处理用户的最新输入。
    * **益处：** 带来更自然、更有效的对话。

反思为智能体系统添加了一层**元认知**，使其能够从自身的输出和过程中学习，从而带来更智能、更可靠和更高质量的结果。

## 动手实践代码示例（LangChain）

要实现一个完整的、迭代的反思过程，需要具备状态管理和循环执行的机制。虽然这些在 LangGraph 等基于图的框架中或通过自定义过程代码可以原生处理，但**单个反思循环**的基本原理可以使用 LCEL（LangChain Expression Language）的组合语法得到有效演示。

此示例使用 Langchain 库和 OpenAI 的 GPT-4o 模型实现一个反思循环，以**迭代地**生成和优化一个计算阶乘的 Python 函数。该过程始于一个任务提示，生成初始代码，然后根据模拟高级软件工程师角色的批判，**反复**对代码进行反思和优化，直到批判阶段确定代码完美或达到最大迭代次数。最后，它打印出优化后的最终代码。

首先，确保你安装了必要的库：
```bash
pip install langchain langchain-community langchain-openai
```

你还需要使用你选择的语言模型（例如，OpenAI、Google Gemini、Anthropic）的 API 密钥来设置你的环境。
```python
import os
from dotenv import load_dotenv
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.messages import SystemMessage, HumanMessage

# --- Configuration ---
# Load environment variables from .env file (for OPENAI_API_KEY)
load_dotenv()

# Check if the API key is set
if not os.getenv("OPENAI_API_KEY"):
   raise ValueError("OPENAI_API_KEY not found in .env file. Please add it.")

# Initialize the Chat LLM. We use gpt-4o for better reasoning.
# A lower temperature is used for more deterministic outputs.
llm = ChatOpenAI(model="gpt-4o", temperature=0.1)

def run_reflection_loop():
   """
   Demonstrates a multi-step AI reflection loop to progressively improve a Python function.
   """
   # --- The Core Task ---
   task_prompt = """
   Your task is to create a Python function named `calculate_factorial`.
   This function should do the following:
   1.  Accept a single integer `n` as input.
   2.  Calculate its factorial (n!).
   3.  Include a clear docstring explaining what the function does.
   4.  Handle edge cases: The factorial of 0 is 1.
   5.  Handle invalid input: Raise a ValueError if the input is a negative number.
   """
   # --- The Reflection Loop ---
   max_iterations = 3
   current_code = ""
   # We will build a conversation history to provide context in each step.
   message_history = [HumanMessage(content=task_prompt)]


   for i in range(max_iterations):
       print("\n" + "="*25 + f" REFLECTION LOOP: ITERATION {i + 1} " + "="*25)

       # --- 1. GENERATE / REFINE STAGE ---
       # In the first iteration, it generates. In subsequent iterations, it refines.
       if i == 0:
           print("\n>>> STAGE 1: GENERATING initial code...")
           # The first message is just the task prompt.
           response = llm.invoke(message_history)
           current_code = response.content
       else:
           print("\n>>> STAGE 1: REFINING code based on previous critique...")
           # The message history now contains the task,
           # the last code, and the last critique.
           # We instruct the model to apply the critiques.
           message_history.append(HumanMessage(content="Please refine the code using the critiques provided."))
           response = llm.invoke(message_history)
           current_code = response.content

       print("\n--- Generated Code (v" + str(i + 1) + ") ---\n" + current_code)
       message_history.append(response) # Add the generated code to history

       # --- 2. REFLECT STAGE ---
       print("\n>>> STAGE 2: REFLECTING on the generated code...")

       # Create a specific prompt for the reflector agent.
       # This asks the model to act as a senior code reviewer.
       reflector_prompt = [
           SystemMessage(content="""
               You are a senior software engineer and an expert
               in Python.
               Your role is to perform a meticulous code review.
               Critically evaluate the provided Python code based
               on the original task requirements.
               Look for bugs, style issues, missing edge cases,
               and areas for improvement.
               If the code is perfect and meets all requirements,
               respond with the single phrase 'CODE_IS_PERFECT'.
               Otherwise, provide a bulleted list of your critiques.
           """),
           HumanMessage(content=f"Original Task:\n{task_prompt}\n\nCode to Review:\n{current_code}")
       ]

       critique_response = llm.invoke(reflector_prompt)
       critique = critique_response.content

       # --- 3. STOPPING CONDITION ---
       if "CODE_IS_PERFECT" in critique:
           print("\n--- Critique ---\nNo further critiques found. The code is satisfactory.")
           break

       print("\n--- Critique ---\n" + critique)
       # Add the critique to the history for the next refinement loop.
       message_history.append(HumanMessage(content=f"Critique of the previous code:\n{critique}"))

   print("\n" + "="*30 + " FINAL RESULT " + "="*30)
   print("\nFinal refined code after the reflection process:\n")
   print(current_code)

if __name__ == "__main__":
   run_reflection_loop()
```

这段代码首先设置环境，加载 API 密钥，并初始化一个像 GPT-4o 这样具有低温度的强大语言模型以实现集中式输出。核心任务由一个提示定义，要求创建一个计算阶乘的 Python 函数，其中包括对文档字符串、边界情况（0 的阶乘）和负数输入的错误处理的具体要求。`run_reflection_loop` 函数编排了迭代优化过程。在循环中，第一次迭代时，语言模型根据任务提示生成初始代码。在后续迭代中，它根据上一步的批判来优化代码。一个独立的“反思者”角色，也由语言模型扮演，但具有不同的系统提示，充当**高级软件工程师**，根据原始任务要求批判生成的代码。如果发现问题，该批判以带项目符号的列表形式提供，如果未发现问题，则以短语 `'CODE_IS_PERFECT'` 响应。循环持续进行，直到批判表明代码完美或达到最大迭代次数。对话历史在每一步中都会被维护并传递给语言模型，为生成/优化和反思阶段提供上下文。最后，脚本打印出循环结束后生成的最后一个代码版本。

## 动手实践代码示例（ADK）

现在我们来看一个使用 Google ADK 实现的概念代码示例。具体来说，代码通过采用**生成者-批判者**结构来展示这一点，其中一个组件（生成者）产生初始结果或计划，而另一个组件（批判者）提供批判性反馈或批判，引导生成者产生更优化或更准确的最终输出。

```python
from google.adk.agents import SequentialAgent, LlmAgent

# The first agent generates the initial draft.
generator = LlmAgent(
   name="DraftWriter",
   description="Generates initial draft content on a given subject.",
   instruction="Write a short, informative paragraph about the user's subject.",
   output_key="draft_text" # The output is saved to this state key.
)

# The second agent critiques the draft from the first agent.
reviewer = LlmAgent(
   name="FactChecker",
   description="Reviews a given text for factual accuracy and provides a structured critique.",
   instruction="""
   You are a meticulous fact-checker.
   1. Read the text provided in the state key 'draft_text'.
   2. Carefully verify the factual accuracy of all claims.
   3. Your final output must be a dictionary containing two keys:
      - "status": A string, either "ACCURATE" or "INACCURATE".
      - "reasoning": A string providing a clear explanation for your status, citing specific issues if any are found.
   """,
   output_key="review_output" # The structured dictionary is saved here.
)

# The SequentialAgent ensures the generator runs before the reviewer.
review_pipeline = SequentialAgent(
   name="WriteAndReview_Pipeline",
   sub_agents=[generator, reviewer]
)

# Execution Flow:
# 1. generator runs -> saves its paragraph to state['draft_text'].
# 2. reviewer runs -> reads state['draft_text'] and saves its dictionary output to state['review_output'].
```

此代码演示了在 Google ADK 中使用**顺序智能体管线**进行文本生成和审阅。它定义了两个 `LlmAgent` 实例：`generator`（生成者）和 `reviewer`（审阅者）。`generator` 智能体旨在创建关于给定主题的初始草稿段落。它被指示编写一篇简短而信息丰富的文章，并将其输出保存到状态键 `draft_text` 中。`reviewer` 智能体充当对 `generator` 产生的文本进行**事实核查**的角色。它被指示从 `draft_text` 中读取文本并验证其事实准确性。`reviewer` 的输出是一个包含两个键的**结构化字典**：`status` 和 `reasoning`。`status` 指示文本是 `"ACCURATE"`（准确）还是 `"INACCURATE"`（不准确），而 `reasoning` 则提供对其状态的解释，并指出发现的任何具体问题。此字典被保存到状态键 `review_output` 中。创建了一个名为 `review_pipeline` 的 `SequentialAgent` 来管理这两个智能体的执行顺序。它确保 `generator` 先运行，然后是 `reviewer`。整体执行流程是：`generator` 产生文本，然后保存到状态中。随后，`reviewer` 从状态中读取此文本，执行其事实核查，并将其发现（状态和推理）保存回状态中。该管线允许使用独立的智能体实现结构化的内容创建和审阅过程。

*注：对于感兴趣的读者，也可使用 ADK 的 `LoopAgent` 实现另一种方案。*

在总结之前，重要的是要考虑虽然反思模式显著提高了输出质量，但它也带来了重要的**权衡**。迭代过程虽然强大，但可能导致**更高的成本和延迟**，因为每一次优化循环都可能需要新的 LLM 调用，使其不适用于时间敏感的应用。此外，该模式是**内存密集型**的；随着每次迭代，对话历史会扩展，包括初始输出、批判和随后的优化。

## 概要速览（At a Glance）

### 是什么 (What)

智能体的初始输出通常是次优的，存在不准确、不完整或未能满足复杂要求的问题。基本的智能体工作流程缺乏内置的机制让智能体识别和修复自身的错误。这通过让智能体评估自身工作，或更可靠地通过引入一个独立的逻辑智能体充当批判者来解决，从而防止初始响应不顾质量地成为最终结果。

---

### 为什么 (Why)

反思模式通过引入自我校正和优化机制提供了一个解决方案。它建立了一个**反馈回路**，其中"生产者"智能体生成输出，然后"批判者"智能体（或生产者本身）根据预定义的标准对其进行评估。然后利用此批判来生成改进版本。这种**生成、评估和优化的迭代过程**逐步提高了最终结果的质量，从而带来更准确、连贯和可靠的产出。

---

### 经验法则 (Rule of thumb)

当最终输出的**质量、准确性和细节**比速度和成本更重要时，使用反思模式。它对于生成精美的长篇内容、编写和调试代码以及创建详细计划等任务特别有效。当任务需要高度客观性或通用生产者智能体可能遗漏的专业评估时，应采用一个**独立的批判者智能体**。

---

## 视觉摘要

![图片](/images/translations/agent-design-patterns/p1-04-reflection-01.png)

*图 1：反思设计模式，自我反思*

![图片](/images/translations/agent-design-patterns/p1-04-reflection-02.png)

*图 2：反思设计模式，生产者和批判智能体*

## 关键要点

*   反思模式的主要优势在于它能够**迭代地自我校正和优化**输出，从而带来显著更高的质量、准确性和对复杂指令的遵守。
*   它涉及**执行、评估/批判和优化**的反馈回路。反思对于要求高质量、准确或细微差别的输出的任务至关重要。
*   一个强大的实现方式是**生产者-批判者模型**，其中一个独立的智能体（或带有特定提示的角色）评估初始输出。这种关注点的分离增强了**客观性**，并允许提供更专业化、结构化的反馈。
*   然而，这些益处是以**增加延迟和计算开销**为代价的，同时也带来了更高的**超出模型上下文窗口或被 API 服务限制**的风险。
*   虽然完全的迭代反思通常需要有状态的工作流程（如 LangGraph），但在 LangChain 中可以使用 LCEL 实现单个反思步骤，以将输出传递给批判和随后的优化。
*   Google ADK 可以通过**顺序工作流程**促进反思，其中一个智能体的输出被另一个智能体批判，从而允许进行后续的优化步骤。
*   该模式使智能体能够执行**自我校正**并随着时间推移提高其性能。

## 结论

反思模式提供了一种在智能体工作流程中进行自我校正的关键机制，实现了超越单次执行的**迭代改进**。这是通过创建一个**循环**来实现的：系统生成一个输出，根据特定标准对其进行评估，然后利用该评估来产生一个优化后的结果。此评估可以由智能体本身执行（自我反思），或者通常更有效地由一个**独立的批判者智能体**执行，后者是该模式中的一个关键架构选择。

虽然一个完全自主、多步骤的反思过程需要一个强大的状态管理架构，但其核心原则可以在**单个生成-批判-优化循环**中得到有效演示。作为一种控制结构，反思可以与其他基础模式集成，以构建更健壮、功能更复杂的智能体系统。

## 参考文献

以下是有关反思模式和相关概念的进一步阅读资源：

*   Training Language Models to Self-Correct via Reinforcement Learning, https://arxiv.org/abs/2409.12917
*   LangChain Expression Language (LCEL) Documentation: https://python.langchain.com/docs/introduction/
*   LangGraph Documentation: https://www.langchain.com/langgraph
*   Google Agent Developer Kit (ADK) Documentation (Multi-Agent Systems): https://google.github.io/adk-docs/agents/multi-agents/
