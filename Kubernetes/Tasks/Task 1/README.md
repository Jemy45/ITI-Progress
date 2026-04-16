# Kubernetes Task 1 - Setting Up a K3s Cluster with Server and Worker Nodes

This task demonstrates how to set up a Kubernetes cluster using K3s, join a worker node to a server node, and deploy an application with multiple replicas.

## Task Overview

The goal is to:
- Install K3s on two machines (server and worker)
- Join the worker node to the server node
- Label the worker node with a proper role
- Apply a deployment and verify that pods are distributed correctly

---

## Step 1: Worker Node Joined into the Server Successfully

![Worker joined into the server successfully](images/1%29Joined.png)

We set up two machines and installed K3s on the server node. Then we joined the worker node to the server using the node token and the server IP address.

**On the Server:**
```bash
curl -sfL https://get.k3s.io | sh -
```

Get the server IP and token needed to join workers:
```bash
ip add                                          # Get the server IP
cat /var/lib/rancher/k3s/server/node-token      # Get the node token
```

**On the Worker:**

First, verify connectivity to the server's API port:
```bash
curl -vk https://<SERVER_IP>:6443
```

If the connection fails, open the port on the firewall:
```bash
firewall-cmd --add-ports=6443/tcp
```

Then join the worker to the server:
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```

**Example with real values:**
```bash
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.65.5:6443 K3S_TOKEN=K10b93d85a186114fa990dbcb5408fba94b454b2b6c8387dcebd77d8a2a17d707b5::server:c2ec95ee84b83f7f80b809ec435285ae sh -
```

---

## Step 2: Deployment Worked Successfully and Created 3 Replicas of Pods

![Deployment worked successfully and created 3 replicas of pods](images/2%29Doneeee.png)

We applied the deployment YAML directly from a URL. This creates 3 replicas of the application pod across the cluster.

**Command:**
```bash
kubectl apply -f https://gist.githubusercontent.com/galal-hussein/9dc72ecada5fda0f7e0a8d0aaa595af1/raw/032e373f2b292176aa4df2d6b842983759359998/deployment.yaml
```

> **Note:** We didn't specify `nodeSelector` in this deployment.yaml, so Kubernetes scheduler decides which node will host each pod.

---

## Step 3: Verifying kubectl get nodes — Worker is Ready

![Verifying kubectl get nodes that worker is ready](images/3%29VERIFYK3SWORKERJOINED.png)

After the worker joins, we verify the cluster nodes. By default, the worker has no role label, so we assign it one manually.

**Verify nodes:**
```bash
kubectl get nodes
```

**Label the worker node with the `worker` role:**
```bash
kubectl label nodes worker node-role.kubernetes.io/worker=worker
```

> **Note:** This is only a label — it doesn't affect scheduling. You can use any name you prefer.

---

## Step 4: Verifying Pods Are Created and Distributed Across Nodes

![Verifying using kubectl get pods -o wide to see which worker contains the running pods](images/4%29Verifypodscreatedinwhichworker.png)

We verify the pods were created successfully and check which node each pod is running on using the `-o wide` flag.

**Command:**
```bash
kubectl get pods -o wide
```

---

## Key Concepts

### K3s vs kubeadm
- **kubeadm** is the traditional way to set up Kubernetes. It requires manual steps like applying a CNI plugin (e.g., Flannel).
- **K3s** is a lightweight Kubernetes distribution that handles CNI networking (Flannel) automatically — no manual setup required.

### What is Flannel?
Flannel is a CNI (Container Network Interface) — think of it as a massive, invisible virtual switch that connects all your servers so that Pods can communicate across nodes.

When a Pod on Node A tries to talk to a Pod on Node B using a virtual IP (e.g., `10.42.x.x`), the physical router would drop the traffic because those IPs don't exist on the real network. Flannel solves this by:
1. Intercepting the traffic from the Pod
2. Wrapping it in a digital envelope (encapsulation)
3. Writing the real physical IP of the destination node on the outside
4. Sending it across the real network
5. The Flannel on the destination node unwraps the envelope and delivers it to the correct Pod

> With **K3s**, Flannel is built-in and opens UDP port `8472` automatically. With **kubeadm**, you must apply it manually.

### `kubectl run` vs `kubectl apply`

| | `kubectl run` (Imperative) | `kubectl apply` (Declarative) |
|---|---|---|
| **How** | Pass all instructions in one command | Create a YAML config file and apply it |
| **Scope** | Creates a single Pod | Can create Deployments, Services, etc. |
| **Self-healing** | No — if the Pod dies, Kubernetes won't restart it | Yes — Kubernetes reconciles the cluster to match the YAML |
| **Use case** | Quick tests or network connectivity checks | Production workloads |

### What is a Nominated Node?
When you run `kubectl get pods -o wide`, you may see a **Nominated Node** column. This is used for **priority-based preemption**:
- If a high-priority Pod needs to be scheduled but all nodes are full, Kubernetes can **terminate lower-priority Pods** on a node to make room.
- The node selected for this eviction is shown as the "Nominated Node."
- Think of it like a restaurant where a VIP customer arrives and a regular customer must give up their table.

---

## Commands Reference

| Command | Description |
|---------|-------------|
| `curl -sfL https://get.k3s.io \| sh -` | Install K3s server |
| `curl -sfL https://get.k3s.io \| K3S_URL=... K3S_TOKEN=... sh -` | Join a worker to the server |
| `cat /var/lib/rancher/k3s/server/node-token` | Get the server node token |
| `kubectl get nodes` | List all cluster nodes |
| `kubectl label nodes <node> node-role.kubernetes.io/worker=worker` | Label a node with the worker role |
| `kubectl apply -f <url/file>` | Apply a Kubernetes manifest |
| `kubectl get pods` | List all pods |
| `kubectl get pods -o wide` | List pods with node placement details |
| `kubectl exec -it <pod> -- /bin/bash` | Open a shell inside a running pod |
| `firewall-cmd --add-ports=6443/tcp` | Open port 6443 on the firewall |

---

## Conclusion

This task successfully demonstrates how to set up a lightweight Kubernetes cluster using K3s, join a worker node, and deploy a multi-replica application. Using K3s simplifies the process by automating CNI networking (Flannel), making it ideal for learning and lightweight production environments.
