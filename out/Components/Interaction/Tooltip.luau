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
local function TooltipPopup(props)
	local theme = React.useContext(CleanThemeContext)
	local anchor = Vector2.zero
	local _position = props.target.position
	local _absolutePosition = props.overlay.AbsolutePosition
	local position = _position - _absolutePosition
	local _exp = props.placement or "Top"
	repeat
		if _exp == "Top" then
			anchor = Vector2.new(0.5, 1)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X / 2, 0)
			position = _position_1 + _vector2
			break
		end
		if _exp == "Bottom" then
			anchor = Vector2.new(0.5, 0)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X / 2, props.target.size.Y)
			position = _position_1 + _vector2
			break
		end
		if _exp == "Left" then
			anchor = Vector2.new(1, 0.5)
			local _position_1 = position
			local _vector2 = Vector2.new(0, props.target.size.Y / 2)
			position = _position_1 + _vector2
			break
		end
		if _exp == "Right" then
			anchor = Vector2.new(0, 0.5)
			local _position_1 = position
			local _vector2 = Vector2.new(props.target.size.X, props.target.size.Y / 2)
			position = _position_1 + _vector2
			break
		end
	until true
	local intent = ColorHelper:getIntentColors(theme, props.intent, "default", theme.components.tooltip.intents)
	local _value = theme.components.tooltip.boxShadow
	local shadow = if _value ~= 0 and _value == _value and _value ~= "" and _value then CssHelper:parseCssShadow(theme.components.tooltip.boxShadow) else nil
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, props.spacing, theme.components.tooltip.spacing))
	local _exp_1 = shadow ~= nil and React.createElement(Padding, {
		resolvedPadding = {
			top = shadow.blurRadius.Offset + shadow.spread.Y.Offset - shadow.offset.Y.Offset,
			bottom = shadow.blurRadius.Offset + shadow.spread.Y.Offset + shadow.offset.Y.Offset,
			left = shadow.blurRadius.Offset + shadow.spread.X.Offset - shadow.offset.X.Offset,
			right = shadow.blurRadius.Offset + shadow.spread.X.Offset + shadow.offset.X.Offset,
		},
	})
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.value = theme.components.box.boxShadow
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
		BackgroundTransparency = 1,
	}, _exp_1, React.createElement("frame", {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = intent.backgroundColor,
		BackgroundTransparency = intent.backgroundTransparency,
	}, _exp_2, _exp_3, _exp_4, _exp_5, if type(_content) == "string" then React.createElement(Text, {
		text = props.content,
		TextColor3 = intent.textColor,
	}) else props.content))
end
local function Tooltip(props)
	local targetRef = React.useRef()
	local target, setTarget = React.useState()
	local show = function()
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
	local hide = function()
		setTarget(nil)
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
			local _attributes = table.clone(props)
			setmetatable(_attributes, nil)
			_attributes.overlay = overlay
			_attributes.target = target
			return ReactRoblox.createPortal(React.createElement(TooltipPopup, _attributes), overlay)
		end,
	})))
end
return {
	Tooltip = Tooltip,
}
