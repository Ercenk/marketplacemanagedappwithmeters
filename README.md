# Building a custom provider with custom code and deployed through a managed app

1. Started with the quickstart at this [page](https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/publish-service-catalog-app?tabs=azure-powershell)
1. Brought over the quickstart [sample](https://github.com/Azure/azure-quickstart-templates/tree/master/101-managed-application)
1. Uploaded the artifacts on the artifacts folder to an Azure Storage Account
1. Testing with my account, thus changing the group to user at this [section](https://docs.microsoft.com/en-us/azure/azure-resource-manager/managed-applications/publish-service-catalog-app?tabs=azure-powershell#create-an-azure-active-directory-user-group-or-application)

    ```bash
    userid=$(az ad user show --id <email> --query objectId --output tsv)
    ```
1. Get the "owner" role ID
    ```bash
    ownerid=$(az role definition list --name Owner --query [].name --output tsv)
    ```
1. Create the resource group for app definition
    ```bash
    az group create --name ercappdefinition --location eastus2
    ```
1. Create the application's definition source
    ```bash
    az managedapp definition create \
    --name "ErcManagedStorage" \
    --location "eastus2" \
    --resource-group ercappdefinition \
    --lock-level ReadOnly \
    --display-name "Ercenk Managed Storage Account" \
    --description "Ercenk Managed Azure Storage Account" \
    --authorizations "$userid:$ownerid" \
    --package-file-uri "https://ercsandboxeast2.blob.core.windows.net/media/app.zip?sv=2019-02-02&st=2020-05-15T17%3A25%3A24Z&se=2021-05-16T17%3A25%3A00Z&sr=b&sp=r&sig=kyLaHjoT2Im6bEmRmaNS3nySUaSGyzIzfNvq0QTnoVQ%3D"

