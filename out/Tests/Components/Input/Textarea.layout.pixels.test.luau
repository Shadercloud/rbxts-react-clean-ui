-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Each = _binding.Each
local _Textarea_layout = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea.layout")
local resolveTextareaScreenScale = _Textarea_layout.resolveTextareaScreenScale
local resolveTextareaWholePixels = _Textarea_layout.resolveTextareaWholePixels
local TextareaWholePixels
do
	TextareaWholePixels = setmetatable({}, {
		__tostring = function()
			return "TextareaWholePixels"
		end,
	})
	TextareaWholePixels.__index = TextareaWholePixels
	function TextareaWholePixels.new(...)
		local self = setmetatable({}, TextareaWholePixels)
		return self:constructor(...) or self
	end
	function TextareaWholePixels:constructor()
	end
	function TextareaWholePixels:roundsUp(value, expected)
		Assert:equal(resolveTextareaWholePixels(value), expected)
	end
	function TextareaWholePixels:badValues(value)
		Assert:equal(resolveTextareaWholePixels(value), 0)
	end
	function TextareaWholePixels:snapsToContext(screen, design, context, expected)
		Assert:equal(resolveTextareaScreenScale(screen, design, context), expected)
	end
	function TextareaWholePixels:measuredRatio()
		Assert:equal(resolveTextareaScreenScale(240, 160, 1), 1.5)
	end
	function TextareaWholePixels:unmeasured(screen, design, context, expected)
		Assert:equal(resolveTextareaScreenScale(screen, design, context), expected)
	end
	local _decorator = DisplayName("Fractional sizes round up to the next whole design pixel and whole sizes stay put")
	local _decorator_1 = Each({ { 124.8, 125 }, { 125.0000001, 125 }, { 125, 125 }, { 25.2, 26 }, { 0, 0 } })
	local _descriptor = Test(TextareaWholePixels, "roundsUp", {
		value = TextareaWholePixels.roundsUp,
	})
	if _descriptor then
		TextareaWholePixels.roundsUp = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaWholePixels, "roundsUp", {
		value = TextareaWholePixels.roundsUp,
	})
	if _descriptor_1 then
		TextareaWholePixels.roundsUp = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaWholePixels, "roundsUp", {
		value = TextareaWholePixels.roundsUp,
	})
	if _descriptor_2 then
		TextareaWholePixels.roundsUp = _descriptor_2.value
	end
	local _decorator_2 = DisplayName("Negative, NaN and infinite sizes resolve to zero")
	local _decorator_3 = Each({ { -3 }, { 0 / 0 }, { math.huge }, { -math.huge } })
	local _descriptor_3 = Test(TextareaWholePixels, "badValues", {
		value = TextareaWholePixels.badValues,
	})
	if _descriptor_3 then
		TextareaWholePixels.badValues = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextareaWholePixels, "badValues", {
		value = TextareaWholePixels.badValues,
	})
	if _descriptor_4 then
		TextareaWholePixels.badValues = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextareaWholePixels, "badValues", {
		value = TextareaWholePixels.badValues,
	})
	if _descriptor_5 then
		TextareaWholePixels.badValues = _descriptor_5.value
	end
	local _decorator_4 = DisplayName("A measured height within one pixel of design times context scale returns the context scale")
	local _decorator_5 = Each({ { 124, 124.8, 1, 1 }, { 161, 160, 1, 1 }, { 159, 160, 1, 1 }, { 180.5, 120, 1.5, 1.5 } })
	local _descriptor_6 = Test(TextareaWholePixels, "snapsToContext", {
		value = TextareaWholePixels.snapsToContext,
	})
	if _descriptor_6 then
		TextareaWholePixels.snapsToContext = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextareaWholePixels, "snapsToContext", {
		value = TextareaWholePixels.snapsToContext,
	})
	if _descriptor_7 then
		TextareaWholePixels.snapsToContext = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextareaWholePixels, "snapsToContext", {
		value = TextareaWholePixels.snapsToContext,
	})
	if _descriptor_8 then
		TextareaWholePixels.snapsToContext = _descriptor_8.value
	end
	local _decorator_6 = DisplayName("A measured height more than one pixel off the context scale returns the measured ratio")
	local _descriptor_9 = Test(TextareaWholePixels, "measuredRatio", {
		value = TextareaWholePixels.measuredRatio,
	})
	if _descriptor_9 then
		TextareaWholePixels.measuredRatio = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_6(TextareaWholePixels, "measuredRatio", {
		value = TextareaWholePixels.measuredRatio,
	})
	if _descriptor_10 then
		TextareaWholePixels.measuredRatio = _descriptor_10.value
	end
	local _decorator_7 = DisplayName("Before layout the context scale is used, and a bad context scale resolves to one")
	local _decorator_8 = Each({ { 0, 160, 0.75, 0.75 }, { 100, 0, 0, 1 } })
	local _descriptor_11 = Test(TextareaWholePixels, "unmeasured", {
		value = TextareaWholePixels.unmeasured,
	})
	if _descriptor_11 then
		TextareaWholePixels.unmeasured = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(TextareaWholePixels, "unmeasured", {
		value = TextareaWholePixels.unmeasured,
	})
	if _descriptor_12 then
		TextareaWholePixels.unmeasured = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(TextareaWholePixels, "unmeasured", {
		value = TextareaWholePixels.unmeasured,
	})
	if _descriptor_13 then
		TextareaWholePixels.unmeasured = _descriptor_13.value
	end
	TextareaWholePixels = Tag("Lune")(TextareaWholePixels) or TextareaWholePixels
end
return TextareaWholePixels
