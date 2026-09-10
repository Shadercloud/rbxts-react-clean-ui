-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local resolveSteppedValue = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Increment.step").resolveSteppedValue
local IncrementStepValidation
do
	IncrementStepValidation = setmetatable({}, {
		__tostring = function()
			return "IncrementStepValidation"
		end,
	})
	IncrementStepValidation.__index = IncrementStepValidation
	function IncrementStepValidation.new(...)
		local self = setmetatable({}, IncrementStepValidation)
		return self:constructor(...) or self
	end
	function IncrementStepValidation:constructor()
	end
	function IncrementStepValidation:defaultStep()
		Assert:equal(resolveSteppedValue(5, "increment", 1), 6)
	end
	function IncrementStepValidation:defaultStepDown()
		Assert:equal(resolveSteppedValue(5, "decrement", 1), 4)
	end
	function IncrementStepValidation:customStep()
		Assert:equal(resolveSteppedValue(10, "increment", 5), 15)
	end
	function IncrementStepValidation:customStepDown()
		Assert:equal(resolveSteppedValue(10, "decrement", 5), 5)
	end
	function IncrementStepValidation:clampsToMax()
		Assert:equal(resolveSteppedValue(8, "increment", 5, 0, 10), 10)
	end
	function IncrementStepValidation:clampsToMin()
		Assert:equal(resolveSteppedValue(2, "decrement", 5, 0, 10), 0)
	end
	function IncrementStepValidation:noOpAtMax()
		Assert:undefined(resolveSteppedValue(10, "increment", 1, 0, 10))
	end
	function IncrementStepValidation:noOpAtMin()
		Assert:undefined(resolveSteppedValue(0, "decrement", 1, 0, 10))
	end
	function IncrementStepValidation:decimalStepExact()
		local current = 0
		for index = 0, 9 do
			current = resolveSteppedValue(current, "increment", 0.1)
		end
		Assert:equal(current, 1)
	end
	function IncrementStepValidation:noDecimalDrift()
		local current = 0
		for index = 0, 89 do
			current = resolveSteppedValue(current, "increment", 0.1)
		end
		Assert:equal(current, 9)
	end
	function IncrementStepValidation:decimalStepDownExact()
		local current = 1
		for index = 0, 9 do
			current = resolveSteppedValue(current, "decrement", 0.1)
		end
		Assert:equal(current, 0)
	end
	function IncrementStepValidation:oddDecimalStepExact()
		local current = 0
		for index = 0, 9 do
			current = resolveSteppedValue(current, "increment", 0.3)
		end
		Assert:equal(current, 3)
	end
	local _decorator = DisplayName("Increments by the default step when no bounds are set")
	local _descriptor = Test(IncrementStepValidation, "defaultStep", {
		value = IncrementStepValidation.defaultStep,
	})
	if _descriptor then
		IncrementStepValidation.defaultStep = _descriptor.value
	end
	local _descriptor_1 = _decorator(IncrementStepValidation, "defaultStep", {
		value = IncrementStepValidation.defaultStep,
	})
	if _descriptor_1 then
		IncrementStepValidation.defaultStep = _descriptor_1.value
	end
	local _decorator_1 = DisplayName("Decrements by the default step when no bounds are set")
	local _descriptor_2 = Test(IncrementStepValidation, "defaultStepDown", {
		value = IncrementStepValidation.defaultStepDown,
	})
	if _descriptor_2 then
		IncrementStepValidation.defaultStepDown = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(IncrementStepValidation, "defaultStepDown", {
		value = IncrementStepValidation.defaultStepDown,
	})
	if _descriptor_3 then
		IncrementStepValidation.defaultStepDown = _descriptor_3.value
	end
	local _decorator_2 = DisplayName("Increments by a custom step size when no bounds are set")
	local _descriptor_4 = Test(IncrementStepValidation, "customStep", {
		value = IncrementStepValidation.customStep,
	})
	if _descriptor_4 then
		IncrementStepValidation.customStep = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(IncrementStepValidation, "customStep", {
		value = IncrementStepValidation.customStep,
	})
	if _descriptor_5 then
		IncrementStepValidation.customStep = _descriptor_5.value
	end
	local _decorator_3 = DisplayName("Decrements by a custom step size when no bounds are set")
	local _descriptor_6 = Test(IncrementStepValidation, "customStepDown", {
		value = IncrementStepValidation.customStepDown,
	})
	if _descriptor_6 then
		IncrementStepValidation.customStepDown = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(IncrementStepValidation, "customStepDown", {
		value = IncrementStepValidation.customStepDown,
	})
	if _descriptor_7 then
		IncrementStepValidation.customStepDown = _descriptor_7.value
	end
	local _decorator_4 = DisplayName("A step that would overshoot max is clamped to max")
	local _descriptor_8 = Test(IncrementStepValidation, "clampsToMax", {
		value = IncrementStepValidation.clampsToMax,
	})
	if _descriptor_8 then
		IncrementStepValidation.clampsToMax = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(IncrementStepValidation, "clampsToMax", {
		value = IncrementStepValidation.clampsToMax,
	})
	if _descriptor_9 then
		IncrementStepValidation.clampsToMax = _descriptor_9.value
	end
	local _decorator_5 = DisplayName("A step that would undershoot min is clamped to min")
	local _descriptor_10 = Test(IncrementStepValidation, "clampsToMin", {
		value = IncrementStepValidation.clampsToMin,
	})
	if _descriptor_10 then
		IncrementStepValidation.clampsToMin = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(IncrementStepValidation, "clampsToMin", {
		value = IncrementStepValidation.clampsToMin,
	})
	if _descriptor_11 then
		IncrementStepValidation.clampsToMin = _descriptor_11.value
	end
	local _decorator_6 = DisplayName("Returns undefined instead of a new value when already sitting at max")
	local _descriptor_12 = Test(IncrementStepValidation, "noOpAtMax", {
		value = IncrementStepValidation.noOpAtMax,
	})
	if _descriptor_12 then
		IncrementStepValidation.noOpAtMax = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(IncrementStepValidation, "noOpAtMax", {
		value = IncrementStepValidation.noOpAtMax,
	})
	if _descriptor_13 then
		IncrementStepValidation.noOpAtMax = _descriptor_13.value
	end
	local _decorator_7 = DisplayName("Returns undefined instead of a new value when already sitting at min")
	local _descriptor_14 = Test(IncrementStepValidation, "noOpAtMin", {
		value = IncrementStepValidation.noOpAtMin,
	})
	if _descriptor_14 then
		IncrementStepValidation.noOpAtMin = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(IncrementStepValidation, "noOpAtMin", {
		value = IncrementStepValidation.noOpAtMin,
	})
	if _descriptor_15 then
		IncrementStepValidation.noOpAtMin = _descriptor_15.value
	end
	local _decorator_8 = DisplayName("Ten increments of 0.1 land exactly on 1 with no floating-point error")
	local _descriptor_16 = Test(IncrementStepValidation, "decimalStepExact", {
		value = IncrementStepValidation.decimalStepExact,
	})
	if _descriptor_16 then
		IncrementStepValidation.decimalStepExact = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_8(IncrementStepValidation, "decimalStepExact", {
		value = IncrementStepValidation.decimalStepExact,
	})
	if _descriptor_17 then
		IncrementStepValidation.decimalStepExact = _descriptor_17.value
	end
	local _decorator_9 = DisplayName("Ninety increments of 0.1 stay exact and never accumulate drift")
	local _descriptor_18 = Test(IncrementStepValidation, "noDecimalDrift", {
		value = IncrementStepValidation.noDecimalDrift,
	})
	if _descriptor_18 then
		IncrementStepValidation.noDecimalDrift = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_9(IncrementStepValidation, "noDecimalDrift", {
		value = IncrementStepValidation.noDecimalDrift,
	})
	if _descriptor_19 then
		IncrementStepValidation.noDecimalDrift = _descriptor_19.value
	end
	local _decorator_10 = DisplayName("Ten decrements of 0.1 from 1 land exactly on 0")
	local _descriptor_20 = Test(IncrementStepValidation, "decimalStepDownExact", {
		value = IncrementStepValidation.decimalStepDownExact,
	})
	if _descriptor_20 then
		IncrementStepValidation.decimalStepDownExact = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_10(IncrementStepValidation, "decimalStepDownExact", {
		value = IncrementStepValidation.decimalStepDownExact,
	})
	if _descriptor_21 then
		IncrementStepValidation.decimalStepDownExact = _descriptor_21.value
	end
	local _decorator_11 = DisplayName("Ten increments of 0.3 land exactly on 3 despite the awkward binary fraction")
	local _descriptor_22 = Test(IncrementStepValidation, "oddDecimalStepExact", {
		value = IncrementStepValidation.oddDecimalStepExact,
	})
	if _descriptor_22 then
		IncrementStepValidation.oddDecimalStepExact = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_11(IncrementStepValidation, "oddDecimalStepExact", {
		value = IncrementStepValidation.oddDecimalStepExact,
	})
	if _descriptor_23 then
		IncrementStepValidation.oddDecimalStepExact = _descriptor_23.value
	end
	IncrementStepValidation = Tag("Lune")(IncrementStepValidation) or IncrementStepValidation
end
return IncrementStepValidation
