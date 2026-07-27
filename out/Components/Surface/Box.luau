-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Padding = _Decorator.Padding
local Corners = _Decorator.Corners
local BoxShadow = _Decorator.BoxShadow
local Container = TS.import(script, script.Parent.Parent, "Layout").Container
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local Box = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	local _condition = props.BackgroundTransparency
	if _condition == nil then
		_condition = theme.components.box.backgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BackgroundColor3 = props.BackgroundColor3 or theme.components.box.backgroundColor
	_attributes.ZIndex = props.ZIndex
	_attributes.Event = props.Event
	local _exp = React.createElement("uistroke", {
		Thickness = theme.components.box.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.box.borderColor,
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	_attributes_1.value = theme.components.box.boxShadow
	local _exp_1 = React.createElement(BoxShadow, _attributes_1)
	local _attributes_2 = table.clone(props)
	setmetatable(_attributes_2, nil)
	return React.createElement(Container, _attributes, _exp, _exp_1, React.createElement(Padding, _attributes_2), React.createElement(Corners, {
		radius = theme.components.box.cornerRadius,
	}), props.children)
end)
return {
	Box = Box,
}
