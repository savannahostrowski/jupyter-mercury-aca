param environmentName string
param location string = resourceGroup().location

module logAnalytics 'loganalytics.bicep' = {
  name: 'loganalytics'
  params: {
    environmentName: environmentName
    location: location
  }
}

output logAnalyticsWorkspaceId string = logAnalytics.outputs.logAnalyticsWorkspaceId
output logAnalyticsWorkspaceName string = logAnalytics.outputs.logAnalyticsWorkspaceName
