---
title: "第八章：记忆管理（Memory Management）"
date: 2025-10-12
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "通过短期和长期记忆机制使智能体保持上下文并从过往经验中学习"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 8
---

[← 上一章：多智能体协作](../07-multi-agent-collaboration/) | [返回目录](../) | [下一章：学习与适应 →](../09-learning-and-adaptation/)

---

# 第八章：记忆管理（Memory Management）

高效的内存管理对于智能体保留信息至关重要。与人类一样，智能体需要不同类型的内存才能高效运行。本章深入探讨内存管理，特别是处理智能体对即时（短期）和持久（长期）内存的要求。

在智能体系统中，内存是指智能体保留和利用过去互动、观察和学习经验中信息的能力。这种能力使智能体能够做出明智的决策、保持对话的上下文，并随着时间的推移而改进。智能体内存通常分为两个主要类别：

**短期内存（上下文内存）：** 类似于工作内存，它保存当前正在处理或最近访问的信息。对于使用大型语言模型（LLMs）的智能体来说，短期内存主要存在于**上下文窗口**内。此窗口包含最近的消息、智能体回复、工具使用结果以及来自当前交互的智能体反思，所有这些都为 LLM 后续的响应和行动提供信息。上下文窗口的容量有限，限制了智能体可以直接访问的最近信息的量。高效的短期内存管理涉及将最相关的信息保留在这个有限的空间内，可能通过总结较旧的对话片段或强调关键细节等技术来实现。具有“长上下文”窗口的模型的出现只是扩展了这种短期内存的大小，允许在一次交互中容纳更多信息。然而，这种上下文仍然是**短暂的**，一旦会话结束就会丢失，并且每次处理都可能成本高昂且效率低下。因此，智能体需要单独的内存类型来实现真正的持久性、从过去的交互中召回信息并构建持久的知识库。

**长期内存（持久内存）：** 它充当智能体需要在各种交互、任务或延长的时间段内保留的信息存储库，类似于长期知识库。数据通常存储在智能体的即时处理环境之外，通常在数据库、知识图谱或**向量数据库**中。在向量数据库中，信息被转换为数值向量并存储，使智能体能够根据**语义相似性**而不是精确的关键词匹配来检索数据，这个过程被称为**语义搜索**。当智能体需要来自长期内存的信息时，它会查询外部存储，检索相关数据，并将其集成到短期上下文以供立即使用，从而将先验知识与当前交互结合起来。

## 实际应用和用例

内存管理对于智能体跟踪信息并随着时间的推移智能地执行任务至关重要。这对于智能体超越基本问答能力是必不可少的。应用包括：

*   **聊天机器人和对话式 AI：** 维持对话流程依赖于短期内存。聊天机器人需要记住先前的用户输入才能提供连贯的回复。长期内存使聊天机器人能够召回用户偏好、过去的问题或先前的讨论，从而提供个性化和连续的交互。
*   **面向任务的智能体：** 管理多步骤任务的智能体需要短期内存来跟踪先前的步骤、当前的进度和总体目标。此信息可能驻留在任务的上下文或临时存储中。长期内存对于访问不在即时上下文中的特定用户相关数据至关重要。
*   **个性化体验：** 提供量身定制交互的智能体利用长期内存来存储和检索用户偏好、过去行为和个人信息。这允许智能体调整其响应和建议。
*   **学习和改进：** 智能体可以通过从过去的交互中学习来完善其性能。成功的策略、错误和新信息存储在长期内存中，促进未来的适应。强化学习智能体以这种方式存储习得的策略或知识。
*   **信息检索（RAG）：** 旨在回答问题的智能体访问知识库，即它们的长期内存，通常在**检索增强生成（RAG）**中实现。智能体检索相关的文档或数据来为其响应提供信息。
*   **自主系统：** 机器人或自动驾驶汽车需要内存来存储地图、路线、物体位置和习得行为。这涉及用于即时周围环境的短期内存和用于一般环境知识的长期内存。

内存使智能体能够维护历史、学习、个性化交互，并管理复杂的、依赖时间的问题。

## 动手实践代码：Google 智能体开发工具包（ADK）中的内存管理

Google 智能体开发工具包（ADK）提供了一种用于管理上下文和内存的结构化方法，包括用于实际应用的组件。牢固掌握 ADK 的 **会话（Session）**、**状态（State）**和**内存（Memory）**对于构建需要保留信息的智能体至关重要。

