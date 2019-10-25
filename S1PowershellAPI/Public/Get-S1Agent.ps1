function Get-S1Agent
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [string]$Query,

        [switch] $RawData
    )

    Begin {

    $baseURL='https://'+$tenant+'.sentinelone.net'
    $url = $baseURL+'/web/api/v2.0/agents'
    $idurl = $url+'?query='+$Query
        
    }

    Process {

        if($RawData){
            $(Invoke-RestMethod -Uri $idurl -Method Get -Headers $header).data
        } else {
            $(Invoke-RestMethod -Uri $idurl -Method Get -Headers $header).data | format-table -Property computerName, osType,osName, lastLoggedInUserName
        }
         

    }
    End {

    }
}