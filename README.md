### Dumps the WoW API for [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources)
Requires disabling the [Blizzard_Deprecated](https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_Deprecated) addon, subsequently any deprecated API will not be tracked but omitted altogether. Dumping the FrameXML globals with FindGlobals is no longer needed.

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
