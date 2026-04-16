# TASK 3

## Part 1: DNS

### 1) Create a deployment named `web` with 2 replicas in namespace `iti`

```bash
kubectl create namespace iti
kubectl create deployment web --image=nginx --replicas=2 --namespace=iti --port=80
```

### 2) Expose the deployment as a NodePort service

```bash
kubectl expose deployment web --namespace=iti --port=5000 --target-port=80 --type=NodePort
```

**Pic 1: Verify the NodePort service creation and routing**  
![Pic 1 - Verify NodePort](images/1%29VerifyNodePort.png)

### 3) Enable SRV record generation by naming the service port

```bash
kubectl edit service -n iti web
```

Then add a name for the port:

```yaml
ports:
  - name: http
```

**Pic 2: Edit the `web` service to add a port name**  
![Pic 2 - Edit service port name](images/2%29EditTheNAMEOFPORT.png)

### 4) Create a test pod in the `default` namespace and verify DNS + curl

```bash
kubectl run nginx-test --image=nginx -n default
kubectl exec -it nginx-test -n default -- bash
apt update && apt install -y dnsutils curl
```

Now test DNS resolution and access the service by its domain name from inside the test pod.

**Pic 3: Verify DNS resolution and curl from a pod in `default` namespace**  
![Pic 3 - DNS and curl test](images/3%29TestDNSResolutionAndCurl.png)

---

## Part 2: Ingress and Services

### 1) Create namespace `iti-46`

```bash
kubectl create namespace iti-46
```

### 2) Create two deployments (`africa`, `europe`) with 2 replicas each

```bash
kubectl create deployment europe --image=husseingalal/europe:latest --replicas=2 --namespace=iti-46
kubectl create deployment africa --image=husseingalal/africa:latest --replicas=2 --namespace=iti-46
```

**Pic 4: Verify deployments and pods**  
![Pic 4 - Africa and Europe deployments](images/4%29CreateAfricaandEurope.png)

### 3) Create ClusterIP services for both deployments

```bash
kubectl expose deployment africa --port=8888 --target-port=80 --namespace=iti-46
kubectl expose deployment europe --port=8888 --target-port=80 --namespace=iti-46
```

**Pic 5: Verify services**  
![Pic 5 - Services verification](images/5%29Create2ServicesClusterIPForThem.png)

### 4) Add node IP to `/etc/hosts`

Add the master node IP with the domain:

```text
world.universe.mine
```

**Pic 6: Verify `/etc/hosts` entry**  
![Pic 6 - Add master IP to hosts](images/6%29addmasteripintohosts.png)

### 5) Create ingress `world` in namespace `iti-46`

```bash
kubectl create ingress world -n iti-46 \
  --rule="world.universe.mine/europe/=europe:8888" \
  --rule="world.universe.mine/africa/=africa:8888"
```

**Pic 7: Describe ingress and test curl**  
![Pic 7 - Ingress description and curl test](images/7%29Describeingressthatcreatedandtrycurl.png)

When applying this ingress and testing:

```bash
curl http://world.universe.mine/europe/
```

I sometimes got a **Bad Gateway** response. This appears to be related to the ingress controller behavior/configuration. I tested switching to NGINX ingress and middleware, and it worked at one point, but the same setup was not consistently reproducible. I am still investigating the root cause.

---

## Notes

### The StripPrefix Middleware Example

When you request `world.universe.mine/africa`, the pod may fail because it does not have an `/africa` path; it only serves the root path (`/`).

1. The request arrives as `/africa`.
2. The middleware intercepts the request.
3. The middleware strips (removes) `africa` from the path.
4. The middleware forwards a clean `/` path to the pod.
5. The pod serves `/` successfully and returns the webpage.

### How traffic reaches pods

When you open `http://world.universe.mine/africa/`:

1. Your machine uses `/etc/hosts` to resolve the domain to your master node IP.
2. The ingress controller on the master node receives the request and forwards it to the `africa` service.
3. The `africa` service load-balances across two pods (one on master, one on worker).
4. If the chosen pod is on the worker node, the master transparently routes traffic through the internal cluster network in milliseconds.

So, it does not matter whether you put the worker IP or master IP in `/etc/hosts` as long as traffic can reach the ingress endpoint.

### Ingress rule explanation (one sentence)

If a user visits `world.universe.mine` and requests `/europe/`, route that traffic to the internal service `europe` on port `8888`.

---

## Lab Questions (Reference)

### DNS
- Create deployment `web` in namespace `iti` with 2 replicas.
- Run app on port 80.
- Expose using NodePort service on port 5000.
- List SRV record and verify domain resolution.
- Create a test pod in `default`, exec into it, and reach the service by domain name.

### Ingress and services
- Create namespace `iti-46`.
- Create deployments `africa` and `europe` with 2 replicas each.
- Expose both using ClusterIP services on port 8888 (target port 80), same service names as deployments.
- Create ingress `world` for `world.universe.mine` with routes:
  - `http://world.universe.mine/europe/`
  - `http://world.universe.mine/africa/`
