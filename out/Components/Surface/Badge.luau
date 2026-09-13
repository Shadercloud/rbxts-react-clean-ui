-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local Padding = _Decorator.Padding
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local HStack = TS.import(script, script.Parent.Parent, "Layout").HStack
local Icon = TS.import(script, script.Parent, "Icon").Icon
local Badge = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local badgeTheme = theme.components.badge
	local scale = props.scale or theme.default.scale
	local intentColors = ColorHelper:getIntentColors(theme, props.intent, "default", badgeTheme.intents)
	local backgroundImage = CssHelper:resolveBackgroundImage(intentColors.backgroundImage)
	local padding = SpacingHelper:GetResolvedPadding(theme, {}, badgeTheme.spacing, badgeTheme.padding, scale)
	local gap = math.ceil(SpacingHelper:GetPadding(theme, scale, badgeTheme.spacing) / 2)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Badge"
	end
	_attributes.key = _condition
	_attributes.ref = ref
	_attributes.Active = false
	_attributes.Selectable = false
	_attributes.Size = UDim2.fromOffset(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.Position = props.Position
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.BackgroundColor3 = intentColors.backgroundColor
	local _condition_1 = intentColors.backgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 0
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BorderSizePixel = 0
	local _condition_2 = backgroundImage.Image
	if _condition_2 == nil then
		_condition_2 = ""
	end
	_attributes.Image = _condition_2
	_attributes.ImageColor3 = backgroundImage.ImageColor3
	_attributes.ImageTransparency = backgroundImage.ImageTransparency
	_attributes.ScaleType = backgroundImage.ScaleType
	_attributes.SliceCenter = backgroundImage.SliceCenter
	_attributes.SliceScale = backgroundImage.SliceScale
	_attributes.TileSize = backgroundImage.TileSize
	return React.createElement("imagelabel", _attributes, React.createElement(Corners, {
		radius = badgeTheme.cornerRadius,
	}), badgeTheme.borderThickness > 0 and (React.createElement("uistroke", {
		key = "Stroke",
		Thickness = badgeTheme.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = intentColors.borderColor,
	})), React.createElement(Gradient, {
		value = intentColors.backgroundGradient,
	}), React.createElement(Padding, {
		resolvedPadding = padding,
	}), React.createElement(HStack, {
		valign = "Center",
		Wraps = false,
		Padding = UDim.new(0, gap),
	}, props.icon ~= nil and React.createElement(Icon, {
		name = "BadgeIcon",
		LayoutOrder = 1,
		scale = scale,
		icon = props.icon,
		color = intentColors.textColor,
	}), React.createElement(Text, {
		name = "BadgeText",
		LayoutOrder = 2,
		text = props.text,
		TextWrap = false,
		typography = TypographyHelper:getTypography(theme, scale, badgeTheme.typography),
		TextColor3 = intentColors.textColor,
	})))
end)
return {
	Badge = Badge,
}
