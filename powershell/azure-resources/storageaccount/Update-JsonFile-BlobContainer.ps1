# Get storage account object
$st = Get-AzStorageAccount -ResourceGroupName "" -StorageAccountName ""

# Download file
Get-AzStorageBlobContent -Container "" -Blob "" -Destination $(System.DefaultWorkingDirectory) -Context $st.Context

#Update json file
$json = Get-Content $(System.DefaultWorkingDirectory)\"{filename}.json" -Raw | ConvertFrom-Json
$json.{nodename} = ""
$json | ConvertTo-Json | Set-Content $(System.DefaultWorkingDirectory)\"{filename}.json"

# Upload file
Set-AzStorageBlobContent -Container "" -File $(System.DefaultWorkingDirectory)\"{filename}.json" -Blob "{filename}.json" -Context $st.Context -Force
