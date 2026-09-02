-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SpacingHelper
local function VStack(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "VStack"
	end
	_attributes.key = _condition
	_attributes.FillDirection = Enum.FillDirection.Vertical
	_attributes.HorizontalFlex = props.HorizontalFlex or Enum.UIFlexAlignment.Fill
	_attributes.VerticalFlex = props.VerticalFlex
	_attributes.VerticalAlignment = props.VerticalAlignment or props.valign
	_attributes.HorizontalAlignment = props.HorizontalAlignment
	_attributes.Padding = props.Padding or UDim.new(0, SpacingHelper:GetPadding(theme, props.spacing))
	_attributes.Wraps = props.Wraps
	_attributes.SortOrder = Enum.SortOrder.LayoutOrder
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", _attributes), props.children)
end
return {
	VStack = VStack,
}
