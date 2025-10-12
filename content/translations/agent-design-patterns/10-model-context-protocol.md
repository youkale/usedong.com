---
title: "第十章：模型上下文协议（Model Context Protocol）"
date: 2025-10-12
tags: ["Agent", "AI", "设计模式", "架构"]
summary: "通过标准化协议实现LLM与外部系统、工具和数据源的无缝集成"
original_author: "Antonio Gulli"
book: "智能体设计模式"
chapter: 10
---

[← 上一章：学习与适应](../09-learning-and-adaptation/) | [返回目录](../) | [下一章：目标设定与监控 →](../11-goal-setting-and-monitoring/)

---

# 第十章：模型上下文协议（Model Context Protocol）
为了让大型语言模型（LLM）能有效地充当智能体（agent），它们的能力必须超越多模态生成。它们需要与外部环境进行交互，包括访问最新数据、利用外部软件和执行特定的操作任务。模型上下文协议（Model Context Protocol, MCP）就是为满足这一需求而设计的，它提供了一个标准化的接口，供 LLM 与外部资源对接。该协议是实现一致且可预测集成的关键机制。

## MCP 模式概述

设想有一个通用适配器，允许任何 LLM 连接到任何外部系统、数据库或工具，而无需为每一个都进行定制集成。这本质上就是模型上下文协议（MCP）。它是一个开放标准，旨在规范 Gemini、OpenAI 的 GPT 模型、Mixtral 和 Claude 等 LLM 如何与外部应用、数据源和工具进行通信。可以将其视为一种通用连接机制，简化了 LLM 获取上下文、执行动作和与各种系统交互的方式。

MCP 采用客户端-服务器架构运作。它定义了不同元素——数据（称为“资源”）、交互式模板（本质上是提示）和可操作函数（称为“工具”）——如何由 MCP 服务器暴露，然后由 MCP 客户端（可以是 LLM 主机应用或 AI 智能体本身）消费使用。这种标准化方法极大地降低了将 LLM 集成到各种操作环境中的复杂性。

然而，MCP 是一种“智能体接口”的契约，其有效性在很大程度上取决于它所暴露的底层 API 的设计。存在一种风险，即开发人员只是简单地封装了现有的传统 API 而不做修改，这对于智能体来说可能是次优的。例如，如果一个票务系统的 API 只允许逐一检索完整的票务详情，那么一个被要求汇总高优先级票务的智能体在处理高并发量时就会变得缓慢且不准确。要真正有效，底层 API 应该通过过滤和排序等确定性功能进行改进，以帮助非确定性智能体高效工作。这突出表明，智能体并不能神奇地取代确定性工作流；它们通常需要更强的确定性支持才能成功。

此外，MCP 可以封装一个 API，其输入或输出本身仍不能被智能体理解。一个 API 只有在其数据格式对智能体友好时才有用，而 MCP 本身并不能保证这一点。例如，为一个返回 PDF 文件的文档存储创建 MCP 服务器大多是无用的，因为消费的智能体无法解析 PDF 内容。更好的方法是首先创建一个 API，返回文档的文本版本，例如 Markdown，智能体才能实际阅读和处理。这表明，开发人员不仅要考虑连接，还必须考虑所交换数据的性质，以确保真正的兼容性。

## MCP 与工具函数调用

模型上下文协议（MCP）和工具函数调用是两种不同的机制，它们都允许 LLM 与外部能力（包括工具）交互并执行动作。虽然两者都旨在扩展 LLM 的能力，使其超越文本生成，但它们在方法和抽象级别上有所不同。

工具函数调用可以被视为 LLM 对特定、预定义工具或函数的直接请求。请注意，在此上下文中，我们交替使用“工具”和“函数”这两个词。这种交互的特点是一对一的通信模型，LLM 根据其对用户意图的理解（需要外部动作）来格式化请求。然后，应用程序代码执行此请求并将结果返回给 LLM。这个过程通常是专有的，并且因不同的 LLM 提供商而异。

