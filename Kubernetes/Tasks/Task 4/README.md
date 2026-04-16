# Kubernetes Task 4

## Objective
This task covers:
- Persistent Volumes (PV) and PersistentVolumeClaims (PVC)
- Downward API with mounted content in NGINX
- ConfigMaps used as environment variables and mounted files

---

## 1) Persistent Volumes

Create a working directory and prepare the host file:

```bash
mkdir -p /root/task4
echo "Ahmed Gamal Mohamed - SA INTAKE 46" > /root/task4/index.html
```

Create PV and PVC manifests, then apply them:

```bash
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
```

Generate a deployment manifest using dry-run:

```bash
kubectl create deployment nginx-dep --image=nginx --replicas=3 --dry-run=client -o yaml > deployment.yaml
```

Edit `deployment.yaml` to:
- add `nodeSelector` so pods run on the worker node
- mount the volume in the container
- define a volume that uses your PVC

### Verification

- **Picture 1**: PV and PVC files content.  
  ![Verify PV and PVC manifests](images/1%29Verify%20Creating%20pv%20and%20pvc.png)

- **Picture 2**: Deployment YAML after mount and node selector edits.  
  ![Verify deployment YAML edits](images/2%29VerifyCreationofDeployment.png)

- **Picture 3**: Verification using `kubectl get pods -o wide`, `kubectl get pv,pvc`, `curl <pod-ip>`, and reading `index.html` from inside the pod.  
  ![Verify task 1 resources and content](images/3%29Verifythetask1issuccessfuly.png)

---

## 2) Downward API with PV/PVC

Create a manifest that contains both PV and PVC for the Downward API scenario:

```bash
kubectl apply -f pvandpvc.yaml
```

Create a deployment manifest with:
- proper mounting configuration
- Downward API data (pod name and pod IP) rendered into the mounted HTML content

```bash
kubectl apply -f deployment.yaml
```

### Verification

- **Picture 4**: `pvandpvc.yaml` content.  
  ![PV and PVC YAML for downward API](images/4%29PvandPVC.png)

- **Picture 5**: Deployment YAML with mounting and arguments.  
  ![Deployment YAML for downward API](images/5%29CreateDeploymentyaml.png)

- **Picture 6**: Verification of PV/PVC, pods, curl output, and HTML content that includes pod metadata from Downward API.  
  ![Downward API verification](images/6%29VerificationDownwardapi.png)

---

## 3) ConfigMaps

Create `/opt/cm.yaml`:

```yaml
apiVersion: v1
data:
  tree: birke
  level: "3"
  department: park
kind: ConfigMap
metadata:
  name: birke
```

Apply it:

```bash
kubectl apply -f /opt/cm.yaml
```

Create another ConfigMap:

```bash
kubectl create configmap trauerweide --from-literal=tree=trauerweide
```

Verify ConfigMaps:

```bash
kubectl get configmaps
```

Create pod manifest by dry-run:

```bash
kubectl run pod1 --image=nginx:alpine --dry-run=client -o yaml > task4-3-pod.yaml
```

Edit the pod manifest so that:
- key `tree` from ConfigMap `trauerweide` is exposed as env variable `TREE1`
- all keys from ConfigMap `birke` are mounted under `/etc/birke/*`

Then apply:

```bash
kubectl apply -f task4-3-pod.yaml
```

### Verification

- **Picture 7**: ConfigMaps created successfully.  
  ![Verify ConfigMaps](images/7%29Verifyconfigmaps.png)

- **Picture 8**: Pod YAML (`task4-3-pod.yaml`) content before apply.  
  ![Verify pod yaml](images/8%29VerifyPod1usingcatforitsyamlfle.png)

- **Picture 9**: Verification from inside the pod (`ls`, environment check with `grep`) showing expected values.  
  ![Verify env and mounted data inside pod](images/9%29Verifyusingexec%20for%20the%20environmentinside%20the%20pod.png)

---

## Lab Requirements Covered

### 1) Persistent Volumes
- Created `nginx-pv` with `hostPath` and 1Gi capacity
- Created a claim that binds to the PV
- Stored full name in host `index.html`
- Mounted the claim in an NGINX deployment with 3 replicas
- Scheduled replicas on the same node using `nodeSelector`

### 2) Downward API
- Created PV/PVC resources for this scenario
- Mounted data that includes `podIP` and `podName`
- Verified this information appears in `index.html`

### 3) ConfigMaps
- Created `/opt/cm.yaml` for ConfigMap `birke`
- Created ConfigMap `trauerweide` with `tree=trauerweide`
- Created `pod1` (`nginx:alpine`) with:
  - env variable `TREE1` from `trauerweide.tree`
  - mounted files from all keys of `birke` under `/etc/birke/*`

---

## Notes

- **PV reclaim policy:**  
  `Retain` keeps data after PVC deletion and is safer for important data. `Recycle` is deprecated in modern Kubernetes versions.

- **Access modes:**  
  If the same volume needs to be mounted by multiple pods, verify the storage backend and access mode support your design (`ReadWriteOnce`, `ReadOnlyMany`, `ReadWriteMany`).

- **Downward API use case:**  
  Downward API is useful when applications need runtime pod metadata (like pod name or IP) without calling the Kubernetes API directly.

- **ConfigMap best practice:**  
  Use environment variables for single keys and volume mounts for multi-key config files. This keeps application configuration clean and easier to update.
