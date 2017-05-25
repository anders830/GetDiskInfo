#region Get-DiskInfo  
Function Get-DiskInfo  
{   
<#

.DESCRIPTION
This function can be used to get the information of disk in specific displayed mode.

.PARAMETER GraphInfo
The description of a parameter1

.PARAMETER RawInfo
The description of a parameter2

.EXAMPLE
C:\PS> Get-DiskInfo -GraphInfo
This command will get the information of disk drive as raw mode.

.EXAMPLE
C:\PS> Get-DiskInfo -RawInfo
This command will get the information of disk drive as color mode.

.EXAMPLE
C:\PS> Get-DiskInfo
This command will get the information of disk drive as color and raw mode.
#>

    Param  
    (  
        [Parameter(Mandatory=$false,ValueFromPipeline=$true)]  
        [Alias("CN")][String]$ComputerName=$Env:COMPUTERNAME,  
        [Parameter(Mandatory=$false)]  
        [Alias("GI")][Switch]$GraphInfo,  
        [Parameter(Mandatory=$false)]  
        [Alias("RI")][Switch]$RawInfo  
    )  
  
    $diskInfo = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType = 3"
       
    if($GraphInfo)  
    {
        Get-ColorDiskInfo($diskInfo)
    }  
    elseif($RawInfo)  
    {
        Get-RawDiskInfo($diskInfo)
    }    
    else
    {
        Get-ColorDiskInfo($diskInfo)
        Get-RawDiskInfo($diskInfo)
    }
}  
#endregion  
  
#region Get-RawDiskInfo  
Function Get-RawDiskInfo($diskInfo) 
{     
    Write-Host "=================== Raw Data ==================="  
  
    $diskInfo|Select-Object @{Name = "Computer Name";Expression={$ComputerName}} `
    ,@{Name = "Drive Name";Expression={$_.DeviceID}} `
    ,@{Name = "Volume Name";Expression={if(($_.VolumeName) -le 0){$_.DeviceID}else{$_.VolumeName}}} `
    ,@{Name = "Free Space";Expression={"{0:N2}" -f ($_.FreeSpace/1GB) + " GB"}}`
    ,@{Name = "Used Space";Expression={"{0:N2}" -f (($_.Size - $_.FreeSpace)/1GB) + " GB"}} `
    ,@{Name = "Total Disk Space";Expression={"{0:N2}" -f ($_.Size/1GB) + " GB"}} | Format-Table -AutoSize  
}  
#endregion  
  
#region Get-ColorDiskInfo  
Function Get-ColorDiskInfo($diskInfo)  
{  
    $Threshold = 40  
    Write-Host "==================== Graph ===================="  
    Write-Host " " -BackgroundColor Red -NoNewline  
    Write-Host " Used Space  |  " -NoNewline  
    Write-Host " " -BackgroundColor Green -NoNewline  
    Write-Host " Free Space"  
    Write-Host  
  
    foreach($disk in $diskInfo)  
    {  
        $DiskDrive = $disk.DeviceID  
        $FreeDiskSize = $disk.FreeSpace/$disk.Size
        $UsedDiskSize = ($disk.Size-$FreeDiskSize)/$disk.Size  
        $FreeDiskPercent = "{0:P2}" -f $FreeDiskSize  
          
        Write-Host "[$ComputerName] " -NoNewline  
        Write-Host "$DiskDrive " -NoNewline  
        Write-Host  (" " *($UsedDiskSize*$Threshold)) -BackgroundColor Red -NoNewline   
        Write-Host  (" " *($FreeDiskSize*$Threshold)) -BackgroundColor Green -NoNewline  
        Write-Host " $FreeDiskPercent Free"  
        Write-Host  
    }  
}  
#endregion  