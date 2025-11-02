# Getting Started with Docker Offload

⏱️ **Estimated time**: 10 minutes

In this lab, you'll set up Docker Offload and learn how to start cloud-powered Docker sessions.

## 🎯 Learning Objectives

By the end of this lab, you will:
- Install and verify Docker Offload
- Start your first Docker Offload session
- Understand Docker contexts
- Verify GPU availability
- Run your first cloud container

## 📋 Step 1: Verify Docker Desktop Version

Docker Offload requires Docker Desktop 4.43.0 or later.

```bash
docker version
```

Look for the **Server Version** in the output. It should be 4.43.0 or higher.

**Expected output:**
```
Client:
 Version:           28.0.2
 ...

Server: Docker Desktop 4.43.0 (178452)
 Engine:
  Version:          28.0.2
  ...
```

> 📝 **Note**: If your version is older, update Docker Desktop from [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/).

## 📋 Step 2: Enable Docker Offload

There are two ways to enable Docker Offload:

### Option A: Using Docker Dashboard (Recommended)

1. Open Docker Desktop
2. Navigate to **Settings** → **Beta Features**
3. Toggle **Docker Offload** to ON
4. Click **Apply & Restart**

### Option B: Using CLI

Docker Captains have automatic access and can start using it immediately via CLI without additional setup.

## 📋 Step 3: Check Docker Offload Version

Verify Docker Offload is available:

```bash
docker offload version
```

**Expected output:**
```
Docker Offload v0.4.2 build at 2025-06-30
```

View all available commands:

```bash
docker offload --help
```

**Output:**
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

## 📋 Step 4: Start Docker Offload Session

Start a Docker Offload session with GPU support:

```bash
docker offload start --gpu
```

You'll see an interactive prompt:

```
? Please select an account:
  › user: ajeetraina
    org: docker
```

Select your account (Docker Captains typically use their personal account).

Next, you'll be asked about GPU support:

```
? Enable GPU support? (Y/n)
```

Press `Y` for yes. This provisions an NVIDIA L4 GPU instance.

**Expected output:**
```
✓ Starting Docker Offload session...
✓ Provisioning cloud resources...
✓ Connecting to cloud daemon...
✓ Docker Offload session started successfully!

Context switched to: docker-cloud
```

> ⚡ **Pro Tip**: Use `--no-gpu` flag if you don't need GPU acceleration. This saves costs!

## 📋 Step 5: Verify Docker Context

Docker Offload creates a new context called `docker-cloud`:

```bash
docker context ls
```

**Expected output:**
```
NAME             DESCRIPTION                                      DOCKER ENDPOINT
default          Current DOCKER_HOST based configuration         unix:///var/run/docker.sock
desktop-linux    Docker Desktop                                   unix:///Users/.../.docker/run/docker.sock
docker-cloud *   docker cloud context created by version v0.4.2  unix:///Users/.../.docker/cloud/docker-cloud.sock
```

The `*` indicates `docker-cloud` is the active context. All Docker commands now run in the cloud!

## 📋 Step 6: Check Offload Status

View your Docker Offload connection status:

```bash
docker offload status
```

**Expected output:**
```
Status: Connected
Account: ajeetraina
GPU Enabled: Yes
Instance Type: gpu.large
Region: us-east-1
Uptime: 2m 15s
Auto-shutdown: 30 minutes of inactivity
```

## 📋 Step 7: Verify Cloud Environment

Check that you're running in the cloud:

```bash
docker info | grep -E "(Server Version|Operating System)"
```

**Expected output:**
```
Server Version: 28.0.2
Operating System: Ubuntu 22.04.5 LTS
```

The **Ubuntu** operating system confirms you're running in the Docker Offload cloud environment!

## 📋 Step 8: Verify GPU Availability

Let's confirm the NVIDIA L4 GPU is available:

```bash
docker run --rm --gpus all nvidia/cuda:12.4.0-runtime-ubuntu22.04 nvidia-smi
```

