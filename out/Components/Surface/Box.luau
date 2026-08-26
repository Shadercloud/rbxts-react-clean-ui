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
local CssHelper = _Helpers.CssHelper
local Box = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local paddingSourceProps = props
	local hasCustomPadding = paddingSourceProps.top ~= nil or paddingSourceProps.bottom ~= nil or paddingSourceProps.left ~= nil or paddingSourceProps.right ~= nil or paddingSourceProps.spacing ~= nil or paddingSourceProps.padding ~= nil or paddingSourceProps.resolvedPadding ~= nil
	local themePadding = theme.components.box.padding
	local paddingProps = if not hasCustomPadding and themePadding ~= nil then {
		resolvedPadding = CssHelper:parseCssQuad(themePadding),
	} else paddingSourceProps
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
	_attributes.backgroundImage = props["background-image"] or theme.components.box.backgroundImage
	local _attributes_1 = {}
	local _condition_1 = props["border-thickness"]
	if _condition_1 == nil then
		_condition_1 = theme.components.box.borderThickness
	end
	_attributes_1.Thickness = _condition_1
	_attributes_1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	_attributes_1.Color = props["border-color"] or theme.components.box.borderColor
	local _exp = React.createElement("uistroke", _attributes_1)
	local _attributes_2 = table.clone(props)
	setmetatable(_attributes_2, nil)
	_attributes_2.value = theme.components.box.boxShadow
	local _exp_1 = React.createElement(BoxShadow, _attributes_2)
	local _attributes_3 = table.clone(paddingProps)
	setmetatable(_attributes_3, nil)
	return React.createElement(Container, _attributes, _exp, _exp_1, React.createElement(Padding, _attributes_3), React.createElement(Corners, {
		radius = theme.components.box.cornerRadius,
	}), props.children)
end)
return {
	Box = Box,
}
