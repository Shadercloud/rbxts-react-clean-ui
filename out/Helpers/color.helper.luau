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
		for _k, _v in self:resolveComponentColors(componentPrimary, state) do
			_object[_k] = _v
		end
		for _k, _v in self:resolveComponentColors(componentMatching, state) do
			_object[_k] = _v
		end
		return _object
	end
	function ColorHelper:resolveComponentColors(colors, state)
		if colors == nil then
			return {}
		end
		if self:isInlineIntentColors(colors) then
			local _object = table.clone((colors.default or {}))
			setmetatable(_object, nil)
			for _k, _v in (colors[state] or {}) do
				_object[_k] = _v
			end
			return _object
		end
		-- A direct Partial<IntentScheme> has no state variants,
		-- so the requested state is ignored.
		return colors
	end
	function ColorHelper:isInlineIntentColors(colors)
		local statefulColors = colors
		return statefulColors.default ~= nil or statefulColors.hover ~= nil or statefulColors.focus ~= nil
	end
end
return {
	ColorHelper = ColorHelper,
}
