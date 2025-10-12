---
title: "第六章：规划（Planning）"
date: 2025-10-11
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "通过将复杂目标分解为可执行步骤序列，使智能体具备战略性思考和自主执行能力"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 6
---

[← 上一章：工具使用](../05-tool_use/) | [返回目录](../) | [下一章：多智能体协作 →](../07-multi-agent-collaboration/)

---

# 第六章：规划（Planning）

智能行为通常不只是对即时输入的反应。它需要**预见性**，将复杂的任务分解成更小、更易管理的步骤，并制定策略来实现期望的结果。这就是“规划”（Planning）模式发挥作用的地方。规划模式的核心在于，它是一个代理（agent）或一个代理系统，能够制定一系列动作，将系统从**初始状态**推向**目标状态**。

## 规划模式概述

在人工智能的语境下，将规划代理视为一个专门处理复杂目标的专家会很有帮助。当你要求它“组织一次团队外勤活动”时，你定义了**“什么”（目标和约束）**，但没有定义**“如何”（方法）**。该代理的核心任务是自主地规划一条通向该目标的路径。它必须首先理解初始状态（例如：预算、参与人数、期望日期）和目标状态（成功预订的外勤活动），然后发现连接它们的最优动作序列。**计划不是预先知道的，它是根据请求创建的。**

这一过程的一个标志是**适应性**。一个初始计划仅仅是一个起点，而非僵硬的脚本。代理的真正力量在于它能够**纳入新信息**并**绕过障碍**来驾驭项目。例如，如果首选场地不可用，或选定的餐饮服务商已被订满，一个有能力的代理不会简单地失败。它会**适应**。它会登记新的约束条件，重新评估其选项，并制定新的计划，例如建议替代场地或日期。

然而，至关重要的是要认识到**灵活性与可预测性**之间的权衡。动态规划是一种特定的工具，并非万能的解决方案。当一个问题的解决方案已经**被充分理解和可重复**时，将代理限制在一个预先确定的、固定的工作流程中会更有效。这种方法限制了代理的自主性，以减少不确定性和不可预测行为的风险，从而保证可靠且一致的结果。因此，决定使用规划代理还是一个简单的任务执行代理，取决于一个核心问题：**“如何做”是需要被发现的，还是已经已知的？**

## 实际应用与用例

规划模式是自主系统中的核心计算过程，它使代理能够合成一系列动作来实现指定的、特别是在动态或复杂环境中的目标。这一过程将一个高层目标转化为一个由离散的、可执行的步骤构成的结构化计划。

在**流程任务自动化**等领域，规划被用于编排复杂的工作流程。例如，像新员工入职这样的业务流程可以被分解为一系列有方向的子任务，例如创建系统账户、分配培训模块以及与不同部门协调。代理生成一个计划，以逻辑顺序执行这些步骤，调用必要的工具或与各种系统交互来管理依赖关系。

在**机器人技术和自主导航**中，规划是状态空间遍历的基础。一个系统，无论是实体机器人还是虚拟实体，都必须生成一条路径或动作序列，以从初始状态过渡到目标状态。这涉及到在遵守环境约束（如避开障碍物或遵守交通规则）的同时，优化如时间或能耗等指标。

此模式对于**结构化信息合成**也至关重要。当任务是生成一份复杂输出（如研究报告）时，代理可以制定一个计划，其中包括信息收集、数据总结、内容构建和迭代优化等不同阶段。同样，在涉及多步骤问题解决的客户支持场景中，代理可以创建并遵循一个系统的计划来进行诊断、解决方案实施和升级。

本质上，规划模式允许代理超越简单、反应性的动作，转向**目标导向的行为**。它提供了解决需要连贯的、相互依赖的操作序列的问题所需的逻辑框架。

## 实践代码 (Crew AI)

以下部分将演示使用 Crew AI 框架实现规划器模式。此模式涉及一个代理，它首先制定一个多步骤计划来解决一个复杂的查询，然后按顺序执行该计划。

