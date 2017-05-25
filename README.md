## GetDiskInfo.ps1

This PowerShell script can be used to get the disk info as different.

```
.DESCRIPTION
This function can be used to get the information of disk in specific displayed mode.

.PARAMETER GraphInfo
This is a switch parameter, it will get the information of disk drive as graph mode.

.PARAMETER RawInfo
This is a switch parameter, it will get the information of disk drive as raw mode.

.EXAMPLE
C:\PS> Get-DiskInfo -GraphInfo
This command will get the information of disk drive as raw mode.

.EXAMPLE
C:\PS> Get-DiskInfo -RawInfo
This command will get the information of disk drive as color mode.

.EXAMPLE
C:\PS> Get-DiskInfo
This command will get the information of disk drive as color and raw mode.
```

![](https://github.com/anders830/GetDiskInfo/blob/master/GetDiskInfo.png)
