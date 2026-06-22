KethoDoc.WidgetOrder = {
	-- abstract classes
	"FrameScriptObject",
	"Object",
	"ScriptObject",
	"ScriptRegion",
	"AnimatableObject",
	"Region",
	"FontInstance",
	"Blob",

	-- fontinstance
	"Font",
	"FontString",

	"VectorGraphics",

	-- texture
	"TextureBase",
	"Texture",
	"MaskTexture",
	"Line",

	-- animation
	"AnimationGroup",
	"Animation",
	"Alpha",
	"Scale",
	"LineScale",
	"Translation",
	"LineTranslation",
	"Path", "ControlPoint",
	"Rotation",
	"TextureCoordTranslation",
	"FlipBook",
	"VertexColor",

	-- frame
	"Frame",
	"Button", "CheckButton",
	"Model",
	"PlayerModel",
	"CinematicModel", "DressUpModel", "TabardModel",
	"ModelScene", "ModelSceneActor",
	"EditBox",
	"MessageFrame",
	"SimpleHTML",
	"ColorSelect",
	"GameTooltip",
	"Cooldown",
	"MovieFrame",
	"ScrollFrame",
	"Slider",
	"StatusBar",
	"Minimap", -- unique
	"FogOfWarFrame",
	"UnitPositionFrame",
	"ArchaeologyDigSiteFrame", "QuestPOIFrame", "ScenarioPOIFrame",
	"Browser",
	"Checkout",
	"OffScreenFrame",
}

-- https://www.townlong-yak.com/framexml/9.0.1/UI.xsd#286
KethoDoc.WidgetHandlers = {
	"OnAnimFinished",
	"OnAnimStarted",
	"OnArrowPressed",
	"OnAttributeChanged",
	"OnButtonUpdate",
	"OnChar",
	"OnCharComposition",
	"OnClick",
	"OnColorSelect",
	"OnCooldownDone",
	"OnCursorChanged",
	"OnDisable",
	"OnDoubleClick",
	"OnDragStart",
	"OnDragStop",
	"OnDressModel",
	"OnEditFocusGained",
	"OnEditFocusLost",
	"OnEnable",
	"OnEnter",
	"OnEnterPressed",
	"OnError",
	"OnEscapePressed",
	"OnEvent",
	"OnExternalLink",
	"OnFinished",
	"OnGamePadButtonDown",
	"OnGamePadButtonUp",
	"OnGamePadStick",
	"OnHide",
	"OnHorizontalScroll",
	"OnHyperlinkClick",
	"OnHyperlinkEnter",
	"OnHyperlinkLeave",
	"OnInputLanguageChanged",
	"OnKeyDown",
	"OnKeyUp",
	"OnLeave",
	"OnLoad",
	"OnLoop",
	"OnMessageScrollChanged",
	"OnMinMaxChanged",
	"OnModelCleared", -- added in 10.0.0
	"OnModelLoaded",
	"OnModelLoading",
	"OnMouseDown",
	"OnMouseUp",
	"OnMouseWheel",
	"OnMovieFinished",
	"OnMovieHideSubtitle",
	"OnMovieShowSubtitle",
	"OnPanFinished",
	"OnPause",
	"OnPlay",
	"OnReceiveDrag",
	"OnRequestNewSize",
	"OnScrollRangeChanged",
	"OnShow",
	"OnSizeChanged",
	"OnSpacePressed",
	"OnStop",
	"OnTabPressed",
	"OnTextChanged",
	"OnTextSet",
	"OnTooltipAddMoney",
	"OnTooltipCleared",
	"OnTooltipSetAchievement",
	"OnTooltipSetDefaultAnchor",
	"OnTooltipSetEquipmentSet",
	"OnTooltipSetFramestack",
	"OnTooltipSetItem",
	"OnTooltipSetQuest",
	"OnTooltipSetSpell",
	"OnTooltipSetUnit",
	"OnUiMapChanged",
	"OnUpdate",
	"OnUpdateModel",
	"OnValueChanged",
	"OnVerticalScroll",
	"PostClick",
	"PreClick",
}

