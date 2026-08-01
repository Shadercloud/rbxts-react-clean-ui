-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
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
local SpacingHelper = _Helpers.SpacingHelper
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local function TooltipPopup(props)
	local theme = React.useContext(CleanThemeContext)
	local groupTransparency, transparencyTween = useTween(1, {
		duration = props.fadeDuration,
		easing = "quadOut",
	})
	React.useEffect(function()
		transparencyTween:setGoal(if props.visible then 0 else 1)
	end, { props.visible, transparencyTween })
	local resolvedPadding = {
		top = 0,
		bottom = 0,
		left = 0,
		right = 0,
	}
	local _value = theme.components.tooltip.boxShadow
	local shadow = if _value ~= 0 and _value == _value and _value ~= "" and _value then CssHelper:parseCssShadow(theme.components.tooltip.boxShadow) else nil
	if shadow ~= nil then
		resolvedPadding.top += shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset
		resolvedPadding.bottom += shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset
		resolvedPadding.left += shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset
		resolvedPadding.right += shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset
	end
	local pointerSize = if props.placement == "Center" then 0 else theme.components.tooltip.pointerSize
	local anchor = Vector2.zero
	local _position = props.target.position
	local _absolutePosition = props.overlay.AbsolutePosition
	local position = _position - _absolutePosition
	local pointerRotation = 45
	local pointerAnchor = Vector2.new(0.5, 1)
	local pointerPosition = UDim2.new(0.5, 0, 1, 0)
	local factor = 1.41421356
	local pointerHeight = (factor * pointerSize) / 2
	local pointerDiff = pointerHeight - (pointerSize / 2)
	local _exp = props.placement or "Top"
	repeat
		if _exp == "Top" then
			anchor = Vector2.new(0.5, 1)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X / 2, 0)
			position = _position_1 + _vector2
			pointerPosition = UDim2.new(0.5, (resolvedPadding.left - resolvedPadding.right) / 2, 1, -math.max(math.ceil(pointerDiff), resolvedPadding.bottom - pointerDiff))
			resolvedPadding.bottom = math.max(math.floor(pointerHeight), resolvedPadding.bottom)
			break
		end
		if _exp == "Bottom" then
			anchor = Vector2.new(0.5, 0)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X / 2, props.target.size.Y)
			position = _position_1 + _vector2
			pointerAnchor = Vector2.new(0.5, 0)
			pointerRotation = -135
			pointerPosition = UDim2.new(0.5, (resolvedPadding.left - resolvedPadding.right) / 2, 0, math.max(math.ceil(pointerDiff), resolvedPadding.top - pointerDiff))
			resolvedPadding.top = math.max(math.floor(pointerHeight), resolvedPadding.top)
			break
		end
		if _exp == "Left" then
			anchor = Vector2.new(1, 0.5)
			local _position_1 = position
			local _vector2 = Vector2.new(0, props.target.size.Y / 2)
			position = _position_1 + _vector2
			pointerRotation = -45
			pointerAnchor = Vector2.new(1, 0.5)
			pointerPosition = UDim2.new(1, -math.max(math.ceil(pointerDiff), resolvedPadding.right - pointerDiff), 0.5, 0)
			resolvedPadding.right = math.max(math.floor(pointerHeight), resolvedPadding.right)
			break
		end
		if _exp == "Right" then
			anchor = Vector2.new(0, 0.5)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X, props.target.size.Y / 2)
			position = _position_1 + _vector2
			pointerRotation = 135
			pointerAnchor = Vector2.new(0, 0.5)
			pointerPosition = UDim2.new(0, math.max(math.ceil(pointerDiff), resolvedPadding.left - pointerDiff), 0.5, 0)
			resolvedPadding.left = math.max(math.floor(pointerHeight), resolvedPadding.left)
			break
		end
		if _exp == "Center" then
			anchor = Vector2.new(0.5, 0.5)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X / 2, props.target.size.Y / 2)
			position = _position_1 + _vector2
			break
		end
	until true
	local intent = ColorHelper:getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents)
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, props.spacing, theme.components.tooltip.spacing))
	local _exp_1 = React.createElement(Padding, {
		resolvedPadding = resolvedPadding,
	})
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.value = theme.components.tooltip.boxShadow
	local _exp_2 = React.createElement(BoxShadow, _attributes)
	local _exp_3 = React.createElement(Corners, {
		radius = theme.components.button.cornerRadius,
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	_attributes_1.resolvedPadding = padding
	local _exp_4 = React.createElement(Padding, _attributes_1)
	local _attributes_2 = {}
	local _condition = props["border-thickness"]
	if _condition == nil then
		_condition = theme.components.box.borderThickness
	end
	_attributes_2.Thickness = _condition
	_attributes_2.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	_attributes_2.Color = props["border-color"] or intent.borderColor
	local _exp_5 = React.createElement("uistroke", _attributes_2)
	local _content = props.content
	return React.createElement("canvasgroup", {
		Position = UDim2.fromOffset(position.X, position.Y),
		AnchorPoint = anchor,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		GroupTransparency = groupTransparency,
		BackgroundTransparency = 1,
	}, React.createElement("frame", {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
	}, _exp_1, React.createElement("frame", {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = intent.backgroundColor,
		BackgroundTransparency = intent.backgroundTransparency,
	}, _exp_2, _exp_3, _exp_4, _exp_5, if type(_content) == "string" then React.createElement(Text, {
		text = props.content,
		TextColor3 = intent.textColor,
	}) else props.content)), pointerSize > 0 and React.createElement("frame", {
		Size = UDim2.fromOffset(pointerSize, pointerSize),
		AnchorPoint = pointerAnchor,
		Position = pointerPosition,
		BorderSizePixel = 1,
		BackgroundColor3 = intent.backgroundColor,
		BorderColor3 = props["border-color"] or intent.borderColor,
		BackgroundTransparency = intent.backgroundTransparency,
		Rotation = 45,
	}, React.createElement("uigradient", {
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4999, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0) }),
		Rotation = pointerRotation,
	})))
end
local function Tooltip(props)
	local targetRef = React.useRef()
	local hideRequest = React.useRef(0)
	local target, setTarget = React.useState()
	local visible, setVisible = React.useState(false)
	local theme = React.useContext(CleanThemeContext)
	local fadeDuration = theme.components.tooltip.fadeDuration
	local show = function()
		hideRequest.current += 1
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
		setVisible(true)
	end
	local hide = function()
		setVisible(false)
		local request = hideRequest.current + 1
		hideRequest.current = request
		if fadeDuration <= 0 then
			setTarget(nil)
			return nil
		end
		task.delay(fadeDuration, function()
			-- Do not remove it if the tooltip was shown again.
			if hideRequest.current == request then
				setTarget(nil)
			end
		end)
	end
	local _exp = props.children
	local _object = {
		ref = targetRef,
	}
	local _left = "Event"
	local _object_1 = {}
	local _spread = props.children.props.Event
	if _spread then
		for _k, _v in _spread do
			_object_1[_k] = _v
		end
	end
	_object_1.MouseEnter = function(guiObject, x, y)
		local _result = props.children.props.Event
		if _result ~= nil then
			_result = _result.MouseEnter
			if _result ~= nil then
				_result(guiObject, x, y)
			end
		end
		show()
	end
	_object_1.MouseLeave = function(guiObject, x, y)
		local _result = props.children.props.Event
		if _result ~= nil then
			_result = _result.MouseLeave
			if _result ~= nil then
				_result(guiObject, x, y)
			end
		end
		hide()
	end
	_object[_left] = _object_1
	local child = React.cloneElement(_exp, _object)
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
