-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local FieldsetContext = TS.import(script, script.Parent.Parent, "Layout").FieldsetContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SpacingHelper = _Helpers.SpacingHelper
local function Checkbox(props)
	local theme = React.useContext(CleanThemeContext)
	local fieldset = React.useContext(FieldsetContext)
	local checked, setChecked = React.useState(false)
	React.useEffect(function()
		if not fieldset then
			return nil
		end
		local _connection = fieldset.labelActivated
		if _connection ~= nil then
			_connection = _connection.Event:Connect(function()
				setChecked(function(current)
					return not current
				end)
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
	React.useEffect(function()
		local _result = props.onChange
		if _result ~= nil then
			_result(checked)
		end
	end, { checked })
	local _attributes = {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Event = {
			Activated = function()
				setChecked(not checked)
			end,
		},
	}
	local _condition = props.BackgroundTransparency
	if _condition == nil then
		_condition = theme.components.button.backgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BackgroundColor3 = ColorHelper:getIntentColor(theme, props.intent, "background", theme.components.button.intents, props.BackgroundColor3)
	_attributes.AutoButtonColor = false
	return React.createElement("imagebutton", _attributes, React.createElement(Corners, {
		radius = theme.components.checkbox.cornerRadius,
	}), React.createElement("uistroke", {
		Thickness = theme.components.button.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = ColorHelper:getIntentColor(theme, if checked then props["intent-checked"] or "success" else props["intent-unchecked"] or "primary", "border", theme.components.checkbox.intents),
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.checkbox.spacing),
	}), React.createElement(Icon, {
		scale = props.scale,
		icon = if checked then props["icon-checked"] or "check" else props["icon-unchecked"],
		color = ColorHelper:getIntentColor(theme, if checked then props["intent-checked"] or "success" else props["intent-unchecked"] or "primary", "text", theme.components.checkbox.intents, props.BackgroundColor3),
	}))
end
return {
	Checkbox = Checkbox,
}
