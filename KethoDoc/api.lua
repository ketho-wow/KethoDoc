-- deprecated / script wrapper API
local augments = {
	C_Timer = {
		NewTicker = true,
		NewTimer = true,
	}
}

local deprecated = {
	C_AreaPoiInfo = {
		GetAreaPOITimeLeft = true,
	},
	C_Calendar = {
		GetDate = true,
	},
	C_ChatInfo = {
		ReportPlayer = true,
		CanReportPlayer = true,
	},
	C_Club = {
		AddClubStreamToChatWindow = true,
	},
	C_DateAndTime = {
		GetDateFromEpoch = true,
		GetTodaysDate = true,
		GetYesterdaysDate = true,
	},
	C_PvP = {
		GetBrawlInfo = true,
		GetMatchPVPStatIDs = true,
	},
	C_RecruitAFriend = {
		IsSendingEnabled = true,
		CheckEmailEnabled = true,
		SendRecruit = true,
	},
	C_Social = {
		GetLastScreenshot = true,
		GetScreenshotByIndex = true,
		GetNumCharactersPerMedia = true,
	},
	C_Timer = augments.C_Timer,
}

local IsClassic = (KethoDoc.branch == "classic")
local blacklist = IsClassic and augments or deprecated

KethoDoc.FrameXmlBlacklist = {
	-- these globals are set through _G instead
	Blizzard_CombatLog_Update_QuickButtons = true,
	CombatLog_Color_ColorArrayByEventType = true,
	CombatLog_Color_ColorArrayBySchool = true,
	CombatLog_Color_ColorArrayByUnitType = true,
	CombatLog_Color_ColorStringByEventType = true,
	CombatLog_Color_ColorStringBySchool = true,
	CombatLog_Color_ColorStringByUnitType = true,
	CombatLog_Color_FloatToText = true,
	CombatLog_Color_HighlightColorArray = true,
	CombatLog_OnEvent = true,
	CombatLog_String_DamageResultString = true,
	CombatLog_String_GetIcon = true,
	CombatLog_String_PowerType = true,
	CombatLog_String_SchoolString = true,
	COMBAT_TEXT_SCROLL_FUNCTION = true, -- set within a function

	-- DressUpFrames.xml
	OnMaximize = true,
	OnMinimize = true,
}

KethoDoc.LuaAPI = { -- see compat.lua
	abs = true, -- math.abs
	acos = true, -- function (x) return math.deg(math.acos(x)) end
	asin = true, -- function (x) return math.deg(math.asin(x)) end
	assert = true,
	atan = true, -- function (x) return math.deg(math.atan(x)) end
	atan2 = true, -- function (x,y) return math.deg(math.atan2(x,y)) end
	--bit
	ceil = true, -- math.ceil
	collectgarbage = true,
	--coroutine
	cos = true, -- function (x) return math.cos(math.rad(x)) end
	date = true,
	deg = true, -- math.deg
	difftime = true,
	error = true,
	exp = true, -- math.exp
	floor = true, -- math.floor
	foreach = true, -- table.foreach
	foreachi = true, -- table.foreachi
	fastrandom = true, -- wow lua
	format = true, -- string.format
	frexp = true, -- math.frexp
	gcinfo = true,
	getfenv = true,
	getmetatable = true,
	getn = true, -- table.getn
	gmatch = true, -- string.gmatch
	gsub = true, -- string.gsub
	ipairs = true,
	ldexp = true, -- math.ldexp
	loadstring = true,
	log = true, -- math.log
	log10 = true, -- math.log10
	max = true, -- math.max
	--math
	min = true, -- math.min
	mod = true, -- math.fmod
	newproxy = true,
	next = true,
	pairs = true,
	pcall = true,
	rad = true, -- math.rad
	random = true, -- math.random
	rawequal = true,
	rawget = true,
	rawset = true,
	select = true,
	setfenv = true,
	setmetatable = true,
	sin = true, -- function (x) return math.sin(math.rad(x)) end
	sort = true, -- table.sort
	sqrt = true, -- math.sqrt
	--string
	strbyte = true, -- string.byte
	strchar = true, -- string.char
	strcmputf8i = true, -- wow lua
	strconcat = true, -- wow lua
	strfind = true, -- string.find
	strjoin = true, -- string.join; wow lua
	strlen = true, -- string.len
	strlenutf8 = true, -- wow lua
	strlower = true, -- string.lower
	strmatch = true, -- string.match
	strrep = true, -- string.rep
	strrev = true, -- string.reverse
	strsplit = true, -- string.split; wow lua
	strsub = true, -- string.sub
	strtrim = true, -- string.trim; wow lua
	strupper = true, -- string.upper
	--table
	tan = true, -- function (x) return math.tan(math.rad(x)) end
	time = true,
	tinsert = true, -- table.insert
	tonumber = true,
	tostring = true,
	tremove = true, -- table.remove
	type = true,
	unpack = true,
	wipe = true, -- table.wipe; wow lua
	xpcall = true,
}

KethoDoc.LuaApiBlacklist = {
	["string.rtgsub"] = true, -- RestrictedTable_rtgsub()
}

function KethoDoc:GetGlobalFuncs()
	local t = {}
	for k, v in pairs(_G) do
		if type(v) == "function" then
			t[k] = true
		end
	end
	return t
end

function KethoDoc:GetApiSystemFuncs()
	local t = {}
	for systemName, v in pairs(_G) do
		if systemName:find("^C_") and type(v) == "table" then
			for funcName in pairs(v) do
				if not blacklist[systemName] or not blacklist[systemName][funcName] then
					tinsert(t, format("%s.%s", systemName, funcName))
				end
			end
		end
	end
	sort(t)
	return t
end
