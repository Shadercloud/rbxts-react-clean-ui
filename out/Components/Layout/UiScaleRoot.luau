-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local UiScaleContext = _Contexts.UiScaleContext
local useUiScale = _Contexts.useUiScale
local UiScaleFrame = TS.import(script, script.Parent, "UiScaleRoot.frame").UiScaleFrame
local UiScaleRoot = React.forwardRef(function(props, ref)
	local parentScale = useUiScale()
	local _attributes = {
		ref = ref,
	}
	local _condition = props.name
	if _condition == nil then
		_condition = "UiScaleRoot"
	end
	_attributes.name = _condition
	_attributes.scale = props.scale
	_attributes.ZIndex = props.ZIndex
	return React.createElement(UiScaleFrame, _attributes, React.createElement(UiScaleContext.Provider, {
		value = parentScale * props.scale,
	}, props.children))
end)
return {
	UiScaleRoot = UiScaleRoot,
}
