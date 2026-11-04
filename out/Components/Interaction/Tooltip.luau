-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local GuiService = TS.import(script, TS.getModule(script, "@rbxts", "services")).GuiService
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local DragStateContext = _Contexts.DragStateContext
local OverlayConsumer = _Contexts.OverlayConsumer
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local ElementHelper = _Helpers.ElementHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local _Tooltip_placement = TS.import(script, script.Parent, "Tooltip.placement")
local computeTooltipLayout = _Tooltip_placement.computeTooltipLayout
local getTooltipSafeArea = _Tooltip_placement.getTooltipSafeArea
local function getTopbarBottom(overlay)
	local surface = overlay:FindFirstAncestorWhichIsA("ScreenGui")
	if surface == nil or surface.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
		return 0
	end
	local originY = if surface.ScreenInsets == Enum.ScreenInsets.CoreUISafeInsets then (GuiService:GetGuiInset()).Y else 0
	return GuiService.TopbarInset.Max.Y - originY - overlay.AbsolutePosition.Y
end
local function readFrame(overlay)
	return {
		position = overlay.AbsolutePosition,
		size = overlay.AbsoluteSize,
		topbarBottom = getTopbarBottom(overlay),
	}
end
local function TooltipPopup(props)
	local theme = React.useContext(CleanThemeContext)
	local contentRef = React.useRef()
	local contentSize, setContentSize = React.useState()
	local frame, setFrame = React.useState(function()
		return readFrame(props.overlay)
	end)
	local groupTransparency, transparencyTween = useTween(1, {
		duration = props.fadeDuration,
		easing = "quadOut",
	})
	local measured = contentSize ~= nil
	React.useEffect(function()
		transparencyTween:setGoal(if props.visible and measured then 0 else 1)
	end, { props.visible, measured, transparencyTween })
	React.useEffect(function()
		local overlay = props.overlay
		local update = function()
			local latest = readFrame(overlay)
			setFrame(function(current)
				return if current.position == latest.position and current.size == latest.size and current.topbarBottom == latest.topbarBottom then current else latest
			end)
		end
		update()
		local connections = { overlay:GetPropertyChangedSignal("AbsoluteSize"):Connect(update), overlay:GetPropertyChangedSignal("AbsolutePosition"):Connect(update), GuiService:GetPropertyChangedSignal("TopbarInset"):Connect(update) }
		return function()
			for _, connection in connections do
				connection:Disconnect()
			end
		end
	end, { props.overlay })
	React.useEffect(function()
		local content = contentRef.current
		if content == nil then
			return nil
		end
		local update = function()
			local size = content.AbsoluteSize
			if size.X > 0 or size.Y > 0 then
				setContentSize(size)
			end
		end
		update()
		local sizeChanged = content:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		return function()
			sizeChanged:Disconnect()
		end
	end, {})
	local shadowPadding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	}
	local shadow = if theme.components.tooltip.boxShadow ~= nil and theme.components.tooltip.boxShadow ~= 0 then CssHelper:parseCssShadow(theme.components.tooltip.boxShadow) else nil
	if shadow ~= nil then
		shadowPadding.top += shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset
		shadowPadding.bottom += shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset
		shadowPadding.left += shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset
		shadowPadding.right += shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset
	end
	local _result = contentSize
	if _result ~= nil then
		_result = _result.X
	end
	local _condition = _result
	if _condition == nil then
		_condition = 0
	end
	local contentWidth = _condition
	local _result_1 = contentSize
	if _result_1 ~= nil then
		_result_1 = _result_1.Y
	end
	local _condition_1 = _result_1
	if _condition_1 == nil then
		_condition_1 = 0
	end
	local contentHeight = _condition_1
	local cornerRadius = SizeHelper:toUDim(theme.components.button.cornerRadius)
	local _position = props.target.position
	local _position_1 = frame.position
	local targetPosition = _position - _position_1
	local layout = computeTooltipLayout({
		target = {
			left = targetPosition.X,
			top = targetPosition.Y,
			right = targetPosition.X + props.target.size.X,
			bottom = targetPosition.Y + props.target.size.Y,
		},
		content = {
			width = contentWidth,
			height = contentHeight,
		},
		bounds = getTooltipSafeArea({
			width = frame.size.X,
			height = frame.size.Y,
		}, theme.components.tooltip.edgeMargin, frame.topbarBottom),
		placement = props.placement,
		pointerSize = theme.components.tooltip.pointerSize,
		shadow = shadowPadding,
		cornerRadius = cornerRadius.Offset + cornerRadius.Scale * math.min(contentWidth, contentHeight),
	})
	local resolvedPadding = layout.padding
	local pointer = layout.pointer
	local pointerSize = if pointer ~= nil then theme.components.tooltip.pointerSize else 0
	local intent = ColorHelper:getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents)
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, props.spacing, theme.components.tooltip.spacing))
	local _attributes = {}
	local _condition_2 = props.name
	if _condition_2 == nil then
		_condition_2 = "Tooltip"
	end
	_attributes.key = _condition_2
	_attributes.Position = UDim2.fromOffset(layout.position.x, layout.position.y)
	_attributes.AnchorPoint = Vector2.new(layout.anchor.x, layout.anchor.y)
	_attributes.Size = UDim2.fromOffset(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.GroupTransparency = if measured then groupTransparency else 1
	_attributes.BackgroundTransparency = 1
	_attributes.BorderSizePixel = 0
	local _exp = React.createElement(Padding, {
		resolvedPadding = resolvedPadding,
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	_attributes_1.value = theme.components.tooltip.boxShadow
	local _exp_1 = React.createElement(BoxShadow, _attributes_1)
	local _exp_2 = React.createElement(Corners, {
		radius = theme.components.button.cornerRadius,
	})
	local _attributes_2 = table.clone(props)
	setmetatable(_attributes_2, nil)
	_attributes_2.resolvedPadding = padding
	local _exp_3 = React.createElement(Padding, _attributes_2)
	local _attributes_3 = {
		key = "Stroke",
	}
	local _condition_3 = props["border-thickness"]
	if _condition_3 == nil then
		_condition_3 = theme.components.box.borderThickness
	end
	_attributes_3.Thickness = _condition_3
	_attributes_3.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	_attributes_3.Color = props["border-color"] or intent.borderColor
	local _exp_4 = React.createElement("uistroke", _attributes_3)
	local _content = props.content
	return React.createElement("canvasgroup", _attributes, React.createElement("frame", {
		key = "ShadowPadding",
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, _exp, React.createElement("frame", {
		key = "Content",
		ref = contentRef,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = intent.backgroundColor,
		BackgroundTransparency = intent.backgroundTransparency,
		BorderSizePixel = 0,
	}, _exp_1, _exp_2, _exp_3, _exp_4, if type(_content) == "string" then React.createElement(Text, {
		name = "TooltipText",
		text = props.content,
		TextColor3 = intent.textColor,
	}) else props.content)), pointer ~= nil and React.createElement("frame", {
		key = "Pointer",
		Size = UDim2.fromOffset(pointerSize, pointerSize),
		AnchorPoint = Vector2.new(pointer.anchor.x, pointer.anchor.y),
		Position = UDim2.new(pointer.scale.x, pointer.offset.x, pointer.scale.y, pointer.offset.y),
		BorderSizePixel = 1,
		BackgroundColor3 = intent.backgroundColor,
		BorderColor3 = props["border-color"] or intent.borderColor,
		BackgroundTransparency = intent.backgroundTransparency,
		Rotation = 45,
	}, React.createElement("uigradient", {
		key = "Gradient",
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4999, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0) }),
		Rotation = pointer.rotation,
	})))
end
local function Tooltip(props)
	local targetRef = React.useRef()
	local hideRequest = React.useRef(0)
	local hoveredRef = React.useRef(false)
	local shownRef = React.useRef(false)
	local target, setTarget = React.useState()
	local visible, setVisible = React.useState(false)
	local theme = React.useContext(CleanThemeContext)
	local dragState = React.useContext(DragStateContext)
	local fadeDuration = theme.components.tooltip.fadeDuration
	local suppressed = props.disabled == true or dragState.preview or dragState.dragging
	local suppressedRef = React.useRef(suppressed)
	suppressedRef.current = suppressed
	local controlled = props.open ~= nil
	local controlledRef = React.useRef(controlled)
	controlledRef.current = controlled
	local captureTarget = function()
		local _result = targetRef.current
		if _result ~= nil then
			_result = _result.AbsolutePosition
		end
		if _result then
			local _object = {}
			local _left = "position"
			local _result_1 = targetRef.current
			if _result_1 ~= nil then
				_result_1 = _result_1.AbsolutePosition
			end
			_object[_left] = _result_1
			local _left_1 = "size"
			local _result_2 = targetRef.current
			if _result_2 ~= nil then
				_result_2 = _result_2.AbsoluteSize
			end
			_object[_left_1] = _result_2
			setTarget(_object)
		end
	end
	local show = function()
		shownRef.current = true
		hideRequest.current += 1
		captureTarget()
		setVisible(true)
	end
	local hide = function()
		shownRef.current = false
		setVisible(false)
		local request = hideRequest.current + 1
		hideRequest.current = request
		if fadeDuration <= 0 then
			setTarget(nil)
			return nil
		end
		task.delay(fadeDuration, function()
			if hideRequest.current == request then
				setTarget(nil)
			end
		end)
	end
	React.useEffect(function()
		if suppressed then
			hoveredRef.current = false
		end
		local _condition = not suppressed
		if _condition then
			local _condition_1 = props.open
			if _condition_1 == nil then
				_condition_1 = hoveredRef.current
			end
			_condition = _condition_1
		end
		local wanted = _condition
		if wanted and not shownRef.current then
			show()
		elseif not wanted and shownRef.current then
			hide()
		end
	end, { suppressed, props.open })
	React.useEffect(function()
		local instance = targetRef.current
		if not visible or instance == nil then
			return nil
		end
		local positionChanged = instance:GetPropertyChangedSignal("AbsolutePosition"):Connect(captureTarget)
		local sizeChanged = instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(captureTarget)
		return function()
			positionChanged:Disconnect()
			sizeChanged:Disconnect()
		end
	end, { visible })
	local child = ElementHelper:cloneWithEvents(props.children, {
		ref = targetRef,
	}, {
		MouseEnter = function()
			hoveredRef.current = true
			if not controlledRef.current and not suppressedRef.current then
				show()
			end
		end,
		MouseLeave = function()
			hoveredRef.current = false
			if not controlledRef.current then
				hide()
			end
		end,
	})
	return React.createElement(React.Fragment, nil, child, target ~= nil and (React.createElement(OverlayConsumer, {
		render = function(overlay)
			if overlay == nil then
				return nil
			end
			local _attributes = {
				fadeDuration = fadeDuration,
			}
			for _k, _v in props do
				_attributes[_k] = _v
			end
			_attributes.overlay = overlay
			_attributes.target = target
			_attributes.visible = visible
			return ReactRoblox.createPortal(React.createElement(TooltipPopup, _attributes), overlay)
		end,
	})))
end
return {
	Tooltip = Tooltip,
}
