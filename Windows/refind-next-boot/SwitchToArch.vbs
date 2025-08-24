Set WshShell = WScript.CreateObject("WScript.Shell")
If WScript.Arguments.Length = 0 Then
  Set ObjShell = CreateObject("Shell.Application")
  ObjShell.ShellExecute "wscript.exe" _
    , """" & WScript.ScriptFullName & """ RunAsAdministrator", , "runas", 1
  WScript.Quit
End if

Set WshShell = CreateObject("WScript.Shell")

' Change directory to the script's location
WshShell.CurrentDirectory = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)

' Run the refind-next-boot command
WshShell.Run "refind-next-boot ""Arch Linux""", 0, True

' Shutdown the system (restart immediately)
WshShell.Run "shutdown -r -t 0 -f", 0, False