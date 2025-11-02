# Real-World Application: Agno GitHub Issue Analyzer

## Project Overview

The Agno GitHub Issue Analyzer represents the perfect introduction to collaborative multi-agent systems, demonstrating how specialized AI agents can work together to solve real-world problems. This project showcases a practical implementation where multiple agents coordinate to analyze GitHub repositories, retrieve open issues, and generate comprehensive reports—all through a single, intuitive interface.

## The Problem It Solves

Development teams face a common challenge: understanding the landscape of open issues across GitHub repositories. Manually browsing through dozens or hundreds of issues is time-consuming and error-prone. The Agno system automates this process by:

- Fetching all open issues from any GitHub repository
- Analyzing and categorizing issues automatically
- Identifying trends and patterns
- Generating professional markdown reports
- Providing actionable insights

## What Makes This Demo Special

✅ **Zero Complex Configuration** - Just add your GitHub token and run with a single command

✅ **Local Inference** - Uses Docker Model Runner with Qwen3 model, requiring no external API dependencies

✅ **Real-World Utility** - Provides immediate value for development teams and project managers

✅ **Multi-Agent Coordination** - Demonstrates proper agent orchestration using the Agno framework

## Architecture Overview

The system implements a sophisticated three-agent architecture:

```
┌──────────────────────────────────────────────────┐
│              User Request                        │
│   "Analyze issues in facebook/react"            │
└────────────────┬─────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────┐
│          COORDINATOR AGENT                       │
│  • Parses user queries                          │
│  • Orchestrates workflow                        │
│  • Handles error scenarios                      │
│  • Delivers final report                        │
└────────────────┬─────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────┐
│      GITHUB ISSUE RETRIEVER AGENT               │
│  • Authenticates with GitHub via MCP            │
│  • Fetches open issues with metadata           │
│  • Handles pagination                           │
│  • Filters and normalizes data                  │
└────────────────┬─────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────┐
│            WRITER AGENT                          │
│  • Categorizes issues                           │
│  • Assesses priority                            │
│  • Identifies trends                            │
│  • Generates markdown report                    │
└────────────────┬─────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────┐
│       COMPREHENSIVE MARKDOWN REPORT              │
│  • Issue categories and summaries               │
│  • Priority assessment                          │
│  • Trend analysis                               │
│  • Actionable recommendations                   │
└──────────────────────────────────────────────────┘
```

## Agent Team Structure

### Coordinator Agent - The Team Orchestrator

**Role**: Master Workflow Manager

**Responsibilities**:
- Parse user queries to understand repository targets and analysis requirements
- Orchestrate workflow between GitHub Issue Retriever and Writer agents
- Handle error scenarios and retry logic when agents encounter issues
- Provide status updates and coordinate the final report delivery

**Key Capabilities**:
```python
# Example coordination logic
def handle_query(user_input):
    # Parse repository from query
    repo_info = extract_repository(user_input)
    
    # Delegate to GitHub retriever
    issues = github_retriever.fetch_issues(repo_info)
    
    # Send to writer for analysis
    report = writer.analyze_and_report(issues)
    
    # Deliver final result
    return format_final_report(report)
```

### GitHub Issue Retriever - The Data Collector

**Role**: GitHub API Specialist

**Key Capabilities**:
- Authenticate with GitHub using secure MCP Server integration
- Retrieve all open issues with complete metadata (labels, assignees, creation dates, etc.)
- Handle large repositories with thousands of issues through intelligent pagination
- Filter and sort issues based on various criteria (priority, age, labels)
- Extract relevant context including issue descriptions, comments, and linked pull requests

**Data Retrieved**:
```python
issue_data = {
    'number': 12345,
    'title': 'Feature request: Add dark mode',
    'state': 'open',
    'labels': ['enhancement', 'ui', 'good first issue'],
    'created_at': '2025-01-15T10:30:00Z',
    'updated_at': '2025-01-20T14:45:00Z',
    'author': 'username',
    'comments': 12,
    'body': 'Detailed description...',
    'assignees': ['dev1', 'dev2']
}
```

**MCP Gateway Integration**:

The agent connects to GitHub through a secure MCP Gateway that:
- Manages authentication tokens securely using Docker secrets
- Transforms GitHub JSON responses into CSV format for efficient AI processing
- Provides real-time communication via Server-Sent Events (SSE)
- Handles rate limiting and error recovery

### Writer Agent - The Content Analyst

