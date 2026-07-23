-- Compiled with roblox-ts v3.0.0
local ColorHelper
do
	ColorHelper = setmetatable({}, {
		__tostring = function()
			return "ColorHelper"
		end,
	})
	ColorHelper.__index = ColorHelper
	function ColorHelper.new(...)
		local self = setmetatable({}, ColorHelper)
		return self:constructor(...) or self
	end
	function ColorHelper:constructor()
	end
	function ColorHelper:getIntentColors(theme, intent, state, componentColors)
		if state == nil then
			state = "default"
		end
		local selectedIntent = intent or "primary"
		local defaultPrimary = theme.colors.intents.primary
		local defaultMatching = theme.colors.intents[selectedIntent]
		local _componentPrimary = componentColors
		if _componentPrimary ~= nil then
			_componentPrimary = _componentPrimary.primary
		end
		local componentPrimary = _componentPrimary
		local _componentMatching = componentColors
		if _componentMatching ~= nil then
			_componentMatching = _componentMatching[selectedIntent]
		end
		local componentMatching = _componentMatching
		local _object = table.clone(defaultPrimary.default)
		setmetatable(_object, nil)
		local _condition = defaultPrimary[state]
		if _condition == nil then
			_condition = {}
		end
		for _k, _v in _condition do
			_object[_k] = _v
		end
		for _k, _v in defaultMatching.default do
			_object[_k] = _v
		end
		local _condition_1 = defaultMatching[state]
		if _condition_1 == nil then
			_condition_1 = {}
		end
		for _k, _v in _condition_1 do
			_object[_k] = _v
		end
		local _result = componentPrimary
		if _result ~= nil then
			_result = _result.default
		end
		local _condition_2 = _result
		if _condition_2 == nil then
			_condition_2 = {}
		end
		for _k, _v in _condition_2 do
			_object[_k] = _v
		end
		local _result_1 = componentPrimary
		if _result_1 ~= nil then
			_result_1 = _result_1[state]
		end
		local _condition_3 = _result_1
		if _condition_3 == nil then
			_condition_3 = {}
		end
		for _k, _v in _condition_3 do
			_object[_k] = _v
		end
		local _result_2 = componentMatching
		if _result_2 ~= nil then
			_result_2 = _result_2.default
		end
		local _condition_4 = _result_2
		if _condition_4 == nil then
			_condition_4 = {}
		end
		for _k, _v in _condition_4 do
			_object[_k] = _v
		end
		local _result_3 = componentMatching
		if _result_3 ~= nil then
			_result_3 = _result_3[state]
		end
		local _condition_5 = _result_3
		if _condition_5 == nil then
			_condition_5 = {}
		end
		for _k, _v in _condition_5 do
			_object[_k] = _v
		end
		return _object
	end
end
return {
	ColorHelper = ColorHelper,
}
