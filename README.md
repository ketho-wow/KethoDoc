### Dumps the WoW API for [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources)
* The text is shown in an editbox
* Every patch `framexml_branch.lua` has to be manually updated with [FindGlobals](https://www.wowace.com/projects/findglobals)

| Function | Description   
| --- | ---
| `KethoDoc:DumpGlobalAPI()`      | Dumps WoW API
| `KethoDoc:DumpLuaAPI()`         | Dumps Lua API
| `KethoDoc:DumpWidgetAPI()`      | Dumps Widget API
| `KethoDoc:DumpEvents()`         | Dumps Events grouped by API system
| `KethoDoc:DumpCVars()`          | Dumps Console Variables and Commands
| `KethoDoc:DumpLuaEnums()`       | Dumps Enum table and Lua Enums
| `KethoDoc:DumpUIParentFrames()` | Dumps UIParent child frames
| `KethoDoc:DumpFrameXML()`       | Dumps FrameXML functions
