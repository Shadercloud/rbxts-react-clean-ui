-- Compiled with roblox-ts v3.0.0
local function toDesignPixels(value, scale)
	local _value = value
	if type(_value) == "number" then
		return value / scale
	end
	local _value_1 = value
	local _scale = scale
	return _value_1 / _scale
end
local function toScreenPixels(value, scale)
	local _value = value
	if type(_value) == "number" then
		return value * scale
	end
	local _value_1 = value
	local _scale = scale
	return _value_1 * _scale
end
return {
	toDesignPixels = toDesignPixels,
	toScreenPixels = toScreenPixels,
}
