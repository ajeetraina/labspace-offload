#!/bin/bash
# Run GPU-accelerated Streamlit App

echo "Starting GPU-accelerated Streamlit environment..."
echo ""

# Check if Docker Offload is active
if docker context ls | grep -q "docker-cloud \*"; then
    echo "✅ Docker Offload is active - using cloud GPU"
else
    echo "⚠️  Docker Offload is not active"
    echo "For GPU acceleration, run: docker offload start --gpu"
fi

echo ""
echo "Installing Streamlit, PyTorch, and TorchVision..."

docker run --rm -p 8501:8501 --gpus all python:3.9 sh -c \
  "pip install streamlit torch torchvision && \
   streamlit hello --server.address=0.0.0.0"

echo ""
echo "Access Streamlit at: http://localhost:8501"
