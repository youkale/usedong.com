---
title: "第三章：并行化（Parallelization）"
date: 2025-10-11
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "本文翻译并解读了常见的 Agent 设计模式，包括 ReAct、Chain of Thought、Plan-and-Execute 等，帮助你构建更加稳定和可靠的 AI Agent"
original_author: "Multiple Sources"
---

第三章：并行化（Parallelization）
并行化模式概览

在前面的章节中，我们探讨了用于顺序工作流的提示链（Prompt Chaining），以及用于动态决策和路径转换的路由（Routing）模式。虽然这些模式至关重要，但许多复杂的智能体（agentic）任务涉及多个可以同时执行而非依次执行的子任务。这时，**并行化（Parallelization）**模式就变得至关重要。

并行化涉及并发执行多个组件，例如大型语言模型（LLM）调用、工具使用，甚至是整个子智能体（见图1）。并行执行不是等待一个步骤完成后再开始下一个，而是允许独立的任务同时运行，从而显著减少可分解为独立部分的任务的总体执行时间。

以一个旨在研究某个主题并总结其发现的智能体为例。顺序方法可能是：

1. 搜索来源 A。

2. 总结来源 A。

3. 搜索来源 B。

总结来源 B。

从总结 A 和 B 中合成最终答案。

而并行方法可以是：

1. 同时搜索来源 A 和搜索来源 B。

2. 一旦两次搜索都完成，同时总结来源 A 和总结来源 B。

3. 从总结 A 和 B 中合成最终答案（此步骤通常是顺序的，等待并行步骤完成）。

核心思想是识别工作流程中不依赖于其他部分输出的部分，并让它们并行执行。当处理具有延迟的外部服务（如 API 或数据库）时，这种方法特别有效，因为你可以并发地发出多个请求。

实现并行化通常需要支持异步执行或多线程/多进程的框架。现代智能体框架在设计时就考虑了异步操作，允许你轻松定义可以并行运行的步骤。

![图1. 带有子智能体的并行化示例](/images/translations/parallelization-fig-1.png)


LangChain、LangGraph 和 Google ADK 等框架提供了并行执行的机制。在 LangChain 表达式语言 (LCEL) 中，你可以通过使用 |（用于顺序）等运算符组合可运行对象，并通过构建具有并发执行分支的链或图来实现并行执行。LangGraph 凭借其图结构，允许从单个状态转换定义多个可以执行的节点，从而有效地在工作流中启用并行分支。Google ADK 提供了强大、原生的机制来促进和管理智能体（agent）的并行执行，显著提高了复杂、多智能体系统的效率和可扩展性。ADK 框架中的这种内在能力允许开发者设计和实现多个智能体可以并发而非顺序操作的解决方案。

并行化模式对于提高智能体系统的效率和响应速度至关重要，尤其是在处理涉及多个独立查找、计算或与外部服务交互的任务时。它是优化复杂智能体工作流性能的关键技术。

实际应用与用例

并行化是一种强大的模式，可用于优化各种应用中智能体的性能：

信息收集与研究：
同时从多个来源收集信息是一个典型的用例。

用例： 一个研究某公司的智能体。

并行任务： 同时搜索新闻文章、提取股票数据、查看社交媒体提及，并查询公司数据库。

益处： 比顺序查找更快地收集到全面的视图。

数据处理与分析：
并发应用不同的分析技术或处理不同的数据段。

用例： 一个分析客户反馈的智能体。

并行任务： 在一批反馈条目上同时运行情感分析、提取关键词、对反馈进行分类和识别紧急问题。

益处： 快速提供多方面的分析。

多 API 或工具交互：
调用多个独立的 API 或工具来收集不同类型的信息或执行不同的操作。

用例： 一个旅行规划智能体。

并行任务： 同时检查航班价格、搜索酒店空房情况、查找当地活动和寻找餐厅推荐。

益处： 更快地呈现完整的旅行计划。

多组件内容生成：
并行生成复杂内容的不同部分。

用例： 一个创建营销邮件的智能体。

并行任务： 同时生成主题行、起草邮件正文、寻找相关图片和创建行动号召按钮文本。

益处： 更高效地组装最终邮件。

验证与核实：
并发执行多个独立的检查或验证。

用例： 一个验证用户输入的智能体。

并行任务： 同时检查邮件格式、验证电话号码、对照数据库核实地址，并检查是否有不当言语。

益处： 更快地提供输入有效性的反馈。

