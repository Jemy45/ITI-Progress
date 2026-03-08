# Docker Task 3 - Private Registry, Docker Compose & Nginx Reverse Proxy

This task is split into three parts. **Task A** covers setting up a private Docker registry, building a custom Nginx image, and pushing/pulling it from the private registry. **Task B** covers using Docker Compose to deploy a full WordPress application with a MySQL database. **Task C** covers building a Flask app with an Nginx reverse proxy using Docker Compose and a private registry.

---

## Part A: Private Docker Registry & Custom Nginx Image

### Task A Overview

The goal of Task A is to:
- Create a private Docker registry running locally
- Build a custom Nginx image with a personalized index page
- Push the image to the private registry
- Verify the registry works by removing the local image, pulling it back, and running it

---

### Step 1: Create the Private Registry

![Task A - Create Registry](images/1%29TaskA-CreateRegistry.png)

We start by running a local Docker registry container. A private registry allows you to store and distribute Docker images within your own infrastructure without relying on Docker Hub.

**Command:**
```bash
docker run -d -p 5000:5000 --name registry registry:2
```

- `-d` — Runs the container in detached (background) mode
- `-p 5000:5000` — Maps port 5000 on the host to port 5000 inside the container
- `--name registry` — Names the container "registry" for easy reference
- `registry:2` — Uses the official Docker Registry v2 image

You can verify the registry is running using:
```bash
docker ps
```

---

### Step 2: Create the Dockerfile for Custom Nginx

![Task A - Create Dockerfile for simple nginx alpine](images/2%29TaskA-CreateDockerfileforsimplenginxalpine.png)

We create a Dockerfile that builds a custom Nginx image based on Alpine Linux. This image serves a personalized HTML page.

**File: Dockerfile**
```dockerfile
# Use base image of nginx alpine
FROM nginx:alpine

# Add a custom index page
RUN echo "<h1>Ahmed Gamal-ITI-SA-46</h1>" > /usr/share/nginx/html/index.html

# Start nginx in the foreground to keep the container running
CMD ["nginx", "-g", "daemon off;"]
```

**Key points:**
- `FROM nginx:alpine` — Uses the lightweight Alpine-based Nginx image
- `RUN echo "<h1>...</h1>" > /usr/share/nginx/html/index.html` — Replaces the default Nginx welcome page with a custom HTML page
- `CMD ["nginx", "-g", "daemon off;"]` — Starts Nginx in the foreground so the container stays running

---

### Step 3: Build and Push the Image to the Private Registry

![Task A - Build and Push the nginx into private registry](images/3%29TaskABuildandPushthenginxintoprivateregistry.png)

We build the custom Nginx image and tag it with the private registry address (`localhost:5000`), then push it to our local registry.

**Commands:**
```bash
docker build -t localhost:5000/custom-nginx .
docker push localhost:5000/custom-nginx
```

- `docker build -t localhost:5000/custom-nginx .` — Builds the image and tags it for the private registry
- `docker push localhost:5000/custom-nginx` — Pushes the image to the local registry running on port 5000

The image name must follow the format `<registry-address>/<image-name>` for Docker to know where to push it.

---

### Step 4: Verify by Removing and Pulling the Image

![Task A - Verify that is in registry by remove then pull it](images/4%29TaskAVerifythatisinregistrybyremovethenpullit.png)

To confirm the image was successfully stored in the private registry, we remove the local copy and pull it back from the registry.

**Commands:**
```bash
docker rmi localhost:5000/custom-nginx
docker pull localhost:5000/custom-nginx
```

- `docker rmi` — Removes the local image
- `docker pull` — Downloads the image from the private registry

If the pull succeeds, it proves the image is properly stored in our private registry and can be distributed to any machine that has access to it.

---

### Step 5: Run the Pulled Image

![Task A - Verify that pulled image not in use then run it](images/5%29TaskAVerifythatpulledimagenotinusethenrunit.png)

Finally, we verify the pulled image works correctly by running it as a container.

**Command:**
```bash
docker run -d -p 80:80 localhost:5000/custom-nginx
```

- `-d` — Runs in detached mode
- `-p 80:80` — Maps port 80 on the host to port 80 inside the container

You can verify it's working by visiting `http://localhost` in your browser or using:
```bash
curl localhost
```

This should return the custom HTML page: `<h1>Ahmed Gamal-ITI-SA-46</h1>`

---

## Part B: WordPress & MySQL with Docker Compose

### Task B Overview

The goal of Task B is to:
- Write a Docker Compose file to deploy WordPress and MySQL together
- Configure environment variables for database connectivity
- Use a volume to persist MySQL data
- Access the WordPress site from the browser

---

### Step 6: Create the Docker Compose File

![Task B - Create Docker compose file](images/6%29%20Task%20B-%20Create%20Docker%20compose%20file.png)

We create a `compose.yaml` file that defines two services: **WordPress** and **MySQL**. Docker Compose allows us to define and run multi-container applications with a single file.

