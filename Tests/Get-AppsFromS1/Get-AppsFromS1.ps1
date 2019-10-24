 # * $apps = "mikogo","zoho","remotepc","onnectwise","teamviewer","logmein","pcanywhere","tightvnc","splashtop","radmin"

$apps = "cyberduck"

foreach($line in $apps) {
    try
    {
      Write-Host "Searching for $line..."
      Get-S1Apps -AppName $line -ExportCSVPath "AppExport $line.csv" -Username
    }
    catch
    {
      
    }
    
}