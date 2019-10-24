#Pull users from AD Group
$users = Get-AdGroupMember -identity "IT Security Crew"
#// $users += Get-AdGroupMember -identity "IT Network Engineering"
#// $users += Get-AdGroupMember -identity "ITPlatformEngineering"
#// $users += Get-AdGroupMember -identity "ITSystemEngineering"

$myOutObjectArray = @() 
$i=0
$c = $users.Count
foreach($user in $users) {
    Write-Progress -Activity "Looking up users" -status "Searching machines $i of $c machines" -percentComplete (($i+1)/($c)*100)
    try {
        $raw = Get-S1Agent -Query $user.SAMAccountName -RawData
        foreach($data in $raw){
            $outObject = New-Object -TypeName psobject
            $outObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $user.name
            $outObject | Add-Member -MemberType NoteProperty -Name "UserName" -Value $data.lastLoggedInUserName
            $outObject | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $data.computerName
            $temp = $data.networkInterfaces.inet -join ', '
            $outObject | Add-Member -MemberType NoteProperty -Name "IP" -Value $temp
            $myOutObjectArray += $outObject
        }
        
    }catch{}
    $i++
}
$myOutObjectArray | Format-Table -AutoSize