function Invoke-S1HashClass
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Hash
    )

    Begin {

        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/hashes/'+$Hash+'/classification'

    
    }

    Process {
        try {
            Invoke-RestMethod -Uri $url -Method Get -Headers $header
        } catch {
            Write-Host "Hash not classified."
            Invoke-S1HashReputation -Hash $Hash
        }
    }

    End {
    }
}