```python
import os
from dotenv import load_dotenv
from crewai import Agent, Task, Crew, Process
from langchain_openai import ChatOpenAI

# Load environment variables from .env file for security
load_dotenv()

# 1. Explicitly define the language model for clarity
llm = ChatOpenAI(model="gpt-4-turbo")

# 2. Define a clear and focused agent
planner_writer_agent = Agent(
   role='Article Planner and Writer',
   goal='Plan and then write a concise, engaging summary on a specified topic.',
   backstory=(
       'You are an expert technical writer and content strategist. '
       'Your strength lies in creating a clear, actionable plan before writing, '
       'ensuring the final summary is both informative and easy to digest.'
   ),
   verbose=True,
   allow_delegation=False,
   llm=llm # Assign the specific LLM to the agent
)

# 3. Define a task with a more structured and specific expected output
topic = "The importance of Reinforcement Learning in AI"
high_level_task = Task(
   description=(
       f"1. Create a bullet-point plan for a summary on the topic: '{topic}'.\n"
       f"2. Write the summary based on your plan, keeping it around 200 words."
   ),
   expected_output=(
       "A final report containing two distinct sections:\n\n"
       "### Plan\n"
       "- A bulleted list outlining the main points of the summary.\n\n"
       "### Summary\n"
       "- A concise and well-structured summary of the topic."
   ),
   agent=planner_writer_agent,
)

# Create the crew with a clear process
crew = Crew(
   agents=[planner_writer_agent],
   tasks=[high_level_task],
   process=Process.sequential,
)

# Execute the task
print("## Running the planning and writing task ##")
result = crew.kickoff()

print("\n\n---\n## Task Result ##\n---")
print(result)
```

这段代码利用 CrewAI 库创建了一个 AI 代理，用于规划并撰写关于给定主题的摘要。它首先导入了必要的库，包括 Crew.ai 和 langchain_openai，并从 `.env` 文件加载环境变量。代码显式定义了一个 `ChatOpenAI` 语言模型供代理使用。然后，创建了一个名为 `planner_writer_agent` 的代理，赋予了它一个特定的角色和目标：先规划后撰写一份简洁、引人入胜的摘要。代理的背景故事强调了其在规划和技术写作方面的专长。定义了一个 `Task`，其描述清晰，要求首先创建一个计划，然后根据主题“人工智能中强化学习的重要性”撰写摘要，并指定了期望输出的格式。最后，组装了一个 `Crew`，包含该代理和任务，并设置为顺序处理。调用 `crew.kickoff()` 方法执行定义的任务，并打印结果。

## Google DeepResearch

Google Gemini DeepResearch（参见图 1）是一个基于代理的系统，专为自主信息检索和合成而设计。它通过一个**多步骤的代理流程**工作，该流程动态且迭代地查询 Google 搜索，系统地探索复杂主题。该系统旨在处理大量基于网络的来源，评估收集到的数据的相关性和知识缺口，并执行后续搜索来解决这些缺口。最终输出将经过验证的信息整合为一份结构化的多页摘要，并附带原始来源的引用。

更进一步来说，该系统的运作不是一次简单的查询-响应事件，而是一个**受管理的、长时间运行的过程**。它首先将用户的提示分解成一个多点研究计划（参见图 1），然后将该计划呈现给用户进行审查和修改。这允许在执行前**协作性地确定研究方向**。一旦计划被批准，代理流程就开始其迭代的搜索和分析循环。这不仅仅是执行一系列预定义的搜索；代理会**根据其收集到的信息动态地制定和完善查询**，主动识别知识缺口、佐证数据点并解决矛盾。

![图片](/images/translations/agent-design-patterns/p1-06-planning-01.png)
**图 1：Google Deep Research 代理正在生成使用 Google Search 作为工具的执行计划。**

一个关键的架构组成部分是系统**管理此过程的异步能力**。这种设计确保了调查（可能涉及分析数百个来源）对单点故障具有弹性，并允许用户脱离并在完成时收到通知。该系统还可以集成用户提供的文档，将来自私人来源的信息与其基于网络的研究所结合。最终输出不仅仅是发现结果的串联列表，而是一份**结构化的多页报告**。在合成阶段，模型对收集到的信息进行批判性评估，识别主要主题，并以连贯的叙事和逻辑部分组织内容。该报告被设计成**交互式的**，通常包含音频概述、图表以及链接到原始引用来源等功能，使用户能够进行验证和进一步探索。除了合成的结果之外，模型还**明确返回**它搜索和咨询过的完整来源列表（参见图 2）。这些以引用的形式呈现，提供**完整的透明度**和对原始信息**的直接访问**。整个过程将一个简单的查询转化为一个全面的、合成的知识体系。

![图片](/images/translations/agent-design-patterns/p1-06-planning-02.png)
**图 2：Deep Research 计划执行的一个例子，结果是 Google Search 被用作搜索各种网络来源的工具。**

通过减轻手动数据获取和合成所需的大量时间和资源投入，Gemini DeepResearch 提供了一种更**结构化和详尽**的信息发现方法。该系统的价值在跨各种领域的复杂、多方面的研究任务中尤为明显。

例如，在**竞争分析**中，可以指导代理系统地收集和整理市场趋势、竞争对手的产品规格、来自不同在线来源的公众情绪以及营销策略的数据。这种自动化流程取代了手动跟踪多个竞争对手的繁琐任务，使分析师能够专注于更高阶的战略解释，而不是数据收集（参见图 3）。

