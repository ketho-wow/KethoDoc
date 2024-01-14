
local W

local function TryCreateFrame(frameType, ...)
	local ok, frame = pcall(CreateFrame, frameType, ...)
	if ok and frame.GetObjectType then
		return frame
	-- else
	-- 	print(ok, frame)
	end
end

local FrameScriptObject = {
	GetName = true,
	GetObjectType = true,
	IsForbidden = true,
	IsObjectType = true,
	SetForbidden = true,
}

local Object = {
	GetName = true,
	GetObjectType = true,
	IsForbidden = true,
	IsObjectType = true,
	SetForbidden = true,
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
		FrameScriptObject = {
			inherits = {},
			meta_object = function() return FrameScriptObject end,
			unique_methods = function() return FrameScriptObject end,
		},
		-- ScriptObject = {
		-- 	inherits = {},
		-- 	meta_object = function() return ScriptObject end,
		-- 	unique_methods = function() return ScriptObject end,
		-- 	unique_handlers = function() return self:CompareTable(W.AnimationGroup.handlers, W.Frame.handlers) end,
		-- },
		Object = {
			inherits = {"FrameScriptObject"},
			meta_object = function() return Object end,
			unique_methods = function() return Object end,
			unique_handlers = function() return self:CompareTable(W.AnimationGroup.handlers, W.Frame.handlers) end,
		},
		Region = {
			inherits = {"Object"},
			-- Frame ∩ LayeredRegion
			meta_object = function() return (self:CompareTable(W.Frame.meta_object, W.LayeredRegion.meta_object())) end,
			-- Region \ UIObject \ ScriptObject
			unique_methods = function()
				local t = self:RemoveTable(W.Region.meta_object(), W.Object.meta_object())
				return self:RemoveTable(t, W.Object.meta_object())
			end,
			-- Texture ∩ FontString \ ScriptObject
			unique_handlers = function()
				local union = self:CompareTable(W.Texture.handlers, W.FontString.handlers)
				return self:RemoveTable(union, W.Object.unique_handlers())
			end,
		},
		LayeredRegion = {
			inherits = {"Region"},
			-- Texture ∩ FontString
			meta_object = function() return (self:CompareTable(W.Texture.meta_object, W.FontString.meta_object)) end,
			-- Region \ LayeredRegion
			unique_methods = function() return self:RemoveTable(W.LayeredRegion.meta_object(), W.Region.meta_object()) end,
		},
		FontInstance = {
			inherits = {},
			meta_object = function() -- Font ∩ FontString
				-- local FontInstance = self:CompareTable(W.Font.meta_object, W.FontString.meta_object)
				-- Font has its own version and FontString inherits from LayeredRegion
				-- FontInstance.GetAlpha = nil
				-- FontInstance.SetAlpha = nil
				return FontInstance
			end, -- FontInstance \ Object
			-- unique_methods = function() return self:RemoveTable(W.FontInstance.meta_object(), W.UIObject.meta_object()) end,
			unique_methods = function() return FontInstance end,
		},

		Font = { -- Font \ FontInstance
			inherits = {"FontInstance"},
			object = CreateFont(""),
			unique_methods = function() return self:RemoveTable(W.Font.meta_object, W.FontInstance.meta_object()) end,
		},
		FontString = { -- FontString \ (FontInstance ∧ LayeredRegion)
			inherits = {"LayeredRegion", "FontInstance"},
			object = TryCreateFrame("Frame"):CreateFontString(),
			unique_methods = function()
				local obj = self:RemoveTable(W.FontString.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.LayeredRegion.meta_object())
			end,
		},

		Texture = { -- Texture \ LayeredRegion
			inherits = {"LayeredRegion"},
			object = TryCreateFrame("Frame"):CreateTexture(),
			unique_methods = function() return self:RemoveTable(W.Texture.meta_object, W.LayeredRegion.meta_object()) end,
		},
		Line = { -- Texture +6 -12
			inherits = {"Texture"},
			object = TryCreateFrame("Frame"):CreateLine(),
			unique_methods = function() return self:RemoveTable(W.Line.meta_object, W.Texture.meta_object) end,
		},
		MaskTexture = { -- Texture -4
			inherits = {"Texture"},
			object = TryCreateFrame("Frame"):CreateMaskTexture(),
			unique_methods = function() return self:RemoveTable(W.MaskTexture.meta_object, W.Texture.meta_object) end,
		},

		AnimationGroup = { -- AnimationGroup \ (UIObject ∧ ScriptObject)
			inherits = {"Object"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup(),
			unique_methods = function()
				local obj = self:RemoveTable(W.AnimationGroup.meta_object, W.Object.meta_object())
				return self:RemoveTable(obj, W.Object.meta_object())
			end,
			unique_handlers = function() return self:RemoveTable(W.AnimationGroup.handlers, W.Object.unique_handlers()) end,
		},
		Animation = { -- Animation \ (UIObject ∧ ScriptObject)
			inherits = {"Object"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
			unique_methods = function()
				local obj = self:RemoveTable(W.Animation.meta_object, W.Object.meta_object())
				return self:RemoveTable(obj, W.Object.meta_object())
			end,
			unique_handlers = function() return self:RemoveTable(W.Animation.handlers, W.Object.unique_handlers()) end,
		},
		Alpha = { -- Alpha \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
			unique_methods = function() return self:RemoveTable(W.Alpha.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Alpha.handlers, W.Animation.handlers) end,
		},
		LineScale = { -- LineScale \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
			unique_methods = function() return self:RemoveTable(W.LineScale.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.LineScale.handlers, W.Animation.handlers) end,
		},
		LineTranslation = { -- LineTranslation \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
			unique_methods = function() return self:RemoveTable(W.LineTranslation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.LineTranslation.handlers, W.Animation.handlers) end,
		},
		Path = { -- Path \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
			unique_methods = function() return self:RemoveTable(W.Path.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Path.handlers, W.Animation.handlers) end,
		},
		ControlPoint = { -- ControlPoint \ UIObject
			inherits = {"Object"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
			unique_methods = function() return self:RemoveTable(W.ControlPoint.meta_object, W.Object.meta_object()) end,
		},
		Rotation = { -- Rotation \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
			unique_methods = function() return self:RemoveTable(W.Rotation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Rotation.handlers, W.Animation.handlers) end,
		},
		Scale = { -- Scale \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
			unique_methods = function() return self:RemoveTable(W.Scale.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Scale.handlers, W.Animation.handlers) end,
		},
		TextureCoordTranslation = { -- TextureCoordTranslation \ Animation
		inherits = {"Animation"},
			-- apparently can only be created in XML
			--object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("TextureCoordTranslation"),
			object = KethoFrame.animgroup.texcoordtranslation,
			unique_methods = function() return self:RemoveTable(W.TextureCoordTranslation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.TextureCoordTranslation.handlers, W.Animation.handlers) end,
		},
		Translation = { -- Translation \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
			unique_methods = function() return self:RemoveTable(W.Translation.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Translation.handlers, W.Animation.handlers) end,
		},
		FlipBook = { -- FlipBook \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("FlipBook"),
			unique_methods = function() return self:RemoveTable(W.FlipBook.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.FlipBook.handlers, W.Animation.handlers) end,
		},
		VertexColor = { -- VertexColor \ Animation
			inherits = {"Animation"},
			object = TryCreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("VertexColor"),
			unique_methods = function() return self:RemoveTable(W.VertexColor.meta_object, W.Animation.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.VertexColor.handlers, W.Animation.handlers) end,
		},

		Frame = { -- Frame \ (Region ∧ ScriptObject)
			inherits = {"Region"},
			object = TryCreateFrame("Frame"),
			unique_methods = function()
				local obj = self:RemoveTable(W.Frame.meta_object, W.Region.meta_object())
				return self:RemoveTable(obj, W.Object.meta_object())
			end,
			unique_handlers = function() local t = self:RemoveTable(W.Frame.handlers, W.Region.unique_handlers())
				return self:RemoveTable(t, W.Object.unique_handlers())
			end,
		},
		Browser = { -- Browser \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("Browser"),
			unique_methods = function() return self:RemoveTable(W.Browser.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Browser.handlers, W.Frame.handlers) end,
		},

		Button = { -- Button \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("Button"),
			unique_methods = function() return self:RemoveTable(W.Button.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Button.handlers, W.Frame.handlers) end,
		},
		CheckButton = { -- CheckButton \ Button
			inherits = {"Button"},
			object = TryCreateFrame("CheckButton"),
			unique_methods = function() return self:RemoveTable(W.CheckButton.meta_object, W.Button.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.CheckButton.handlers, W.Button.handlers) end,
		},
		-- UnitButton unavailable
		Checkout = { -- Checkout \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("Checkout"),
			unique_methods = function() return self:RemoveTable(W.Checkout.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Checkout.handlers, W.Frame.handlers) end,
		},
		ColorSelect = { -- ColorSelect \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("ColorSelect"),
			unique_methods = function() return self:RemoveTable(W.ColorSelect.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ColorSelect.handlers, W.Frame.handlers) end,
		},
		Cooldown = { -- Cooldown \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("Cooldown"),
			unique_methods = function() return self:RemoveTable(W.Cooldown.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Cooldown.handlers, W.Frame.handlers) end,
		},
		EditBox = { -- EditBox \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("EditBox"),
			unique_methods = function()
				local obj = self:RemoveTable(W.EditBox.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.Frame.meta_object)
			end,
			unique_handlers = function() return self:RemoveTable(W.EditBox.handlers, W.Frame.handlers) end,
		},
		FogOfWarFrame = { -- FogOfWarFrame \ Frame
			inherits = {"Frame"},
			-- does not error and returns an empty frame in classic/bc
			object = TryCreateFrame("FogOfWarFrame"),
			unique_methods = function() return self:RemoveTable(W.FogOfWarFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.FogOfWarFrame.handlers, W.Frame.handlers) end,
		},
		GameTooltip = { -- GameTooltip \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("GameTooltip"),
			unique_methods = function() return self:RemoveTable(W.GameTooltip.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.GameTooltip.handlers, W.Frame.handlers) end,
		},
		MessageFrame = { -- MessageFrame \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("MessageFrame"),
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
			object = TryCreateFrame("Model"),
			unique_methods = function() return self:RemoveTable(W.Model.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Model.handlers, W.Frame.handlers) end,
		},
		PlayerModel = { -- PlayerModel \ Model
			inherits = {"Model"},
			object = TryCreateFrame("PlayerModel"),
			unique_methods = function() return self:RemoveTable(W.PlayerModel.meta_object, W.Model.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.PlayerModel.handlers, W.Model.handlers) end,
		},
		CinematicModel = { -- CinematicModel \ Model
			inherits = {"PlayerModel"},
			object = TryCreateFrame("CinematicModel"),
			unique_methods = function() return self:RemoveTable(W.CinematicModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.CinematicModel.handlers, W.PlayerModel.handlers) end,
		},
		DressUpModel = { -- DressUpModel \ Model
			inherits = {"PlayerModel"},
			object = TryCreateFrame("DressUpModel"),
			unique_methods = function() return self:RemoveTable(W.DressUpModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.DressUpModel.handlers, W.PlayerModel.handlers) end,
		},
		-- ModelFFX unavailable
		TabardModel = { -- TabardModel \ Model
			inherits = {"PlayerModel"},
			object = TryCreateFrame("TabardModel"),
			unique_methods = function() return self:RemoveTable(W.TabardModel.meta_object, W.PlayerModel.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.TabardModel.handlers, W.PlayerModel.handlers) end,
		},
		-- UICamera unavailable

		ModelScene = { -- ModelScene \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("ModelScene"),
			unique_methods = function() return self:RemoveTable(W.ModelScene.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ModelScene.handlers, W.Frame.handlers) end,
		},
		MovieFrame = { -- MovieFrame \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("MovieFrame"),
			unique_methods = function() return self:RemoveTable(W.MovieFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.MovieFrame.handlers, W.Frame.handlers) end,
		},
		OffScreenFrame = { -- OffScreenFrame \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("OffScreenFrame"),
			unique_methods = function() return self:RemoveTable(W.OffScreenFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.OffScreenFrame.handlers, W.Frame.handlers) end,
		},
		POIFrame = {
			inherits = {"Frame"}, -- ArchaeologyDigSiteFrame ∩ QuestPOIFrame
			meta_object = self.isMainline and function() return self:CompareTable(W.ArchaeologyDigSiteFrame.meta_object, W.QuestPOIFrame.meta_object) end,
			-- (ArchaeologyDigSiteFrame ∩ QuestPOIFrame) \ Frame
			unique_methods = function() return self:RemoveTable(W.POIFrame.meta_object(), W.Frame.meta_object) end,
		},
		ArchaeologyDigSiteFrame = { -- ArchaeologyDigSiteFrame \ POIFrame
			inherits = {"POIFrame"},
			object = TryCreateFrame("ArchaeologyDigSiteFrame"),
			unique_methods = function() return self:RemoveTable(W.ArchaeologyDigSiteFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.ArchaeologyDigSiteFrame.handlers, W.Frame.handlers) end,
		},
		QuestPOIFrame = { -- QuestPOIFrame \ POIFrame
			inherits = {"POIFrame"},
			object = TryCreateFrame("QuestPOIFrame"),
			unique_methods = function() return self:RemoveTable(W.QuestPOIFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.QuestPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScenarioPOIFrame = { -- ScenarioPOIFrame \ POIFrame
			inherits = {"POIFrame"},
			object = TryCreateFrame("ScenarioPOIFrame"),
			unique_methods = function() return self:RemoveTable(W.ScenarioPOIFrame.meta_object, W.POIFrame.meta_object()) end,
			unique_handlers = function() return self:RemoveTable(W.ScenarioPOIFrame.handlers, W.Frame.handlers) end,
		},
		ScrollFrame = { -- ScrollFrame \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("ScrollFrame"),
			unique_methods = function() return self:RemoveTable(W.ScrollFrame.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.ScrollFrame.handlers, W.Frame.handlers) end,
		},
		SimpleHTML = { -- SimpleHTML \ (FontInstance ∧ Frame)
			inherits = {"Frame", "FontInstance"},
			object = TryCreateFrame("SimpleHTML"),
			unique_methods = function()
				local obj = self:RemoveTable(W.SimpleHTML.meta_object, W.FontInstance.meta_object())
				return self:RemoveTable(obj, W.Frame.meta_object)
			end,
			unique_handlers = function() return self:RemoveTable(W.SimpleHTML.handlers, W.Frame.handlers) end,
		},
		Slider = { -- Slider \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("Slider"),
			unique_methods = function() return self:RemoveTable(W.Slider.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.Slider.handlers, W.Frame.handlers) end,
		},
		StatusBar = { -- StatusBar \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("StatusBar"),
			unique_methods = function() return self:RemoveTable(W.StatusBar.meta_object, W.Frame.meta_object) end,
			unique_handlers = function() return self:RemoveTable(W.StatusBar.handlers, W.Frame.handlers) end,
		},
		-- TaxiRouteFrame unavailable
		UnitPositionFrame = { -- UnitPositionFrame \ Frame
			inherits = {"Frame"},
			object = TryCreateFrame("UnitPositionFrame"),
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
			inherits = {"Object"},
			object = TryCreateFrame("ModelScene"):CreateActor(),
			unique_methods = function() return self:RemoveTable(W.ModelSceneActor.meta_object, W.Object.meta_object()) end,
			unique_handlers = function()
				return { -- can only set these from XML
					OnModelCleared = true,
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
	"FrameScriptObject",
	"Object",
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
	"FlipBook",
	"VertexColor",

	-- frame
	"Frame",
	"Browser",
	"Button", "CheckButton",
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
	-- this test is wrong, ScriptObject on FontString and Texture does not appear to be tested
	local widgets = {
		{"FrameScriptObject",       {}},
		{"Object",                  {}},
		{"Region",                  {W.Object}},
		{"LayeredRegion",           {W.Region, W.Object, W.FrameScriptObject}},

		{"FontInstance",            {}},
		{"Font",                    {W.FontInstance, W.FrameScriptObject}},
		{"FontString",              {W.LayeredRegion, W.Region, W.Object, W.FrameScriptObject, W.FontInstance}},
		{"Texture",                 {W.LayeredRegion, W.Region, W.Object, W.FrameScriptObject}},
		{"Line",                    {W.Texture, W.LayeredRegion, W.Region, W.Object, W.FrameScriptObject}},
		{"MaskTexture",             {W.Texture, W.LayeredRegion, W.Region, W.Object, W.FrameScriptObject}},

		{"AnimationGroup",          {W.Object, W.FrameScriptObject}},
		{"Animation",               {W.Object, W.FrameScriptObject}},
		{"Alpha",                   {W.Animation, W.Object, W.FrameScriptObject}},
		{"LineScale",               {W.Animation, W.Object, W.FrameScriptObject}},
		{"Translation",             {W.Animation, W.Object, W.FrameScriptObject}},
		{"LineTranslation",         {W.Animation, W.Object, W.FrameScriptObject}},
		{"Path",                    {W.Animation, W.Object, W.FrameScriptObject}},
		{"ControlPoint",            {W.Object}},
		{"Rotation",                {W.Animation, W.Object, W.FrameScriptObject}},
		{"TextureCoordTranslation", {W.Animation, W.Object, W.FrameScriptObject}},
		{"FlipBook",                {W.Animation, W.Object, W.FrameScriptObject}},
		{"VertexColor",             {W.Animation, W.Object, W.FrameScriptObject}},

		{"Frame",                   {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Browser",                 {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Button",                  {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"CheckButton",             {W.Button, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Checkout",                {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"ColorSelect",             {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Cooldown",                {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"EditBox",                 {W.FontInstance, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"FogOfWarFrame",           {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"GameTooltip",             {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"MessageFrame",            {W.FontInstance, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Minimap",                 {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Model",                   {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"PlayerModel",             {W.Model, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"CinematicModel",          {W.PlayerModel, W.Model, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"DressUpModel",            {W.PlayerModel, W.Model, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"TabardModel",             {W.PlayerModel, W.Model, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"ModelScene",              {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"MovieFrame",              {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"OffScreenFrame",          {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"POIFrame",                {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"ArchaeologyDigSiteFrame", {W.POIFrame, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"QuestPOIFrame",           {W.POIFrame, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"ScenarioPOIFrame",        {W.POIFrame, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"ScrollFrame",             {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"SimpleHTML",              {W.FontInstance, W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"Slider",                  {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"StatusBar",               {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"UnitPositionFrame",       {W.Frame, W.Region, W.Object, W.FrameScriptObject}},
		{"WorldFrame",              {W.Frame, W.Region, W.Object, W.FrameScriptObject}},

		{"ModelSceneActor",         {W.Object}},
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
			if not blaat1 then
				blaat1, blaat2 = meta_object, expected
			end
			print("Failed:", v[1], size1, size2)

		end
	end
	print(format("Widgets: Passed %d of %d tests", passed_count, #widgets))
	-- Widgets: Passed 52 of 52 tests in 9.2.5 (44232)
end