正如在人类交互中一样，智能体需要能够召回先前的交流，以进行连贯和自然的对话。ADK 通过三个核心概念及其相关的服务简化了上下文管理。

与智能体的每一次交互都可以被视为一个独特的对话线程。智能体可能需要访问来自更早交互的数据。ADK 结构如下：

| 概念 | 描述 | 类比 |
| :--- | :--- | :--- |
| **会话（Session）** | 记录该特定交互的消息和行动（**事件**）的单个聊天线程，也存储与该对话相关的临时数据（**状态**）。 | 一次完整的对话 |
| **状态（session.state）** | 存储在会话内的数据，仅包含与当前活跃聊天线程相关的信息。 | 对话中的“临时便笺” |
| **内存（Memory）** | 一个可搜索的信息存储库，源自各种过去的聊天或外部来源，作为超出即时对话的数据检索资源。 | 长期知识库 |

ADK 提供了专门的服务来管理对于构建复杂、有状态和上下文感知智能体至关重要的关键组件。**SessionService** 通过处理会话的启动、记录和终止来管理聊天线程（Session 对象），而 **MemoryService** 则负责监督长期知识（Memory）的存储和检索。

SessionService 和 MemoryService 都提供各种配置选项，允许用户根据应用程序需求选择存储方法。内存选项可用于测试目的，但数据不会在重启后保留。对于持久存储和可扩展性，ADK 还支持数据库和基于云的服务。

### 会话（Session）：跟踪每次聊天

ADK 中的 `Session` 对象旨在跟踪和管理单个聊天线程。在与智能体发起对话时，`SessionService` 会生成一个 `Session` 对象，表示为 `google.adk.sessions.Session`。此对象封装了与特定对话线程相关的所有数据，包括唯一标识符（`id`, `app_name`, `user_id`）、作为 `Event` 对象的事件时间记录、用于会话特定临时数据的存储区（称为 `state`），以及指示上次更新的时间戳（`last_update_time`）。开发人员通常通过 `SessionService` 间接与 `Session` 对象交互。`SessionService` 负责管理会话会话的生命周期，其中包括启动新会话、恢复以前的会话、记录会话活动（包括状态更新）、识别活跃会话以及管理会话数据的移除。ADK 提供了几种具有不同会话历史和临时数据存储机制的 `SessionService` 实现，例如 `InMemorySessionService`，它适用于测试但不提供跨应用程序重启的数据持久性。

```python
# Example: Using InMemorySessionService
# This is suitable for local development and testing where data
# persistence across application restarts is not required.
from google.adk.sessions import InMemorySessionService
session_service = InMemorySessionService()


Then there's DatabaseSessionService if you want reliable saving to a database you manage.
# Example: Using DatabaseSessionService
# This is suitable for production or development requiring persistent storage.
# You need to configure a database URL (e.g., for SQLite, PostgreSQL, etc.).
# Requires: pip install google-adk[sqlalchemy] and a database driver (e.g., psycopg2 for PostgreSQL)
from google.adk.sessions import DatabaseSessionService
# Example using a local SQLite file:
db_url = "sqlite:///./my_agent_data.db"
session_service = DatabaseSessionService(db_url=db_url)




Besides, there's VertexAiSessionService which uses Vertex AI infrastructure for scalable production on Google Cloud.
# Example: Using VertexAiSessionService
# This is suitable for scalable production on Google Cloud Platform, leveraging
# Vertex AI infrastructure for session management.
# Requires: pip install google-adk[vertexai] and GCP setup/authentication
from google.adk.sessions import VertexAiSessionService

PROJECT_ID = "your-gcp-project-id" # Replace with your GCP project ID
LOCATION = "us-central1" # Replace with your desired GCP location
# The app_name used with this service should correspond to the Reasoning Engine ID or name
REASONING_ENGINE_APP_NAME = "projects/your-gcp-project-id/locations/us-central1/reasoningEngines/your-engine-id" # Replace with your Reasoning Engine resource name

session_service = VertexAiSessionService(project=PROJECT_ID, location=LOCATION)
# When using this service, pass REASONING_ENGINE_APP_NAME to service methods:
# session_service.create_session(app_name=REASONING_ENGINE_APP_NAME, ...)
# session_service.get_session(app_name=REASONING_ENGINE_APP_NAME, ...)
# session_service.append_event(session, event, app_name=REASONING_ENGINE_APP_NAME)
# session_service.delete_session(app_name=REASONING_ENGINE_APP_NAME, ...)

```

