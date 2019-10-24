function Set-S1Tenant
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Tenant
    )

    $global:tenant = $Tenant

    try{
        Write-Host "Testing Tenant by enumerating groups..."
        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/groups?limit=200'
        $(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data | format-table -Property name, siteId, id
    } catch {
        Write-Host "API call failed, check tenant and internet access."
    }

}