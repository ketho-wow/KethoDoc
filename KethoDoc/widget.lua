
local KD = KethoDoc
local W
local IsClassic = (KD.branch == "classic")

-- (AnimationGroup ∩ Frame) \ UIObject
function KethoDoc.GetScriptObject()
	local intersect = KD:CompareTable(W.AnimationGroup.meta_object, W.Frame.meta_object)
	return KD:RemoveTable(intersect, W.UIObject.meta_object())
end

-- UIObject ∩ FontInstance
function KethoDoc.GetObject()
	return (KD:CompareTable(W.UIObject.meta_object(), W.FontInstance.meta_object()))
end

KethoDoc.WidgetClasses = {
	ScriptObject = {
		inherits = {},
		meta_object = KD.GetScriptObject,
		unique_methods = KD.GetScriptObject,
		unique_handlers = function() return KD:CompareTable(W.AnimationGroup.handlers, W.Frame.handlers) end,
	},
	Object = {
		inherits = {},
		meta_object = KD.GetObject,
		unique_methods = KD.GetObject,
	},
	UIObject = {
		inherits = {"Object"},
		-- AnimationGroup ∩ ControlPoint
		meta_object = function() return (KD:CompareTable(W.AnimationGroup.meta_object, W.ControlPoint.meta_object)) end,
		-- UIObject \ Object
		unique_methods = function() return KD:RemoveTable(W.UIObject.meta_object(), W.Object.meta_object()) end,
	},
	Region = {
		inherits = {"UIObject"},
		-- Frame ∩ LayeredRegion
		meta_object = function() return (KD:CompareTable(W.Frame.meta_object, W.LayeredRegion.meta_object())) end,
		-- Region \ UIObject
		unique_methods = function() return KD:RemoveTable(W.Region.meta_object(), W.UIObject.meta_object()) end,
	},
	LayeredRegion = {
		inherits = {"Region"},
		-- Texture ∩ FontString
		meta_object = function() return (KD:CompareTable(W.Texture.meta_object, W.FontString.meta_object)) end,
		-- Region \ LayeredRegion
		unique_methods = function() return KD:RemoveTable(W.LayeredRegion.meta_object(), W.Region.meta_object()) end,
	},
	FontInstance = {
		inherits = {"Object"},
		meta_object = function() -- Font ∩ FontString
			local FontInstance = KD:CompareTable(W.Font.meta_object, W.FontString.meta_object)
			-- Font has its own version and FontString inherits from LayeredRegion
			FontInstance.GetAlpha = nil
			FontInstance.SetAlpha = nil
			return FontInstance
		end, -- FontInstance \ Object
		unique_methods = function() return KD:RemoveTable(W.FontInstance.meta_object(), W.Object.meta_object()) end,
	},
	
	Font = { -- Font \ FontInstance
		inherits = {"FontInstance"},
		object = CreateFont(""),
		unique_methods = function() return KD:RemoveTable(W.Font.meta_object, W.FontInstance.meta_object()) end,
	},
	FontString = { -- FontString \ (FontInstance ∧ LayeredRegion)
		inherits = {"LayeredRegion", "FontInstance"},
		object = CreateFrame("Frame"):CreateFontString(),
		unique_methods = function()
			local obj = KD:RemoveTable(W.FontString.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.LayeredRegion.meta_object())
		end,
	},
	
	Texture = { -- Texture \ LayeredRegion
		inherits = {"LayeredRegion"},
		object = CreateFrame("Frame"):CreateTexture(),
		unique_methods = function() return KD:RemoveTable(W.Texture.meta_object, W.LayeredRegion.meta_object()) end,
	},
	Line = { -- Texture +6 -12
		inherits = {"Texture"},
		object = CreateFrame("Frame"):CreateLine(),
		unique_methods = function() return KD:RemoveTable(W.Line.meta_object, W.Texture.meta_object) end,
	},
	MaskTexture = { -- Texture -4
		inherits = {"Texture"},
		object = CreateFrame("Frame"):CreateMaskTexture(),
		unique_methods = function() return KD:RemoveTable(W.MaskTexture.meta_object, W.Texture.meta_object) end,
	},
	
	AnimationGroup = { -- AnimationGroup \ (UIObject ∧ ScriptObject)
		inherits = {"UIObject", "ScriptObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup(),
		unique_methods = function()
			local obj = KD:RemoveTable(W.AnimationGroup.meta_object, W.UIObject.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
		unique_handlers = function() return KD:RemoveTable(W.AnimationGroup.handlers, W.ScriptObject.unique_handlers()) end,
	},
	Animation = { -- Animation \ (UIObject ∧ ScriptObject)
		inherits = {"UIObject", "ScriptObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
		unique_methods = function()
			local obj = KD:RemoveTable(W.Animation.meta_object, W.UIObject.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
		unique_handlers = function() return KD:RemoveTable(W.Animation.handlers, W.ScriptObject.unique_handlers()) end,
	},
	Alpha = { -- Alpha \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
		unique_methods = function() return KD:RemoveTable(W.Alpha.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Alpha.handlers, W.Animation.handlers) end,
	},
	LineScale = { -- LineScale \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
		unique_methods = function() return KD:RemoveTable(W.LineScale.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.LineScale.handlers, W.Animation.handlers) end,
	},
	LineTranslation = { -- LineTranslation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
		unique_methods = function() return KD:RemoveTable(W.LineTranslation.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.LineTranslation.handlers, W.Animation.handlers) end,
	},
	Path = { -- Path \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
		unique_methods = function() return KD:RemoveTable(W.Path.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Path.handlers, W.Animation.handlers) end,
	},
	ControlPoint = { -- ControlPoint \ UIObject
		inherits = {"UIObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
		unique_methods = function() return KD:RemoveTable(W.ControlPoint.meta_object, W.UIObject.meta_object()) end,
	},
	Rotation = { -- Rotation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
		unique_methods = function() return KD:RemoveTable(W.Rotation.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Rotation.handlers, W.Animation.handlers) end,
	},
	Scale = { -- Scale \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
		unique_methods = function() return KD:RemoveTable(W.Scale.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Scale.handlers, W.Animation.handlers) end,
	},
	TextureCoordTranslation = { -- TextureCoordTranslation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("TextureCoordTranslation"),
		unique_methods = function() return KD:RemoveTable(W.TextureCoordTranslation.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.TextureCoordTranslation.handlers, W.Animation.handlers) end,
	},
	Translation = { -- Translation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
		unique_methods = function() return KD:RemoveTable(W.Translation.meta_object, W.Animation.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Translation.handlers, W.Animation.handlers) end,
	},
	
	Frame = { -- Frame \ (Region ∧ ScriptObject)
		inherits = {"Region", "ScriptObject"},
		object = CreateFrame("Frame"),
		unique_methods = function()
			local obj = KD:RemoveTable(W.Frame.meta_object, W.Region.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
		unique_handlers = function() return KD:RemoveTable(W.Frame.handlers, W.ScriptObject.unique_handlers()) end,
	},
	Browser = { -- Browser \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Browser"),
		unique_methods = function() return KD:RemoveTable(W.Browser.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Browser.handlers, W.Frame.handlers) end,
	},
	
	Button = { -- Button \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Button"),
		unique_methods = function() return KD:RemoveTable(W.Button.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Button.handlers, W.Frame.handlers) end,
	},
	CheckButton = { -- CheckButton \ Button
		inherits = {"Button"},
		object = CreateFrame("CheckButton"),
		unique_methods = function() return KD:RemoveTable(W.CheckButton.meta_object, W.Button.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.CheckButton.handlers, W.Button.handlers) end,
	},
	ItemButton = { -- ItemButton \ Button
		inherits = {"Button"},
		object = not IsClassic and CreateFrame("ItemButton"), -- no extra methods
		unique_methods = function() return KD:RemoveTable(W.ItemButton.meta_object, W.ItemButton.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.ItemButton.handlers, W.ItemButton.handlers) end,
	},
	-- UnitButton unavailable
	
	Checkout = { -- Checkout \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Checkout"),
		unique_methods = function() return KD:RemoveTable(W.Checkout.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Checkout.handlers, W.Frame.handlers) end,
	},
	ColorSelect = { -- ColorSelect \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ColorSelect"),
		unique_methods = function() return KD:RemoveTable(W.ColorSelect.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.ColorSelect.handlers, W.Frame.handlers) end,
	},
	Cooldown = { -- Cooldown \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Cooldown"),
		unique_methods = function() return KD:RemoveTable(W.Cooldown.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Cooldown.handlers, W.Frame.handlers) end,
	},
	EditBox = { -- EditBox \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("EditBox", "KethoDocumenterEditBox"),
		unique_methods = function()
			local obj = KD:RemoveTable(W.EditBox.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
		unique_handlers = function() return KD:RemoveTable(W.EditBox.handlers, W.Frame.handlers) end,
	},
	FogOfWarFrame = { -- FogOfWarFrame \ Frame
		inherits = {"Frame"},
		object = not IsClassic and CreateFrame("FogOfWarFrame"),
		unique_methods = function() return KD:RemoveTable(W.FogOfWarFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.FogOfWarFrame.handlers, W.Frame.handlers) end,
	},
	GameTooltip = { -- GameTooltip \ Frame
		inherits = {"Frame"},
		object = CreateFrame("GameTooltip"),
		unique_methods = function() return KD:RemoveTable(W.GameTooltip.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.GameTooltip.handlers, W.Frame.handlers) end,
	},
	MessageFrame = { -- MessageFrame \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("MessageFrame"),
		unique_methods = function()
			local obj = KD:RemoveTable(W.MessageFrame.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
		unique_handlers = function() return KD:RemoveTable(W.MessageFrame.handlers, W.Frame.handlers) end,
	},
	Minimap = { -- Minimap \ Frame
		inherits = {"Frame"},
		object = Minimap, -- unique
		unique_methods = function() return KD:RemoveTable(W.Minimap.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Minimap.handlers, W.Frame.handlers) end,
	},
	
	Model = { -- Model \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Model"),
		unique_methods = function() return KD:RemoveTable(W.Model.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Model.handlers, W.Frame.handlers) end,
	},
	PlayerModel = { -- PlayerModel \ Model
		inherits = {"Model"},
		object = CreateFrame("PlayerModel"),
		unique_methods = function() return KD:RemoveTable(W.PlayerModel.meta_object, W.Model.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.PlayerModel.handlers, W.Model.handlers) end,
	},
	CinematicModel = { -- CinematicModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("CinematicModel"),
		unique_methods = function() return KD:RemoveTable(W.CinematicModel.meta_object, W.PlayerModel.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.CinematicModel.handlers, W.PlayerModel.handlers) end,
	},
	DressupModel = { -- DressupModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("DressupModel"),
		unique_methods = function() return KD:RemoveTable(W.DressupModel.meta_object, W.PlayerModel.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.DressupModel.handlers, W.PlayerModel.handlers) end,
	},
	-- ModelFFX unavailable
	TabardModel = { -- TabardModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("TabardModel"),
		unique_methods = function() return KD:RemoveTable(W.TabardModel.meta_object, W.PlayerModel.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.TabardModel.handlers, W.PlayerModel.handlers) end,
	},
	-- UICamera unavailable
	
	ModelScene = { -- ModelScene \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ModelScene"),
		unique_methods = function() return KD:RemoveTable(W.ModelScene.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.ModelScene.handlers, W.Frame.handlers) end,
	},
	MovieFrame = { -- MovieFrame \ Frame
		inherits = {"Frame"},
		object = not IsClassic and CreateFrame("MovieFrame"),
		unique_methods = function() return KD:RemoveTable(W.MovieFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.MovieFrame.handlers, W.Frame.handlers) end,
	},
	OffScreenFrame = { -- OffScreenFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("OffScreenFrame"),
		unique_methods = function() return KD:RemoveTable(W.OffScreenFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.OffScreenFrame.handlers, W.Frame.handlers) end,
	},
	POIFrame = {
		inherits = {"Frame"}, -- ArchaeologyDigSiteFrame ∩ QuestPOIFrame
		meta_object = not IsClassic and function() return KD:CompareTable(W.ArchaeologyDigSiteFrame.meta_object, W.QuestPOIFrame.meta_object) end,
		-- (ArchaeologyDigSiteFrame ∩ QuestPOIFrame) \ Frame
		unique_methods = function() return KD:RemoveTable(W.POIFrame.meta_object(), W.Frame.meta_object) end,
	},
	ArchaeologyDigSiteFrame = { -- ArchaeologyDigSiteFrame \ POIFrame
		inherits = {"POIFrame"},
		object = not IsClassic and CreateFrame("ArchaeologyDigSiteFrame"),
		unique_methods = function() return KD:RemoveTable(W.ArchaeologyDigSiteFrame.meta_object, W.POIFrame.meta_object()) end,
		unique_handlers = function() return KD:RemoveTable(W.ArchaeologyDigSiteFrame.handlers, W.Frame.handlers) end,
	},
	QuestPOIFrame = { -- QuestPOIFrame \ POIFrame
		inherits = {"POIFrame"},
		object = not IsClassic and CreateFrame("QuestPOIFrame"),
		unique_methods = function() return KD:RemoveTable(W.QuestPOIFrame.meta_object, W.POIFrame.meta_object()) end,
		unique_handlers = function() return KD:RemoveTable(W.QuestPOIFrame.handlers, W.Frame.handlers) end,
	},
	ScenarioPOIFrame = { -- ScenarioPOIFrame \ POIFrame
		inherits = {"POIFrame"},
		object = not IsClassic and CreateFrame("ScenarioPOIFrame"),
		unique_methods = function() return KD:RemoveTable(W.ScenarioPOIFrame.meta_object, W.POIFrame.meta_object()) end,
		unique_handlers = function() return KD:RemoveTable(W.ScenarioPOIFrame.handlers, W.Frame.handlers) end,
	},
	ScrollFrame = { -- ScrollFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ScrollFrame"),
		unique_methods = function() return KD:RemoveTable(W.ScrollFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.ScrollFrame.handlers, W.Frame.handlers) end,
	},
	ScrollingMessageFrame = {
		inherits = {"Frame", "FontInstance"},
		meta_object = function()
			-- the non-inherited methods are not in metatable, get from both tables
			local obj = {}
			for k, v in pairs(CreateFrame("ScrollingMessageFrame")) do
				if type(v) == "function" then
					obj[k] = true
				end
			end
			for k, v in pairs(getmetatable(CreateFrame("ScrollingMessageFrame")).__index) do
				obj[k] = v
			end
			return obj
		end,
		unique_methods = function() -- ScrollingMessageFrame \ (FontInstance ∧ Frame)
			local object = KD:RemoveTable(W.ScrollingMessageFrame.meta_object(), W.FontInstance.meta_object())
			return KD:RemoveTable(object, W.Frame.meta_object)
		end,
		unique_handlers = function()
			local handler = {}
			local obj = CreateFrame("ScrollingMessageFrame")
			for k in pairs(KD.WidgetHandlers) do
				if obj:HasScript(k) then
					handler[k] = true
				end
			end
			return handler
		end,
	},
	SimpleHTML = { -- SimpleHTML \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("SimpleHTML"),
		unique_methods = function()
			local obj = KD:RemoveTable(W.SimpleHTML.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
		unique_handlers = function() return KD:RemoveTable(W.SimpleHTML.handlers, W.Frame.handlers) end,
	},
	Slider = { -- Slider \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Slider"),
		unique_methods = function() return KD:RemoveTable(W.Slider.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.Slider.handlers, W.Frame.handlers) end,
	},
	StatusBar = { -- StatusBar \ Frame
		inherits = {"Frame"},
		object = CreateFrame("StatusBar"),
		unique_methods = function() return KD:RemoveTable(W.StatusBar.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.StatusBar.handlers, W.Frame.handlers) end,
	},
	-- TaxiRouteFrame unavailable
	UnitPositionFrame = { -- UnitPositionFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("UnitPositionFrame"),
		unique_methods = function() return KD:RemoveTable(W.UnitPositionFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.UnitPositionFrame.handlers, W.Frame.handlers) end,
	},
	WorldFrame = { -- WorldFrame \ Frame
		inherits = {"Frame"},
		object = WorldFrame, -- unique, no extra methods
		unique_methods = function() return KD:RemoveTable(W.WorldFrame.meta_object, W.Frame.meta_object) end,
		unique_handlers = function() return KD:RemoveTable(W.WorldFrame.handlers, W.Frame.handlers) end,
	},
}

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
		"CinematicModel", "DressupModel", "TabardModel", --"ModelFFX", "UICamera",
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
}

-- https://www.townlong-yak.com/framexml/8.1.5/UI.xsd#282
KD.WidgetHandlers = {
	"OnAnimFinished",
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
	"OnHide",
	"OnHorizontalScroll",
	"OnHyperlinkClick",
	"OnHyperlinkEnter",
	"OnHyperlinkLeave",
	"OnInputLanguageChanged",
	"OnJoystickAxisMotion",
	"OnJoystickButtonDown",
	"OnJoystickButtonUp",
	"OnJoystickHatMotion",
	"OnJoystickStickMotion",
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

W = KD.WidgetClasses
KethoDocumenterEditBox:SetAutoFocus(false) -- steals our focus otherwise

-- set meta objects
for _, widget in pairs(KD.WidgetClasses) do
	if widget.object then
		widget.meta_object = getmetatable(widget.object).__index
	end
end

-- fill handlers
for _, widget in pairs(KD.WidgetClasses) do
	if widget.object and widget.object.HasScript then
		widget.handlers = {}
		for _, handler in pairs(KD.WidgetHandlers) do
			if widget.object:HasScript(handler) then
				widget.handlers[handler] = true
			end
		end
	end
end