选择合适的 `SessionService` 至关重要，因为它决定了智能体的交互历史和临时数据的存储方式及其持久性。

每次消息交换都涉及一个循环过程：接收到一条消息，`Runner` 使用 `SessionService` 检索或建立一个 `Session`，智能体使用 `Session` 的上下文（状态和历史交互）处理消息，智能体生成响应并可能更新状态，`Runner` 将此封装为一个 `Event`，然后 `session_service.append_event` 方法记录新事件并更新存储中的状态。然后 `Session` 等待下一条消息。理想情况下，当交互结束时，会使用 `delete_session` 方法来终止会话。此过程说明了 `SessionService` 如何通过管理 `Session` 特定的历史记录和临时数据来维持连续性。

### 状态（State）：会话的草稿本

在 ADK 中，每个代表一个聊天线程的 `Session` 都包含一个 `state` 组件，类似于智能体在该特定对话期间的临时工作内存。虽然 `session.events` 记录了整个聊天历史，但 `session.state` 存储和更新与活跃聊天相关的动态数据点。

从根本上说，`session.state` 作为一个**字典**运行，将数据存储为键值对。其核心功能是使智能体能够保留和管理对于连贯对话至关重要的细节，例如用户偏好、任务进度、增量数据收集或影响后续智能体操作的条件标志。

状态的结构包括与可序列化 Python 类型的值（包括字符串、数字、布尔值、列表以及包含这些基本类型的字典）配对的字符串键。状态是**动态**的，在整个对话中不断演变。这些更改的永久性取决于配置的 `SessionService`。

可以使用**键前缀**来实现状态组织，以定义数据范围和持久性。

*   **没有前缀**的键是会话特定的。
*   `user:` 前缀将数据与所有会话中的用户 ID 关联。
*   `app:` 前缀指定在应用程序所有用户之间共享的数据。
*   `temp:` 前缀表示仅在当前处理回合中有效且不会持久存储的数据。

智能体通过单个 `session.state` 字典访问所有状态数据。`SessionService` 处理数据检索、合并和持久性。应在通过 `session_service.append_event()` 向会话历史添加 `Event` 时更新状态。这确保了准确的跟踪、在持久服务中的正确保存以及对状态更改的安全处理。

**简单方法：使用 output\_key（用于智能体文本回复）：** 如果您只是想将智能体的最终文本回复直接保存到状态中，这是最简单的方法。当您设置 `LlmAgent` 时，只需告诉它您想要使用的 `output_key`。`Runner` 会看到这一点，并在附加事件时自动创建必要的动作，将回复保存到状态。让我们看一个演示通过 `output_key` 更新状态的代码示例。

```python
# Import necessary classes from the Google Agent Developer Kit (ADK)
from google.adk.agents import LlmAgent
from google.adk.sessions import InMemorySessionService, Session
from google.adk.runners import Runner
from google.genai.types import Content, Part

# Define an LlmAgent with an output_key.
greeting_agent = LlmAgent(
   name="Greeter",
   model="gemini-2.0-flash",
   instruction="Generate a short, friendly greeting.",
   output_key="last_greeting"
)

# --- Setup Runner and Session ---
app_name, user_id, session_id = "state_app", "user1", "session1"
session_service = InMemorySessionService()
runner = Runner(
   agent=greeting_agent,
   app_name=app_name,
   session_service=session_service
)
session = session_service.create_session(
   app_name=app_name,
   user_id=user_id,
   session_id=session_id
)

print(f"Initial state: {session.state}")

# --- Run the Agent ---
user_message = Content(parts=[Part(text="Hello")])
print("\n--- Running the agent ---")
for event in runner.run(
   user_id=user_id,
   session_id=session_id,
   new_message=user_message
):
   if event.is_final_response():
     print("Agent responded.")

# --- Check Updated State ---
# Correctly check the state *after* the runner has finished processing all events.
updated_session = session_service.get_session(app_name, user_id, session_id)
print(f"\nState after agent run: {updated_session.state}")

```

