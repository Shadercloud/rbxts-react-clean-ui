-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useRef = _react.useRef
local useState = _react.useState
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local TypographyHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local FieldsetContext = TS.import(script, script.Parent.Parent, "Layout").FieldsetContext
local function Input(props)
	local theme = React.useContext(CleanThemeContext)
	local fieldset = React.useContext(FieldsetContext)
	local _labelActivated = fieldset
	if _labelActivated ~= nil then
		_labelActivated = _labelActivated.labelActivated
	end
	local labelActivated = _labelActivated
	local ref = useRef()
	local value, setValue = useState(props.value)
	local typography = TypographyHelper:getTypography(theme, props.scale, theme.components.input.typography)
	React.useEffect(function()
		if not labelActivated then
			return nil
		end
		local connection = labelActivated.Event:Connect(function()
			local _result = ref.current
			if _result ~= nil then
				_result:CaptureFocus()
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, { labelActivated, ref })
	local _exp = React.createElement("uistroke", {
		Thickness = theme.components.input.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.input.borderColor,
	})
	local _exp_1 = React.createElement(Corners, {
		radius = theme.components.input.cornerRadius,
	})
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	local _exp_2 = React.createElement(Padding, _attributes)
	local _attributes_1 = {
		ref = ref,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
		FontFace = Font.fromName(typography.font.Name, typography.weight or Enum.FontWeight.Regular),
		FontSize = typography.size,
	}
	local _condition = props.PlaceholderText
	if _condition == nil then
		_condition = props.placeholder
	end
	_attributes_1.PlaceholderText = _condition
	_attributes_1.PlaceholderColor3 = props.PlaceholderColor3
	_attributes_1.TextScaled = props.TextScaled
	_attributes_1.LineHeight = typography.lineHeight
	_attributes_1.Text = value
	_attributes_1.TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor
	_attributes_1.ClearTextOnFocus = false
	_attributes_1.Event = props.Event
	_attributes_1.Change = {
		Text = function(rbx)
			if props.validation == "Number" or props.validation == "Int" then
				if not ref.current then
					return nil
				end
				local _value = tonumber(rbx.Text)
				local _condition_1 = not (_value ~= 0 and _value == _value and _value)
				if _condition_1 then
					_condition_1 = rbx.Text ~= "" and rbx.Text ~= "-"
				end
				if _condition_1 then
					ref.current.Text = props.value
					return nil
				end
				if props.validation == "Int" and rbx.Text ~= "" and rbx.Text ~= "-" then
					local _condition_2 = tonumber(rbx.Text)
					if _condition_2 == nil then
						_condition_2 = 0
					end
					if math.round(_condition_2) ~= tonumber(rbx.Text) then
						return nil
					end
				end
			end
			setValue(rbx.Text)
			local _result = props.onChange
			if _result ~= nil then
				_result(rbx.Text)
			end
		end,
	}
	return React.createElement("frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, _exp, _exp_1, _exp_2, React.createElement("textbox", _attributes_1))
end
return {
	Input = Input,
}
