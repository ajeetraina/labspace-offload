# GPU-Accelerated Workloads with Docker Offload

## GPU Capabilities

Docker Offload supports GPU-enabled instances with **NVIDIA L4 GPUs**, enabling:

- **AI Inferencing** - Run large language models and machine learning pipelines
- **Media Processing** - Handle video encoding, image processing, and graphics workloads
- **General-Purpose GPU Computing** - Accelerate any CUDA-compatible applications
- **Hardware-Accelerated CI** - Run GPU-dependent tests and validation

### NVIDIA L4 GPU Specifications

- **Memory**: 23GB GDDR6
- **Architecture**: Ada Lovelace
- **CUDA Cores**: 7,424
- **Tensor Cores**: 232 (4th generation)
- **Perfect for**: AI inference, video transcoding, virtual workstations

## Demo 1: Jupyter Lab with TensorFlow GPU

### Overview

Launch a fully-configured Jupyter Lab environment with TensorFlow and GPU acceleration for machine learning development.

### Run the Container

```bash
docker run --rm -p 8888:8888 --gpus all tensorflow/tensorflow:latest-gpu-jupyter
```

### What's Included

The `tensorflow/tensorflow:latest-gpu-jupyter` image comes pre-installed with:
- TensorFlow GPU version
- CUDA libraries
- cuDNN
- Complete scientific Python stack (NumPy, Pandas, Matplotlib)
- Jupyter Lab

This eliminates hours of complex dependency management and environment configuration!

### Access Jupyter Lab

1. Open **Docker Dashboard > Containers**
2. View your running container
3. Click on **Ports** to access Jupyter Lab
4. Copy the token from the logs to authenticate

### Test GPU Acceleration

In Jupyter Lab, create a new notebook and run:

```python
import tensorflow as tf

# Check GPU availability
print("Num GPUs Available: ", len(tf.config.list_physical_devices('GPU')))

# Display GPU details
if tf.config.list_physical_devices('GPU'):
    gpu = tf.config.list_physical_devices('GPU')[0]
    print(f"GPU Device: {gpu}")
    
    # Simple GPU computation
    with tf.device('/GPU:0'):
        a = tf.constant([[1.0, 2.0], [3.0, 4.0]])
        b = tf.constant([[1.0, 1.0], [0.0, 1.0]])
        c = tf.matmul(a, b)
        print("\nMatrix multiplication result:")
        print(c)
```

### Use Cases

- Training neural networks
- Model experimentation and prototyping
- Data science exploration
- Computer vision research
- Natural language processing

## Demo 2: GPU-Accelerated Streamlit App

### Overview

Create an instant, GPU-enabled data science development environment using Streamlit with PyTorch.

### Run the Container

```bash
docker run --rm -p 8501:8501 --gpus all python:3.9 sh -c \
  "pip install streamlit torch torchvision && streamlit hello --server.address=0.0.0.0"
```

### What This Does

1. **Installs Streamlit** - For the web interface
2. **Installs PyTorch** - GPU-accelerated deep learning framework
3. **Installs TorchVision** - Computer vision utilities
4. **Launches Demo App** - Streamlit's built-in demo with interactive widgets

### Access the App

Open your browser at `http://localhost:8501`

### Build Your Own Streamlit App

Create a simple GPU-accelerated app:

```python
import streamlit as st
import torch

st.title("GPU Acceleration Demo")

# Check CUDA availability
if torch.cuda.is_available():
    st.success(f"✅ GPU Available: {torch.cuda.get_device_name(0)}")
    st.info(f"Memory: {torch.cuda.get_device_properties(0).total_memory / 1e9:.2f} GB")
    
    # Simple GPU computation
    if st.button("Run GPU Computation"):
        with st.spinner("Computing on GPU..."):
            # Create large tensors on GPU
            x = torch.randn(10000, 10000, device='cuda')
            y = torch.randn(10000, 10000, device='cuda')
            z = torch.matmul(x, y)
            st.success("Computation completed!")
            st.write(f"Result shape: {z.shape}")
else:
    st.error("❌ No GPU available")
```

## Demo 3: Hugging Face Transformers with GPU

### Overview

Set up a GPU-accelerated environment for working with state-of-the-art NLP and computer vision models from Hugging Face.

### Run the Container

