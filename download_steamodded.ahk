#Persistent  ; Keeps the script running
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance off

; Check if the script is running as administrator
if not A_IsAdmin
{
    ; Try to relaunch the script with administrator privileges
    Run, *RunAs "%A_ScriptFullPath%",, UseErrorLevel
    
    ; Check for an error during relaunch
    if ErrorLevel
    {
        MsgBox, Failed to launch script with administrator privileges.
    }
    ExitApp  ; Exit the current script instance if not running as admin
}

EnvGet, appDataPath, APPDATA
; Replace the URL and the file path as needed
url := "https://github.com/Steamopollys/Steamodded/releases/latest/download/steamodded_injector.exe"
filePath := appDataPath . "\Balatro\steamodded_injector.exe"

; PowerShell command to add the file to Windows Defender exclusions
psCommand := "Add-MpPreference -ExclusionPath '" . filePath . "'"

; Run the PowerShell command
Run, powershell.exe -Command %psCommand%, , Hide

; PowerShell command to add the file to Windows Defender exclusions
psCommand := "Add-MpPreference -ExclusionProcess 'steamodded_injector.exe'"

; Run the PowerShell command
Run, powershell.exe -Command %psCommand%, , Hide

Sleep, 3000

; PowerShell command to download the file using System.Net.WebClient
psDownloadCommand := "$client = New-Object System.Net.WebClient; $client.DownloadFile('" . url . "', '" . filePath . "')"

; Run the PowerShell download command and check for success
RunWait, powershell.exe -Command %psDownloadCommand%, , Hide, OutputVar

; Check if the file exists to verify it was downloaded
FileGetSize, fileSize, %filePath%

if (ErrorLevel == 0 && fileSize > 0) ; Check if file exists and is greater than 0 bytes
{
    MsgBox, The injector has been downloaded to %filePath%
}
else
{
    MsgBox, Failed to download the injector. Please check your internet connection and try again.
}

ExitApp
