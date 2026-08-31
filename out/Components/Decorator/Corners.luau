-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local function Corners(props)
	if props.radius == nil then
		return nil
	end
	local radius = SizeHelper:toUDim(props.radius)
	if radius.Scale == 0 and radius.Offset == 0 then
		return nil
	end
	return React.createElement("uicorner", {
		CornerRadius = radius,
	})
end
return {
	Corners = Corners,
}