**File: compose.yaml**
```yaml
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    depends_on:
      - db

  db:
    image: mysql:5.7
    environment:
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - /var/lib/mysql:/var/lib/mysql
```

**Key points:**
- **wordpress service:**
  - `image: wordpress:latest` — Uses the official WordPress image
  - `ports: "8080:80"` — Maps port 8080 on the host to port 80 inside the container
  - `environment` — Configures WordPress to connect to the MySQL database using the service name `db` as the host
  - `depends_on: db` — Ensures MySQL starts before WordPress

- **db service:**
  - `image: mysql:5.7` — Uses MySQL 5.7 for compatibility with WordPress
  - `environment` — Sets up the database name, user, password, and root password
  - `volumes` — Persists MySQL data to the host filesystem so data survives container restarts

---

### Step 7: Start the Compose Stack and Verify

![Task B - Up the docker compose and verify it](images/7%29Task%20B%20-%20Up%20the%20docker%20compose%20and%20verify%20it%20.png)

We use `docker compose up` to start both services defined in the compose file.

**Command:**
```bash
docker compose up -d
```

- `up` — Creates and starts all the services defined in the compose file
- `-d` — Runs in detached (background) mode

You can verify both containers are running using:
```bash
docker compose ps
```

Once both services are up, you can access WordPress by visiting `http://localhost:8080` in your browser. WordPress will guide you through the initial setup wizard.

To stop and remove the containers:
```bash
docker compose down
```

---

## Part C: Flask App with Nginx Reverse Proxy via Docker Compose

### Task C Overview

The goal of Task C is to:
- Build a Flask application image and push it to the private registry
- Create an Nginx reverse proxy configuration to forward traffic to the Flask app
- Write a Docker Compose file that orchestrates both services
- Verify end-to-end connectivity through the Nginx proxy and directly to Flask

---

### Step 8: Build and Push the Flask Image to the Private Registry

![Task C - Build and Push the image on private registry](images/8%29Task%20C-%20Build%20and%20Push%20the%20image%20on%20private%20registry.png)

We reuse the Flask application from the previous task. We build the image using the same Dockerfile and shell script, then push it to our private registry.

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

**File: run_flask.sh**
```bash
#!/bin/bash

# Navigate to the task2 directory
cd "/media/jimmy/Data/ITIContent/Docker/task 2"

# Clone the repository
echo "Cloning repository..."
git clone https://github.com/Jemy45/basic-flask-app

# Navigate to the application directory
cd basic-flask-app

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

**Commands:**
```bash
docker build -t localhost:5000/lab3c-flask-img-on-priv-reg .
docker push localhost:5000/lab3c-flask-img-on-priv-reg
```

- The image is tagged with `localhost:5000/lab3c-flask-img-on-priv-reg` so it can be pushed to and pulled from the private registry
- This makes the image available for the Docker Compose setup in the next step

---

### Step 9: Create the Docker Compose File

![Task C - Create the compose file have flask and nginx](images/9%29Task%20C-%20Create%20the%20composefilehaveflaskandnginx.png)

We create a `compose.yaml` that defines two services: the **Flask app** (pulled from the private registry) and an **Nginx reverse proxy** that forwards incoming traffic to the Flask app.

**File: compose.yaml**
```yaml
services:
  # Flask app pulled from the private registry (localhost:5000)
  flask-app:
    image: localhost:5000/lab3c-flask-img-on-priv-reg
    container_name: lab3c-flask-app
    ports:
      - "8080:5000"
    mem_limit: 100m

  # Nginx reverse proxy in front of the Flask app, published on port 80
  nginx:
    image: nginx:alpine
    container_name: nginx-proxy
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - flask-app
```

**Key points:**
- **flask-app service:**
  - `image: localhost:5000/lab3c-flask-img-on-priv-reg` — Pulls the Flask image from the private registry
  - `container_name: lab3c-flask-app` — Sets a specific container name (used in the Nginx config for proxying)
  - `ports: "8080:5000"` — Maps port 8080 on the host to port 5000 inside the container for direct access
  - `mem_limit: 100m` — Limits memory usage to 100MB

- **nginx service:**
  - `image: nginx:alpine` — Uses the official lightweight Nginx image
  - `container_name: nginx-proxy` — Names the container for easy identification
  - `ports: "80:80"` — Exposes Nginx on port 80
  - `volumes` — Mounts the custom `nginx.conf` file into the container, replacing the default Nginx configuration
  - `depends_on: flask-app` — Ensures the Flask app starts before Nginx

---

### Step 10: Create the Nginx Reverse Proxy Configuration

![Task C - Create nginx configure file rather than the main default config](images/10%29Task%20C-Create%20nginx%20configure%20file%20rather%20than%20the%20main%20defaultconfig.png)

We create a custom Nginx configuration file that acts as a reverse proxy, forwarding all incoming HTTP requests on port 80 to the Flask application on port 5000.

**File: nginx.conf**
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html;
    server_name _;

    location / {
           proxy_pass http://lab3c-flask-app:5000/;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
    }
}
```

