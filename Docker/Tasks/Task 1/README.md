# Docker Task 1 - Resource Limits and Memory Management

This task demonstrates how to work with Docker containers, set resource limits (CPU and memory), and observe container behavior when memory consumption exceeds the defined limits.

## Task Overview

The goal is to:
- Run containers with specific CPU and memory limits
- Create a Python application that consumes memory over time
- Build a custom Docker image
- Monitor and observe what happens when a container exceeds its memory limit

---

## Step 1: Run Nginx Container in Background

![Background container Nginx Alpine](images/1)BackgroundcontainerNginxAlpine.png)

First, we run an nginx:alpine container in the background. This demonstrates running a basic container with the `-d` (detached) flag.

**Command:**
```bash
docker run -d nginx:alpine
```

---

## Step 2: Create Apache Container with 70MB Memory Limit

![Make Apache with 70M](images/2)MAkeapachiwith70M.png)

We create and run an Apache container with resource constraints:
- Memory limit: 70MB
- CPU limit: 1 core

This shows how to set resource limits when starting a container.

**Command:**
```bash
docker run -d --name apache-container -m 70m --cpus="1" httpd
```

---

## Step 3: Inspect Container to Get ID

![Inspect to get ID](images/3)InspecttogetID.png)

Using the `docker inspect` command to get detailed information about the container, including its ID and configuration.

**Command:**
```bash
docker inspect <container-name>
```

---

## Step 4: Verify CPU and Memory Configuration

![Verify CPU is 1 and Memory is 70](images/4)VerifyCPUis1andMemoryis70.png)

This screenshot confirms that the container was created with the correct resource limits:
- CPU: 1 core
- Memory: 70MB

You can verify these settings using `docker inspect` or `docker stats` commands.

---

## Step 5: Create Python Consumer File

![Create Python consumer file](images/5)CreatePythonconsumerfile.png)

We create a Python script (`consumer.py`) that gradually consumes memory. The script:
1. Waits 15 seconds after the container starts
2. Allocates 45MB of memory
3. Waits 5 seconds
4. Allocates an additional 15MB (total 60MB)
5. Runs in an infinite loop to keep the container alive

**File: consumer.py**
```python
import time
# Wait 15 seconds before continue the code after container starts
time.sleep(15)
# Allocate 45MB of memory 
data1 = bytearray(45 * 1024 * 1024) 
time.sleep(5)
# Allocate 15MB of memory now the allocated is 60MB
data2 = bytearray(15 * 1024 * 1024)

# Infinite loop to keep the container running
while True:
    time.sleep(1)
```

---

## Step 6: Create Dockerfile

![Create Dockerfile](images/6)CreateDockerFile.png)

We create a Dockerfile that:
- Uses nginx:alpine as the base image
- Installs Python3
- Copies the consumer.py file into the container
- Runs the Python script when the container starts

**File: Dockerfile**
```dockerfile
FROM nginx:alpine
# Download python on nginx
RUN apk add --no-cache python3 
# Copy the file from host into the container
COPY consumer.py /app/consumer.py
# Run the code on the container
CMD ["python3", "/app/consumer.py"]
```

---

## Step 7: Build Image and Run with Configuration

![Build the image and run with configuration](images/7)BuildTheimageandMakeRunwithConfiguration.png)

We build the Docker image and run it with specific resource limits:

**Build command:**
```bash
docker build -t memory-consumer .
```

**Run command:**
```bash
docker run -d --name consumer-container -m 70m --cpus="1" memory-consumer
```

---

## Step 8: First 10 Seconds - Memory is Normal

![First 10 seconds the code is waiting and memory is normal](images/8)First10secondthecodeiswaitadthememoryisnormal.png)

During the first 10-15 seconds, the container is running but the Python script is still in the sleep phase. Memory consumption is normal and within limits.

**Monitor with:**
```bash
docker stats consumer-container
```

---

## Step 9: After 15 Seconds - Memory Consumption Increases

![After that the consumption is 90](images/9)afterthemtheconsumptionis90.png)

After 15 seconds, the script starts allocating memory. The consumption increases to around 90MB, which exceeds the 70MB limit we set.

---

## Step 10: Container Killed Due to Memory Limit Exceeded

![After last 5 seconds the consumption exceeds the limits so it killed](images/10)afterlast5secondtheconsumptionexceedsthelimitsoitkilled.png)

When the memory consumption exceeds the 70MB limit, Docker kills the container automatically. This is Docker's OOM (Out Of Memory) killer in action, protecting the host system from memory exhaustion.

**Result:** Container is stopped because it exceeded memory limits.

---

## Key Learnings

1. **Resource Limits**: Docker allows you to set CPU and memory limits using `--cpus` and `-m` flags
2. **Memory Management**: When a container exceeds its memory limit, Docker's OOM killer terminates it
3. **Monitoring**: Use `docker stats` to monitor real-time resource usage
4. **Custom Images**: You can build custom images by combining base images with your application code
5. **Container Lifecycle**: Containers can be automatically stopped when they violate resource constraints

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `docker run -d <image>` | Run container in detached mode |
| `docker run -m <size>` | Set memory limit |
| `docker run --cpus="<number>"` | Set CPU limit |
| `docker inspect <container>` | Get detailed container information |
| `docker stats <container>` | Monitor real-time resource usage |
| `docker build -t <name> .` | Build image from Dockerfile |
| `docker logs <container>` | View container logs |

---

## Conclusion

This task successfully demonstrates Docker's resource management capabilities and shows how containers behave when they exceed their allocated resources. Understanding these limits is crucial for running containerized applications in production environments.
