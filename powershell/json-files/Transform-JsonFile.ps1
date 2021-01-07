<#
.SYNOPSIS
	This Azure Automation runbook automates bot configuration file. 

.DESCRIPTION
    This is a PowerShell runbook, as opposed to a PowerShell Workflow runbook.

.SYNTAX
    
    Add-MemberToJsonObject [-FilePath] <System.String> [-Name] <System.String> [-Value] <System.String>
    Add-MemberToJsonObject -FilePath "..\BotConfig.json" -Name "Key" -Value ""

    Add-JsonObjectoToArray [-FilePath] <System.String> [-Array] <System.String> [-JsonObject] <System.String>
    Add-JsonObjectoToArray -FilePath "..\BotConfig.json" -Array "" -JsonObject '{"":  ""}'
    
    Get-JsonMemberValueFromArray [-FilePath] <System.String> [-Array] <System.String> [-JsonMemberNameToFilter] <System.String> [-JsonMemberValueToFilter] <System.String> [-JsonMemberNameToGet] <System.String>
    Get-JsonMemberValueFromArray -FilePath "..\BotConfig.json" -Array "" -JsonMemberNameToFilter "" -JsonMemberValueToFilter "" -JsonMemberNameToGet ""
    
    Remove-JsonObjectFromArray [-FilePath] <System.String> [-Array] <System.String> [-JsonMemberNameToFilter] <System.String> [-JsonMemberValueToFilter] <System.String>
    Remove-JsonObjectFromArray -FilePath "..\BotConfig.json" -Array "" -JsonMemberNameToFilter "" -JsonMemberValueToFilter ""

    Update-JsonMemberValue [-FilePath] <System.String> [-Name] <System.String> [-Value] <System.String>
    Update-JsonMemberValue -FilePath "..\BotConfig.json" -Name "" -Value ""
    
    Update-JsonMemberValueFromArray [-FilePath] <System.String> [-Array] <System.String> [-JsonMemberNameToFilter] <System.String> [-JsonMemberValueToFilter] <System.String> [-JsonMemberNameToSet] <System.String> [-JsonMemberValueToSet] <System.String>
    Update-JsonMemberValueFromArray -FilePath "..\BotConfig.json" -Array "" -JsonMemberNameToFilter "" -JsonMemberValueToFilter "" -JsonMemberNameToSet "" -JsonMemberValueToSet ""

.PARAMETER
    None.

.INPUTS
	None.

.OUTPUTS
    Human-readable informational and error messages produced during the job
#>

# Add member to object
function Add-MemberToJsonObject {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Name,
        [parameter(Mandatory=$true)] [String]$Value
    )

    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json
    
    # Add json member
    $json | Add-Member -MemberType NoteProperty -Name $Name -Value $Value
    
    # Save json file
    $json | ConvertTo-Json | Set-Content $FilePath
}

# Add object to array
function Add-JsonObjectoToArray {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Array,
        [parameter(Mandatory=$true)] [String]$JsonObject
    )

    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json
    
    # Add json object to array
    $json.$($Array) += (ConvertFrom-Json $JsonObject)
    
    # Save json file
    $json | ConvertTo-Json | Set-Content $FilePath
}

# Get member value from array
function Get-JsonMemberValueFromArray {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Array,
        [parameter(Mandatory=$true)] [String]$JsonMemberNameToFilter,
        [parameter(Mandatory=$true)] [String]$JsonMemberValueToFilter,
        [parameter(Mandatory=$true)] [String]$JsonMemberNameToGet
    )

    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json
    
    # Get json member
    return $json.$($Array).Where({$_.$($JsonMemberNameToFilter) -eq $JsonMemberValueToFilter}).$($JsonMemberNameToGet)
}

# Remove object from array
function Remove-JsonObjectFromArray {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Array,
        [parameter(Mandatory=$true)] [String]$JsonMemberNameToFilter,
        [parameter(Mandatory=$true)] [String]$JsonMemberValueToFilter
    )

    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json
    
    # Remove array
    $json.$($Array) = $json.$($Array).Where({$_.$($JsonMemberNameToFilter) -ne $JsonMemberValueToFilter})
    
    # Save json file
    $json | ConvertTo-Json | Set-Content $FilePath
}

# Update member value
function Update-JsonMemberValue {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Name,
        [parameter(Mandatory=$true)] [String]$Value
    )

    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json

    # Update json member value
    $json.$($Name) = $Value

    # Save json file
    $json | ConvertTo-Json | Set-Content $FilePath
}

# Update member value from array
function Update-JsonMemberValueFromArray {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath,
        [parameter(Mandatory=$true)] [String]$Array,
        [parameter(Mandatory=$true)] [String]$JsonMemberNameToFilter,
        [parameter(Mandatory=$true)] [String]$JsonMemberValueToFilter,
        [parameter(Mandatory=$true)] [String]$JsonMemberNameToSet,
        [parameter(Mandatory=$true)] [String]$JsonMemberValueToSet
    )
    
    # Get json file content
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json

    # Update json member value
    $json.$($Array) | % {if($_.$($JsonMemberNameToFilter) -eq $JsonMemberValueToFilter){$_.$($JsonMemberNameToSet) = $JsonMemberValueToSet}}

    # Save json file
    $json | ConvertTo-Json | Set-Content $FilePath
}
