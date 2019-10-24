function Get-S1GroupList
{
    Begin {
        $baseURL="https://$tenant.sentinelone.net"
        $url = $baseURL+'/web/api/v2.0/groups?limit=200'    
    }

    Process {

        $(Invoke-RestMethod -Uri $url -Method Get -Headers $header).data | format-table -Property name, siteId, id

    }
    End {

    }
}