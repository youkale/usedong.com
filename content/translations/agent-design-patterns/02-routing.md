---
title: "第二章：路由（Routing）"
date: 2025-10-10
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "智能路由机制，让 AI 根据上下文动态选择最合适的工具、功能或子智能体"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 2
---

[← 上一章：提示链](../01-prompt-chaining/) | [返回目录](../) | [下一章：并行化 →](../03-parallelization/)

---

# 第二章：路由（Routing）

## 路由模式概览（Routing Pattern Overview）

虽然**提示词链（prompt chaining）**这种按顺序处理信息的方式，是执行确定性、线性工作流程的基础技术，但在需要**自适应响应（adaptive responses）**的场景中，它的适用性受到限制。现实世界的**智能体系统（agentic systems）**通常必须根据偶发因素（contingent factors）来仲裁（arbitrate）多种潜在动作，例如环境状态、用户输入或前一操作的结果。这种**动态决策（dynamic decision-making）**的能力，控制着流程流向不同的专业功能、工具或子流程，是通过一种称为**路由（routing）**的机制来实现的。

路由为智能体的操作框架引入了**条件逻辑（conditional logic）**，使执行路径从固定的模式，转变为智能体根据特定标准动态评估，从一组可能的后续行动中进行选择的模式。这使得系统行为更具**灵活性**和**上下文感知（context-aware）**能力。

例如，一个旨在处理客户咨询的智能体，如果配备了路由功能，它可以首先对传入的查询进行**分类**以确定用户意图。根据分类结果，它可以将查询导向：专门的**问答（question-answering）**智能体、用于检索账户信息的**数据库工具（database retrieval tool）**、或者针对复杂问题的**升级处理流程（escalation procedure）**，而不是默认采用单一的、预定的响应路径。因此，一个使用路由的更复杂的智能体可以：

1.  **分析**用户的查询。
2.  根据**意图**对查询进行**路由**：
    *   如果意图是“**查询订单状态**”，则路由到与订单数据库交互的子智能体或工具链。
    *   如果意图是“**产品信息**”，则路由到搜索产品目录的子智能体或链。
    *   如果意图是“**技术支持**”，则路由到访问故障排除指南或升级至人工客服的不同链。
    *   如果意图**不明确**，则路由到澄清问题的子智能体或提示词链。

路由模式的核心组件是执行**评估**并**指引流程**的机制。该机制可以通过几种方式实现：

*   **基于大语言模型的路由（LLM-based Routing）**：可以直接提示语言模型来分析输入，并输出一个指示下一步或目的地（destination）的特定**标识符**或**指令**。例如，可以提示大语言模型：“分析以下用户查询，并仅输出类别：‘订单状态’、‘产品信息’、‘技术支持’或‘其他’。”智能体系统随后读取此输出，并相应地指引工作流程。

*   **基于嵌入向量的路由（Embedding-based Routing）**：将输入查询转换为**向量嵌入（vector embedding）**（参见 RAG，第十四章）。然后将该嵌入向量与代表不同路由或功能的嵌入向量进行比较。查询会被路由到嵌入向量**最相似**的那个路由。这对于**语义路由（semantic routing）**非常有用，因为决策是基于输入的**含义**，而不仅仅是关键词。

*   **基于规则的路由（Rule-based Routing）**：这涉及使用**预定义规则或逻辑**（例如，`if-else` 语句、`switch cases`），基于输入中提取的关键词、模式或结构化数据。这种方法比基于大语言模型的路由**更快**、**更具确定性**，但在处理细微差别或新颖输入方面**灵活性较低**。

*   **基于机器学习模型的路由（Machine Learning Model-Based Routing）**：它采用**判别模型（discriminative model）**，例如分类器，该模型经过**少量标记数据语料库**的专门训练以执行路由任务。虽然它与基于嵌入向量的方法在概念上相似，但其关键特征是**监督式微调（supervised fine-tuning）**过程，该过程调整模型参数以创建专门的路由功能。该技术不同于基于大语言模型的路由，因为决策组件不是在推理时执行提示词的**生成式模型（generative model）**。相反，路由逻辑被编码在经过微调的模型的**学习权重（learned weights）**中。虽然大语言模型可能在预处理步骤中用于生成**合成数据**以增加训练集，但它们**不参与**实时路由决策本身。

