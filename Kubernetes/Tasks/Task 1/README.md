# Kubernetes Task 1

## Objective
Set up a cluster with one server and one worker, then deploy NGINX and verify pod scheduling.

---

## 1) kubeadm Setup (Server + Worker)

For the kubeadm setup steps, I followed this guide:  
https://gist.github.com/galal-hussein/96ac1b9094198094dfea0a04f145c009

### Verification

- **Picture 1**: Worker node joined the server successfully.  
  ![Worker joined successfully](images/1%29Joined.png)

- **Picture 2**: Deployment succeeded and created 3 pod replicas.  
  ![Deployment with 3 replicas](images/2%29Doneeee.png)

---

## 2) k3s Setup (Server + Worker)

I also connected the worker to the server using the k3s quick-start guide:  
https://docs.k3s.io/quick-start

To join a worker, you need:
- Server IP
- Server node token

Get them from the server:

```bash
ip a
cat /var/lib/rancher/k3s/server/node-token
```

Test API connectivity from the worker before joining:

```bash
curl -vk https://<SERVER_IP>:6443
```

If connectivity fails, open the Kubernetes API port:

```bash
firewall-cmd --zone=public --add-port=6443/tcp
```

Join the worker:

```bash
curl -sfL https://get.k3s.io | K3S_URL=https://<SERVER_IP>:6443 K3S_TOKEN=<NODE_TOKEN> sh -
```

Verify node status:

```bash
kubectl get nodes
```

If the worker has no role label, add one:

```bash
kubectl label nodes <worker-node-name> node-role.kubernetes.io/worker=worker
```

- **Picture 3**: Worker node is joined and in `Ready` state.  
  ![Worker ready in k3s](images/3%29VERIFYK3SWORKERJOINED.png)

---

## 3) Deploy and Verify Workload

Apply the deployment:

```bash
kubectl apply -f https://gist.githubusercontent.com/galal-hussein/9dc72ecada5fda0f7e0a8d0aaa595af1/raw/032e373f2b292176aa4df2d6b842983759359998/deployment.yaml
```

Because no `nodeSelector` is defined, Kubernetes chooses the node automatically.

Verify pod placement:

```bash
kubectl get pods
kubectl get pods -o wide
```

- **Picture 4**: Pod distribution and running node details.  
  ![Pod placement verification](images/4%29Verifypodscreatedinwhichworker.png)

---

## Notes

- **Flannel in k3s:**  
  Flannel is a CNI plugin that enables pod-to-pod communication across nodes. In k3s, it is included by default. In kubeadm clusters, you usually install a CNI manually. Flannel commonly uses UDP port `8472`.

- **Why Flannel matters:**  
  Pod IP ranges are virtual and not directly routable on the physical network. Flannel encapsulates pod traffic and forwards it to the correct node, where it is delivered to the target pod.

- **`kubectl run` vs `kubectl apply`:**
  - `kubectl run` is imperative and usually used for quick tests.
  - `kubectl apply` is declarative and keeps resources aligned with YAML definitions.

- **Nominated node concept:**  
  A nominated node appears when Kubernetes prepares placement for a high-priority pod, potentially preempting lower-priority pods if needed.

- **Access NGINX container:**

  ```bash
  kubectl exec -it <nginx-pod-name> -- /bin/sh
  ```