**Role**: Intelligence and Reporting Specialist

**Analysis Capabilities**:

1. **Smart Categorization**: Automatically classifies issues into categories:
   - 🐛 Bugs
   - ✨ Feature Requests
   - 📚 Documentation
   - 🔧 Enhancements
   - ❓ Questions
   - 🔒 Security

2. **Priority Assessment**: Evaluates issue urgency based on:
   - Labels (critical, high-priority, urgent)
   - Activity level (comments, recent updates)
   - Age (stale vs. fresh issues)
   - Community engagement

3. **Trend Analysis**: Identifies patterns:
   - Common problem areas
   - Emerging themes
   - User pain points
   - Feature demand signals

4. **Summary Generation**: Creates concise, readable summaries that capture the essence of complex technical issues

5. **Markdown Formatting**: Produces professionally formatted reports with:
   - Proper linking to GitHub issues
   - Tables and statistics
   - Code blocks where relevant
   - Clear hierarchical structure

## Technical Implementation

### Docker Compose Orchestration

The system uses a multi-service Docker Compose architecture:

```yaml
services:
  agents:
    image: demo/agents
    build:
      context: agent
    ports:
      - "7777:7777"
    environment:
      # Point agents at the MCP gateway
      - MCPGATEWAY_URL=http://mcp-gateway:8811/sse
    volumes:
      # Mount the agents configuration
      - ./agents.yaml:/agents.yaml
    models:
      qwen3-small:
        endpoint_var: MODEL_RUNNER_URL
        model_var: MODEL_RUNNER_MODEL

  agents-ui:
    image: demo/ui
    build:
      context: agent-ui
    ports:
      - "3000:3000"
    environment:
      - AGENTS_URL=http://localhost:7777
    depends_on:
      - agents

  mcp-gateway:
    image: docker/mcp-gateway:latest
    use_api_socket: true
    command:
      - --transport=sse
      - --secrets=/run/secrets/mcp_secret
      - --servers=github-official
      # Data interceptor: Convert JSON to CSV
      - --interceptor
      - after:exec:cat | jq '.content[0].text = (.content[0].text | fromjson | map(select(. != null) | [(.number // ""), (.state // ""), (.title // ""), (.user.login // ""), ((.labels // []) | map(.name) | join(";")), (.created_at // "")] | @csv) | join("\n"))'
    secrets:
      - mcp_secret

models:
  qwen3-small:
    model: ai/qwen3:8B-Q4_0  # 4.44 GB
    context_size: 15000  # 7 GB VRAM

secrets:
  mcp_secret:
    file: ./.mcp.env
```

### Key Components Explained

#### 1. Agents Service
- Runs the core Agno framework on port 7777
- Hosts Coordinator, GitHub Retriever, and Writer agents
- Connects to MCP Gateway for GitHub API access
- Uses Docker Model Runner for local LLM inference

#### 2. Agents UI Service
- Provides Next.js web interface on port 3000
- Offers chat-style interface for user interaction
- Communicates with agent runtime through HTTP

#### 3. MCP Gateway Service
- Acts as secure intermediary between agents and GitHub API
- Uses Docker secrets for token management
- Includes data interceptor for JSON-to-CSV transformation
- Enables real-time communication via SSE
- Can dynamically spin up MCP server containers

#### 4. Models Configuration
- Defines Qwen3 model variants
- Qwen3-8B: 4.44 GB, 7 GB VRAM (development)
- Qwen3-14B: 11.28 GB, 15 GB VRAM (production)
- Qwen3-30B: Available via Docker Offload (compose.offload.yaml)

## Getting Started

### Prerequisites

✅ Docker Desktop 4.43.0+ or Docker Engine

✅ Docker Compose 2.38.1+

✅ GitHub Personal Access Token

✅ Docker Offload enabled (for cloud GPU acceleration)

### Step 1: Get the Code

Download the compose-for-agents zip file provided by the Docker Team (check the Docker Community Slack).

```bash
unzip compose-for-agents.zip
cd compose-for-agents/agno/
```

### Step 2: Configure MCP Secrets

Create your MCP environment file:

```bash
cp .mcp.env.example .mcp.env
```

Edit `.mcp.env` and add your GitHub token:

```bash
github.personal_access_token=ghp_your_token_here
```

