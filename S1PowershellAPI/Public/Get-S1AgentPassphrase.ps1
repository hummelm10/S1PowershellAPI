function Get-S1AgentPassphrase
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [string]$Query, 

        [switch]$IsDecommissioned
    )

    Begin {

    $baseURL='https://'+$tenant+'.sentinelone.net'
    $url = $baseURL+'/web/api/v2.0/agents/passphrases'
    $idurl = $url+'?query='+$Query
        
    }

    Process {

        #$(Invoke-RestMethod -Uri "https://$tenant.sentinelone.net/web/api/v2.0/agents?query=" -Method Get -Headers $header).data.lastLoggedInUserName
        if($IsDecommissioned){
            $idurl = $idurl+"&isDecommissioned=true"
        }
        $(Invoke-RestMethod -Uri $idurl -Method Get -Headers $header).data | format-table

    }
    End {

    }
}