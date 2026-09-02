-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CssHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").CssHelper
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function BoxShadow(props)
	local shadowProps
	if props.completeShadow then
		shadowProps = CssHelper:ResolveShadow(props.completeShadow)
	else
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
		local _object = {}
		local _left = "Offset"
		local _result = shadow
		if _result ~= nil then
			_result = _result.offset
		end
		_object[_left] = _result
		local _left_1 = "BlurRadius"
		local _result_1 = shadow
		if _result_1 ~= nil then
			_result_1 = _result_1.blurRadius
		end
		_object[_left_1] = _result_1
		local _left_2 = "Spread"
		local _result_2 = shadow
		if _result_2 ~= nil then
			_result_2 = _result_2.spread
		end
		_object[_left_2] = _result_2
		_object.Color = props.color or shadowTheme.color
		local _left_3 = "Transparency"
		local _condition_1 = props.transparency
		if _condition_1 == nil then
			_condition_1 = shadowTheme.transparency
		end
		_object[_left_3] = _condition_1
		shadowProps = _object
	end
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "BoxShadow"
	end
	_attributes.key = _condition
	for _k, _v in shadowProps do
		_attributes[_k] = _v
	end
	local _condition_1 = props.zindex
	if _condition_1 == nil then
		_condition_1 = -1
	end
	_attributes.ZIndex = _condition_1
	return React.createElement("uishadow", _attributes)
end
return {
	BoxShadow = BoxShadow,
}
