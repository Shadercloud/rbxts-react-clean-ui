-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SpacingHelper
local function Padding(props)
	local theme = React.useContext(CleanThemeContext)
	local padding = SpacingHelper:GetResolvedPadding(theme, props)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Padding"
	end
	_attributes.key = _condition
	_attributes.PaddingTop = UDim.new(0, padding.top)
	_attributes.PaddingBottom = UDim.new(0, padding.bottom)
	_attributes.PaddingLeft = UDim.new(0, padding.left)
	_attributes.PaddingRight = UDim.new(0, padding.right)
	return React.createElement("uipadding", _attributes)
end
return {
	Padding = Padding,
}