路由机制可以在智能体操作周期的**多个节点**上实现。它们可以在**开始阶段**应用以对主要任务进行分类，可以在处理链的**中间点**应用以确定后续动作，也可以在**子程序（subroutine）**中应用以从给定集合中选择最合适的工具。

LangChain、LangGraph 和 Google 的 Agent Developer Kit (ADK) 等计算框架提供了明确的**构造**来定义和管理此类条件逻辑。LangGraph 凭借其**基于状态的图架构**，特别适合于决策依赖于整个系统累积状态的复杂路由场景。同样，Google 的 ADK 提供了构建智能体能力和交互模型的基础组件，作为实现路由逻辑的基础。在这些框架提供的执行环境中，开发者定义了可能的操作路径，以及决定计算图（computational graph）中节点之间转换的函数或基于模型的评估。

路由的实现使系统能够超越**确定性顺序处理（deterministic sequential processing）**。它促进了**自适应执行流（adaptive execution flows）**的开发，这些流程可以动态且适当地响应更广泛的输入和状态变化。

---

## 实际应用与用例（Practical Applications & Use Cases）

路由模式是**自适应智能体系统**设计中的关键控制机制，使其能够根据可变输入和内部状态动态改变其执行路径。通过提供必要的条件逻辑层，它的效用跨越了多个领域。

*   **在人机交互中**，例如虚拟助手或人工智能驱动的导师，路由用于**解释用户意图**。对自然语言查询的初步分析确定了最合适的后续行动，无论是调用特定的信息检索工具、升级给人工操作员，还是根据用户表现选择课程中的下一个模块。这使得系统能够超越线性对话流程，进行**上下文相关的响应**。

*   **在自动化数据和文档处理管道中**，路由充当**分类和分发功能**。系统根据内容、元数据或格式分析传入的数据（例如电子邮件、支持工单或 API 有效载荷）。然后，系统将每个项目导向相应的**工作流程**，例如销售线索摄取流程、针对 JSON 或 CSV 格式的特定数据转换功能，或紧急问题升级路径。

*   **在涉及多个专业工具或智能体的复杂系统中**，路由充当**高层调度器（high-level dispatcher）**。一个由搜索、总结和分析信息等不同智能体组成的研究系统，将使用**路由器**根据当前目标将任务分配给**最合适的智能体**。同样，一个人工智能编码助手使用路由来**识别编程语言和用户意图**——是调试、解释还是翻译——然后再将代码片段传递给正确的专业工具。

最终，路由提供了**逻辑仲裁能力（capacity for logical arbitration）**，这对于创建功能多样化和上下文感知的系统至关重要。它将智能体从预定义序列的静态执行者，转变为一个**动态系统**，能够在不断变化的条件下，就完成任务的**最有效方法**做出决策。

---

## 动手代码示例（LangChain）

在代码中实现路由涉及定义**可能的路径**以及决定**选择哪条路径的逻辑**。LangChain 和 LangGraph 等框架为此提供了特定的组件和结构。LangGraph 基于状态的图结构对于**可视化和实现**路由逻辑尤其直观。

以下代码演示了一个使用 LangChain 和 Google 的生成式 AI 构建的简单**类智能体系统**。它设置了一个“协调器”（coordinator），根据用户请求的**意图**（预订、信息或不明确）将请求路由到不同的**模拟“子智能体”处理程序**。系统使用语言模型对请求进行分类，然后将其委托给相应的处理函数，模拟了多智能体架构中常见的**基本委托模式（basic delegation pattern）**。

首先，确保您安装了必要的库：
```bash
pip install langchain langgraph google-cloud-aiplatform langchain-google-genai google-adk deprecated pydantic
```

您还需要通过 API 密钥设置您的环境以使用您选择的语言模型（例如，OpenAI、Google Gemini、Anthropic）。

