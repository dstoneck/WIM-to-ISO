function wimiso
{
    $Directory = "D:\WIMtoISO\"
    #$files = Get-ChildItem -Attributes I:\Images\Images -Include *.wim -Recurse
    $wim = "D:\WIMtoISO\Final\images\"
    $Source = "D:\WIMtoISO\Final"
    $EFI = "-bD:\WIMtoISO\fwfiles\Efisys.bin"
    $oscdimg = "D:\WIMtoISO\Oscdimg\oscdimg.exe"
    $FY = (Read-Host "Fiscal Year (FY18Q3)")
    $FYPATH = "\\server\Approved Images\" + $FY

    If ((Test-Path $FYPATH) -eq 'False')
        {
            Write-Host "Path good" -BackgroundColor Green
        }
        else        
        {
            Write-Host "Creating Fiscal Year Directory "$FY
            New-Item -Path ($FYPATH) -ItemType directory
        }

    Invoke-Expression wimdell | Out-Null
    Invoke-Expression wimhp | Out-Null
    Invoke-Expression wimlen | Out-Null

}

function wimdell
{
    $files = Get-ChildItem -Attributes I:\Images\Images\Dell -Include *.wim -Recurse
    $Output = "\\server\Approved Images\" + $FY + "\Dell\" + $Name + ".iso"

    foreach ($file in $files) {
        $Name = $file.BaseName
        Write-Host $Name
        Copy-Item $file -Destination $wim
        Rename-Item -NewName Win10.wim -Path ($wim + $file.BaseName + ".wim")
        Start-Process -FilePath $oscdimg -ArgumentList @("$EFI", '-pEF', '-u1', '-udfver102', "$Source", "$Output") -PassThru -Wait
        Remove-Item ($wim + "*.wim")
    }
}


function wimhp
{
    $files = Get-ChildItem -Attributes I:\Images\Images\Hewlett-Packard -Include *.wim -Recurse
    $Output = "\\server\Approved Images\" + $FY + "\Hewlett-Packard\" + $Name + ".iso"

    foreach ($file in $files) {
        $Name = $file.BaseName
        Write-Host $Name
        Copy-Item $file -Destination $wim
        Rename-Item -NewName Win10.wim -Path ($wim + $file.BaseName + ".wim")
        Start-Process -FilePath $oscdimg -ArgumentList @("$EFI", '-pEF', '-u1', '-udfver102', "$Source", "$Output") -PassThru -Wait
        Remove-Item ($wim + "*.wim")
    }
}


function wimlen
{
    $files = Get-ChildItem -Attributes I:\Images\Images\Lenovo -Include *.wim -Recurse
    $Output = "\\server\Approved Images\" + $FY + "\Lenovo\" + $Name + ".iso"

    foreach ($file in $files) {
        $Name = $file.BaseName
        Write-Host $Name
        Copy-Item $file -Destination $wim
        Rename-Item -NewName Win10.wim -Path ($wim + $file.BaseName + ".wim")
        Start-Process -FilePath $oscdimg -ArgumentList @("$EFI", '-pEF', '-u1', '-udfver102', "$Source", "$Output") -PassThru -Wait
        Remove-Item ($wim + "*.wim")
    }
}


wimiso
