-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CssHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").CssHelper
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function BoxShadow(props)
	local theme = React.useContext(CleanThemeContext)
	local shadowTheme = theme.components.boxShadow
	local _condition = props["box-shadow"]
	if _condition == nil then
		_condition = props.value
	end
	local shadowValue = _condition
	if shadowValue == nil then
		return nil
	end
	local shadow = CssHelper:parseCssShadow(shadowValue)
	if shadow == nil then
		return nil
	end
	local _attributes = {
		Offset = shadow.offset,
		BlurRadius = shadow.blurRadius,
		Spread = shadow.spread,
		Color = props.color or shadowTheme.color,
	}
	local _condition_1 = props.transparency
	if _condition_1 == nil then
		_condition_1 = shadowTheme.transparency
	end
	_attributes.Transparency = _condition_1
	local _condition_2 = props.zindex
	if _condition_2 == nil then
		_condition_2 = -1
	end
	_attributes.ZIndex = _condition_2
	return React.createElement("uishadow", _attributes)
end
return {
	BoxShadow = BoxShadow,
}
