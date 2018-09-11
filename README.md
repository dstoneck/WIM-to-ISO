# WIM-to-ISO
Build ISO Installers from the WIM file

This was designed to build the .wim files into a ISO to reinstall on the desktops/laptops in the field

This does require the DISM.exe from Microsoft https://docs.microsoft.com/en-us/windows-hardware/get-started/adk-install

The way this tool works is it will complies wims into there own seperate iso files.

The ISO are built using a base WINPE to apply the wim to the system

Working on building a version that will build the WinPE directory system and then wrap the wim file with it.

Update: Sept 10, 2018

Changes were made to the script to generate the folders needed to create the wim and to modify the files needed to format/reimage upon booting from media
