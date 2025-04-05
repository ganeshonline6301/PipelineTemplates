@minLength(3)
@maxLength(128)
param name string
param location string
param sqlServerAADLogin string
param sqlServerAADSid string

var defaultFirewallRules = [
  {
    name: 'AllowAllWindowsAzureIps'
    start: '0.0.0.0'
    end: '0.0.0.0'
  }
  {
    name: '<your-firewall-name>'
    start: '<your-current-ip-address>'
    end: '<your-current-ip-address>'
  }
]

resource SqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  name: name
  location: location
  properties: {
    administrators: {
      principalType: 'Group'
      administratorType: 'ActiveDirectory'
      azureADOnlyAuthentication: true
      login: sqlServerAADLogin
      sid: sqlServerAADSid
    }
  }
}

resource firewallRules 'Microsoft.Sql/servers/firewallRules@2021-11-01' = [
  for firewallRule in defaultFirewallRules: {
    parent: SqlServer
    name: firewallRule.name
    properties: {
      startIpAddress: firewallRule.start
      endIpAddress: firewallRule.end
    }
  }
]
