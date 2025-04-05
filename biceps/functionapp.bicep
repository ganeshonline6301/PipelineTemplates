param location string
param functionAppPlanName string
param functionAppPlanSku string
param functionAppName string

resource functionAppPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: functionAppPlanName
  location: location
  kind: 'linux'
  sku: {
    name: functionAppPlanSku
  }
  properties: {
    reserved: true
  }
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    httpsOnly: true
    serverFarmId: functionAppPlan.id
    reserved: true
    clientAffinityEnabled: true
    siteConfig: {
      alwaysOn: true
      //fxversion
    }
  }
}
