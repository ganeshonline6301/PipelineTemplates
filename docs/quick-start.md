# 🚀 Quick Start Guide

## Overview

This repository contains a collection of **Azure DevOps pipeline templates** for building, deploying .NET applications, deploying infrastructure using Bicep, and publishing modules to Azure Container Registry (ACR). The templates can be easily integrated into your DevOps workflows to streamline CI/CD pipelines.

### Key Features:
- **.NET Application Build**: A template to build and publish .NET applications.
- **Infrastructure Deployment**: Templates for deploying infrastructure using **Bicep** and managing Azure resources.
- **Web Application Deployment**: Template to deploy web applications to **Azure App Service**.
- **ACR Publishing**: Publish modules (e.g., AppService, CosmosDB, SQLServer) to **Azure Container Registry**.

---

## 🧑‍💻 Sample Pipeline Guide

This guide walks you through setting up and running a **sample pipeline** for:

- Deploying infrastructure
- Publishing modules to **Azure Container Registry (ACR)**

It uses one of the predefined **stage templates** (`publish.yml`) and a **parameters.json** file that provides the necessary configurations for deployment.

### Sample Pipeline (`pipeline.yml`)

This pipeline file demonstrates the use of the `publish.yml` stage template from the **`stages/`** folder. It triggers on changes to the **`main`** or **`master`** branches and executes the **publish** stage with custom parameters. The pipeline also integrates a **`parameters.json`** file to provide values for parameters.

### Key Sections in `pipeline.yml`:

- **Trigger**: This section ensures that the pipeline is triggered when changes are made to the `main` or `master` branches, specifically within the `pipeline/` folder.

- **Stages**: The pipeline uses the `publish.yml` stage template, which is located in the **`stages/`** folder.

- **Parameters**: The pipeline passes required parameters, including:
  - **`ServiceConnection`**: The Azure service connection used for authentication.
  - **`ResourceGroupName`**: The name of the Azure Resource Group where the resources will be deployed.
  - **`ServiceName`**: Refers to the Azure Pipeline Environment name (e.g., `dev`, `prod`) used for organizing and managing deployments.
  - **`Environment`**: The actual deployment environment (e.g., `dev`, `prod`). This may be used for setting conditions, naming conventions, or environment-specific settings.
  - **`ParametersFilePath`**: The path to the `parameters.json` file, which contains deployment configurations.
  - **`ContainerRegistryName`**: The name of your Azure Container Registry (ACR).

> ⚠️**Note:** Before running the CI/CD pipeline, make sure the environment (e.g., `dev`, `prod`) is created in **Azure DevOps** under **Pipelines > Environments**. This enables the pipeline to target specific deployment environments, manage approvals, and monitor releases effectively.


### Example of `pipeline.yml`:

```yaml
trigger:
  branches:
    include:
      - main
      - master
  paths:
    include:
      - pipeline

stages:
  - template: ../stages/publish.yml
    parameters:
      ServiceConnection: '<your-service-connection-name>'
      ResourceGroupName: '<your-resource-group-name>'
      ServiceName: '<your-service-name>'
      Environment: '<your-environment>'
      ParametersFilePath: $(Build.SourcesDirectory)/pipeline/parameters.json
      ContainerRegistryName: '<your-container-registry-name>'
```

---

### Stages Section

This pipeline uses the `publish.yml` stage template located in the [stages](stages/publish.yml) folder. The `publish.yml` template will deploy infrastructure to Azure using Bicep templates and publish modules to Azure Container Registry (ACR).

### YAML Configuration

```yaml
stages:
  - template: ../stages/publish.yml
    parameters:
      ServiceConnection: 'my-azure-service-connection'
      ResourceGroupName: 'my-app-rg'
      ServiceName: 'infra-dev'
      Environment: 'dev'
      ParametersFilePath: $(Build.SourcesDirectory)/pipeline/parameters.json
      ContainerRegistryName: 'mycontainerregistry'
```

### Parameters File: `parameters.json`

This is an example of the `parameters.json` file that contains the deployment parameters for the Bicep templates.

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "azureContainerRegistryName": {
            "value": "<your-containerregistryname>"
        },
        "location": {
            "value": "<your-region>"
        },
        "sku": {
            "value": "<your-sku>"
        }
    }
}
```

This file defines the parameters that will be used by the Bicep templates during the deployment process:

- **azureContainerRegistryName**:  
  The name of the Azure Container Registry where modules will be published (e.g., `MyContainerRegistry`).

- **location**:  
  The Azure region where resources will be deployed (e.g., `East US`).

- **sku**:  
  The SKU of the Azure resources (e.g., `Standard`).

---

### Pipeline Path and Documentation

The `stages` folder path in your repository is referenced as `../stages/`.  
This tells Azure DevOps to look for stage templates like `publish.yml` in the `stages` folder.

You can easily replace this with other templates in the `stages` folder.  
For example, you could use the `build.yml` or `release.yml` templates by adjusting the template path accordingly.

```yaml
- template: ../stages/build.yml
  parameters:
    SolutionFile: 'MyApp/MyApp.sln'
    ProjectName: 'MyApp.WebApi'
```

### Extending the Pipeline

- You can extend the pipeline by adding additional stages. The pipeline allows you to mix and match templates based on your requirements.

- Each stage can be linked to the next, and you can configure multiple stages such as Build, Publish, and Release, depending on your needs.

### 📁 Folder Structure

Here’s the general folder structure for the repository:

| Folder      | Description                                    |
|-------------|------------------------------------------------|
| `biceps/`   | Bicep templates for deploying resources into ACR|
| `jobs/`     | Reusable job templates for Azure DevOps        |
| `pipeline/` | Full pipeline templates for .NET deployments deploying bicep modules into ACR   |
| `scripts/`  | Bash/PowerShell scripts used in pipelines      |
| `stages/`   | Multi-stage definitions for complex pipelines  |
| `docs/`   | Documentation files, including guides like `quick-start.md`  |

---

### 📝 Summary

By following this guide, you can quickly set up an Azure DevOps pipeline using the provided templates. Each stage template is reusable and configurable through parameters. Simply replace the placeholder values in the pipeline and `parameters.json` with your actual project details, and you're ready to go!

Feel free to explore and add additional templates from the `stages` folder to build complex multi-stage pipelines that suit your deployment process.
