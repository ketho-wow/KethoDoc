
KethoDoc = {}
local eb = KethoEditBox

local build = select(4, GetBuildInfo())
local branches = {
	[80200] = "live",
	[80205] = "ptr",
	[11302] = "classic",
}

KethoDoc.branch = branches[build]

function KethoDoc:DumpGlobalAPI()
	local frameXML = CopyTable(self.FrameXML[self.branch])
	self:InsertTable(self.FrameXmlBlacklist, frameXML)
	self:InsertTable(self.LuaAPI, frameXML)
	local api = self:GetApiSystemFuncs()

	-- filter all functions against FrameXML functions and Lua API
	for funcName in pairs(self:GetGlobalFuncs()) do
		if not frameXML[funcName] then
			tinsert(api, funcName)
		end
	end
	sort(api)

	eb:Show()
	eb:InsertLine("local GlobalAPI = {")
	for _, apiName in pairs(api) do
		eb:InsertLine(format('\t"%s",', apiName))
	end
	eb:InsertLine("}\n\nreturn GlobalAPI")
end

function KethoDoc:DumpLuaAPI()
	local api = {}
	for apiName in pairs(self.LuaAPI) do
		tinsert(api, apiName)
	end

	for _, tblName in pairs({"bit", "coroutine", "math", "string", "table"}) do
		for methodName, value in pairs(_G[tblName]) do
			if type(value) == "function" then -- ignore math.PI, math.huge
				tinsert(api, format("%s.%s", tblName, methodName))
			end
		end
	end
	sort(api)

	eb:Show()
	eb:InsertLine("local LuaAPI = {")
	for _, apiName in pairs(api) do
		eb:InsertLine(format('\t"%s",', apiName))
	end
	eb:InsertLine("}\n\nreturn LuaAPI")
end

-- wannabe table serializer
function KethoDoc:DumpWidgetAPI()
	if not self.WidgetClasses then
		self:SetupWidgets()
	end
	eb:Show()
	eb:InsertLine("local WidgetAPI = {")
	for _, objectName in pairs(self.WidgetOrder) do
		local object = self.WidgetClasses[objectName]
		if object.meta_object then -- sanity check for Classic
			eb:InsertLine("\t"..objectName.." = {")
			local inheritsTable = {}
			for _, v in pairs(object.inherits) do
				tinsert(inheritsTable, format('"%s"', v)) -- stringify
			end
			eb:InsertLine(format("\t\tinherits = {%s},", table.concat(inheritsTable, ", ")))

			if object.unique_handlers then
				local handlers = self:SortTable(object.unique_handlers())
				if next(handlers) then
					eb:InsertLine("\t\thandlers = {")
					for _, name in pairs(handlers) do
						eb:InsertLine('\t\t\t"'..name..'",')
					end
					eb:InsertLine("\t\t},")
				end
			end

			eb:InsertLine("\t\tmethods = {")
			local methods = self:SortTable(object.unique_methods())
			for _, name in pairs(methods) do
				eb:InsertLine('\t\t\t"'..name..'",')
			end
			eb:InsertLine("\t\t},")
			eb:InsertLine("\t},")
		end
	end
	eb:InsertLine("}\n\nreturn WidgetAPI")
end

function KethoDoc:DumpEvents()
	APIDocumentation_LoadUI()
	eb:Show()
	eb:InsertLine("local Events = {")

	sort(APIDocumentation.systems, function(a, b)
		return (a.Namespace or a.Name) < (b.Namespace or b.Name)
	end)

	for _, system in pairs(APIDocumentation.systems) do
		if #system.Events > 0 then -- skip systems with no events
			eb:InsertLine("\t"..(system.Namespace or system.Name).." = {")
			for _, event in pairs(system.Events) do
				eb:InsertLine(format('\t\t"%s",', event.LiteralName))
			end
			eb:InsertLine("\t},")
		end
	end
	eb:InsertLine("}\n\nreturn Events")
end

