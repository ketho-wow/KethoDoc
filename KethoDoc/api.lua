KethoDoc.LuaAPI = { -- see compat.lua
	--bit = true,
	--coroutine = true,
	--math = true,
	--string = true,
	--table = true,

	abs = true, -- math.abs
	acos = true, -- function (x) return math.deg(math.acos(x)) end
	asin = true, -- function (x) return math.deg(math.asin(x)) end
	assert = true,
	atan = true, -- function (x) return math.deg(math.atan(x)) end
	atan2 = true, -- function (x,y) return math.deg(math.atan2(x,y)) end
	ceil = true, -- math.ceil
	collectgarbage = true,
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
	strsplittable = true, -- wow lua
	strsub = true, -- string.sub
	strtrim = true, -- string.trim; wow lua
	strupper = true, -- string.upper
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

local LuaFrameXml = {
	acos = true,
	asin = true,
	atan = true,
	atan2 = true,
	cos = true,
	sin = true,
	tan = true,
}

-- /me headpats meorawr and ferronn
function KethoDoc:isFramexml(func)
	---@diagnostic disable-next-line: discard-returns
	return pcall(function() coroutine.create(func) end)
end

function KethoDoc:GetGlobalAPI()
	local api_func, framexml_func = {}, {}
	for k, v in pairs(_G) do
		if type(v) == "function" then
			if self:isFramexml(v) then
				framexml_func[k] = true
			else
				api_func[k] = true
			end
		end
	end
	for k in pairs(self.LuaAPI) do
		api_func[k] = nil
	end
	for k in pairs(LuaFrameXml) do
		framexml_func[k] = nil
	end
	if C_AddOns.IsAddOnLoaded("Blizzard_PTRFeedback") then
		-- EdiitMode securehooks
		api_func.UpdateUIParentPosition = nil
		-- Blizzard_PTRFeedback securehooks
		api_func.SetItemRef = nil
		api_func.QuestMapLogTitleButton_OnEnter = nil -- mainline
		api_func.QuestLog_Update = nil -- classic
		api_func.FauxScrollFrame_Update = nil -- classic
	end
	return api_func, framexml_func
end

function KethoDoc:GetNamespaceAPI()
	local t = {}
	for systemName, v in pairs(_G) do
		if type(systemName) == "string" and systemName:find("^C_") and type(v) == "table" then
			for funcName in pairs(v) do
				local name = format("%s.%s", systemName, funcName)
				t[name] = true
			end
		end
	end
	return t
end
