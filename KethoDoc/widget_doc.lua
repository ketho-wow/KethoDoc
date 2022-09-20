local WidgetDocumentation
local widget_systems = {
	CooldownFrameAPI = "Cooldown",
	MinimapFrameAPI = "Minimap",
	SimpleAnimAPI = "Animation",
	SimpleAnimAlphaAPI = "Alpha",
	SimpleAnimFlipBookAPI = "FlipBook",
	SimpleAnimGroupAPI = "AnimationGroup",
	SimpleAnimPathAPI = "Path",
	SimpleAnimRotationAPI = "Rotation",
	SimpleAnimScaleAPI = "Scale",
	SimpleAnimScaleLineAPI = "LineScale", -- empty
	SimpleAnimTextureCoordTranslationAPI = "TextureCoordTranslation",
	SimpleAnimTranslationAPI = "Translation",
	SimpleAnimTranslationLineAPI = "LineTranslation", -- empty
	SimpleAnimatableObjectAPI = "AnimatableObject",
	SimpleBrowserAPI = "Browser",
	SimpleButtonAPI = "Button",
	SimpleCheckboxAPI = "CheckButton",
	SimpleColorSelectAPI = "ColorSelect",
	SimpleControlPointAPI = "ControlPoint",
	SimpleEditBoxAPI = "EditBox",
	SimpleFontAPI = "Font",
	SimpleFontStringAPI = "FontString",
	SimpleFrameAPI = "Frame",
	SimpleFrameScriptObjectAPI = "FrameScriptObject",
	SimpleHTMLAPI = "SimpleHTML",
	SimpleLineAPI = "Line",
	SimpleMaskTextureAPI = "MaskTexture", -- empty
	SimpleMessageFrameAPI = "MessageFrame",
	SimpleModelAPI = "Model",
	SimpleModelFFXAPI = "ModelFFX", -- unavailable to addons
	SimpleMovieAPI = "MovieFrame",
	SimpleObjectAPI = "Object",
	SimpleOffScreenFrameAPI = "OffScreenFrame",
	SimpleRegionAPI = "Region",
	SimpleScriptRegionAPI = "ScriptRegion",
	SimpleScriptRegionResizingAPI = "ScriptRegionResizing",
	SimpleScrollFrameAPI = "ScrollFrame",
	SimpleSliderAPI = "Slider",
	SimpleStatusBarAPI = "StatusBar",
	SimpleTextureAPI = "Texture",
	SimpleTextureBaseAPI = "TextureBase",
}

local widget_tests = {
	{
		name = "AnimationGroup",
		actual = CreateFrame("Frame"):CreateAnimationGroup(),
		expected = {"Object", "FrameScriptObject", "AnimationGroup"},
	},
	{
		name = "Alpha",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
		expected = {"Object", "FrameScriptObject", "Animation", "Alpha"},
	},
	{
		name = "Frame",
		actual = CreateFrame("Frame"),
		expected = {"Object", "FrameScriptObject", "AnimatableObject", "ScriptRegion", "ScriptRegionResizing", "Frame"},
	},
	{
		name = "Button",
		actual = CreateFrame("Button"),
		expected = {"Object", "FrameScriptObject", "AnimatableObject", "ScriptRegion", "ScriptRegionResizing", "Frame", "Button"},
	},
	{
		name = "CheckButton",
		actual = CreateFrame("CheckButton"),
		expected = {"Object", "FrameScriptObject", "AnimatableObject", "ScriptRegion", "ScriptRegionResizing", "Frame", "Button", "CheckButton"},
	},
}

local function CopyKeys(dest, src)
	for k in pairs(src) do
		dest[k] = true
	end
end

local function GetTableSize(tbl)
	local c = 0
	for _ in pairs(tbl) do
		c = c + 1
	end
	return c
end

local function GetExpectedWidget(expected)
	local t = {}
	for _, system in pairs(expected) do
		CopyKeys(t, WidgetDocumentation[system])
	end
	return t
end

local function TestWidget(unit_test)
	local actual = getmetatable(unit_test.actual).__index
	local expected = GetExpectedWidget(unit_test.expected)
	local equals = true
	for method in pairs(expected) do
		if not actual[method] then
			equals = false
			print("--|cffffff00wrongly expected|r", method)
		end
	end
	for method in pairs(actual) do
		if not expected[method] then
			equals = false
			print("--|cffff0000missing|r", method)
		end
	end
	local sizeText = format("%d/%d actual/expected", GetTableSize(actual), GetTableSize(expected))
	local resultText = equals and "|cff00ff00success|r:" or "|cffff0000failed|r:"
	print(resultText, unit_test.name, sizeText)
end

function KethoDoc:GetWidgetDocs()
	APIDocumentation_LoadUI()
	WidgetDocumentation = {}
	for _, system in pairs(APIDocumentation.systems) do
		if system.Type == "ScriptObject" then
			local t = {}
			for _, func in pairs(system.Functions) do
				t[func.Name] = true
			end
			WidgetDocumentation[widget_systems[system.Name]] = t
		end
	end
	for _, test in pairs(widget_tests) do
		TestWidget(test)
	end
end
