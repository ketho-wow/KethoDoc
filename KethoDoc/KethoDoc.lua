
KethoDoc = {}
local eb = KethoEditBox

local build = select(4, GetBuildInfo())
local branches = {
	[80205] = "live",
	[80300] = "ptr",
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

			if object.unique_methods then
				eb:InsertLine("\t\tmethods = {")
				local methods = self:SortTable(object.unique_methods())
				for _, name in pairs(methods) do
					eb:InsertLine('\t\t\t"'..name..'",')
				end
				eb:InsertLine("\t\t},")
			end

			if object.intrinsic then
				eb:InsertLine(format('\t\tmixin = "%s",', object.mixin))
				eb:InsertLine("\t\tintrinsic = true,")
			end
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
			if not v.command:find("^CACHE") then -- these just keep switching between false/nil
				local _, defaultValue, server, character = GetCVarInfo(v.command)
				-- every time they change the category they seem to lose the help text
				local helpString = v.help and #v.help > 0 and v.help:gsub('"', '\\"') or self.cvars.ptr.var[v.command].help or ""
				tinsert(cvarTbl, cvarFs:format(v.command, defaultValue or "", v.category, tostring(server), tostring(character), helpString))
			end
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

-- kind of messy
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

	local EnumGroup, EnumGroupSorted = {}, {}
	local EnumUngrouped = {}
	-- LE_* globals
	for enumType, enumValue in pairs(_G) do
		if enumType:find("^LE_") and not enumType:find("GAME_ERR") then
			-- try to group enums together so we can sort by value
			local found
			for group in pairs(self.EnumGroups) do
				if enumType:find("^"..group) then
					EnumGroup[group] = EnumGroup[group] or {}
					tinsert(EnumGroup[group], {enumType, enumValue})
					found = true
					break
				end
			end
			if not found then
				tinsert(EnumUngrouped, {enumType, enumValue})
			end
		end
	end
	-- sort groups by name
	for groupName in pairs(EnumGroup) do
		tinsert(EnumGroupSorted, groupName)
	end
	sort(EnumGroupSorted)
	-- sort values in groups
	for group, tbl in pairs(EnumGroup) do
		sort(tbl, function(a, b)
			return a[2] < b[2]
		end)
	end
	-- print group enums
	for _, group in pairs(EnumGroupSorted) do
		local numEnum = self.EnumGroups[group]
		if type(numEnum) == "string" then
			eb:InsertLine(format("%s = %d", numEnum, _G[numEnum]))
		end
		for _, values in pairs(EnumGroup[group]) do
			eb:InsertLine(format("%s = %d", values[1], values[2]))
		end
		eb:InsertLine("")
	end

	-- print any NUM_LE_* globals not belonging to a group
	local NumLuaEnum, NumEnumCache = {}, {}
	for enum, value in pairs(_G) do
		if enum:find("^NUM_LE_") then
			NumLuaEnum[enum] = value
		end
	end
	for _, numEnum in pairs(self.EnumGroups) do
		NumEnumCache[numEnum] = true
	end
	for numEnum in pairs(NumLuaEnum) do
		if not NumEnumCache[numEnum] then
			eb:InsertLine(format("%s = %d", numEnum, _G[numEnum]))
		end
	end

	-- print not yet grouped enums
	if #EnumUngrouped > 0 then
		eb:InsertLine("\n-- to be categorized")
		sort(EnumUngrouped, function(a, b)
			return a[1] < b[1]
		end)
		for _, enum in pairs(EnumUngrouped) do
			eb:InsertLine(format("%s = %d", enum[1], enum[2]))
		end
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
