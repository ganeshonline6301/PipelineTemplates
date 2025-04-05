# 🧰 PipelineTemplates

![Last Commit](https://img.shields.io/github/last-commit/ganeshonline6301/PipelineTemplates)


A collection of reusable **Azure DevOps pipeline templates** specifically designed for deploying **.NET applications to Azure App Service** and **Bicep-based deployments to Azure Container Registry (ACR)**.  

In the future, GitHub Actions templates will be added to extend cross-platform DevOps automation.

## 🚀 Getting Started

For a quick start, please refer to the [Quick Start Guide](docs/quick-start.md) to set up Azure DevOps pipelines using the provided templates.

## 📁 Folder Structure

| Folder      | Description                                    |
|-------------|------------------------------------------------|
| `biceps/`   | Bicep templates for deploying resources into ACR|
| `jobs/`     | Reusable job templates for Azure DevOps        |
| `pipeline/` | Full pipeline templates for .NET deployments deploying bicep modules into ACR   |
| `scripts/`  | Bash/PowerShell scripts used in pipelines      |
| `stages/`   | Multi-stage definitions for complex pipelines  |
| `docs/`   | Documentation files, including guides like `quick-start.md`  |

## 📌 Contribution

We love contributions! Feel free to fork, suggest changes, or raise issues. Contributions for both Azure DevOps and future GitHub Actions templates are highly appreciated.

## 📝 License

This project is licensed under the [MIT License](LICENSE).
