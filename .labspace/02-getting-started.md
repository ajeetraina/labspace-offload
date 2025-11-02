# Getting Started with Docker Offload

## Prerequisites

✅ Docker Desktop 4.43.0 or later

✅ Active Docker Hub account

✅ Internet connection

**Note for Docker Captains**: You don't need to sign up separately for Docker Offload. Just start using it by following the CLI commands below. If you face any issues, reach out to Eva Bojorges.

## Installation & Setup

### Step 1: Verify Docker Desktop Version

Ensure you have Docker Desktop 4.43.0 or later installed:

```bash
docker --version
```

### Step 2: Explore Docker Offload CLI

Open your terminal and run:

```bash
docker offload
```

You should see:

```
Usage:  docker offload COMMAND

Docker Offload

Commands:
  accounts       Prints available accounts
  diagnose       Print diagnostic information
  start          Start a Docker Offload session
  status         Show the status of the Docker Offload connection
  stop           Stop a Docker Offload session
  version        Prints the version

Run 'docker offload COMMAND --help' for more information on a command.
```

## Starting Your First Docker Offload Session

### Step 3: Start Docker Offload

```bash
docker offload start
```

You'll be prompted to:

1. **Choose your Hub account** - Select your Docker Hub account
2. **Enable GPU support** - Choose whether to enable GPU (recommended for ML workloads)

**GPU Support**: When enabled, Docker Offload runs in an instance with an NVIDIA L4 GPU, perfect for machine learning or compute-intensive workloads.

### Step 4: Verify the Cloud Context

After starting Docker Offload, a new `docker-cloud` context is created:

```bash
docker context ls
```

Expected output:

```
NAME             DESCRIPTION                                      DOCKER ENDPOINT
default          Current DOCKER_HOST based configuration          unix:///var/run/docker.sock
desktop-linux    Docker Desktop                                   unix:///Users/username/.docker/run/docker.sock
docker-cloud *   docker cloud context created by version v0.4.2   unix:///Users/username/.docker/cloud/docker-cloud.sock
```

Notice the asterisk (*) next to `docker-cloud` - this indicates it's your active context.

## Verifying Your Setup

### Check Available Accounts

```bash
docker offload accounts
```

This displays your user and organization accounts available for Docker Offload.

### Check Connection Status

```bash
docker offload status
```

### Check Version

```bash
docker offload version
```

Expected output:
```
Docker Offload v0.4.2 build at 2025-06-30
```

### Verify Cloud Instance

Confirm you're connected to the cloud instance:

```bash
docker info | grep -E "(Server Version|Operating System)"
```

Expected output:
```
 Server Version: 28.0.2
 Operating System: Ubuntu 22.04.5 LTS
```

### Verify GPU Availability (if enabled)

If you enabled GPU support, verify the GPU:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

You should see output showing:
- **GPU**: NVIDIA L4
- **Memory**: 23GB total
- **Driver**: 535.247.01
- **CUDA Version**: 12.4

## Using Docker Dashboard

### Enable Docker Offload in Dashboard

1. Open Docker Desktop
2. Navigate to **Settings > Beta Features**
3. Enable **Docker Offload**
4. Toggle the button to start Docker Offload

### Where to Find Docker Offload

Docker Offload appears in multiple places:
- Under **Models** section
- On the **left sidebar** of the Docker Dashboard

## Your First Cloud Container

Let's run a simple test to verify everything works:

```bash
docker run --rm hello-world
```

This container runs in the cloud, not on your local machine!

## Running a Sample Application

Let's deploy a full-stack React application with Node.js backend and MongoDB:

```bash
docker compose -p react-express-mongodb \
  -f "https://github.com/docker/awesome-compose.git#:react-express-mongodb" up
```

This compose file defines an application with three services:
- **frontend** - React application
- **backend** - Node.js API
- **db** - MongoDB database

The application maps port 3000 of the frontend service to port 3000 of the cloud instance.

### Verify in Docker Dashboard

1. Open Docker Desktop
2. Navigate to **Containers**
3. You should see your running containers
4. Click on the container to view logs and metrics

## Stopping Docker Offload

When you're done, stop the Docker Offload session:

```bash
docker offload stop
```

This command removes the `docker-cloud` context from your system.

## Troubleshooting

### View Docker Offload Logs

All Docker Offload logs are available at:

```bash
cd ~/.docker/cloud/logs
tail -f cloud-daemon.log
```

### Common Issues

**Issue**: Cannot start Docker Offload
- **Solution**: Ensure Docker Desktop 4.43.0+ is installed and you're logged into Docker Hub

**Issue**: GPU not available
- **Solution**: Make sure you enabled GPU support when starting the session

**Issue**: Connection timeout
- **Solution**: Check your internet connection and firewall settings

## Key Takeaways

✅ Docker Offload uses the same Docker CLI you know and love

✅ The `docker-cloud` context automatically routes commands to cloud infrastructure

✅ Sessions are ephemeral and clean up automatically after 30 minutes of inactivity

✅ GPU acceleration is available with NVIDIA L4 GPUs (23GB VRAM)

✅ All your Docker workflows work seamlessly - builds, compose, run, etc.

Now that you're set up, let's explore GPU-accelerated workloads! 🚀