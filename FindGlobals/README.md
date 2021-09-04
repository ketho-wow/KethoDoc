1. **Download FrameXML**  
	Convert any UTF-8-BOM encoded files to UTF-8 to make them readable
  * https://wow.gamepedia.com/Viewing_Blizzard%27s_interface_code
  * Mirror: https://www.townlong-yak.com/framexml
  * Mirror: https://github.com/Gethe/wow-ui-source

2. **Minimal PowerShell example to find all [FindGlobals](https://www.wowace.com/projects/findglobals) SETGLOBALfile occurrences in the FrameXML directory**  
```powershell
Get-ChildItem -Recurse -Name -Filter *.lua |
	Foreach-Object {luac5.1 -l -p $_ |
	lua5.1 "D:\findglobals\globals.lua" $_} |
	Out-File -FilePath API.txt
```
The `Generate-Globals.ps1` script does most of the work and requires [PowerShell 7.x](https://docs.microsoft.com/powershell/scripting/install/installing-powershell-core-on-windows)
