param (
    [string]$resourceGroupName,
    [string]$environment,
    [string]$parametersFilePath,
    [string]$bicepFilePath
)

if (-not (Test-Path $parametersFilePath)) {
    Write-Host "Error: Parameter file '$parametersFilePath' not found!"
    exit 1
}

Write-Host "Deploying resources for environment: $environment"

          az deployment group create --resource-group $resourceGroupName `
              --template-file "$bicepFilePath" `
              --parameters "@$parametersFilePath"