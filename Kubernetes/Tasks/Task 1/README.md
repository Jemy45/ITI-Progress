# Kubernetes Task 1

## Objective
Set up a Kubernetes cluster with one server (control plane) and one worker node, then deploy an application and verify pod scheduling.

---

## Part 1: kubeadm Setup (Server + Worker)

For the kubeadm installation and initial cluster setup, I followed this guide:  
https://gist.github.com/galal-hussein/96ac1b9094198094dfea0a04f145c009

### Verification

- **Picture 1**: Worker node joined the server successfully.  
  ![Worker joined successfully](images/1%29Joined.png)

- **Picture 2**: Deployment worked successfully and created **3 pod replicas**.  
  ![Deployment with 3 replicas](images/2%29Doneeee.png)

---

## Part 2: k3s Setup (Alternative Method)

I also connected the worker to the server using **k3s** by following:  
https://docs.k3s.io/quick-start

To join the worker to the server, you need:
- The server IP
- The server node token

### Get Required Values on the Server

```bash
ip a
cat /var/lib/rancher/k3s/server/node-token
```

> ⚠️ Keep the node token private. It is sensitive and can be used to join new nodes to your cluster.

### Join Command on the Worker

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```

### Connectivity Check Before Joining

```bash
curl -vk https://<SERVER_IP>:6443
```

If this fails, open port **6443/tcp** in the firewall:

```bash
firewall-cmd --zone=public --add-port=6443/tcp
```

This rule is temporary (until reboot).

To keep it after reboot:

```bash
firewall-cmd --zone=public --permanent --add-port=6443/tcp
firewall-cmd --reload
```

After joining, verify nodes:

```bash
kubectl get nodes
```

If the worker has no role label, add one:

```bash
kubectl label nodes <worker-node-name> node-role.kubernetes.io/worker=worker
```

- **Picture 3**: Verification that the worker is joined and ready.  
  ![Worker ready in k3s](images/3%29VERIFYK3SWORKERJOINED.png)

---

## Networking Note (Flannel)

Flannel is a **CNI (Container Network Interface)** plugin that allows pods on different nodes to communicate.

- With **k3s**, Flannel is included by default.
- With **kubeadm**, you usually apply a CNI plugin manually.
- Flannel commonly uses **UDP port 8472**.

Flannel encapsulates pod traffic so packets can move across the real physical network between nodes.

---

## `kubectl run` vs `kubectl apply`

### `kubectl run` (Imperative)
- You provide instructions directly in one command.
- Typically used for quick testing.
- Usually creates a single pod.

### `kubectl apply` (Declarative)
- You define the desired state in a YAML file.
- Kubernetes continuously reconciles running resources with the YAML definition.
- Best for repeatable and production-style workflows.

---

## Apply the Deployment

```bash
kubectl apply -f https://gist.githubusercontent.com/galal-hussein/9dc72ecada5fda0f7e0a8d0aaa595af1/raw/032e373f2b292176aa4df2d6b842983759359998/deployment.yaml
```

This deployment does not define a `nodeSelector`, so Kubernetes decides where to place pods.

Verify with:

```bash
kubectl get pods
kubectl get pods -o wide
```

- **Picture 4**: Verification of which worker node is running the pods.  
  ![Pod placement verification](images/4%29Verifypodscreatedinwhichworker.png)

---

## Note: What is a Nominated Node?

A **nominated node** appears when Kubernetes is handling scheduling for a **high-priority pod** that may preempt lower-priority pods.

In simple terms:
- If resources are full and a high-priority pod must run,
- Kubernetes can terminate lower-priority pods,
- then schedule the high-priority pod on that node.

---

## Access NGINX Pod with `kubectl exec`

To open a shell inside an NGINX pod:

```bash
kubectl exec -it <nginx-pod-name> -- /bin/sh
```

Alternatively, you can use:

```bash
kubectl exec -it <nginx-pod-name> -- /bin/bash
```

---

## Task 1 Status

✅ **Task 1 completed successfully.**
