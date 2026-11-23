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
local function toScreenTextSize(size, scale)
	local screenSize = math.clamp(size, 1, 100) * scale
	if screenSize > 100 then
		return nil
	end
	return math.max(screenSize, 1)
end
local function toScreenTextSizeRange(minTextSize, maxTextSize, scale)
	local screenMin = math.clamp(minTextSize * scale, 1, 100)
	return { screenMin, math.clamp(maxTextSize * scale, screenMin, 100) }
end
return {
	toDesignPixels = toDesignPixels,
	toScreenPixels = toScreenPixels,
	toScreenTextSize = toScreenTextSize,
	toScreenTextSizeRange = toScreenTextSizeRange,
}
