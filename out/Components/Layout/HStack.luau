-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function HStack(props)
	local theme = React.useContext(CleanThemeContext)
	local padding = UDim.new(0, theme.spacing[props.spacing or theme.default.spacing])
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = padding,
		Wraps = true,
	}), props.children)
end
return {
	HStack = HStack,
}
