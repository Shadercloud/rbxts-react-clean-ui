-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useIgnorePreferredTextSize = TS.import(script, script.Parent.Parent.Parent, "Contexts").useIgnorePreferredTextSize
local TypographyHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").TypographyHelper
local PinTextSize = TS.import(script, script.Parent, "PinTextSize").PinTextSize
local function usePinsPreferredTextSize(scaled)
	local ignorePreferredTextSize = useIgnorePreferredTextSize()
	return ignorePreferredTextSize and scaled ~= true
end
local function PreferredTextSizePin(props)
	local pinned = usePinsPreferredTextSize(props.scaled)
	if not pinned then
		return nil
	end
	local textSize = TypographyHelper:toTextSize(props.size)
	if textSize == nil then
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
	local size = math.clamp(textSize, minTextSize, maxTextSize)
	local scaled = props.scaled
	if scaled == nil or type(scaled) == "boolean" then
		return React.createElement(PinTextSize, {
			size = size,
		})
	end
	return React.createElement("uitextsizeconstraint", {
		key = "PinTextSize",
		MinTextSize = scaled:map(function(value)
			return if value then minTextSize else size
		end),
		MaxTextSize = scaled:map(function(value)
			return if value then maxTextSize else size
		end),
	})
end
return {
	usePinsPreferredTextSize = usePinsPreferredTextSize,
	PreferredTextSizePin = PreferredTextSizePin,
}
