
local W

-- can still fire LUA_WARNING for e.g. ArchaeologyDigSiteFrame on classic but wont halt execution
local function TryCreateFrame(frameType, ...)
	local ok, frame = pcall(CreateFrame, frameType, ...)
	if ok and frame.GetObjectType then
		return frame
	-- else
	-- 	print(ok, frame)
	end
end

-- A ∪ B
local function union(a, b)
	local t = {}
	for k in pairs(a) do
		t[k] = true
	end
	for k in pairs(b) do
		t[k] = true
	end
	return t
end

-- A ∩ B
local function intersect(a, b)
	local t = {}
	for k in pairs(a) do
		if b[k] then
			t[k] = true
		end
	end
	for k in pairs(b) do
		if a[k] then
			t[k] = true
		end
	end
	return t
end

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


local FrameScriptObject = {
	GetName = true,
	GetObjectType = true,
	IsForbidden = true,
	IsObjectType = true,
	SetForbidden = true,
	SetToDefaults = true,
	-- secret values
	HasAnySecretAspect = true,
	HasSecretAspect = true,
	HasSecretValues = true,
	IsPreventingSecretValues = true,
	SetPreventSecretValues = true,
}

local Object = {
	ClearParentKey = true,
	GetDebugName = true,
	GetParent = true,
	IsObjectType = true,
	GetParentKey = true,
	SetParentKey = true,
}

local ScriptObject = {
	GetScript = true,
	HasScript = true,
	HookScript = true,
	SetScript = true,
}

local FontInstance = {
	GetFont = true,
	GetFontObject = true,
	GetIndentedWordWrap = true,
	GetJustifyH = true,
	GetJustifyV = true,
	GetShadowColor = true,
	GetShadowOffset = true,
	GetSpacing = true,
	GetTextColor = true,
	SetFont = true,
	SetFontObject = true,
	SetIndentedWordWrap = true,
	SetJustifyH = true,
	SetJustifyV = true,
	SetShadowColor = true,
	SetShadowOffset = true,
	SetSpacing = true,
	SetTextColor = true,
}

