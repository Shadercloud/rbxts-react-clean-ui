-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local BoxShadow = TS.import(script, script.Parent.Parent, "Decorator").BoxShadow
local function resolveFieldState(disabled, focused, hovered)
	if disabled then
		return "disabled"
	end
	if focused then
		return "focus"
	end
	if hovered then
		return "hover"
	end
	return "default"
end
local function resolveFieldStateStyle(states, state)
	if states == nil or state == "default" then
		return {}
	end
	return states[state] or {}
end
local function FieldBoxShadow(props)
	local value = props.value
	if value == nil then
		return nil
	end
	if type(value) == "table" then
		local complete = value
		if CssHelper:parseCssShadow(complete.shadow) == nil then
			return nil
		end
		return React.createElement(BoxShadow, {
			name = props.name,
			completeShadow = complete,
		})
	end
	return React.createElement(BoxShadow, {
		name = props.name,
		value = value,
	})
end
local function FieldInnerShadow(props)
	local theme = React.useContext(CleanThemeContext)
	local ref = React.useRef()
	local height, setHeight = React.useState(0)
	React.useEffect(function()
		local frame = ref.current
		if frame ~= nil then
			setHeight(frame.AbsoluteSize.Y)
		end
	end, {})
	local inset = math.max(0, props.inset)
	local radius = if props.cornerRadius ~= nil then SizeHelper:toRadius(theme, props.cornerRadius) else UDim.new()
	local innerRadius = UDim.new(radius.Scale, math.max(0, radius.Offset - inset))
	local fade = if height > 0 then props.value.size / height else 0
	local transparency = if fade >= 1 then NumberSequence.new(props.value.transparency, 1) else NumberSequence.new({ NumberSequenceKeypoint.new(0, props.value.transparency), NumberSequenceKeypoint.new(math.max(fade, 0.001), 1), NumberSequenceKeypoint.new(1, 1) })
	return React.createElement("frame", {
		key = "InnerShadow",
		ref = ref,
		Position = UDim2.fromOffset(inset, inset),
		Size = UDim2.new(1, -2 * inset, 1, -2 * inset),
		BackgroundColor3 = props.value.color,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Visible = fade > 0,
		Change = {
			AbsoluteSize = function(rbx)
				return setHeight(rbx.AbsoluteSize.Y)
			end,
		},
	}, (innerRadius.Scale ~= 0 or innerRadius.Offset ~= 0) and React.createElement("uicorner", {
		key = "Corners",
		CornerRadius = innerRadius,
	}), React.createElement("uigradient", {
		key = "Fade",
		Rotation = 90,
		Transparency = transparency,
	}))
end
return {
	resolveFieldState = resolveFieldState,
	resolveFieldStateStyle = resolveFieldStateStyle,
	FieldBoxShadow = FieldBoxShadow,
	FieldInnerShadow = FieldInnerShadow,
}
