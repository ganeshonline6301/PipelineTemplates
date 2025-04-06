# 🧰 PipelineTemplates

![Last Commit](https://img.shields.io/github/last-commit/ganeshonline6301/PipelineTemplates)


A collection of **reusable Azure DevOps pipeline templates** specifically designed for:

- Deploying **.NET applications** to **Azure App Service**
- **Bicep-based deployments** to **Azure Container Registry (ACR)**

These templates are intended to help you set up CI/CD pipelines faster, with clean and customizable YAML workflows tailored for modern .NET projects.

## 🌐 Roadmap

In the near future, this repository will include:

- GitHub Actions templates to support **cross-platform DevOps automation**
- Deployment templates for various services (App Service, Function Apps, Containers, etc.)
- Terraform integration to support **infrastructure-as-code** across **any cloud provider**

## ⚡ Getting Started

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

## 🤝 Contributing

This repo is open to the community!  
Feel free to:

- Raise issues  
- Suggest improvements  
- Submit pull requests

Let’s collaborate and simplify DevOps workflows together.

## ⭐ Show Your Support

If you find this helpful, give the repo a ⭐ and help spread the word!

## 📝 License

This project is licensed under the [MIT License](LICENSE).
