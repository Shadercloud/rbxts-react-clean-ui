-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SpacingHelper
local function HStack(props)
	local theme = React.useContext(CleanThemeContext)
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalFlex = props.HorizontalFlex,
		HorizontalAlignment = props.HorizontalAlignment,
		VerticalAlignment = props.valign or props.VerticalAlignment,
		VerticalFlex = props.VerticalFlex,
		Padding = props.Padding or UDim.new(0, math.ceil(SpacingHelper:GetPadding(theme, props.spacing) / 2)),
		Wraps = if props.Wraps == nil then true else props.Wraps,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Change = props.Change,
		Event = props.Event,
	}), props.children)
end
return {
	HStack = HStack,
}
