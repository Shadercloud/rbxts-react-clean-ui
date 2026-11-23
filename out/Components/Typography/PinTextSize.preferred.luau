-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local useIgnorePreferredTextSize = _Contexts.useIgnorePreferredTextSize
local useUiScale = _Contexts.useUiScale
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local TypographyHelper = _Helpers.TypographyHelper
local toScreenTextSize = _Helpers.toScreenTextSize
local toScreenTextSizeRange = _Helpers.toScreenTextSizeRange
local function usePinsPreferredTextSize(scaled)
	local ignorePreferredTextSize = useIgnorePreferredTextSize()
	return ignorePreferredTextSize and scaled ~= true
end
local function usePreferredTextSizePin(size, scaled, minTextSize, maxTextSize)
	local pinned = usePinsPreferredTextSize(scaled)
	local uiScale = useUiScale()
	if not pinned then
		return nil
	end
	local textSize = TypographyHelper:toTextSize(size)
	if textSize == nil then
		return nil
	end
	local _condition = minTextSize
	if _condition == nil then
		_condition = 1
	end
	local _condition_1 = maxTextSize
	if _condition_1 == nil then
		_condition_1 = 100
	end
	return toScreenTextSize(math.clamp(textSize, _condition, _condition_1), uiScale)
end
local function PreferredTextSizePin(props)
	local uiScale = useUiScale()
	local size = usePreferredTextSizePin(props.size, props.scaled, props.minTextSize, props.maxTextSize)
	if size == nil then
		return nil
	end
	local _condition = props.minTextSize
	if _condition == nil then
		_condition = 1
	end
	local minTextSize = _condition
	local _condition_1 = props.maxTextSize
	if _condition_1 == nil then
		_condition_1 = 100
	end
	local maxTextSize = _condition_1
	local shrinkScale = props.shrinkScale
	local pin = function(scale)
		return math.max(size * scale, 1)
	end
	local bounds = function(textScaled, scale)
		return if textScaled then toScreenTextSizeRange(minTextSize, maxTextSize, uiScale * scale) else { pin(scale), pin(scale) }
	end
	local scaled = props.scaled
	if scaled == nil or type(scaled) == "boolean" then
		local pinned = if shrinkScale == nil then size else shrinkScale:map(pin)
		return React.createElement("uitextsizeconstraint", {
			key = "PinTextSize",
			MinTextSize = pinned,
			MaxTextSize = pinned,
		})
	end
	local resolved = if shrinkScale == nil then scaled:map(function(value)
		return bounds(value, 1)
	end) else React.joinBindings({
		scaled = scaled,
		shrinkScale = shrinkScale,
	}):map(function(values)
		return bounds(values.scaled, values.shrinkScale)
	end)
	return React.createElement("uitextsizeconstraint", {
		key = "PinTextSize",
		MinTextSize = resolved:map(function(range)
			return range[1]
		end),
		MaxTextSize = resolved:map(function(range)
			return range[2]
		end),
	})
end
return {
	usePinsPreferredTextSize = usePinsPreferredTextSize,
	usePreferredTextSizePin = usePreferredTextSizePin,
	PreferredTextSizePin = PreferredTextSizePin,
}