```bash
docker run --rm -p 8080:8080 --gpus all python:3.9 sh -c \
  "pip install transformers torch accelerate && \
   python -c 'import transformers; print(\"Transformers GPU ready\")'"
```

### Installed Libraries

- **transformers** - Hugging Face library with thousands of pre-trained models (BERT, GPT, CLIP)
- **torch** - PyTorch for deep learning computations
- **accelerate** - Simplifies distributed and mixed-precision training

### Example: Text Generation with GPT-2

```python
from transformers import pipeline, set_seed
import torch

# Use GPU if available
device = 0 if torch.cuda.is_available() else -1

# Create text generation pipeline
generator = pipeline('text-generation', 
                    model='gpt2',
                    device=device)

set_seed(42)

# Generate text
result = generator(
    "Artificial intelligence is",
    max_length=50,
    num_return_sequences=3
)

for i, text in enumerate(result):
    print(f"\nGeneration {i+1}:")
    print(text['generated_text'])
```

### Example: Sentiment Analysis

```python
from transformers import pipeline

# Create sentiment analysis pipeline
sentiment = pipeline('sentiment-analysis', device=0)

# Analyze sentiment
texts = [
    "Docker Offload is amazing for GPU workloads!",
    "This is frustrating and slow.",
    "I'm not sure how I feel about this."
]

results = sentiment(texts)

for text, result in zip(texts, results):
    print(f"Text: {text}")
    print(f"Sentiment: {result['label']} (confidence: {result['score']:.2f})\n")
```

### Example: Image Classification

```python
from transformers import pipeline
from PIL import Image
import requests

# Load image classifier
classifier = pipeline('image-classification', device=0)

# Download sample image
url = "https://images.unsplash.com/photo-1574158622682-e40e69881006"
image = Image.open(requests.get(url, stream=True).raw)

# Classify image
results = classifier(image)

print("Top 5 predictions:")
for result in results:
    print(f"{result['label']}: {result['score']:.2%}")
```

## Performance Comparison

### Build Times

| Environment | Time | Improvement |
|------------|------|-------------|
| Local (M1 Mac) | 45s | baseline |
| Local (Intel i7) | 60s | -33% |
| Docker Offload | 15s | **3x faster** |

### Model Inference (GPT-2)

| Environment | Tokens/sec | Improvement |
|------------|-----------|-------------|
| CPU (local) | 12 | baseline |
| Docker Offload (L4 GPU) | 180 | **15x faster** |

## Cloud Builds with Docker Offload

### Enhanced Build Performance

When you use Docker Offload for builds, the `docker buildx build` command executes on remote BuildKit instances in the cloud.

### Benefits

✅ **Faster Builds** - Powerful cloud instances outperform typical development machines

✅ **Consistent Results** - Standardized build environment eliminates "works on my machine" issues

✅ **Resource Efficiency** - No local CPU/memory consumption during builds

✅ **Team Collaboration** - Shared cache improves build times across the entire team

### Build Infrastructure

- **Isolated Environment** - Each cloud builder runs on dedicated Amazon EC2 instances with EBS volumes
- **Shared Cache** - Intelligent caching accelerates builds across machines and team members
- **Multi-Platform Support** - Native support for multiple architectures (linux/amd64, linux/arm64)
- **Secure Transfer** - Build results are encrypted in transit
- **Automatic Management** - Docker handles all infrastructure provisioning

## Best Practices

### 1. Resource Management

- Stop Docker Offload sessions when not in use (auto-stops after 30 minutes)
- Use appropriate model sizes for your GPU memory (23GB limit)
- Monitor GPU utilization in container logs

### 2. Development Workflow

- Develop and test on small models locally
- Scale up to full models on Docker Offload for final testing
- Use batch processing for multiple inference tasks

### 3. Security

- Don't commit sensitive API keys or tokens
- Use environment variables for configuration
- Sessions are ephemeral - no data persists between sessions

## Troubleshooting GPU Issues

### Check GPU Availability

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

### Common Issues

**Issue**: `--gpus all` not recognized
- **Solution**: Ensure you started Docker Offload with GPU support enabled

**Issue**: CUDA out of memory
- **Solution**: Use smaller models or reduce batch sizes

**Issue**: Slow inference
- **Solution**: Verify you're using GPU with `torch.cuda.is_available()` or similar checks

## Next Steps

Now that you understand GPU-accelerated workloads, let's explore building sophisticated multi-agent AI systems with Docker Offload! 🚀