**How to create a GitHub token**:
1. Go to GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)
2. Click "Generate new token (classic)"
3. Give it a descriptive name: "Docker Agno Analyzer"
4. Select scopes: `repo` (for private repos) or `public_repo` (for public repos only)
5. Click "Generate token"
6. Copy the token immediately (it won't be shown again)

### Step 3: Start the Services

#### Using Docker Offload (Recommended)

For cloud GPU acceleration:

```bash
docker compose -f compose.yaml -f compose.offload.yaml up --build
```

This command:
- Downloads the 4.44 GB Qwen3-8B model
- Requires approximately 7 GB VRAM for inference
- Operates entirely offline after initial setup
- Provides consistent performance without API rate limits

#### Using Local Resources

If you have sufficient local GPU:

```bash
docker compose up --build
```

### Step 4: Access the Interface

Once all services are running, open your browser:

```
http://localhost:3000
```

You'll see a chat-style interface where you can interact with the multi-agent system.

### Step 5: Verify Services

Check that all containers are running:

```bash
docker ps
```

Expected containers:
- `agno-agents-1` - Agent runtime
- `agno-agents-ui-1` - Web interface
- `agno-mcp-gateway-1` - MCP Gateway

**Note**: Docker Model Runner runs in a Docker container but is not visible via `docker ps`.

## Using the Analyzer

### Example Prompts

#### 1. Basic Repository Analysis

```
Analyze issues in microsoft/vscode
```

**What happens**:
1. Coordinator parses the repository name
2. GitHub Retriever fetches all open issues
3. Writer categorizes and analyzes issues
4. System generates comprehensive report

**Sample Output**:
```markdown
# GitHub Issue Analysis: microsoft/vscode

## Summary
- Total open issues: 5,247
- Recent activity: 128 issues updated in last 7 days
- Categories: Bugs (45%), Feature Requests (35%), Documentation (20%)

## High Priority Issues

### 🐛 Critical Bugs
1. [#12345] Editor crashes on large files
   - Created: 2025-01-15
   - Comments: 45
   - Labels: bug, critical, editor
   
### ✨ Top Feature Requests
1. [#12346] Add native Markdown preview
   - Created: 2025-01-10
   - Comments: 123
   - Labels: feature-request, markdown

## Trends
- Increasing requests for AI-assisted coding features
- Performance issues with large workspaces
- Growing demand for better extension API
```

#### 2. Specific Repository Focus

```
summarize the issues in the repo facebook/react
```

#### 3. Category-Specific Analysis

```
categorize the problems in tensorflow/tensorflow
```

#### 4. Comparative Analysis

```
compare issues between vue/core and angular/angular
```

### Understanding the Agent Workflow

Watch the agents collaborate in real-time:

1. **Coordinator** receives your query
   ```
   Coordinator: "Understood. Analyzing facebook/react repository..."
   ```

2. **GitHub Retriever** fetches issues
   ```
   GitHub Retriever: "Fetching open issues from facebook/react..."
   GitHub Retriever: "Retrieved 1,247 open issues"
   ```

3. **Writer** analyzes and generates report
   ```
   Writer: "Categorizing issues..."
   Writer: "Identifying trends and patterns..."
   Writer: "Generating markdown report..."
   ```

4. **Coordinator** delivers final report
   ```
   Coordinator: "Analysis complete! Here's your report:"
   [Full markdown report displayed]
   ```

## Advanced Features

### Custom Issue Filters

Modify the GitHub Retriever to filter issues:

```python
# Filter by labels
issues = retriever.fetch_issues(
    repo="facebook/react",
    labels=["bug", "high-priority"]
)

# Filter by date range
issues = retriever.fetch_issues(
    repo="facebook/react",
    since="2025-01-01"
)

# Filter by state
issues = retriever.fetch_issues(
    repo="facebook/react",
    state="closed"  # Analyze resolved issues
)
```

### Enhanced Analysis

Extend the Writer agent for deeper insights:

```python
# Sentiment analysis
writer.analyze_sentiment(issues)

# Time series analysis
writer.analyze_issue_trends(issues, period="monthly")

# Contributor analysis
writer.analyze_contributors(issues)

# Issue velocity metrics
writer.calculate_velocity(issues)
```

### Export Options

Save reports in different formats:

```python
# Export as JSON
writer.export_report(format="json", filename="report.json")

# Export as PDF
writer.export_report(format="pdf", filename="report.pdf")

# Export as Excel
writer.export_report(format="xlsx", filename="report.xlsx")
```

## Performance Optimization

### Model Selection Guide

| Repository Size | Issues | Recommended Model | VRAM |
|----------------|--------|-------------------|------|
| Small (<100) | <100 | Qwen3-8B | 7 GB |
| Medium (100-1K) | 100-1K | Qwen3-14B | 15 GB |
| Large (1K-10K) | 1K-10K | Qwen3-30B | 24 GB |
| Huge (10K+) | 10K+ | Use batching | - |

### Batching Large Repositories

For repositories with thousands of issues:

```python
# Process in batches
batch_size = 100
for i in range(0, len(issues), batch_size):
    batch = issues[i:i+batch_size]
    partial_report = writer.analyze_batch(batch)
    reports.append(partial_report)

# Merge reports
final_report = writer.merge_reports(reports)
```

### Caching Strategy

Implement caching to avoid redundant API calls:

```python
# Cache issue data
cache_key = f"github:issues:{owner}:{repo}"
cached_data = cache.get(cache_key)

if cached_data and not stale(cached_data):
    issues = cached_data
else:
    issues = retriever.fetch_issues(repo)
    cache.set(cache_key, issues, ttl=3600)  # 1 hour
```

## Troubleshooting

### Issue: GitHub authentication failed

**Error**: "401 Unauthorized"

**Solution**:
1. Verify your token in `.mcp.env`
2. Ensure token has correct scopes (`repo` or `public_repo`)
3. Check if token is expired
4. Restart MCP Gateway: `docker compose restart mcp-gateway`

### Issue: Rate limiting

**Error**: "403 Rate limit exceeded"

**Solution**:
- Authenticated requests have 5,000 requests/hour limit
- Use issue caching to reduce API calls
- Wait for rate limit to reset (check `X-RateLimit-Reset` header)
- Consider using GitHub Enterprise for higher limits

### Issue: Model out of memory

**Error**: "CUDA out of memory"

**Solution**:
1. Reduce context size in `compose.yaml`:
   ```yaml
   context_size: 8000  # Reduce from 15000
   ```
2. Use smaller model (Qwen3-8B instead of 14B)
3. Enable Docker Offload for cloud GPU
4. Process issues in smaller batches

### Issue: Slow analysis

**Solution**:
- Use Docker Offload for faster GPU inference
- Reduce number of issues analyzed at once
- Increase model temperature for faster (less precise) generation
- Disable trend analysis for quick summaries

### Issue: Incomplete report

**Solution**:
- Increase model context size
- Check agent logs: `docker logs agno-agents-1`
- Verify all agents are running properly
- Ensure GitHub API returned complete data

## Production Deployment

### Environment Variables

```bash
# .env file
GITHUB_TOKEN=your_token_here
MODEL_SIZE=14B  # 8B, 14B, or 30B
CONTEXT_SIZE=15000
LOG_LEVEL=INFO
CACHE_ENABLED=true
CACHE_TTL=3600
```

### Security Best Practices

1. **Never commit tokens**: Add `.mcp.env` to `.gitignore`
2. **Use secrets management**: Docker secrets or HashiCorp Vault
3. **Rotate tokens regularly**: Every 90 days
4. **Minimal scopes**: Only grant necessary permissions
5. **Monitor usage**: Track API calls and rate limits

### Monitoring

```yaml
services:
  agents:
    # Add monitoring
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
```

## Real-World Use Cases

### 1. Sprint Planning

```
Analyze issues labeled 'sprint-ready' in our repository
```

Helps teams identify ready-to-work issues for upcoming sprints.

### 2. Technical Debt Assessment

```
Categorize issues with 'technical-debt' label and assess priority
```

Provides visibility into technical debt backlog.

### 3. Bug Triage

```
Summarize all critical bugs reported in the last 30 days
```

Helps teams stay on top of critical issues.

### 4. Feature Demand Analysis

```
Identify most requested features based on issue labels and comments
```

Informs product roadmap decisions.

### 5. Community Engagement

```
Analyze issues from external contributors vs. core team
```

Helps measure and improve community health.

## Key Takeaways

✅ Multi-agent systems solve complex real-world problems through specialization

✅ MCP Gateway provides secure, standardized tool integration

✅ Local LLM inference with Docker Model Runner eliminates API dependencies

✅ Docker Compose orchestrates complex multi-service architectures simply

✅ Docker Offload makes GPU-accelerated agent systems accessible to everyone

✅ Practical agent applications deliver immediate business value

You've now mastered building production-ready multi-agent systems with Docker! 🚀