-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local RowContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").RowContext
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").BreakpointHelper
local function resolveSpan(span, children, breakpoint)
	if span == nil then
		return math.floor(12 / math.max(children, 1))
	end
	local _span = span
	if type(_span) == "number" then
		return span
	end
	local _span_1 = span
	if type(_span_1) == "string" then
		local _condition = tonumber(span)
		if _condition == nil then
			_condition = 12
		end
		return _condition
	end
	return BreakpointHelper:getValue(breakpoint, span) or 12
end
local Column = React.forwardRef(function(props, ref)
	local context = React.useContext(RowContext)
	local span = resolveSpan(props.span, context.children, context.breakpoint)
	local fraction = math.floor((span / 12) * 1000) / 1000
	local padding = context.padding
	local widthScale = fraction + ((fraction - 1) * padding.Scale)
	local widthOffset = (fraction - 1) * padding.Offset
	return React.createElement("frame", {
		ref = ref,
		Size = UDim2.new(widthScale, widthOffset, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, props.children)
end)
return {
	Column = Column,
}
