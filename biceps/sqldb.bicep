@minLength(3)
@maxLength(128)
param name string
param location string
param parentServerName string
var databaseCollation = 'SQL_Latin1_General_CP1_CI_AS'
 
resource server 'Microsoft.Sql/servers@2021-11-01' existing = {
  name: parentServerName
}
 
resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Basic'
  }
  properties: {
    collation: databaseCollation
  }
  parent: server
}