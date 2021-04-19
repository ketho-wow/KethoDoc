
KethoDoc = {}
local eb = KethoEditBox

KethoDoc.tocVersion = select(4, GetBuildInfo())

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	KethoDoc.isRetail = true
	KethoDoc.branch = IsTestBuild() and "ptr" or "live"
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	KethoDoc.branch = "classic"
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
	KethoDoc.branch = "bc"
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
	eb:InsertLine("local LuaAPI = {")
	for _, apiName in pairs(api) do
		eb:InsertLine(format('\t"%s",', apiName))
	end
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

local EnumTypo = { -- ACCOUNT -> ACCCOUNT (3 Cs)
	LE_FRAME_TUTORIAL_ACCOUNT_CLUB_FINDER_NEW_COMMUNITY_JOINED = "LE_FRAME_TUTORIAL_ACCCOUNT_CLUB_FINDER_NEW_COMMUNITY_JOINED",
}

local function SortEnum(a, b)
	if a.value == b.value then
		return a.name < b.name
	else
		return a.value < b.value
	end
end

-- kind of messy
function KethoDoc:DumpLuaEnums(isEmmyLua, showGameErr)
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
				tinsert(TableEnum, {name = enumType, value = enumValue})
			end
			sort(TableEnum, SortEnum)
			local numberFormat = self.EnumBitGroups[name] and "0x%X" or "%d"
			for _, enum in pairs(TableEnum) do
				eb:InsertLine(format("\t\t%s = %s,", enum.name, format(numberFormat, enum.value)))
			end
			eb:InsertLine("\t},")
		end
	end
	eb:InsertLine("}")

	-- check if a NUM_LE still exists
	for _, NUM_LE in pairs(self.EnumGroups) do
		if type(NUM_LE) == "string" and not _G[NUM_LE] then
			print("Removed: ", NUM_LE)
		end
	end
	local EnumGroup, EnumGroupSorted = {}, {}
	local EnumUngrouped = {}
	-- LE_* globals
	for enumType, enumValue in pairs(_G) do
		if enumType:find("^LE_") then
			if showGameErr or not enumType:find("GAME_ERR") then
				-- group enums together
				local found
				for group, NUM_LE in pairs(self.EnumGroups) do
					local enumType2 = EnumTypo[enumType] or enumType -- hack
					if enumType2:find("^"..group) then
						EnumGroup[group] = EnumGroup[group] or {}
						tinsert(EnumGroup[group], {name = enumType, value = enumValue})
						found = true
						break
					end
				end
				if not found then
					tinsert(EnumUngrouped, {name = enumType, value = enumValue})
				end
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
		sort(group, SortEnum)
	end
	-- print group enums
	for _, group in pairs(EnumGroupSorted) do
		eb:InsertLine("")
		local numEnum = self.EnumGroups[group]
		local groupEnum = _G[numEnum]
		if groupEnum then
			eb:InsertLine(format("%s = %d", numEnum, groupEnum))
		end
		for _, tbl in pairs(EnumGroup[group]) do
			eb:InsertLine(format("%s = %d", tbl.name, tbl.value))
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
	-- not yet categorized enums
	if #EnumUngrouped > 0 then
		eb:InsertLine("\n-- to be categorized")
		sort(EnumUngrouped, SortEnum)
		for _, enum in pairs(EnumUngrouped) do
			eb:InsertLine(format("%s = %d", enum.name, enum.value))
		end
	end
end

function KethoDoc:GetFrames()
	local t = {}
	for _, v in pairs(_G) do
		-- cant interact with forbidden frames; only check for named frames
		if type(v) == "table" and v.IsForbidden and not v:IsForbidden() and v:GetName() then
			local parent = v:GetParent()
			local name = v:GetDebugName()
			if not parent or (parent == UIParent) or (parent == WorldFrame) then
				t[name] = true
			end
		end
	end
	return t
end

function KethoDoc:GetFrameXML()
	local t = {}
	for k in pairs(self.FrameXML[self.branch]) do
		if type(_G[k]) == "function" then
			t[k] = true
		elseif type(_G[k]) == "table" and strfind(k, "Util$") then
			for k2, v2 in pairs(_G[k]) do
				if type(v2) == "function" then
					t[k.."."..k2] = true;
				end
			end
		end
	end
	return t
end

function KethoDoc:DumpFrames()
	self:DumpLodTable("Frames", self.GetFrames, self.initFrames)
end

function KethoDoc:DumpFrameXML()
	self:DumpLodTable("FrameXML", self.GetFrameXML, self.initFrameXML)
end

function KethoDoc:DumpLodTable(label, getFunc, initTbl)
	self:LoadLodAddons()
	local lodTbl = {}
	for name in pairs(getFunc(self)) do
		if not initTbl[name] then
			tinsert(lodTbl, name)
		end
	end
	sort(lodTbl)

	eb:Show()
	eb:InsertLine(format("local %s = {", label))
	for _, name in pairs(self:SortTable(initTbl)) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine("}\n\nlocal LoadOnDemand = {")
	for _, name in pairs(lodTbl) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine(format("}\n\nreturn {%s, LoadOnDemand}", label))
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
