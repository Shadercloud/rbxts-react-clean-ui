-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local CssHelper = TS.import(script, script.Parent, "css.helper").CssHelper
local SpacingHelper
do
	SpacingHelper = setmetatable({}, {
		__tostring = function()
			return "SpacingHelper"
		end,
	})
	SpacingHelper.__index = SpacingHelper
	function SpacingHelper.new(...)
		local self = setmetatable({}, SpacingHelper)
		return self:constructor(...) or self
	end
	function SpacingHelper:constructor()
	end
	function SpacingHelper:GetPadding(theme, spacing, component)
		if spacing == "None" then
			return 0
		end
		local key = spacing or theme.default.spacing
		local _result = component
		if _result ~= nil then
			_result = _result[key]
		end
		local _condition = _result
		if _condition == nil then
			_condition = theme.spacing[key]
			if _condition == nil then
				_condition = 0
			end
		end
		return _condition
	end
	function SpacingHelper:GetResolvedPadding(theme, props, componentSpacing, componentPadding, defaultSpacing)
		if props.resolvedPadding ~= nil then
			return props.resolvedPadding
		end
		local isNone = props.spacing == "None"
		local key = if props.spacing ~= nil and props.spacing ~= "None" then props.spacing else (defaultSpacing or theme.default.spacing)
		-- tier 3: a scale-indexed map picks the quad for the active key
		-- (falling through to tiers 1/2 if that key isn't defined in the
		-- map); a plain quad applies regardless of key.
		local _result
		if isNone or componentPadding == nil then
			_result = nil
		else
			local _componentPadding = componentPadding
			_result = if type(_componentPadding) == "table" then componentPadding[key] else componentPadding
		end
		local quadForKey = _result
		local base = if quadForKey ~= nil then CssHelper:parseCssQuad(quadForKey) else self:ResolveNumberPadding(if isNone then 0 else self:GetPadding(theme, key, componentSpacing))
		local instanceQuad = if props.padding ~= nil then CssHelper:parseCssQuad(props.padding) else nil
		local _object = {}
		local _left = "top"
		local _result_1
		if props.top ~= nil then
			_result_1 = self:GetPadding(theme, props.top, componentSpacing)
		else
			local _result_2 = instanceQuad
			if _result_2 ~= nil then
				_result_2 = _result_2.top
			end
			local _condition = _result_2
			if _condition == nil then
				_condition = base.top
			end
			_result_1 = _condition
		end
		_object[_left] = _result_1
		local _left_1 = "bottom"
		local _result_2
		if props.bottom ~= nil then
			_result_2 = self:GetPadding(theme, props.bottom, componentSpacing)
		else
			local _result_3 = instanceQuad
			if _result_3 ~= nil then
				_result_3 = _result_3.bottom
			end
			local _condition = _result_3
			if _condition == nil then
				_condition = base.bottom
			end
			_result_2 = _condition
		end
		_object[_left_1] = _result_2
		local _left_2 = "left"
		local _result_3
		if props.left ~= nil then
			_result_3 = self:GetPadding(theme, props.left, componentSpacing)
		else
			local _result_4 = instanceQuad
			if _result_4 ~= nil then
				_result_4 = _result_4.left
			end
			local _condition = _result_4
			if _condition == nil then
				_condition = base.left
			end
			_result_3 = _condition
		end
		_object[_left_2] = _result_3
		local _left_3 = "right"
		local _result_4
		if props.right ~= nil then
			_result_4 = self:GetPadding(theme, props.right, componentSpacing)
		else
			local _result_5 = instanceQuad
			if _result_5 ~= nil then
				_result_5 = _result_5.right
			end
			local _condition = _result_5
			if _condition == nil then
				_condition = base.right
			end
			_result_4 = _condition
		end
		_object[_left_3] = _result_4
		return _object
	end
	function SpacingHelper:ResolveNumberPadding(value)
		return {
			top = value,
			bottom = value,
			left = value,
			right = value,
		}
	end
end
return {
	SpacingHelper = SpacingHelper,
}