在幕后，`Runner` 看到您的 `output_key` 并在调用 `append_event` 时自动创建带有 `state_delta` 的必要动作。

**标准方法：使用 EventActions.state\_delta（用于更复杂的更新）：** 对于需要执行更复杂操作的时候——例如一次更新多个键、保存不仅仅是文本的内容、针对 `user:` 或 `app:` 等特定范围，或者进行与智能体最终文本回复无关的更新——您将手动构建状态更改字典（`state_delta`）并将其包含在您要附加的 `Event` 的 `EventActions` 中。让我们看一个例子：

```python
import time
from google.adk.tools.tool_context import ToolContext
from google.adk.sessions import InMemorySessionService

# --- Define the Recommended Tool-Based Approach ---
def log_user_login(tool_context: ToolContext) -> dict:
   """
   Updates the session state upon a user login event.
   This tool encapsulates all state changes related to a user login.
   Args:
       tool_context: Automatically provided by ADK, gives access to session state.
   Returns:
       A dictionary confirming the action was successful.
   """
   # Access the state directly through the provided context.
   state = tool_context.state

   # Get current values or defaults, then update the state.
   # This is much cleaner and co-locates the logic.
   login_count = state.get("user:login_count", 0) + 1
   state["user:login_count"] = login_count
   state["task_status"] = "active"
   state["user:last_login_ts"] = time.time()
   state["temp:validation_needed"] = True

   print("State updated from within the `log_user_login` tool.")

   return {
       "status": "success",
       "message": f"User login tracked. Total logins: {login_count}."
   }

# --- Demonstration of Usage ---
# In a real application, an LLM Agent would decide to call this tool.
# Here, we simulate a direct call for demonstration purposes.

# 1. Setup
session_service = InMemorySessionService()
app_name, user_id, session_id = "state_app_tool", "user3", "session3"
session = session_service.create_session(
   app_name=app_name,
   user_id=user_id,
   session_id=session_id,
   state={"user:login_count": 0, "task_status": "idle"}
)
print(f"Initial state: {session.state}")

# 2. Simulate a tool call (in a real app, the ADK Runner does this)
# We create a ToolContext manually just for this standalone example.
from google.adk.tools.tool_context import InvocationContext
mock_context = ToolContext(
   invocation_context=InvocationContext(
       app_name=app_name, user_id=user_id, session_id=session_id,
       session=session, session_service=session_service
   )
)

# 3. Execute the tool
log_user_login(mock_context)

# 4. Check the updated state
updated_session = session_service.get_session(app_name, user_id, session_id)
print(f"State after tool execution: {updated_session.state}")

# Expected output will show the same state change as the
# "Before" case,
# but the code organization is significantly cleaner
# and more robust.

```

此代码演示了一种基于工具的方法，用于管理应用程序中的用户会话状态。它定义了一个函数 `log_user_login`，该函数充当一个工具。此工具负责在用户登录时更新会话状态。

该函数接受一个 `ToolContext` 对象，由 ADK 提供，以访问和修改会话的 `state` 字典。在工具内部，它会递增 `user:login_count`，将 `task_status` 设置为 `"active"`，记录 `user:last_login_ts`（时间戳），并添加一个临时标志 `temp:validation_needed`。

代码的演示部分模拟了如何使用此工具。它设置了一个内存会话服务，并创建了一个具有一些预定义状态的初始会话。然后手动创建一个 `ToolContext`，以模仿 ADK `Runner` 将执行该工具的环境。使用此模拟上下文调用 `log_user_login` 函数。最后，代码再次检索会话以显示状态已通过工具的执行得到更新。目的是展示将状态更改封装在工具内如何使代码比直接在工具外部操作状态更清晰、更有组织。

请注意，**强烈不鼓励**在检索会话后直接修改 `session.state` 字典，因为它绕过了标准事件处理机制。这种直接更改将不会记录在会话的事件历史中，可能不会由选定的 `SessionService` 持久化，可能导致并发问题，并且不会更新时间戳等基本元数据。更新会话状态的推荐方法是：对 `LlmAgent` 使用 `output_key` 参数（专门用于智能体的最终文本响应），或在通过 `session_service.append_event()` 附加事件时，将状态更改包含在 `EventActions.state_delta` 中。`session.state` 应主要用于读取现有数据。

