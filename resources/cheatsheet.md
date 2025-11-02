# Docker Offload Cheat Sheet

Quick reference for Docker Offload commands, configurations, and common workflows.

## Docker Offload CLI Commands

### Session Management

```bash
# Start Docker Offload with GPU
docker offload start --gpu

# Start without GPU
docker offload start

# Check status
docker offload status

# Stop session
docker offload stop

# Check version
docker offload version

# List accounts
docker offload accounts

# Diagnose issues
docker offload diagnose
```

### Context Management

```bash
# List contexts
docker context ls

# Switch to cloud context (automatically set when starting)
docker context use docker-cloud

# Switch back to local
docker context use default
```

## Verification Commands

### Check Cloud Instance

```bash
# Verify you're using cloud
docker info | grep -E "(Server Version|Operating System)"

# Expected output:
# Server Version: 28.0.2
# Operating System: Ubuntu 22.04.5 LTS
```

### Check GPU Availability

```bash
# Test GPU
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi

# Expected:
# NVIDIA L4 GPU
# 23GB memory
# CUDA 12.4
```

## Common Docker Commands with Offload

### Running Containers

```bash
# Simple container
docker run --rm hello-world

# Interactive container
docker run -it --rm ubuntu bash

# With GPU
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi

# With port mapping
docker run -p 8080:80 nginx

# With volume mount
docker run -v $(pwd):/data ubuntu ls /data
```

### Building Images

```bash
# Build locally (uses cloud builder when Offload active)
docker build -t myapp:latest .

# Build with BuildKit
docker buildx build -t myapp:latest .

# Multi-platform build
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

### Docker Compose

```bash
# Start services
docker compose up

# Start in detached mode
docker compose up -d

# Start with build
docker compose up --build

# Stop services
docker compose down

# View logs
docker compose logs -f

# Run with override file
docker compose -f compose.yaml -f compose.offload.yaml up
```

## GPU Workload Examples

### Jupyter Lab

```bash
docker run --rm -p 8888:8888 --gpus all \
  tensorflow/tensorflow:latest-gpu-jupyter
```

Access: http://localhost:8888

### Streamlit

```bash
docker run --rm -p 8501:8501 --gpus all python:3.9 sh -c \
  "pip install streamlit torch torchvision && \
   streamlit hello --server.address=0.0.0.0"
```

Access: http://localhost:8501

### Hugging Face

```bash
docker run --rm -p 8080:8080 --gpus all python:3.9 sh -c \
  "pip install transformers torch accelerate && \
   python -c 'import transformers; print(\"Ready\")'"
```

## Model Configuration

### Qwen3 Models

**Development (8B)**:
```yaml
models:
  qwen3-small:
    model: ai/qwen3:8B-Q4_0
    context_size: 15000  # 7 GB VRAM
```

**Production (14B)**:
```yaml
models:
  qwen3-medium:
    model: ai/qwen3:14B-Q6_K
    context_size: 15000  # 15 GB VRAM
```

**High-End (30B)**:
```yaml
models:
  qwen3-large:
    model: ai/qwen3:30B-A3B-Q4_K_M
    context_size: 41000  # 21+ GB VRAM
```

## MCP Gateway Configuration

### Basic Setup

```yaml
mcp-gateway:
  image: docker/mcp-gateway:latest
  use_api_socket: true
  command:
    - --transport=sse
    - --servers=github-official
    - --secrets=/run/secrets/mcp_secret
  secrets:
    - mcp_secret

secrets:
  mcp_secret:
    file: ./.mcp.env
```

### Multiple Servers

```yaml
command:
  - --servers=github-official,slack,jira
```

### With Interceptor (JSON to CSV)

```yaml
command:
  - --interceptor
  - after:exec:cat | jq '.content[0].text = (.content[0].text | fromjson | map(select(. != null) | [(.number // ""), (.state // ""), (.title // "")]) | join("\n"))'
```

## Common Compose Patterns

### Agent with Model

```yaml
services:
  agent:
    build: .
    ports:
      - "7777:7777"
    models:
      qwen3:
        endpoint_var: MODEL_URL
        model_var: MODEL_NAME

models:
  qwen3:
    model: ai/qwen3:8B-Q4_0
    context_size: 15000
