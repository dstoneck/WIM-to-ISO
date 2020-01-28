function wimiso
{
    # This script is been written for 64bit system. With some minor changes it can be confirured for other platforms
    $Directory = "C:\wimiso\"
    $files = Get-ChildItem ($Directory + "WIM\")
    $wim = $Directory + "Final\images\"
    $Output = $Directory + "Output\" + $file.BaseName
    $Source = $Directory + "Final"
    $EFI = "-b" + $Directory + "fwfiles\Efisys.bin"
    $oscdimg = $Directory + "Oscdimg\oscdimg.exe"
    #& 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools'

    #Checks to see if directory exist it
    If ((Test-Path $Directory) -eq 'False') {
        Invoke-Expression createdirectory | Out-Null
        }

    Write-Host "Ready for to build the wim files into ISO files? `nWim files should be located in " + $Directory + $files
    # The following is the were the system packs the wim file into a ISO for disturbition
    # Most of the ISO are to large for Disc and have to be burned to USB Drives depending on the size of the ISO file
    foreach ($file in $files) {
        $Name = $file.BaseName
        Write-Host $Name
        Move-Item ($Directory + $file) -Destination $wim
        Rename-Item -NewName Win10.wim -Path ($wim + $file.BaseName + ".wim")
        Start-Process -FilePath $oscdimg -ArgumentList @("$EFI", '-pEF', '-u1', '-udfver102', "$Source", "$Output") -PassThru -Wait
        Remove-Item ($wim + "\*.wim")
        Rename-Item -NewName ($file.BaseName + ".iso") -Path $Output


    }

}

function createdirectory {
    # If fails it creates the PS Enviroment to apply the image to the system.
    # The following walks the user on how to create the WinPE enviroment
	Write-Host "Opening Deployment and Imaging Tools Enviroment"
    Write-Host "Enter the following into Deployment and Imaging Tools Env. CLI:"
    Write-Host "copype amd64 c:\wimiso"
    Write-Host "Close out when completed"
    Start-Process -FilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Windows Kits\Windows ADK\Deployment and Imaging Tools Environment.lnk" | Out-Null

    # Mounts the WinPE image to make changes
    Mount-WindowsImage -ImagePath ($Directory + "\media\sources\boot.wim") -Index 1 -Path ($Directory + "\mount")

    # Modify's the start command to apply the image to the system it is booted on. The 2 lines have the DISKPART and DISM apply commands
    Add-Content ($Directory + "\mount\windows\system32\Startnet.cmd") "DISKPART /s x:\CreatePartitions-Win10.txt `ndism /apply-image /imagefile:""x:\images\win10.wim"" /applydir:s: /index:1`ndism /apply-image /imagefile:""x:\images\win10.wim"" /applydir:w: /index:2"
    New-Item   -Path ($Directory + "mount\") -Name "CreatePartitions-Win10.txt" -ItemType "file" -Value "sel disk 0 `nclean `nconvert gpt `ncreate partition primary size=500 `nset id=DE94BBA4-06D1-4D40-A16A-BFD50179D6AC `ngpt attributes=0x8000000000000001 `nformat quick fs=ntfs label="Windows RE tools" `nassign letter=T `ncreate partition efi size=499 `nformat quick fs=fat32 label="System" `nassign letter=S `ncreate partition msr size=128 `ncreate partition primary `ngpt attributes=0x0000000000000000 `nformat quick fs=ntfs label="OSDisk" `nassign letter=W `nrescan `nlist vol `nexit"

    # Unmounts the image from the system
    Dismount-WindowsImage -Path ($Directory + "mount") -Save
     
    # Copies the command to build the directory into a ISO with the wim files.
    # This part may get changed and use the source from the Windows Kit directory
    Copy-Item -Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg" -Destination ($Directory + "Oscdimg") -Recurse

}
wimiso
