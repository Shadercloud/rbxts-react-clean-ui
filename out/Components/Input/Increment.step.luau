-- Compiled with roblox-ts v3.0.0
local ROUNDING_PRECISION = 1e9
local function roundToPrecision(value)
	return if value >= 0 then math.floor(value * ROUNDING_PRECISION + 0.5) / ROUNDING_PRECISION else math.ceil(value * ROUNDING_PRECISION - 0.5) / ROUNDING_PRECISION
end
local function resolveSteppedValue(current, direction, step, min, max)
	if direction == "decrement" and min ~= nil and current <= min then
		return nil
	end
	if direction == "increment" and max ~= nil and current >= max then
		return nil
	end
	local candidate = if direction == "increment" then current + step else current - step
	candidate = roundToPrecision(candidate)
	if min ~= nil and candidate < min then
		candidate = min
	end
	if max ~= nil and candidate > max then
		candidate = max
	end
	return candidate
end
return {
	resolveSteppedValue = resolveSteppedValue,
}
