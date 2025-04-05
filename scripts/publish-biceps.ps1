param (
    [string]$bicepFilePath,
    [string]$serviceConnection,
    [string]$containerRegistry,
    [string]$moduleName
)

$moduleName = $moduleName.ToLower()
$acrName = $containerRegistry
$moduleTag = "br:$acrName.azurecr.io/bicep/$moduleName:v1"

Write-Host "Checking if $moduleName exists in ACR..."

$moduleExists = az acr repository show-tags --name $acrName --repository "bicep/$moduleName" --query "[?contains(@, 'v1')]" | ConvertFrom-Json

if ($moduleExists.Count -eq 0) {
    Write-Host "$moduleName not found, publishing..."
    az acr login --name $acrName
    az bicep publish --file "$bicepFilePath" --target "$moduleTag" --force
} else {
    Write-Host "$moduleName already exists, skipping publish."
}