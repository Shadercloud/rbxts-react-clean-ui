-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useUiScale = TS.import(script, script.Parent.Parent.Parent, "Contexts").useUiScale
local toScreenTextSize = TS.import(script, script.Parent.Parent.Parent, "Helpers").toScreenTextSize
local function PinTextSize(props)
	local uiScale = useUiScale()
	if props.size == nil or props.enabled == false then
		return nil
	end
	local size = toScreenTextSize(props.size, uiScale)
	if size == nil then
		return nil
	end
	return React.createElement("uitextsizeconstraint", {
		key = "PinTextSize",
		MinTextSize = size,
		MaxTextSize = size,
	})
end
return {
	PinTextSize = PinTextSize,
}
