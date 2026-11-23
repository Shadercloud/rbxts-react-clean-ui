-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local function PinTextSize(props)
	if props.size == nil or props.enabled == false then
		return nil
	end
	local size = math.clamp(props.size, 1, 100)
	return React.createElement("uitextsizeconstraint", {
		key = "PinTextSize",
		MinTextSize = size,
		MaxTextSize = size,
	})
end
return {
	PinTextSize = PinTextSize,
}
