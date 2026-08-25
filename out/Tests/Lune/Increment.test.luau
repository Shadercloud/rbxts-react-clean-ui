-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local resolveSteppedValue = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Increment.step").resolveSteppedValue
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
	function IncrementStepValidation:incrementsByDefaultStepWithNoBounds()
		Assert:equal(resolveSteppedValue(5, "increment", 1), 6)
	end
	function IncrementStepValidation:decrementsByDefaultStepWithNoBounds()
		Assert:equal(resolveSteppedValue(5, "decrement", 1), 4)
	end
	function IncrementStepValidation:incrementsByCustomStepWithNoBounds()
		Assert:equal(resolveSteppedValue(10, "increment", 5), 15)
	end
	function IncrementStepValidation:decrementsByCustomStepWithNoBounds()
		Assert:equal(resolveSteppedValue(10, "decrement", 5), 5)
	end
	function IncrementStepValidation:incrementingPastMaxClampsToMax()
		Assert:equal(resolveSteppedValue(8, "increment", 5, 0, 10), 10)
	end
	function IncrementStepValidation:decrementingPastMinClampsToMin()
		Assert:equal(resolveSteppedValue(2, "decrement", 5, 0, 10), 0)
	end
	function IncrementStepValidation:incrementingWhenAlreadyAtMaxReturnsUndefined()
		Assert:undefined(resolveSteppedValue(10, "increment", 1, 0, 10))
	end
	function IncrementStepValidation:decrementingWhenAlreadyAtMinReturnsUndefined()
		Assert:undefined(resolveSteppedValue(0, "decrement", 1, 0, 10))
	end
	function IncrementStepValidation:repeatedDecimalStepIncrementsLandOnExactValue()
		local current = 0
		for index = 0, 9 do
			current = resolveSteppedValue(current, "increment", 0.1)
		end
		Assert:equal(current, 1)
	end
	function IncrementStepValidation:repeatedDecimalStepIncrementsDoNotDriftOverManyCalls()
		local current = 0
		for index = 0, 89 do
			current = resolveSteppedValue(current, "increment", 0.1)
		end
		Assert:equal(current, 9)
	end
	function IncrementStepValidation:repeatedDecimalStepDecrementsLandOnExactValue()
		local current = 1
		for index = 0, 9 do
			current = resolveSteppedValue(current, "decrement", 0.1)
		end
		Assert:equal(current, 0)
	end
	function IncrementStepValidation:repeatedDifferentDecimalStepIncrementsLandOnExactValue()
		local current = 0
		for index = 0, 9 do
			current = resolveSteppedValue(current, "increment", 0.3)
		end
		Assert:equal(current, 3)
	end
	local _descriptor = Test(IncrementStepValidation, "incrementsByDefaultStepWithNoBounds", {
		value = IncrementStepValidation.incrementsByDefaultStepWithNoBounds,
	})
	if _descriptor then
		IncrementStepValidation.incrementsByDefaultStepWithNoBounds = _descriptor.value
	end
	local _descriptor_1 = Test(IncrementStepValidation, "decrementsByDefaultStepWithNoBounds", {
		value = IncrementStepValidation.decrementsByDefaultStepWithNoBounds,
	})
	if _descriptor_1 then
		IncrementStepValidation.decrementsByDefaultStepWithNoBounds = _descriptor_1.value
	end
	local _descriptor_2 = Test(IncrementStepValidation, "incrementsByCustomStepWithNoBounds", {
		value = IncrementStepValidation.incrementsByCustomStepWithNoBounds,
	})
	if _descriptor_2 then
		IncrementStepValidation.incrementsByCustomStepWithNoBounds = _descriptor_2.value
	end
	local _descriptor_3 = Test(IncrementStepValidation, "decrementsByCustomStepWithNoBounds", {
		value = IncrementStepValidation.decrementsByCustomStepWithNoBounds,
	})
	if _descriptor_3 then
		IncrementStepValidation.decrementsByCustomStepWithNoBounds = _descriptor_3.value
	end
	local _descriptor_4 = Test(IncrementStepValidation, "incrementingPastMaxClampsToMax", {
		value = IncrementStepValidation.incrementingPastMaxClampsToMax,
	})
	if _descriptor_4 then
		IncrementStepValidation.incrementingPastMaxClampsToMax = _descriptor_4.value
	end
	local _descriptor_5 = Test(IncrementStepValidation, "decrementingPastMinClampsToMin", {
		value = IncrementStepValidation.decrementingPastMinClampsToMin,
	})
	if _descriptor_5 then
		IncrementStepValidation.decrementingPastMinClampsToMin = _descriptor_5.value
	end
	local _descriptor_6 = Test(IncrementStepValidation, "incrementingWhenAlreadyAtMaxReturnsUndefined", {
		value = IncrementStepValidation.incrementingWhenAlreadyAtMaxReturnsUndefined,
	})
	if _descriptor_6 then
		IncrementStepValidation.incrementingWhenAlreadyAtMaxReturnsUndefined = _descriptor_6.value
	end
	local _descriptor_7 = Test(IncrementStepValidation, "decrementingWhenAlreadyAtMinReturnsUndefined", {
		value = IncrementStepValidation.decrementingWhenAlreadyAtMinReturnsUndefined,
	})
	if _descriptor_7 then
		IncrementStepValidation.decrementingWhenAlreadyAtMinReturnsUndefined = _descriptor_7.value
	end
	local _descriptor_8 = Test(IncrementStepValidation, "repeatedDecimalStepIncrementsLandOnExactValue", {
		value = IncrementStepValidation.repeatedDecimalStepIncrementsLandOnExactValue,
	})
	if _descriptor_8 then
		IncrementStepValidation.repeatedDecimalStepIncrementsLandOnExactValue = _descriptor_8.value
	end
	local _descriptor_9 = Test(IncrementStepValidation, "repeatedDecimalStepIncrementsDoNotDriftOverManyCalls", {
		value = IncrementStepValidation.repeatedDecimalStepIncrementsDoNotDriftOverManyCalls,
	})
	if _descriptor_9 then
		IncrementStepValidation.repeatedDecimalStepIncrementsDoNotDriftOverManyCalls = _descriptor_9.value
	end
	local _descriptor_10 = Test(IncrementStepValidation, "repeatedDecimalStepDecrementsLandOnExactValue", {
		value = IncrementStepValidation.repeatedDecimalStepDecrementsLandOnExactValue,
	})
	if _descriptor_10 then
		IncrementStepValidation.repeatedDecimalStepDecrementsLandOnExactValue = _descriptor_10.value
	end
	local _descriptor_11 = Test(IncrementStepValidation, "repeatedDifferentDecimalStepIncrementsLandOnExactValue", {
		value = IncrementStepValidation.repeatedDifferentDecimalStepIncrementsLandOnExactValue,
	})
	if _descriptor_11 then
		IncrementStepValidation.repeatedDifferentDecimalStepIncrementsLandOnExactValue = _descriptor_11.value
	end
end
return IncrementStepValidation
