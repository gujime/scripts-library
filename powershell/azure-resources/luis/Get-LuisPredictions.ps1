<#
.SYNOPSIS
	This Azure Automation runbook automates bot configuration file. 

.DESCRIPTION
    This is a PowerShell runbook, as opposed to a PowerShell Workflow runbook.

.SYNTAX    
    Get-Predictions [-FilePath] <System.String> | [Out-File] <System.String>

.EXAMPLE
    . .\Get-LuisPredictions.ps1
    Get-Predictions -FilePath "..\Get-LuisPredictions.json" | Out-File "..\result.txt"
    
.PARAMETER
    None.

.INPUTS
	None.

.OUTPUTS
    Human-readable informational and error messages produced during the job    
#>

# Get LUIS predictions
function Get-Predictions {
    param(
        [parameter(Mandatory=$true)] [String]$FilePath
    )

    # read json file with questions
    $json = Get-Content $FilePath -Raw | ConvertFrom-Json
    foreach($q in $json.questions)
    {
        # set parameters
        $params = @{
            "Uri" = "$($json.endpoint)/luis/prediction/v3.0/apps/$($json.luisappid)/slots/$($json.slot)/predict?subscription-key=$($json.subscriptionkey)&verbose=true&show-all-intents=true&log=true&query=$($q.value)"
            "Method" = $json.method
        }

        # get LUIS prediction
        Invoke-RestMethod @params | ConvertTo-Json
    }
}