```python
# Copyright (c) 2025 Marco Fago
# https://www.linkedin.com/in/marco-fago/
#
# This code is licensed under the MIT License.
# See the LICENSE file in the repository for the full license text.

from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_core.runnables import RunnablePassthrough, RunnableBranch

# --- Configuration ---
# Ensure your API key environment variable is set (e.g., GOOGLE_API_KEY)
try:
   llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0)
   print(f"Language model initialized: {llm.model}")
except Exception as e:
   print(f"Error initializing language model: {e}")
   llm = None

# --- Define Simulated Sub-Agent Handlers (equivalent to ADK sub_agents) ---

def booking_handler(request: str) -> str:
   """Simulates the Booking Agent handling a request."""
   print("\n--- DELEGATING TO BOOKING HANDLER ---")
   return f"Booking Handler processed request: '{request}'. Result: Simulated booking action."

def info_handler(request: str) -> str:
   """Simulates the Info Agent handling a request."""
   print("\n--- DELEGATING TO INFO HANDLER ---")
   return f"Info Handler processed request: '{request}'. Result: Simulated information retrieval."

def unclear_handler(request: str) -> str:
   """Handles requests that couldn't be delegated."""
   print("\n--- HANDLING UNCLEAR REQUEST ---")
   return f"Coordinator could not delegate request: '{request}'. Please clarify."

# --- Define Coordinator Router Chain (equivalent to ADK coordinator's instruction) ---
# This chain decides which handler to delegate to.
coordinator_router_prompt = ChatPromptTemplate.from_messages([
   ("system", """Analyze the user's request and determine which specialist handler should process it.
    - If the request is related to booking flights or hotels,
      output 'booker'.
    - For all other general information questions, output 'info'.
    - If the request is unclear or doesn't fit either category,
      output 'unclear'.
    ONLY output one word: 'booker', 'info', or 'unclear'."""),
   ("user", "{request}")
])

if llm:
   coordinator_router_chain = coordinator_router_prompt | llm | StrOutputParser()

# --- Define the Delegation Logic (equivalent to ADK's Auto-Flow based on sub_agents) ---
# Use RunnableBranch to route based on the router chain's output.

# Define the branches for the RunnableBranch
branches = {
   "booker": RunnablePassthrough.assign(output=lambda x: booking_handler(x['request']['request'])),
   "info": RunnablePassthrough.assign(output=lambda x: info_handler(x['request']['request'])),
   "unclear": RunnablePassthrough.assign(output=lambda x: unclear_handler(x['request']['request'])),
}

# Create the RunnableBranch. It takes the output of the router chain
# and routes the original input ('request') to the corresponding handler.
delegation_branch = RunnableBranch(
   (lambda x: x['decision'].strip() == 'booker', branches["booker"]), # Added .strip()
   (lambda x: x['decision'].strip() == 'info', branches["info"]),     # Added .strip()
   branches["unclear"] # Default branch for 'unclear' or any other output
)

# Combine the router chain and the delegation branch into a single runnable
# The router chain's output ('decision') is passed along with the original input ('request')
# to the delegation_branch.
coordinator_agent = {
   "decision": coordinator_router_chain,
   "request": RunnablePassthrough()
} | delegation_branch | (lambda x: x['output']) # Extract the final output

# --- Example Usage ---
def main():
   if not llm:
       print("\nSkipping execution due to LLM initialization failure.")
       return

   print("--- Running with a booking request ---")
   request_a = "Book me a flight to London."
   result_a = coordinator_agent.invoke({"request": request_a})
   print(f"Final Result A: {result_a}")

   print("\n--- Running with an info request ---")
   request_b = "What is the capital of Italy?"
   result_b = coordinator_agent.invoke({"request": request_b})
   print(f"Final Result B: {result_b}")

   print("\n--- Running with an unclear request ---")
   request_c = "Tell me about quantum physics."
   result_c = coordinator_agent.invoke({"request": request_c})
   print(f"Final Result C: {result_c}")

if __name__ == "__main__":
   main()
```
**代码输出：**
```
Language model initialized: gemini-2.5-flash
--- Running with a booking request ---

--- DELEGATING TO BOOKING HANDLER ---
Final Result A: Booking Handler processed request: 'Book me a flight to London.'. Result: Simulated booking action.

--- Running with an info request ---

--- DELEGATING TO INFO HANDLER ---
Final Result B: Info Handler processed request: 'What is the capital of Italy?'. Result: Simulated information retrieval.

--- Running with an unclear request ---

--- HANDLING UNCLEAR REQUEST ---
Final Result C: Coordinator could not delegate request: 'Tell me about quantum physics.'. Please clarify.
```

