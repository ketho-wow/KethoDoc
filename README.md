### Dumps the WoW API for [BlizzardInterfaceResources](https://github.com/Ketho/BlizzardInterfaceResources)
Requires disabling the [Blizzard_Deprecated](https://github.com/Gethe/wow-ui-source/tree/live/Interface/AddOns/Blizzard_Deprecated) addon; any deprecated API will be omitted.

It's no longer needed to dump the FrameXML globals with FindGlobals.

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
