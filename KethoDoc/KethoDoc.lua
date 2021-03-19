
KethoDoc = {}
local eb = KethoEditBox

--local tocVersion = select(4, GetBuildInfo())

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	KethoDoc.branch = "live"
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	KethoDoc.branch = "classic"
end

function KethoDoc:GetAPI()
	local api = {}
	self:InsertTable(api, self:GetCNamespaceAPI())
	local nonApi = {}
	self:InsertTable(nonApi, self.FrameXML[self.branch])
	self:InsertTable(nonApi, self.FrameXmlBlacklist)
	self:InsertTable(nonApi, self.LuaAPI)
	-- filter all global functions against FrameXML functions and Lua API
	for funcName in pairs(self:GetGlobalFuncs()) do
		if not nonApi[funcName] then
			api[funcName] = true
		end
	end
	return api
end

function KethoDoc:DumpGlobalAPI()
	local api = self:GetAPI()

	eb:Show()
	eb:InsertLine("local GlobalAPI = {")
	for _, apiName in pairs(self:SortTable(api)) do
		eb:InsertLine(format('\t"%s",', apiName))
	end
	eb:InsertLine("}\n")
	self:DumpLuaAPI()

	eb:InsertLine("}\n\nreturn {GlobalAPI, LuaAPI}")
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
	tDeleteItem(api, "string.rtgsub") -- RestrictedTable_rtgsub()
	sort(api)

	--eb:Show()
	eb:InsertLine("local LuaAPI = {")
	for _, apiName in pairs(api) do
		eb:InsertLine(format('\t"%s",', apiName))
	end
	--eb:InsertLine("}\n\nreturn LuaAPI")
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

			if object.unique_methods and not object.mixin then
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
	local test_cvarTbl, test_commandTbl = {}, {}
	local cvarFs = '\t\t["%s"] = {"%s", %d, %s, %s, "%s"},'
	local commandFs = '\t\t["%s"] = {%d, "%s"},'

	for _, v in pairs(C_Console.GetAllCommands()) do
		if v.commandType == Enum.ConsoleCommandType.Cvar then
			if not v.command:find("^CACHE") then -- these just keep switching between false/nil
				local _, defaultValue, server, character = GetCVarInfo(v.command)
				-- every time they change the category they seem to lose the help text
				local backupDesc = self.cvar_cache[v.command]
				local helpString = v.help and #v.help > 0 and v.help:gsub('"', '\\"') or backupDesc or ""
				local tbl = self.cvar_test[v.command] and test_cvarTbl or cvarTbl
				tinsert(tbl, cvarFs:format(v.command, defaultValue or "", v.category, tostring(server), tostring(character), helpString))
			end
		elseif v.commandType == Enum.ConsoleCommandType.Command then
			local tbl = self.cvar_test[v.command] and test_commandTbl or commandTbl
			local helpString = v.help and #v.help > 0 and v.help:gsub('"', '\\"') or ""
			tinsert(tbl, commandFs:format(v.command, v.category, helpString))
		end
	end
	for _, tbl in pairs({cvarTbl, commandTbl, test_cvarTbl, test_commandTbl}) do
		sort(tbl, self.SortCaseInsensitive)
	end

	eb:Show()
	eb:InsertLine("local CVars = {")
	eb:InsertLine("\tvar = {")
	eb:InsertLine("\t\t-- var = default, category, account, character, help")
	for _, cvar in pairs(cvarTbl) do
		eb:InsertLine(cvar)
	end
	eb:InsertLine("\t},")

	eb:InsertLine("\tcommand = {")
	eb:InsertLine("\t\t-- command = category, help")
	for _, command in pairs(commandTbl) do
		eb:InsertLine(command)
	end
	eb:InsertLine("\t},\n}\n")

	if #test_cvarTbl > 0 then
		eb:InsertLine("local PTR = {")
		eb:InsertLine("\tvar = {")
		for _, cvar in pairs(test_cvarTbl) do
			eb:InsertLine(cvar)
		end
		eb:InsertLine("\t},")
		eb:InsertLine("\tcommand = {")
		for _, command in pairs(test_commandTbl) do
			eb:InsertLine(command)
		end
		eb:InsertLine("\t},\n}")
	else
		eb:InsertLine("local PTR = {}")
	end

	eb:InsertLine("\nreturn {CVars, PTR}")
end

local EnumOrder = { -- some special enums share the same value
	LE_EXPANSION_LEVEL_PREVIOUS = true,
	LE_EXPANSION_LEVEL_CURRENT = true,
}

local EnumTypo = { -- ACCOUNT -> ACCCOUNT; yes they use 3 Cs
	LE_FRAME_TUTORIAL_ACCOUNT_CLUB_FINDER_NEW_COMMUNITY_JOINED = "LE_FRAME_TUTORIAL_ACCCOUNT_CLUB_FINDER_NEW_COMMUNITY_JOINED",
}

