param location string
param cosmosDbAccountName string
param cosmosDatabaseName string
param cosmosContainerName string
param cosmosPartitionKeyPath string
param cosmosDbOfferType string
param cosmosDbEnableFreeTier bool

// Cosmos Account
resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: cosmosDbOfferType
    enableFreeTier: cosmosDbEnableFreeTier
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
  }
}

// Cosmos DB
resource cosmosDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2024-11-15' = {
  parent: cosmosDbAccount
  name: cosmosDatabaseName
  properties: {
    resource: {
      id: cosmosDatabaseName
    }
  }
}

// Cosmos Container
resource cosmosContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2024-11-15' = {
  parent: cosmosDatabase
  name: cosmosContainerName
  properties: {
    resource: {
      id: cosmosContainerName
      partitionKey: {
        paths: [cosmosPartitionKeyPath]
        kind: 'Hash'
      }
    }
  }
}
