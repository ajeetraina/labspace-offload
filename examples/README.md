# Docker Offload Examples

This directory contains practical examples and scripts for working with Docker Offload.

## Quick Start Scripts

### GPU Workloads

**Jupyter Lab with TensorFlow GPU**:
```bash
chmod +x jupyter-gpu.sh
./jupyter-gpu.sh
```

**Streamlit with PyTorch**:
```bash
chmod +x streamlit-gpu.sh
./streamlit-gpu.sh
```

**Hugging Face Transformers**:
```bash
chmod +x huggingface-gpu.sh
./huggingface-gpu.sh
```

## Compose Files

### Full-Stack Application

**React + Node.js + MongoDB**:
```bash
docker compose -f react-app-compose.yaml up
```

Access at: http://localhost:3000

### Multi-Agent Systems

**A2A Fact Checker**:
```bash
# Start with Docker Offload for GPU support
docker offload start --gpu

# Launch the system
docker compose -f a2a-compose.yaml up --build
```

Access at: http://localhost:8080/dev-ui/?app=AgentKit

**Agno GitHub Analyzer**:
```bash
# Configure GitHub token first
cp .mcp.env.example .mcp.env
# Edit .mcp.env and add your GitHub token

# Start with Docker Offload
docker offload start --gpu

# Launch the system
docker compose -f agno-compose.yaml up --build
```

Access at: http://localhost:3000

## Configuration

### MCP Gateway Setup

1. Copy the example environment file:
   ```bash
   cp .mcp.env.example .mcp.env
   ```

2. Add your credentials:
   - GitHub Personal Access Token
   - Other service credentials as needed

3. Ensure the file is in your `.gitignore`:
   ```bash
   echo ".mcp.env" >> .gitignore
   ```

### GitHub Token Creation

1. Go to GitHub Settings → Developer settings → Personal access tokens
2. Click "Generate new token (classic)"
3. Give it a descriptive name: "Docker Offload Agno"
4. Select scopes:
   - `repo` (for private repos)
   - OR `public_repo` (for public repos only)
5. Click "Generate token"
6. Copy immediately (shown only once)
7. Add to `.mcp.env`

## Docker Offload Commands

### Start Docker Offload

```bash
# Start with GPU support (recommended)
docker offload start --gpu

# Start without GPU
docker offload start
```

### Check Status

```bash
# View connection status
docker offload status

# List available accounts
docker offload accounts

# Check version
docker offload version
```

### Verify GPU

```bash
# Check GPU availability
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

### Stop Docker Offload

```bash
docker offload stop
```

## Model Configuration

### Available Models

**Qwen3-8B** (Recommended for development):
- Size: 4.44 GB
- VRAM: 7 GB
- Context: 15,000 tokens
- Speed: Fast

**Qwen3-14B** (Production):
- Size: 11.28 GB
- VRAM: 15 GB
- Context: 15,000 tokens
- Quality: Better

**Qwen3-30B** (High-end):
- Size: 30+ GB
- VRAM: 24 GB
- Context: 41,000 tokens
- Quality: Best

### Adjusting Model Parameters

Edit the compose file:

```yaml
models:
  your-model:
    model: ai/qwen3:8B-Q4_0
    context_size: 20000      # Increase for longer context
    temperature: 0.7         # 0.0-1.0 (higher = more creative)
    top_p: 0.9              # Nucleus sampling
    repeat_penalty: 1.1      # Reduce repetition
```

## Troubleshooting

### GPU Not Available

**Issue**: `--gpus all` flag not working

**Solution**:
1. Ensure Docker Offload started with GPU: `docker offload start --gpu`
2. Verify GPU is available: `docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi`

### Authentication Errors

**Issue**: GitHub authentication failed

**Solution**:
1. Check token in `.mcp.env`
2. Verify token has correct scopes
3. Ensure token hasn't expired
4. Restart MCP Gateway: `docker compose restart mcp-gateway`

### Out of Memory

**Issue**: CUDA out of memory

**Solution**:
1. Use smaller model (8B instead of 14B)
2. Reduce context_size in compose file
3. Enable Docker Offload for more VRAM
4. Process data in smaller batches

### Connection Issues

**Issue**: Cannot connect to MCP Gateway

**Solution**:
1. Check MCP Gateway logs: `docker logs <container-name>`
2. Verify ports are not in use: `lsof -i :8811`
3. Restart services: `docker compose restart`

## Best Practices

### Security

- Never commit `.mcp.env` file
- Use environment variables for sensitive data
- Rotate tokens regularly (every 90 days)
- Use minimal token scopes needed
- Enable 2FA on your GitHub account

### Performance

- Start with smaller models for development
- Scale up to larger models for production
- Use caching to reduce API calls
- Monitor GPU memory usage
- Batch process when possible

### Development

- Test locally before using Docker Offload
- Use Docker Offload for GPU-intensive tasks
- Keep compose files version controlled
- Document custom configurations
- Share examples with team

## Additional Resources

- [Docker Offload Documentation](https://docs.docker.com)
- [MCP Gateway GitHub](https://github.com/docker/mcp-gateway)
- [Compose for Agents](https://github.com/docker/compose-for-agents)
- [Docker Model Runner](https://docs.docker.com/model-runner)

## Support

If you encounter issues:

1. Check troubleshooting section above
2. Review Docker Offload logs: `~/.docker/cloud/logs/cloud-daemon.log`
3. Join Collabnix Community Slack
4. Open issue on GitHub

---

*Happy coding with Docker Offload!* 🚀
