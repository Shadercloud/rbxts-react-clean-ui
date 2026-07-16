-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function HStack(props)
	local theme = React.useContext(CleanThemeContext)
	local _condition = (theme.spacing[props.spacing or theme.default.spacing])
	if _condition == nil then
		_condition = 0
	end
	local padding = UDim.new(0, math.ceil(_condition / 2))
	return React.createElement(React.Fragment, nil, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = props.valign,
		Padding = padding,
		Wraps = true,
	}), props.children)
end
return {
	HStack = HStack,
}