总结一下，在设计状态时，请保持简单，使用基本数据类型，为您的键赋予清晰的名称并正确使用前缀，避免深层嵌套，并始终使用 `append_event` 过程更新状态。

### 内存（Memory）：使用 MemoryService 的长期知识

在智能体系统中，`Session` 组件维护着当前聊天历史（事件）和特定于单个对话的临时数据（状态）的记录。然而，为了让智能体保留跨多个交互的信息或访问外部数据，长期知识管理是必要的。这由 **MemoryService** 促进。

```python
# Example: Using InMemoryMemoryService
# This is suitable for local development and testing where data
# persistence across application restarts is not required.
# Memory content is lost when the app stops.
from google.adk.memory import InMemoryMemoryService
memory_service = InMemoryMemoryService()

```

`Session` 和 `State` 可以概念化为单个聊天会话的短期内存，而由 `MemoryService` 管理的长期知识则作为持久且可搜索的存储库运行。该存储库可能包含来自多个过去交互或外部来源的信息。`MemoryService`，由 `BaseMemoryService` 接口定义，建立了管理这种可搜索的长期知识的标准。其主要功能包括：

*   **添加信息**，涉及从会话中提取内容并使用 `add_session_to_memory` 方法进行存储。
*   **检索信息**，允许智能体查询存储并使用 `search_memory` 方法接收相关数据。

ADK 提供了几种用于创建此长期知识存储的实现。`InMemoryMemoryService` 提供了一个适用于测试的临时存储解决方案，但数据不会在应用程序重启时保留。对于生产环境，通常使用 `VertexAiRagMemoryService`。此服务利用 Google Cloud 的**检索增强生成（RAG）**服务，实现可扩展、持久和语义搜索功能（另请参阅第 14 章关于 RAG 的内容）。

```python
# Example: Using VertexAiRagMemoryService
# This is suitable for scalable production on GCP, leveraging
# Vertex AI RAG (Retrieval Augmented Generation) for persistent,
# searchable memory.
# Requires: pip install google-adk[vertexai], GCP
# setup/authentication, and a Vertex AI RAG Corpus.
from google.adk.memory import VertexAiRagMemoryService

# The resource name of your Vertex AI RAG Corpus
RAG_CORPUS_RESOURCE_NAME = "projects/your-gcp-project-id/locations/us-central1/ragCorpora/your-corpus-id" # Replace with your Corpus resource name

# Optional configuration for retrieval behavior
SIMILARITY_TOP_K = 5 # Number of top results to retrieve
VECTOR_DISTANCE_THRESHOLD = 0.7 # Threshold for vector similarity

memory_service = VertexAiRagMemoryService(
   rag_corpus=RAG_CORPUS_RESOURCE_NAME,
   similarity_top_k=SIMILARITY_TOP_K,
   vector_distance_threshold=VECTOR_DISTANCE_THRESHOLD
)
# When using this service, methods like add_session_to_memory
# and search_memory will interact with the specified Vertex AI
# RAG Corpus.
```

## 动手实践代码：LangChain 和 LangGraph 中的内存管理

在 LangChain 和 LangGraph 中，**内存**是创建智能且感觉自然的对话应用程序的关键组件。它允许 AI 智能体记住过去互动中的信息、从反馈中学习并适应用户偏好。LangChain 的内存功能通过引用存储的历史记录来丰富当前提示，然后记录最新的交流以供将来使用，从而奠定了基础。随着智能体处理更复杂的任务，此功能对于效率和用户满意度都变得至关重要。

**短期内存：** 这是线程范围的，意味着它跟踪单个会话或线程中正在进行的对话。它提供了即时上下文，但完整的历史记录可能会挑战 LLM 的上下文窗口，可能导致错误或性能不佳。LangGraph 将短期内存作为智能体状态的一部分进行管理，该状态通过检查点程序持久化，允许随时恢复线程。

**长期内存：** 这存储跨会话的用户特定或应用程序级数据，并在对话线程之间共享。它保存在自定义“命名空间”中，可以随时在任何线程中召回。LangGraph 提供存储来保存和召回长期内存，使智能体能够无限期地保留知识。

LangChain 提供了几种用于管理对话历史的工具，范围从手动控制到链中的自动化集成。

### ChatMessageHistory：手动内存管理

对于在正式链之外直接简单地控制对话历史，`ChatMessageHistory` 类是理想的选择。它允许手动跟踪对话交流。

