function wimiso
{
    $Directory = "C:\WIMtoISO\"
    $files = Get-ChildItem "C:\WIMtoISO\WIM\"
    $wim = "C:\WIMtoISO\Final\images\"
    $Output = "C:\WIMtoISO\Output\Completed.iso"
    $Source = "C:\WIMtoISO\Final"
    $EFI = "-bC:\WIMtoISO\fwfiles\Efisys.bin"
    $oscdimg = "C:\WIMtoISO\Oscdimg\oscdimg.exe"
    #& 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools'

    foreach ($file in $files) {
        $Name = $file.BaseName
        Write-Host $Name
        Move-Item ("C:\WIMtoISO\WIM\" + $file) -Destination $wim
        Rename-Item -NewName Win10.wim -Path ($Directory + "Final\images\" + $file.BaseName + ".wim")
        Start-Process -FilePath $oscdimg -ArgumentList @("$EFI", '-pEF', '-u1', '-udfver102', "$Source", "$Output") -PassThru -Wait
        Remove-Item ($wim + "\*.wim")
        Rename-Item -NewName ($file.BaseName + ".iso") -Path $Output


    }

}

wimiso