![图片](/images/translations/agent-design-patterns/p1-06-planning-03.png)
**图 3：Google Deep Research 代理生成的最终输出，替我们分析了使用 Google Search 作为工具获取的来源。**

同样，在**学术探索**中，该系统可作为进行广泛文献回顾的有力工具。它可以识别和总结基础性论文，追踪概念在大量出版物中的发展，并绘制出特定领域内新兴的研究前沿，从而加速学术探究中最耗时的初始阶段。

这种方法效率的提高源于**迭代搜索和过滤循环的自动化**，这是手动研究中的核心瓶颈。系统能够处理比人类研究人员在相同时限内通常可行的**更大容量和更多种类的**信息来源，从而实现**全面性**。这种更广泛的分析范围有助于减少潜在的**选择偏差**，并增加了发现不那么明显但可能至关重要的信息的可能性，从而形成对主题更**稳健和有依据**的理解。

## OpenAI Deep Research API

OpenAI Deep Research API 是一个专门的工具，旨在自动化复杂的**研究任务**。它利用一个**高级的、代理式的模型**，该模型可以独立地推理、规划，并从真实世界的来源合成信息。与简单的问答模型不同，它接受一个高层查询，并自主地将其分解为子问题，使用其内置工具执行网络搜索，并交付一个**结构化的、富含引用的最终报告**。该 API 提供了对整个过程的直接编程访问，在撰写本文时使用了像 `o3-deep-research-2025-06-26` 这样的模型进行高质量的合成，以及更快的 `o4-mini-deep-research-2025-06-26` 用于对延迟敏感的应用。

Deep Research API 非常有用，因为它将原本需要数小时手动研究的工作自动化，交付**专业级、数据驱动**的报告，适用于为商业战略、投资决策或政策建议提供信息。其主要优点包括：

*   **结构化、带引用的输出：** 它生成组织良好、带有链接到源元数据的**内联引用**的报告，确保主张可验证且有数据支持。
*   **透明度：** 与 ChatGPT 中抽象的过程不同，该 API 暴露了所有**中间步骤**，包括代理的推理、它执行的特定网络搜索查询，以及它运行的任何代码。这允许进行详细的调试、分析，并更深入地理解最终答案是如何构建的。
*   **可扩展性：** 它支持**模型上下文协议（MCP）**，使开发人员能够将代理连接到**私有知识库和内部数据源**，将公共网络研究与专有信息相结合。

要使用该 API，您需要向 `client.responses.create` 端点发送请求，指定一个模型、一个输入提示，以及代理可以使用的工具。输入通常包括一个定义代理角色和期望输出格式的 `system_message`，以及 `user_query`。您还必须包含 `web_search_preview` 工具，并且可以选择添加其他工具，如 `code_interpreter` 或自定义 MCP 工具（参见第 10 章）用于内部数据。

```python
from openai import OpenAI

# Initialize the client with your API key
client = OpenAI(api_key="YOUR_OPENAI_API_KEY")

# Define the agent's role and the user's research question
system_message = """You are a professional researcher preparing a structured, data-driven report.
Focus on data-rich insights, use reliable sources, and include inline citations."""
user_query = "Research the economic impact of semaglutide on global healthcare systems."

# Create the Deep Research API call
response = client.responses.create(
 model="o3-deep-research-2025-06-26",
 input=[
   {
     "role": "developer",
     "content": [{"type": "input_text", "text": system_message}]
   },
   {
     "role": "user",
     "content": [{"type": "input_text", "text": user_query}]
   }
 ],
 reasoning={"summary": "auto"},
 tools=[{"type": "web_search_preview"}]
)

# Access and print the final report from the response
final_report = response.output[-1].content[0].text
print(final_report)

# --- ACCESS INLINE CITATIONS AND METADATA ---
print("--- CITATIONS ---")
annotations = response.output[-1].content[0].annotations

if not annotations:
   print("No annotations found in the report.")
else:
   for i, citation in enumerate(annotations):
       # The text span the citation refers to
       cited_text = final_report[citation.start_index:citation.end_index]

       print(f"Citation {i+1}:")
       print(f"  Cited Text: {cited_text}")
       print(f"  Title: {citation.title}")
       print(f"  URL: {citation.url}")
       print(f"  Location: chars {citation.start_index}–{citation.end_index}")
print("\n" + "="*50 + "\n")

# --- INSPECT INTERMEDIATE STEPS ---
print("--- INTERMEDIATE STEPS ---")

# 1. Reasoning Steps: Internal plans and summaries generated by the model.
try:
   reasoning_step = next(item for item in response.output if item.type == "reasoning")
   print("\n[Found a Reasoning Step]")
   for summary_part in reasoning_step.summary:
       print(f"  - {summary_part.text}")
except StopIteration:
   print("\nNo reasoning steps found.")

# 2. Web Search Calls: The exact search queries the agent executed.
try:
   search_step = next(item for item in response.output if item.type == "web_search_call")
   print("\n[Found a Web Search Call]")
   print(f"  Query Executed: '{search_step.action['query']}'")
   print(f"  Status: {search_step.status}")
except StopIteration:
   print("\nNo web search steps found.")

# 3. Code Execution: Any code run by the agent using the code interpreter.
try:
   code_step = next(item for item in response.output if item.type == "code_interpreter_call")
   print("\n[Found a Code Execution Step]")
   print("  Code Input:")
   print(f"  ```python\n{code_step.input}\n  ```")
   print("  Code Output:")
   print(f"  {code_step.output}")
except StopIteration:
   print("\nNo code execution steps found.")
```

