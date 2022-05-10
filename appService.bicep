//module to create app service resource in Azure.

param location string
param appServiceAppName string

@allowed([
  'nonprod'
  'prod'
])
param environmentType string //parameter for the environment type

var appServicePlanName = 'toy-product-launch-plan' //using variable to define the Azure app service plan name.
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

//app service plan details
resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

//app service details
resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

//output for hostname
output appServiceAppHostName string = appServiceApp.properties.defaultHostName
