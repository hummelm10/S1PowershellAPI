function Get-S1Apps
{

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory=$false)]
        [string]$AppName,

        [Parameter(Mandatory=$false)]
        [string]$Publisher,

        [Parameter(Mandatory=$false)]
        [string]$ComputerName,

        [Parameter(Mandatory=$false)]
        [string] $ExportCSVPath,

        [switch] $Username, 

        [switch] $NumTotal

    )

    Begin {
        $baseURL="https://$tenant.sentinelone.net"
        if(!$ComputerName){
            if($AppName -And !$Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?name__contains=$AppName&agentIsDecommissioned=false&skipCount=false&limit=100"}
            elseif(!$AppName -And $Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?publisher__contains=$Publisher&agentIsDecommissioned=false&skipCount=false&limit=100"}
            elseif($AppName -And $Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?name__contains=$AppName&publisher__contains=$Publisher&agentIsDecommissioned=false&skipCount=false&limit=100"}
        } else {
            if($AppName -And !$Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?name__contains=$AppName&agentComputerName__contains=$ComputerName&agentIsDecommissioned=false&skipCount=false&limit=1000"}
            elseif(!$AppName -And $Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?publisher__contains=$Publisher&agentComputerName__contains=$ComputerName&agentIsDecommissioned=false&skipCount=false&limit=100"}
            elseif($AppName -And $Publisher){$url = $baseURL+"/web/api/v2.0/installed-applications?name__contains=$AppName&publisher__contains=$Publisher&agentComputerName__contains=$ComputerName&agentIsDecommissioned=false&skipCount=false&limit=100"}
            else{$url = $baseURL+"/web/api/v2.0/installed-applications?agentComputerName__contains=$ComputerName&agentIsDecommissioned=false&skipCount=false&limit=100"}
        } 

    }

    Process {
       Write-Progress -Activity "Searching Machines for Installed Application" -status "Looking for application instances"
        #$(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data | ConvertTo-Json | ConvertFrom-JSON
        $call = Invoke-RestMethod -Uri $url -Method Get -Headers $header
        $output = $call.data | ConvertTo-Json | ConvertFrom-JSON #format-table -Property agentComputerName, agentDomain, agentId, agentMachineType, type, name, publisher, version, riskLevel
        
        while($call.pagination.nextCursor){
            $pagingURL = $url+"&cursor="+$call.pagination.nextCursor
            $call = Invoke-RestMethod -Uri $pagingURL -Method Get -Headers $header
            $output += $call.data | ConvertTo-Json | ConvertFrom-JSON
        }
        
        Write-Host "Total Count of " "$AppName" "$Publisher" ": "$call.pagination.totalItems
        
        if(!$NumTotal) {
            $c = ($output | Measure-Object).Count
            #$c
            $myOutObjectArray = @() 
            for ($i=0; $i -le ($output | Measure-Object).Count-1; $i++) {
                if($Username){Write-Progress -Activity "Searching Machines for Installed Application" -status "Looking for usernames on $i of $c machines" -percentComplete (($i+1)/($c)*100)}
                $outObject = New-Object -TypeName psobject
                $outObject | Add-Member -MemberType NoteProperty -Name "agentComputerName" -Value $output[$i].agentComputerName
                $outObject | Add-Member -MemberType NoteProperty -Name "agentDomain" -Value $output[$i].agentDomain
                $outObject | Add-Member -MemberType NoteProperty -Name "agentId" -Value $output[$i].agentId
                $outObject | Add-Member -MemberType NoteProperty -Name "agentMachineType" -Value $output[$i].agentMachineType
                $outObject | Add-Member -MemberType NoteProperty -Name "type" -Value $output[$i].type
                $outObject | Add-Member -MemberType NoteProperty -Name "name" -Value $output[$i].name
                $outObject | Add-Member -MemberType NoteProperty -Name "publisher" -Value $output[$i].publisher
                $outObject | Add-Member -MemberType NoteProperty -Name "version" -Value $output[$i].version
                $outObject | Add-Member -MemberType NoteProperty -Name "riskLevel" -Value $output[$i].riskLevel
                if($Username){
                    try {
                        $baseURL="https://$tenant.sentinelone.net"
                        $url = $baseURL+'/web/api/v2.0/agents'
                        $idurl = $url+'?query='+$output[$i].agentComputerName
                        $temp = $(Invoke-RestMethod -Uri $idurl -Method Get -Headers $header).data.lastLoggedInUserName
                        $tempString = ""
                        foreach($string in $temp){
                            $tempString += $string 
                        }
                        $outObject | Add-Member -MemberType NoteProperty -Name "lastLoggedInUserName" -Value $tempString
                    } catch {
                        Write-Host "YOU SHOULD NEVER SEE THIS"
                    }
                }
                $myOutObjectArray += $outObject
            }
            $myOutObjectArray | format-table -Auto
            if($ExportCSVPath -And ($output | Measure-Object).Count -gt 0) {
                $myOutObjectArray | Export-Csv -Path $ExportCSVPath -NoTypeInformation
                Write-Host "CSV written to '$ExportCSVPath'"
            }
            #Write-Host $output.Count
            #$url = $url + "&countOnly=true"
            #$(Invoke-RestMethod -Uri $url -Method Get -Headers $header).pagination.totalItems
        } 
    }

    End {
        #lazy adding whitespace at the end of console output
        Write-Host
        Write-Host
    }
}