相比之下，模型上下文协议（MCP）作为一个标准化接口运行，用于 LLM 发现、通信和利用外部能力。它作为一个开放协议发挥作用，促进与各种工具和系统的交互，旨在建立一个生态系统，其中任何符合规定的工具都可以被任何符合规定的 LLM 访问。这促进了跨不同系统的互操作性、可组合性和可重用性。通过采用联邦模型，我们显著改善了互操作性，并通过简单地将现有资产封装在符合 MCP 的接口中，解锁了它们的价值。该策略允许我们将分散的传统服务带入一个现代生态系统。这些服务继续独立运行，但现在可以组合成新的应用和工作流，它们的协作由 LLM 协调。这在不要求对基础系统进行昂贵重写的情况下，培养了敏捷性和可重用性。

以下是 MCP 与工具函数调用的基本区别：

| 特征 | 工具函数调用 | 模型上下文协议（MCP） |
| :--- | :--- | :--- |
| **标准化** | 专有且特定于供应商。格式和实现因 LLM 提供商而异。 | 一个开放的、标准化的协议，促进不同 LLM 和工具之间的互操作性。 |
| **范围** | LLM 请求执行特定、预定义函数的直接机制。 | LLM 与外部工具如何发现和通信的更广泛框架。 |
| **架构** | LLM 与应用程序的工具处理逻辑之间的一对一交互。 | 客户端-服务器架构，LLM 驱动的应用（客户端）可以连接和利用各种 MCP 服务器（工具）。 |
| **发现** | 在特定对话的上下文中，LLM 被明确告知哪些工具可用。 | 启用可用工具的动态发现。MCP 客户端可以查询服务器以查看它提供哪些能力。 |
| **重用性** | 工具集成通常与所使用的特定应用和 LLM 紧密耦合。 | 促进可重用、独立的“MCP 服务器”的开发，任何符合规定的应用都可以访问。 |

可以把工具函数调用想象成给 AI 一套特定的、定制的工具，比如一个特定的扳手和螺丝刀。这对于一个任务固定的车间来说是高效的。而 MCP（模型上下文协议）则像创建了一个通用、标准化的电源插座系统。它本身不提供工具，但它允许任何符合规定的工具（来自任何制造商）插入并工作，从而实现一个动态且不断扩展的车间。

简而言之，函数调用提供了对少数特定函数的直接访问，而 MCP 是标准化的通信框架，允许 LLM 发现和使用范围广泛的外部资源。对于简单的应用，特定工具就足够了；对于需要适应的复杂、互连的 AI 系统，像 MCP 这样的通用标准至关重要。

## MCP 的额外考量

尽管 MCP 提供了一个强大的框架，但要进行彻底评估，需要考虑几个影响其是否适用于特定用例的关键方面。让我们更详细地看看一些方面：

**工具 vs. 资源 vs. 提示**：理解这些组件的具体作用很重要。**资源**是静态数据（例如，PDF 文件、数据库记录）。**工具**是执行动作的可执行函数（例如，发送电子邮件、查询 API）。**提示**是指导 LLM 如何与资源或工具交互的模板，确保交互是结构化和有效的。

**可发现性**：MCP 的一个关键优势是 MCP 客户端可以动态查询服务器以了解它提供哪些工具和资源。这种“即时”发现机制对于需要适应新功能而无需重新部署的智能体来说非常强大。

**安全性**：通过任何协议暴露工具和数据都需要强大的安全措施。MCP 的实现必须包含身份验证和授权，以控制哪些客户端可以访问哪些服务器以及允许它们执行哪些特定动作。

**实现**：虽然 MCP 是一个开放标准，但其实现可能很复杂。不过，供应商已开始简化这一过程。例如，一些模型供应商如 Anthropic 或 FastMCP 提供 SDK，抽象掉了许多样板代码，使开发人员更容易创建和连接 MCP 客户端和服务器。

**错误处理**：全面的错误处理策略至关重要。协议必须定义错误（例如，工具执行失败、服务器不可用、请求无效）如何传达回 LLM，以便它能理解失败并可能尝试替代方法。