```python
from langchain.memory import ChatMessageHistory

# Initialize the history object
history = ChatMessageHistory()

# Add user and AI messages
history.add_user_message("I'm heading to New York next week.")
history.add_ai_message("Great! It's a fantastic city.")

# Access the list of messages
print(history.messages)
```

### ConversationBufferMemory：链的自动化内存

对于将内存直接集成到链中，`ConversationBufferMemory` 是一个常见的选择。它保留对话的缓冲区，并使其可用于您的提示。它的行为可以通过两个关键参数进行自定义：

*   `memory_key`：一个字符串，指定提示中将保存聊天历史记录的变量名称。它默认为 `"history"`。
*   `return_messages`：一个布尔值，指示历史记录的格式。
    *   如果为 `False`（默认值），它返回一个格式化的字符串，这对于标准 LLM 是理想的。
    *   如果为 `True`，它返回一个消息对象列表，这是聊天模型的推荐格式。

```python
from langchain.memory import ConversationBufferMemory

# Initialize memory
memory = ConversationBufferMemory()

# Save a conversation turn
memory.save_context({"input": "What's the weather like?"}, {"output": "It's sunny today."})

# Load the memory as a string
print(memory.load_memory_variables({}))
```

将此内存集成到 `LLMChain` 中，允许模型访问对话的历史记录并提供上下文相关的响应。

```python
from langchain_openai import OpenAI
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate
from langchain.memory import ConversationBufferMemory

# 1. Define LLM and Prompt
llm = OpenAI(temperature=0)
template = """You are a helpful travel agent.

Previous conversation:
{history}

New question: {question}
Response:"""
prompt = PromptTemplate.from_template(template)

# 2. Configure Memory
# The memory_key "history" matches the variable in the prompt
memory = ConversationBufferMemory(memory_key="history")

# 3. Build the Chain
conversation = LLMChain(llm=llm, prompt=prompt, memory=memory)

# 4. Run the Conversation
response = conversation.predict(question="I want to book a flight.")
print(response)
response = conversation.predict(question="My name is Sam, by the way.")
print(response)
response = conversation.predict(question="What was my name again?")
print(response)
```

为了提高聊天模型的有效性，建议通过设置 `return_messages=True` 来使用结构化的消息对象列表。

```python
from langchain_openai import ChatOpenAI
from langchain.chains import LLMChain
from langchain.memory import ConversationBufferMemory
from langchain_core.prompts import (
   ChatPromptTemplate,
   MessagesPlaceholder,
   SystemMessagePromptTemplate,
   HumanMessagePromptTemplate,
)

# 1. Define Chat Model and Prompt
llm = ChatOpenAI()
prompt = ChatPromptTemplate(
   messages=[
       SystemMessagePromptTemplate.from_template("You are a friendly assistant."),
       MessagesPlaceholder(variable_name="chat_history"),
       HumanMessagePromptTemplate.from_template("{question}")
   ]
)

# 2. Configure Memory
# return_messages=True is essential for chat models
memory = ConversationBufferMemory(memory_key="chat_history", return_messages=True)

# 3. Build the Chain
conversation = LLMChain(llm=llm, prompt=prompt, memory=memory)

# 4. Run the Conversation
response = conversation.predict(question="Hi, I'm Jane.")
print(response)
response = conversation.predict(question="Do you remember my name?")
print(response)
```

### 长期内存类型

长期内存允许系统保留跨不同对话的信息，提供更深层次的上下文和个性化。它可以分解为类似于人类记忆的三种类型：

| 长期内存类型 | 描述 | LangGraph 中的实现 |
| :--- | :--- | :--- |
| **语义记忆**（Semantic Memory） | **记住事实：** 涉及保留特定的事实和概念，例如用户偏好或领域知识。用于**固定（ground）**智能体的响应，实现更个性化和相关的交互。 | 可以作为不断更新的用户“配置文件”或“事实文档集合”进行管理。 |
| **情景记忆**（Episodic Memory） | **记住经验：** 涉及召回过去的事件或行动。对于 AI 智能体，情景记忆通常用于记住如何完成任务。 | 实践中常通过**少样本示例提示（few-shot example prompting）**实现，智能体从过去成功的交互序列中学习以正确执行任务。 |
| **程序记忆**（Procedural Memory） | **记住规则：** 这是执行任务的记忆——智能体的核心指令和行为，通常包含在其系统提示中。智能体通常会修改自己的提示以适应和改进。 | **“反思（Reflection）”**是一种有效的技术，其中智能体被提示其当前指令和最近的交互，然后被要求完善自己的指令。 |

