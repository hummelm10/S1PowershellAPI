function Set-S1APIKey
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$APIKey
    )

$global:header = @{

    'Authorization' = "APIToken $APIKey"

    'Content-Type' = 'application/json'

}

    try{
        Write-Host "Testing API Key by enumerating groups..."
        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/groups?limit=200'
        $(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data | format-table -Property name, siteId, id
    } catch {
        Write-Host "API call failed, check key and internet access."
    }

}