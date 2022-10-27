@description('Specifies the location for resources.')
param location string = 'uksouth'
param app_service_plan_name string = 'toy-product-launch-plan-starter'
var app_service_app_name = 'ml-20221027-launch-1'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2V3' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = {
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

resource appServicePlan 'Microsoft.Web/serverFarms@2022-03-01' = {
  name: app_service_plan_name
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: app_service_app_name
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
