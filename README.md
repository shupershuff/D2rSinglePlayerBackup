# Overview
Yeah gidday.<br>
<br>
Thought I'd make a quick and easy way for folk to ensure their Diablo 2 Resurrected game saves are saved to the cloud instead of local only.<br>
This is useful if you want to ensure you have a backup of your game files incase your computer spontaneously combusts and/or if you want to play the same game saves across multiple computers.

This script works by copying your save game data to a cloud sync'd location (OneDrive/Dropbox/Google Drive) and creating a junction in the original location so the game still thinks the files are in the same location.<br>

# Usage
1. Use OneDrive/Dropbox/Google Drive.
2. Download script (D2SinglePlayerBackup.ps1).
3. Run script and choose the relevant option.
4. Begin sighing in relief instead of crying in disbelief in the instance your save files get corrupted/lost.

![image](https://github.com/user-attachments/assets/edc1533a-4765-463a-a85d-f86f343aa12f)

Note: If using Google Drive, ensure you have 'Mirror files' option enabled:
![image](https://github.com/user-attachments/assets/5610d63d-cb9d-4bce-beeb-bdde72a21a37)


# Links:
- https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/mklink
- https://learn.microsoft.com/en-us/windows/win32/fileio/hard-links-and-junctions
- https://www.youtube.com/watch?v=dQw4w9WgXcQ