function KethoDoc:SetupWidgets()
	self.WidgetClasses = {
		FrameScriptObject = { -- abstract
			inherits = {},
			meta_object = function() return FrameScriptObject end,
			unique_methods = function() return FrameScriptObject end,
		},
		Object = { -- abstract
			inherits = {"FrameScriptObject"},
			-- FrameScriptObject ∪ Object
			meta_object = function() return union(FrameScriptObject, Object) end,
			unique_methods = function() return Object end,
		},
		ScriptObject = { -- abstract
			inherits = {},
			meta_object = function() return ScriptObject end,
			unique_methods = function() return ScriptObject end,
		},
		ScriptRegion = { -- abstract
			inherits = {"Object", "ScriptObject"},
			-- Frame ∩ Region
			meta_object = function() return intersect(W.Frame.meta_object(), W.Region.meta_object()) end,
			-- ScriptRegion \ (Object ∪ ScriptObject)
			unique_methods = function()
				local u = union(W.Object.meta_object(), W.ScriptObject.meta_object())
				return set_difference(W.ScriptRegion.meta_object(), u)
			end,
			-- Frame ∩ Texture
			unique_handlers = function() return intersect(W.Frame.handlers, W.Texture.handlers) end,
		},
		Region = { -- abstract
			inherits = {"Region"},
			-- Texture ∩ FontString
			meta_object = function() return intersect(W.Texture.meta_object(), W.FontString.meta_object()) end,
			-- Region \ ScriptRegion
			unique_methods = function() return set_difference(W.Region.meta_object(), W.ScriptRegion.meta_object()) end,
		},
		FontInstance = { -- abstract
			inherits = {},
			meta_object = function() return FontInstance end,
			unique_methods = function() return FontInstance end,
		},
		Font = {
			inherits = {"FrameScriptObject", "FontInstance"},
			object = CreateFont(""),
			-- Font \ (FrameScriptObject ∪ FontInstance)
			unique_methods = function()
				local u = union(W.FrameScriptObject.meta_object(), W.FontInstance.meta_object())
				return set_difference(W.Font.meta_object(), u) end,
		},
		FontString = {
			inherits = {"Region", "FontInstance"},
			object = TryCreateFrame("Frame"):CreateFontString(),
			-- FontString \ (Region ∩ FontInstance)
			unique_methods = function()
				local u = union(W.Region.meta_object(), W.FontInstance.meta_object())
				return set_difference(W.FontString.meta_object(), u)
			end,
		},
		TextureBase = { -- abstract
			inherits = {"Region"},
			meta_object = function()
				local o = CopyTable(W.Texture.meta_object())
				o.AddMaskTexture = nil
				o.GetMaskTexture = nil
				o.GetNumMaskTextures = nil
				o.RemoveMaskTexture = nil
				return o
			end,
			-- TextureBase \ Region
			unique_methods = function() return set_difference(W.TextureBase.meta_object(), W.Region.meta_object()) end,
		},
		Texture = {
			inherits = {"TextureBase"},
			object = TryCreateFrame("Frame"):CreateTexture(),
			-- Texture \ TextureBase
			unique_methods = function() return set_difference(W.Texture.meta_object(), W.TextureBase.meta_object()) end,
		},
		MaskTexture = {
			inherits = {"TextureBase"},
			object = TryCreateFrame("Frame"):CreateMaskTexture(), -- equivalent to TextureBase
			unique_methods = function() return set_difference(W.MaskTexture.meta_object(), W.TextureBase.meta_object()) end,
		},
		Line = {
			inherits = {"TextureBase"},
			object = TryCreateFrame("Frame"):CreateLine(),
			-- Texture \ Region
			unique_methods = function() return set_difference(W.Line.meta_object(), W.TextureBase.meta_object()) end,
		},
		AnimationGroup = {
			inherits = {"Object", "ScriptObject"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup(),
			-- AnimationGroup \ (Object ∪ ScriptObject)
			unique_methods = function()
				local u = union(W.Object.meta_object(), W.ScriptObject.meta_object())
				return set_difference(W.AnimationGroup.meta_object(), u)
			end,
			unique_handlers = function() return W.AnimationGroup.handlers end,
		},
		Animation = {
			inherits = {"Object", "ScriptObject"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
			-- Animation \ (Object ∪ ScriptObject)
			unique_methods = function()
				local u = union(W.Object.meta_object(), W.ScriptObject.meta_object())
				return set_difference(W.Animation.meta_object(), u)
			end,
			unique_handlers = function() return W.Animation.handlers end,
		},
		Alpha = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
			-- Alpha \ Animation
			unique_methods = function() return set_difference(W.Alpha.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.Alpha.handlers, W.Animation.handlers) end,
		},
		LineScale = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
			-- LineScale \ Animation
			unique_methods = function() return set_difference(W.LineScale.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.LineScale.handlers, W.Animation.handlers) end,
		},
		LineTranslation = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
			-- LineTranslation \ Animation
			unique_methods = function() return set_difference(W.LineTranslation.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.LineTranslation.handlers, W.Animation.handlers) end,
		},
		Path = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
			-- Path \ Animation
			unique_methods = function() return set_difference(W.Path.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.Path.handlers, W.Animation.handlers) end,
		},
		ControlPoint = {
			inherits = {"Object"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
			-- ControlPoint \ Object
			unique_methods = function() return set_difference(W.ControlPoint.meta_object(), W.Object.meta_object()) end,
		},
		Rotation = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
			-- Rotation \ Animation
			unique_methods = function() return set_difference(W.Rotation.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.Rotation.handlers, W.Animation.handlers) end,
		},
		Scale = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
			-- Scale \ Animation
			unique_methods = function() return set_difference(W.Scale.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.Scale.handlers, W.Animation.handlers) end,
		},
		TextureCoordTranslation = {
			inherits = {"Animation"},
			object = KethoFrame.animgroup.texcoordtranslation, -- can only be created in XML
			-- TextureCoordTranslation \ Animation
			unique_methods = function() return set_difference(W.TextureCoordTranslation.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.TextureCoordTranslation.handlers, W.Animation.handlers) end,
		},
		Translation = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
			-- Translation \ Animation
			unique_methods = function() return set_difference(W.Translation.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.Translation.handlers, W.Animation.handlers) end,
		},
		FlipBook = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("FlipBook"),
			-- FlipBook \ Animation
			unique_methods = function() return set_difference(W.FlipBook.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.FlipBook.handlers, W.Animation.handlers) end,
		},
		VertexColor = {
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("VertexColor"),
			-- VertexColor \ Animation
			unique_methods = function() return set_difference(W.VertexColor.meta_object(), W.Animation.meta_object()) end,
			unique_handlers = function() return set_difference(W.VertexColor.handlers, W.Animation.handlers) end,
		},
		Frame = {
			inherits = {"ScriptRegion"},
			object = TryCreateFrame("Frame"),
			-- Frame \ ScriptRegion
			unique_methods = function() return set_difference(W.Frame.meta_object(), W.ScriptRegion.meta_object()) end,
			unique_handlers = function() return set_difference(W.Frame.handlers, W.ScriptRegion.unique_handlers()) end,
		},
		Browser = {
			inherits = {"Frame"},
			object = TryCreateFrame("Browser"),
			-- Browser \ Frame
			unique_methods = function() return set_difference(W.Browser.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Browser.handlers, W.Frame.handlers) end,
		},
		Button = {
			inherits = {"Frame"},
			object = TryCreateFrame("Button"),
			-- Button \ Frame
			unique_methods = function() return set_difference(W.Button.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Button.handlers, W.Frame.handlers) end,
		},
		CheckButton = {
			inherits = {"Button"},
			object = TryCreateFrame("CheckButton"),
			-- CheckButton \ Button
			unique_methods = function() return set_difference(W.CheckButton.meta_object(), W.Button.meta_object()) end,
			unique_handlers = function() return set_difference(W.CheckButton.handlers, W.Button.handlers) end,
		},
		-- UnitButton unavailable
		Checkout = {
			inherits = {"Frame"},
			object = TryCreateFrame("Checkout"),
			-- Checkout \ Frame
			unique_methods = function() return set_difference(W.Checkout.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Checkout.handlers, W.Frame.handlers) end,
		},
		ColorSelect = {
			inherits = {"Frame"},
			object = TryCreateFrame("ColorSelect"),
			-- ColorSelect \ Frame
			unique_methods = function() return set_difference(W.ColorSelect.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.ColorSelect.handlers, W.Frame.handlers) end,
		},
		Cooldown = {
			inherits = {"Frame"},
			object = TryCreateFrame("Cooldown"),
			-- Cooldown \ Frame
			unique_methods = function() return set_difference(W.Cooldown.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Cooldown.handlers, W.Frame.handlers) end,
		},
		EditBox = {
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("EditBox"),
			-- EditBox \ (Frame ∩ FontInstance)
			unique_methods = function()
				local u = union(W.Frame.meta_object(), W.FontInstance.meta_object())
				return set_difference(W.EditBox.meta_object(), u)
			end,
			unique_handlers = function() return set_difference(W.EditBox.handlers, W.Frame.handlers) end,
		},
		MessageFrame = {
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("MessageFrame"),
			-- MessageFrame \ (Frame ∩ FontInstance)
			unique_methods = function()
				local u = union(W.Frame.meta_object(), W.FontInstance.meta_object())
				return set_difference(W.MessageFrame.meta_object(), u)
			end,
			unique_handlers = function() return set_difference(W.MessageFrame.handlers, W.Frame.handlers) end,
		},
		SimpleHTML = {
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("SimpleHTML"),
			-- SimpleHTML \ (Frame ∩ FontInstance)
			unique_methods = function()
				local u = union(W.Frame.meta_object(), W.FontInstance.meta_object())
				return set_difference(W.SimpleHTML.meta_object(), u)
			end,
			unique_handlers = function() return set_difference(W.SimpleHTML.handlers, W.Frame.handlers) end,
		},
		FogOfWarFrame = {
			inherits = {"Frame"},
			object = TryCreateFrame("FogOfWarFrame"), -- does not error and returns an empty frame in classic
			-- FogOfWarFrame \ Frame
			unique_methods = function() return set_difference(W.FogOfWarFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.FogOfWarFrame.handlers, W.Frame.handlers) end,
		},
		GameTooltip = {
			inherits = {"Frame"},
			object = TryCreateFrame("GameTooltip"),
			-- GameTooltip \ Frame
			unique_methods = function() return set_difference(W.GameTooltip.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.GameTooltip.handlers, W.Frame.handlers) end,
		},
		Minimap = {
			inherits = {"Frame"},
			object = Minimap, -- unique
			-- Minimap \ Frame
			unique_methods = function() return set_difference(W.Minimap.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Minimap.handlers, W.Frame.handlers) end,
		},
		Model = {
			inherits = {"Frame"},
			object = TryCreateFrame("Model"),
			-- Model \ Frame
			unique_methods = function() return set_difference(W.Model.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Model.handlers, W.Frame.handlers) end,
		},
		PlayerModel = {
			inherits = {"Model"},
			object = TryCreateFrame("PlayerModel"),
			-- PlayerModel \ Model
			unique_methods = function() return set_difference(W.PlayerModel.meta_object(), W.Model.meta_object()) end,
			unique_handlers = function() return set_difference(W.PlayerModel.handlers, W.Model.handlers) end,
		},
		CinematicModel = {
			inherits = {"PlayerModel"},
			object = TryCreateFrame("CinematicModel"),
			-- CinematicModel \ Model
			unique_methods = function() return set_difference(W.CinematicModel.meta_object(), W.PlayerModel.meta_object()) end,
			unique_handlers = function() return set_difference(W.CinematicModel.handlers, W.PlayerModel.handlers) end,
		},
		DressUpModel = {
			inherits = {"PlayerModel"},
			object = TryCreateFrame("DressUpModel"),
			-- DressUpModel \ Model
			unique_methods = function() return set_difference(W.DressUpModel.meta_object(), W.PlayerModel.meta_object()) end,
			unique_handlers = function() return set_difference(W.DressUpModel.handlers, W.PlayerModel.handlers) end,
		},
		-- ModelFFX unavailable
		TabardModel = {
			inherits = {"PlayerModel"},
			object = TryCreateFrame("TabardModel"),
			-- TabardModel \ Model
			unique_methods = function() return set_difference(W.TabardModel.meta_object(), W.PlayerModel.meta_object()) end,
			unique_handlers = function() return set_difference(W.TabardModel.handlers, W.PlayerModel.handlers) end,
		},
		-- UICamera unavailable
		ModelScene = {
			inherits = {"Frame"},
			object = TryCreateFrame("ModelScene"),
			-- ModelScene \ Frame
			unique_methods = function() return set_difference(W.ModelScene.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.ModelScene.handlers, W.Frame.handlers) end,
		},
		ModelSceneActor = {
			inherits = {"Object"},
			object = TryCreateFrame("ModelScene"):CreateActor(),
			-- ModelSceneActor \ Object
			unique_methods = function() return set_difference(W.ModelSceneActor.meta_object(), W.Object.meta_object()) end,
			unique_handlers = function()
				return { -- can only be set from XML
					OnModelCleared = true,
					OnModelLoading = true,
					OnModelLoaded = true,
					OnAnimFinished = true,
				}
			end,
		},
		MovieFrame = {
			inherits = {"Frame"},
			object = TryCreateFrame("MovieFrame"),
			-- MovieFrame \ Frame
			unique_methods = function() return set_difference(W.MovieFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.MovieFrame.handlers, W.Frame.handlers) end,
		},
		OffScreenFrame = {
			inherits = {"Frame"},
			object = TryCreateFrame("OffScreenFrame"),
			-- OffScreenFrame \ Frame
			unique_methods = function() return set_difference(W.OffScreenFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.OffScreenFrame.handlers, W.Frame.handlers) end,
		},
		Blob = { -- abstract
			inherits = {"Frame"},
			meta_object = function() return W.ArchaeologyDigSiteFrame.meta_object() end, -- equivalent to Blob
			-- ArchaeologyDigSiteFrame \ Frame
			unique_methods = function() return set_difference(W.ArchaeologyDigSiteFrame.meta_object(), W.Frame.meta_object()) end,
		},
		ArchaeologyDigSiteFrame = {
			inherits = {"Blob"},
			object = TryCreateFrame("ArchaeologyDigSiteFrame"),
			-- ArchaeologyDigSiteFrame \ Blob
			unique_methods = function() return set_difference(W.ArchaeologyDigSiteFrame.meta_object(), W.Blob.meta_object()) end,
			unique_handlers = function() return set_difference(W.ArchaeologyDigSiteFrame.handlers, W.Frame.handlers) end,
		},
		QuestPOIFrame = {
			inherits = {"Blob"},
			object = TryCreateFrame("QuestPOIFrame"),
			-- QuestPOIFrame \ Blob
			unique_methods = function() return set_difference(W.QuestPOIFrame.meta_object(), W.Blob.meta_object()) end,
			unique_handlers = function() return set_difference(W.QuestPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScenarioPOIFrame = {
			inherits = {"Blob"},
			object = TryCreateFrame("ScenarioPOIFrame"),
			-- ScenarioPOIFrame \ Blob
			unique_methods = function() return set_difference(W.ScenarioPOIFrame.meta_object(), W.Blob.meta_object()) end,
			unique_handlers = function() return set_difference(W.ScenarioPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScrollFrame = {
			inherits = {"Frame"},
			object = TryCreateFrame("ScrollFrame"),
			-- ScrollFrame \ Frame
			unique_methods = function() return set_difference(W.ScrollFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.ScrollFrame.handlers, W.Frame.handlers) end,
		},
		Slider = {
			inherits = {"Frame"},
			object = TryCreateFrame("Slider"),
			-- Slider \ Frame
			unique_methods = function() return set_difference(W.Slider.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.Slider.handlers, W.Frame.handlers) end,
		},
		StatusBar = {
			inherits = {"Frame"},
			object = TryCreateFrame("StatusBar"),
			-- StatusBar \ Frame
			unique_methods = function() return set_difference(W.StatusBar.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.StatusBar.handlers, W.Frame.handlers) end,
		},
		-- TaxiRouteFrame unavailable
		UnitPositionFrame = {
			inherits = {"Frame"},
			object = TryCreateFrame("UnitPositionFrame"),
			-- UnitPositionFrame \ Frame
			unique_methods = function() return set_difference(W.UnitPositionFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.UnitPositionFrame.handlers, W.Frame.handlers) end,
		},
		WorldFrame = {
			inherits = {"Frame"},
			object = WorldFrame, -- unique, no extra methods
			-- WorldFrame \ Frame
			unique_methods = function() return set_difference(W.WorldFrame.meta_object(), W.Frame.meta_object()) end,
			unique_handlers = function() return set_difference(W.WorldFrame.handlers, W.Frame.handlers) end,
		},
	}

	-- set meta objects
	for _, widget in pairs(self.WidgetClasses) do
		if widget.object then
			widget.meta_object = function()
				return getmetatable(widget.object).__index
			end
		end
	end

	-- fill handlers
	for _, widget in pairs(self.WidgetClasses) do
		if widget.object and widget.object.HasScript then
			widget.handlers = {}
			for _, handler in pairs(self.WidgetHandlers) do
				if widget.object:HasScript(handler) then
					widget.handlers[handler] = true
				end
			end
		end
	end

	W = self.WidgetClasses
	W.EditBox.object:SetAutoFocus(false) -- steals our focus otherwise
end

KethoDoc.WidgetOrder = {
	-- abstract classes
	"FrameScriptObject",
	"Object",
	"ScriptObject",
	"ScriptRegion",
	"Region",
	"FontInstance",

	-- fontinstance
	"Font",
	"FontString",

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
	"Minimap", -- unique
	"MovieFrame",
	"ScrollFrame",
	"Slider",
	"StatusBar",
	"FogOfWarFrame",
	"UnitPositionFrame",
	KethoDoc.isMainline and "Blob" or nil, -- abstract
	"ArchaeologyDigSiteFrame", "QuestPOIFrame", "ScenarioPOIFrame",
	"Browser",
	"Checkout",
	"OffScreenFrame",
	"WorldFrame", -- unique
	--"ModelFFX",
	--"UICamera",
	--"TaxiRouteFrame",
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

-- not really a proper and structured unit test
function KethoDoc:WidgetTest()
	if not self.WidgetClasses then
		self:SetupWidgets()
	end
	-- combine unique methods plus inherited methods
	-- widget scripts are not really being tested
	local widgets = {
		{"FrameScriptObject",       {}},
		{"Object",                  {W.FrameScriptObject}},
		{"ScriptObject",            {}},
		{"ScriptRegion",            {                W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Region",                  {W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},

		{"FontInstance",            {}},
		{"Font",                    {W.FontInstance, W.FrameScriptObject}},
		{"FontString",              {W.FontInstance, W.Region, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},

		{"TextureBase",             {               W.Region, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Texture",                 {W.TextureBase, W.Region, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"MaskTexture",             {W.TextureBase, W.Region, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Line",                    {W.TextureBase, W.Region, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},

		{"AnimationGroup",          {             W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Animation",               {             W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Alpha",                   {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"LineScale",               {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Translation",             {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"LineTranslation",         {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Path",                    {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ControlPoint",            {                             W.Object, W.FrameScriptObject}},
		{"Rotation",                {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"TextureCoordTranslation", {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"FlipBook",                {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"VertexColor",             {W.Animation, W.ScriptObject, W.Object, W.FrameScriptObject}},

		{"Frame",                   {                                 W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Button",                  {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"CheckButton",             {W.Button,               W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Model",                   {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"PlayerModel",             {               W.Model, W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"CinematicModel",          {W.PlayerModel, W.Model, W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"DressUpModel",            {W.PlayerModel, W.Model, W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"TabardModel",             {W.PlayerModel, W.Model, W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ModelScene",              {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ModelSceneActor",         {                                                                 W.Object, W.FrameScriptObject}},
		{"EditBox",                 {W.FontInstance,         W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"MessageFrame",            {W.FontInstance,         W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"SimpleHTML",              {W.FontInstance,         W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ColorSelect",             {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"GameTooltip",             {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Cooldown",                {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Minimap",                 {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"MovieFrame",              {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ScrollFrame",             {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Slider",                  {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"StatusBar",               {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"FogOfWarFrame",           {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"UnitPositionFrame",       {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Blob",                    {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ArchaeologyDigSiteFrame", {W.Blob,                 W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"QuestPOIFrame",           {W.Blob,                 W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"ScenarioPOIFrame",        {W.Blob,                 W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Browser",                 {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"Checkout",                {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"OffScreenFrame",          {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
		{"WorldFrame",              {                        W.Frame, W.ScriptRegion, W.ScriptObject, W.Object, W.FrameScriptObject}},
	}

	-- skip certain unit tests for classic, bit ugly
	if not self.isMainline then
		local onlyMainline = {
			Blob = true,
			ArchaeologyDigSiteFrame = true,
			QuestPOIFrame = true,
			ScenarioPOIFrame = true,
		}
		for i = #widgets, 1, -1 do
			if onlyMainline[widgets[i][1]] then
				table.remove(widgets, i)
			end
		end
	end

	local passed_count = 0
	for _, v in pairs(widgets) do
		local widget_class = W[v[1]]
		local meta_source = widget_class.meta_object
		local meta_object = type(meta_source) == "function" and meta_source() or meta_source
		local expected = self:MixinTable(widget_class, unpack(v[2]))
		local equal, size1, size2 = self:TableEquals(meta_object, expected)
		if equal then
			passed_count = passed_count + 1
		else
			print("Failed:", v[1], size1, size2)
		end
	end
	print(format("Widgets: Passed %d of %d tests", passed_count, #widgets))
	-- [Mainline] Widgets: Passed 55 of 55 tests in 10.2.5 (53441)
	-- [Classic] Widgets: Passed 51 of 51 tests in 1.15.1 (53495)
end