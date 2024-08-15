
KethoDoc = {}
local eb = KethoEditBox

local toc = select(4, GetBuildInfo())

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
	KethoDoc.isMainline = true
	KethoDoc.branch = "mainline"
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
	KethoDoc.branch = "vanilla"
elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
	KethoDoc.branch = "cata"
end

local ptr_realms = {
	[909] = "Anasterian",
	[912] = "Broxigar",
	[969] = "Nobundo",
	[3296] = "Benedictus",
	[3299] = "Lycanthoth",
	-- classic_era
	[5533] = "Classic Era PTR",
}

local beta_realms = {
	-- 11.0.0
	[970] = "Khadgar",
	[976] = "Alleria",
	-- 11.0.2
	[4184] = "These Go To Eleven",
}

local realmId = GetRealmID()

if beta_realms[realmId] then
	KethoDoc.branch = "mainline_beta"
-- elseif IsTestBuild() or ptr_realms[realmId] then
-- 	KethoDoc.branch = KethoDoc.branch.."_ptr"
end

if IsPublicBuild() then
	if GetCVarBool("loadDeprecationFallbacks") then
		print("|cff71d5ffKethoDoc:|r Please click |cFFFFFF00|Haddon:KethoDoc|h[Reload]|h|r to disable CVar loadDeprecationFallbacks and avoid dumping deprecated API.")
		hooksecurefunc("SetItemRef", function(link)
			local linkType, addon = strsplit(":", link)
			if linkType == "addon" and addon == "KethoDoc" then
				C_CVar.SetCVar("loadDeprecationFallbacks", 0)
				-- use a custom cvar instead of savedvariables
				C_CVar.RegisterCVar("KethoDoc")
				C_CVar.SetCVar("KethoDoc", 1)
				C_UI.Reload()
			end
		end)
	elseif C_CVar.GetCVarBool("KethoDoc") then
		print("|cff71d5ffKethoDoc:|r Deprecations are unloaded.")
		C_CVar.SetCVar("KethoDoc", 0)
	end
end


function KethoDoc:FixDocumentation()
	if not MAX_STABLE_SLOTS then -- 10.2.7
		MAX_STABLE_SLOTS = -1
		EXTRA_PET_STABLE_SLOT = -1
		NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = -1
	end
	if not Constants.PetConsts then -- 11.0.2
		Constants.PetConsts = {
			MAX_STABLE_SLOTS = -1,
			EXTRA_PET_STABLE_SLOT = -1,
			NUM_PET_SLOTS_THAT_NEED_LEARNED_SPELL = -1,
		}
	end
end

function KethoDoc:GetAPI()
	local api_func, framexml_func = self:GetGlobalAPI()
	self:InsertTable(api_func, self:GetNamespaceAPI())
	return api_func, framexml_func
end

function KethoDoc:DumpGlobalAPI()
	local api = self:GetAPI()
	eb:Show()
	eb:InsertLine("local GlobalAPI = {")
	for _, tbl in pairs(self:SortTable(api, "key")) do
		eb:InsertLine(format('\t"%s",', tbl.key))
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