下面是伪代码，演示了智能体如何使用**反思**来更新存储在 LangGraph `BaseStore` 中的程序记忆。

```python
# Node that updates the agent's instructions
def update_instructions(state: State, store: BaseStore):
   namespace = ("instructions",)
   # Get the current instructions from the store
   current_instructions = store.search(namespace)[0]

   # Create a prompt to ask the LLM to reflect on the conversation
   # and generate new, improved instructions
   prompt = prompt_template.format(
       instructions=current_instructions.value["instructions"],
       conversation=state["messages"]
   )

   # Get the new instructions from the LLM
   output = llm.invoke(prompt)
   new_instructions = output['new_instructions']

   # Save the updated instructions back to the store
   store.put(("agent_instructions",), "agent_a", {"instructions": new_instructions})

# Node that uses the instructions to generate a response
def call_model(state: State, store: BaseStore):
   namespace = ("agent_instructions", )
   # Retrieve the latest instructions from the store
   instructions = store.get(namespace, key="agent_a")[0]

   # Use the retrieved instructions to format the prompt
   prompt = prompt_template.format(instructions=instructions.value["instructions"])
   # ... application logic continues
```

LangGraph 将长期内存作为 JSON 文档存储在存储中。每个内存都组织在一个自定义的**命名空间**（如文件夹）和一个独特的**键**（如文件名）下。这种层次结构允许轻松组织和检索信息。以下代码演示了如何使用 `InMemoryStore` 来放置、获取和搜索内存。

```python
from langgraph.store.memory import InMemoryStore

# A placeholder for a real embedding function
def embed(texts: list[str]) -> list[list[float]]:
   # In a real application, use a proper embedding model
   return [[1.0, 2.0] for _ in texts]

# Initialize an in-memory store. For production, use a database-backed store.
store = InMemoryStore(index={"embed": embed, "dims": 2})

# Define a namespace for a specific user and application context
user_id = "my-user"
application_context = "chitchat"
namespace = (user_id, application_context)

# 1. Put a memory into the store
store.put(
   namespace,
   "a-memory",  # The key for this memory
   {
       "rules": [
           "User likes short, direct language",
           "User only speaks English & python",
       ],
       "my-key": "my-value",
   },
)

# 2. Get the memory by its namespace and key
item = store.get(namespace, "a-memory")
print("Retrieved Item:", item)

# 3. Search for memories within the namespace, filtering by content
# and sorting by vector similarity to the query.
items = store.search(
   namespace,
   filter={"my-key": "my-value"},
   query="language preferences"
)
print("Search Results:", items)
```

### Vertex Memory Bank

**Memory Bank** 是 Vertex AI Agent Engine 中的一项托管服务，它为智能体提供持久的长期内存。该服务使用 Gemini 模型异步分析对话历史记录，以提取关键事实和用户偏好。

此信息会持久存储，按定义的作用域（如用户 ID）组织，并智能地更新以巩固新数据并解决矛盾。在开始新会话时，智能体通过完全数据召回或使用嵌入的相似性搜索来检索相关的记忆。此过程允许智能体跨会话保持连续性，并根据召回的信息个性化响应。

智能体的 `runner` 与 `VertexAiMemoryBankService` 交互，该服务首先被初始化。此服务处理在智能体对话期间生成的记忆的自动存储。每个记忆都标记有一个唯一的 `USER_ID` 和 `APP_NAME`，确保将来准确检索。

```python
from google.adk.memory import VertexAiMemoryBankService

agent_engine_id = agent_engine.api_resource.name.split("/")[-1]

memory_service = VertexAiMemoryBankService(
   project="PROJECT_ID",
   location="LOCATION",
   agent_engine_id=agent_engine_id
)

session = await session_service.get_session(
   app_name=app_name,
   user_id="USER_ID",
   session_id=session.id
)
await memory_service.add_session_to_memory(session)
```

