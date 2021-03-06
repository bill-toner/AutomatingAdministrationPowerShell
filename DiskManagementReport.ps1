cls
Write-Host "Disk Management Report" -BackgroundColor DarkCyan

$Servers = Import-Csv C:\Users\Administrator.ADATUM\Documents\servers.csv

Foreach ($Server in $Servers)
{
  Try
  {

    $Disk = Get-WmiObject -ComputerName $Server.ServerName -Class Win32_LogicalDisk | ? {$_.DeviceID -eq "C:"}
    [int] $percent = ($Disk.Freespace/$Disk.Size) * 100

    $Disk | ? {$_.DeviceID -eq "C:"} | FT `
    @{Label = "ComputerName" ; Expression = {$_.PSComputerName}}, `
    @{Label = "Drive Letter" ; Expression = {$_.DeviceID}}, `
    @{Label = "C Drive Total Space in GB" ; Expression = {[math]::round(($_.Size/1GB),2)}}, `
    @{Label = "C Drive Freespace in GB " ; Expression = {[math]::round(($_.Freespace/1GB),2)}}, `
    @{Label = "Freespace%" ; Expression = {[int](($_.Freespace/$_.Size) * 100)}}

    $Disk | ? {$_.DeviceID -eq "C:"} | Select `
    @{Label = "ComputerName" ; Expression = {$_.PSComputerName}}, `
    @{Label = "Drive Letter" ; Expression = {$_.DeviceID}}, `
    @{Label = "C Drive Total Space in GB" ; Expression = {[math]::round(($_.Size/1GB),2)}}, `
    @{Label = "C Drive Freespace in GB" ; Expression = {[math]::round(($_.Freespace/1GB),2)}}, `
    @{Label = "Freespace%" ; Expression = {[int](($_.Freespace/$_.Size) * 100)}} | Export-Csv C:\Users\Administrator.ADATUM\Documents\DiskReport.csv -Append
  }
  Catch
  {
    Write-Host "Unable to connect to the server"
  }
}
