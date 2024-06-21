<#---
title: Developer Access
---

To create a minimum privileges access to a Kubernetes cluster running in Azure, using Azure credentials, follow these steps:

### Step 1: Create an Azure AD Group and User

1. **Create an Azure AD Group:**
   - Go to the Azure portal.
   - Navigate to **Azure Active Directory** > **Groups**.
   - Click on **New group**.
   - Enter the required information and create the group.

2. **Create or identify an Azure AD User:**
   - Go to **Azure Active Directory** > **Users**.
   - Ensure you have a user that you want to assign to the group created above. If not, create a new user.

3. **Add User to the Group:**
   - Go to the group created in step 1.
   - Under the **Members** section, click **Add members**.
   - Select the user and add them to the group.

### Step 2: Configure Kubernetes RBAC (Role-Based Access Control)

1. **Create a Namespace:**
   - Use `kubectl` to create a namespace if it doesn't already exist.
     ```bash
     kubectl create namespace <namespace-name>
     ```

2. **Create a Role:**
   - Create a YAML file (e.g., `role.yaml`) defining the Role that allows access to the specific service.
     ```yaml
     apiVersion: rbac.authorization.k8s.io/v1
     kind: Role
     metadata:
       namespace: <namespace-name>
       name: port-forward-role
     rules:
     - apiGroups: [""]
       resources: ["pods"]
       verbs: ["get", "list"]
     ```

3. **Create a RoleBinding:**
   - Create a YAML file (e.g., `rolebinding.yaml`) to bind the Role to the user.
     ```yaml
     apiVersion: rbac.authorization.k8s.io/v1
     kind: RoleBinding
     metadata:
       name: port-forward-rolebinding
       namespace: <namespace-name>
     subjects:
     - kind: User
       name: "<azure-ad-user-email>"  # The Azure AD user email
       apiGroup: rbac.authorization.k8s.io
     roleRef:
       kind: Role
       name: port-forward-role
       apiGroup: rbac.authorization.k8s.io
     ```

4. **Apply the Role and RoleBinding:**
   ```bash
   kubectl apply -f role.yaml
   kubectl apply -f rolebinding.yaml
   ```

### Step 3: Configure Azure AD Integration with Kubernetes

1. **Enable Azure AD Integration in AKS:**
   - Ensure your AKS cluster is integrated with Azure AD. If not, follow the [Azure AD integration documentation](https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli).

2. **Assign Azure Role:**
   - Assign the user to the Azure Kubernetes Service Cluster User role:
     ```bash
     az role assignment create --assignee <azure-ad-user-id> --role "Azure Kubernetes Service Cluster User Role" --scope /subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.ContainerService/managedClusters/<aks-cluster-name>
     ```

### Step 4: Configure kubectl for Azure AD Authentication

1. **Install Azure CLI and kubectl:**
   - Ensure you have the Azure CLI and `kubectl` installed.

2. **Login to Azure CLI:**
   ```bash
   az login
   ```

3. **Get AKS Credentials:**
   ```bash
   az aks get-credentials --resource-group <resource-group-name> --name <aks-cluster-name>
   ```

4. **Test Access:**
   - The user can now use `kubectl` to port-forward to the specific service within the namespace they have access to:
     ```bash
     kubectl port-forward svc/<service-name> -n <namespace-name> <local-port>:<service-port>
     ```

By following these steps, you ensure that the given user has the minimum privileges needed to access only the specified namespace and service, and can perform port forwarding using `kubectl`.

#>