**本地 vs. 远程服务器**：MCP 服务器可以部署在与智能体相同的机器上（本地），也可以部署在不同的服务器上（远程）。本地服务器可能因速度和敏感数据的安全性而被选择，而远程服务器架构则允许组织内共享、可扩展地访问通用工具。

**按需 vs. 批处理**：MCP 可以支持按需、交互式会话和更大规模的批处理。选择取决于应用程序，从需要即时工具访问的实时对话智能体到批量处理记录的数据分析管道。

**传输机制**：协议还定义了通信的底层传输层。对于本地交互，它使用基于 STDIO（标准输入/输出）的 JSON-RPC 进行高效的进程间通信。对于远程连接，它利用 Streamable HTTP 和 Server-Sent Events (SSE) 等网络友好协议，以实现持久且高效的客户端-服务器通信。

## MCP 客户端-服务器交互模型

模型上下文协议使用客户端-服务器模型来标准化信息流。理解组件交互是 MCP 高级智能体行为的关键：

*   **大型语言模型（LLM）**：核心智能。它处理用户请求，制定计划，并决定何时需要访问外部信息或执行动作。
*   **MCP 客户端**：这是围绕 LLM 的应用程序或封装器。它充当中介，将 LLM 的意图转换为符合 MCP 标准的正式请求。它负责发现、连接和与 MCP 服务器通信。
*   **MCP 服务器**：这是通往外部世界的门户。它向任何授权的 MCP 客户端暴露一组工具、资源和提示。每个服务器通常负责一个特定的领域，例如连接到公司的内部数据库、电子邮件服务或公共 API。
*   **可选的第三方（3P）服务**：这代表了 MCP 服务器管理和暴露的实际外部工具、应用程序或数据源。它是执行所请求动作的最终端点，例如查询专有数据库、与 SaaS 平台交互或调用公共天气 API。

交互流程如下：

1.  **发现**：MCP 客户端代表 LLM，查询 MCP 服务器以询问它提供哪些能力。服务器回复一个清单，列出其可用的**工具**（例如，`send_email`）、**资源**（例如，`customer_database`）和**提示**。
2.  **请求制定**：LLM 确定它需要使用其中一个被发现的工具。例如，它决定发送一封电子邮件。它制定一个请求，指定要使用的工具 (`send_email`) 和必要的参数（收件人、主题、正文）。
3.  **客户端通信**：MCP 客户端接收 LLM 拟定的请求，并将其作为标准化调用发送到相应的 MCP 服务器。
4.  **服务器执行**：MCP 服务器接收请求。它验证客户端身份，验证请求，然后通过与底层软件对接来执行指定的动作（例如，调用电子邮件 API 的 `send()` 函数）。
5.  **响应和上下文更新**：执行完成后，MCP 服务器将标准化响应发送回 MCP 客户端。此响应指示动作是否成功，并包含任何相关输出（例如，已发送电子邮件的确认 ID）。然后，客户端将此结果传递回 LLM，更新其上下文，使其能够进行任务的下一步。

![图片](/images/translations/agent-design-patterns/p2-10-mcp.png)

*图 1：模型上下文协议*

## 实际应用与用例

MCP 显著拓宽了 AI/LLM 的能力，使其更加通用和强大。以下是九个关键用例：