-- A \ B
local function set_difference(a, b)
	local t = {}
	for k in pairs(a) do
		if not b[k] then
			t[k] = true
		end
	end
	return t
end

local function GetObjectMethods(v)
	return getmetatable(v).__index
end

local function GetGameTooltipMethods()
	local gtt = GetObjectMethods(CreateFrame("GameTooltip"))
	local frame = GetObjectMethods(CreateFrame("Frame"))
	return set_difference(gtt, frame)
end

-- fires LUA_WARNING for ArchaeologyDigSiteFrame on classic but wont halt execution
function TryCreateFrame(frameType, ...)
	local ok, frame = pcall(CreateFrame, frameType, ...)
	if ok and frame.GetObjectType then
		return frame
	end
end

function KethoDoc:GetWidgetObjects()
	local t = {
		Alpha                   = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"), {"SimpleAnimAlphaAPI"}},
		Animation               = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(), {"SimpleAnimAPI"}},
		AnimationGroup          = {CreateFrame("Frame"):CreateAnimationGroup(), {"SimpleAnimGroupAPI"}},
		ArchaeologyDigSiteFrame = {TryCreateFrame("ArchaeologyDigSiteFrame"), {"FrameAPIArchaeologyDigSiteFrame"}},
		Browser                 = {CreateFrame("Browser"), {"SimpleBrowserAPI"}},
		Button                  = {CreateFrame("Button"), {"SimpleButtonAPI"}},
		CheckButton             = {CreateFrame("CheckButton"), {"SimpleCheckboxAPI"}},
		Checkout                = {CreateFrame("Checkout"), {"FrameAPISimpleCheckout"}},
		CinematicModel          = {CreateFrame("CinematicModel"), {"FrameAPICinematicModel"}},
		ColorSelect             = {CreateFrame("ColorSelect"), {"SimpleColorSelectAPI"}},
		ControlPoint            = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(), {"SimpleControlPointAPI"}},
		Cooldown                = {CreateFrame("Cooldown"), {"FrameAPICooldown"}},
		DressUpModel            = {CreateFrame("DressUpModel"), {"FrameAPIDressUpModel"}},
		EditBox                 = {CreateFrame("EditBox"), {"SimpleEditBoxAPI"}},
		FlipBook                = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("FlipBook"), {"SimpleAnimFlipBookAPI"}},
		FogOfWarFrame           = {CreateFrame("FogOfWarFrame"), {"FrameAPIFogOfWarFrame"}},
		Font                    = {CreateFont(""), {"SimpleFontAPI"}},
		FontString              = {CreateFrame("Frame"):CreateFontString(), {"SimpleFontStringAPI"}},
		Frame                   = {CreateFrame("Frame"), {"SimpleFrameAPI"}},
		GameTooltip             = {CreateFrame("GameTooltip", {"GameTooltip"})}, -- hack
		Line                    = {CreateFrame("Frame"):CreateLine(), {"SimpleLineAPI"}},
		LineScale               = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"), {"SimpleAnimScaleLineAPI"}},
		LineTranslation         = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"), {"SimpleAnimTranslationLineAPI"}},
		MaskTexture             = {CreateFrame("Frame"):CreateMaskTexture(), {"SimpleMaskTextureAPI"}},
		MessageFrame            = {CreateFrame("MessageFrame"), {"SimpleMessageFrameAPI"}},
		Minimap                 = {Minimap, {"MinimapFrameAPI"}}, -- unique
		Model                   = {CreateFrame("Model"), {"SimpleModelAPI"}},
		ModelScene              = {CreateFrame("ModelScene"), {"FrameAPIModelSceneFrame"}},
		ModelSceneActor         = {CreateFrame("ModelScene"):CreateActor(), {"FrameAPIModelSceneFrameActorBase", "FrameAPIModelSceneFrameActor"}},
		MovieFrame              = {CreateFrame("MovieFrame"), {"SimpleMovieAPI"}},
		OffScreenFrame          = {CreateFrame("OffScreenFrame"), {"SimpleOffScreenFrameAPI"}},
		Path                    = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"), {"SimpleAnimPathAPI"}},
		PlayerModel             = {CreateFrame("PlayerModel"), {"FrameAPICharacterModelBase"}},
		QuestPOIFrame           = {TryCreateFrame("QuestPOIFrame"), {"FrameAPIQuestPOI"}},
		Rotation                = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"), {"SimpleAnimRotationAPI"}},
		Scale                   = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"), {"SimpleAnimScaleAPI"}},
		ScenarioPOIFrame        = {TryCreateFrame("ScenarioPOIFrame"), {"FrameAPIScenarioPOI"}},
		ScrollFrame             = {CreateFrame("ScrollFrame"), {"SimpleScrollFrameAPI"}},
		SimpleHTML              = {CreateFrame("SimpleHTML"), {"SimpleMessageFrameAPI"}},
		Slider                  = {CreateFrame("Slider"), {"SimpleSliderAPI"}},
		StatusBar               = {CreateFrame("StatusBar"), {"SimpleStatusBarAPI"}},
		TabardModel             = {CreateFrame("TabardModel"), {"FrameAPITabardModelBase", "FrameAPITabardModel"}}, 
		Texture                 = {CreateFrame("Frame"):CreateTexture(), {"SimpleTextureAPI"}},
		TextureCoordTranslation = {KethoFrame.animgroup.texcoordtranslation, {"SimpleAnimTextureCoordTranslationAPI"}},
		Translation             = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"), {"SimpleAnimTranslationAPI"}},
		UnitPositionFrame       = {CreateFrame("UnitPositionFrame"), {"FrameAPIUnitPositionFrame"}},
		VertexColor             = {CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("VertexColor"), {"SimpleAnimVertexColorAPI"}},
		-- ModelFFX glues
		-- TaxiRouteFrame unavailable
		-- UICamera unavailable
		-- UnitButton unavailable
		-- WorldFrame = {WorldFrame}, -- unique, no extra methods
	}
	t.EditBox[1]:SetAutoFocus(false) -- steals our focus otherwise
	if APIDocumentation:FindAPIByName("system", "SimpleVectorGraphicsAPI") then
		t.VectorGraphics = {CreateFrame("Frame"):CreateVectorGraphics(), {"SimpleVectorGraphicsAPI"}}
	end
	if NamePlate1 then -- only when a nameplate is visible
		t.NamePlate = {NamePlate1, {"FrameAPINamePlate"}}
	end
	return t
