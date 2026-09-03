-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CssHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").CssHelper
local function Gradient(props)
	local resolved = CssHelper:resolveBackgroundGradient(props.value)
	if resolved == nil then
		return nil
	end
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Gradient"
	end
	_attributes.key = _condition
	for _k, _v in resolved do
		_attributes[_k] = _v
	end
	return React.createElement("uigradient", _attributes)
end
return {
	Gradient = Gradient,
}