多模态处理：
并发处理相同输入的不同模态（文本、图像、音频）。

用例： 一个分析包含文本和图像的社交媒体帖子的智能体。

并行任务： 同时分析文本以获取情感和关键词，并分析图像以获取对象和场景描述。

益处： 更快地整合来自不同模态的洞察。

A/B 测试或多选项生成：
并行生成响应或输出的多个变体以选择最佳方案。

用例： 一个生成不同创意文本选项的智能体。

并行任务： 使用略微不同的提示或模型同时生成三篇不同的文章标题。

益处： 允许快速比较和选择最佳选项。

并行化是智能体设计中的一个基本优化技术，它通过利用并发执行来处理独立任务，使开发者能够构建出性能更高、响应更快的应用程序。

动手实践代码示例（LangChain）

LangChain 框架内的并行执行由 LangChain 表达式语言（LCEL） 促成。主要方法是，将多个可运行（runnable）组件结构化到一个字典或列表结构中。当这个集合作为输入传递给链中的后续组件时，LCEL 运行时会并发执行其中包含的可运行对象。

在 LangGraph 的上下文中，这个原理应用于图的拓扑结构。通过将图架构设计成多个节点，在缺乏直接顺序依赖关系的情况下，可以从一个单一的共同节点启动，从而定义并行工作流。这些并行路径独立执行，然后它们的结果可以在图中的后续汇聚点聚合。

以下实现演示了使用 LangChain 框架构建的并行处理工作流。此工作流设计用于并发执行两个独立操作，以响应单个用户查询。这些并行进程被实例化为不同的链或函数，它们的各自输出随后被聚合为一个统一的结果。

此实现的前提条件包括安装所需的 Python 包，例如 langchain、langchain-community，以及像 langchain-openai 这样的模型提供商库。此外，必须在本地环境中配置一个有效的语言模型 API 密钥以进行身份验证。

```python
import os
import asyncio
from typing import Optional

from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import Runnable, RunnableParallel, RunnablePassthrough

# --- Configuration ---
# Ensure your API key environment variable is set (e.g., OPENAI_API_KEY)
try:
   llm: Optional[ChatOpenAI] = ChatOpenAI(model="gpt-4o-mini", temperature=0.7)

except Exception as e:
   print(f"Error initializing language model: {e}")
   llm = None

# --- Define Independent Chains ---
# These three chains represent distinct tasks that can be executed in parallel.

summarize_chain: Runnable = (
   ChatPromptTemplate.from_messages([
       ("system", "Summarize the following topic concisely:"),
       ("user", "{topic}")
   ])
   | llm
   | StrOutputParser()
)

questions_chain: Runnable = (
   ChatPromptTemplate.from_messages([
       ("system", "Generate three interesting questions about the following topic:"),
       ("user", "{topic}")
   ])
   | llm
   | StrOutputParser()
)

terms_chain: Runnable = (
   ChatPromptTemplate.from_messages([
       ("system", "Identify 5-10 key terms from the following topic, separated by commas:"),
       ("user", "{topic}")
   ])
   | llm
   | StrOutputParser()
)

# --- Build the Parallel + Synthesis Chain ---

# 1. Define the block of tasks to run in parallel. The results of these,
#    along with the original topic, will be fed into the next step.
map_chain = RunnableParallel(
   {
       "summary": summarize_chain,
       "questions": questions_chain,
       "key_terms": terms_chain,
       "topic": RunnablePassthrough(),  # Pass the original topic through
   }
)

# 2. Define the final synthesis prompt which will combine the parallel results.
synthesis_prompt = ChatPromptTemplate.from_messages([
   ("system", """Based on the following information:
    Summary: {summary}
    Related Questions: {questions}
    Key Terms: {key_terms}
    Synthesize a comprehensive answer."""),
   ("user", "Original topic: {topic}")
])

# 3. Construct the full chain by piping the parallel results directly
#    into the synthesis prompt, followed by the LLM and output parser.
full_parallel_chain = map_chain | synthesis_prompt | llm | StrOutputParser()

# --- Run the Chain ---
async def run_parallel_example(topic: str) -> None:
   """
   Asynchronously invokes the parallel processing chain with a specific topic
   and prints the synthesized result.

   Args:
       topic: The input topic to be processed by the LangChain chains.
   """
   if not llm:
       print("LLM not initialized. Cannot run example.")
       return

   print(f"\n--- Running Parallel LangChain Example for Topic: '{topic}' ---")
   try:
       # The input to `ainvoke` is the single 'topic' string,
       # then passed to each runnable in the `map_chain`.
       response = await full_parallel_chain.ainvoke(topic)
       print("\n--- Final Response ---")
       print(response)
   except Exception as e:
       print(f"\nAn error occurred during chain execution: {e}")

if __name__ == "__main__":
   test_topic = "The history of space exploration"
   # In Python 3.7+, asyncio.run is the standard way to run an async function.
   asyncio.run(run_parallel_example(test_topic))

```

