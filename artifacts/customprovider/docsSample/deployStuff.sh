#!/bin/bash

resourceGroup="ErcSandboxWest2"
location="westus2"
appName="ManagedUsersAppDefinition"
# Select subscription and create resource group (if you have not created yet)
# az group create --name $resourceGroup --location eastus2

 az managedapp definition delete -n $appName -g $resourceGroup

# Get object ID of your identity
userid=$(az ad user show --upn-or-object-id ercenk@microsoft.com --query objectId --output tsv)
# Get role definition ID for the Owner role
roleid=$(az role definition list --name Owner --query [].name --output tsv)

# Create managed application definition resource
az managedapp definition create \
  --name $appName \
  --location $location \
  --resource-group $resourceGroup \
  --lock-level ReadOnly \
  --display-name "Managed users app definition" \
  --description "Managed application with Azure Custom Provider" \
  --authorizations "$userid:$roleid" \
  --package-file-uri "https://ercsandboxeast2.blob.core.windows.net/managedapps/app.zip?sv=2019-02-02&st=2020-08-04T13%3A33%3A32Z&se=2020-08-05T13%3A33%3A32Z&sr=b&sp=r&sig=k0tvr5i0HMkk9xzvKah5yHr9951NqlKyeZVNvJoz2Bg%3D"