```

### Multi-Service Architecture

```yaml
services:
  frontend:
    image: myapp-ui:latest
    ports:
      - "3000:3000"
    depends_on:
      - backend
  
  backend:
    image: myapp-api:latest
    ports:
      - "8080:8080"
    depends_on:
      - database
  
  database:
    image: postgres:15
    volumes:
      - db-data:/var/lib/postgresql/data

volumes:
  db-data:
```

## Troubleshooting

### Check Logs

```bash
# Docker Offload logs
cd ~/.docker/cloud/logs
tail -f cloud-daemon.log

# Container logs
docker logs <container-name>
docker logs -f <container-name>  # Follow

# Compose logs
docker compose logs
docker compose logs -f service-name
```

### Debug GPU Issues

```bash
# Verify GPU in container
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi

# Check CUDA availability (PyTorch)
docker run --rm --gpus all python:3.9 sh -c \
  "pip install torch && python -c 'import torch; print(torch.cuda.is_available())'"

# Check CUDA availability (TensorFlow)
docker run --rm --gpus all python:3.9 sh -c \
  "pip install tensorflow && python -c 'import tensorflow as tf; print(len(tf.config.list_physical_devices(\"GPU\")))'"
```

### Network Issues

```bash
# Test connectivity
docker run --rm curlimages/curl curl -I https://hub.docker.com

# Check ports
lsof -i :8080  # Check if port in use

# View network
docker network ls
docker network inspect bridge
```

### Reset Docker Offload

```bash
# Stop session
docker offload stop

# Remove cloud context
docker context rm docker-cloud

# Start fresh
docker offload start --gpu
```

## Performance Tips

### Build Optimization

```dockerfile
# Use BuildKit
# syntax=docker/dockerfile:1

# Multi-stage builds
FROM node:16 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM node:16-alpine
COPY --from=builder /app/node_modules ./node_modules
COPY . .
CMD ["node", "server.js"]
```

### Cache Optimization

```dockerfile
# Order layers by change frequency
# Least changing first
FROM python:3.9
WORKDIR /app

# Dependencies (changes rarely)
COPY requirements.txt .
RUN pip install -r requirements.txt

# Code (changes often)
COPY . .
CMD ["python", "app.py"]
```

### Resource Limits

```yaml
services:
  app:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 4G
        reservations:
          memory: 2G
```

## Security Best Practices

### Secrets Management

```yaml
# Don't hardcode secrets
services:
  app:
    environment:
      - DB_PASSWORD=${DB_PASSWORD}
    secrets:
      - db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### .gitignore

```gitignore
# Secrets
.mcp.env
*.key
*.pem
secrets/

# Environment
.env
.env.local

# Logs
*.log
```

### Non-Root User

```dockerfile
FROM node:16-alpine

# Create user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy files
COPY --chown=appuser:appgroup . .

# Switch to non-root user
USER appuser

CMD ["node", "server.js"]
```

## Useful Environment Variables

```bash
# Docker configuration
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Model Runner
export MODEL_RUNNER_URL=http://localhost:8000
export MODEL_RUNNER_MODEL=qwen3:8B-Q4_0

# MCP Gateway
export MCPGATEWAY_URL=http://localhost:8811/sse

# Logging
export LOG_LEVEL=INFO
```

## Quick Reference Tables

### Port Mappings

| Service | Port | Protocol |
|---------|------|----------|
| Jupyter | 8888 | HTTP |
| Streamlit | 8501 | HTTP |
| Agent Runtime | 7777 | HTTP |
| Agent UI | 3000 | HTTP |
| MCP Gateway | 8811 | HTTP/SSE |

### Model Sizes

| Model | Size | VRAM | Context | Use Case |
|-------|------|------|---------|----------|
| Qwen3-8B | 4.44 GB | 7 GB | 15K | Development |
| Qwen3-14B | 11.28 GB | 15 GB | 15K | Production |
| Qwen3-30B | 30+ GB | 24 GB | 41K | High-end |

### File Locations

| Item | Location |
|------|----------|
| Docker Offload logs | `~/.docker/cloud/logs/` |
| Docker config | `~/.docker/config.json` |
| Compose files | `./compose.yaml` |
| MCP secrets | `./.mcp.env` |

---

**Keep this cheat sheet handy for quick reference!** 🚀
