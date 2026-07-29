-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local DefaultTheme = TS.import(script, script.Parent, "themes", "default.theme").DefaultTheme
local function isRecord(value)
	local _value = value
	return type(_value) == "table"
end
local function deepMerge(base, overrides)
	local _object = {}
	if base then
		for _k, _v in base do
			_object[_k] = _v
		end
	end
	local result = _object
	local overrideRecord = overrides
	for key, overrideValue in pairs(overrideRecord) do
		local baseValue = result[key]
		if isRecord(baseValue) and isRecord(overrideValue) then
			result[key] = deepMerge(baseValue, overrideValue)
		elseif overrideValue ~= nil then
			result[key] = overrideValue
		end
	end
	return result
end
local function createTheme(overrides)
	if overrides == nil then
		overrides = {}
	end
	return deepMerge(DefaultTheme, overrides)
end
local function extendTheme(baseTheme, overrides)
	return deepMerge(baseTheme, overrides)
end
return {
	createTheme = createTheme,
	extendTheme = extendTheme,
}
