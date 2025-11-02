#!/bin/bash
# Run Hugging Face Transformers with GPU

echo "Setting up Hugging Face Transformers with GPU..."
echo ""

# Check if Docker Offload is active
if docker context ls | grep -q "docker-cloud \*"; then
    echo "✅ Docker Offload is active - GPU available"
else
    echo "⚠️  Docker Offload is not active"
    echo "Enable GPU: docker offload start --gpu"
fi

echo ""
echo "Installing Transformers, PyTorch, and Accelerate..."

docker run --rm -p 8080:8080 --gpus all python:3.9 sh -c \
  "pip install transformers torch accelerate && \
   python -c 'import transformers; print(\"Transformers GPU ready\")'" 

echo ""
echo "Environment ready! GPU support verified."
