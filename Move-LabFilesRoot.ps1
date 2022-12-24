<#
.Synopsis
    Copy files from subdirectories to root directory.
.DESCRIPTION 
    After downloading your lab files, it will move the files from the modules folder to the root directory file structure.
    All lab files have unique names. 

    Start:

    Course files
    ├── Mod1 
    │   ├── coursefile1.pdf
    │   ├── coursefile2.pdf
    ├── Mod2 
    │   ├── coursefile3.pdf
    ├── Mod3
    │   ├── coursefile4.pdf
    └── 

    End: 

    Course files
    ├── coursefile1.pdf 
    ├── coursefile2.pdf 
    ├── coursefile3.pdf
    └── coursefile4.pdf
.PARAMETER LabFilesPath 
    The valid root path of the location of your Course Files.
.EXAMPLE
    C:\PS>Move-LabFilesRoot -Path C:\CourseFiles 
#>
function Move-LabFilesRoot {
    [CmdletBinding()]
    param (
        # LabFilesPath The root folder of the Course Files.
        [Parameter()]
        [ValidateScript( { Test-Path $PSItem -PathType Container } )]
        [string]
        $LabFilesPath
    )

    if ($LabFilesPath -eq $env:SystemDrive) {
        throw "Do not run this on $($env:SystemDrive)"
    }

    $allFiles = Get-ChildItem -Path $LabFilesPath -Recurse -File

    foreach ($file in $allFiles) {
        Move-Item -Path $file.Fullname -Destination $LabFilesPath -Force
    }

    # Not checking for hidden items 
    $allDirectories = Get-ChildItem -Path $LabFilesPath -Recurse -Directory  

    foreach ($directory in $allDirectories) {
        if ($directory.GetFiles().Count -eq 0) {
            Remove-Item -Path $directory.Fullname -Force 
        }
        else {
            Write-Warning -Message "Did not delete directory: $($directory.Name). Contents may still exist in directory."
        }
    }
}