**Expected output:**
```
Fri Nov  2 16:55:11 2025       
+---------------------------------------------------------------------------------------+
| NVIDIA-SMI 535.247.01             Driver Version: 535.247.01   CUDA Version: 12.4     |
|-----------------------------------------+----------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
|                                         |                      |               MIG M. |
|=========================================+======================+======================|
|   0  NVIDIA L4                      Off | 00000000:31:00.0 Off |                    0 |
| N/A   44C    P0              27W /  72W |      0MiB / 23034MiB |      0%      Default |
|                                         |                      |                  N/A |
+-----------------------------------------+----------------------+----------------------+
```

🎉 **Success!** You have:
- **GPU**: NVIDIA L4
- **Memory**: 23GB VRAM
- **CUDA**: Version 12.4
- **Driver**: 535.247.01

## 📋 Step 9: Run Your First Cloud Container

Let's run a simple container to test the cloud execution:

```bash
docker run --rm alpine:latest echo "Hello from Docker Offload!"
```

**Expected output:**
```
Hello from Docker Offload!
```

## 📋 Step 10: Check Available Accounts

View all accounts you can use with Docker Offload:

```bash
docker offload accounts
```

**Expected output (formatted):**
```json
{
  "user": {
    "id": "15ee357d-XXXX-4d39-87d9-dc3b697b3392",
    "fullName": "Ajeet Singh Raina",
    "username": "ajeetraina",
    "state": "READY"
  },
  "orgs": [
    {
      "id": "57b45934-74c0-11e4-XXX-0242ac11001b",
      "fullName": "Docker, Inc.",
      "orgname": "docker",
      "state": "READY"
    }
  ]
}
```

## 🔄 Switching Contexts

To switch back to local Docker:

```bash
docker context use desktop-linux
```

To switch back to Docker Offload:

```bash
docker context use docker-cloud
```

Or simply restart the offload session:

```bash
docker offload start --gpu
```

## 🛑 Stopping Docker Offload

When you're done, stop the Docker Offload session:

```bash
docker offload stop
```

**Expected output:**
```
✓ Stopping Docker Offload session...
✓ Cleaning up cloud resources...
✓ Session stopped successfully.

Context switched to: desktop-linux
```

> 💡 **Auto-Shutdown**: Docker Offload automatically stops after ~30 minutes of inactivity, so you don't need to worry about forgetting to stop it!

## 📊 Session Management

Docker Offload manages ephemeral cloud environments:

| Feature | Behavior |
|---------|----------|
| **Active Session** | Remains active while you interact with containers |
| **Inactivity Timeout** | ~30 minutes of no activity |
| **Auto-Cleanup** | Containers, images, and volumes removed on stop |
| **No Persistence** | No state between sessions (by design) |
| **Cost Efficiency** | Pay only for active session time |

## 🐛 Troubleshooting

### Issue: Docker Offload command not found

**Solution**: Update to Docker Desktop 4.43.0 or later

### Issue: Cannot start session

**Solution**: 
1. Check internet connectivity
2. Verify Docker Captain status
3. Contact Eva Bojorges for access issues

### Issue: GPU not available

**Solution**: Ensure you started with `--gpu` flag:
```bash
docker offload stop
docker offload start --gpu
```

### View Logs

If you encounter issues, check the logs:

```bash
cd ~/.docker/cloud/logs
tail -f cloud-daemon.log
```

## 📚 Key Takeaways

✅ Docker Offload extends your local Docker workflow to the cloud  
✅ NVIDIA L4 GPUs with 23GB VRAM are available instantly  
✅ Same Docker commands work seamlessly in the cloud  
✅ Automatic cleanup prevents runaway costs  
✅ Docker Captains get automatic access  

## 🎯 Next Steps

Now that you have Docker Offload running, let's put that GPU to work!

In the next lab, you'll:
- Run Jupyter Lab with TensorFlow GPU support
- Deploy Streamlit ML applications
- Test Hugging Face transformers
- Experience real GPU acceleration

---

**Ready to run GPU-accelerated ML workloads?** 🚀

Click **Next** to continue to Lab 03: GPU-Accelerated ML Workloads →
