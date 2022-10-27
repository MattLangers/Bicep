@description('Specifies the location for resources.')
param location string = 'uksouth'
var app_service_app_name = 'ml-20221027-launch-1'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'

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

module appService 'modules/appService.bicep' = {
  name: 'appService'
  params: {
    location: location
    appServiceAppName: app_service_app_name
    environmentType: environmentType
  }
}

output appServiceAppHostName string = appService.outputs.appServiceAppHostName