function KethoDoc:DumpWidgetAPI()
	if not self.WidgetClasses then
		self:SetupWidgets()
	end
	eb:Show()
	eb:InsertLine("local WidgetAPI = {")
	for _, objectName in pairs(self.WidgetOrder) do
		local object = self.WidgetClasses[objectName]
		if object and object.meta_object then -- sanity check for Classic
			eb:InsertLine("\t"..objectName.." = {")
			local inheritsTable = {}
			for _, v in pairs(object.inherits) do
				tinsert(inheritsTable, format('"%s"', v)) -- stringify
			end
			eb:InsertLine(format("\t\tinherits = {%s},", table.concat(inheritsTable, ", ")))

			if object.unique_handlers then
				local handlers = self:SortTable(object.unique_handlers(), "key")
				if next(handlers) then
					eb:InsertLine("\t\thandlers = {")
					for _, tbl in pairs(handlers) do
						eb:InsertLine('\t\t\t"'..tbl.key..'",')
					end
					eb:InsertLine("\t\t},")
				end
			end
			if object.unique_methods and not object.mixin then
				eb:InsertLine("\t\tmethods = {")
				local methods = self:SortTable(object.unique_methods(), "key")
				for _, tbl in pairs(methods) do
					eb:InsertLine('\t\t\t"'..tbl.key..'",')
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
	self:FixDocumentation()
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
	local cvarFs = '\t\t["%s"] = {"%s", %d, %s, %s, %s, "%s"},'
	local commandFs = '\t\t["%s"] = {%d, "%s"},'

	for _, v in pairs(ConsoleGetAllCommands()) do
		if v.commandType == Enum.ConsoleCommandType.Cvar then
			-- these just keep switching between false/nil
			if not v.command:find("^CACHE") and v.command ~= "KethoDoc" then
				local _, defaultValue, server, character, _, secure = C_CVar.GetCVarInfo(v.command)
				-- every time they change the category they seem to lose the help text
				local cvarCache = self.cvar_cache.var[v.command]
				if cvarCache then
					-- the category resets back to 5 seemingly randomly
					if v.category == 5 then
						v.category = cvarCache[2]
					end
				end
				local helpString = ""
				if v.help and #v.help > 0 then
					helpString = v.help
				elseif cvarCache and cvarCache[6] then
					helpString = cvarCache[6]
				end
				helpString = helpString:gsub('"', '\\"')
				local tbl = self.cvar_test[v.command] and test_cvarTbl or cvarTbl
				tinsert(tbl, cvarFs:format(v.command, defaultValue or "", v.category, tostring(server), tostring(character), tostring(secure), helpString))
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
	eb:InsertLine("\t\t-- var = default, category, account, character, secure, help")
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

local function SortEnum(a, b)
	if a.value ~= b.value then
		return a.value < b.value
	else
		return a.name < b.name
	end
end

-- pretty dumb way without even using bitwise op
local function IsBitEnum(tbl, name)
	local t = tInvert(tbl)
	if name == "Damageclass" then
		return true
	end
	for i = 1, 3 do
		if not t[2^i] then
			return false
		end
	end
	if t[3] or t[5] or t[7] then
		return false
	end
	return true
end

-- kind of messy; need to refactor this
function KethoDoc:DumpLuaEnums(showGameErr)
	self.EnumGroups = {}
	for _, v in pairs(self.EnumGroupsIndexed) do
		self.EnumGroups[v[1]] = v[2]
	end
	-- Enum table
	eb:Show()
	eb:InsertLine("Enum = {")
	local enums = {}
	for name in pairs(Enum) do
		if not name:find("Meta$") then
			tinsert(enums, name)
		end
	end
	sort(enums)

	for _, name in pairs(enums) do
		local TableEnum = {}
		eb:InsertLine("\t"..name.." = {")
		for enumType, enumValue in pairs(Enum[name]) do
			tinsert(TableEnum, {name = enumType, value = enumValue})
		end
		sort(TableEnum, SortEnum)
		local numberFormat = IsBitEnum(Enum[name], name) and "0x%X" or "%disable"
		for _, enum in pairs(TableEnum) do
			if type(enum.value) == "string" then -- 64 bit enum
				numberFormat = '"%s"'
			-- elseif enum.value < 0 then
			-- 	numberFormat = "%d"
			end
			eb:InsertLine(format("\t\t%s = %s,", enum.name, format(numberFormat, enum.value)))
		end
		eb:InsertLine("\t},")
	end
	eb:InsertLine("}")
	self:DumpConstants()

	-- check if a NUM_LE still exists
	-- for _, NUM_LE in pairs(self.EnumGroups) do
	-- 	if type(NUM_LE) == "string" and not _G[NUM_LE] then
	-- 		print("Removed: ", NUM_LE)
	-- 	end
	-- end
	local EnumGroup, EnumGroupSorted = {}, {}
	local EnumUngrouped = {}
	-- LE_* globals
	for enumType, enumValue in pairs(_G) do
		if type(enumType) == "string" and enumType:find("^LE_") and (showGameErr or not enumType:find("GAME_ERR")) then
			-- group enums together
			local found
			for _, group in pairs(self.EnumGroupsIndexed) do
				if enumType:find("^"..group[1]) then
					EnumGroup[group[1]] = EnumGroup[group[1]] or {}
					tinsert(EnumGroup[group[1]], {name = enumType, value = enumValue})
					found = true
					break
				end
			end
			if not found then
				tinsert(EnumUngrouped, {name = enumType, value = enumValue})
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
		if type(enum) == "string" and enum:find("^NUM_LE_") then
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

