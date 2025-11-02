# Multi-Agent Fact Checker with Agent2Agent (A2A)

## Project Overview

The A2A Multi-Agent Fact Checker is a sophisticated demonstration of collaborative multi-agent systems built with Google's Agent2Agent SDK (A2A). This project showcases how specialized AI agents can work together under orchestration to verify facts and claims through a combination of external research and internal reasoning.

## What Makes This Special?

✅ **Zero Configuration** - Run with a single Docker command

✅ **Local LLM Inference** - Uses Docker Model Runner (no API keys required)

✅ **Real-time Web Search** - Integrates DuckDuckGo via Model Context Protocol (MCP)

✅ **Orchestrated Workflow** - Demonstrates true agent collaboration

✅ **Modular Architecture** - Each agent has distinct roles and capabilities

## Architecture Overview

The system implements a three-agent architecture where each agent has a clearly defined role:

```
┌─────────────────────────────────────────────────┐
│              User Query                         │
│   "How far is the moon from Earth?"            │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│              AUDITOR AGENT                      │
│  • Coordinates workflow                         │
│  • Plans verification strategy                  │
│  • Delivers final answer                        │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│              CRITIC AGENT                       │
│  • Searches DuckDuckGo via MCP                 │
│  • Gathers evidence                            │
│  • Provides supporting/refuting data           │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│              REVISER AGENT                      │
│  • Analyzes evidence                           │
│  • Refines conclusions                         │
│  • Forms reasoned answer                       │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
┌─────────────────────────────────────────────────┐
│          FINAL VERIFIED ANSWER                  │
└─────────────────────────────────────────────────┘
```

## Agent Roles

### Auditor Agent
**Tools**: None
**Role**: Master Coordinator

The Auditor serves as the orchestrator of the entire fact-checking workflow:
- Receives user queries and plans the verification strategy
- Delegates tasks to Critic and Reviser agents
- Ensures proper workflow execution
- Delivers the final answer to the user

### Critic Agent
**Tools**: DuckDuckGo Search (via MCP)
**Role**: Evidence Gatherer

The Critic is the research specialist:
- Performs web searches using DuckDuckGo
- Gathers evidence to support or refute claims
- Retrieves current information and scientific data
- Provides raw research findings to other agents

### Reviser Agent
**Tools**: None
**Role**: Analysis Specialist

The Reviser focuses on internal reasoning:
- Analyzes evidence gathered by the Critic
- Synthesizes multiple sources of information
- Forms reasoned conclusions without external input
- Refines and finalizes answers

## Prerequisites

Before running the project, ensure you have:

✅ Docker Desktop 4.43.0+ or Docker Engine installed

✅ Docker Offload enabled and started (for GPU support)

✅ Docker Compose 2.38.1+ (if using Docker Engine on Linux)

✅ GPU drivers properly installed for your system

✅ A laptop or workstation with a GPU (e.g., MacBook) for running models locally

## Getting Started

### Step 1: Clone the Repository

```bash
git clone https://github.com/docker/compose-for-agents.git
cd compose-for-agents/a2a
```

### Step 2: Review the Architecture

Examine the `compose.yaml` file to understand the setup:

```yaml
services:
  a2a:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DUCKDUCKGO_MCP_URL=http://mcp-gateway:8811/sse
    depends_on:
      - mcp-gateway
    models:
      - qwen3-small

  mcp-gateway:
    image: docker/mcp-gateway:latest
    use_api_socket: true
    command:
      - --transport=sse
      - --servers=duckduckgo

models:
  qwen3-small:
    model: ai/qwen3:8B-Q4_0
    context_size: 15000
```

### Step 3: Start with Docker Offload

Launch the multi-agent system with cloud GPU support:

```bash
docker compose -f compose.yaml -f compose.offload.yaml up --build
```

This command:
- Downloads the Qwen3-8B model (4.44 GB)
- Sets up the MCP Gateway for web search
- Configures all three agents
- Launches the web interface

### Step 4: Access the Interface

Once containers are running, open your browser:

```
http://localhost:8080/dev-ui/?app=AgentKit
```

### Step 5: View Running Containers

Verify all services are running in Docker Dashboard:

1. Open Docker Desktop
2. Navigate to **Containers**
3. You should see:
   - `a2a` - Main agent orchestrator
   - `mcp-gateway` - MCP server for DuckDuckGo
   - Docker Model Runner (running Qwen3)

## Example Use Cases

### Example 1: Scientific Fact Check

**Input**: "How far is the moon from Earth?"

**Workflow**:

1. **Auditor** receives the question and plans the verification strategy
2. **Critic** searches DuckDuckGo for current scientific data
3. **Reviser** analyzes the gathered evidence and forms a reasoned conclusion
4. **Auditor** presents the final verdict with supporting evidence

**Expected Output**:
```
The Moon's distance from Earth varies due to its elliptical orbit:

- Average distance: 384,400 km (238,855 miles)
- Closest approach (perigee): ~363,300 km (225,623 miles)
- Farthest point (apogee): ~405,500 km (252,088 miles)

This information is based on current astronomical measurements and NASA data.
```

