-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Padding = _Decorator.Padding
local Corners = _Decorator.Corners
local BoxShadow = _Decorator.BoxShadow
local Container = TS.import(script, script.Parent.Parent, "Layout").Container
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local Box = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local _condition = props["border-thickness"]
	if _condition == nil then
		_condition = theme.components.box.borderThickness
	end
	local borderThickness = _condition
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes.AutomaticSize = SizeHelper:GetAutoSize(props)
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = theme.components.box.backgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BackgroundColor3 = props.BackgroundColor3 or theme.components.box.backgroundColor
	_attributes.ZIndex = props.ZIndex
	_attributes.Event = props.Event
	_attributes.backgroundImage = props["background-image"] or theme.components.box.backgroundImage
	local _exp = borderThickness > 0 and (React.createElement("uistroke", {
		Thickness = borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = props["border-color"] or theme.components.box.borderColor,
	}))
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	_attributes_1.value = theme.components.box.boxShadow
	return React.createElement(Container, _attributes, _exp, React.createElement(BoxShadow, _attributes_1), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.box.spacing, theme.components.box.padding),
	}), React.createElement(Corners, {
		radius = theme.components.box.cornerRadius,
	}), props.children)
end)
return {
	Box = Box,
}