所提供的 Python 代码实现了一个 LangChain 应用程序，旨在通过利用并行执行来高效处理给定的主题。请注意，asyncio 提供的是并发（concurrency）而非并行（parallelism）。它通过使用事件循环（event loop）在任务空闲时（例如，等待网络请求）智能地在任务之间切换，从而在单个线程上实现并发效果。这营造了多个任务同时进展的错觉，但代码本身仍由一个受 Python 全局解释器锁（GIL） 限制的线程执行。

代码首先从 langchain_openai 和 langchain_core 导入必要的模块，包括用于语言模型、提示、输出解析和可运行结构的组件。代码尝试初始化一个 ChatOpenAI 实例，具体使用了 "gpt-4o-mini" 模型，并指定了用于控制创造性的温度（temperature）。使用了一个 try-except 块来增强语言模型初始化过程的鲁棒性。

随后定义了三条独立的 LangChain “链”，每条链都设计用于对输入主题执行一个独特的任务。第一条链用于简洁地总结主题，使用了系统消息和包含主题占位符的用户消息。第二条链配置为生成与主题相关的三个有趣问题。第三条链设置用于识别输入主题中的 5 到 10 个关键词，并要求它们以逗号分隔。这些独立链中的每一条都由一个为其特定任务量身定制的 ChatPromptTemplate 组成，后跟已初始化的语言模型和一个 StrOutputParser，用于将输出格式化为字符串。

接着，构建了一个 RunnableParallel 块来捆绑这三条链，允许它们同时执行。这个并行可运行对象还包含一个 RunnablePassthrough，以确保原始输入主题可用于后续步骤。为最终的合成步骤定义了一个单独的 ChatPromptTemplate，它以总结、问题、关键词和原始主题作为输入，以生成一个全面的答案。

通过将 map_chain（并行块）导入合成提示，再接上语言模型和输出解析器，构建了完整的端到端处理链，命名为 full_parallel_chain。提供了一个名为 run_parallel_example 的异步函数，用于演示如何调用这个 full_parallel_chain。该函数将主题作为输入，并使用 invoke 来运行异步链。

最后，标准的 Python if __name__ == "__main__": 块展示了如何使用 asyncio.run 来管理异步执行，并用一个示例主题（本例中为 "The history of space exploration"）来执行 run_parallel_example。

本质上，这段代码建立了一个工作流，其中多个 LLM 调用（用于总结、问题和关键词）针对给定主题同时发生，然后它们的结果由最后一个 LLM 调用组合起来。这展示了使用 LangChain 在智能体工作流中实现并行化模式的核心思想。

动手实践代码示例（Google ADK）

现在，让我们关注一个具体的示例，它在 Google ADK 框架内阐释了这些概念。我们将研究如何应用 ADK 的原语（primitives），例如 ParallelAgent 和 SequentialAgent，来构建一个利用并发执行以提高效率的智能体流。

