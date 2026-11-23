-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local Decorators = _lunit.Decorators
local _uiscale_helper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "uiscale.helper")
local toDesignPixels = _uiscale_helper.toDesignPixels
local toScreenPixels = _uiscale_helper.toScreenPixels
local _binding = Decorators
local Each = _binding.Each
local EPSILON = 1e-9
local function assertApprox(actual, expected, label)
	Assert["true"](Assert, math.abs(actual - expected) <= EPSILON, `{label}: expected {expected}, got {actual}`)
end
local UiScaleHelperNumber
do
	UiScaleHelperNumber = setmetatable({}, {
		__tostring = function()
			return "UiScaleHelperNumber"
		end,
	})
	UiScaleHelperNumber.__index = UiScaleHelperNumber
	function UiScaleHelperNumber.new(...)
		local self = setmetatable({}, UiScaleHelperNumber)
		return self:constructor(...) or self
	end
	function UiScaleHelperNumber:constructor()
	end
	function UiScaleHelperNumber:designDivides(value, scale, expected)
		assertApprox(toDesignPixels(value, scale), expected, `toDesignPixels({value}, {scale})`)
	end
	function UiScaleHelperNumber:screenMultiplies(value, scale, expected)
		assertApprox(toScreenPixels(value, scale), expected, `toScreenPixels({value}, {scale})`)
	end
	function UiScaleHelperNumber:roundTrip(value, scale)
		assertApprox(toScreenPixels(toDesignPixels(value, scale), scale), value, `round trip of {value} at {scale}`)
		assertApprox(toDesignPixels(toScreenPixels(value, scale), scale), value, `reverse round trip of {value} at {scale}`)
	end
	function UiScaleHelperNumber:identityAtOne(value)
		Assert:equal(toDesignPixels(value, 1), value)
		Assert:equal(toScreenPixels(value, 1), value)
	end
	local _decorator = Each({ { 300, 1.5, 200 }, { 100, 1.25, 80 }, { 420, 1.25, 336 }, { 0, 1.5, 0 }, { -30, 1.5, -20 } })
	local _decorator_1 = DisplayName("Screen pixels divided by the scale give design pixels")
	local _descriptor = Test(UiScaleHelperNumber, "designDivides", {
		value = UiScaleHelperNumber.designDivides,
	})
	if _descriptor then
		UiScaleHelperNumber.designDivides = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(UiScaleHelperNumber, "designDivides", {
		value = UiScaleHelperNumber.designDivides,
	})
	if _descriptor_1 then
		UiScaleHelperNumber.designDivides = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(UiScaleHelperNumber, "designDivides", {
		value = UiScaleHelperNumber.designDivides,
	})
	if _descriptor_2 then
		UiScaleHelperNumber.designDivides = _descriptor_2.value
	end
	local _decorator_2 = Each({ { 200, 1.5, 300 }, { 80, 1.25, 100 }, { 336, 1.25, 420 }, { 0, 1.5, 0 }, { -20, 1.5, -30 } })
	local _decorator_3 = DisplayName("Design pixels multiplied by the scale give screen pixels")
	local _descriptor_3 = Test(UiScaleHelperNumber, "screenMultiplies", {
		value = UiScaleHelperNumber.screenMultiplies,
	})
	if _descriptor_3 then
		UiScaleHelperNumber.screenMultiplies = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(UiScaleHelperNumber, "screenMultiplies", {
		value = UiScaleHelperNumber.screenMultiplies,
	})
	if _descriptor_4 then
		UiScaleHelperNumber.screenMultiplies = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(UiScaleHelperNumber, "screenMultiplies", {
		value = UiScaleHelperNumber.screenMultiplies,
	})
	if _descriptor_5 then
		UiScaleHelperNumber.screenMultiplies = _descriptor_5.value
	end
	local _decorator_4 = Each({ { 123.4, 1.25 }, { 777, 1.5 }, { 1, 1.2 }, { 59.5, 0.75 } })
	local _decorator_5 = DisplayName("Converting to design pixels and back to screen pixels returns the original value")
	local _descriptor_6 = Test(UiScaleHelperNumber, "roundTrip", {
		value = UiScaleHelperNumber.roundTrip,
	})
	if _descriptor_6 then
		UiScaleHelperNumber.roundTrip = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(UiScaleHelperNumber, "roundTrip", {
		value = UiScaleHelperNumber.roundTrip,
	})
	if _descriptor_7 then
		UiScaleHelperNumber.roundTrip = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(UiScaleHelperNumber, "roundTrip", {
		value = UiScaleHelperNumber.roundTrip,
	})
	if _descriptor_8 then
		UiScaleHelperNumber.roundTrip = _descriptor_8.value
	end
	local _decorator_6 = Each({ { 0 }, { 1 }, { 123.4 }, { -50 } })
	local _decorator_7 = DisplayName("At scale 1 both conversions return the value unchanged")
	local _descriptor_9 = Test(UiScaleHelperNumber, "identityAtOne", {
		value = UiScaleHelperNumber.identityAtOne,
	})
	if _descriptor_9 then
		UiScaleHelperNumber.identityAtOne = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(UiScaleHelperNumber, "identityAtOne", {
		value = UiScaleHelperNumber.identityAtOne,
	})
	if _descriptor_10 then
		UiScaleHelperNumber.identityAtOne = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(UiScaleHelperNumber, "identityAtOne", {
		value = UiScaleHelperNumber.identityAtOne,
	})
	if _descriptor_11 then
		UiScaleHelperNumber.identityAtOne = _descriptor_11.value
	end
	UiScaleHelperNumber = Tag("Lune")(UiScaleHelperNumber) or UiScaleHelperNumber
end
return UiScaleHelperNumber
