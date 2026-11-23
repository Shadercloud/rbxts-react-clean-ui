-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _uiscale_helper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "uiscale.helper")
local toDesignPixels = _uiscale_helper.toDesignPixels
local toScreenPixels = _uiscale_helper.toScreenPixels
local STUDIO_SKIP_MESSAGE = TS.import(script, script.Parent, "layout").STUDIO_SKIP_MESSAGE
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local EPSILON = 1e-4
local function assertVectorApprox(actual, expected, label)
	Assert["true"](Assert, math.abs(actual.X - expected.X) <= EPSILON and math.abs(actual.Y - expected.Y) <= EPSILON, `{label}: expected ({expected.X}, {expected.Y}), got ({actual.X}, {actual.Y})`)
end
local UiScaleHelperVector
do
	UiScaleHelperVector = setmetatable({}, {
		__tostring = function()
			return "UiScaleHelperVector"
		end,
	})
	UiScaleHelperVector.__index = UiScaleHelperVector
	function UiScaleHelperVector.new(...)
		local self = setmetatable({}, UiScaleHelperVector)
		return self:constructor(...) or self
	end
	function UiScaleHelperVector:constructor()
	end
	function UiScaleHelperVector:designDivides(x, y, scale, expectedX, expectedY)
		local result = toDesignPixels(Vector2.new(x, y), scale)
		Assert["true"](Assert, typeof(result) == "Vector2", "Expected a Vector2 input to produce a Vector2")
		assertVectorApprox(result, Vector2.new(expectedX, expectedY), `toDesignPixels(({x}, {y}), {scale})`)
	end
	function UiScaleHelperVector:screenMultiplies(x, y, scale, expectedX, expectedY)
		local result = toScreenPixels(Vector2.new(x, y), scale)
		Assert["true"](Assert, typeof(result) == "Vector2", "Expected a Vector2 input to produce a Vector2")
		assertVectorApprox(result, Vector2.new(expectedX, expectedY), `toScreenPixels(({x}, {y}), {scale})`)
	end
	function UiScaleHelperVector:roundTrip(scale)
		local value = Vector2.new(123.5, 77.25)
		assertVectorApprox(toScreenPixels(toDesignPixels(value, scale), scale), value, `round trip at {scale}`)
	end
	function UiScaleHelperVector:zeroStaysZero()
		assertVectorApprox(toDesignPixels(Vector2.zero, 1.5), Vector2.zero, "toDesignPixels(zero)")
		assertVectorApprox(toScreenPixels(Vector2.zero, 1.5), Vector2.zero, "toScreenPixels(zero)")
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { 300, 150, 1.5, 200, 100 }, { 1000, 500, 1.25, 800, 400 }, { 64, 32, 1, 64, 32 } })
	local _decorator_2 = DisplayName("A Vector2 in screen pixels is divided by the scale on both axes")
	local _descriptor = Test(UiScaleHelperVector, "designDivides", {
		value = UiScaleHelperVector.designDivides,
	})
	if _descriptor then
		UiScaleHelperVector.designDivides = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(UiScaleHelperVector, "designDivides", {
		value = UiScaleHelperVector.designDivides,
	})
	if _descriptor_1 then
		UiScaleHelperVector.designDivides = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(UiScaleHelperVector, "designDivides", {
		value = UiScaleHelperVector.designDivides,
	})
	if _descriptor_2 then
		UiScaleHelperVector.designDivides = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(UiScaleHelperVector, "designDivides", {
		value = UiScaleHelperVector.designDivides,
	})
	if _descriptor_3 then
		UiScaleHelperVector.designDivides = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = Each({ { 200, 100, 1.5, 300, 150 }, { 800, 400, 1.25, 1000, 500 }, { 64, 32, 1, 64, 32 } })
	local _decorator_5 = DisplayName("A Vector2 in design pixels is multiplied by the scale on both axes")
	local _descriptor_4 = Test(UiScaleHelperVector, "screenMultiplies", {
		value = UiScaleHelperVector.screenMultiplies,
	})
	if _descriptor_4 then
		UiScaleHelperVector.screenMultiplies = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(UiScaleHelperVector, "screenMultiplies", {
		value = UiScaleHelperVector.screenMultiplies,
	})
	if _descriptor_5 then
		UiScaleHelperVector.screenMultiplies = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(UiScaleHelperVector, "screenMultiplies", {
		value = UiScaleHelperVector.screenMultiplies,
	})
	if _descriptor_6 then
		UiScaleHelperVector.screenMultiplies = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(UiScaleHelperVector, "screenMultiplies", {
		value = UiScaleHelperVector.screenMultiplies,
	})
	if _descriptor_7 then
		UiScaleHelperVector.screenMultiplies = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { 1.25 }, { 1.5 }, { 1.2 } })
	local _decorator_8 = DisplayName("A Vector2 converted to design pixels and back keeps its original components")
	local _descriptor_8 = Test(UiScaleHelperVector, "roundTrip", {
		value = UiScaleHelperVector.roundTrip,
	})
	if _descriptor_8 then
		UiScaleHelperVector.roundTrip = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_8(UiScaleHelperVector, "roundTrip", {
		value = UiScaleHelperVector.roundTrip,
	})
	if _descriptor_9 then
		UiScaleHelperVector.roundTrip = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(UiScaleHelperVector, "roundTrip", {
		value = UiScaleHelperVector.roundTrip,
	})
	if _descriptor_10 then
		UiScaleHelperVector.roundTrip = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(UiScaleHelperVector, "roundTrip", {
		value = UiScaleHelperVector.roundTrip,
	})
	if _descriptor_11 then
		UiScaleHelperVector.roundTrip = _descriptor_11.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Vector2.zero stays zero at any scale")
	local _descriptor_12 = Test(UiScaleHelperVector, "zeroStaysZero", {
		value = UiScaleHelperVector.zeroStaysZero,
	})
	if _descriptor_12 then
		UiScaleHelperVector.zeroStaysZero = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_10(UiScaleHelperVector, "zeroStaysZero", {
		value = UiScaleHelperVector.zeroStaysZero,
	})
	if _descriptor_13 then
		UiScaleHelperVector.zeroStaysZero = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_9(UiScaleHelperVector, "zeroStaysZero", {
		value = UiScaleHelperVector.zeroStaysZero,
	})
	if _descriptor_14 then
		UiScaleHelperVector.zeroStaysZero = _descriptor_14.value
	end
	UiScaleHelperVector = Tag("Studio")(UiScaleHelperVector) or UiScaleHelperVector
end
return UiScaleHelperVector
