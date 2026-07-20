-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _ = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _.CleanThemeContext
local useGroupElement = _.useGroupElement
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local GroupMeasurement = _Layout.GroupMeasurement
local HStack = _Layout.HStack
local function Button(props)
	local theme = React.useContext(CleanThemeContext)
	local hover, setHover = React.useState(false)
	local group = useGroupElement(props.group)
	local padding = SpacingHelper:GetResolvedPadding(theme, props)
	local _attributes = {}
	local _object = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	_object.MouseEnter = function(button, x, y)
		setHover(true)
		local _result = props.Event
		if _result ~= nil then
			_result = _result.MouseEnter
			if _result ~= nil then
				_result(button, x, y)
			end
		end
	end
	_object.MouseLeave = function(button, x, y)
		setHover(false)
		local _result = props.Event
		if _result ~= nil then
			_result = _result.MouseLeave
			if _result ~= nil then
				_result(button, x, y)
			end
		end
	end
	_attributes.Event = _object
	local _result = group
	if _result ~= nil then
		_result = _result.groupSize
		if _result ~= nil then
			_result = _result.X
		end
	end
	local _condition = _result
	if _condition == nil then
		_condition = 0
	end
	_attributes.Size = UDim2.fromOffset(_condition, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = theme.components.button.backgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BackgroundColor3 = ColorHelper:getIntentColor(theme, props.intent, if hover then "hover" else "background", theme.components.button.intents, props.BackgroundColor3)
	_attributes.AutoButtonColor = false
	_attributes.ZIndex = props.ZIndex
	local _exp = React.createElement(Corners, {
		radius = theme.components.button.cornerRadius,
	})
	local _exp_1 = React.createElement("uistroke", {
		Thickness = theme.components.button.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = ColorHelper:getIntentColor(theme, props.intent, "border", theme.components.button.intents),
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	_attributes_1.value = theme.components.button.boxShadow
	local _exp_2 = React.createElement(BoxShadow, _attributes_1)
	local _attributes_2 = table.clone(props)
	setmetatable(_attributes_2, nil)
	return React.createElement("imagebutton", _attributes, _exp, _exp_1, _exp_2, React.createElement(Padding, _attributes_2), React.createElement(GroupMeasurement, {
		enabled = props.group,
		group = group,
		padding = padding,
	}, (props.icon ~= nil or props.text ~= nil) and React.createElement(HStack, {
		valign = "Center",
		spacing = props.spacing,
	}, props.icon ~= nil and React.createElement(Icon, {
		scale = props.scale,
		icon = props.icon,
		color = ColorHelper:getIntentColor(theme, props.intent, "text", theme.components.button.intents, nil, theme.components.button.textColor),
	}), props.text ~= nil and React.createElement(Text, {
		text = props.text,
		typography = TypographyHelper:getTypography(theme, props.scale, theme.components.button.typography),
		TextColor3 = ColorHelper:getIntentColor(theme, props.intent, "text", theme.components.button.intents, nil, theme.components.button.textColor),
	})), props.children))
end
return {
	Button = Button,
}