function KethoDoc:DumpConstants()
	if Constants then
		eb:InsertLine("\nConstants = {")
		for _, t1 in pairs(self:SortTable(Constants, "key")) do
			eb:InsertLine(format("\t%s = {", t1.key))
			for _, t2 in pairs(self:SortTable(t1.value, "value")) do
				eb:InsertLine(format("\t\t%s = %s,", t2.key, t2.value))
			end
			eb:InsertLine("\t},")
		end
		eb:InsertLine("}")
	end
end

function KethoDoc:GetFrames()
	local t = {}
	for _, v in pairs(_G) do
		-- cant interact with forbidden frames; only check for named frames
		-- font objects can be forbidden (and have no parent)
		if type(v) == "table" and v.IsForbidden and not v:IsForbidden() and v:GetName() and v.GetParent then
			local parent = v:GetParent()
			local name = v:GetDebugName()
			if not parent or (parent == UIParent) or (parent == WorldFrame) then
				t[name] = true
			end
		end
	end
	t.KethoFrame = nil
	t.KethoDocEditBox = nil
	return t
end

function KethoDoc:GetFrameXML()
	local _, t = self:GetAPI()
	for namespace, v in pairs(_G) do
		if type(namespace) == "string" and type(v) == "table" and namespace:find("Util$") then
			for funcname, v2 in pairs(v) do
				if type(v2) == "function" then
					local name = format("%s.%s", namespace, funcname)
					t[name] = true
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
	for _, tbl in pairs(self:SortTable(initTbl, "key")) do
		eb:InsertLine(format('\t"%s",', tbl.key))
	end
	eb:InsertLine("}\n\nlocal LoadOnDemand = {")
	for _, name in pairs(lodTbl) do
		eb:InsertLine(format('\t"%s",', name))
	end
	eb:InsertLine(format("}\n\nreturn {%s, LoadOnDemand}", label))
end

function KethoDoc:DumpNonBlizzardDocumented()
	local api = self:GetAPI()
	local BAD = {}
	UIParentLoadAddOn("Blizzard_APIDocumentation")
	for _, apiTable in pairs(APIDocumentation.functions) do
		if apiTable.System.Namespace then
			local name = format("%s.%s", apiTable.System.Namespace, apiTable.Name)
			BAD[name] = true
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
	for _, tbl in pairs(self:SortTable(nonDoc, "key")) do
		eb:InsertLine(format('\t"%s",', tbl.key))
	end
	eb:InsertLine("}\n\nreturn NonBlizzardDocumented")
end

-- for auto marking globals in vscode extension
function KethoDoc:DumpGlobals()
	self:LoadLodAddons()
	KethoDocData = {api = {}, other = {}}
	for k, v in pairs(_G) do
		if type(k) == "string" and not k:find("Ketho") and not k:find("table: ") then
			if type(v) == "function" and not self:isFramexml(v) then
				KethoDocData.api[k] = true
			else
				KethoDocData.other[k] = true
			end
		end
	end
end

local currentDump = 0
local api = {
	"GetBuildInfo",
	"DumpGlobalAPI",
	"DumpWidgetAPI",
	"DumpLuaEnums", -- dump enums before applying doc fixes
	"DumpEvents",
	"DumpCVars",
	"DumpFrames",
	"DumpFrameXML",
	"WidgetTest",
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
