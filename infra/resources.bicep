param environmentName string
param location string = resourceGroup().location
param principalId string = ''
param webImageName string = ''

// Container apps host (including container registry)
module containerApps './core/host/container-apps.bicep' = {
  name: 'container-apps'
  params: {
    environmentName: environmentName
    location: location
    logAnalyticsWorkspaceName: monitoring.outputs.logAnalyticsWorkspaceName
  }
}

// Frontend
module web './app/web.bicep' = {
  name: 'web'
  params: {
    environmentName: environmentName
    location: location
    imageName: webImageName
    applicationInsightsName: monitoring.outputs.applicationInsightsName
    containerAppsEnvironmentName: containerApps.outputs.containerAppsEnvironmentName
    containerRegistryName: containerApps.outputs.containerRegistryName
  }
}

// Application database
module cosmos './app/db.bicep' = {
  name: 'cosmos'
  params: {
    environmentName: environmentName
    location: location
    keyVaultName: keyVault.outputs.keyVaultName
  }
}

// Store secrets in a keyvault
module keyVault './core/security/keyvault.bicep' = {
  name: 'keyvault'
  params: {
    environmentName: environmentName
    location: location
    principalId: principalId
  }
}

// Monitor application with Azure Monitor
module monitoring './core/monitor/monitoring.bicep' = {
  name: 'monitoring'
  params: {
    environmentName: environmentName
    location: location
  }
}

output APPLICATIONINSIGHTS_CONNECTION_STRING string = monitoring.outputs.applicationInsightsConnectionString
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerApps.outputs.containerRegistryEndpoint
output AZURE_CONTAINER_REGISTRY_NAME string = containerApps.outputs.containerRegistryName
output AZURE_COSMOS_CONNECTION_STRING_KEY string = cosmos.outputs.cosmosConnectionStringKey
output AZURE_COSMOS_DATABASE_NAME string = cosmos.outputs.cosmosDatabaseName
output AZURE_KEY_VAULT_ENDPOINT string = keyVault.outputs.keyVaultEndpoint
output WEB_URI string = web.outputs.WEB_URI
