-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local GuiService = _services.GuiService
local UserInputService = _services.UserInputService
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
local _Tooltip_layer = TS.import(script, script.Parent, "Tooltip.layer")
local TooltipLayerContext = _Tooltip_layer.TooltipLayerContext
local isTooltipCovered = _Tooltip_layer.isTooltipCovered
local setTooltipHovered = _Tooltip_layer.setTooltipHovered
local subscribeTooltipHover = _Tooltip_layer.subscribeTooltipHover
local function isPressInput(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
local function getTopbarBottom(overlay)
	local surface = overlay:FindFirstAncestorWhichIsA("ScreenGui")
	local topbarInset = GuiService.TopbarInset
	if surface == nil or not topbarInset or surface.ScreenInsets == Enum.ScreenInsets.TopbarSafeInsets then
		return 0
	end
	local originY = if surface.ScreenInsets == Enum.ScreenInsets.CoreUISafeInsets then (GuiService:GetGuiInset()).Y else 0
	return topbarInset.Max.Y - originY - overlay.AbsolutePosition.Y
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
	local cornerRadius = SizeHelper:toRadius(theme, theme.components.button.cornerRadius)
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
	_attributes.Active = if props.onHover ~= nil or props.onPress ~= nil then true else nil
	_attributes.Event = {
		MouseEnter = function()
			if props.visible then
				local _result_2 = props.onHover
				if _result_2 ~= nil then
					_result_2(true)
				end
			end
		end,
		MouseLeave = function()
			local _result_2 = props.onHover
			if _result_2 ~= nil then
				_result_2(false)
			end
		end,
		InputBegan = function(_rbx, input)
			if props.visible and isPressInput(input) then
				local _result_2 = props.onPress
				if _result_2 ~= nil then
					_result_2()
				end
			end
		end,
	}
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
	}, _exp_1, _exp_2, _exp_3, _exp_4, React.createElement(TooltipLayerContext.Provider, {
		value = props.layer,
	}, if type(_content) == "string" then React.createElement(Text, {
		name = "TooltipText",
		text = props.content,
		TextColor3 = intent.textColor,
	}) else props.content))), pointer ~= nil and React.createElement("frame", {
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
	local owner = React.useRef({}).current
	local hideRequest = React.useRef(0)
	local closeRequest = React.useRef(0)
	local closingRef = React.useRef(false)
	local longPressRequest = React.useRef(0)
	local touchConnection = React.useRef()
	local hoveredRef = React.useRef(false)
	local popupHoveredRef = React.useRef(false)
	local pinnedRef = React.useRef(false)
	local longPressedRef = React.useRef(false)
	local holdsRef = React.useRef(0)
	local releaseRef = React.useRef()
	local shownRef = React.useRef(false)
	local actionsRef = React.useRef()
	local target, setTarget = React.useState()
	local visible, setVisible = React.useState(false)
	local theme = React.useContext(CleanThemeContext)
	local dragState = React.useContext(DragStateContext)
	local layer = React.useContext(TooltipLayerContext)
	local fadeDuration = theme.components.tooltip.fadeDuration
	local _condition = theme.components.tooltip.closeDelay
	if _condition == nil then
		_condition = 0.15
	end
	local closeDelay = _condition
	local _condition_1 = theme.components.tooltip.longPressDelay
	if _condition_1 == nil then
		_condition_1 = 0.5
	end
	local longPressDelay = _condition_1
	local suppressed = props.disabled == true or dragState.preview or dragState.dragging
	local suppressedRef = React.useRef(suppressed)
	suppressedRef.current = suppressed
	local controlled = props.open ~= nil
	local controlledRef = React.useRef(controlled)
	controlledRef.current = controlled
	local interactive = props.interactive == true and not controlled
	local pinOnPress = props.pinOnPress == true and not controlled
	local longPress = props.longPress == true and not controlled
	local holdable = interactive or pinOnPress
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
	local release = function()
		local releaseHold = releaseRef.current
		releaseRef.current = nil
		local _result = releaseHold
		if _result ~= nil then
			_result()
		end
	end
	local endTouch = function()
		longPressRequest.current += 1
		local _result = touchConnection.current
		if _result ~= nil then
			_result:Disconnect()
		end
		touchConnection.current = nil
	end
	local show = function()
		shownRef.current = true
		hideRequest.current += 1
		captureTarget()
		setVisible(true)
		if releaseRef.current == nil and layer.retain ~= nil then
			releaseRef.current = layer.retain()
		end
	end
	local hide = function()
		shownRef.current = false
		closingRef.current = false
		closeRequest.current += 1
		popupHoveredRef.current = false
		setTooltipHovered(owner, nil)
		setVisible(false)
		local request = hideRequest.current + 1
		hideRequest.current = request
		if fadeDuration <= 0 then
			setTarget(nil)
		else
			task.delay(fadeDuration, function()
				if hideRequest.current == request then
					setTarget(nil)
				end
			end)
		end
		release()
	end
	local isWanted = function()
		if suppressedRef.current then
			return false
		end
		if props.open ~= nil then
			return props.open
		end
		return (hoveredRef.current and not isTooltipCovered(layer.depth, owner)) or popupHoveredRef.current or pinnedRef.current or longPressedRef.current or (holdable and holdsRef.current > 0)
	end
	local close = function()
		if shownRef.current and not isWanted() then
			hide()
		end
	end
	local update = function()
		if isWanted() then
			closeRequest.current += 1
			closingRef.current = false
			if not shownRef.current then
				show()
			end
			return nil
		end
		if not shownRef.current or closingRef.current then
			return nil
		end
		if not interactive or controlledRef.current or suppressedRef.current then
			hide()
			return nil
		end
		closingRef.current = true
		local request = closeRequest.current + 1
		closeRequest.current = request
		task.delay(closeDelay, function()
			if closeRequest.current == request then
				closingRef.current = false
				local _result = actionsRef.current
				if _result ~= nil then
					_result.close()
				end
			end
		end)
	end
	local togglePin = function()
		if suppressedRef.current or controlledRef.current then
			return nil
		end
		pinnedRef.current = not pinnedRef.current
		update()
	end
	actionsRef.current = {
		update = update,
		close = close,
		togglePin = togglePin,
	}
	local childLayer = React.useMemo(function()
		return {
			depth = layer.depth + 1,
			retain = function()
				local released = false
				holdsRef.current += 1
				local _result = actionsRef.current
				if _result ~= nil then
					_result.update()
				end
				return function()
					if released then
						return nil
					end
					released = true
					holdsRef.current -= 1
					local _result_1 = actionsRef.current
					if _result_1 ~= nil then
						_result_1.update()
					end
				end
			end,
		}
	end, { layer.depth })
	local beginLongPress = function(input)
		endTouch()
		local request = longPressRequest.current
		task.delay(longPressDelay, function()
			if longPressRequest.current == request and not suppressedRef.current and not controlledRef.current then
				longPressedRef.current = true
				local _result = actionsRef.current
				if _result ~= nil then
					_result.update()
				end
			end
		end)
		touchConnection.current = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End and input.UserInputState ~= Enum.UserInputState.Cancel then
				return nil
			end
			endTouch()
			if longPressedRef.current then
				longPressedRef.current = false
				local _result = actionsRef.current
				if _result ~= nil then
					_result.update()
				end
			elseif input.UserInputState == Enum.UserInputState.End and pinOnPress then
				local _result = actionsRef.current
				if _result ~= nil then
					_result.togglePin()
				end
			end
		end)
	end
	local setPopupHovered = function(hovered)
		popupHoveredRef.current = hovered
		setTooltipHovered(owner, if hovered then layer.depth else nil)
		update()
	end
	local unpin = function()
		if pinnedRef.current then
			pinnedRef.current = false
			update()
		end
	end
	React.useEffect(function()
		if suppressed then
			hoveredRef.current = false
			pinnedRef.current = false
			longPressedRef.current = false
			endTouch()
		end
		update()
	end, { suppressed, props.open })
	React.useEffect(function()
		return subscribeTooltipHover(function()
			local _result = actionsRef.current
			if _result ~= nil then
				_result = _result.update()
			end
			return _result
		end)
	end, {})
	React.useEffect(function()
		return function()
			hideRequest.current += 1
			closeRequest.current += 1
			endTouch()
			setTooltipHovered(owner, nil)
			release()
		end
	end, {})
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
			if (pinOnPress or longPress) and UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
				return nil
			end
			hoveredRef.current = true
			if not controlledRef.current and not suppressedRef.current then
				update()
			end
		end,
		MouseLeave = function()
			hoveredRef.current = false
			if not controlledRef.current then
				update()
			end
		end,
		InputBegan = function(_rbx, input)
			if (not pinOnPress and not longPress) or controlledRef.current or suppressedRef.current then
				return nil
			end
			if isTooltipCovered(layer.depth, owner) then
				return nil
			end
			if longPress and input.UserInputType == Enum.UserInputType.Touch then
				beginLongPress(input)
			elseif pinOnPress and isPressInput(input) then
				togglePin()
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
			_attributes.layer = childLayer
			_attributes.onHover = if interactive then setPopupHovered else nil
			_attributes.onPress = if pinOnPress then unpin else nil
			return ReactRoblox.createPortal(React.createElement(TooltipPopup, _attributes), overlay)
		end,
	})))
end
return {
	Tooltip = Tooltip,
}
