# 🚀 Azure DevOps Job Templates

## Overview

This folder contains reusable **Azure DevOps job templates** for building, deploying .NET applications, publishing modules to Azure Container Registry (ACR), and more. These templates can be referenced in Azure DevOps pipelines to streamline the build and deployment processes.

---

## 🔧 Job Template 1: **Build .NET Application (`build-dotnet.yml`)**

### **Purpose**
This job is responsible for building and publishing a .NET application. It:
1. Restores the dependencies.
2. Builds the solution.
3. Publishes the output.
4. Renames the artifact to a custom name.

### **Parameters**
- **`solutionFile`**: The path to the `.sln` file.
- **`dotnetVersion`**: The version of .NET SDK to use (e.g., `6.0`).
- **`artifactName`**: The name to give the published artifact (ZIP file).
- **`buildConfiguration`**: The build configuration (e.g., `Release` or `Debug`).

### **Steps**
1. **Install .NET SDK**: Uses the `UseDotNet@2` task to install the specified .NET SDK version.
2. **Dotnet Restore**: Runs `dotnet restore` on the provided solution file.
3. **Dotnet Build**: Builds the solution using `dotnet build` with the provided configuration and without restoring dependencies again.
4. **Publish**: Publishes the application using `dotnet publish`, outputs a ZIP file of the published app.
5. **Rename Artifact**: A PowerShell task renames the resulting ZIP file to the custom artifact name.
6. **Publish Artifact**: Publishes the renamed ZIP file as a pipeline artifact using the `PublishPipelineArtifact@1` task.

### **Example Usage**
```yaml
jobs:
- template: jobs/build-dotnet.yml
  parameters:
    solutionFile: 'MyApp.sln'
    dotnetVersion: '6.0'
    artifactName: 'MyAppArtifact'
    buildConfiguration: 'Release'
```

---
## 🔧 Job Template 2: **Deploy Infrastructure (`deploy-infra.yml`)**

### **Purpose**
This job is responsible for deploying infrastructure to Azure using Bicep templates. It:
1. Authenticates to Azure using a service connection.
2. Deploys the specified Bicep template and parameter file to a given resource group.
3. Supports environment-based deployments.

### **Parameters**
- **`resourceGroupName`**: The name of the Azure resource group to deploy the resources to.
- **`environment`**: The target environment for deployment (e.g., `dev`, `prod`).
- **`serviceConnection`**: The Azure service connection used for authentication.
- **`bicepFilePath`**: The file path to the Bicep template (`.bicep`) file.
- **`parametersFilePath`**: The file path to the Bicep parameters file.

### **Steps**
1. **Azure CLI Deployment**: The job uses the `AzureCLI@2` task to deploy resources using the Azure CLI command:
   ```bash
   az deployment group create \
     --resource-group <resourceGroupName> \
     --template-file <bicepFilePath> \
     --parameters <parametersFilePath>
   ```

### **Example Usage**
```yaml
jobs:
- template: jobs/deploy-infra.yml
  parameters:
    resourceGroupName: 'MyResourceGroup'
    environment: 'dev'
    serviceConnection: 'MyAzureServiceConnection'
    bicepFilePath: 'templates/main.bicep'
    parametersFilePath: 'templates/parameters.dev.json'
```

---

## 🔧 Job Template 3: **Deploy Web Application (`deploy-webapp.yml`)**

### **Purpose**
This job is responsible for deploying a web application to Azure App Service. It:
1. Downloads the pipeline artifact (i.e., the ZIP file).
2. Deploys the application to the specified Azure App Service.

### **Parameters**
- **`appServiceName`**: The name of the Azure App Service to deploy to.
- **`projectName`**: The name of the project artifact to download.
- **`serviceConnection`**: The Azure service connection to use for authentication.

### **Steps**
1. **Download Pipeline Artifact**: Downloads the artifact (ZIP file) from the pipeline.
2. **Deploy to Azure App Service**: Uses the `AzureWebApp@1` task to deploy the downloaded ZIP file to the specified Azure App Service.

### **Example Usage**
```yaml
jobs:
- template: jobs/deploy-infra.yml
  parameters:
    resourceGroupName: 'MyResourceGroup'
    environment: 'dev'
    serviceConnection: 'MyAzureServiceConnection'
    bicepFilePath: 'templates/main.bicep'
    parametersFilePath: 'templates/parameters.dev.json'
```
---

## 🔧 Job Template 4: **Publish Bicep Modules (`publish-modules.yml`)**

### **Purpose**
This job is designed for publishing Bicep modules to Azure Container Registry (ACR). It:
1. Checks if the module already exists in the container registry.
2. Publishes the module to ACR if it does not already exist.

### **Parameters**
- **`bicepFilePath`**: The path to the Bicep file that needs to be published.
- **`serviceConnection`**: The Azure service connection to use for authentication.
- **`containerRegistry`**: The name of the Azure Container Registry (ACR).
- **`moduleName`**: The name of the Bicep module to be published.

### **Steps**
1. **Check for Existing Module**: Uses the Azure CLI to check if the module already exists in the ACR.
2. **Publish Module**: If the module does not exist, it logs in to ACR and uses the `az bicep publish` command to publish the Bicep file.

### **Example Usage**
```yaml
jobs:
- template: jobs/publish-modules.yml
  parameters:
    bicepFilePath: 'templates/module.bicep'
    serviceConnection: 'MyAzureServiceConnection'
    containerRegistry: 'MyContainerRegistry'
    moduleName: 'myModule'
```
