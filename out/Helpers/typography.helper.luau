-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local ScaleSizes = TS.import(script, script.Parent.Parent, "Interfaces").ScaleSizes
local TypographyHelper
do
	TypographyHelper = setmetatable({}, {
		__tostring = function()
			return "TypographyHelper"
		end,
	})
	TypographyHelper.__index = TypographyHelper
	function TypographyHelper.new(...)
		local self = setmetatable({}, TypographyHelper)
		return self:constructor(...) or self
	end
	function TypographyHelper:constructor()
	end
	function TypographyHelper:getTypography(theme, scale, component)
		local resolvedScale = scale or theme.default.scale
		local _object = table.clone(theme.typography[theme.typeScaleMap[resolvedScale]])
		setmetatable(_object, nil)
		local typography = _object
		if component == nil then
			return typography
		end
		local componentTypography = if self:isScaledTypographyStyle(component) then self:getClosestTypography(component, resolvedScale) else component
		if componentTypography ~= nil then
			local _object_1 = table.clone(typography)
			setmetatable(_object_1, nil)
			for _k, _v in componentTypography do
				_object_1[_k] = _v
			end
			typography = _object_1
		end
		return typography
	end
	function TypographyHelper:getClosestTypography(typography, scale)
		local _scale = scale
		local scaleIndex = (table.find(ScaleSizes, _scale) or 0) - 1
		-- Prefer the exact scale, then progressively smaller scales.
		do
			local index = scaleIndex
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					index -= 1
				else
					_shouldIncrement = true
				end
				if not (index >= 0) then
					break
				end
				local value = typography[ScaleSizes[index + 1]]
				if value ~= nil then
					return value
				end
			end
		end
		-- If no smaller scale exists, use the nearest larger scale.
		do
			local index = scaleIndex + 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					index += 1
				else
					_shouldIncrement = true
				end
				if not (index < #ScaleSizes) then
					break
				end
				local value = typography[ScaleSizes[index + 1]]
				if value ~= nil then
					return value
				end
			end
		end
		return nil
	end
	function TypographyHelper:isScaledTypographyStyle(value)
		for _, key in ScaleSizes do
			if value[key] ~= nil then
				return true
			end
		end
		return false
	end
end
return {
	TypographyHelper = TypographyHelper,
}