```python
  from google.adk.agents import LlmAgent, ParallelAgent, SequentialAgent
  from google.adk.tools import google_search
  GEMINI_MODEL="gemini-2.0-flash"

  # --- 1. Define Researcher Sub-Agents (to run in parallel) ---

  # Researcher 1: Renewable Energy
  researcher_agent_1 = LlmAgent(
      name="RenewableEnergyResearcher",
      model=GEMINI_MODEL,
      instruction="""You are an AI Research Assistant specializing in energy.
  Research the latest advancements in 'renewable energy sources'.
  Use the Google Search tool provided.
  Summarize your key findings concisely (1-2 sentences).
  Output *only* the summary.
  """,
      description="Researches renewable energy sources.",
      tools=[google_search],
      # Store result in state for the merger agent
      output_key="renewable_energy_result"
  )

  # Researcher 2: Electric Vehicles
  researcher_agent_2 = LlmAgent(
      name="EVResearcher",
      model=GEMINI_MODEL,
      instruction="""You are an AI Research Assistant specializing in transportation.
  Research the latest developments in 'electric vehicle technology'.
  Use the Google Search tool provided.
  Summarize your key findings concisely (1-2 sentences).
  Output *only* the summary.
  """,
      description="Researches electric vehicle technology.",
      tools=[google_search],
      # Store result in state for the merger agent
      output_key="ev_technology_result"
  )

  # Researcher 3: Carbon Capture
  researcher_agent_3 = LlmAgent(
      name="CarbonCaptureResearcher",
      model=GEMINI_MODEL,
      instruction="""You are an AI Research Assistant specializing in climate solutions.
  Research the current state of 'carbon capture methods'.
  Use the Google Search tool provided.
  Summarize your key findings concisely (1-2 sentences).
  Output *only* the summary.
  """,
      description="Researches carbon capture methods.",
      tools=[google_search],
      # Store result in state for the merger agent
      output_key="carbon_capture_result"
  )

  # --- 2. Create the ParallelAgent (Runs researchers concurrently) ---
  # This agent orchestrates the concurrent execution of the researchers.
  # It finishes once all researchers have completed and stored their results in state.
  parallel_research_agent = ParallelAgent(
      name="ParallelWebResearchAgent",
      sub_agents=[researcher_agent_1, researcher_agent_2, researcher_agent_3],
      description="Runs multiple research agents in parallel to gather information."
  )

  # --- 3. Define the Merger Agent (Runs *after* the parallel agents) ---
  # This agent takes the results stored in the session state by the parallel agents
  # and synthesizes them into a single, structured response with attributions.
  merger_agent = LlmAgent(
      name="SynthesisAgent",
      model=GEMINI_MODEL,  # Or potentially a more powerful model if needed for synthesis
      instruction="""You are an AI Assistant responsible for combining research findings into a structured report.
  Your primary task is to synthesize the following research summaries, clearly attributing findings to their source areas. Structure your response using headings for each topic. Ensure the report is coherent and integrates the key points smoothly.

  **Crucially: Your entire response MUST be grounded *exclusively* on the information provided in the 'Input Summaries' below. Do NOT add any external knowledge, facts, or details not present in these specific summaries.**

  **Input Summaries:**

  *   **Renewable Energy:**
      {renewable_energy_result}
  *   **Electric Vehicles:**
      {ev_technology_result}
  *   **Carbon Capture:**
      {carbon_capture_result}

  **Output Format:**

  ## Summary of Recent Sustainable Technology Advancements

  ### Renewable Energy Findings
  (Based on RenewableEnergyResearcher's findings)
  [Synthesize and elaborate *only* on the renewable energy input summary provided above.]

  ### Electric Vehicle Findings
  (Based on EVResearcher's findings)
  [Synthesize and elaborate *only* on the EV input summary provided above.]

  ### Carbon Capture Findings
  (Based on CarbonCaptureResearcher's findings)
  [Synthesize and elaborate *only* on the carbon capture input summary provided above.]

  ### Overall Conclusion
  [Provide a brief (1-2 sentence) concluding statement that connects *only* the findings presented above.]

  Output *only* the structured report following this format. Do not include introductory or concluding phrases outside this structure, and strictly adhere to using only the provided input summary content.
  """,
      description="Combines research findings from parallel agents into a structured, cited report, strictly grounded on provided inputs.",
      # No tools needed for merging
      # No output_key needed here, as its direct response is the final output of the sequence
  )

  # --- 4. Create the SequentialAgent (Orchestrates the overall flow) ---
  # This is the main agent that will be run. It first executes the ParallelAgent
  # to populate the state, and then executes the MergerAgent to produce the final output.
  sequential_pipeline_agent = SequentialAgent(
      name="ResearchAndSynthesisPipeline",
      # Run parallel research first, then merge
      sub_agents=[parallel_research_agent, merger_agent],
      description="Coordinates parallel research and synthesizes the results."
  )
  root_agent = sequential_pipeline_agent

```

这段代码定义了一个多智能体系统，用于研究和合成有关可持续技术发展的信息。它设置了三个 LlmAgent 实例，充当专业研究员。ResearcherAgent_1 专注于可再生能源，ResearcherAgent_2 研究电动汽车技术，而 ResearcherAgent_3 调查碳捕获方法。每个研究员智能体都配置使用 GEMINI_MODEL 和 google_search 工具。它们被指示简洁地总结其发现（1-2 句话），并使用 output_key 将这些总结存储在会话状态（session state）中。

