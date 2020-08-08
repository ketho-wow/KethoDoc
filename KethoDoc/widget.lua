
local W
local IsClassic = (KethoDoc.branch == "classic")

-- (AnimationGroup ∩ Frame) \ UIObject
function KethoDoc.GetScriptObject()
	local intersect = KethoDoc:CompareTable(W.AnimationGroup.meta_object, W.Frame.meta_object)
	return KethoDoc:RemoveTable(intersect, W.UIObject.meta_object())
end

-- UIObject ∩ FontInstance
function KethoDoc.GetObject()
	return (KethoDoc:CompareTable(W.UIObject.meta_object(), W.FontInstance.meta_object()))
end

local function GetMixinFrame(name)
	local t = {}
	local frame = CreateFrame(name)
	for k, v in pairs(frame) do
		if type(v) == "function" then
			t[k] = true
		end
	end
	for k in pairs(getmetatable(frame).__index) do
		t[k] = true
	end
	return t
end

function KethoDoc:SetupWidgets()
	self.WidgetClasses = {
		ScriptObject = {
			inherits = {},
			meta_object = self.GetScriptObject,
			unique_methods = self.GetScriptObject,
			unique_handlers = function() return self:CompareTable(W.AnimationGroup.handlers, W.Frame.handlers) end,
		},
		Object = {
			inherits = {},
			meta_object = self.GetObject,
			unique_methods = self.GetObject,
		},
		UIObject = {
			inherits = {"Object"},
			-- AnimationGroup ∩ ControlPoint
			meta_object = function() return (self:CompareTable(W.AnimationGroup.meta_object, W.ControlPoint.meta_object)) end,
			-- UIObject \ Object
			unique_methods = function() return self:RemoveTable(W.UIObject.meta_object(), W.Object.meta_object()) end,
		},
		Region = {
			inherits = {"UIObject"},
			-- Frame ∩ LayeredRegion
			meta_object = function() return (self:CompareTable(W.Frame.meta_object, W.LayeredRegion.meta_object())) end,
			-- Region \ UIObject
			unique_methods = function() return self:RemoveTable(W.Region.meta_object(), W.UIObject.meta_object()) end,
		},
		LayeredRegion = {
			inherits = {"Region"},
			-- Texture ∩ FontString
			meta_object = function() return (self:CompareTable(W.Texture.meta_object, W.FontString.meta_object)) end,
			-- Region \ LayeredRegion
			unique_methods = function() return self:RemoveTable(W.LayeredRegion.meta_object(), W.Region.meta_object()) end,
		},
		FontInstance = {
			inherits = {"Object"},
			meta_object = function() -- Font ∩ FontString
				local FontInstance = self:CompareTable(W.Font.meta_object, W.FontString.meta_object)
				-- Font has its own version and FontString inherits from LayeredRegion
				FontInstance.GetAlpha = nil
				FontInstance.SetAlpha = nil
				return FontInstance
			end, -- FontInstance \ Object
			unique_methods = function() return self:RemoveTable(W.FontInstance.meta_object(), W.Object.meta_object()) end,
		},

		Font = { -- Font \ FontInstance
			inherits = {"FontInstance"},
			object = CreateFont(""),
			unique_methods = function() return self:RemoveTable(W.Font.meta_object, W.FontInstance.meta_object()) end,
		},
		FontString = { -- FontString \ (FontInstance ∧ LayeredRegion)
			inherits = {"LayeredRegion", "FontInstance"},
			object = CreateFrame("Frame"):CreateFontString(),
			unique_methods = function()
				local obj = self:RemoveTable(W.FontString.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.LayeredRegion.meta_object())
			end,
		},

		Texture = { -- Texture \ LayeredRegion
			inherits = {"LayeredRegion"},
			object = CreateFrame("Frame"):CreateTexture(),
			unique_methods = function() return self:RemoveTable(W.Texture.meta_object, W.LayeredRegion.meta_object()) end,
		},
		Line = { -- Texture +6 -12
			inherits = {"Texture"},
			object = CreateFrame("Frame"):CreateLine(),
			unique_methods = function() return self:RemoveTable(W.Line.meta_object, W.Texture.meta_object) end,
		},
		MaskTexture = { -- Texture -4
			inherits = {"Texture"},
			object = CreateFrame("Frame"):CreateMaskTexture(),
			unique_methods = function() return self:RemoveTable(W.MaskTexture.meta_object, W.Texture.meta_object) end,
		},

		AnimationGroup = { -- AnimationGroup \ (UIObject ∧ ScriptObject)
			inherits = {"UIObject", "ScriptObject"},
			object = CreateFrame("Frame"):CreateAnimationGroup(),
			unique_methods = function()
				local obj = self:RemoveTable(W.AnimationGroup.meta_object, W.UIObject.meta_object())
				return self:RemoveTable(obj, W.ScriptObject.meta_object())
			end,
			unique_handlers = function() return self:RemoveTable(W.AnimationGroup.handlers, W.ScriptObject.unique_handlers()) end,
		},
		Animation = { -- Animation \ (UIObject ∧ ScriptObject)
			inherits = {"UIObject", "ScriptObject"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
			unique_methods = function()
				local obj = self:RemoveTable(W.Animation.meta_object, W.UIObject.meta_object())
				return self:RemoveTable(obj, W.ScriptObject.meta_object())
			end,
			unique_handlers = function() return self:RemoveTable(W.Animation.handlers, W.ScriptObject.unique_handlers()) end,
		},
		Alpha = { -- Alpha \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
			unique_methods = function() return self:RemoveTable(W.Alpha.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Alpha.handlers, W.Animation.handlers) end,
		},
		LineScale = { -- LineScale \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
			unique_methods = function() return self:RemoveTable(W.LineScale.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.LineScale.handlers, W.Animation.handlers) end,
		},
		LineTranslation = { -- LineTranslation \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
			unique_methods = function() return self:RemoveTable(W.LineTranslation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.LineTranslation.handlers, W.Animation.handlers) end,
		},
		Path = { -- Path \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
			unique_methods = function() return self:RemoveTable(W.Path.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Path.handlers, W.Animation.handlers) end,
		},
		ControlPoint = { -- ControlPoint \ UIObject
			inherits = {"UIObject"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
			unique_methods = function() return self:RemoveTable(W.ControlPoint.meta_object, W.UIObject.meta_object()) end,
		},
		Rotation = { -- Rotation \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
			unique_methods = function() return self:RemoveTable(W.Rotation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Rotation.handlers, W.Animation.handlers) end,
		},
		Scale = { -- Scale \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
			unique_methods = function() return self:RemoveTable(W.Scale.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Scale.handlers, W.Animation.handlers) end,
		},
		TextureCoordTranslation = { -- TextureCoordTranslation \ Animation
		inherits = {"Animation"},
			-- cant seem to actually create this in Lua
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("TextureCoordTranslation"),
			unique_methods = function() return self:RemoveTable(W.TextureCoordTranslation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.TextureCoordTranslation.handlers, W.Animation.handlers) end,
		},
		Translation = { -- Translation \ Animation
			inherits = {"Animation"},
			object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
			unique_methods = function() return self:RemoveTable(W.Translation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Translation.handlers, W.Animation.handlers) end,
		},

		Frame = { -- Frame \ (Region ∧ ScriptObject)
			inherits = {"Region", "ScriptObject"},
			object = CreateFrame("Frame"),
			unique_methods = function()
				local obj = self:RemoveTable(W.Frame.meta_object, W.Region.meta_object())
				return self:RemoveTable(obj, W.ScriptObject.meta_object())
			end,
			unique_handlers = function() return self:RemoveTable(W.Frame.handlers, W.ScriptObject.unique_handlers()) end,
		},
		Browser = { -- Browser \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Browser"),
			unique_methods = function() return self:RemoveTable(W.Browser.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Browser.handlers, W.Frame.handlers) end,
		},

		Button = { -- Button \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Button"),
			unique_methods = function() return self:RemoveTable(W.Button.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Button.handlers, W.Frame.handlers) end,
		},
		CheckButton = { -- CheckButton \ Button
			inherits = {"Button"},
			object = CreateFrame("CheckButton"),
			unique_methods = function() return self:RemoveTable(W.CheckButton.meta_object, W.Button.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.CheckButton.handlers, W.Button.handlers) end,
		},
		ItemButton = { -- ItemButton \ Button
			inherits = {"Button"},
			meta_object = not IsClassic and GetMixinFrame("ItemButton"),
			mixin = "ItemButtonMixin",
			intrinsic = true,
			unique_methods = function() return ItemButtonMixin end,
		},
		-- UnitButton unavailable

		Checkout = { -- Checkout \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Checkout"),
			unique_methods = function() return self:RemoveTable(W.Checkout.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Checkout.handlers, W.Frame.handlers) end,
		},
		ColorSelect = { -- ColorSelect \ Frame
			inherits = {"Frame"},
			object = CreateFrame("ColorSelect"),
			unique_methods = function() return self:RemoveTable(W.ColorSelect.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ColorSelect.handlers, W.Frame.handlers) end,
		},
		Cooldown = { -- Cooldown \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Cooldown"),
			unique_methods = function() return self:RemoveTable(W.Cooldown.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Cooldown.handlers, W.Frame.handlers) end,
		},
		EditBox = { -- EditBox \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = CreateFrame("EditBox"),
			unique_methods = function()
				local obj = self:RemoveTable(W.EditBox.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.Frame.meta_object)
			end,
			unique_handlers = function() return self:RemoveTable(W.EditBox.handlers, W.Frame.handlers) end,
		},
		FogOfWarFrame = { -- FogOfWarFrame \ Frame
			inherits = {"Frame"},
			object = not IsClassic and CreateFrame("FogOfWarFrame"),
			unique_methods = function() return self:RemoveTable(W.FogOfWarFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.FogOfWarFrame.handlers, W.Frame.handlers) end,
		},
		GameTooltip = { -- GameTooltip \ Frame
			inherits = {"Frame"},
			object = CreateFrame("GameTooltip"),
			unique_methods = function() return self:RemoveTable(W.GameTooltip.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.GameTooltip.handlers, W.Frame.handlers) end,
		},
		MessageFrame = { -- MessageFrame \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = CreateFrame("MessageFrame"),
			unique_methods = function()
				local obj = self:RemoveTable(W.MessageFrame.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.Frame.meta_object)
			end,
			unique_handlers = function() return self:RemoveTable(W.MessageFrame.handlers, W.Frame.handlers) end,
		},
		Minimap = { -- Minimap \ Frame
			inherits = {"Frame"},
			object = Minimap, -- unique
			unique_methods = function() return self:RemoveTable(W.Minimap.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Minimap.handlers, W.Frame.handlers) end,
		},

		Model = { -- Model \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Model"),
			unique_methods = function() return self:RemoveTable(W.Model.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Model.handlers, W.Frame.handlers) end,
		},
		PlayerModel = { -- PlayerModel \ Model
			inherits = {"Model"},
			object = CreateFrame("PlayerModel"),
			unique_methods = function() return self:RemoveTable(W.PlayerModel.meta_object, W.Model.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.PlayerModel.handlers, W.Model.handlers) end,
		},
		CinematicModel = { -- CinematicModel \ Model
			inherits = {"PlayerModel"},
			object = CreateFrame("CinematicModel"),
			unique_methods = function() return self:RemoveTable(W.CinematicModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.CinematicModel.handlers, W.PlayerModel.handlers) end,
		},
		DressUpModel = { -- DressUpModel \ Model
			inherits = {"PlayerModel"},
			object = CreateFrame("DressUpModel"),
			unique_methods = function() return self:RemoveTable(W.DressUpModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.DressUpModel.handlers, W.PlayerModel.handlers) end,
		},
		-- ModelFFX unavailable
		TabardModel = { -- TabardModel \ Model
			inherits = {"PlayerModel"},
			object = CreateFrame("TabardModel"),
			unique_methods = function() return self:RemoveTable(W.TabardModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.TabardModel.handlers, W.PlayerModel.handlers) end,
		},
		-- UICamera unavailable

		ModelScene = { -- ModelScene \ Frame
			inherits = {"Frame"},
			object = CreateFrame("ModelScene"),
			unique_methods = function() return self:RemoveTable(W.ModelScene.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ModelScene.handlers, W.Frame.handlers) end,
		},
		MovieFrame = { -- MovieFrame \ Frame
			inherits = {"Frame"},
			object = not IsClassic and CreateFrame("MovieFrame"),
			unique_methods = function() return self:RemoveTable(W.MovieFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.MovieFrame.handlers, W.Frame.handlers) end,
		},
		OffScreenFrame = { -- OffScreenFrame \ Frame
			inherits = {"Frame"},
			object = CreateFrame("OffScreenFrame"),
			unique_methods = function() return self:RemoveTable(W.OffScreenFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.OffScreenFrame.handlers, W.Frame.handlers) end,
		},
		POIFrame = {
			inherits = {"Frame"}, -- ArchaeologyDigSiteFrame ∩ QuestPOIFrame
			meta_object = not IsClassic and function() return self:CompareTable(W.ArchaeologyDigSiteFrame.meta_object, W.QuestPOIFrame.meta_object) end,
			-- (ArchaeologyDigSiteFrame ∩ QuestPOIFrame) \ Frame
			unique_methods = function() return self:RemoveTable(W.POIFrame.meta_object(), W.Frame.meta_object) end,
		},
		ArchaeologyDigSiteFrame = { -- ArchaeologyDigSiteFrame \ POIFrame
			inherits = {"POIFrame"},
			object = not IsClassic and CreateFrame("ArchaeologyDigSiteFrame"),
			unique_methods = function() return self:RemoveTable(W.ArchaeologyDigSiteFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.ArchaeologyDigSiteFrame.handlers, W.Frame.handlers) end,
		},
		QuestPOIFrame = { -- QuestPOIFrame \ POIFrame
			inherits = {"POIFrame"},
			object = not IsClassic and CreateFrame("QuestPOIFrame"),
			unique_methods = function() return self:RemoveTable(W.QuestPOIFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.QuestPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScenarioPOIFrame = { -- ScenarioPOIFrame \ POIFrame
			inherits = {"POIFrame"},
			object = not IsClassic and CreateFrame("ScenarioPOIFrame"),
			unique_methods = function() return self:RemoveTable(W.ScenarioPOIFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.ScenarioPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScrollFrame = { -- ScrollFrame \ Frame
			inherits = {"Frame"},
			object = CreateFrame("ScrollFrame"),
			unique_methods = function() return self:RemoveTable(W.ScrollFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ScrollFrame.handlers, W.Frame.handlers) end,
		},
		ScrollingMessageFrame = {
			inherits = {"Frame", "FontInstance"},
			meta_object = GetMixinFrame("ScrollingMessageFrame"),
			mixin = "ScrollingMessageFrameMixin",
			intrinsic = true,
			unique_methods = function() return ScrollingMessageFrameMixin end,
		},
		SimpleHTML = { -- SimpleHTML \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = CreateFrame("SimpleHTML"),
			unique_methods = function()
				local obj = self:RemoveTable(W.SimpleHTML.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.Frame.meta_object)
			end,
			unique_handlers = function() return self:RemoveTable(W.SimpleHTML.handlers, W.Frame.handlers) end,
		},
		Slider = { -- Slider \ Frame
			inherits = {"Frame"},
			object = CreateFrame("Slider"),
			unique_methods = function() return self:RemoveTable(W.Slider.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Slider.handlers, W.Frame.handlers) end,
		},
		StatusBar = { -- StatusBar \ Frame
			inherits = {"Frame"},
			object = CreateFrame("StatusBar"),
			unique_methods = function() return self:RemoveTable(W.StatusBar.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.StatusBar.handlers, W.Frame.handlers) end,
		},
		-- TaxiRouteFrame unavailable
		UnitPositionFrame = { -- UnitPositionFrame \ Frame
			inherits = {"Frame"},
			object = CreateFrame("UnitPositionFrame"),
			unique_methods = function() return self:RemoveTable(W.UnitPositionFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.UnitPositionFrame.handlers, W.Frame.handlers) end,
		},
		WorldFrame = { -- WorldFrame \ Frame
			inherits = {"Frame"},
			object = WorldFrame, -- unique, no extra methods
			unique_methods = function() return self:RemoveTable(W.WorldFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.WorldFrame.handlers, W.Frame.handlers) end,
		},
		ModelSceneActor = {
			inherits = {"UIObject"},
			object = CreateFrame("ModelScene"):CreateActor(),
			unique_methods = function() return self:RemoveTable(W.ModelSceneActor.meta_object, W.UIObject.meta_object()) end,
			unique_handlers = function()
				return { -- can only set these from XML
					OnModelLoading = true,
					OnModelLoaded = true,
					OnAnimFinished = true,
				}
			end,
		},
	}

	-- set meta objects
	for _, widget in pairs(self.WidgetClasses) do
		if widget.object then
			widget.meta_object = getmetatable(widget.object).__index
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
	"ScriptObject",
	"Object",
	"UIObject",
	"Region", -- (LayoutFrame)
	"LayeredRegion",
	"FontInstance",

	-- fontinstance
	"Font",
	"FontString",

	-- texture
	"Texture", "Line", "MaskTexture",

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

	-- frame
	"Frame",
	"Browser",
	"Button", "CheckButton", "ItemButton", --"UnitButton",
	"Checkout",
	"ColorSelect",
	"Cooldown",
	"EditBox",
	"FogOfWarFrame",
	"GameTooltip",
	"MessageFrame",
	"Minimap", -- unique
	"Model", "PlayerModel",
		"CinematicModel", "DressUpModel", "TabardModel", --"ModelFFX", "UICamera",
	"ModelScene",
	"MovieFrame",
	"OffScreenFrame",
	"POIFrame", "ArchaeologyDigSiteFrame", "QuestPOIFrame", "ScenarioPOIFrame",
	"ScrollFrame",
	"ScrollingMessageFrame",
	"SimpleHTML",
	"Slider",
	"StatusBar",
	--"TaxiRouteFrame",
	"UnitPositionFrame",
	"WorldFrame", -- unique
	"ModelSceneActor",
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
	local widgets = {
		{"ScriptObject",			{}},
		{"Object",					{}},
		{"UIObject",				{W.Object}},
		{"Region",					{W.UIObject, W.Object}},
		{"LayeredRegion",			{W.Region, W.UIObject, W.Object}},

		{"FontInstance",			{W.Object}},
		{"Font",					{W.FontInstance, W.Object}},
		{"FontString",				{W.LayeredRegion, W.Region, W.UIObject, W.Object, W.FontInstance}},
		{"Texture",					{W.LayeredRegion, W.Region, W.UIObject, W.Object}},
		{"Line",					{W.Texture, W.LayeredRegion, W.Region, W.UIObject, W.Object}},
		{"MaskTexture",				{W.Texture, W.LayeredRegion, W.Region, W.UIObject, W.Object}},

		{"AnimationGroup",			{W.UIObject, W.Object, W.ScriptObject}},
		{"Animation",				{W.UIObject, W.Object, W.ScriptObject}},
		{"Alpha",					{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"LineScale",				{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"Translation",				{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"LineTranslation",			{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"Path",					{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"ControlPoint",			{W.UIObject, W.Object}},
		{"Rotation",				{W.Animation, W.UIObject, W.Object, W.ScriptObject}},
		{"TextureCoordTranslation",	{W.Animation, W.UIObject, W.Object, W.ScriptObject}},

		{"Frame",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Browser",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Button",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"CheckButton",				{W.Button, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		-- .itemContextChangedCallback is set on ItemButtonMixin:PostOnLoad() so the test fails
		{"ItemButton",				{W.Button, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Checkout",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ColorSelect",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Cooldown",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"EditBox",					{W.FontInstance, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"FogOfWarFrame",			{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"GameTooltip",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"MessageFrame",			{W.FontInstance, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Minimap",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Model",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"PlayerModel",				{W.Model, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"CinematicModel",			{W.PlayerModel, W.Model, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"DressUpModel",			{W.PlayerModel, W.Model, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"TabardModel",				{W.PlayerModel, W.Model, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ModelScene",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"MovieFrame",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"OffScreenFrame",			{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"POIFrame",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ArchaeologyDigSiteFrame",	{W.POIFrame, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"QuestPOIFrame",			{W.POIFrame, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ScenarioPOIFrame",		{W.POIFrame, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ScrollFrame",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"ScrollingMessageFrame",	{W.FontInstance, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"SimpleHTML",				{W.FontInstance, W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"Slider",					{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"StatusBar",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"UnitPositionFrame",		{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},
		{"WorldFrame",				{W.Frame, W.Region, W.UIObject, W.Object, W.ScriptObject}},

		{"ModelSceneActor",			{W.UIObject, W.Object}},
	}

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
	print(format("Passed %d of %d tests", passed_count, #widgets))
	-- Failed: Line 84 95
	-- Failed: MaskTexture 85 89
	-- Failed: ItemButton 190 189
	-- Passed 51 of 54 tests
end
