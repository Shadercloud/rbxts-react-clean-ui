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
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Corners"
	end
	_attributes.key = _condition
	_attributes.CornerRadius = radius
	return React.createElement("uicorner", _attributes)
end
return {
	Corners = Corners,
}
