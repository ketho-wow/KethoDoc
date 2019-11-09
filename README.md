### Dumps the WoW API for [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources)
Every patch `framexml_<branch>.lua` has to be manually updated by running [FindGlobals](https://www.wowace.com/projects/findglobals) on the [FrameXML](https://wow.gamepedia.com/Viewing_Blizzard%27s_interface_code)

| Function | Description   
| --- | ---
| `KethoDoc:DumpGlobalAPI()` | Dumps WoW API
| `KethoDoc:DumpWidgetAPI()` | Dumps Widget API
| `KethoDoc:DumpEvents()`    | Dumps Events by API system
| `KethoDoc:DumpCVars()`     | Dumps Console Variables and Commands
| `KethoDoc:DumpLuaEnums()`  | Dumps Lua Enums
| `KethoDoc:DumpFrames()`    | Dumps top-level frames
| `KethoDoc:DumpFrameXML()`  | Dumps FrameXML functions

The text is shown in an editbox

![](https://i.imgur.com/Ym5xebg.png)
