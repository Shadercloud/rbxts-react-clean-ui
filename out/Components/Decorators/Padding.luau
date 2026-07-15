-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function Padding(props)
	local theme = React.useContext(CleanThemeContext)
	local amount = theme.spacing[props.spacing or theme.default.spacing]
	local padding = UDim.new(0, amount)
	return React.createElement("uipadding", {
		PaddingTop = padding,
		PaddingBottom = padding,
		PaddingLeft = padding,
		PaddingRight = padding,
	})
end
return {
	Padding = Padding,
}
