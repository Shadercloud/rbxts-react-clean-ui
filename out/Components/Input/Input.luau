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
local resolveValidatedText = TS.import(script, script.Parent, "Input.validation").resolveValidatedText
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
	local lastValidText = useRef(props.value)
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
	_attributes_1.Text = if props.controlled then props.value else value
	_attributes_1.TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor
	_attributes_1.Active = props.Active
	_attributes_1.Archivable = props.Archivable
	_attributes_1.BorderColor3 = props.BorderColor3
	_attributes_1.BorderMode = props.BorderMode
	_attributes_1.BorderSizePixel = props.BorderSizePixel
	_attributes_1.ClipsDescendants = props.ClipsDescendants
	_attributes_1.Rotation = props.Rotation
	_attributes_1.Selectable = props.Selectable
	_attributes_1.SelectionImageObject = props.SelectionImageObject
	_attributes_1.SizeConstraint = props.SizeConstraint
	_attributes_1.Tag = props.Tag
	_attributes_1.AutoLocalize = props.AutoLocalize
	_attributes_1.RootLocalizationTable = props.RootLocalizationTable
	_attributes_1.NextSelectionDown = props.NextSelectionDown
	_attributes_1.NextSelectionLeft = props.NextSelectionLeft
	_attributes_1.NextSelectionRight = props.NextSelectionRight
	_attributes_1.NextSelectionUp = props.NextSelectionUp
	_attributes_1.SelectionGroup = props.SelectionGroup
	_attributes_1.SelectionOrder = props.SelectionOrder
	local _condition_1 = props.ClearTextOnFocus
	if _condition_1 == nil then
		_condition_1 = false
	end
	_attributes_1.ClearTextOnFocus = _condition_1
	_attributes_1.CursorPosition = props.CursorPosition
	_attributes_1.MultiLine = props.MultiLine
	_attributes_1.SelectionStart = props.SelectionStart
	_attributes_1.ShowNativeInput = props.ShowNativeInput
	_attributes_1.TextEditable = props.TextEditable
	_attributes_1.TextTruncate = props.TextTruncate
	_attributes_1.RichText = props.RichText
	local _object = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	_object.FocusLost = function(rbx, enterPressed, inputThatCausedFocusLoss)
		if props.validation == "Number" or props.validation == "Int" then
			local number = tonumber(rbx.Text)
			if number ~= nil then
				local clamped = number
				if props.min ~= nil and clamped < props.min then
					clamped = props.min
				end
				if props.max ~= nil and clamped > props.max then
					clamped = props.max
				end
				if clamped ~= number then
					local clampedText = tostring(clamped)
					ref.current.Text = clampedText
					lastValidText.current = clampedText
					setValue(clampedText)
					local _result = props.onChange
					if _result ~= nil then
						_result(clampedText)
					end
				end
			end
		end
		local _result = props.Event
		if _result ~= nil then
			_result = _result.FocusLost
			if _result ~= nil then
				_result(rbx, enterPressed, inputThatCausedFocusLoss)
			end
		end
	end
	_attributes_1.Event = _object
	local _object_1 = {}
	local _spread_1 = props.Change
	if _spread_1 then
		for _k, _v in _spread_1 do
			_object_1[_k] = _v
		end
	end
	_object_1.Text = function(rbx)
		local resolved = resolveValidatedText(props.validation, rbx.Text, lastValidText.current)
		if resolved ~= rbx.Text then
			ref.current.Text = resolved
			return nil
		end
		lastValidText.current = rbx.Text
		setValue(rbx.Text)
		local _result = props.onChange
		if _result ~= nil then
			_result(rbx.Text)
		end
		local _result_1 = props.Change
		if _result_1 ~= nil then
			_result_1 = _result_1.Text
			if _result_1 ~= nil then
				_result_1(rbx)
			end
		end
	end
	_attributes_1.Change = _object_1
	return React.createElement("frame", {
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		Visible = props.Visible,
		ZIndex = props.ZIndex,
	}, _exp, _exp_1, _exp_2, React.createElement("textbox", _attributes_1))
end
return {
	Input = Input,
}
