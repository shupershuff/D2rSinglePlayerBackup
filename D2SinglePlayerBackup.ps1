<#
Author: Shupershuff
Version: 1.0
Usage:
	Close D2r if open. Run script to move Diablo 2 save folder from "C:\Users\<USERNAME>\Saved Games\Diablo II Resurrected" to your chosen cloud storage.
Purpose:
	Quick and easy way for folk to ensure game saves are saved to the cloud instead of local only.
	
Instructions: See GitHub readme https://github.com/shupershuff/D2rSinglePlayerBackup


Notes: 
- Google Drive only works if it's configured to store files locally AND on the cloud. In other words, the "Mirror files" option is chosen instead of "Stream files"/
- If ya want to do this yourself (for anything) without a script, just copy the data to a cloud sync'd path and use this command in CMD: mklink /J <DefaultSaveGamePath> <CloudSaveGamePath>

#>
##################
# Config Options #
##################
$SaveFolderName = "Saved Games" #Name of the folder which will be created.

##########
# Script #
##########
[console]::WindowWidth=86 + $env:username.length + $SaveFolderName.length
write-host
write-host " This script will ensure your game files are saved in a cloud sync'd location."
write-host
$DefaultSaveGamePath = ("C:\Users\" + $env:username + "\Saved Games\Diablo II Resurrected")
$OneDriveSavePath = ("C:\Users\" + $env:username + "\OneDrive\")
$DropboxSavePath = ("C:\Users\" + $env:username + "\Dropbox\")
$GoogleDriveSavePath =  ("C:\Users\" + $env:username + "\My Drive\")

###Check if junction has already been created ###
$SavedGamesFolder = ("C:\Users\" + $env:username + "\Saved Games")
# Run cmd's dir command to get junction info, ensuring the path is quoted
$junctionInfo = cmd /c "dir `"$SavedGamesFolder`" /AL"
# Define a regex pattern to match the "Diablo II Resurrected" junction and its target path
$regexPattern = "\s+<JUNCTION>\s+Diablo II Resurrected\s+\[([^\]]+)\]"

# Check if the output contains the specific junction target path for "Diablo II Resurrected"
if ("$junctionInfo" -match $regexPattern){ #Warn user if they've already ran this script and moved the game folder.
    # Extract the target path using the match
    $JunctionTarget = $matches[1]
	$RecreateJunction = $True
	Write-Host " Warning, the D2r Savegame folder is already redirected." -foregroundcolor yellow
	Write-host " This is currently pointing to: $JunctionTarget" -foregroundcolor yellow
	Write-host
	Write-host " If you're happy with game files already being saved to this cloud folder, close the script now." -foregroundcolor yellow
	Write-host " Otherwise, continue with the script to point it to the new cloud location." -foregroundcolor yellow
	pause
	Write-host
}
else {
    Write-Verbose "No junction for 'Diablo II Resurrected' found in $SavedGamesFolder."
}

do {
	$LastOption = 3
	$OptionText = " or 3"
	write-host " Options are:"
	write-host "  1 - OneDrive"
	write-host "  2 - Dropbox"
	write-host "  3 - Google Drive"
	if ($RecreateJunction -eq $True) {
		write-host "  4 - Move folder back to default (local) location"
		$LastOption ++
		$OptionText = ", 3 or 4"
	}
	write-host
	$CloudOption = read-host " Enter the option would you like to choose and press enter (1, 2$OptionText)"
	if ($CloudOption -notin 1..$LastOption){
		write-host " Please choose option 1, 2$OptionText.`n" -foregroundcolor red
	}
} until ($CloudOption -in 1..$LastOption)
if ($CloudOption -eq 1){
	write-host " Configuring for OneDrive...`n"
	$CloudSaveGamePath = ($OneDriveSavePath + $SaveFolderName + "\Diablo II Resurrected")
}
if ($CloudOption -eq 2){
	write-host " Configuring for Dropbox...`n"
	$CloudSaveGamePath = ($DropboxSavePath + $SaveFolderName + "\Diablo II Resurrected")
}
if ($CloudOption -eq 3){
	write-host " Configuring for Google Drive...`n"
	$CloudSaveGamePath = ($GoogleDriveSavePath + $SaveFolderName + "\Diablo II Resurrected")
	write-host " Note, for this to save to the cloud, you need to configure Google Drive to store files locally AND" -foregroundcolor yellow
	write-host " on the cloud." -foregroundcolor yellow
	Write-host " To do this, go into Google Drive preferences and change My Drive syncing options from 'Stream files'" -foregroundcolor yellow
	write-host " to 'Mirror files'.`n" -foregroundcolor yellow
	pause
}
if ($RecreateJunction -eq $True){
	write-verbose "Removing Existing Junction"
	Remove-Item -Path $DefaultSaveGamePath -recurse -Force
	New-Item $DefaultSaveGamePath -type directory | out-null
	write-verbose "Moving Savegame data from previous junction target back to default location"
	Get-ChildItem -Path $JunctionTarget | Copy-Item -Destination $DefaultSaveGamePath -Force -recurse
	if ($CloudOption -eq 4){
		Write-Host " Moved Saved Game data back to default location.`n " -nonewline -foregroundcolor green
		$DefaultSaveGamePath
		Write-Host
		pause
		Exit
	}
}
if (!(Test-Path -path $CloudSaveGamePath)) {
	New-Item $CloudSaveGamePath -type directory | out-null
	Write-host " Created Directory: $CloudSaveGamePath" -foregroundcolor green
}
try {
	Get-ChildItem -Path $DefaultSaveGamePath | Copy-Item -Destination $CloudSaveGamePath -Force -recurse
	Remove-Item -Path $DefaultSaveGamePath -recurse -Force
	Write-host " Moved D2r Saves to $CloudSaveGamePath " -foregroundcolor green
	cmd /c "mklink /J `"$DefaultSaveGamePath`" `"$CloudSaveGamePath`"" | out-null
	Write-host " Junction created in Saved Games folder to $CloudSaveGamePath." -foregroundcolor green
	Write-host "`n Script finished succesfully.`n" -foregroundcolor green
}
Catch {
	Write-host "`n Oh stink, something went wrong.`n" -foregroundcolor red
}
pause
