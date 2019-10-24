function Invoke-S1HashReputation
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Hash
    )

    Begin {

        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/hashes/'+$Hash+'/reputation'
    
    }

    Process {
        try {
            $out = $(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data
            Write-Host $out
        } catch {
            Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
            Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
        }
    }

    End {
    }
}