这段代码片段利用 OpenAI API 执行一个“深度研究”任务。它首先使用您的 API 密钥初始化 OpenAI 客户端，这对于身份验证至关重要。然后，它定义了 AI 代理的角色为专业研究员，并设定了用户关于司美格鲁肽对全球医疗系统经济影响的研究问题。代码构建了一个对 `o3-deep-research-2025-06-26` 模型的 API 调用，将定义的系统消息和用户查询作为输入提供。它还请求自动总结推理过程并启用网络搜索功能。发出 API 调用后，它提取并打印最终生成的报告。

随后，它尝试访问和显示报告注解中的**内联引用和元数据**，包括被引用的文本、标题、URL 和在报告中的位置。最后，它检查并打印模型采取的**中间步骤**的详细信息，例如推理步骤、网络搜索调用（包括执行的查询），以及如果使用了代码解释器，则打印任何代码执行步骤。

## 概要速览（At a Glance）

### 是什么 (What)

复杂问题通常无法通过一个单一动作解决，需要**预见性**才能实现期望的结果。如果没有结构化的方法，代理系统难以处理涉及多个步骤和依赖关系的多方面请求。这使得将高层目标分解成一系列可管理、可执行的小任务变得困难。因此，当面对复杂的任务时，系统无法有效地制定策略，导致结果不完整或不正确。

---

### 为什么 (Why)

规划模式提供了一个标准化解决方案，即让代理系统首先创建一个**连贯的计划**来解决目标。它涉及将一个高层目标分解为一系列更小、**可操作的步骤或子目标**。这使得系统能够管理复杂的工作流程，编排各种工具，并以逻辑顺序处理依赖关系。大型语言模型（LLMs）特别适合此任务，因为它们可以根据其庞大的训练数据生成**合理且有效的计划**。这种结构化方法将一个简单的反应型代理转变为一个**战略执行者**，可以主动地朝着复杂目标努力，甚至在必要时调整其计划。

---

### 经验法则 (Rule of thumb)

当用户的请求**过于复杂，无法通过单一动作或工具处理**时，请使用此模式。它非常适合自动化多步流程，例如生成详细研究报告、新员工入职，或执行竞争分析。只要任务需要一系列**相互依赖的操作**才能达到最终的合成结果，就应应用规划模式。

---

## 可视化总结

![图片](/images/translations/agent-design-patterns/p1-06-planning-04.png)
**图 4：规划设计模式**

## 关键要点

*   规划使代理能够将复杂目标分解为可操作的、按顺序的步骤。
*   它对于处理多步骤任务、工作流自动化和导航复杂环境至关重要。
*   LLMs 可以通过基于任务描述生成分步方法来执行规划。
*   **显式提示或设计任务以要求规划步骤，能鼓励代理框架中的这种行为。**
*   Google Deep Research 是一个代理，代表我们分析使用 Google Search 作为工具获取的来源。它进行反思、规划和执行。

## 结论

总而言之，规划模式是一个基础性组件，它将代理系统从简单的**反应式响应者**提升为**战略性的、目标导向的执行者**。现代大型语言模型为这一核心能力提供了支持，能够自主地将高层目标分解成连贯的、可执行的步骤。这种模式可从简单的、顺序性的任务执行（如 CrewAI 代理创建和遵循写作计划的示例），扩展到更复杂和动态的系统。Google DeepResearch 代理便是这种高级应用的典范，它创建迭代的研究计划，并根据持续的信息收集进行调整和演变。最终，规划为复杂问题提供了**连接人类意图与自动化执行的必要桥梁**。通过结构化问题解决方法，这种模式使代理能够管理复杂的工作流程并交付全面、合成的结果。

## 参考文献

- Google DeepResearch (Gemini Feature): gemini.google.com
- OpenAI ,Introducing deep research https://openai.com/index/introducing-deep-research/
- Perplexity, Introducing Perplexity Deep Research, https://www.perplexity.ai/hub/blog/introducing-perplexity-deep-research
