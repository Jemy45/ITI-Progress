# Kubernetes Task 2

## Objective
In this task, I worked on three main topics:
- Configuring `kubectl` context with a custom namespace
- Creating a custom kubectl plugin
- Generating and applying a deployment YAML with replicas and environment variables

---

## 1) Kubectl Config and Context

As in Task 1, the cluster has:
- 1 server (control plane)
- 1 worker (agent)

### a) Create namespace `iti-46`

```bash
kubectl create namespace iti-46
```

### b) Review k3s kubeconfig location

In k3s, kubeconfig is usually stored at:

`/etc/rancher/k3s/k3s.yaml`

You can inspect config and contexts using:

```bash
kubectl config view
kubectl config get-contexts
```

### c) Create a new context for the new namespace

```bash
kubectl config set-context iti-context --cluster=default --user=default --namespace=iti-46
```

Then switch to it:

```bash
kubectl config use-context iti-context
```

### Verification

- **Picture 1**: Namespace `iti-46` created and context added successfully.  
  ![Verify namespace and context creation](images/1%29VerifyNSCreatedandContextcreated.png)

- **Picture 2**: `kubectl config view` confirms the new context and specs.  
  ![Verify context details in kubeconfig](images/2%29Verifybycattheyamlfileofk3s.png)

---

## 2) Create a Kubectl Plugin (`kubectl hostnames`)

Create a plugin file:

```bash
vim /usr/local/bin/kubectl-hostnames
```

Add this content:

```bash
#!/bin/sh
kubectl describe nodes | grep Hostname
```

Make it executable:

```bash
chmod a+x /usr/local/bin/kubectl-hostnames
```

Now you can run:

```bash
kubectl hostnames
```

### Verification

- **Picture 3**: Plugin works and shows hostnames of all nodes.  
  ![Verify kubectl hostnames plugin](images/3%29VerifyingThePluginofHostnames.png)

---

## 3) Create and Apply Deployment YAML

Generate deployment YAML using dry-run:

```bash
kubectl create deployment nginx-dep --image=nginx:alpine --dry-run=client -o yaml > nginx-deployment.yaml
```

Edit the generated file:
- Change `replicas` from `1` to `3`
- Add environment variable: `FOO=ITI`

### Verification of YAML

- **Picture 4**: YAML file after setting replicas and environment variable.  
  ![Deployment YAML with replicas and env](images/4%29Createyamlfileandmakereplicas3andADDENVIRONMT.png)

Apply the deployment:

```bash
kubectl apply -f nginx-deployment.yaml
```

Verify deployment and pods:

```bash
kubectl get deployments
kubectl get pods
```

- **Picture 5**: Deployment and pods created successfully.  
  ![Verify deployments and pods](images/5%29Kubectlgetdeploymentsandpods.png)

Check the environment variable inside a pod:

```bash
kubectl exec -it <nginx-pod-name> -- /bin/sh
echo $FOO
```

- **Picture 6**: `FOO` is available inside the pod and prints `ITI`.  
  ![Verify environment variable inside pod](images/6%29ChecktheENVinPOD.png)


## Notes

### What is a Context in Kubernetes?
A context is a convenient profile that bundles:
- **Cluster**
- **User**
- **Namespace**

It tells `kubectl` where to send commands and under which identity/namespace they should run.

### `dry-run` modes

- `--dry-run=none` (default)  
  The request is processed normally and resources are actually created.

- `--dry-run=client`  
  Generates the resource definition locally without sending it to the API server.  
  This is very useful for drafting YAML files.

- `--dry-run=server`  
  Sends the request to the API server for validation and permission checks, but does not persist the resource.  
  Useful for pre-flight validation.

Example:

```bash
kubectl create namespace iti-46 --dry-run=server
```

If the namespace already exists, Kubernetes reports it during validation.