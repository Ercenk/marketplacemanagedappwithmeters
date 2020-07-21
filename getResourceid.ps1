# curl is an alias to Web-Invoke PowerShell command
# Get system identity access tokenn
$MetadataUrl = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fmanagement.azure.com%2F"
$Token = curl -H @{"Metadata" = "true"} $MetadataUrl | Select-Object -Expand Content | ConvertFrom-Json
$Headers = @{}
$Headers.Add("Authorization","$($Token.token_type) "+ " " + "$($Token.access_token)")

# step 2
# Get subscription and resource group
$metadata = curl -H @{'Metadata'='true'} http://169.254.169.254/metadata/instance?api-version=2019-06-01 | select -ExpandProperty Content | ConvertFrom-Json 

# Make sure the system identity has at least reader permission on the resource group
$managementUrl = "https://management.azure.com/subscriptions/" + $metadata.compute.subscriptionId + "/resourceGroups/" + $metadata.compute.resourceGroupName + "?api-version=2019-10-01"
$resourceGroupInfo = curl -Headers $Headers $managementUrl | select -ExpandProperty Content | ConvertFrom-Json
$managedappId = $resourceGroupInfo.managedBy

#step 3
# Get resourceUsageId from the managed app
$managedAppUrl = "https://management.azure.com" + $managedappId + "\?api-version=2019-07-01"
$ManagedApp = curl $managedAppUrl -H $Headers | Select-Object -Expand Content | ConvertFrom-Json
# Use this resource ID to emit usage 
$resourceUsageId = $ManagedApp.properties.billingDetails.resourceUsageId