1.  **数据库集成**：MCP 允许 LLM 和智能体无缝访问和交互数据库中的结构化数据。例如，使用适用于数据库的 MCP 工具箱，智能体可以查询 Google BigQuery 数据集来检索实时信息、生成报告或更新记录，所有这些都由自然语言命令驱动。
2.  **生成式媒体编排**：MCP 使智能体能够与高级生成式媒体服务集成。通过适用于生成式媒体服务的 MCP 工具，智能体可以编排涉及 Google 的 Imagen（图像生成）、Google 的 Veo（视频创建）、Google 的 Chirp 3 HD（逼真语音）或 Google 的 Lyria（音乐创作）的工作流，从而在 AI 应用中实现动态内容创建。
3.  **外部 API 交互**：MCP 为 LLM 调用和接收来自任何外部 API 的响应提供了一种标准化的方式。这意味着智能体可以获取实时天气数据、拉取股票价格、发送电子邮件或与 CRM 系统交互，将其能力扩展到其核心语言模型之外。
4.  **基于推理的信息提取**：利用 LLM 强大的推理技能，MCP 促进了有效、依赖查询的信息提取，超越了传统的搜索和检索系统。智能体可以分析文本并提取直接回答用户复杂问题的精确条款、图表或陈述，而不是传统搜索工具返回整个文档。
5.  **自定义工具开发**：开发人员可以构建自定义工具，并通过 MCP 服务器暴露它们（例如，使用 FastMCP）。这允许将专业的内部函数或专有系统以标准化、易于消费的格式提供给 LLM 和其他智能体，而无需直接修改 LLM。
6.  **标准化 LLM-应用通信**：MCP 确保了 LLM 与其交互的应用程序之间有一致的通信层。这减少了集成开销，促进了不同 LLM 提供商和主机应用程序之间的互操作性，并简化了复杂智能体系统的开发。
7.  **复杂工作流编排**：通过结合各种 MCP 暴露的工具和数据源，智能体可以编排高度复杂的、多步骤的工作流。例如，一个智能体可以通过与不同的 MCP 服务交互，从数据库中检索客户数据、生成个性化营销图片、起草定制电子邮件，然后发送出去。
8.  **物联网设备控制**：MCP 可以促进 LLM 与物联网（IoT）设备的交互。智能体可以使用 MCP 向智能家居设备、工业传感器或机器人发送命令，实现物理系统的自然语言控制和自动化。
9.  **金融服务自动化**：在金融服务中，MCP 可以使 LLM 与各种金融数据源、交易平台或合规系统交互。智能体可以分析市场数据、执行交易、生成个性化财务建议或自动化监管报告，所有这些都保持安全和标准化的通信。

简而言之，模型上下文协议（MCP）使智能体能够访问来自数据库、API 和网络资源的实时信息。它还允许智能体通过集成和处理来自各种来源的数据，执行发送电子邮件、更新记录、控制设备和执行复杂任务等动作。此外，MCP 支持 AI 应用程序的媒体生成工具。

## ADK 动手代码示例

本节概述了如何连接到提供文件系统操作的本地 MCP 服务器，从而使 ADK 智能体能够与本地文件系统交互。

### 使用 MCPToolset 设置智能体

为了配置智能体进行文件系统交互，必须创建一个 `agent.py` 文件（例如，在 `./adk_agent_samples/mcp_agent/agent.py`）。`MCPToolset` 在 `LlmAgent` 对象的 `tools` 列表中被实例化。至关重要的是，必须将 `args` 列表中的 `"/path/to/your/folder"` 替换为 MCP 服务器可以访问的本地系统上某个目录的绝对路径。该目录将是智能体执行文件系统操作的根目录。

```python
import os
from google.adk.agents import LlmAgent
from google.adk.tools.mcp_tool.mcp_toolset import MCPToolset, StdioServerParameters

# 创建一个可靠的绝对路径，指向与此智能体脚本位于同一目录中的
# 名为 'mcp_managed_files' 的文件夹。
# 这确保了智能体可以在演示时开箱即用。
# 对于生产环境，您应该将其指向一个更持久和安全的位置。
TARGET_FOLDER_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "mcp_managed_files")

# 确保目标目录在智能体需要它之前存在。
os.makedirs(TARGET_FOLDER_PATH, exist_ok=True)

root_agent = LlmAgent(
   model='gemini-2.0-flash',
   name='filesystem_assistant_agent',
   instruction=(
       'Help the user manage their files. You can list files, read files, and write files. '
       f'You are operating in the following directory: {TARGET_FOLDER_PATH}'
   ),
   tools=[
       MCPToolset(
           connection_params=StdioServerParameters(
               command='npx',
               args=[
                   "-y",  # Argument for npx to auto-confirm install
                   "@modelcontextprotocol/server-filesystem",
                   # This MUST be an absolute path to a folder.
                   TARGET_FOLDER_PATH,
               ],
           ),
           # Optional: You can filter which tools from the MCP server are exposed.
           # For example, to only allow reading:
           # tool_filter=['list_directory', 'read_file']
       )
   ],
)
```

