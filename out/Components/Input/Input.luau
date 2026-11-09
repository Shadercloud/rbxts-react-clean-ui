-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useRef = _react.useRef
local useState = _react.useState
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local CssHelper = _Helpers.CssHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local Padding = _Decorator.Padding
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local FieldsetContext = _Layout.FieldsetContext
local FlexItem = _Layout.FlexItem
local HStack = _Layout.HStack
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local _Input_field = TS.import(script, script.Parent, "Input.field")
local FieldBoxShadow = _Input_field.FieldBoxShadow
local FieldInnerShadow = _Input_field.FieldInnerShadow
local resolveFieldState = _Input_field.resolveFieldState
local resolveFieldStateStyle = _Input_field.resolveFieldStateStyle
local _Input_validation = TS.import(script, script.Parent, "Input.validation")
local resolveClampedText = _Input_validation.resolveClampedText
local resolveValidatedText = _Input_validation.resolveValidatedText
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
	local focused, setFocused = useState(false)
	local hovered, setHovered = useState(false)
	local lastValidText = useRef(props.value)
	local inputTheme = theme.components.input
	local stateStyle = resolveFieldStateStyle(inputTheme.states, resolveFieldState(props.disabled, focused, hovered))
	local _condition = stateStyle.borderThickness
	if _condition == nil then
		_condition = inputTheme.borderThickness
	end
	local borderThickness = _condition
	local typography = TypographyHelper:getTypography(theme, props.scale, theme.components.input.typography)
	local placeholderTypography = TypographyHelper:getTypography(theme, props.scale, theme.components.input.placeholder)
	local backgroundImage = CssHelper:resolveBackgroundImage(theme.components.input.backgroundImage)
	React.useEffect(function()
		if not labelActivated then
			return nil
		end
		local connection = labelActivated.Event:Connect(function()
			if props.disabled then
				return nil
			end
			local _result = ref.current
			if _result ~= nil then
				_result:CaptureFocus()
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, { labelActivated, ref, props.disabled })
	React.useEffect(function()
		if props.disabled then
			local _result = ref.current
			if _result ~= nil then
				_result:ReleaseFocus()
			end
		end
	end, { props.disabled })
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	local _exp = React.createElement(Padding, _attributes)
	local _exp_1 = props.icon ~= nil and (React.createElement(Icon, {
		name = "InputIcon",
		icon = props.icon,
		color = theme.components.input.iconColor,
	}))
	local _attributes_1 = {
		key = "TextBox",
		ref = ref,
		Size = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left,
		FontFace = TypographyHelper:toFontFace(typography.font, typography.weight or Enum.FontWeight.Regular),
		FontSize = typography.size,
	}
	local _condition_1 = props.PlaceholderText
	if _condition_1 == nil then
		_condition_1 = props.placeholder
	end
	_attributes_1.PlaceholderText = _condition_1
	_attributes_1.PlaceholderColor3 = props.PlaceholderColor3 or placeholderTypography.color
	_attributes_1.TextScaled = props.TextScaled
	_attributes_1.LineHeight = typography.lineHeight
	_attributes_1.Text = if props.controlled then props.value else value
	_attributes_1.TextColor3 = props.TextColor3 or typography.color or theme.colors.intents.primary.default.textColor
	local _condition_2 = props.TextTransparency
	if _condition_2 == nil then
		_condition_2 = typography.transparency
	end
	_attributes_1.TextTransparency = _condition_2
	_attributes_1.Active = props.Active
	_attributes_1.Archivable = props.Archivable
	_attributes_1.BorderColor3 = props.BorderColor3
	_attributes_1.BorderMode = props.BorderMode
	_attributes_1.BorderSizePixel = if props.BorderSizePixel == nil then 0 else props.BorderSizePixel
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
	local _condition_3 = props.ClearTextOnFocus
	if _condition_3 == nil then
		_condition_3 = false
	end
	_attributes_1.ClearTextOnFocus = _condition_3
	_attributes_1.CursorPosition = props.CursorPosition
	_attributes_1.MultiLine = props.MultiLine
	_attributes_1.SelectionStart = props.SelectionStart
	_attributes_1.ShowNativeInput = props.ShowNativeInput
	_attributes_1.TextEditable = if props.disabled then false else props.TextEditable
	_attributes_1.Interactable = if props.disabled then false else nil
	_attributes_1.TextTruncate = props.TextTruncate
	_attributes_1.RichText = props.RichText
	local _object = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	_object.Focused = function(rbx)
		setFocused(true)
		local _result = props.Event
		if _result ~= nil then
			_result = _result.Focused
			if _result ~= nil then
				_result(rbx)
			end
		end
	end
	_object.FocusLost = function(rbx, enterPressed, inputThatCausedFocusLoss)
		setFocused(false)
		local clampedText = resolveClampedText(props.validation, rbx.Text, props.min, props.max)
		if clampedText ~= nil then
			ref.current.Text = clampedText
			lastValidText.current = clampedText
			setValue(clampedText)
			local _result = props.onChange
			if _result ~= nil then
				_result(clampedText)
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
	local content = (React.createElement(React.Fragment, nil, _exp, React.createElement(HStack, {
		valign = "Center",
		Wraps = false,
	}, _exp_1, React.createElement(FlexItem, nil, React.createElement("textbox", _attributes_1)))))
	local _attributes_2 = {}
	local _condition_4 = props.name
	if _condition_4 == nil then
		_condition_4 = "Input"
	end
	_attributes_2.key = _condition_4
	_attributes_2.Size = props.Size or UDim2.fromScale(1, 0)
	_attributes_2.AutomaticSize = Enum.AutomaticSize.Y
	_attributes_2.BackgroundColor3 = stateStyle.backgroundColor or inputTheme.backgroundColor
	local _condition_5 = stateStyle.backgroundTransparency
	if _condition_5 == nil then
		_condition_5 = inputTheme.backgroundTransparency
		if _condition_5 == nil then
			_condition_5 = 1
		end
	end
	_attributes_2.BackgroundTransparency = _condition_5
	_attributes_2.AnchorPoint = props.AnchorPoint
	_attributes_2.Position = props.Position
	_attributes_2.LayoutOrder = props.LayoutOrder
	_attributes_2.Visible = props.Visible
	_attributes_2.ZIndex = props.ZIndex
	_attributes_2.BorderSizePixel = 0
	_attributes_2.Image = backgroundImage.Image
	_attributes_2.ImageColor3 = backgroundImage.ImageColor3
	_attributes_2.ImageTransparency = backgroundImage.ImageTransparency
	_attributes_2.ScaleType = backgroundImage.ScaleType
	_attributes_2.SliceCenter = backgroundImage.SliceCenter
	_attributes_2.SliceScale = backgroundImage.SliceScale
	_attributes_2.TileSize = backgroundImage.TileSize
	_attributes_2.Event = {
		MouseEnter = function()
			return setHovered(true)
		end,
		MouseLeave = function()
			return setHovered(false)
		end,
	}
	return React.createElement("imagelabel", _attributes_2, React.createElement("uistroke", {
		key = "Stroke",
		Thickness = borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = stateStyle.borderColor or inputTheme.borderColor,
	}), React.createElement(Corners, {
		radius = inputTheme.cornerRadius,
	}), React.createElement(Gradient, {
		value = stateStyle.backgroundGradient or inputTheme.backgroundGradient,
	}), React.createElement(FieldBoxShadow, {
		value = inputTheme.boxShadow,
	}), if inputTheme.innerShadow == nil then content else (React.createElement(React.Fragment, nil, React.createElement(FieldInnerShadow, {
		value = inputTheme.innerShadow,
		cornerRadius = inputTheme.cornerRadius,
		inset = borderThickness,
	}), React.createElement("frame", {
		key = "Content",
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, content))))
end
return {
	Input = Input,
}
