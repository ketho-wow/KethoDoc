
local KD = KethoDoc
local W

if not (KD.branch == "live" or KD.branch == "ptr") then
	return
end

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
		methods = KD.GetScriptObject,
	},
	Object = {
		inherits = {},
		meta_object = KD.GetObject,
		methods = KD.GetObject,
	},
	UIObject = {
		inherits = {"Object"},
		-- AnimationGroup ∩ ControlPoint
		meta_object = function() return (KD:CompareTable(W.AnimationGroup.meta_object, W.ControlPoint.meta_object)) end,
		-- UIObject \ Object
		methods = function() return KD:RemoveTable(W.UIObject.meta_object(), W.Object.meta_object()) end,
	},
	Region = {
		inherits = {"UIObject"},
		-- Frame ∩ LayeredRegion
		meta_object = function() return (KD:CompareTable(W.Frame.meta_object, W.LayeredRegion.meta_object())) end,
		-- Region \ UIObject
		methods = function() return KD:RemoveTable(W.Region.meta_object(), W.UIObject.meta_object()) end,
	},
	LayeredRegion = {
		inherits = {"Region"},
		-- Texture ∩ FontString
		meta_object = function() return (KD:CompareTable(W.Texture.meta_object, W.FontString.meta_object)) end,
		-- Region \ LayeredRegion
		methods = function() return KD:RemoveTable(W.LayeredRegion.meta_object(), W.Region.meta_object()) end,
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
		methods = function() return KD:RemoveTable(W.FontInstance.meta_object(), W.Object.meta_object()) end,
	},
	
	Font = { -- Font \ FontInstance
		inherits = {"FontInstance"},
		object = CreateFont(""),
		methods = function() return KD:RemoveTable(W.Font.meta_object, W.FontInstance.meta_object()) end,
	},
	FontString = { -- FontString \ (FontInstance ∧ LayeredRegion)
		inherits = {"LayeredRegion", "FontInstance"},
		object = CreateFrame("Frame"):CreateFontString(),
		methods = function()
			local obj = KD:RemoveTable(W.FontString.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.LayeredRegion.meta_object())
		end,
	},
	
	Texture = { -- Texture \ LayeredRegion
		inherits = {"LayeredRegion"},
		object = CreateFrame("Frame"):CreateTexture(),
		methods = function() return KD:RemoveTable(W.Texture.meta_object, W.LayeredRegion.meta_object()) end,
	},
	Line = { -- Texture +6 -12
		inherits = {"Texture"},
		object = CreateFrame("Frame"):CreateLine(),
		methods = function() return KD:RemoveTable(W.Line.meta_object, W.Texture.meta_object) end,
	},
	MaskTexture = { -- Texture -4
		inherits = {"Texture"},
		object = CreateFrame("Frame"):CreateMaskTexture(),
		methods = function() return KD:RemoveTable(W.MaskTexture.meta_object, W.Texture.meta_object) end,
	},
	
	AnimationGroup = { -- AnimationGroup \ (UIObject ∧ ScriptObject)
		inherits = {"UIObject", "ScriptObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup(),
		methods = function()
			local obj = KD:RemoveTable(W.AnimationGroup.meta_object, W.UIObject.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
	},
	Animation = { -- Animation \ (UIObject ∧ ScriptObject)
		inherits = {"UIObject", "ScriptObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation(),
		methods = function()
			local obj = KD:RemoveTable(W.Animation.meta_object, W.UIObject.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
	},
	Alpha = { -- Alpha \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Alpha"),
		methods = function() return KD:RemoveTable(W.Alpha.meta_object, W.Animation.meta_object) end,
	},
	LineScale = { -- LineScale \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineScale"),
		methods = function() return KD:RemoveTable(W.LineScale.meta_object, W.Animation.meta_object) end,
	},
	LineTranslation = { -- LineTranslation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("LineTranslation"),
		methods = function() return KD:RemoveTable(W.LineTranslation.meta_object, W.Animation.meta_object) end,
	},
	Path = { -- Path \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"),
		methods = function() return KD:RemoveTable(W.Path.meta_object, W.Animation.meta_object) end,
	},
	ControlPoint = { -- ControlPoint \ UIObject
		inherits = {"UIObject"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Path"):CreateControlPoint(),
		methods = function() return KD:RemoveTable(W.ControlPoint.meta_object, W.UIObject.meta_object()) end,
	},
	Rotation = { -- Rotation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Rotation"),
		methods = function() return KD:RemoveTable(W.Rotation.meta_object, W.Animation.meta_object) end,
	},
	Scale = { -- Scale \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Scale"),
		methods = function() return KD:RemoveTable(W.Scale.meta_object, W.Animation.meta_object) end,
	},
	TextureCoordTranslation = { -- TextureCoordTranslation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("TextureCoordTranslation"),
		methods = function() return KD:RemoveTable(W.TextureCoordTranslation.meta_object, W.Animation.meta_object) end,
	},
	Translation = { -- Translation \ Animation
		inherits = {"Animation"},
		object = CreateFrame("Frame"):CreateAnimationGroup():CreateAnimation("Translation"),
		methods = function() return KD:RemoveTable(W.Translation.meta_object, W.Animation.meta_object) end,
	},
	
	Frame = { -- Browser ∩ Button
		inherits = {"Region", "ScriptObject"},
		object = CreateFrame("Frame"),
		methods = function()
			local obj = KD:RemoveTable(W.Frame.meta_object, W.Region.meta_object())
			return KD:RemoveTable(obj, W.ScriptObject.meta_object())
		end,
	},
	Browser = { -- Browser \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Browser"),
		methods = function() return KD:RemoveTable(W.Browser.meta_object, W.Frame.meta_object) end,
	},
	
	Button = { -- Button \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Button"),
		methods = function() return KD:RemoveTable(W.Button.meta_object, W.Frame.meta_object) end,
	},
	CheckButton = { -- CheckButton \ Button
		inherits = {"Button"},
		object = CreateFrame("CheckButton"),
		methods = function() return KD:RemoveTable(W.CheckButton.meta_object, W.Button.meta_object) end,
	},
	ItemButton = { -- ItemButton \ Button
		inherits = {"Button"},
		object = CreateFrame("ItemButton"), -- no extra methods
		methods = function() return KD:RemoveTable(W.ItemButton.meta_object, W.ItemButton.meta_object) end,
	},
	-- UnitButton unavailable
	
	Checkout = { -- Checkout \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Checkout"),
		methods = function() return KD:RemoveTable(W.Checkout.meta_object, W.Frame.meta_object) end,
	},
	ColorSelect = { -- ColorSelect \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ColorSelect"),
		methods = function() return KD:RemoveTable(W.ColorSelect.meta_object, W.Frame.meta_object) end,
	},
	Cooldown = { -- Cooldown \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Cooldown"),
		methods = function() return KD:RemoveTable(W.Cooldown.meta_object, W.Frame.meta_object) end,
	},
	EditBox = { -- EditBox \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("EditBox", "KethoDocumenterEditBox"),
		methods = function()
			local obj = KD:RemoveTable(W.EditBox.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
	},
	FogOfWarFrame = { -- FogOfWarFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("FogOfWarFrame"),
		methods = function() return KD:RemoveTable(W.FogOfWarFrame.meta_object, W.Frame.meta_object) end,
	},
	GameTooltip = { -- GameTooltip \ Frame
		inherits = {"Frame"},
		object = CreateFrame("GameTooltip"),
		methods = function() return KD:RemoveTable(W.GameTooltip.meta_object, W.Frame.meta_object) end,
	},
	MessageFrame = { -- MessageFrame \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("MessageFrame"),
		methods = function()
			local obj = KD:RemoveTable(W.MessageFrame.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
	},
	Minimap = { -- Minimap \ Frame
		inherits = {"Frame"},
		object = Minimap, -- unique
		methods = function() return KD:RemoveTable(W.Minimap.meta_object, W.Frame.meta_object) end,
	},
	
	Model = { -- Model \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Model"),
		methods = function() return KD:RemoveTable(W.Model.meta_object, W.Frame.meta_object) end,
	},
	PlayerModel = { -- PlayerModel \ Model
		inherits = {"Model"},
		object = CreateFrame("PlayerModel"),
		methods = function() return KD:RemoveTable(W.PlayerModel.meta_object, W.Model.meta_object) end,
	},
	CinematicModel = { -- CinematicModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("CinematicModel"),
		methods = function() return KD:RemoveTable(W.CinematicModel.meta_object, W.PlayerModel.meta_object) end,
	},
	DressupModel = { -- DressupModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("DressupModel"),
		methods = function() return KD:RemoveTable(W.DressupModel.meta_object, W.PlayerModel.meta_object) end,
	},
	-- ModelFFX unavailable
	TabardModel = { -- TabardModel \ Model
		inherits = {"PlayerModel"},
		object = CreateFrame("TabardModel"),
		methods = function() return KD:RemoveTable(W.TabardModel.meta_object, W.PlayerModel.meta_object) end,
	},
	-- UICamera unavailable
	
	ModelScene = { -- ModelScene \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ModelScene"),
		methods = function() return KD:RemoveTable(W.ModelScene.meta_object, W.Frame.meta_object) end,
	},
	MovieFrame = { -- MovieFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("MovieFrame"),
		methods = function() return KD:RemoveTable(W.MovieFrame.meta_object, W.Frame.meta_object) end,
	},
	OffScreenFrame = { -- OffScreenFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("OffScreenFrame"),
		methods = function() return KD:RemoveTable(W.OffScreenFrame.meta_object, W.Frame.meta_object) end,
	},
	POIFrame = {
		inherits = {"Frame"}, -- ArchaeologyDigSiteFrame ∩ QuestPOIFrame
		meta_object = function() return KD:CompareTable(W.ArchaeologyDigSiteFrame.meta_object, W.QuestPOIFrame.meta_object) end,
		-- (ArchaeologyDigSiteFrame ∩ QuestPOIFrame) \ Frame
		methods = function() return KD:RemoveTable(W.POIFrame.meta_object(), W.Frame.meta_object) end,
	},
	ArchaeologyDigSiteFrame = { -- ArchaeologyDigSiteFrame \ POIFrame
		inherits = {"POIFrame"},
		object = CreateFrame("ArchaeologyDigSiteFrame"),
		methods = function() return KD:RemoveTable(W.ArchaeologyDigSiteFrame.meta_object, W.POIFrame.meta_object()) end,
	},
	QuestPOIFrame = { -- QuestPOIFrame \ POIFrame
		inherits = {"POIFrame"},
		object = CreateFrame("QuestPOIFrame"),
		methods = function() return KD:RemoveTable(W.QuestPOIFrame.meta_object, W.POIFrame.meta_object()) end,
	},
	ScenarioPOIFrame = { -- ScenarioPOIFrame \ POIFrame
		inherits = {"POIFrame"},
		object = CreateFrame("ScenarioPOIFrame"),
		methods = function() return KD:RemoveTable(W.ScenarioPOIFrame.meta_object, W.POIFrame.meta_object()) end,
	},
	ScrollFrame = { -- ScrollFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("ScrollFrame"),
		methods = function() return KD:RemoveTable(W.ScrollFrame.meta_object, W.Frame.meta_object) end,
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
		methods = function() -- ScrollingMessageFrame \ (FontInstance ∧ Frame)
			local object = KD:RemoveTable(W.ScrollingMessageFrame.meta_object(), W.FontInstance.meta_object())
			return KD:RemoveTable(object, W.Frame.meta_object)
		end,
	},
	SimpleHTML = { -- SimpleHTML \ (FontInstance ∧ Frame)
		inherits = {"Frame", "FontInstance"},
		object = CreateFrame("SimpleHTML"),
		methods = function()
			local obj = KD:RemoveTable(W.SimpleHTML.meta_object, W.FontInstance.meta_object())
			return KD:RemoveTable(obj, W.Frame.meta_object)
		end,
	},
	Slider = { -- Slider \ Frame
		inherits = {"Frame"},
		object = CreateFrame("Slider"),
		methods = function() return KD:RemoveTable(W.Slider.meta_object, W.Frame.meta_object) end,
	},
	StatusBar = { -- StatusBar \ Frame
		inherits = {"Frame"},
		object = CreateFrame("StatusBar"),
		methods = function() return KD:RemoveTable(W.StatusBar.meta_object, W.Frame.meta_object) end,
	},
	-- TaxiRouteFrame unavailable
	UnitPositionFrame = { -- UnitPositionFrame \ Frame
		inherits = {"Frame"},
		object = CreateFrame("UnitPositionFrame"),
		methods = function() return KD:RemoveTable(W.UnitPositionFrame.meta_object, W.Frame.meta_object) end,
	},
	WorldFrame = { -- WorldFrame \ Frame
		inherits = {"Frame"},
		object = WorldFrame, -- unique, no extra methods
		methods = function() return KD:RemoveTable(W.WorldFrame.meta_object, W.Frame.meta_object) end,
	},
}

W = KD.WidgetClasses
KethoDocumenterEditBox:SetAutoFocus(false) -- steals our focus otherwise

for _, widget in pairs(KD.WidgetClasses) do
	if widget.object then
		widget.meta_object = getmetatable(widget.object).__index
	end
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