如前所述，这段 Python 代码构造了一个使用 LangChain 库和 Google 的生成式 AI 模型，特别是 `gemini-2.5-flash` 的简单类智能体系统。详细来说，它定义了三个模拟的子智能体处理程序：`booking_handler`、`info_handler` 和 `unclear_handler`，每个都旨在处理特定类型的请求。核心组件是 `coordinator_router_chain`，它利用 `ChatPromptTemplate` **指示**语言模型将传入的用户请求分类为三个类别之一：`'booker'`、`'info'` 或 `'unclear'`。此路由链的输出随后被 `RunnableBranch` 用于**委托**原始请求给相应的处理函数。`RunnableBranch` **检查**来自语言模型的决策，并将请求数据导向 `booking_handler`、`info_handler` 或 `unclear_handler`。`coordinator_agent` 将这些组件结合起来，首先路由请求以做出决策，然后将请求传递给选定的处理程序。最终输出从处理程序的响应中提取。`main` 函数通过三个示例请求演示了系统的用法，展示了不同的输入如何被路由并由模拟智能体处理。代码中包含对语言模型初始化失败的错误处理，以确保健壮性。代码结构模仿了一个基本的**多智能体框架**，其中中央协调器根据意图将任务委托给专业智能体。

---

## 动手代码示例（Google ADK）

Agent Development Kit (ADK) 是一个用于工程化智能体系统的框架，为定义智能体的能力和行为提供了**结构化环境**。与基于显式计算图的架构相比，ADK 范式中的路由通常是通过定义一组**离散的“工具”（tools）**来实现的，这些工具代表智能体的功能。针对用户查询选择适当工具的过程由框架的**内部逻辑**管理，该逻辑利用**底层模型**将用户意图与正确的**功能处理程序**进行匹配。

以下 Python 代码演示了使用 Google ADK 库的 Agent Development Kit (ADK) 应用程序示例。它设置了一个“协调器”（Coordinator）智能体，根据定义的指令将用户请求路由到专业子智能体（“Booker”用于预订，“Info”用于一般信息）。然后，子智能体使用特定的**工具**来模拟处理请求，展示了智能体系统中的基本委托模式。

