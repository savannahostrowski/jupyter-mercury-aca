param environmentName string
param location string = resourceGroup().location
param principalId string = ''
param apiImageName string = ''
param webImageName string = ''

// Container apps host (including container registry)
module containerApps './core/host/container-apps.bicep' = {
  name: 'container-apps'
  params: {
    environmentName: environmentName
    location: location
  }
}

// Web frontend
module web './app/web.bicep' = {
  name: 'web'
  params: {
    environmentName: environmentName
    location: location
    imageName: webImageName
    containerAppsEnvironmentName: containerApps.outputs.containerAppsEnvironmentName
    containerRegistryName: containerApps.outputs.containerRegistryName
  }
}





output AZURE_CONTAINER_REGISTRY_ENDPOINT string = containerApps.outputs.containerRegistryEndpoint
output AZURE_CONTAINER_REGISTRY_NAME string = containerApps.outputs.containerRegistryName
output WEB_URI string = web.outputs.WEB_URI