-- kind of messy
function KethoDoc:DumpLuaEnums(isEmmyLua)
	-- Enum table
	eb:Show()
	eb:InsertLine("Enum = {")
	local enums = {}
	for name in pairs(Enum) do
		if not isEmmyLua or not name:find("Meta$") then
			tinsert(enums, name)
		end
	end
	sort(enums)

	if isEmmyLua then
		for _, name in pairs(enums) do
			eb:InsertLine("\t---@type "..name)
			eb:InsertLine("\t"..name.." = {},")
		end
	else
		for _, name in pairs(enums) do
			local TableEnum = {}
			eb:InsertLine("\t"..name.." = {")
			for enumType, enumValue in pairs(Enum[name]) do
				tinsert(TableEnum, {enumType, enumValue})
			end
			sort(TableEnum, function(a, b)
				return a[2] < b[2]
			end)
			local isBitflag = self.EnumBitGroups[name]
			local numberFormat = isBitflag and "0x%X" or "%d"
			for _, enum in pairs(TableEnum) do
				eb:InsertLine(format("\t\t%s = %s,", enum[1], format(numberFormat, enum[2])))
			end
			eb:InsertLine("\t},")
		end
	end
	eb:InsertLine("}")

	local EnumGroup, EnumGroupSorted = {}, {}
	local EnumUngrouped = {}
	-- LE_* globals
	for enumType, enumValue in pairs(_G) do
		if enumType:find("^LE_") and not enumType:find("GAME_ERR") then
			-- try to group enums together so we can sort by value
			local found
			for group in pairs(self.EnumGroups) do
				local enumType2 = EnumTypo[enumType] or enumType -- hack
				if enumType2:find("^"..group) then
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
	for _, group in pairs(EnumGroup) do
		sort(group, function(a, b)
			if a[2] == b[2] then -- handle enums with same values
				if EnumOrder[a[1]] then
					return false
				elseif EnumOrder[b[1]] then
					return true
				end
			else
				return a[2] < b[2]
			end
		end)
	end
	-- print group enums
	for _, group in pairs(EnumGroupSorted) do
		eb:InsertLine("")
		local numEnum = self.EnumGroups[group]
		if type(numEnum) == "string" then
			eb:InsertLine(format("%s = %d", numEnum, _G[numEnum]))
		end
		for _, values in pairs(EnumGroup[group]) do
			eb:InsertLine(format("%s = %d", values[1], values[2]))
		end
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

function KethoDoc:PreloadFrames()
	self.frames = {}
	for _, v in pairs(_G) do
		-- cant interact with forbidden frames; only check for named frames
		if type(v) == "table" and v.IsForbidden and not v:IsForbidden() and v:GetName() then
			local parent = v:GetParent()
			if not parent or (parent == UIParent) or (parent == WorldFrame) then
				self.frames[v:GetDebugName()] = true
			end
		end
	end
end

function KethoDoc:DumpFrames()
	self:LoadLodAddons()
	local lodframes = {}
	for _, v in pairs(_G) do
		if type(v) == "table" and v.IsForbidden and not v:IsForbidden() and v:GetName() then
			local parent = v:GetParent()
			local name = v:GetDebugName()
			if not self.frames[name] and (not parent or (parent == UIParent) or (parent == WorldFrame)) then
				tinsert(lodframes, name)
			end
		end
	end
	local frames = self:SortTable(self.frames)
	sort(lodframes)

	eb:Show()
	eb:InsertLine("local Frames = {")
	for _, name in pairs(frames) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nlocal LoadOnDemand = {")
	for _, name in pairs(lodframes) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nreturn {Frames, LoadOnDemand}")
end

function KethoDoc:PreloadFrameXML()
	self.funcs = {}
	for k in pairs(KethoDoc.FrameXML[KethoDoc.branch]) do
		if type(_G[k]) == "function" then
			self.funcs[k] = true
		end
	end
end

function KethoDoc:DumpFrameXML()
	self:LoadLodAddons()
	local lodfuncs = {}
	for k in pairs(self.FrameXML[self.branch]) do
		if not self.funcs[k] and type(_G[k]) == "function" then
			tinsert(lodfuncs, k)
		end
	end
	local funcs = self:SortTable(self.funcs)
	sort(lodfuncs)

	eb:Show()
	eb:InsertLine("local FrameXML = {")
	for _, name in pairs(funcs) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nlocal LoadOnDemand = {")
	for _, name in pairs(lodfuncs) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nreturn {FrameXML, LoadOnDemand}")
end

-- non blizzard documented api
function KethoDoc:DumpNonBlizzardDocumented()
	local api = self:GetAPI()
	local BAD = {}
	UIParentLoadAddOn("Blizzard_APIDocumentation")
	for _, apiTable in pairs(APIDocumentation.functions) do
		if apiTable.System.Namespace then
			BAD[apiTable.System.Namespace.."."..apiTable.Name] = true
		else
			BAD[apiTable.Name] = true
		end
	end
	local nonDoc = {}
	for name in pairs(api) do
		if not BAD[name] then
			nonDoc[name] = true
		end
	end

	eb:Show()
	eb:InsertLine("local NonBlizzardDocumented = {")
	for _, name in pairs(self:SortTable(nonDoc)) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nreturn NonBlizzardDocumented")
end

local currentDump = 0
local api = {
	"GetBuildInfo",
	"DumpGlobalAPI",
	"DumpWidgetAPI",
	"DumpEvents",
	"DumpCVars",
	"DumpLuaEnums",
	"DumpFrames",
	"DumpFrameXML",
}

function KethoDoc:GetBuildInfo()
	local fs = 'GetBuildInfo() => "%s", "%s", "%s", %d'
	eb:Show(fs:format(GetBuildInfo()))
end

function KethoDoc:LazyDump()
	currentDump = currentDump + 1
	local func = self[api[currentDump]]
	if func then
		func(self)
	end
end
