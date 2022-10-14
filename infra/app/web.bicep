param environmentName string
param location string = resourceGroup().location

param apiName string = ''
param applicationInsightsName string = ''
param containerAppsEnvironmentName string = ''
param containerRegistryName string = ''
param imageName string = ''
param keyVaultName string = ''
param serviceName string = 'web'

var abbrs = loadJsonContent('../abbreviations.json')
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

module web '../core/host/container-app.bicep' = {
  name: '${serviceName}-container-app-module'
  params: {
    environmentName: environmentName
    location: location
    containerAppsEnvironmentName: containerAppsEnvironmentName
    containerRegistryName: containerRegistryName
    env: [
    
      {
        name: 'APP_API_BASE_URL'
        value: 'https://${api.properties.configuration.ingress.fqdn}'
      }
    ]
    imageName: !empty(imageName) ? imageName : 'nginx:latest'
    keyVaultName: keyVault.name
    serviceName: serviceName
    targetPort: 80
  }
}


output WEB_NAME string = web.outputs.name
output WEB_URI string = web.outputs.uri
