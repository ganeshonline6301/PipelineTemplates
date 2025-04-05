param location string
param appServicePlanName string
param appServicePlanSku string
param appServicePlanTier string
param appServicePlanCapacity int
param appServiceName string
param dotnetVersion string
param corsAllowedOrigins array

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: appServicePlanTier
    capacity: appServicePlanCapacity
  }
}

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      netFrameworkVersion: dotnetVersion
      cors: {
        allowedOrigins: corsAllowedOrigins
      }
    }
  }
}
