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
	function ColorHelper:getIntentColors(theme, intent, state, componentColors, overrideColors)
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
		local _overridePrimary = overrideColors
		if _overridePrimary ~= nil then
			_overridePrimary = _overridePrimary.primary
		end
		local overridePrimary = _overridePrimary
		local _overrideMatching = overrideColors
		if _overrideMatching ~= nil then
			_overrideMatching = _overrideMatching[selectedIntent]
		end
		local overrideMatching = _overrideMatching
		local _exp = defaultPrimary.default
		local _result = defaultMatching
		if _result ~= nil then
			_result = _result.default
		end
		local _exp_1 = defaultPrimary[state]
		local _result_1 = defaultMatching
		if _result_1 ~= nil then
			_result_1 = _result_1[state]
		end
		local layers = { _exp, _result, _exp_1, _result_1, self:resolveComponentDefaultLayer(componentPrimary), self:resolveComponentDefaultLayer(componentMatching), self:resolveComponentStateLayer(componentPrimary, state), self:resolveComponentStateLayer(componentMatching, state), self:resolveComponentDefaultLayer(overridePrimary), self:resolveComponentDefaultLayer(overrideMatching), self:resolveComponentStateLayer(overridePrimary, state), self:resolveComponentStateLayer(overrideMatching, state) }
		return self:mergeLayers(layers)
	end
	function ColorHelper:mergeLayers(layers)
		local merged = {}
		local backgroundImage
		local backgroundGradient
		local typography
		for _, layer in layers do
			if layer == nil then
				continue
			end
			local _object = table.clone(merged)
			setmetatable(_object, nil)
			for _k, _v in layer do
				_object[_k] = _v
			end
			merged = _object
			if layer.backgroundImage ~= nil then
				local _object_1 = {}
				if backgroundImage then
					for _k, _v in backgroundImage do
						_object_1[_k] = _v
					end
				end
				for _k, _v in layer.backgroundImage do
					_object_1[_k] = _v
				end
				backgroundImage = _object_1
			end
			if layer.backgroundGradient ~= nil then
				local _result
				if layer.backgroundGradient.colors ~= nil then
					local _object_1 = {}
					if backgroundGradient then
						for _k, _v in backgroundGradient do
							_object_1[_k] = _v
						end
					end
					_object_1.stops = nil
					_result = _object_1
				else
					_result = backgroundGradient
				end
				local inheritedGradient = _result
				local _object_1 = {}
				if inheritedGradient then
					for _k, _v in inheritedGradient do
						_object_1[_k] = _v
					end
				end
				for _k, _v in layer.backgroundGradient do
					_object_1[_k] = _v
				end
				backgroundGradient = _object_1
			end
			if layer.typography ~= nil then
				local _object_1 = {}
				if typography then
					for _k, _v in typography do
						_object_1[_k] = _v
					end
				end
				for _k, _v in layer.typography do
					_object_1[_k] = _v
				end
				typography = _object_1
			end
		end
		merged.backgroundImage = backgroundImage
		merged.backgroundGradient = backgroundGradient
		merged.typography = typography
		return merged
	end
	function ColorHelper:resolveComponentDefaultLayer(colors)
		if colors == nil then
			return nil
		end
		if self:isInlineIntentColors(colors) then
			return colors.default
		end
		return colors
	end
	function ColorHelper:resolveComponentStateLayer(colors, state)
		if colors == nil or not self:isInlineIntentColors(colors) then
			return nil
		end
		return colors[state]
	end
	function ColorHelper:isInlineIntentColors(colors)
		local statefulColors = colors
		return statefulColors.default ~= nil or statefulColors.hover ~= nil or statefulColors.focus ~= nil
	end
end
return {
	ColorHelper = ColorHelper,
}
