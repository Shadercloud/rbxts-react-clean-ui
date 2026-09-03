-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local Padding = _Decorator.Padding
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local HStack = TS.import(script, script.Parent.Parent, "Layout").HStack
local _ = TS.import(script, script.Parent.Parent, "Layout")
local Group = _.Group
local GroupContext = _.GroupContext
local function ButtonText(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {
		name = "ButtonText",
		text = props.text,
	}
	local _exp = props.scale
	local _object = {}
	local _spread = theme.components.button.typography
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	local _result = props.styleOverride
	if _result ~= nil then
		_result = _result.typography
	end
	if _result then
		for _k, _v in _result do
			_object[_k] = _v
		end
	end
	_attributes.typography = TypographyHelper:getTypography(theme, _exp, _object)
	local _exp_1 = props.intent
	local _exp_2 = if props.disabled then "disabled" else "default"
	local _exp_3 = theme.components.button.intents
	local _result_1 = props.styleOverride
	if _result_1 ~= nil then
		_result_1 = _result_1.intents
	end
	_attributes.TextColor3 = ColorHelper:getIntentColors(theme, _exp_1, _exp_2, _exp_3, _result_1).textColor
	return React.createElement(Text, _attributes)
end
local function ButtonIcon(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "ButtonIcon"
	end
	_attributes.name = _condition
	_attributes.scale = props.scale
	_attributes.icon = props.icon
	_attributes.spinning = props.spinning
	_attributes.speed = props.speed
	local _exp = props.intent
	local _exp_1 = if props.disabled then "disabled" else "default"
	local _exp_2 = theme.components.button.intents
	local _result = props.styleOverride
	if _result ~= nil then
		_result = _result.intents
	end
	_attributes.color = ColorHelper:getIntentColors(theme, _exp, _exp_1, _exp_2, _result).textColor
	return React.createElement(Icon, _attributes)
end
local Button = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local hover, setHover = React.useState(false)
	React.useEffect(function()
		if props.disabled then
			setHover(false)
		end
	end, { props.disabled })
	local group = React.useContext(GroupContext)
	local padding = SpacingHelper:GetResolvedPadding(theme, props)
	local state = if props.disabled then "disabled" elseif hover then "hover" else "default"
	local _exp = props.intent
	local _exp_1 = theme.components.button.intents
	local _result = props.styleOverride
	if _result ~= nil then
		_result = _result.intents
	end
	local intentColors = ColorHelper:getIntentColors(theme, _exp, state, _exp_1, _result)
	local backgroundImage = CssHelper:resolveBackgroundImage(intentColors.backgroundImage)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Button"
	end
	_attributes.key = _condition
	_attributes.ref = ref
	_attributes.Active = not props.disabled
	local _object = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	_object.MouseEnter = function(button, x, y)
		if not props.disabled then
			setHover(true)
		end
		local _result_1 = props.Event
		if _result_1 ~= nil then
			_result_1 = _result_1.MouseEnter
			if _result_1 ~= nil then
				_result_1(button, x, y)
			end
		end
	end
	_object.MouseLeave = function(button, x, y)
		if not props.disabled then
			setHover(false)
		end
		local _result_1 = props.Event
		if _result_1 ~= nil then
			_result_1 = _result_1.MouseLeave
			if _result_1 ~= nil then
				_result_1(button, x, y)
			end
		end
	end
	_object.Activated = function(button, inputObject, clickCount)
		if props.disabled then
			return nil
		end
		local _result_1 = props.Event
		if _result_1 ~= nil then
			_result_1 = _result_1.Activated
			if _result_1 ~= nil then
				_result_1(button, inputObject, clickCount)
			end
		end
	end
	_attributes.Event = _object
	local _result_1
	if props.group then
		local _result_2 = group
		if _result_2 ~= nil then
			_result_2 = _result_2.size
			if _result_2 ~= nil then
				_result_2 = _result_2.X
			end
		end
		local _condition_1 = _result_2
		if _condition_1 == nil then
			_condition_1 = 0
		end
		_result_1 = _condition_1
	else
		_result_1 = 0
	end
	_attributes.Size = UDim2.fromOffset(_result_1, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		local _result_2 = props.styleOverride
		if _result_2 ~= nil then
			_result_2 = _result_2.backgroundTransparency
		end
		_condition_1 = _result_2
		if _condition_1 == nil then
			_condition_1 = theme.components.button.backgroundTransparency
		end
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BackgroundColor3 = intentColors.backgroundColor
	_attributes.AutoButtonColor = false
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.ZIndex = props.ZIndex
	_attributes.Image = backgroundImage.Image
	_attributes.ImageColor3 = backgroundImage.ImageColor3
	_attributes.ImageTransparency = backgroundImage.ImageTransparency
	_attributes.ScaleType = backgroundImage.ScaleType
	_attributes.SliceCenter = backgroundImage.SliceCenter
	_attributes.SliceScale = backgroundImage.SliceScale
	_attributes.TileSize = backgroundImage.TileSize
	local _attributes_1 = {}
	local _result_2 = props.styleOverride
	if _result_2 ~= nil then
		_result_2 = _result_2.cornerRadius
	end
	local _condition_2 = _result_2
	if _condition_2 == nil then
		_condition_2 = theme.components.button.cornerRadius
	end
	_attributes_1.radius = _condition_2
	local _exp_2 = React.createElement(Corners, _attributes_1)
	local _attributes_2 = {
		key = "Stroke",
	}
	local _result_3 = props.styleOverride
	if _result_3 ~= nil then
		_result_3 = _result_3.borderThickness
	end
	local _condition_3 = _result_3
	if _condition_3 == nil then
		_condition_3 = theme.components.button.borderThickness
	end
	_attributes_2.Thickness = _condition_3
	_attributes_2.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	_attributes_2.Color = intentColors.borderColor
	local _exp_3 = React.createElement("uistroke", _attributes_2)
	local _attributes_3 = table.clone(props)
	setmetatable(_attributes_3, nil)
	local _result_4 = props.styleOverride
	if _result_4 ~= nil then
		_result_4 = _result_4.boxShadow
	end
	local _condition_4 = _result_4
	if _condition_4 == nil then
		_condition_4 = theme.components.button.boxShadow
	end
	_attributes_3.value = _condition_4
	local _exp_4 = React.createElement(BoxShadow, _attributes_3)
	local _exp_5 = React.createElement(Gradient, {
		value = intentColors.backgroundGradient,
	})
	local _attributes_4 = table.clone(props)
	setmetatable(_attributes_4, nil)
	return React.createElement("imagebutton", _attributes, _exp_2, _exp_3, _exp_4, _exp_5, React.createElement(Padding, _attributes_4), React.createElement(Group.Element, {
		enabled = props.group,
		padding = padding,
	}, (props.icon ~= nil or props.text ~= nil) and React.createElement(HStack, {
		valign = "Center",
		spacing = props.spacing,
		Wraps = false,
	}, props.icon ~= nil and React.createElement(ButtonIcon, {
		scale = props.scale,
		intent = props.intent,
		disabled = props.disabled,
		icon = props.icon,
		styleOverride = props.styleOverride,
	}), props.text ~= nil and React.createElement(ButtonText, {
		text = props.text,
		intent = props.intent,
		disabled = props.disabled,
		scale = props.scale,
		styleOverride = props.styleOverride,
	})), props.children))
end)
Button.Text = ButtonText
Button.Icon = ButtonIcon
return {
	Button = Button,
}
