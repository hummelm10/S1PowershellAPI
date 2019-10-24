#Get public and private function definition files.
    $Public  = @( Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue )
    $Private = @( Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
    Foreach($import in @($Public + $Private))
    {
        Try
        {
            . $import.fullname
        }
        Catch
        {
            Write-Error -Message "Failed to import function $($import.fullname): $_"
        }
    }

    [xml]$configFile= Get-Content $PSScriptRoot\Config.xml

$global:header = @{
    'Authorization' = "APIToken "+$configFile.configuration.appsettings.add[0].value

    'Content-Type' = 'application/json'
}

    $global:tenant = $configFile.configuration.appsettings.add[1].value
    Export-ModuleMember -Function $Public.Basename