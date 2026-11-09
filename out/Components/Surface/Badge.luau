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
local function darkenColor(color, amount)
	local target = if amount < 0 then Color3.new(1, 1, 1) else Color3.new(0, 0, 0)
	local alpha = math.abs(amount)
	local _color = color
	if typeof(_color) == "Color3" then
		return color:Lerp(target, alpha)
	end
	return color:map(function(value)
		return value:Lerp(target, alpha)
	end)
end
local Badge = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local badgeTheme = theme.components.badge
	local scale = props.scale or theme.default.scale
	local clickable = props.onClick ~= nil
	local hover, setHover = React.useState(false)
	local pressed, setPressed = React.useState(false)
	React.useEffect(function()
		if not clickable then
			setHover(false)
			setPressed(false)
		end
	end, { clickable })
	local intentColors = ColorHelper:getIntentColors(theme, props.intent, "default", badgeTheme.intents)
	local _result
	if not clickable then
		_result = nil
	else
		local _result_1
		if pressed then
			local _object = {}
			local _spread = props.hoverStyle
			if _spread then
				for _k, _v in _spread do
					_object[_k] = _v
				end
			end
			local _spread_1 = props.pressStyle
			if _spread_1 then
				for _k, _v in _spread_1 do
					_object[_k] = _v
				end
			end
			_result_1 = _object
		else
			_result_1 = if hover then props.hoverStyle else nil
		end
		_result = _result_1
	end
	local stateStyle = _result
	local _result_1
	if not clickable then
		_result_1 = 0
	else
		local _result_2
		if pressed then
			local _condition = badgeTheme.pressDarken
			if _condition == nil then
				_condition = badgeTheme.hoverDarken
				if _condition == nil then
					_condition = 0
				end
			end
			_result_2 = _condition
		else
			local _result_3
			if hover then
				local _condition = badgeTheme.hoverDarken
				if _condition == nil then
					_condition = 0
				end
				_result_3 = _condition
			else
				_result_3 = 0
			end
			_result_2 = _result_3
		end
		_result_1 = _result_2
	end
	local darken = _result_1
	local baseBackgroundColor = props.BackgroundColor3 or intentColors.backgroundColor
	local _result_2 = stateStyle
	if _result_2 ~= nil then
		_result_2 = _result_2.backgroundColor
	end
	local _condition = _result_2
	if _condition == nil then
		_condition = (if darken ~= 0 then darkenColor(baseBackgroundColor, darken) else baseBackgroundColor)
	end
	local backgroundColor = _condition
	local _result_3 = stateStyle
	if _result_3 ~= nil then
		_result_3 = _result_3.textColor
	end
	local _condition_1 = _result_3
	if _condition_1 == nil then
		_condition_1 = props.textColor or intentColors.textColor
	end
	local textColor = _condition_1
	local _result_4 = stateStyle
	if _result_4 ~= nil then
		_result_4 = _result_4.iconColor
	end
	local _condition_2 = _result_4
	if _condition_2 == nil then
		_condition_2 = props.iconColor or textColor
	end
	local iconColor = _condition_2
	local _result_5 = stateStyle
	if _result_5 ~= nil then
		_result_5 = _result_5.borderColor
	end
	local _condition_3 = _result_5
	if _condition_3 == nil then
		_condition_3 = props.borderColor or intentColors.borderColor
	end
	local borderColor = _condition_3
	local _condition_4 = props.borderThickness
	if _condition_4 == nil then
		_condition_4 = badgeTheme.borderThickness
	end
	local borderThickness = _condition_4
	local backgroundImage = CssHelper:resolveBackgroundImage(intentColors.backgroundImage)
	local padding = SpacingHelper:GetResolvedPadding(theme, {
		padding = props.padding,
	}, badgeTheme.spacing, badgeTheme.padding, scale)
	local gap = math.ceil(SpacingHelper:GetPadding(theme, scale, badgeTheme.spacing) / 2)
	local content = (React.createElement(React.Fragment, nil, React.createElement(Padding, {
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
		color = iconColor,
	}), React.createElement(Text, {
		name = "BadgeText",
		LayoutOrder = 2,
		text = props.text,
		TextWrap = false,
		typography = TypographyHelper:getTypography(theme, scale, badgeTheme.typography),
		TextColor3 = textColor,
	}))))
	local _attributes = {}
	local _condition_5 = props.name
	if _condition_5 == nil then
		_condition_5 = "Badge"
	end
	_attributes.key = _condition_5
	_attributes.ref = ref
	_attributes.Active = false
	_attributes.Selectable = false
	_attributes.Size = UDim2.fromOffset(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.Position = props.Position
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.BackgroundColor3 = backgroundColor
	local _result_6 = stateStyle
	if _result_6 ~= nil then
		_result_6 = _result_6.backgroundTransparency
	end
	local _condition_6 = _result_6
	if _condition_6 == nil then
		_condition_6 = props.BackgroundTransparency
		if _condition_6 == nil then
			_condition_6 = intentColors.backgroundTransparency
			if _condition_6 == nil then
				_condition_6 = 0
			end
		end
	end
	_attributes.BackgroundTransparency = _condition_6
	_attributes.BorderSizePixel = 0
	local _condition_7 = backgroundImage.Image
	if _condition_7 == nil then
		_condition_7 = ""
	end
	_attributes.Image = _condition_7
	_attributes.ImageColor3 = backgroundImage.ImageColor3
	_attributes.ImageTransparency = backgroundImage.ImageTransparency
	_attributes.ScaleType = backgroundImage.ScaleType
	_attributes.SliceCenter = backgroundImage.SliceCenter
	_attributes.SliceScale = backgroundImage.SliceScale
	_attributes.TileSize = backgroundImage.TileSize
	return React.createElement("imagelabel", _attributes, React.createElement(Corners, {
		radius = badgeTheme.cornerRadius,
	}), borderThickness > 0 and (React.createElement("uistroke", {
		key = "Stroke",
		Thickness = borderThickness,
		BorderStrokePosition = if props.borderPosition == "outer" then Enum.BorderStrokePosition.Outer else Enum.BorderStrokePosition.Inner,
		Color = borderColor,
		Transparency = props.borderTransparency,
	})), React.createElement(Gradient, {
		value = intentColors.backgroundGradient,
	}), if clickable then (React.createElement("imagebutton", {
		key = "BadgeButton",
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Image = "",
		Event = {
			MouseEnter = function()
				return setHover(true)
			end,
			MouseLeave = function()
				setHover(false)
				setPressed(false)
			end,
			SelectionGained = function()
				return setHover(true)
			end,
			SelectionLost = function()
				setHover(false)
				setPressed(false)
			end,
			MouseButton1Down = function()
				return setPressed(true)
			end,
			MouseButton1Up = function()
				return setPressed(false)
			end,
			Activated = function()
				setPressed(false)
				local _result_7 = props.onClick
				if _result_7 ~= nil then
					_result_7()
				end
			end,
		},
	}, content)) else content)
end)
return {
	Badge = Badge,
}
