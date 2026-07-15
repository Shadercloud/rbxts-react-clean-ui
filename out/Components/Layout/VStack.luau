-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function VStack(props)
	local theme = React.useContext(CleanThemeContext)
	local padding = UDim.new(0, theme.spacing[props.spacing or theme.default.spacing])
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = padding,
	}), props.children)
end
return {
	VStack = VStack,
}
