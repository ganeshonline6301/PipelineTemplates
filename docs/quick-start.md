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
  - **ServiceConnection**: The Azure service connection used for authentication.
  - **ResourceGroupName**: The name of the Azure Resource Group where the resources will be deployed.
  - **ServiceName**: The name of the service (e.g., App Service or other).
  - **Environment**: The environment to deploy to (e.g., `dev`, `prod`).
  - **ParametersFilePath**: The path to the `parameters.json` file, which contains deployment configurations.

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