function KethoDoc:DumpCVars()
	local cvarTbl, commandTbl = {}, {}
	local cvarFs = '\t\t["%s"] = {"%s", %d, %s, %s, "%s"},'
	local commandFs = '\t\t["%s"] = {%d, "%s"},'

	for _, v in pairs(C_Console.GetAllCommands()) do
		if v.commandType == Enum.ConsoleCommandType.Cvar then
			local _, defaultValue, server, character = GetCVarInfo(v.command)
			local helpString = v.help and v.help:gsub('"', '\\"') or ""
			tinsert(cvarTbl, cvarFs:format(v.command, defaultValue or "", v.category, tostring(server), tostring(character), helpString))
		elseif v.commandType == Enum.ConsoleCommandType.Command then
			tinsert(commandTbl, commandFs:format(v.command, v.category, v.help or ""))
		end
	end
	sort(cvarTbl, self.SortCaseInsensitive)
	sort(commandTbl, self.SortCaseInsensitive)

	eb:Show()
	eb:InsertLine("local CVars = {")
	eb:InsertLine("\tvar = {")
	eb:InsertLine("\t\t-- var = default, category, server, character, help")
	for _, cvar in pairs(cvarTbl) do
		eb:InsertLine(cvar)
	end
	eb:InsertLine("\t},")

	eb:InsertLine("\tcommand = {")
	eb:InsertLine("\t\t-- command = category, help")
	for _, command in pairs(commandTbl) do
		eb:InsertLine(command)
	end
	eb:InsertLine("\t},\n}\n\nreturn CVars")
end

function KethoDoc:DumpLuaEnums()
	-- Enum table
	eb:Show()
	eb:InsertLine("Enum = {")
	local enums = {}
	for name in pairs(Enum) do
		tinsert(enums, name)
	end
	sort(enums)

	for _, name in pairs(enums) do
		local TableEnum = {}
		eb:InsertLine("\t"..name.." = {")
		for enumType, enumValue in pairs(Enum[name]) do
			tinsert(TableEnum, {enumType, enumValue})
		end
		sort(TableEnum, function(a, b)
			return a[2] < b[2]
		end)
		for _, enum in pairs(TableEnum) do
			eb:InsertLine(format("\t\t%s = %d,", enum[1], enum[2]))
		end
		eb:InsertLine("\t},")
	end
	eb:InsertLine("}\n")

	-- NUM_LE_* globals
	local NumLuaEnum, LuaEnum = {}, {}
	for enumType, enumValue in pairs(_G) do
		if enumType:find("^NUM_LE_") then
			tinsert(NumLuaEnum, {enumType, enumValue})
		end
	end
	sort(NumLuaEnum, function(a, b)
		return a[1] < b[1]
	end)
	for _, enum in pairs(NumLuaEnum) do
		eb:InsertLine(format("%s = %d", enum[1], enum[2]))
	end
	eb:InsertLine("")

	-- LE_* globals
	for enumType, enumValue in pairs(_G) do
		if enumType:find("^LE_") and not enumType:find("GAME_ERR") then
			tinsert(LuaEnum, {enumType, enumValue})
		end
	end
	-- cba to filter by enum value and group, too difficult
	sort(LuaEnum, function(a, b)
		return a[1] < b[1]
	end)
	for _, enum in pairs(LuaEnum) do
		eb:InsertLine(format("%s = %d", enum[1], enum[2]))
	end
end

function KethoDoc:DumpFrames()
	self:LoadLodAddons()
	local frames = {}
	for _, v in pairs(_G) do
		-- cant interact with forbidden frames; only check for named frames
		if type(v) == "table" and v.IsForbidden and not v:IsForbidden() and v:GetName() then
			local parent = v:GetParent()
			if not parent or (parent == UIParent) or (parent == WorldFrame) then
				frames[v:GetDebugName()] = true
			end
		end
	end
	eb:Show()
	eb:InsertLine("local Frames = {")
	for _, name in pairs(self:SortTable(frames)) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nreturn Frames")
end

function KethoDoc:DumpFrameXML()
	self:LoadLodAddons()
	local funcs = {}
	for k in pairs(self.FrameXML[self.branch]) do
		if type(_G[k]) == "function" then
			tinsert(funcs, k)
		end
	end
	sort(funcs)

	eb:Show()
	eb:InsertLine("local FrameXML = {")
	for _, name in pairs(funcs) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nreturn FrameXML")
end
