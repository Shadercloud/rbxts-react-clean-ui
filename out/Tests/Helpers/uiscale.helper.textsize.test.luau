-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local Decorators = _lunit.Decorators
local _uiscale_helper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "uiscale.helper")
local toScreenTextSize = _uiscale_helper.toScreenTextSize
local toScreenTextSizeRange = _uiscale_helper.toScreenTextSizeRange
local _binding = Decorators
local Each = _binding.Each
local EPSILON = 1e-9
local function assertApprox(actual, expected, label)
	Assert["true"](Assert, math.abs(actual - expected) <= EPSILON, `{label}: expected {expected}, got {actual}`)
end
local UiScaleHelperTextSize
do
	UiScaleHelperTextSize = setmetatable({}, {
		__tostring = function()
			return "UiScaleHelperTextSize"
		end,
	})
	UiScaleHelperTextSize.__index = UiScaleHelperTextSize
	function UiScaleHelperTextSize.new(...)
		local self = setmetatable({}, UiScaleHelperTextSize)
		return self:constructor(...) or self
	end
	function UiScaleHelperTextSize:constructor()
	end
	function UiScaleHelperTextSize:sizeMultiplies(size, scale, expected)
		local actual = toScreenTextSize(size, scale)
		Assert:notUndefined(actual, `Expected toScreenTextSize({size}, {scale}) to pin`)
		assertApprox(actual, expected, `toScreenTextSize({size}, {scale})`)
	end
	function UiScaleHelperTextSize:exactCapPins(size, scale)
		local actual = toScreenTextSize(size, scale)
		Assert:notUndefined(actual, `Expected toScreenTextSize({size}, {scale}) to pin at the cap`)
		assertApprox(actual, 100, `toScreenTextSize({size}, {scale})`)
	end
	function UiScaleHelperTextSize:aboveCapUndefined(size, scale)
		Assert:undefined(toScreenTextSize(size, scale), `Expected toScreenTextSize({size}, {scale}) to skip the pin`)
	end
	function UiScaleHelperTextSize:clampsBeforeScale(size, scale, expected)
		local actual = toScreenTextSize(size, scale)
		Assert:notUndefined(actual, `Expected toScreenTextSize({size}, {scale}) to pin`)
		assertApprox(actual, expected, `toScreenTextSize({size}, {scale})`)
	end
	function UiScaleHelperTextSize:clampedThenCapped(size, scale)
		Assert:undefined(toScreenTextSize(size, scale), `Expected toScreenTextSize({size}, {scale}) to skip the pin`)
	end
	function UiScaleHelperTextSize:floorsAtOne(size, scale)
		local actual = toScreenTextSize(size, scale)
		Assert:notUndefined(actual, `Expected toScreenTextSize({size}, {scale}) to pin`)
		assertApprox(actual, 1, `toScreenTextSize({size}, {scale})`)
	end
	function UiScaleHelperTextSize:rangeScales(minTextSize, maxTextSize, scale, expectedMin, expectedMax)
		local _binding_1 = toScreenTextSizeRange(minTextSize, maxTextSize, scale)
		local actualMin = _binding_1[1]
		local actualMax = _binding_1[2]
		assertApprox(actualMin, expectedMin, `min of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
		assertApprox(actualMax, expectedMax, `max of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
	end
	function UiScaleHelperTextSize:rangeClampsEdges(minTextSize, maxTextSize, scale, expectedMin, expectedMax)
		local _binding_1 = toScreenTextSizeRange(minTextSize, maxTextSize, scale)
		local actualMin = _binding_1[1]
		local actualMax = _binding_1[2]
		assertApprox(actualMin, expectedMin, `min of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
		assertApprox(actualMax, expectedMax, `max of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
	end
	function UiScaleHelperTextSize:rangeMaxFollowsMin(minTextSize, maxTextSize, scale, expected)
		local _binding_1 = toScreenTextSizeRange(minTextSize, maxTextSize, scale)
		local actualMin = _binding_1[1]
		local actualMax = _binding_1[2]
		assertApprox(actualMin, expected, `min of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
		assertApprox(actualMax, expected, `max of toScreenTextSizeRange({minTextSize}, {maxTextSize}, {scale})`)
	end
	local _decorator = Each({ { 18, 1, 18 }, { 18, 1.5, 27 }, { 18, 3, 54 }, { 24, 1.25, 30 }, { 14, 0.5, 7 } })
	local _decorator_1 = DisplayName("A design text size is multiplied by the scale")
	local _descriptor = Test(UiScaleHelperTextSize, "sizeMultiplies", {
		value = UiScaleHelperTextSize.sizeMultiplies,
	})
	if _descriptor then
		UiScaleHelperTextSize.sizeMultiplies = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(UiScaleHelperTextSize, "sizeMultiplies", {
		value = UiScaleHelperTextSize.sizeMultiplies,
	})
	if _descriptor_1 then
		UiScaleHelperTextSize.sizeMultiplies = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(UiScaleHelperTextSize, "sizeMultiplies", {
		value = UiScaleHelperTextSize.sizeMultiplies,
	})
	if _descriptor_2 then
		UiScaleHelperTextSize.sizeMultiplies = _descriptor_2.value
	end
	local _decorator_2 = Each({ { 100, 1 }, { 50, 2 }, { 40, 2.5 }, { 20, 5 } })
	local _decorator_3 = DisplayName("A product of exactly 100 is still returned as 100")
	local _descriptor_3 = Test(UiScaleHelperTextSize, "exactCapPins", {
		value = UiScaleHelperTextSize.exactCapPins,
	})
	if _descriptor_3 then
		UiScaleHelperTextSize.exactCapPins = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(UiScaleHelperTextSize, "exactCapPins", {
		value = UiScaleHelperTextSize.exactCapPins,
	})
	if _descriptor_4 then
		UiScaleHelperTextSize.exactCapPins = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(UiScaleHelperTextSize, "exactCapPins", {
		value = UiScaleHelperTextSize.exactCapPins,
	})
	if _descriptor_5 then
		UiScaleHelperTextSize.exactCapPins = _descriptor_5.value
	end
	local _decorator_4 = Each({ { 48, 3 }, { 96, 3 }, { 34, 3 }, { 60, 2 }, { 100, 1.01 } })
	local _decorator_5 = DisplayName("A product above 100 returns undefined instead of a capped size")
	local _descriptor_6 = Test(UiScaleHelperTextSize, "aboveCapUndefined", {
		value = UiScaleHelperTextSize.aboveCapUndefined,
	})
	if _descriptor_6 then
		UiScaleHelperTextSize.aboveCapUndefined = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(UiScaleHelperTextSize, "aboveCapUndefined", {
		value = UiScaleHelperTextSize.aboveCapUndefined,
	})
	if _descriptor_7 then
		UiScaleHelperTextSize.aboveCapUndefined = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(UiScaleHelperTextSize, "aboveCapUndefined", {
		value = UiScaleHelperTextSize.aboveCapUndefined,
	})
	if _descriptor_8 then
		UiScaleHelperTextSize.aboveCapUndefined = _descriptor_8.value
	end
	local _decorator_6 = Each({ { 150, 1, 100 }, { 150, 0.5, 50 }, { 0, 1, 1 }, { -5, 2, 2 } })
	local _decorator_7 = DisplayName("The design size is clamped to 1-100 before the scale is applied")
	local _descriptor_9 = Test(UiScaleHelperTextSize, "clampsBeforeScale", {
		value = UiScaleHelperTextSize.clampsBeforeScale,
	})
	if _descriptor_9 then
		UiScaleHelperTextSize.clampsBeforeScale = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(UiScaleHelperTextSize, "clampsBeforeScale", {
		value = UiScaleHelperTextSize.clampsBeforeScale,
	})
	if _descriptor_10 then
		UiScaleHelperTextSize.clampsBeforeScale = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(UiScaleHelperTextSize, "clampsBeforeScale", {
		value = UiScaleHelperTextSize.clampsBeforeScale,
	})
	if _descriptor_11 then
		UiScaleHelperTextSize.clampsBeforeScale = _descriptor_11.value
	end
	local _decorator_8 = Each({ { 150, 2 }, { 200, 1.5 } })
	local _decorator_9 = DisplayName("An oversized design size clamped to 100 still exceeds the cap once scaled up")
	local _descriptor_12 = Test(UiScaleHelperTextSize, "clampedThenCapped", {
		value = UiScaleHelperTextSize.clampedThenCapped,
	})
	if _descriptor_12 then
		UiScaleHelperTextSize.clampedThenCapped = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(UiScaleHelperTextSize, "clampedThenCapped", {
		value = UiScaleHelperTextSize.clampedThenCapped,
	})
	if _descriptor_13 then
		UiScaleHelperTextSize.clampedThenCapped = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(UiScaleHelperTextSize, "clampedThenCapped", {
		value = UiScaleHelperTextSize.clampedThenCapped,
	})
	if _descriptor_14 then
		UiScaleHelperTextSize.clampedThenCapped = _descriptor_14.value
	end
	local _decorator_10 = Each({ { 1, 0.5 }, { 10, 0.05 }, { 3, 0.25 } })
	local _decorator_11 = DisplayName("A scaled size below 1 is raised to the 1px floor")
	local _descriptor_15 = Test(UiScaleHelperTextSize, "floorsAtOne", {
		value = UiScaleHelperTextSize.floorsAtOne,
	})
	if _descriptor_15 then
		UiScaleHelperTextSize.floorsAtOne = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(UiScaleHelperTextSize, "floorsAtOne", {
		value = UiScaleHelperTextSize.floorsAtOne,
	})
	if _descriptor_16 then
		UiScaleHelperTextSize.floorsAtOne = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(UiScaleHelperTextSize, "floorsAtOne", {
		value = UiScaleHelperTextSize.floorsAtOne,
	})
	if _descriptor_17 then
		UiScaleHelperTextSize.floorsAtOne = _descriptor_17.value
	end
	local _decorator_12 = Each({ { 1, 100, 1, 1, 100 }, { 10, 30, 1.5, 15, 45 }, { 12, 24, 1.25, 15, 30 }, { 10, 40, 3, 30, 100 }, { 1, 100, 0.5, 1, 50 } })
	local _decorator_13 = DisplayName("Both ends of the range are scaled and the top is capped at 100")
	local _descriptor_18 = Test(UiScaleHelperTextSize, "rangeScales", {
		value = UiScaleHelperTextSize.rangeScales,
	})
	if _descriptor_18 then
		UiScaleHelperTextSize.rangeScales = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(UiScaleHelperTextSize, "rangeScales", {
		value = UiScaleHelperTextSize.rangeScales,
	})
	if _descriptor_19 then
		UiScaleHelperTextSize.rangeScales = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(UiScaleHelperTextSize, "rangeScales", {
		value = UiScaleHelperTextSize.rangeScales,
	})
	if _descriptor_20 then
		UiScaleHelperTextSize.rangeScales = _descriptor_20.value
	end
	local _decorator_14 = Each({ { 40, 60, 3, 100, 100 }, { 2, 4, 0.25, 1, 1 }, { 0, 0, 1, 1, 1 } })
	local _decorator_15 = DisplayName("A range pushed past either edge collapses onto 1 or 100")
	local _descriptor_21 = Test(UiScaleHelperTextSize, "rangeClampsEdges", {
		value = UiScaleHelperTextSize.rangeClampsEdges,
	})
	if _descriptor_21 then
		UiScaleHelperTextSize.rangeClampsEdges = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(UiScaleHelperTextSize, "rangeClampsEdges", {
		value = UiScaleHelperTextSize.rangeClampsEdges,
	})
	if _descriptor_22 then
		UiScaleHelperTextSize.rangeClampsEdges = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(UiScaleHelperTextSize, "rangeClampsEdges", {
		value = UiScaleHelperTextSize.rangeClampsEdges,
	})
	if _descriptor_23 then
		UiScaleHelperTextSize.rangeClampsEdges = _descriptor_23.value
	end
	local _decorator_16 = Each({ { 30, 20, 1, 30 }, { 50, 10, 2, 100 } })
	local _decorator_17 = DisplayName("A max below the scaled min is raised to the min")
	local _descriptor_24 = Test(UiScaleHelperTextSize, "rangeMaxFollowsMin", {
		value = UiScaleHelperTextSize.rangeMaxFollowsMin,
	})
	if _descriptor_24 then
		UiScaleHelperTextSize.rangeMaxFollowsMin = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(UiScaleHelperTextSize, "rangeMaxFollowsMin", {
		value = UiScaleHelperTextSize.rangeMaxFollowsMin,
	})
	if _descriptor_25 then
		UiScaleHelperTextSize.rangeMaxFollowsMin = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(UiScaleHelperTextSize, "rangeMaxFollowsMin", {
		value = UiScaleHelperTextSize.rangeMaxFollowsMin,
	})
	if _descriptor_26 then
		UiScaleHelperTextSize.rangeMaxFollowsMin = _descriptor_26.value
	end
	UiScaleHelperTextSize = Tag("Lune")(UiScaleHelperTextSize) or UiScaleHelperTextSize
end
return UiScaleHelperTextSize
