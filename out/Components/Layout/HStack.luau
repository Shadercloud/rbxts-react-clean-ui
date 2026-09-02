-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SpacingHelper
local function HStack(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "HStack"
	end
	_attributes.key = _condition
	_attributes.FillDirection = Enum.FillDirection.Horizontal
	_attributes.HorizontalFlex = props.HorizontalFlex
	_attributes.HorizontalAlignment = props.HorizontalAlignment
	_attributes.VerticalAlignment = props.valign or props.VerticalAlignment
	_attributes.VerticalFlex = props.VerticalFlex
	_attributes.Padding = props.Padding or UDim.new(0, math.ceil(SpacingHelper:GetPadding(theme, props.spacing) / 2))
	_attributes.Wraps = if props.Wraps == nil then true else props.Wraps
	_attributes.SortOrder = Enum.SortOrder.LayoutOrder
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", _attributes), props.children)
end
return {
	HStack = HStack,
}
