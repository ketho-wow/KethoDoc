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
	-- ScriptRegionSharedDocumentation
	-- SharedScriptObjectModelLightDocumentation
}

local widget_tests = {
	{
		name = "Texture",
		actual = CreateFrame("Frame"):CreateTexture(),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Region", "TextureBase", "Texture"},
	},
	{
		name = "MaskTexture",
		actual = CreateFrame("Frame"):CreateMaskTexture(),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Region", "TextureBase", "MaskTexture"},
	},
	{
		name = "Line",
		actual = CreateFrame("Frame"):CreateLine(),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Region", "TextureBase", "Line"},
	},
	{
		name = "Font",
		actual = CreateFont(""),
		expected = {"FrameScriptObject", "Font"},
	},
	{
		name = "FontString",
		actual = CreateFrame("Frame"):CreateFontString(),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Region", "FontString"},
	},
	{
		name = "AnimationGroup",
		actual = CreateFrame("Frame"):CreateAnimationGroup(),
		expected = {"Object", "FrameScriptObject", "AnimationGroup"},
	},
	{
		name = "Animation",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
		expected = {"Object", "FrameScriptObject", "Animation"},
	},
	{
		name = "Alpha",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
		expected = {"Object", "FrameScriptObject", "Animation", "Alpha"},
	},
	{
		name = "Rotation",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
		expected = {"Object", "FrameScriptObject", "Animation", "Rotation"},
	},
	{
		name = "Scale",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
		expected = {"Object", "FrameScriptObject", "Animation", "Scale"},
	},
	{
		name = "LineScale",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
		expected = {"Object", "FrameScriptObject", "Animation", "Scale", "LineScale"},
	},
	{
		name = "Translation",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
		expected = {"Object", "FrameScriptObject", "Animation", "Translation"},
	},
	{
		name = "LineTranslation",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
		expected = {"Object", "FrameScriptObject", "Animation", "Translation", "LineTranslation"},
	},
	{
		name = "TextureCoordTranslation",
		actual = KethoFrame.animgroup.texcoordtranslation,
		expected = {"Object", "FrameScriptObject", "Animation", "TextureCoordTranslation"},
	},
	{
		name = "FlipBook",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("FlipBook"),
		expected = {"Object", "FrameScriptObject", "Animation", "FlipBook"},
	},
	{
		name = "Path",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
		expected = {"Object", "FrameScriptObject", "Animation", "Path"},
	},
	{
		name = "ControlPoint",
		actual = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
		expected = {"Object", "FrameScriptObject", "ControlPoint"},
	},
	{
		name = "Frame",
		actual = CreateFrame("Frame"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame"},
	},
	{
		name = "Button",
		actual = CreateFrame("Button"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Button"},
	},
	{
		name = "CheckButton",
		actual = CreateFrame("CheckButton"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Button", "CheckButton"},
	},
	{
		name = "Model",
		actual = CreateFrame("Model"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Model"},
	},
	{
		name = "PlayerModel",
		actual = CreateFrame("PlayerModel"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Model", "PlayerModel"},
	},
	{
		name = "CinematicModel",
		actual = CreateFrame("CinematicModel"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Model", "PlayerModel", "CinematicModel"},
	},
	{
		name = "DressUpModel",
		actual = CreateFrame("DressUpModel"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Model", "PlayerModel", "DressUpModel"},
	},
	{
		name = "TabardModel",
		actual = CreateFrame("TabardModel"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Model", "PlayerModel", "TabardModel"},
	},
	-- ModelScene
	-- ModelSceneActor
	{
		name = "ColorSelect",
		actual = CreateFrame("ColorSelect"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "ColorSelect"},
	},
	{
		name = "Cooldown",
		actual = CreateFrame("Cooldown"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Cooldown"},
	},
	{
		name = "EditBox",
		actual = CreateFrame("EditBox", "KethoDocEditBox"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "EditBox"},
	},
	-- GameTooltip
	{
		name = "MessageFrame",
		actual = CreateFrame("MessageFrame"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "MessageFrame"},
	},
	{
		name = "Minimap",
		actual = Minimap,
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Minimap"},
	},
	{
		name = "MovieFrame",
		actual = CreateFrame("MovieFrame"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "MovieFrame"},
	},
	{
		name = "ScrollFrame",
		actual = CreateFrame("ScrollFrame"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "ScrollFrame"},
	},
	{
		name = "SimpleHTML",
		actual = CreateFrame("SimpleHTML"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "SimpleHTML"},
	},
	{
		name = "Slider",
		actual = CreateFrame("Slider"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Slider"},
	},
	{
		name = "StatusBar",
		actual = CreateFrame("StatusBar"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "StatusBar"},
	},
	-- ArchaeologyDigSiteFrame
	-- QuestPOIFrame
	-- ScenarioPOIFrame
	-- FogOfWarFrame
	-- UnitPositionFrame
	{
		name = "Browser",
		actual = CreateFrame("Browser"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "Browser"},
	},
	-- Checkout
	{
		name = "OffScreenFrame",
		actual = CreateFrame("OffScreenFrame"),
		expected = {"Object", "FrameScriptObject", "ScriptRegion", "ScriptRegionResizing", "AnimatableObject", "Frame", "OffScreenFrame"},
	},
	-- WorldFrame
}
KethoDocEditBox:SetAutoFocus(false)

local undocumented_widgets = {
	PlayerModel = {
		"ApplySpellVisualKit",
		"CanSetUnit",
		"FreezeAnimation",
		"GetDisplayInfo",
		"GetDoBlend",
		"GetKeepModelOnHide",
		"HasAnimation",
		"PlayAnimKit",
		"RefreshCamera",
		"RefreshUnit",
		"SetAnimation",
		"SetBarberShopAlternateForm",
		"SetCamDistanceScale",
		"SetCreature",
		"SetCustomRace",
		"SetDisplayInfo",
		"SetDoBlend",
		"SetItem",
		"SetItemAppearance",
		"SetKeepModelOnHide",
		"SetPortraitZoom",
		"SetRotation",
		"SetUnit",
		"StopAnimKit",
		"ZeroCachedCenterXY",
	},
	CinematicModel = {
		"EquipItem",
		"InitializeCamera",
		"InitializePanCamera",
		"SetAnimOffset",
		"SetCreatureData",
		"SetFacingLeft",
		"SetFadeTimes",
		"SetHeightFactor",
		"SetJumpInfo",
		"SetPanDistance",
		"SetSpellVisualKit",
		"SetTargetDistance",
		"StartPan",
		"StopPan",
		"UnequipItems",
	},
	DressUpModel = {
		"Dress",
		"GetAutoDress",
		"GetItemTransmogInfo",
		"GetItemTransmogInfoList",
		"GetObeyHideInTransmogFlag",
		"GetSheathed",
		"GetUseTransmogChoices",
		"GetUseTransmogSkin",
		"SetAutoDress",
		"SetItemTransmogInfo",
		"SetObeyHideInTransmogFlag",
		"SetSheathed",
		"SetUseTransmogChoices",
		"SetUseTransmogSkin",
		"TryOn",
		"Undress",
		"UndressSlot",
	},
	TabardModel = {
		"CanSaveTabardNow",
		"CycleVariation",
		"GetLowerBackgroundFileName",
		"GetLowerEmblemFile",
		"GetLowerEmblemTexture",
		"GetUpperBackgroundFileName",
		"GetUpperEmblemFile",
		"GetUpperEmblemTexture",
		"InitializeTabardColors",
		"Save",
	},
}

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
		if WidgetDocumentation[system] then
			for method in pairs(WidgetDocumentation[system]) do
				t[method] = true
			end
		else
			for _, method in pairs(undocumented_widgets[system]) do
				t[method] = true
			end
		end
	end
	return t
end

local function TestWidget(test)
	local actual = getmetatable(test.actual).__index
	local expected = GetExpectedWidget(test.expected)
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
	local resultText = equals and "|cff00ff00pass|r:" or "|cffff0000fail|r:"
	print(resultText, test.name, sizeText)
	return equals
end

function KethoDoc:WidgetDocTest()
	self:FixDocumentation()
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
	local num_passed = 0
	for _, unit_test in pairs(widget_tests) do
		local res = TestWidget(unit_test)
		if res then
			num_passed = num_passed + 1
		end
	end
	print(format("%d of %d tests passed.", num_passed, #widget_tests))
end
