#!/bin/bash
# Run Jupyter Lab with GPU Support using Docker Offload

echo "Starting Jupyter Lab with TensorFlow GPU..."
echo "This will use Docker Offload if active."
echo ""

# Check if Docker Offload is active
if docker context ls | grep -q "docker-cloud \*"; then
    echo "✅ Docker Offload is active - running in cloud"
else
    echo "ℹ️  Docker Offload is not active - running locally"
    echo "To enable Docker Offload, run: docker offload start"
fi

echo ""
echo "Launching Jupyter Lab..."

docker run --rm -p 8888:8888 --gpus all \
  tensorflow/tensorflow:latest-gpu-jupyter

echo ""
echo "Access Jupyter Lab at: http://localhost:8888"
echo "Token will be displayed in the logs above."
