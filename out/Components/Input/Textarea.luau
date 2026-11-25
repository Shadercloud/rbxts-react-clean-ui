-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useRef = _react.useRef
local useState = _react.useState
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local RunService = _services.RunService
local TextService = _services.TextService
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local useUiScale = _Contexts.useUiScale
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local CssHelper = _Helpers.CssHelper
local CustomInputService = _Helpers.CustomInputService
local ElementHelper = _Helpers.ElementHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local FieldsetContext = _Layout.FieldsetContext
local Scroller = _Layout.Scroller
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local PreferredTextSizePin = TS.import(script, script.Parent.Parent, "Typography", "PinTextSize.preferred").PreferredTextSizePin
local _Input_field = TS.import(script, script.Parent, "Input.field")
local FieldBoxShadow = _Input_field.FieldBoxShadow
local FieldInnerShadow = _Input_field.FieldInnerShadow
local resolveFieldState = _Input_field.resolveFieldState
local resolveFieldStateStyle = _Input_field.resolveFieldStateStyle
local _Textarea_layout = TS.import(script, script.Parent, "Textarea.layout")
local TEXTAREA_DEFAULT_ROWS = _Textarea_layout.TEXTAREA_DEFAULT_ROWS
local formatTextareaCount = _Textarea_layout.formatTextareaCount
local resolveTextareaCanvasHeight = _Textarea_layout.resolveTextareaCanvasHeight
local resolveTextareaCaretScroll = _Textarea_layout.resolveTextareaCaretScroll
local resolveTextareaCaretLineText = _Textarea_layout.resolveTextareaCaretLineText
local resolveTextareaHeight = _Textarea_layout.resolveTextareaHeight
local resolveTextareaLength = _Textarea_layout.resolveTextareaLength
local resolveTextareaScreenScale = _Textarea_layout.resolveTextareaScreenScale
local resolveTextareaWholePixels = _Textarea_layout.resolveTextareaWholePixels
local resolveTextareaWrapWidth = _Textarea_layout.resolveTextareaWrapWidth
local trimTextareaText = _Textarea_layout.trimTextareaText
local GAMEPAD_SCROLL_SPEED = 480
local GAMEPAD_DEADZONE = 0.2
local DEFAULT_SCROLLBAR_THICKNESS = 12
local MEASURE_HEIGHT = 100000
local FALLBACK_LINE_SLACK = 1.17
local FALLBACK_FRAMES = 3
local Textarea = React.forwardRef(function(props, forwardedRef)
	local theme = React.useContext(CleanThemeContext)
	local fieldset = React.useContext(FieldsetContext)
	local uiScale = useUiScale()
	local _labelActivated = fieldset
	if _labelActivated ~= nil then
		_labelActivated = _labelActivated.labelActivated
	end
	local labelActivated = _labelActivated
	local ref = useRef()
	local fieldRef = useRef()
	local scrollerRef = useRef()
	local probeRef = useRef()
	local lineProbeRef = useRef()
	local measureRef = useRef()
	local followRequested = useRef(false)
	local lastWrittenY = useRef()
	local neverMeasures = useRef(false)
	local pendingFallback = useRef()
	local pendingNudge = useRef()
	local nudgedSource = useRef()
	local value, setValue = useState(props.value)
	local focused, setFocused = useState(false)
	local hovered, setHovered = useState(false)
	local textHeight, setTextHeight = useState(0)
	local estimated, setEstimated = useState(false)
	local screenFieldSize, setScreenFieldSize = useState(Vector2.zero)
	local screenTextBoxWidth, setScreenTextBoxWidth = useState(0)
	local focusedRef = useRef(false)
	local heldText = useRef()
	local reportedTexts = useRef({})
	local sourceText = if props.controlled then props.value else value
	local _condition = heldText.current
	if _condition == nil then
		_condition = sourceText
	end
	local displayText = _condition
	local inputTheme = theme.components.input
	local textareaTheme = theme.components.textarea
	local stateStyle = resolveFieldStateStyle(inputTheme.states, resolveFieldState(props.disabled, focused, hovered))
	local _condition_1 = stateStyle.borderThickness
	if _condition_1 == nil then
		_condition_1 = inputTheme.borderThickness
	end
	local borderThickness = _condition_1
	local typography = TypographyHelper:getTypography(theme, props.scale, inputTheme.typography)
	local placeholderTypography = TypographyHelper:getTypography(theme, props.scale, inputTheme.placeholder)
	local _exp = props.scale
	local _result = textareaTheme
	if _result ~= nil then
		_result = _result.counter
	end
	local counterTypography = TypographyHelper:getTypography(theme, _exp, _result)
	local fontFace = TypographyHelper:toFontFace(typography.font, typography.weight or Enum.FontWeight.Regular)
	local _condition_2 = TypographyHelper:toTextSize(typography.size)
	if _condition_2 == nil then
		_condition_2 = 14
	end
	local _condition_3 = typography.lineHeight
	if _condition_3 == nil then
		_condition_3 = 1
	end
	local lineHeight = _condition_2 * _condition_3
	local backgroundImage = CssHelper:resolveBackgroundImage(inputTheme.backgroundImage)
	local padding = SpacingHelper:GetResolvedPadding(theme, props)
	local scrollerTheme = theme.components.scroller
	local _condition_4 = scrollerTheme.thickness
	if _condition_4 == nil then
		_condition_4 = DEFAULT_SCROLLBAR_THICKNESS
	end
	local thickness = math.max(0, _condition_4)
	local _condition_5 = scrollerTheme.gutter
	if _condition_5 == nil then
		_condition_5 = thickness
	end
	local gutter = math.max(0, _condition_5)
	local widthConstraint = SizeHelper:GetSizeConstraint({
		minWidth = props.minWidth,
		maxWidth = props.maxWidth,
	})
	local heightConstraint = SizeHelper:GetSizeConstraint({
		minHeight = props.minHeight,
		maxHeight = props.maxHeight,
	})
	local _exp_1 = if props.height ~= nil then SizeHelper:toUDim(props.height).Offset else nil
	local _condition_6 = props.rows
	if _condition_6 == nil then
		local _result_1 = textareaTheme
		if _result_1 ~= nil then
			_result_1 = _result_1.rows
		end
		_condition_6 = _result_1
		if _condition_6 == nil then
			_condition_6 = TEXTAREA_DEFAULT_ROWS
		end
	end
	local _exp_2 = resolveTextareaHeight(_exp_1, _condition_6, lineHeight, padding.top, padding.bottom)
	local _result_1 = heightConstraint
	if _result_1 ~= nil then
		_result_1 = _result_1.MinSize.Y
	end
	local _condition_7 = _result_1
	if _condition_7 == nil then
		_condition_7 = 0
	end
	local _result_2 = heightConstraint
	if _result_2 ~= nil then
		_result_2 = _result_2.MaxSize.Y
	end
	local _condition_8 = _result_2
	if _condition_8 == nil then
		_condition_8 = math.huge
	end
	local fieldHeight = resolveTextareaWholePixels(math.clamp(_exp_2, _condition_7, _condition_8))
	local screenScale = resolveTextareaScreenScale(screenFieldSize.Y, fieldHeight, uiScale)
	local wrapWidth = if screenTextBoxWidth > 0 then math.round(screenTextBoxWidth / screenScale) else resolveTextareaWrapWidth(math.floor(screenFieldSize.X / screenScale), padding.left, padding.right, gutter)
	local canvasHeight = resolveTextareaWholePixels(resolveTextareaCanvasHeight(textHeight, padding.top, padding.bottom, fieldHeight, screenScale))
	local textBoxSize = UDim2.new(1, -(padding.left + padding.right), 0, canvasHeight - padding.top + (if estimated then canvasHeight else 0))
	local textBoxSizeRef = useRef(textBoxSize)
	textBoxSizeRef.current = textBoxSize
	local counterGap = resolveTextareaWholePixels(SpacingHelper:GetPadding(theme, "xs"))
	local _condition_9 = TypographyHelper:toTextSize(counterTypography.size)
	if _condition_9 == nil then
		_condition_9 = 14
	end
	local _condition_10 = counterTypography.lineHeight
	if _condition_10 == nil then
		_condition_10 = 1
	end
	local counterHeight = resolveTextareaWholePixels(_condition_9 * _condition_10)
	local rootHeight = fieldHeight + (if props.showCount == true then counterGap + counterHeight else 0)
	local rootWidth = if props.width == nil then UDim.new(1, 0) else (SizeHelper:GetSize({
		width = props.width,
	})).X
	local _object = {
		fieldHeight = fieldHeight,
		wrapWidth = wrapWidth,
		padding = padding,
		uiScale = uiScale,
		font = typography.font,
	}
	local _left = "textSize"
	local _condition_11 = TypographyHelper:toTextSize(typography.size)
	if _condition_11 == nil then
		_condition_11 = 14
	end
	_object[_left] = _condition_11
	local layout = _object
	local layoutRef = useRef(layout)
	layoutRef.current = layout
	local currentScale = function()
		local field = fieldRef.current
		local _result_3 = field
		if _result_3 ~= nil then
			_result_3 = _result_3.AbsoluteSize.Y
		end
		local _condition_12 = _result_3
		if _condition_12 == nil then
			_condition_12 = 0
		end
		return resolveTextareaScreenScale(_condition_12, layoutRef.current.fieldHeight, layoutRef.current.uiScale)
	end
	local estimateTextHeight = function()
		local measure = measureRef.current
		local current = layoutRef.current
		if measure == nil or measure.Text == "" or current.wrapWidth <= 0 then
			return nil
		end
		local size = TextService:GetTextSize(measure.Text, current.textSize, current.font, Vector2.new(current.wrapWidth, MEASURE_HEIGHT))
		task.defer(function()
			setTextHeight(size.Y * FALLBACK_LINE_SLACK)
			setEstimated(true)
		end)
	end
	local cancelFallback = function()
		local _result_3 = pendingFallback.current
		if _result_3 ~= nil then
			_result_3:Disconnect()
		end
		pendingFallback.current = nil
	end
	local updateTextHeightRef, estimateTextHeightRef
	local updateTextHeight = function()
		local measure = measureRef.current
		local current = layoutRef.current
		if measure == nil or current.wrapWidth <= 0 then
			return nil
		end
		local bounds = measure.TextBounds.Y
		if bounds > 0 then
			neverMeasures.current = false
			cancelFallback()
			setTextHeight(bounds / currentScale())
			setEstimated(false)
			return nil
		end
		if measure.Text == "" then
			cancelFallback()
			setTextHeight(0)
			setEstimated(false)
			return nil
		end
		if neverMeasures.current then
			estimateTextHeight()
			return nil
		end
		if pendingFallback.current ~= nil then
			return nil
		end
		local frames = 0
		pendingFallback.current = RunService.Heartbeat:Connect(function()
			frames += 1
			if frames < FALLBACK_FRAMES then
				return nil
			end
			cancelFallback()
			local latest = measureRef.current
			if latest == nil or latest.Text == "" then
				return nil
			end
			if latest.TextBounds.Y > 0 then
				updateTextHeightRef.current()
				return nil
			end
			neverMeasures.current = true
			estimateTextHeightRef.current()
		end)
	end
	updateTextHeightRef = useRef(updateTextHeight)
	updateTextHeightRef.current = updateTextHeight
	estimateTextHeightRef = useRef(estimateTextHeight)
	estimateTextHeightRef.current = estimateTextHeight
	local nudgeTextBox = function()
		local _result_3 = pendingNudge.current
		if _result_3 ~= nil then
			_result_3:Disconnect()
		end
		local step = 0
		pendingNudge.current = RunService.Heartbeat:Connect(function()
			local textBox = ref.current
			if textBox == nil then
				local _result_4 = pendingNudge.current
				if _result_4 ~= nil then
					_result_4:Disconnect()
				end
				pendingNudge.current = nil
				return nil
			end
			step += 1
			if step == 1 then
				local size = textBoxSizeRef.current
				textBox.Size = UDim2.new(size.X, UDim.new(size.Y.Scale, size.Y.Offset - 1))
				return nil
			end
			textBox.Size = textBoxSizeRef.current
			local _result_4 = pendingNudge.current
			if _result_4 ~= nil then
				_result_4:Disconnect()
			end
			pendingNudge.current = nil
		end)
	end
	local setTextBox = React.useCallback(function(instance)
		ref.current = instance
		ElementHelper:assignRef(forwardedRef, instance)
	end, { forwardedRef })
	local scrollToCaret = function()
		local textBox = ref.current
		local frame = scrollerRef.current
		local probe = probeRef.current
		local lineProbe = lineProbeRef.current
		if not followRequested.current or textBox == nil or frame == nil or probe == nil or lineProbe == nil then
			return nil
		end
		if not textBox:IsFocused() then
			followRequested.current = false
			return nil
		end
		local scale = currentScale()
		local current = layoutRef.current
		local caretLineHeight = lineProbe.TextBounds.Y / scale
		local caretBounds = probe.TextBounds.Y / scale
		if not (caretLineHeight > 0) or not (caretBounds > 0) then
			return nil
		end
		local caretBottom = current.padding.top + caretBounds
		local caretTop = caretBottom - caretLineHeight
		local canvasY = frame.CanvasPosition.Y / scale
		local viewportHeight = frame.AbsoluteWindowSize.Y / scale
		local target = resolveTextareaCaretScroll(caretTop - current.padding.top, caretBottom + current.padding.bottom, canvasY, viewportHeight)
		if target == canvasY then
			return nil
		end
		local maxScroll = math.max(0, frame.AbsoluteCanvasSize.Y / scale - viewportHeight)
		local screenY = math.min(target, maxScroll) * scale
		lastWrittenY.current = screenY
		frame.CanvasPosition = Vector2.new(frame.CanvasPosition.X, screenY)
	end
	local followCaret = function()
		local textBox = ref.current
		local probe = probeRef.current
		if textBox == nil or probe == nil or not textBox:IsFocused() then
			return nil
		end
		local caretText = resolveTextareaCaretLineText(textBox.Text, textBox.CursorPosition)
		if caretText == nil then
			return nil
		end
		followRequested.current = true
		if probe.Text ~= caretText then
			probe.Text = caretText
		end
		scrollToCaret()
	end
	local scrollToCaretRef = useRef(scrollToCaret)
	scrollToCaretRef.current = scrollToCaret
	local followCaretRef = useRef(followCaret)
	followCaretRef.current = followCaret
	local currentScaleRef = useRef(currentScale)
	currentScaleRef.current = currentScale
	local _condition_12 = props.PlaceholderText
	if _condition_12 == nil then
		_condition_12 = props.placeholder
	end
	local placeholderText = _condition_12
	local measureText = function(text)
		local measure = measureRef.current
		if measure == nil then
			return nil
		end
		local _result_3
		if text ~= "" then
			_result_3 = text
		else
			local _result_4 = ref.current
			if _result_4 ~= nil then
				_result_4 = _result_4.PlaceholderText
			end
			local _condition_13 = _result_4
			if _condition_13 == nil then
				_condition_13 = ""
			end
			_result_3 = _condition_13
		end
		measure.Text = _result_3
		updateTextHeight()
	end
	React.useEffect(function()
		local _result_3 = ref.current
		if _result_3 ~= nil then
			_result_3 = _result_3.Text
		end
		local _condition_13 = _result_3
		if _condition_13 == nil then
			_condition_13 = displayText
		end
		measureText(_condition_13)
	end, { placeholderText, wrapWidth, screenScale, typography.size, typography.font, typography.lineHeight })
	React.useEffect(function()
		local field = fieldRef.current
		if field ~= nil then
			setScreenFieldSize(field.AbsoluteSize)
		end
		return function()
			local _result_3 = pendingFallback.current
			if _result_3 ~= nil then
				_result_3:Disconnect()
			end
			pendingFallback.current = nil
			local _result_4 = pendingNudge.current
			if _result_4 ~= nil then
				_result_4:Disconnect()
			end
			pendingNudge.current = nil
		end
	end, {})
	React.useEffect(function()
		if not labelActivated then
			return nil
		end
		local connection = labelActivated.Event:Connect(function()
			if props.disabled then
				return nil
			end
			local _result_3 = ref.current
			if _result_3 ~= nil then
				_result_3:CaptureFocus()
			end
		end)
		return function()
			return connection:Disconnect()
		end
	end, { labelActivated, ref, props.disabled })
	React.useEffect(function()
		if props.disabled then
			local _result_3 = ref.current
			if _result_3 ~= nil then
				_result_3:ReleaseFocus()
			end
		end
	end, { props.disabled })
	React.useEffect(function()
		local textBox = ref.current
		if focusedRef.current or heldText.current == nil or textBox == nil then
			return nil
		end
		if textBox.Text ~= sourceText and reportedTexts.current[sourceText] ~= nil then
			return nil
		end
		heldText.current = nil
		if textBox.Text ~= sourceText then
			textBox.Text = sourceText
		end
	end, { focused, sourceText })
	React.useEffect(function()
		if focusedRef.current or nudgedSource.current == sourceText then
			return nil
		end
		nudgedSource.current = sourceText
		nudgeTextBox()
	end, { focused, sourceText })
	local _exp_3 = function()
		local frame = scrollerRef.current
		if frame == nil then
			return nil
		end
		local connection = frame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
			scrollToCaretRef.current()
		end)
		return function()
			return connection:Disconnect()
		end
	end
	local _exp_4 = inputTheme.innerShadow == nil
	local _exp_5 = scrollerTheme.trackColor ~= nil
	local _condition_13 = scrollerTheme.thumbBorderThickness
	if _condition_13 == nil then
		_condition_13 = 0
	end
	React.useEffect(_exp_3, { _exp_4, _exp_5, _condition_13 > 0 })
	React.useEffect(function()
		if not focused then
			return nil
		end
		local stickY = 0
		local inputConnection = CustomInputService.InputChanged:Connect(function(input)
			if input.KeyCode == Enum.KeyCode.Thumbstick2 then
				stickY = input.Position.Y
			end
		end)
		local stepConnection = RunService.Heartbeat:Connect(function(deltaTime)
			local frame = scrollerRef.current
			if frame == nil or math.abs(stickY) < GAMEPAD_DEADZONE then
				return nil
			end
			local maxScroll = math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y)
			local step = stickY * GAMEPAD_SCROLL_SPEED * deltaTime * currentScaleRef.current()
			local scrollY = math.clamp(frame.CanvasPosition.Y - step, 0, maxScroll)
			frame.CanvasPosition = Vector2.new(frame.CanvasPosition.X, scrollY)
		end)
		return function()
			inputConnection:Disconnect()
			stepConnection:Disconnect()
		end
	end, { focused })
	local measureLabel = function(key, labelRef, change, text)
		return React.createElement("textlabel", {
			key = key,
			ref = labelRef,
			Size = UDim2.fromOffset(wrapWidth, MEASURE_HEIGHT),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextTransparency = 1,
			Active = false,
			Interactable = false,
			Selectable = false,
			AutoLocalize = false,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			FontFace = fontFace,
			FontSize = typography.size,
			LineHeight = typography.lineHeight,
			RichText = props.RichText,
			Text = text,
			Change = change,
		}, React.createElement(PreferredTextSizePin, {
			size = typography.size,
		}))
	end
	local _attributes = {
		key = "TextBox",
		ref = setTextBox,
		Position = UDim2.fromOffset(padding.left, padding.top),
		Size = textBoxSize,
		BackgroundTransparency = 1,
		MultiLine = true,
		TextWrapped = true,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		FontFace = fontFace,
		FontSize = typography.size,
		PlaceholderText = placeholderText,
		PlaceholderColor3 = props.PlaceholderColor3 or placeholderTypography.color,
		LineHeight = typography.lineHeight,
		Text = displayText,
		TextColor3 = props.TextColor3 or typography.color or theme.colors.intents.primary.default.textColor,
	}
	local _condition_14 = props.TextTransparency
	if _condition_14 == nil then
		_condition_14 = typography.transparency
	end
	_attributes.TextTransparency = _condition_14
	_attributes.Active = props.Active
	_attributes.Archivable = props.Archivable
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = if props.BorderSizePixel == nil then 0 else props.BorderSizePixel
	_attributes.Rotation = props.Rotation
	_attributes.Selectable = props.Selectable
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.Tag = props.Tag
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionOrder = props.SelectionOrder
	_attributes.CursorPosition = props.CursorPosition
	_attributes.SelectionStart = props.SelectionStart
	_attributes.ShowNativeInput = props.ShowNativeInput
	_attributes.TextEditable = if props.disabled then false else props.TextEditable
	_attributes.Interactable = if props.disabled then false else nil
	_attributes.RichText = props.RichText
	local _object_1 = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object_1[_k] = _v
		end
	end
	_object_1.Focused = function(rbx)
		focusedRef.current = true
		heldText.current = displayText
		table.clear(reportedTexts.current)
		setFocused(true)
		local _result_3 = props.Event
		if _result_3 ~= nil then
			_result_3 = _result_3.Focused
			if _result_3 ~= nil then
				_result_3(rbx)
			end
		end
	end
	_object_1.FocusLost = function(rbx, enterPressed, inputThatCausedFocusLoss)
		focusedRef.current = false
		followRequested.current = false
		setFocused(false)
		local _result_3 = props.Event
		if _result_3 ~= nil then
			_result_3 = _result_3.FocusLost
			if _result_3 ~= nil then
				_result_3(rbx, enterPressed, inputThatCausedFocusLoss)
			end
		end
	end
	_attributes.Event = _object_1
	local _object_2 = {}
	local _spread_1 = props.Change
	if _spread_1 then
		for _k, _v in _spread_1 do
			_object_2[_k] = _v
		end
	end
	_object_2.AbsoluteSize = function(rbx)
		setScreenTextBoxWidth(rbx.AbsoluteSize.X)
		local _result_3 = props.Change
		if _result_3 ~= nil then
			_result_3 = _result_3.AbsoluteSize
			if _result_3 ~= nil then
				_result_3(rbx)
			end
		end
	end
	_object_2.Text = function(rbx)
		if focusedRef.current then
			local trimmed = trimTextareaText(rbx.Text, props.maxLength)
			if trimmed ~= rbx.Text then
				ref.current.Text = trimmed
				return nil
			end
		end
		measureText(rbx.Text)
		local _current = reportedTexts.current
		local _text = rbx.Text
		_current[_text] = true
		setValue(rbx.Text)
		local _result_3 = props.onChange
		if _result_3 ~= nil then
			_result_3(rbx.Text)
		end
		followCaretRef.current()
		local _result_4 = props.Change
		if _result_4 ~= nil then
			_result_4 = _result_4.Text
			if _result_4 ~= nil then
				_result_4(rbx)
			end
		end
	end
	_object_2.CursorPosition = function(rbx)
		followCaretRef.current()
		local _result_3 = props.Change
		if _result_3 ~= nil then
			_result_3 = _result_3.CursorPosition
			if _result_3 ~= nil then
				_result_3(rbx)
			end
		end
	end
	_attributes.Change = _object_2
	local scroller = (React.createElement(Scroller, {
		name = "Scroller",
		ref = scrollerRef,
		stableGutter = true,
		spacing = "None",
		onScroll = function(canvasPosition)
			local written = lastWrittenY.current
			lastWrittenY.current = nil
			if written == nil or math.abs(canvasPosition.Y - written) > 0.5 then
				followRequested.current = false
			end
		end,
	}, React.createElement("textbutton", {
		key = "Canvas",
		Size = UDim2.new(1, 0, 0, canvasHeight),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		Event = {
			Activated = function()
				if not props.disabled then
					local _result_3 = ref.current
					if _result_3 ~= nil then
						_result_3:CaptureFocus()
					end
				end
			end,
		},
	}, React.createElement("textbox", _attributes, React.createElement(PreferredTextSizePin, {
		size = typography.size,
	})))))
	local _attributes_1 = {
		key = "Field",
		ref = fieldRef,
		Size = UDim2.new(1, 0, 0, fieldHeight),
		LayoutOrder = 1,
		BackgroundColor3 = stateStyle.backgroundColor or inputTheme.backgroundColor,
	}
	local _condition_15 = stateStyle.backgroundTransparency
	if _condition_15 == nil then
		_condition_15 = inputTheme.backgroundTransparency
		if _condition_15 == nil then
			_condition_15 = 1
		end
	end
	_attributes_1.BackgroundTransparency = _condition_15
	_attributes_1.BorderSizePixel = 0
	_attributes_1.Image = backgroundImage.Image
	_attributes_1.ImageColor3 = backgroundImage.ImageColor3
	_attributes_1.ImageTransparency = backgroundImage.ImageTransparency
	_attributes_1.ScaleType = backgroundImage.ScaleType
	_attributes_1.SliceCenter = backgroundImage.SliceCenter
	_attributes_1.SliceScale = backgroundImage.SliceScale
	_attributes_1.TileSize = backgroundImage.TileSize
	_attributes_1.Event = {
		MouseEnter = function()
			return setHovered(true)
		end,
		MouseLeave = function()
			return setHovered(false)
		end,
	}
	_attributes_1.Change = {
		AbsoluteSize = function(rbx)
			return setScreenFieldSize(rbx.AbsoluteSize)
		end,
	}
	local field = (React.createElement("imagelabel", _attributes_1, React.createElement("uistroke", {
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
	}), if inputTheme.innerShadow == nil then scroller else (React.createElement(React.Fragment, nil, React.createElement(FieldInnerShadow, {
		value = inputTheme.innerShadow,
		cornerRadius = inputTheme.cornerRadius,
		inset = borderThickness,
	}), React.createElement("frame", {
		key = "Content",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
	}, scroller))), React.createElement("frame", {
		key = "Measure",
		Size = UDim2.fromOffset(0, 0),
		Visible = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = false,
		Interactable = false,
	}, measureLabel("TextMeasure", measureRef, {
		TextBounds = function()
			return updateTextHeight()
		end,
	}), measureLabel("CaretProbe", probeRef, {
		TextBounds = function()
			return scrollToCaretRef.current()
		end,
	}), measureLabel("LineProbe", lineProbeRef, nil, " "))))
	local _attributes_2 = {}
	local _condition_16 = props.name
	if _condition_16 == nil then
		_condition_16 = "Textarea"
	end
	_attributes_2.key = _condition_16
	_attributes_2.Size = UDim2.new(rootWidth, UDim.new(0, rootHeight))
	_attributes_2.AnchorPoint = props.AnchorPoint
	_attributes_2.Position = props.Position
	_attributes_2.LayoutOrder = props.LayoutOrder
	_attributes_2.Visible = props.Visible
	_attributes_2.ZIndex = props.ZIndex
	_attributes_2.BackgroundTransparency = 1
	_attributes_2.BorderSizePixel = 0
	return React.createElement("frame", _attributes_2, widthConstraint ~= nil and (React.createElement("uisizeconstraint", {
		key = "SizeConstraint",
		MinSize = widthConstraint.MinSize,
		MaxSize = widthConstraint.MaxSize,
	})), props.showCount == true and (React.createElement("uilistlayout", {
		key = "Layout",
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, counterGap),
	})), field, props.showCount == true and (React.createElement(Text, {
		name = "Counter",
		text = formatTextareaCount(resolveTextareaLength(value), props.maxLength),
		typography = counterTypography,
		TextColor3 = counterTypography.color,
		TextTransparency = counterTypography.transparency,
		align = "Right",
		TextWrap = false,
		RichText = false,
		Size = UDim2.new(1, 0, 0, counterHeight),
		AutomaticSize = Enum.AutomaticSize.None,
		LayoutOrder = 2,
	})))
end)
return {
	Textarea = Textarea,
}
