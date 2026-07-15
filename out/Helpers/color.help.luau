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
	function ColorHelper:getIntentColor(theme, intent, key, componentColor, propColor, fallbackColor)
		if propColor ~= nil then
			return propColor
		end
		local selectedIntent = intent or "primary"
		local _condition = componentColor ~= nil and componentColor[selectedIntent] ~= nil
		if _condition then
			local _result = componentColor[selectedIntent]
			if _result ~= nil then
				_result = _result[key]
			end
			_condition = _result ~= nil
		end
		if _condition then
			return componentColor[selectedIntent][key]
		end
		if fallbackColor ~= nil then
			return fallbackColor
		end
		local _result = theme.colors.intents[selectedIntent]
		if _result ~= nil then
			_result = _result[key]
		end
		local _condition_1 = _result
		if _condition_1 == nil then
			_condition_1 = theme.colors.intents.primary[key]
		end
		return _condition_1
	end
end
return {
	ColorHelper = ColorHelper,
}