end

function KethoDoc:GetScriptObjectDocs()
	local t = {}
	for _, system in pairs(APIDocumentation.systems) do
		if system.Type == "ScriptObject" then
			t[system.Name] = {}
			for _, func in pairs(system.Functions) do
				t[system.Name][func.Name] = true
			end
		end
	end
	t.GameTooltip = GetGameTooltipMethods()
	return t
end

function KethoDoc:GetWidgetTests()
	local t = {
		Alpha                   = {"SimpleAnimAlphaAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Animation               = {"SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		AnimationGroup          = {"SimpleAnimGroupAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ArchaeologyDigSiteFrame = {"FrameAPIArchaeologyDigSiteFrame", "FrameAPIBlob", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Browser                 = {"SimpleBrowserAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Button                  = {"SimpleButtonAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		CheckButton             = {"SimpleCheckboxAPI", "SimpleButtonAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Checkout                = {"FrameAPISimpleCheckout", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		CinematicModel          = {"FrameAPICinematicModel", "FrameAPICharacterModelBase", "SimpleModelAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ColorSelect             = {"SimpleColorSelectAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ControlPoint            = {"SimpleControlPointAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Cooldown                = {"FrameAPICooldown", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		DressUpModel            = {"FrameAPIDressUpModel", "FrameAPICharacterModelBase", "SimpleModelAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		EditBox                 = {"SimpleEditBoxAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		FlipBook                = {"SimpleAnimFlipBookAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		FogOfWarFrame           = {"FrameAPIFogOfWarFrame", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Font                    = {"SimpleFontAPI", "SimpleFrameScriptObjectAPI"},
		FontString              = {"SimpleFontStringAPI", "SimpleRegionAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Frame                   = {"SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		GameTooltip             = {"GameTooltip", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Line                    = {"SimpleLineAPI", "SimpleTextureBaseAPI", "SimpleRegionAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		LineScale               = {"SimpleAnimScaleLineAPI", "SimpleAnimScaleAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		LineTranslation         = {"SimpleAnimTranslationLineAPI", "SimpleAnimTranslationAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		MaskTexture             = {"SimpleMaskTextureAPI", "SimpleTextureBaseAPI", "SimpleRegionAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		MessageFrame            = {"SimpleMessageFrameAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Minimap                 = {"MinimapFrameAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Model                   = {"SimpleModelAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ModelScene              = {"FrameAPIModelSceneFrame", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ModelSceneActor         = {"FrameAPIModelSceneFrameActorBase", "FrameAPIModelSceneFrameActor", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		MovieFrame              = {"SimpleMovieAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		OffScreenFrame          = {"SimpleOffScreenFrameAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Path                    = {"SimpleAnimPathAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		PlayerModel             = {"FrameAPICharacterModelBase", "SimpleModelAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		QuestPOIFrame           = {"FrameAPIQuestPOI", "FrameAPIBlob", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Rotation                = {"SimpleAnimRotationAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Scale                   = {"SimpleAnimScaleAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ScenarioPOIFrame        = {"FrameAPIScenarioPOI", "FrameAPIBlob", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		ScrollFrame             = {"SimpleScrollFrameAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		SimpleHTML              = {"SimpleHTMLAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Slider                  = {"SimpleSliderAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		StatusBar               = {"SimpleStatusBarAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		TabardModel             = {"FrameAPITabardModelBase", "FrameAPITabardModel", "FrameAPICharacterModelBase", "SimpleModelAPI", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Texture                 = {"SimpleTextureAPI", "SimpleTextureBaseAPI", "SimpleRegionAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		TextureCoordTranslation = {"SimpleAnimTextureCoordTranslationAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		Translation             = {"SimpleAnimTranslationAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		UnitPositionFrame       = {"FrameAPIUnitPositionFrame", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
		VertexColor             = {"SimpleAnimVertexColorAPI", "SimpleAnimAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"},
	}
	if NamePlate1 then
		t.NamePlate = {"FrameAPINamePlate", "SimpleFrameAPI", "SimpleAnimatableObjectAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"}
	end
	if APIDocumentation:FindAPIByName("system", "SimpleVectorGraphicsAPI") then
		t.VectorGraphics = {"SimpleVectorGraphicsAPI", "SimpleRegionAPI", "SimpleScriptRegionResizingAPI", "SimpleScriptRegionAPI", "SimpleObjectAPI", "SimpleFrameScriptObjectAPI"}
	end
	return t
end

function KethoDoc:WidgetTest()
	APIDocumentation_LoadUI()
	local widget_objects = self:GetWidgetObjects()
	local widget_docs = self:GetScriptObjectDocs()
	local widget_tests = self:GetWidgetTests()

	local passed_count = 0
	for name, system_names in pairs(widget_tests) do
		local actual = getmetatable(widget_objects[name][1]).__index
		local expected = {}
		for _, system_name in pairs(system_names) do
			Mixin(expected, widget_docs[system_name])
		end
		local equal, size1, size2 = self:TableEquals(actual, expected, true)
		if equal then
			passed_count = passed_count + 1
		else
			print("Failed:", name, size1, size2)
		end
	end
	print(format("Widgets: Passed %d of %d tests", passed_count, table.count(widget_tests)))
end