```python
# Copyright (c) 2025 Marco Fago
#
# This code is licensed under the MIT License.
# See the LICENSE file in the repository for the full license text.

import uuid
from typing import Dict, Any, Optional

from google.adk.agents import Agent
from google.adk.runners import InMemoryRunner
from google.adk.tools import FunctionTool
from google.genai import types
from google.adk.events import Event

# --- Define Tool Functions ---
# These functions simulate the actions of the specialist agents.

def booking_handler(request: str) -> str:
   """
   Handles booking requests for flights and hotels.
   Args:
       request: The user's request for a booking.
   Returns:
       A confirmation message that the booking was handled.
   """
   print("-------------------------- Booking Handler Called ----------------------------")
   return f"Booking action for '{request}' has been simulated."

def info_handler(request: str) -> str:
   """
   Handles general information requests.
   Args:
       request: The user's question.
   Returns:
       A message indicating the information request was handled.
   """
   print("-------------------------- Info Handler Called ----------------------------")
   return f"Information request for '{request}'. Result: Simulated information retrieval."

def unclear_handler(request: str) -> str:
   """Handles requests that couldn't be delegated."""
   return f"Coordinator could not delegate request: '{request}'. Please clarify."

# --- Create Tools from Functions ---
booking_tool = FunctionTool(booking_handler)
info_tool = FunctionTool(info_handler)

# Define specialized sub-agents equipped with their respective tools
booking_agent = Agent(
   name="Booker",
   model="gemini-2.0-flash",
   description="A specialized agent that handles all flight
           and hotel booking requests by calling the booking tool.",
   tools=[booking_tool]
)

info_agent = Agent(
   name="Info",
   model="gemini-2.0-flash",
   description="A specialized agent that provides general information
      and answers user questions by calling the info tool.",
   tools=[info_tool]
)

# Define the parent agent with explicit delegation instructions
coordinator = Agent(
   name="Coordinator",
   model="gemini-2.0-flash",
   instruction=(
       "You are the main coordinator. Your only task is to analyze
        incoming user requests "
       "and delegate them to the appropriate specialist agent.
        Do not try to answer the user directly.\n"
       "- For any requests related to booking flights or hotels,
         delegate to the 'Booker' agent.\n"
       "- For all other general information questions, delegate to the 'Info' agent."
   ),
   description="A coordinator that routes user requests to the
     correct specialist agent.",
   # The presence of sub_agents enables LLM-driven delegation (Auto-Flow) by default.
   sub_agents=[booking_agent, info_agent]
)

# --- Execution Logic ---

async
 def run_coordinator(runner: InMemoryRunner, request: str):
   """Runs the coordinator agent with a given request and delegates."""
   print(f"\n--- Running Coordinator with request: '{request}' ---")
   final_result = ""
   try:
       user_id = "user_123"
       session_id = str(uuid.uuid4())
       await
 runner.session_service.create_session(
           app_name=runner.app_name, user_id=user_id, session_id=session_id
       )

       for event in runner.run(
           user_id=user_id,
           session_id=session_id,
           new_message=types.Content(
               role='user',
               parts=[types.Part(text=request)]
           ),
       ):
           if event.is_final_response() and event.content:
               # Try to get text directly from event.content
               # to avoid iterating parts
               if hasattr(event.content, 'text') and event.content.text:
                    final_result = event.content.text
               elif event.content.parts:
                   # Fallback: Iterate through parts and extract text (might trigger warning)
                   text_parts = [part.text for part in event.content.parts if part.text]
                   final_result = "".join(text_parts)
               # Assuming the loop should break after the final response
               break

       print(f"Coordinator Final Response: {final_result}")
       return final_result
   except Exception as e:
       print(f"An error occurred while processing your request: {e}")
       return f"An error occurred while processing your request: {e}"

async
 def main():
   """Main function to run the ADK example."""
   print("--- Google ADK Routing Example (ADK Auto-Flow Style) ---")
   print("Note: This requires Google ADK installed and authenticated.")

   runner = InMemoryRunner(coordinator)
   # Example Usage
   result_a = await run_coordinator(runner, "Book me a hotel in Paris.")
   print(f"Final Output A: {result_a}")
   result_b = await run_coordinator(runner, "What is the highest mountain in the world?")
   print(f"Final Output B: {result_b}")
   result_c = await run_coordinator(runner, "Tell me a random fact.") # Should go to Info
   print(f"Final Output C: {result_c}")
   result_d = await run_coordinator(runner, "Find flights to Tokyo next month.") # Should go to Booker
   print(f"Final Output D: {result_d}")

if __name__ == "__main__":
   import nest_asyncio
   nest_asyncio.apply()
   await main()
```

**代码输出：**
```
--- Google ADK Routing Example (ADK Auto-Flow Style) ---
Note: This requires Google ADK installed and authenticated.

--- Running Coordinator with request: 'Book me a hotel in Paris.' ---
-------------------------- Booking Handler Called ----------------------------
Coordinator Final Response: Booking action for 'Book me a hotel in Paris.' has been simulated.
Final Output A: Booking action for 'Book me a hotel in Paris.' has been simulated.

--- Running Coordinator with request: 'What is the highest mountain in the world?' ---
-------------------------- Info Handler Called ----------------------------
Coordinator Final Response: Information request for 'What is the highest mountain in the world?'. Result: Simulated information retrieval.
Final Output B: Information request for 'What is the highest mountain in the world?'. Result: Simulated information retrieval.

--- Running Coordinator with request: 'Tell me a random fact.' ---
-------------------------- Info Handler Called ----------------------------
Coordinator Final Response: Information request for 'Tell me a random fact.'. Result: Simulated information retrieval.
Final Output C: Information request for 'Tell me a random fact.'. Result: Simulated information retrieval.

--- Running Coordinator with request: 'Find flights to Tokyo next month.' ---
-------------------------- Booking Handler Called ----------------------------
Coordinator Final Response: Booking action for 'Find flights to Tokyo next month.' has been simulated.
Final Output D: Booking action for 'Find flights to Tokyo next month.' has been simulated.
```

