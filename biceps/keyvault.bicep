param location string
param keyVaultName string  
param principleId string
param objectId string

resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: principleId   
        permissions: {           
          secrets: [             
            'get'           
          ]         
        } 
      }
      {
        tenantId: subscription().tenantId
        objectId: objectId
        permissions: {           
          secrets: [             
            'get'           
          ]         
        } 
      }
    ]
    enableSoftDelete: true
    enablePurgeProtection: true
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}