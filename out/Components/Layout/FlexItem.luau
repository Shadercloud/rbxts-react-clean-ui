-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Container = TS.import(script, script.Parent, "Container").Container
local FlexItem = React.forwardRef(function(props, ref)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.ref = ref
	local _condition = props.name
	if _condition == nil then
		_condition = "FlexItem"
	end
	_attributes.name = _condition
	return React.createElement(Container, _attributes, React.createElement("uiflexitem", {
		key = "FlexItemConstraint",
		FlexMode = props.mode or "Grow",
		GrowRatio = props.GrowRatio,
		ShrinkRatio = props.ShrinkRatio,
	}), React.createElement("uilistlayout", {
		key = "FlexItemLayout",
		HorizontalFlex = props.HorizontalFlex,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = props.align,
	}), props.children)
end)
return {
	FlexItem = FlexItem,
}
