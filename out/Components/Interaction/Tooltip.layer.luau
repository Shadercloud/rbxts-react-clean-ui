-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local TooltipLayerContext = React.createContext({
	depth = 0,
})
local hoveredDepths = {}
local listeners = {}
local function setTooltipHovered(owner, depth)
	local _owner = owner
	if hoveredDepths[_owner] == depth then
		return nil
	end
	if depth == nil then
		local _owner_1 = owner
		hoveredDepths[_owner_1] = nil
	else
		local _owner_1 = owner
		local _depth = depth
		hoveredDepths[_owner_1] = _depth
	end
	local _array = {}
	local _length = #_array
	for _v in listeners do
		_length += 1
		_array[_length] = _v
	end
	local snapshot = _array
	for _, listener in snapshot do
		listener()
	end
end
local function isTooltipCovered(depth, owner)
	for other, hoveredDepth in hoveredDepths do
		if other ~= owner and hoveredDepth >= depth then
			return true
		end
	end
	return false
end
local function subscribeTooltipHover(listener)
	local _listener = listener
	listeners[_listener] = true
	return function()
		local _listener_1 = listener
		listeners[_listener_1] = nil
	end
end
return {
	setTooltipHovered = setTooltipHovered,
	isTooltipCovered = isTooltipCovered,
	subscribeTooltipHover = subscribeTooltipHover,
	TooltipLayerContext = TooltipLayerContext,
}
