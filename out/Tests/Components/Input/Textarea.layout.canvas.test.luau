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
local resolveTextareaCanvasHeight = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea.layout").resolveTextareaCanvasHeight
local VIEWPORT = 160
local PADDING = 12
local TextareaCanvasTolerance
do
	TextareaCanvasTolerance = setmetatable({}, {
		__tostring = function()
			return "TextareaCanvasTolerance"
		end,
	})
	TextareaCanvasTolerance.__index = TextareaCanvasTolerance
	function TextareaCanvasTolerance.new(...)
		local self = setmetatable({}, TextareaCanvasTolerance)
		return self:constructor(...) or self
	end
	function TextareaCanvasTolerance:constructor()
	end
	function TextareaCanvasTolerance:scaledTolerance(scale, content, expected)
		Assert:equal(resolveTextareaCanvasHeight(content, 0, 0, VIEWPORT, scale), expected)
	end
	function TextareaCanvasTolerance:threeQuarterTolerance()
		Assert:equal(resolveTextareaCanvasHeight(VIEWPORT + 4 / 3, 0, 0, VIEWPORT, 0.75), VIEWPORT)
		Assert:equal(resolveTextareaCanvasHeight(VIEWPORT + 4 / 3 + 0.01, 0, 0, VIEWPORT, 0.75), VIEWPORT + 4 / 3 + 0.01)
	end
	function TextareaCanvasTolerance:badScale(scale)
		Assert:equal(resolveTextareaCanvasHeight(160.9, 0, 0, VIEWPORT, scale), VIEWPORT)
		Assert:equal(resolveTextareaCanvasHeight(161, 0, 0, VIEWPORT, scale), VIEWPORT)
		Assert:equal(resolveTextareaCanvasHeight(161.5, 0, 0, VIEWPORT, scale), 161.5)
	end
	function TextareaCanvasTolerance:fourArgsMatch(textHeight)
		Assert:equal(resolveTextareaCanvasHeight(textHeight, PADDING, PADDING, VIEWPORT), resolveTextareaCanvasHeight(textHeight, PADDING, PADDING, VIEWPORT, 1))
	end
	function TextareaCanvasTolerance:fourArgsValues()
		Assert:equal(resolveTextareaCanvasHeight(136.75, PADDING, PADDING, VIEWPORT), VIEWPORT)
		Assert:equal(resolveTextareaCanvasHeight(137, PADDING, PADDING, VIEWPORT), VIEWPORT)
		Assert:equal(resolveTextareaCanvasHeight(137.5, PADDING, PADDING, VIEWPORT), 161.5)
	end
	local _decorator = DisplayName("Content within one screen pixel of the view counts as fitting, measured in design px at the given scale")
	local _decorator_1 = Each({ { 1.5, 160.6, 160 }, { 1.5, 160.7, 160.7 }, { 0.75, 161.3, 160 }, { 0.75, 161.4, 161.4 }, { 1, 161, 160 }, { 1, 161.5, 161.5 } })
	local _descriptor = Test(TextareaCanvasTolerance, "scaledTolerance", {
		value = TextareaCanvasTolerance.scaledTolerance,
	})
	if _descriptor then
		TextareaCanvasTolerance.scaledTolerance = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaCanvasTolerance, "scaledTolerance", {
		value = TextareaCanvasTolerance.scaledTolerance,
	})
	if _descriptor_1 then
		TextareaCanvasTolerance.scaledTolerance = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaCanvasTolerance, "scaledTolerance", {
		value = TextareaCanvasTolerance.scaledTolerance,
	})
	if _descriptor_2 then
		TextareaCanvasTolerance.scaledTolerance = _descriptor_2.value
	end
	local _decorator_2 = DisplayName("At scale 0.75 the fitting tolerance is four thirds of a design pixel")
	local _descriptor_3 = Test(TextareaCanvasTolerance, "threeQuarterTolerance", {
		value = TextareaCanvasTolerance.threeQuarterTolerance,
	})
	if _descriptor_3 then
		TextareaCanvasTolerance.threeQuarterTolerance = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_2(TextareaCanvasTolerance, "threeQuarterTolerance", {
		value = TextareaCanvasTolerance.threeQuarterTolerance,
	})
	if _descriptor_4 then
		TextareaCanvasTolerance.threeQuarterTolerance = _descriptor_4.value
	end
	local _decorator_3 = DisplayName("A zero, negative or NaN screen scale uses a one design pixel tolerance")
	local _decorator_4 = Each({ { 0 }, { -2 }, { 0 / 0 } })
	local _descriptor_5 = Test(TextareaCanvasTolerance, "badScale", {
		value = TextareaCanvasTolerance.badScale,
	})
	if _descriptor_5 then
		TextareaCanvasTolerance.badScale = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(TextareaCanvasTolerance, "badScale", {
		value = TextareaCanvasTolerance.badScale,
	})
	if _descriptor_6 then
		TextareaCanvasTolerance.badScale = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(TextareaCanvasTolerance, "badScale", {
		value = TextareaCanvasTolerance.badScale,
	})
	if _descriptor_7 then
		TextareaCanvasTolerance.badScale = _descriptor_7.value
	end
	local _decorator_5 = DisplayName("Four-argument calls match an explicit scale of one with padding included")
	local _decorator_6 = Each({ { 136.75 }, { 137 }, { 137.5 }, { 200 }, { 0 } })
	local _descriptor_8 = Test(TextareaCanvasTolerance, "fourArgsMatch", {
		value = TextareaCanvasTolerance.fourArgsMatch,
	})
	if _descriptor_8 then
		TextareaCanvasTolerance.fourArgsMatch = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(TextareaCanvasTolerance, "fourArgsMatch", {
		value = TextareaCanvasTolerance.fourArgsMatch,
	})
	if _descriptor_9 then
		TextareaCanvasTolerance.fourArgsMatch = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(TextareaCanvasTolerance, "fourArgsMatch", {
		value = TextareaCanvasTolerance.fourArgsMatch,
	})
	if _descriptor_10 then
		TextareaCanvasTolerance.fourArgsMatch = _descriptor_10.value
	end
	local _decorator_7 = DisplayName("Four-argument calls still fit content up to one pixel over the view and grow past it")
	local _descriptor_11 = Test(TextareaCanvasTolerance, "fourArgsValues", {
		value = TextareaCanvasTolerance.fourArgsValues,
	})
	if _descriptor_11 then
		TextareaCanvasTolerance.fourArgsValues = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TextareaCanvasTolerance, "fourArgsValues", {
		value = TextareaCanvasTolerance.fourArgsValues,
	})
	if _descriptor_12 then
		TextareaCanvasTolerance.fourArgsValues = _descriptor_12.value
	end
	TextareaCanvasTolerance = Tag("Lune")(TextareaCanvasTolerance) or TextareaCanvasTolerance
end
return TextareaCanvasTolerance