该脚本由一个主要的**协调器（Coordinator）**智能体和两个专业的**子智能体（sub\_agents）**：`Booker` 和 `Info` 组成。每个专业智能体都配备了一个**功能工具（FunctionTool）**，该工具封装了一个模拟动作的 Python 函数。`booking_handler` 函数模拟处理航班和酒店预订，而 `info_handler` 函数模拟检索一般信息。`unclear_handler` 被包含作为协调器无法委托的请求的备用处理，尽管在 `run_coordinator` 主函数中，当前的协调器逻辑没有明确使用它进行委托失败。协调器智能体的主要职责，如其指令中所定义，是**分析**传入的用户消息并**委托**给 `Booker` 或 `Info` 智能体。这种委托是由 ADK 的 **Auto-Flow 机制**自动处理的，因为协调器定义了子智能体。`run_coordinator` 函数设置了一个 `InMemoryRunner`，创建了用户和会话 ID，然后使用运行器通过协调器智能体处理用户的请求。`runner.run` 方法处理请求并生成事件，代码从 `event.content` 中提取最终响应文本。`main` 函数通过运行不同的请求来演示系统的用法，展示了它如何将预订请求**委托**给 `Booker`，并将信息请求**委托**给 `Info` 智能体。

---

## 一览（At a Glance）

### 质（What）

**智能体系统**通常必须响应各种无法通过单一、线性流程处理的输入和情境。简单的顺序工作流**缺乏**根据上下文做出决策的能力。如果缺少针对特定任务选择正确工具或子流程的机制，系统将保持**僵硬**且**无法适应**。这种限制使得构建能够管理现实世界用户请求的复杂性和多变性的复杂应用程序变得困难。

---

### 理（Why）

**路由模式**通过在智能体的操作框架中引入**条件逻辑**，提供了一个标准化解决方案。它使系统能够**首先分析**传入的查询以确定其意图或性质。基于此分析，智能体**动态地**将控制流导向最合适的专业工具、功能或子智能体。此决策可以通过多种方法驱动，包括提示大语言模型、应用预定义规则或使用**基于嵌入向量的语义相似性**。最终，路由将**静态、预定**的执行路径，转换为能够选择**最佳可行行动**的**灵活且上下文感知**的工作流程。

---

### 法（Rule of Thumb）

当智能体**必须**根据用户输入或当前状态**在多个不同的工作流程、工具或子智能体之间做出决策**时，请使用路由模式。这对于需要**分类或分流**传入请求以处理不同类型任务的应用程序至关重要，例如客户支持机器人区分销售咨询、技术支持和账户管理问题。

---

### 图（Visual Summary）

![图1](/images/translations/02-router-parttent.png)
_Fig.1: Router pattern, using an LLM as a Router（使用大语言模型作为路由器的路由模式）_

## 关键要点（Key Takeaways）

*   **路由**使智能体能够根据条件对工作流的下一步做出**动态决策**。
*   它允许智能体处理**多样化的输入**并**调整其行为**，超越线性执行。
*   路由逻辑可以使用**大语言模型**、**基于规则的系统**或**嵌入向量相似性**来实现。
*   **LangGraph** 和 **Google ADK** 等框架提供了结构化的方式来定义和管理智能体工作流中的路由，尽管它们的架构方法有所不同。

## 结论（Conclusion）

**路由模式**是构建真正**动态且响应迅速**的智能体系统的关键一步。通过实施路由，我们超越了简单的线性执行流，并赋予我们的智能体**智能决策**的能力，以确定如何处理信息、响应用户输入以及利用可用的工具或子智能体。

我们已经看到路由如何应用于各个领域，从客户服务聊天机器人到复杂的数据处理管道。**分析输入并有条件地指引工作流程**的能力，是创建能够处理现实世界任务固有可变性的智能体的基础。

使用 **LangChain** 和 **Google ADK** 的代码示例展示了两种不同但有效的路由实现方法。LangGraph 基于图的结构提供了一种**可视化和明确**的方式来定义状态和转换，使其非常适合具有复杂路由逻辑的多步骤工作流。另一方面，Google ADK 通常侧重于定义**离散的能力（工具）**，并依赖于框架的**自动路由**能力，这对于具有明确定义离散动作集的智能体可能更简单。

掌握路由模式对于构建能够**智能地导航**不同情境并根据上下文提供**定制响应或行动**的智能体至关重要。它是创建多功能且健壮的智能体应用程序的关键组成部分。

## 参考资料（References）

*   LangGraph Documentation: https://www.langchain.com/
*   Google Agent Developer Kit Documentation: https://google.github.io/adk-docs/
