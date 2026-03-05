# Docker Task 2 - Flask App Deployment, Docker Hub Push & Nginx Networking

This task is split into two parts. **Task A** covers building a Flask application container, running it with memory limits, and pushing the image to Docker Hub. **Task B** covers creating a custom Nginx container with a modified port, setting up a Docker network, and testing connectivity.

---

## Part A: Flask App Container & Docker Hub Push

### Task A Overview

The goal of Task A is to:
- Fork and clone a Flask application repository
- Write a Bash script that automates cloning, setting up a virtual environment, and running the app
- Build a Docker image using Alpine Linux with Python, Git, and Bash
- Run the container with a 100MB memory limit and publish port 80 to port 5000
- Push the final image to Docker Hub

---

### Step 1: Fork the Repository

![Fork the repo to edit the changes](images/1%29ForkTherepotoeditthechanges.png)

First, we fork the [basic-flask-app](https://github.com/Jemy45/basic-flask-app) repository on GitHub. Forking allows us to have our own copy of the repo so we can make changes versions of the requirments and use it freely inside our container.

---

### Step 2: Write the Bash Script on the Host

![Bash on the host](images/2%29Bashonthehost.png)

We create a shell script called `run_flask.sh` on the host machine. This script automates the entire setup process for the Flask application:s

1. Clones the forked repository
2. Navigates into the project directory
3. Creates a Python virtual environment
4. Activates the virtual environment
5. Installs the required dependencies from `requirements.txt`
6. Starts the Flask application

**File: run_flask.sh**
```bash
#!/bin/bash

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/Jemy45/basic-flask-app

# Navigate to the application directory
cd basic-flask-app

# Remove the .git directory to be able to commit changes
rm -rf ".git"

# Create virtual environment
echo "Creating virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install requirements
echo "Installing requirements..."
pip install -r requirements.txt

# Run the Flask application
echo "Starting Flask application..."
python routes.py
```

---

### Step 3: Make the Script Executable and Run It

![Change the permission then run](images/3%29Changethepermisionthenrun.png)

Before running the script, we need to give it execute permission using `chmod`. Then we run it to verify that the Flask app works correctly on the host before containerizing it.

**Commands:**
```bash
chmod +x run_flask.sh
./run_flask.sh
```

This step is important because it confirms the script works as expected before we put it inside a Docker container.

---

### Step 4: Create the Dockerfile

![Dockerfile for building the first container](images/4%29Dockerfileforbuildfirstcontainer.png)

We create a Dockerfile that uses `alpine:latest` as the base image. Alpine is a very lightweight Linux distribution, which keeps the image size small. We install Python 3, Git, and Bash, then copy our shell script into the container and run it.

**File: Dockerfile**
```dockerfile
# Use alpine as base image
FROM alpine:latest
# Install Python 3, Git, and Bash
RUN apk add --no-cache python3 git bash
# Change to the /app directory
WORKDIR /app
# Copy the shell file to the container
COPY run_flask.sh .
# Make the shell file executable
RUN chmod +x run_flask.sh
# Run the shell file which clones and download required files for flask
CMD ["./run_flask.sh"]
```

**Key points:**
- `FROM alpine:latest` — Uses Alpine Linux to keep the image lightweight
- `RUN apk add --no-cache python3 git bash` — Installs the tools needed to clone the repo, create a virtual environment, and run the app
- `WORKDIR /app` — Sets the working directory inside the container
- `COPY run_flask.sh .` — Copies the shell script from the host into the container
- `RUN chmod +x run_flask.sh` — Makes the script executable inside the container
- `CMD ["./run_flask.sh"]` — Runs the script when the container starts

---

### Step 5: Build the Docker Image

![Build the Dockerfile](images/5%29Buildthedockerfile.png)

We build the Docker image from the Dockerfile. The `-t` flag lets us give the image a name (tag) so we can refer to it easily.

**Command:**
```bash
docker build -t iti-flask-lab2 .
```

The `.` at the end tells Docker to look for the Dockerfile in the current directory.

---

### Step 6: Run the Container with 100MB Memory Limit and port forwarding

![Run the image with 100M](images/6%29Runtheimagewith100M.png)

We run the container with a memory limit of 100MB and port forwarding. This demonstrates how to apply resource constraints to a running container.

**Command:**
```bash
docker run -d --memory 100m -p 127.0.0.1:80:5000 flask-app
```

- `-d` — Runs the container in detached (background) mode
- `--memory 100m` — Limits the container memory to 100MB
- `-p 127.0.0.1:80:5000` — Maps port 80 on the host to port 5000 inside the container

You can verify the memory limit is applied using:
```bash
docker stats
```

---

### Step 7: Login to Docker Hub

![Login into Docker Hub](images/7%29LoginIntoDockerhub.png)

Before pushing the image, we need to authenticate with Docker Hub. The `docker login` command prompts for your Docker Hub username and password.

**Command:**
```bash
docker login
```

After entering your credentials, you will see a **"Login Succeeded"** message confirming you are authenticated.

---

### Step 8: Build and Push the Image to Docker Hub

![Build and push the docker image](images/8%29Buildandpushthedockerimage.png)

To push an image to Docker Hub, the image name must follow the format `<username>/<repository>:<tag>`. We rebuild (or re-tag) the image with the correct name and then push it.

**Commands:**
```bash
docker build -t <your-dockerhub-username>/flask-app .
docker push <your-dockerhub-username>/flask-app
```

- `docker build -t <username>/flask-app .` — Tags the image with your Docker Hub username
- `docker push <username>/flask-app` — Uploads the image to Docker Hub

---

### Step 9: Verify the Image on Docker Hub

![Verify uploaded on Docker Hub](images/9%29VerofyUploadedonDockerHub.png)

After pushing, we verify that the image appears on Docker Hub by visiting the Docker Hub website. The image should be listed under your repositories. This means anyone can now pull and run your Flask app using:

```bash
docker pull jemy45/jimmy-flask-img-lab2:latest
```

---

## Part B: Custom Nginx Container with Network Configuration

### Task B Overview

The goal of Task B is to:
- Create a custom `index.html` page
- Create a Docker network for container communication
- Build a custom Nginx image that listens on port 8080 instead of the default port 80
- Test connectivity using `curl` on both port 80 and port 8080

---

### Step 10: Create the index.html File

![Task B - Create index.html file](images/10%29TaskbCreateIndex.htmlfile.png)

We create a simple HTML file that Nginx will serve. This custom page helps us verify that the web server is running and serving our content.

**File: index.html**
```html
<h1>Lab 2 ITI - Ahmed Gamal</h1>
```

---

### Step 11: Create the Docker Network

![Task B - Create the network](images/11%29TaskbCreateThenetwork.png)

We create a custom Docker network. A custom network allows containers to communicate with each other by name and gives us more control over the network configuration.

**Command:**
```bash
docker network create my-network
```

You can verify the network was created using:
```bash
docker network ls
```

Custom networks provide:
- **DNS resolution** — Containers can reach each other by name
- **Isolation** — Containers on different networks cannot communicate directly
- **Better control** — You can define subnets, gateways, and other settings

---

### Step 12: Create the Dockerfile for Nginx

![Task B - Dockerfile](images/12%29TaskBDockerfile.png)

We create a Dockerfile that builds a custom Nginx image. The key change is modifying the default Nginx configuration to listen on port **8080** instead of port **80** using the `sed` command.

**File: Dockerfile**
```dockerfile
# Use nginx alpine as base image (lightweight version of nginx)
FROM nginx:alpine
# Change the default port from 80 to 8080 in nginx default config file
RUN sed -i 's/80/8080/g' /etc/nginx/conf.d/default.conf
# Start nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]
```

**Key points:**
- `FROM nginx:alpine` — Uses the lightweight Alpine-based Nginx image
- `RUN sed -i 's/80/8080/g' /etc/nginx/conf.d/default.conf` — Uses `sed` (stream editor) to find every occurrence of `80` in the Nginx config and replace it with `8080`, effectively changing the listening port
- `CMD ["nginx", "-g", "daemon off;"]` — Starts Nginx in the foreground so the container stays running

---

### Step 13: Build and Run the Container

![Task B - Build and Run](images/13%29TaskBBuildandRun.png)

We build the custom Nginx image and run it on the custom network we created earlier.

**Commands:**
```bash
docker build -t custom-nginx .
docker run -d --name nginx-container --network my-network custom-nginx
```

- `-d` — Runs in detached mode
- `--name nginx-container` — Gives the container a recognizable name
- `--network my-network` — Connects the container to the custom network

---

### Step 14: Get Container IP and Test with Curl

![Task B - Get IP then curl on 80 and 8080](images/14%29TaskBgetipthencurlon80and8080.png)

Finally, we get the container's IP address and test the web server using `curl` on both port 80 and port 8080.

**Get the container IP:**
```bash
docker inspect webserver-iti | grep IPAdress
```

**Test on port 80 (should fail):**
```bash
curl <container-ip>:80
```

**Test on port 8080 (should succeed):**
```bash
curl <container-ip>:8080
```

- **Port 80** — The request will fail because we changed Nginx to listen on 8080 instead of 80
- **Port 8080** — The request will succeed and return the HTML content, proving the port change worked

This confirms that the Nginx configuration was successfully modified inside the container.

---

## Key Learnings

1. **Shell Scripting in Docker** — You can automate application setup inside a container using Bash scripts
2. **Alpine Base Image** — Using Alpine Linux keeps your images small and efficient
3. **Docker Hub** — You can push your custom images to Docker Hub so others can pull and use them
4. **Docker Networks** — Custom networks give containers DNS resolution and better isolation
5. **Port Configuration** — You can modify service configurations inside a container using tools like `sed`
6. **Resource Limits** — Use `--memory` to control how much memory a container can use
7. **Testing with Curl** — Use `curl` to verify that a web server is listening on the correct port

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `docker build -t <name> .` | Build an image from a Dockerfile |
| `docker run -d <image>` | Run a container in detached mode |
| `docker run --memory <size> <image>` | Run a container with a memory limit |
| `docker login` | Authenticate with Docker Hub |
| `docker push <image>` | Push an image to Docker Hub |
| `docker network create <name>` | Create a custom Docker network |
| `docker network ls` | List all Docker networks |
| `docker inspect <container>` | Get detailed container information |
| `docker stats` | Monitor real-time resource usage |
| `curl <ip>:<port>` | Test HTTP connectivity to a server |
| `chmod +x <file>` | Make a file executable |

---

## Conclusion

This task demonstrates two important Docker workflows. **Part A** shows how to containerize a Python Flask application, manage it with resource limits, and share it via Docker Hub. **Part B** shows how to customize Nginx configuration inside a container, work with Docker networks, and verify connectivity. These skills are essential for deploying and managing containerized applications in real-world environments.