`npx`（Node Package Execute）与 npm（Node Package Manager）版本 5.2.0 及更高版本捆绑在一起，是一个命令行工具，能够直接执行 npm 注册表中的 Node.js 包。这消除了全局安装的需要。本质上，`npx` 充当 npm 包运行器，它常用于运行许多社区 MCP 服务器，这些服务器以 Node.js 包的形式分发。

创建 `__init__.py` 文件是必要的，以确保 `agent.py` 文件被识别为 Agent Development Kit (ADK) 可发现 Python 包的一部分。该文件应与 `agent.py` 位于同一目录中。

```python
# ./adk_agent_samples/mcp_agent/__init__.py
from . import agent
```

当然，还有其他支持的命令可供使用。例如，连接到 `python3` 可以按如下方式实现：

```python
connection_params = StdioConnectionParams(
 server_params={
     "command": "python3",
     "args": ["./agent/mcp_server.py"],
     "env": {
       "SERVICE_ACCOUNT_PATH":SERVICE_ACCOUNT_PATH,
       "DRIVE_FOLDER_ID": DRIVE_FOLDER_ID
     }
 }
)
```

在 Python 的上下文中，UVX 是一个命令行工具，它利用 `uv` 在临时、隔离的 Python 环境中执行命令。本质上，它允许您运行 Python 工具和包，而无需将它们全局安装或安装在您项目的环境中。您可以通过 MCP 服务器运行它。

```python
connection_params = StdioConnectionParams(
 server_params={
   "command": "uvx",
   "args": ["mcp-google-sheets@latest"],
   "env": {
     "SERVICE_ACCOUNT_PATH":SERVICE_ACCOUNT_PATH,
     "DRIVE_FOLDER_ID": DRIVE_FOLDER_ID
   }
 }
)
```

一旦 MCP 服务器创建完成，下一步是连接到它。

### 使用 ADK Web 连接 MCP 服务器

首先，执行 `adk web`。在您的终端中导航到 `mcp_agent` 的父目录（例如，`adk_agent_samples`）并运行：

```bash
cd ./adk_agent_samples # Or your equivalent parent directory
adk web
```

一旦 ADK Web UI 在您的浏览器中加载，从智能体菜单中选择 `filesystem_assistant_agent`。接下来，尝试使用如下提示：

*   "Show me the contents of this folder."（显示此文件夹的内容。）
*   "Read the `sample.txt` file."（读取 `sample.txt` 文件。）（假设 `sample.txt` 位于 `TARGET_FOLDER_PATH`。）
*   "What's in `another_file.md`?"（`another_file.md` 里有什么？）

## 使用 FastMCP 创建 MCP 服务器

FastMCP 是一个高级 Python 框架，旨在简化 MCP 服务器的开发。它提供了一个抽象层，简化了协议的复杂性，允许开发人员专注于核心逻辑。

该库支持使用简单的 Python 装饰器快速定义工具、资源和提示。一个显著的优势是它的自动模式生成，它能智能地解释 Python 函数签名、类型提示和文档字符串，以构建必要的 AI 模型接口规范。这种自动化最大限度地减少了手动配置并减少了人为错误。

除了基本的工具创建之外，FastMCP 还促进了服务器组合和代理等高级架构模式。这使得复杂、多组件系统的模块化开发成为可能，并将现有服务无缝集成到 AI 可访问的框架中。此外，FastMCP 包括针对高效、分布式和可扩展的 AI 驱动应用程序的优化。

### 使用 FastMCP 设置服务器

为了说明，考虑服务器提供的基本“问候”工具。一旦它激活，ADK 智能体和其他 MCP 客户端就可以使用 HTTP 与此工具交互。