### Example 2: Current Events Check

**Input**: "What is the current status of renewable energy adoption globally?"

**Workflow**:

1. **Auditor** identifies the need for recent data
2. **Critic** searches for latest statistics and reports
3. **Reviser** synthesizes multiple sources into coherent trends
4. **Auditor** provides up-to-date analysis with data backing

**Expected Output**:
```
Global renewable energy adoption shows significant growth:

- Solar and wind capacity increased by 470 GW in 2024
- Renewables now account for 30% of global electricity generation
- Investment in clean energy reached $1.8 trillion in 2024
- China, USA, and EU lead in deployment

Sources: International Energy Agency (IEA), Bloomberg NEF
```

### Example 3: Historical Fact Verification

**Input**: "When was the first iPhone released and what features did it have?"

**Workflow**:

1. **Auditor** determines this requires historical accuracy
2. **Critic** searches for official release information
3. **Reviser** validates and organizes the findings
4. **Auditor** delivers verified historical facts

### Example 4: Health Information Check

**Input**: "What are the proven benefits of vitamin D?"

**Workflow**:

1. **Auditor** recognizes this requires authoritative sources
2. **Critic** searches medical and scientific literature
3. **Reviser** distinguishes between proven and anecdotal benefits
4. **Auditor** presents evidence-based information

## Understanding the Agent Collaboration

### Message Flow

The agents communicate through structured messages:

```python
# User query received
auditor.receive_query("How far is the moon from Earth?")

# Auditor delegates to Critic
auditor.send_to_critic("Search for moon distance data")

# Critic performs search and responds
critic.search_duckduckgo("moon earth distance")
critic.send_results_to_reviser(search_results)

# Reviser analyzes and forms conclusion
reviser.analyze_evidence(search_results)
reviser.send_conclusion_to_auditor(conclusion)

# Auditor delivers final answer
auditor.deliver_final_answer(final_answer)
```

### Why This Architecture Works

1. **Separation of Concerns** - Each agent has a single, well-defined responsibility
2. **Scalability** - Easy to add new agent types (e.g., FactValidator, SourceRanker)
3. **Flexibility** - Can adjust workflow based on query complexity
4. **Transparency** - Clear audit trail of how conclusions were reached

## Customization Options

### Modify Agent Behavior

Edit the agent configuration to change personalities:

```python
AUDITOR_PROMPT = """
You are a thorough fact-checker who values accuracy above all.
Always cite sources and express confidence levels.
"""

CRITIC_PROMPT = """
You are a research specialist who finds the most reliable sources.
Prioritize .edu, .gov, and peer-reviewed sources.
"""

REVISER_PROMPT = """
You are an analytical thinker who synthesizes information critically.
Identify contradictions and assess source reliability.
"""
```

### Add More Search Tools

Extend the Critic agent with additional search capabilities:

```yaml
mcp-gateway:
  command:
    - --servers=duckduckgo,wikipedia,scholarly
```

### Adjust Model Parameters

Modify model context size for longer conversations:

```yaml
models:
  qwen3-small:
    model: ai/qwen3:8B-Q4_0
    context_size: 25000  # Increased from 15000
```

## Performance Considerations

### Model Size vs. Quality Trade-offs

| Model | Size | VRAM | Response Quality | Speed |
|-------|------|------|------------------|-------|
| Qwen3-8B | 4.44 GB | 7 GB | Good | Fast |
| Qwen3-14B | 11.28 GB | 15 GB | Better | Medium |
| Qwen3-30B | 30+ GB | 24+ GB | Best | Slower |

### Tips for Optimal Performance

1. **Start Small** - Use Qwen3-8B for development
2. **Scale Up** - Switch to larger models for production
3. **Monitor VRAM** - Watch GPU memory usage in nvidia-smi
4. **Batch Queries** - Process multiple questions in sequence

## Troubleshooting

### Issue: Agents not responding

**Solution**: Check MCP Gateway connection
```bash
docker logs a2a-mcp-gateway-1
```

### Issue: Search results empty

**Solution**: Verify DuckDuckGo MCP server is running
```bash
docker exec a2a-mcp-gateway-1 ps aux | grep duckduckgo
```

### Issue: Model loading fails

**Solution**: Ensure sufficient GPU memory
```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

### Issue: Slow responses

**Solution**: Reduce context size or use smaller model
```yaml
context_size: 8000  # Reduce from 15000
```

## Key Takeaways

✅ Multi-agent systems enable sophisticated task decomposition

✅ Agent2Agent (A2A) provides a framework for agent orchestration

✅ MCP Gateway securely connects agents to external tools

✅ Docker Offload makes GPU-accelerated agent systems accessible

✅ Clear agent roles lead to better collaboration and results

Next, let's explore a real-world application: the Agno GitHub Issue Analyzer! 🚀