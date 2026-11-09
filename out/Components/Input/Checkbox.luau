-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local FieldsetContext = _Layout.FieldsetContext
local HStack = _Layout.HStack
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local Padding = _Decorator.Padding
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local function Checkbox(props)
	local theme = React.useContext(CleanThemeContext)
	local fieldset = React.useContext(FieldsetContext)
	local controlled = props.checked ~= nil
	local _condition = props.defaultChecked
	if _condition == nil then
		_condition = false
	end
	local internalChecked, setInternalChecked = React.useState(_condition)
	local checked = if controlled then props.checked == true else internalChecked
	local requestChange = function(value)
		if not controlled then
			setInternalChecked(value)
		end
		local _result = props.onChange
		if _result ~= nil then
			_result(value)
		end
	end
	local toggleRef = React.useRef()
	toggleRef.current = function()
		return requestChange(not checked)
	end
	React.useEffect(function()
		if not fieldset then
			return nil
		end
		local _connection = fieldset.labelActivated
		if _connection ~= nil then
			_connection = _connection.Event:Connect(function()
				local _result = toggleRef.current
				if _result ~= nil then
					_result()
				end
			end)
		end
		local connection = _connection
		return function()
			local _result = connection
			if _result ~= nil then
				_result:Disconnect()
			end
		end
	end, { fieldset })
	local backgroundImage = CssHelper:resolveBackgroundImage(theme.components.checkbox.backgroundImage)
	local _attributes = {}
	local _result
	if props.label ~= nil then
		_result = "CheckboxBox"
	else
		local _condition_1 = props.name
		if _condition_1 == nil then
			_condition_1 = "Checkbox"
		end
		_result = _condition_1
	end
	_attributes.key = _result
	_attributes.Size = UDim2.fromOffset(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.LayoutOrder = if props.label ~= nil then 1 else nil
	_attributes.Event = {
		Activated = function()
			requestChange(not checked)
		end,
	}
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = theme.components.button.backgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BackgroundColor3 = ColorHelper:getIntentColors(theme, props.intent, "default", theme.components.checkbox.intents).backgroundColor
	_attributes.AutoButtonColor = false
	_attributes.BorderSizePixel = 0
	_attributes.Image = backgroundImage.Image
	_attributes.ImageColor3 = backgroundImage.ImageColor3
	_attributes.ImageTransparency = backgroundImage.ImageTransparency
	_attributes.ScaleType = backgroundImage.ScaleType
	_attributes.SliceCenter = backgroundImage.SliceCenter
	_attributes.SliceScale = backgroundImage.SliceScale
	_attributes.TileSize = backgroundImage.TileSize
	local _exp = React.createElement(Corners, {
		radius = theme.components.checkbox.cornerRadius,
	})
	local _exp_1 = React.createElement(Gradient, {
		value = theme.components.checkbox.backgroundGradient,
	})
	local _attributes_1 = {
		key = "Stroke",
		Thickness = theme.components.checkbox.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
	}
	local _condition_2 = theme.components.checkbox.borderTransparency
	if _condition_2 == nil then
		_condition_2 = 0
	end
	_attributes_1.Transparency = _condition_2
	_attributes_1.Color = ColorHelper:getIntentColors(theme, if checked then props["intent-checked"] or "success" else props["intent-unchecked"] or "primary", "default", theme.components.checkbox.intents).borderColor
	local box = React.createElement("imagebutton", _attributes, _exp, _exp_1, React.createElement("uistroke", _attributes_1), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.checkbox.spacing, theme.components.checkbox.padding),
	}), React.createElement(Icon, {
		name = "CheckboxIcon",
		scale = props.scale,
		icon = if checked then props["icon-checked"] or "check" else props["icon-unchecked"],
		color = ColorHelper:getIntentColors(theme, if checked then props["intent-checked"] or "success" else props["intent-unchecked"] or "primary", "default", theme.components.checkbox.intents).textColor,
	}))
	if props.label == nil then
		return box
	end
	local labelTheme = theme.components.checkbox.label
	local _attributes_2 = {}
	local _condition_3 = props.name
	if _condition_3 == nil then
		_condition_3 = "Checkbox"
	end
	_attributes_2.key = _condition_3
	_attributes_2.Size = UDim2.fromOffset(0, 0)
	_attributes_2.AutomaticSize = Enum.AutomaticSize.XY
	_attributes_2.BackgroundTransparency = 1
	_attributes_2.BorderSizePixel = 0
	local _attributes_3 = {
		valign = "Center",
		Wraps = false,
	}
	local _result_1 = labelTheme
	if _result_1 ~= nil then
		_result_1 = _result_1.gap
	end
	local _condition_4 = _result_1
	if _condition_4 == nil then
		_condition_4 = math.ceil(SpacingHelper:GetPadding(theme, props.scale, theme.components.checkbox.spacing) / 2)
	end
	_attributes_3.Padding = UDim.new(0, _condition_4)
	local _exp_2 = React.createElement(HStack, _attributes_3)
	local _exp_3 = box
	local _attributes_4 = {
		name = "CheckboxLabelText",
		text = props.label,
		TextWrap = false,
	}
	local _exp_4 = props.scale
	local _result_2 = labelTheme
	if _result_2 ~= nil then
		_result_2 = _result_2.typography
	end
	_attributes_4.typography = TypographyHelper:getTypography(theme, _exp_4, _result_2)
	local _result_3 = labelTheme
	if _result_3 ~= nil then
		_result_3 = _result_3.textColor
	end
	_attributes_4.TextColor3 = _result_3
	return React.createElement("frame", _attributes_2, _exp_2, _exp_3, React.createElement("imagebutton", {
		key = "CheckboxLabel",
		LayoutOrder = 2,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Selectable = false,
		Event = {
			Activated = function()
				requestChange(not checked)
			end,
		},
	}, React.createElement(Text, _attributes_4)))
end
return {
	Checkbox = Checkbox,
}
