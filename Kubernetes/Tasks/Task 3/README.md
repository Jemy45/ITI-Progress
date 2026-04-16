# Kubernetes Task 3

This README documents Task 3 with a clean flow and corrected English, based on the provided lab requirements.

---

## 1) DNS Task

### Step A: Create the namespace

```bash
kubectl create namespace iti
```

### Step B: Create the deployment (`web`) with 2 replicas

```bash
kubectl create deployment web --image=nginx --replicas=2 --namespace=iti --port=80
```

### Step C: Expose the deployment as a NodePort service

```bash
kubectl expose deployment web --namespace=iti --port=5000 --target-port=80 --type=NodePort
```

- **Picture 1**: Verify NodePort service creation and routing.  
  ![Verify NodePort service](images/1%29VerifyNodePort.png)

### Step D & E: Enable SRV record generation by naming the service port

Edit the service:

```bash
kubectl edit service -n iti web
```

Add a name for the port (for example `http`).

- **Picture 2**: Service updated with named port.  
  ![Edit service port name](images/2%29EditTheNAMEOFPORT.png)

### Step F: Test DNS and connectivity from another pod in `default`

```bash
kubectl run nginx-test --image=nginx
kubectl exec -it nginx-test -- bash
apt update && apt install -y dnsutils
```

Then test DNS resolution and curl from inside the test pod.

- **Picture 3**: DNS resolution and curl verification from external pod.  
  ![Test DNS resolution and curl](images/3%29TestDNSResolutionAndCurl.png)

---

## 2) Ingress and Services Task

### Step A: Create namespace `iti-46`

```bash
kubectl create namespace iti-46
```

### Step B: Create `europe` and `africa` deployments (2 replicas each)

```bash
kubectl create deployment europe --image=husseingalal/europe:latest --replicas=2 --namespace=iti-46
kubectl create deployment africa --image=husseingalal/africa:latest --replicas=2 --namespace=iti-46
```

### Step C: Verify deployments and pods

```bash
kubectl get deploy -n iti-46
kubectl get pods -n iti-46
```

### Step D: Expose both deployments as ClusterIP services

```bash
kubectl expose deployment africa --port=8888 --target-port=80 --namespace=iti-46
kubectl expose deployment europe --port=8888 --target-port=80 --namespace=iti-46
```

> Note: In this README, port `5000` is the service port used for the first DNS exercise (`web` in `iti`), while port `8888` is used for the second Ingress exercise (`africa` and `europe` in `iti-46`) to match the lab instructions.

### Step E: Verify services

```bash
kubectl get svc -n iti-46
```

### Step F: Add domain mapping in `/etc/hosts`

Map `world.universe.mine` to your Kubernetes node IP (master or worker).

Example:

```bash
echo "<NODE_IP> world.universe.mine" | sudo tee -a /etc/hosts
```

### Step G: Create ingress `world`

Before creating ingress, make sure an ingress controller is installed and running (for example NGINX Ingress Controller):

```bash
kubectl get pods -n ingress-nginx
```

```bash
kubectl create ingress world -n iti-46 --rule="world.universe.mine/europe/=europe:8888" --rule="world.universe.mine/africa/=africa:8888"
```

Then test:

```bash
curl http://world.universe.mine/europe/
curl http://world.universe.mine/africa/
```

> Note: If you get `Bad Gateway` or `404`, check that your ingress controller is running (for example, `kubectl get pods -n ingress-nginx`) and confirm that route handling matches your app path behavior.

---

## Notes

### StripPrefix middleware idea

When you request `world.universe.mine/africa`, the app may fail because it expects `/` and not `/africa`.

Flow:
1. Request arrives as `/africa`.
2. Middleware intercepts the request.
3. Middleware removes (`strips`) the `/africa` prefix.
4. The pod receives `/`.
5. The app serves the page successfully.

### Traffic flow with `/etc/hosts`

When you open `http://world.universe.mine/africa/`:

1. Your machine uses `/etc/hosts` to resolve the domain to a Kubernetes node IP.
2. The ingress controller on that node receives the request.
3. It forwards the request to the `africa` service.
4. The service load-balances to one of the `africa` pods.
5. If the selected pod is on another node, Kubernetes routes the traffic internally.

So, using the master IP or a worker IP in `/etc/hosts` can both work (as long as ingress is reachable there).

### Ingress rule explanation (one sentence)

If a user visits `world.universe.mine/europe/`, the ingress routes that request to the internal `europe` service on port `8888`.

---

## Lab Requirements Coverage

- DNS deployment and NodePort service in namespace `iti` ✅  
- SRV generation prerequisite (named service port) ✅  
- DNS + curl test from another pod in `default` namespace ✅  
- `iti-46` namespace with `africa` and `europe` deployments ✅  
- ClusterIP services on port `8888` targeting container port `80` ✅  
- Ingress `world` with `/europe/` and `/africa/` routes ✅
