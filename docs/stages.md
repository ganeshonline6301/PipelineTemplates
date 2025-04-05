# 🚀 Azure DevOps Stage Templates

## Overview

This folder contains reusable **Azure DevOps stage templates** that integrate with various job templates to streamline your CI/CD pipelines. The stages include building, publishing infrastructure and modules, and deploying web applications.

---

## 🔧 Stage Template 1: **Build Stage (`build.yml`)**

### **Purpose**
This stage is responsible for building a .NET application. It integrates with the **`build-dotnet.yml`** job template to restore, build, and publish the solution. The artifact is then prepared for deployment.

### **Parameters**
- **`solutionFile`**: The path to the `.sln` file.
- **`projectName`**: The name of the project (used to name the artifact).

### **Stages**
- **Build**: The `Build` stage contains a job that:
  - Restores dependencies and builds the solution.
  - Publishes the output and stores it as an artifact.

### **Steps**
1. **Job**: `build` - The job runs on `windows-latest` VM and uses the **`build-dotnet.yml`** template to handle the build and artifact creation.
2. **Job Execution**: The `.NET solution` is built using the defined `.NET version` and configuration (`Release` by default).

### **Example Usage**
```yaml
stages:
- stage: Build
  displayName: Build ${{ parameters.ProjectName }}
  jobs:
    - job: build
      displayName: Build and Test, create artifacts
      pool:
        vmImage: 'windows-latest'
      variables:
        BuildConfiguration: 'Release'
        DotnetVersion: '<your-dotnet-version>'
      steps:
        - template: ../jobs/build-dotnet.yml
          parameters:
            SolutionFile: ${{ parameters.SolutionFile }}
            ArtifactName: ${{ parameters.ProjectName }}
            BuildConfiguration: $(BuildConfiguration)
            DotnetVersion: $(DotnetVersion)
```

---

## 🔧 Stage Template 2: **Release Stage (`release.yml`)**

### **Purpose**
This stage handles the deployment of infrastructure and the web application to Azure. It uses the `deploy-infra.yml` and `deploy-webapp.yml` job templates.

### **Parameters**
- **`environment`**: The deployment environment (e.g., dev, prod).
- **`projectName`**: The name of the project (artifact).
- **`serviceName`**: The name of the service (e.g., App Service).
- **`resourceGroupName`**: The name of the resource group.
- **`appServiceName`**: The name of the Azure App Service.
- **`serviceConnection`**: The Azure service connection to use.
- **`bicepFilePath`**: Path to the Bicep file for infrastructure deployment.
- **`parametersFilePath`**: Path to the Bicep parameters file.

### **Stages**
- **Deploy Infrastructure**: This stage deploys infrastructure using the `deploy-infra.yml` job template.
- **Deploy WebApp**: This stage deploys the web application to Azure App Service using the `deploy-webapp.yml` template.

### **Steps**
1. **Deploy Infrastructure**: Runs the `deploy-infra.yml` job template to deploy infrastructure using the specified Bicep file.
2. **Deploy WebApp**: Deploys the web app to the Azure App Service after the infrastructure is deployed.

### **Example Usage**
```yaml
stages:
- stage: Deploy_${{ parameters.Environment }}
  displayName: Release to ${{ parameters.Environment }}
  jobs:
  - deployment: DeployInfrastructure
    displayName: "Deploy Infrastructure"
    pool:
      vmImage: 'windows-latest'
    environment: ${{ parameters.ServiceName }}-${{ parameters.Environment }}
    strategy:
      runOnce:
        deploy:
          steps:
            - template: ../jobs/deploy-infra.yml
              parameters:
                serviceConnection: ${{ parameters.ServiceConnection }}
                resourceGroupName: ${{ parameters.ResourceGroupName }}
                environment: ${{ parameters.Environment }}
                bicepFilePath: ${{ parameters.BicepFilePath }}
                parametersFilePath: ${{ parameters.ParametersFilePath }}

  - deployment: DeployWebApp
    displayName: Deploy WebApp to Azure
    dependsOn: DeployInfrastructure
    pool:
      vmImage: 'windows-latest'
    environment: ${{ parameters.ServiceName }}-${{ parameters.Environment }}
    strategy:
      runOnce:
        deploy:
          steps:
            - template: ../jobs/deploy-webapp.yml
              parameters:
                AppServiceName: ${{ parameters.AppServiceName }}
                ProjectName: ${{ parameters.ProjectName }}
                ServiceConnection: ${{ parameters.ServiceConnection }}

```

---

## 🔧 Stage Template 3: **Publish Stage (`publish.yml`)**

### **Purpose**
The `Publish` stage is designed for deploying infrastructure (using Bicep) and publishing modules to Azure Container Registry (ACR). It utilizes the `deploy-infra.yml` and `publish-modules.yml` job templates.

### **Parameters**
- **`serviceConnection`**: The Azure service connection to use for authentication.
- **`resourceGroupName`**: The Azure resource group for deployment.
- **`serviceName`**: The name of the service (e.g., App Service).
- **`environment`**: The deployment environment (e.g., dev, prod).
- **`parametersFilePath`**: The path to the Bicep parameters file.
- **`containerRegistryName`**: The name of the Azure Container Registry (ACR).

### **Stages**
- **Deploy Infrastructure**: This stage deploys infrastructure using the `deploy-infra.yml` job template.
- **Publish Modules**: After infrastructure deployment, the `publish-modules.yml` template publishes modules (e.g., AppService, CosmosDB) to ACR.

### **Steps**
1. **Deploy Infrastructure**: Runs the `deploy-infra.yml` job template to deploy infrastructure using the specified Bicep file.
2. **Publish Modules**: Runs multiple instances of `publish-modules.yml` for different modules (e.g., AppService, CosmosDB, SQLServer, etc.).

### **Example Usage**
```yaml
stages:
- stage: Publish
  displayName: Publish Modules
  jobs:
    - deployment: DeployInfrastructure
      displayName: "Deploy Infrastructure"
      pool:
        vmImage: 'windows-latest'
      environment: ${{ parameters.ServiceName }}-${{ parameters.Environment }}
      strategy:
        runOnce:
          deploy:
            steps:
              - template: ../jobs/deploy-infra.yml
                parameters:
                  ServiceConnection: ${{ parameters.ServiceConnection }}
                  ResourceGroupName: ${{ parameters.ResourceGroupName }}
                  Environment: ${{ parameters.Environment }}
                  BicepFilePath: $(Build.SourcesDirectory)/biceps/containerregistry.bicep
                  ParametersFilePath: ${{ parameters.ParametersFilePath }}
              
    - job: publish
      displayName: Publish modules to ACR
      dependsOn: DeployInfrastructure
      condition: succeeded()
      pool:
        vmImage: 'windows-latest'
      steps:
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/appservice.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: appservice
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/cosmosdb.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: cosmosdb
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/appinsights.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: appinsights
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/sqlserver.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: sqlserver
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/sqldb.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: sqldb
        - template: ../jobs/publish-modules.yml
          parameters:
            BicepFilePath: $(Build.SourcesDirectory)/biceps/keyvault.bicep
            ServiceConnection: ${{ parameters.ServiceConnection }}
            ContainerRegistry: ${{ parameters.ContainerRegistryName }}
            ModuleName: keyvault

```
