function Set-S1APIKey
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [string]$APIKey
    )

$headerTemp = @{

    'Authorization' = "APIToken "+$APIKey

    'Content-Type' = 'application/json'

}

    try{
        Write-Host "Testing API Key by enumerating groups..."
        $baseURL='https://'+$tenant+'.sentinelone.net'
        $url = $baseURL+'/web/api/v2.0/groups?limit=200'
        $(Invoke-RestMethod -Uri $url -Method Get -Headers $headerTemp).data | format-table -Property name, siteId, id
        $global:header = $headerTemp
        #Test header saved properly in variable
        Invoke-RestMethod -Uri $url -Method Get -Headers $header | Out-Null
        [xml]$configFile= Get-Content "$PSScriptRoot\..\Config.xml"
	    $configFile.configuration.appsettings.add[0].value = $APIKey
	    $path="$PSScriptRoot\..\Config.xml"
	    $configFile.Save($path)
    } catch {
        Write-Host "API call failed, check key and internet access."
    }

    

}