```python
# fastmcp_server.py
# This script demonstrates how to create a simple MCP server using FastMCP.
# It exposes a single tool that generates a greeting.

# 1. Make sure you have FastMCP installed:
# pip install fastmcp
from fastmcp import FastMCP, Client

# Initialize the FastMCP server.
mcp_server = FastMCP()

# Define a simple tool function.
# The `@mcp_server.tool` decorator registers this Python function as an MCP tool.
# The docstring becomes the tool's description for the LLM.
@mcp_server.tool
def greet(name: str) -> str:
    """
    Generates a personalized greeting.

    Args:
        name: The name of the person to greet.

    Returns:
        A greeting string.
    """
    return f"Hello, {name}! Nice to meet you."

# Or if you want to run it from the script:
if __name__ == "__main__":
    mcp_server.run(
        transport="http",
        host="127.0.0.1",
        port=8000
    )
```

这个 Python 脚本定义了一个名为 `greet` 的函数，它接受一个人的名字并返回一个个性化的问候。函数上方的 `@tool()` 装饰器自动将其注册为一个 AI 或其他程序可以使用的工具。FastMCP 利用该函数的文档字符串和类型提示来告知智能体该工具的工作原理、所需的输入和它将返回的内容。

当脚本执行时，它会启动 FastMCP 服务器，该服务器在 `localhost:8000` 监听请求。这使得 `greet` 函数作为网络服务可用。然后可以配置一个智能体连接到此服务器，并使用 `greet` 工具作为更大任务的一部分来生成问候。服务器持续运行，直到被手动停止。

### 使用 ADK 智能体消费 FastMCP 服务器

ADK 智能体可以设置为 MCP 客户端，以使用正在运行的 FastMCP 服务器。这需要使用 FastMCP 服务器的网络地址（通常是 `http://localhost:8000`）配置 `HttpServerParameters`。

可以包含一个 `tool_filter` 参数来限制智能体的工具使用，使其仅限于服务器提供的特定工具，例如 `'greet'`。当被要求“Greet John Doe”（问候 John Doe）之类的请求提示时，智能体的嵌入式 LLM 会识别通过 MCP 可用的 `'greet'` 工具，使用参数“John Doe”调用它，并返回服务器的响应。这个过程演示了通过 MCP 暴露的用户定义工具与 ADK 智能体的集成。

为了建立此配置，需要一个智能体文件（例如，位于 `./adk_agent_samples/fastmcp_client_agent/` 的 `agent.py`）。该文件将实例化一个 ADK 智能体，并使用 `HttpServerParameters` 来建立与运行中的 FastMCP 服务器的连接。

```python
# ./adk_agent_samples/fastmcp_client_agent/agent.py
import os
from google.adk.agents import LlmAgent
from google.adk.tools.mcp_tool.mcp_toolset import MCPToolset, HttpServerParameters

# Define the FastMCP server's address.
# Make sure your fastmcp_server.py (defined previously) is running on this port.
FASTMCP_SERVER_URL = "http://localhost:8000"

root_agent = LlmAgent(
   model='gemini-2.0-flash', # Or your preferred model
   name='fastmcp_greeter_agent',
   instruction='You are a friendly assistant that can greet people by their name. Use the "greet" tool.',
   tools=[
       MCPToolset(
           connection_params=HttpServerParameters(
               url=FASTMCP_SERVER_URL,
           ),
           # Optional: Filter which tools from the MCP server are exposed
           # For this example, we're expecting only 'greet'
           tool_filter=['greet']
       )
   ],
)
```

该脚本定义了一个名为 `fastmcp_greeter_agent` 的智能体，它使用 Gemini 语言模型。它被赋予特定的指令，充当一个友好的助手，其目的是问候人们。关键在于，代码为这个智能体配备了执行任务所需的工具。它配置了一个 `MCPToolset` 来连接到在 `localhost:8000` 上运行的独立服务器，该服务器预期是上一个示例中的 FastMCP 服务器。智能体被明确授予访问该服务器上托管的 `greet` 工具的权限。本质上，这段代码设置了系统的客户端部分，创建了一个智能的智能体，它了解自己的目标是问候人们，并且确切地知道使用哪个外部工具来完成它。

在 `fastmcp_client_agent` 目录中创建一个 `__init__.py` 文件是必要的。这确保了智能体被识别为 ADK 可发现的 Python 包。