Memory Bank 提供与 Google ADK 的无缝集成，提供即时的开箱即用体验。对于其他智能体框架（例如 LangGraph 和 CrewAI）的用户，Memory Bank 也通过直接 API 调用提供支持。感兴趣的读者可以随时查阅演示这些集成的在线代码示例。

## 概要

| 方面 | 短期内存（Contextual Memory/State） | 长期内存（Persistent Memory/Memory Service） |
| :--- | :--- | :--- |
| **是什么？** | 正在处理或最近访问的即时信息。 | 需要跨会话或长时间保留的知识。 |
| **存储位置** | LLM 的上下文窗口或 ADK 的 `session.state` 字典。 | 外部存储，如数据库、知识图谱或向量数据库（例如 Vertex AI RAG Corpus）。 |
| **持久性** | **短暂**的。通常在会话结束时丢失。 | **持久**的。跨会话和应用程序重启保留。 |
| **主要用途** | 维持对话上下文；跟踪多步骤任务的当前进度。 | 个性化体验；学习和改进；事实检索（RAG）。 |
| **检索机制** | 自动作为 LLM 提示的一部分包含在内。 | 语义搜索（通过嵌入）或基于键/ID 的查询。 |
| **ADK 组件** | `Session` 和 `session.state`。 | `MemoryService` (例如 `VertexAiRagMemoryService`)。 |

**图 1：内存管理设计模式**
![图片](/images/translations/agent-design-patterns/p2-08-memory-manager-01.png)

### 关键要点

快速回顾一下内存管理的主要观点：

*   **内存**对于智能体跟踪事物、学习和个性化交互**非常重要**。
*   **对话式 AI** 依赖于**短期内存**（用于单个聊天中的即时上下文）和**长期内存**（用于跨多个会话的持久知识）。
*   **短期内存**（即时内容）是**临时**的，通常受限于 LLM 的上下文窗口或框架传递上下文的方式。
*   **长期内存**（持续存在的内容）使用向量数据库等**外部存储**保存跨不同聊天的信息，并通过**搜索**访问。
*   像 **ADK** 这样的框架具有特定的部分，例如 **Session**（聊天线程）、**State**（临时聊天数据）和 **MemoryService**（可搜索的长期知识）来管理内存。
*   ADK 的 **SessionService** 处理聊天会话的整个生命周期，包括其历史（事件）和临时数据（状态）。
*   ADK 的 `session.state` 是用于临时聊天数据的**字典**。**前缀**（`user:`、`app:`、`temp:`）告诉您数据属于何处以及它是否会持续存在。
*   在 ADK 中，您应该在添加事件时使用 `EventActions.state_delta` 或 `output_key` 来**更新状态**，而不是直接更改状态字典。
*   ADK 的 **MemoryService** 用于将信息放入**长期存储**并让智能体搜索它，通常使用工具。
*   **LangChain** 提供了实用的工具，例如 `ConversationBufferMemory`，可**自动**将单个对话的历史记录注入到提示中，使智能体能够召回即时上下文。
*   **LangGraph** 通过使用**存储**来保存和检索语义事实、情景经验，甚至是可更新的程序规则，从而实现**跨不同用户会话**的高级长期内存。
*   **Memory Bank** 是一种托管服务，通过自动提取、存储和召回用户特定信息，为智能体提供**持久的长期内存**，从而在 Google 的 ADK、LangGraph 和 CrewAI 等框架中实现个性化、连续的对话。

## 结论

本章深入探讨了内存管理对于智能体系统来说真正重要的工作，展示了短寿命上下文和长期持续知识之间的区别。我们讨论了如何设置这些类型的内存，以及在构建可以记住事物的更智能的智能体中，您在哪里可以看到它们被使用。我们详细研究了 Google ADK 如何为您提供特定的部分，例如 **Session**、**State** 和 **MemoryService** 来处理这个问题。既然我们已经介绍了智能体如何记住事物，无论是短期还是长期，我们就可以继续讨论它们如何学习和适应。下一个模式 **“学习和适应”** 是关于智能体如何根据新经验或数据改变其思维、行为或所知的一切。

## 参考文献

ADK Memory, https://google.github.io/adk-docs/sessions/memory/
LangGraph Memory, https://langchain-ai.github.io/langgraph/concepts/memory/
Vertex AI Agent Engine Memory Bank, https://cloud.google.com/blog/products/ai-machine-learning/vertex-ai-memory-bank-in-public-preview