随后创建了一个名为 ParallelWebResearchAgent 的 ParallelAgent，用于并发运行这三个研究员智能体。这使得研究可以并行进行，从而可能节省时间。ParallelAgent 在其所有子智能体（即研究员）完成并填充状态后，即完成执行。

接下来，定义了一个 MergerAgent（也是一个 LlmAgent）来合成研究结果。这个智能体将并行研究员存储在会话状态中的总结作为输入。其指令强调输出必须严格仅基于所提供的输入总结，禁止添加外部知识。MergerAgent 的设计目的是将合并后的发现结构化为一个报告，其中包含每个主题的标题和一个简短的总体结论。

最后，创建了一个名为 ResearchAndSynthesisPipeline 的 SequentialAgent 来编排整个工作流。作为主要控制器，这个主智能体首先执行 ParallelAgent 来进行研究。一旦 ParallelAgent 完成，SequentialAgent 随后执行 MergerAgent 来合成收集到的信息。sequential_pipeline_agent 被设置为 root_agent，代表运行此多智能体系统的入口点。整个过程旨在高效地并行收集来自多个来源的信息，然后将其组合成一个结构化的报告。

## 📋 概要速览（At a Glance）

### 🎯 是什么 (What)

许多智能体工作流涉及多个子任务，需要完成这些子任务才能实现最终目标。纯粹的顺序执行（每个任务等待前一个任务完成）通常是低效和缓慢的。当任务依赖于外部 I/O 操作（例如调用不同的 API 或查询多个数据库）时，这种延迟成为了一个显著的瓶颈。缺乏并发执行机制会导致总处理时间是所有单个任务持续时间之和，从而阻碍系统的整体性能和响应能力。

---

### 💡 为什么 (Why)

并行化模式通过启用独立任务的同时执行，提供了一个标准化的解决方案。它通过识别工作流中不依赖彼此即时输出的组件（如工具使用或 LLM 调用）来工作。LangChain 和 Google ADK 等智能体框架提供了内置的构造来定义和管理这些并发操作。例如，一个主进程可以调用几个并行运行的子任务，并等待它们全部完成后再进行下一步。通过同时运行这些独立任务而非依次运行，此模式显著减少了总执行时间。

---

### ✅ 经验法则 (Rule of thumb)

当工作流包含多个可以同时运行的独立操作时使用此模式，例如从多个 API 获取数据、处理不同的数据块，或生成多个内容片段以供后续合成。

---

## 🎨 可视化总结

![图2](/images/translations/03-parallelization-02.png)

_图2：并行化设计模式_

## 关键要点

以下是关键要点：

并行化是一种并发执行独立任务以提高效率的模式。

当任务涉及等待外部资源（例如 API 调用）时，它特别有用。

采用并发或并行架构会带来可观的复杂性和成本，影响设计、调试和系统日志记录等关键开发阶段。

LangChain 和 Google ADK 等框架提供内置支持来定义和管理并行执行。

在 LangChain 表达式语言（LCEL）中，RunnableParallel 是用于并排运行多个可运行对象的关键构造。

Google ADK 可以通过 LLM 驱动的委派（LLM-Driven Delegation） 来促进并行执行，其中协调员智能体（Coordinator agent）的 LLM 识别独立的子任务，并触发专业子智能体进行并发处理。

并行化有助于降低总体延迟，并使智能体系统对复杂任务更具响应性。

结论

并行化模式是一种通过并发执行独立子任务来优化计算工作流的方法。这种方法降低了总体延迟，尤其是在涉及多个模型推理或调用外部服务的复杂操作中。

框架提供了不同的机制来实现此模式。在 LangChain 中，使用 RunnableParallel 等构造来明确定义和同时执行多个处理链。相比之下，像 Google 智能体开发者套件（ADK）这样的框架可以通过多智能体委派实现并行化，其中主协调员模型将不同的子任务分配给可以并发操作的专业智能体。

通过将并行处理与顺序（链式）和条件（路由）控制流相结合，可以构建出能够高效管理多样化和复杂任务的复杂、高性能计算系统。

参考文献

以下是有关并行化模式和相关概念的进一步阅读资源：

LangChain 表达式语言（LCEL）文档（并行性）：https://python.langchain.com/docs/concepts/lcel/

Google 智能体开发者套件（ADK）文档（多智能体系统）：https://google.github.io/adk-docs/agents/multi-agents/

Python asyncio 文档：https://docs.python.org/3/library/asyncio.html
