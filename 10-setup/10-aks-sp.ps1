<#---
title: 
---
#>

az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/$($env:AZURE_SUBSCRIPTION_ID)/resourceGroups/$($env:AZURE_RESOUREGROUP_NAME)/providers/Microsoft.ContainerService/managedClusters/magicbox-prod 
<#
## Documentation
To log in to Azure CLI using GitHub Actions, you need to create an Azure service principal and store its credentials as secrets in your GitHub repository. Here's how to do it:

### Step 1: Create an Azure Service Principal

1. **Open Azure Cloud Shell**: You can do this from the Azure portal by clicking on the Cloud Shell icon.
2. **Create the Service Principal**:
   Run the following command to create a service principal. Replace `YOUR_AZURE_RG` and `YOUR_AZURE_AKS` with your resource group and AKS cluster names.

   ```sh
   az ad sp create-for-rbac --name "github-actions-sp" --role contributor \
       --scopes /subscriptions/YOUR_SUBSCRIPTION_ID/resourceGroups/YOUR_AZURE_RG/providers/Microsoft.ContainerService/managedClusters/YOUR_AZURE_AKS \
       --sdk-auth
   ```

3. **Output**:
   This command will output a JSON object containing the service principal credentials. It will look something like this:

   ```json
   {
     "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "clientSecret": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "subscriptionId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "tenantId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
     "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
     "resourceManagerEndpointUrl": "https://management.azure.com/",
     "activeDirectoryGraphResourceId": "https://graph.windows.net/",
     "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
     "galleryEndpointUrl": "https://gallery.azure.com/",
     "managementEndpointUrl": "https://management.core.windows.net/"
   }
   ```

### Step 2: Add the Service Principal Credentials to GitHub Secrets

1. **Go to Your GitHub Repository**: Navigate to the repository where you want to set up the GitHub Actions workflow.
2. **Settings**: Go to `Settings` > `Secrets` > `New repository secret`.
3. **Add Secrets**:
   - **Name**: `AZURE_CREDENTIALS`
   - **Value**: Paste the JSON output from the Azure CLI command.

### Step 3: Update the GitHub Actions Workflow

Now, ensure that your GitHub Actions workflow uses these credentials to log in to Azure CLI. Here's the updated part of the workflow file:

```yaml
name: Canary Release

on:
  push:
    branches:
      - canary

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v2

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v1

    - name: Log in to GitHub Container Registry
      uses: docker/login-action@v2
      with:
        registry: ghcr.io
        username: ${{ github.actor }}
        password: ${{ secrets.GHCR_PAT }}

    - name: Build and push Docker image
      uses: docker/build-push-action@v3
      with:
        context: .
        push: true
        tags: ghcr.io/${{ github.repository_owner }}/$(basename ${{ github.repository }}):canary

    - name: Generate Kubernetes manifest
      run: |
        cat <<EOF > deployment.yml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: myapp-canary
          labels:
            app: myapp
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: myapp
          template:
            metadata:
              labels:
                app: myapp
            spec:
              containers:
              - name: myapp
                image: ghcr.io/${{ github.repository_owner }}/$(basename ${{ github.repository }}):canary
                ports:
                - containerPort: 80
        EOF
      shell: bash

    - name: Log in to Azure CLI
      uses: azure/login@v1
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Set AKS context
      run: |
        az aks get-credentials --resource-group ${{ secrets.AZURE_RG }} --name ${{ secrets.AZURE_AKS }}

    - name: Deploy to AKS
      run: |
        kubectl apply -f deployment.yml
```

### Explanation:

- **Azure Service Principal**: The service principal credentials are stored in the `AZURE_CREDENTIALS` secret.
- **Login to Azure CLI**: The `azure/login@v1` action uses the `AZURE_CREDENTIALS` secret to authenticate to Azure.

This setup will allow your GitHub Actions workflow to authenticate to Azure and perform actions such as deploying to AKS.
#>
