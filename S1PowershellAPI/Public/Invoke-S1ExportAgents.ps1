function Invoke-S1ExportAgents
{
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$false)]
        [string]$ComputerName, 

        [Parameter(Mandatory=$false)]
        [string]$Username, 

        [Parameter(Mandatory=$false)]
        [switch]$CSV
    )

    Begin {

        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/export/agents'

    }

    Process {
        if($ComputerName -And !$CSV -And !$Username) {
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | Where-Object "Endpoint Name" -Like $ComputerName | format-table
        } elseif($ComputerName -And $CSV -And !$Username) {
            $Export="$pwd\SentinelOne_Agent_Export.csv"
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | Where-Object "Endpoint Name" -Like $ComputerName | Export-Csv -Path $Export -NoTypeInformation
            Write-Host "Wrote CSV to " $Export
        } elseif(!$ComputerName -And $CSV -And !$Username) {
            $Export="$pwd\SentinelOne_Agent_Export.csv"
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | Export-Csv -Path $Export -NoTypeInformation
            Write-Host "Wrote CSV to " $Export
        } elseif(!$ComputerName -And !$CSV -And $Username) {
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | Where-Object "Last Logged In User" -Like $Username | format-table
        } elseif(!$ComputerName -And $CSV -And $Username) {         
            $Export="$pwd\SentinelOne_Agent_Export.csv"
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | Where-Object "Last Logged In User" -Like $Username | Export-Csv -Path $Export -NoTypeInformation
            Write-Host "Wrote CSV to " $Export
        } elseif($ComputerName -And $CSV -And $Username) {
            Write-Host "Cannot search both Username and ComputerName"
        } elseif($ComputerName -And !$CSV -And $Username) {
            Write-Host "Cannot search both Username and ComputerName"
        } else {
            Invoke-RestMethod -Uri $url -Method Get -Headers $header -Body $body | ConvertFrom-Csv | format-table
        }  

    }
    End {
    }
}