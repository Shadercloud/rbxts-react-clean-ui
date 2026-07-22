-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SpacingHelper
local function Padding(props)
	local theme = React.useContext(CleanThemeContext)
	local padding = if props.resolvedPadding ~= nil then props.resolvedPadding else SpacingHelper:GetResolvedPadding(theme, props)
	return React.createElement("uipadding", {
		PaddingTop = UDim.new(0, padding.top),
		PaddingBottom = UDim.new(0, padding.bottom),
		PaddingLeft = UDim.new(0, padding.left),
		PaddingRight = UDim.new(0, padding.right),
	})
end
return {
	Padding = Padding,
}
