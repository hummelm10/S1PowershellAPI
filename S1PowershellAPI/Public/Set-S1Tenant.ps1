function Set-S1Tenant
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$Tenant
    )

    $global:tenantTemp = $Tenant

    try{
        Write-Host "Testing Tenant by enumerating groups..."
        $baseURL='https://'+$tenant+'.sentinelone.net'
        $url = $baseURL+'/web/api/v2.0/groups?limit=200'
        $(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data | format-table -Property name, siteId, id
        $global:tenant = $tenantTemp
	    [xml]$configFile= Get-Content "$PSScriptRoot\..\Config.xml"
	    $configFile.configuration.appsettings.add[1].value = $Tenant
	    $path="$PSScriptRoot\..\Config.xml"
	    $configFile.Save($path)
    } catch {
        Write-Host "API call failed, check tenant and internet access."
    }

}