首先，打开一个新终端并运行 `python fastmcp_server.py` 来启动 FastMCP 服务器。接下来，在您的终端中进入 `fastmcp_client_agent` 的父目录（例如，`adk_agent_samples`），并执行 `adk web`。一旦 ADK Web UI 在您的浏览器中加载，从智能体菜单中选择 `fastmcp_greeter_agent`。然后，您可以通过输入诸如“Greet John Doe”（问候 John Doe）的提示来测试它。智能体将使用您的 FastMCP 服务器上的 `greet` 工具来创建响应。

## 概要速览（At a Glance）

### 是什么 (What)

要充当有效的智能体，LLM 必须超越简单的文本生成。它们需要具备与外部环境交互的能力，以访问最新数据和利用外部软件。如果没有标准化的通信方法，LLM 与外部工具或数据源之间的每一次集成都会成为一个定制的、复杂的且不可重用的工作。这种**临时**方法阻碍了可扩展性，使得构建复杂、互连的 AI 系统变得困难且低效。

---

### 为什么 (Why)

模型上下文协议（MCP）通过充当 LLM 和外部系统之间的通用接口，提供了一个标准化的解决方案。它建立了一个开放、标准化的协议，定义了外部能力如何被发现和使用。MCP 采用客户端-服务器模型，允许服务器向任何符合规定的客户端暴露工具、数据资源和交互式提示。LLM 驱动的应用程序充当这些客户端，以可预测的方式动态发现和与可用资源交互。这种标准化方法培养了一个可互操作和可重用组件的生态系统，极大地简化了复杂智能体工作流的开发。

---

### 经验法则 (Rule of thumb)

当构建需要与多样化且不断演变的外部工具、数据源和 API 交互的**复杂、可扩展或企业级智能体系统**时，请使用模型上下文协议（MCP）。当不同 LLM 和工具之间的互操作性是优先事项时，以及当智能体需要具备动态发现新能力而无需重新部署的能力时，它是理想的选择。对于具有固定且有限数量预定义函数的简单应用程序，直接的工具函数调用可能就足够了。

---

## 关键要点

以下是关键要点：

*   **模型上下文协议（MCP）**是一个开放标准，促进 LLM 与外部应用、数据源和工具之间的标准化通信。
*   它采用**客户端-服务器架构**，定义了暴露和消费资源、提示和工具的方法。
*   **Agent Development Kit (ADK)** 支持利用现有 MCP 服务器以及通过 MCP 服务器暴露 ADK 工具。
*   **FastMCP** 简化了 MCP 服务器的开发和管理，特别是对于暴露用 Python 实现的工具。
*   **适用于生成式媒体服务的 MCP 工具**允许智能体与 Google Cloud 的生成式媒体能力（Imagen、Veo、Chirp 3 HD、Lyria）集成。
*   MCP 使 LLM 和智能体能够与真实世界系统交互、访问动态信息并执行超越文本生成的动作。

## 结论

模型上下文协议（MCP）是一个开放标准，促进大型语言模型（LLM）与外部系统之间的通信。它采用客户端-服务器架构，使 LLM 能够通过标准化工具访问资源、利用提示和执行动作。MCP 允许 LLM 与数据库交互、管理生成式媒体工作流、控制物联网设备以及自动化金融服务。实际示例演示了设置智能体与 MCP 服务器（包括文件系统服务器和使用 FastMCP 构建的服务器）通信，展示了它与 Agent Development Kit (ADK) 的集成。MCP 是开发超越基本语言能力、具备交互能力的 AI 智能体的关键组成部分。

## 参考文献

*   模型上下文协议（MCP）文档。(最新)。Model Context Protocol (MCP)。`https://google.github.io/adk-docs/mcp/`
*   FastMCP 文档。FastMCP。`https://github.com/jlowin/fastmcp`
*   适用于生成式媒体服务的 MCP 工具。MCP Tools for Genmedia Services。`https://google.github.io/adk-docs/mcp/#mcp-servers-for-google-cloud-genmedia`
*   适用于数据库的 MCP 工具箱文档。(最新)。MCP Toolbox for Databases。`https://google.github.io/adk-docs/mcp/databases/`
