---
title: Nexiintra Operations
description: This repository is designed to support a GitOps configuration, where each service's manifest resides in the repo. GitOps is a modern approach to continuous deployment, using Git as a single source of truth for declarative infrastructure and application configurations.
---

### Project Structure Overview

The repository contains various folders and files essential for operating the MagicBox in Nexi Group:

- **.devcontainer**: Configuration files for development containers.
- **.github/workflows**: GitHub Actions workflows for CI/CD.
- **.vscode**: Visual Studio Code settings.
- **00-health, 10-setup, 60-provision, 80-health, 85-Manifests, 90-setup**: Directories with PowerShell scripts (.ps1) for different operational tasks.

### Focus on PowerShell Scripts

#### Key PowerShell Scripts:

- **10-setup/10-web.ps1**: This script sets up the web environment, including configurations and dependencies.
- **60-provision/10-web.ps1**: This script handles the deployment to Kubernetes.

#### Deep Dive into `60-provision/10-web.ps1`

The `60-provision/10-web.ps1` script is designed to deploy the web application to a Kubernetes cluster. Here are the key steps it performs:

1. **Path Setup**: Determines the correct path to the `koksmat.json` configuration file.
2. **Configuration Loading**: Loads and parses `koksmat.json` to extract version, port, app name, image name, and DNS name.
3. **Kubernetes Manifest Generation**: Constructs a Kubernetes manifest for PersistentVolumeClaim, Deployment, Service, and Ingress based on the loaded configuration.
4. **Deployment**: Applies the generated Kubernetes manifest using `kubectl`.

### Summary of the `koksmat.json` File

- **version**: Application version details.
- **appname**: Name of the application.
- **dnsprod**: Production DNS name.
- **imagename**: Docker image name.
- **port**: Application port.

### Example Configuration from `60-provision/10-web.ps1`

```powershell
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-$appname
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: azurefile
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $appname
spec:
  selector:
    matchLabels:
      app: $appname
  replicas: 1
  template:
    metadata:
      labels:
        app: $appname
    spec:
      containers:
      - name: $appname
        image: $image
        ports:
          - containerPort: $port
        env:
        - name: NATS
          value: nats://nats:4222
        - name: DATAPATH
          value: /data
        volumeMounts:
        - mountPath: /data
          name: data
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: pvc-$appname
---
apiVersion: v1
kind: Service
metadata:
  name: $appname
  labels:
    app: $appname
    service: $appname
spec:
  ports:
  - name: http
    port: 5301
    targetPort: $port
  selector:
    app: $appname
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: $appname
spec:
  rules:
  - host: $dnsname
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: $appname
            port:
              number: 5301
```

This script ensures that the application is deployed with the necessary storage, deployment configuration, and accessible through the specified DNS.