**Key points:**
- `listen 80 default_server` — Listens on port 80 for all incoming HTTP traffic
- `server_name _` — Catches all hostnames (acts as a wildcard)
- `proxy_pass http://lab3c-flask-app:5000/` — Forwards requests to the Flask container using its **container name** as the hostname. Docker Compose creates a shared network where containers can resolve each other by name
- `proxy_http_version 1.1` — Uses HTTP/1.1 for the proxy connection
- `proxy_set_header` directives — Passes important headers from the client to the backend Flask app, preserving the original request information

---

### Step 11: Start the Compose Stack and Verify Containers

![Task C - Verify compose up and see the containers](images/11%29%20Task%20C-Verify%20compose%20up%20and%20see%20the%20containers.png)

We start both services using Docker Compose and verify that the containers are running.

**Commands:**
```bash
docker compose up -d
docker compose ps
```

- `docker compose up -d` — Creates and starts all services in detached mode
- `docker compose ps` — Lists all running containers managed by this Compose file

Both the `lab3c-flask-app` and `nginx-proxy` containers should be running, with ports `8080` and `80` exposed respectively.

---

### Step 12: Verify End-to-End Connectivity

![Task C - Verify that the site is working via nginx and also via flask directly](images/12%29Task%20C-%20Verify%20that%20the%20site%20is%20working%20via%20nginx%20and%20also%20via%20flask%20directly.png)

Finally, we verify the setup by testing both access paths:

**Test via Nginx Reverse Proxy (port 80):**
```bash
curl localhost
```

**Test via Flask directly (port 8080):**
```bash
curl localhost:8080
```

- **Port 80** — The request hits Nginx, which proxies it to the Flask app on port 5000. The response confirms the reverse proxy is working correctly.
- **Port 8080** — The request goes directly to the Flask app, bypassing Nginx. This confirms the Flask app is running independently.

Both should return the Flask application's response, proving that:
1. The Flask app was successfully pulled from the private registry
2. The Nginx reverse proxy is correctly forwarding traffic
3. Docker Compose is orchestrating both services seamlessly

---

## Key Learnings

1. **Private Docker Registry** — You can run your own registry to store and distribute images without relying on Docker Hub, giving you full control over your image distribution
2. **Docker Compose** — Compose simplifies multi-container deployments by defining all services, networks, and volumes in a single YAML file
3. **Reverse Proxy with Nginx** — Nginx can act as a reverse proxy, forwarding client requests to backend services, which is a common production pattern
4. **Container Networking in Compose** — Docker Compose automatically creates a shared network where containers can communicate using their service or container names as hostnames
5. **Private Registry Integration with Compose** — You can pull images from a private registry directly in a Compose file by specifying the full registry address in the image field
6. **Memory Limits in Compose** — Resource constraints like `mem_limit` can be set directly in the Compose file for each service
7. **Volume Mounts for Configuration** — Mounting config files (like `nginx.conf`) into containers allows you to customize service behavior without building a new image
8. **WordPress Stack Deployment** — A full-stack WordPress application with a MySQL backend can be deployed in seconds using Docker Compose

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `docker run -d -p 5000:5000 --name registry registry:2` | Start a private Docker registry |
| `docker build -t localhost:5000/<name> .` | Build and tag an image for the private registry |
| `docker push localhost:5000/<name>` | Push an image to the private registry |
| `docker pull localhost:5000/<name>` | Pull an image from the private registry |
| `docker rmi <image>` | Remove a local Docker image |
| `docker compose up -d` | Start all services defined in compose.yaml |
| `docker compose down` | Stop and remove all Compose services |
| `docker compose ps` | List running Compose services |
| `curl localhost` | Test HTTP connectivity to localhost |
| `curl localhost:<port>` | Test HTTP connectivity on a specific port |

---

## Architecture Overview

```
                    ┌─────────────────────────────────────────────┐
                    │            Docker Compose Network           |
                    │                                             |
 User Request       │  ┌─────────────┐      ┌─────────────────┐   │
 ──────────────────►│  │   Nginx     │      │   Flask App     │   │
  Port 80           │  │  (Reverse   │─────►│  (Python App)   │   │
                    │  │   Proxy)    │ :5000 │                │   │
                    │  │  Port 80    │      │  Port 5000      │   │
                    │  └─────────────┘      └─────────────────┘   │
                    │                              ▲              │
                    └──────────────────────────────│──────────────┘
                                                   │
 Direct Access ────────────────────────────────────┘
  Port 8080

                    ┌──────────────────┐
                    │  Private Registry│
                    │  localhost:5000  │
                    │  (registry:2)    │
                    └──────────────────┘
```

---

## Conclusion

This task demonstrates three essential Docker workflows for real-world deployments. **Part A** shows how to set up and use a private Docker registry for storing and distributing images internally. **Part B** demonstrates the power of Docker Compose by deploying a complete WordPress application with a MySQL database in a single command. **Part C** brings it all together by orchestrating a Flask application with an Nginx reverse proxy, pulling images from the private registry and managing the entire stack with Docker Compose. These skills form the foundation for building, deploying, and managing containerized applications in production environments.
