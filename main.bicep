//bicep template for a toy launch website.
//this template accepts  parameters for the resource locations and names.
//uses business rules to select the right SKUs for the resources being deployed.
//automatically sets the SKUs  for each environment type - production & non production
//Steps - create a storage account, Azure App Service Plan, Azure App.

param location string = resourceGroup().location //parameter for the location
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}' //using expression to define default Azure stroage account name.
param appServiceAppName string = 'toy-launch${uniqueString(resourceGroup().id)}' //using expression to define default Azure app service name.
//var appServicePlanName = 'toy-product-launch-plan' //using variable to define the Azure app service plan name.

@allowed([
  'nonprod'
  'prod'
])
param environmentType string //parameter for the environment type
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS' //sets the SKU for the storage account to Standard_GRS if env is prod, Standard_LRS for non prod.
//var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1' //sets the SKU for app service plan to P2v33 for prod env, F1 for non prod.


resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  //storage account details
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

/*
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
}*/

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: appServiceAppName
    environmentType: environmentType
  }
}

//return the output of the appServiceAppHostName from the appService.bicep module
output appServiceAppHostName string = appService.outputs.appServiceAppHostName
/*resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: 'toylaunchstorage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverFarms@2021-03-01' = {
  name: 'toy-product-launch-plan-starter'
  location: location
  sku: {
    name: 'F1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2021-03-01' = {
  name: 'toy-product-launch-1'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
*/
