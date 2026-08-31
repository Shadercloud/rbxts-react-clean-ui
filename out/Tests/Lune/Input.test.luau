-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local _Input_validation = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Input.validation")
local resolveValidatedText = _Input_validation.resolveValidatedText
local resolveClampedText = _Input_validation.resolveClampedText
local InputNumberValidation
do
	InputNumberValidation = setmetatable({}, {
		__tostring = function()
			return "InputNumberValidation"
		end,
	})
	InputNumberValidation.__index = InputNumberValidation
	function InputNumberValidation.new(...)
		local self = setmetatable({}, InputNumberValidation)
		return self:constructor(...) or self
	end
	function InputNumberValidation:constructor()
	end
	function InputNumberValidation:keepsLastValidTextWhenAnInvalidCharacterIsTyped()
		local lastValid = ""
		for _, candidate in { "1", "12", "123", "123A" } do
			local resolved = resolveValidatedText("Number", candidate, lastValid)
			if resolved == candidate then
				lastValid = candidate
			end
		end
		Assert:equal(lastValid, "123")
	end
	function InputNumberValidation:clampsDownToMaxWhenTextIsOverRange()
		local resolved = resolveClampedText("Number", "50", 0, 10)
		Assert:equal(resolved, "10")
	end
	function InputNumberValidation:clampsUpToMinWhenTextIsUnderRange()
		local resolved = resolveClampedText("Number", "-5", 0, 10)
		Assert:equal(resolved, "0")
	end
	function InputNumberValidation:returnsUndefinedWhenTextIsWithinRange()
		local resolved = resolveClampedText("Number", "5", 0, 10)
		Assert:undefined(resolved)
	end
	function InputNumberValidation:returnsUndefinedWhenTextIsNonNumeric()
		local resolved = resolveClampedText("Number", "abc", 0, 10)
		Assert:undefined(resolved)
	end
	local _descriptor = Test(InputNumberValidation, "keepsLastValidTextWhenAnInvalidCharacterIsTyped", {
		value = InputNumberValidation.keepsLastValidTextWhenAnInvalidCharacterIsTyped,
	})
	if _descriptor then
		InputNumberValidation.keepsLastValidTextWhenAnInvalidCharacterIsTyped = _descriptor.value
	end
	local _descriptor_1 = Test(InputNumberValidation, "clampsDownToMaxWhenTextIsOverRange", {
		value = InputNumberValidation.clampsDownToMaxWhenTextIsOverRange,
	})
	if _descriptor_1 then
		InputNumberValidation.clampsDownToMaxWhenTextIsOverRange = _descriptor_1.value
	end
	local _descriptor_2 = Test(InputNumberValidation, "clampsUpToMinWhenTextIsUnderRange", {
		value = InputNumberValidation.clampsUpToMinWhenTextIsUnderRange,
	})
	if _descriptor_2 then
		InputNumberValidation.clampsUpToMinWhenTextIsUnderRange = _descriptor_2.value
	end
	local _descriptor_3 = Test(InputNumberValidation, "returnsUndefinedWhenTextIsWithinRange", {
		value = InputNumberValidation.returnsUndefinedWhenTextIsWithinRange,
	})
	if _descriptor_3 then
		InputNumberValidation.returnsUndefinedWhenTextIsWithinRange = _descriptor_3.value
	end
	local _descriptor_4 = Test(InputNumberValidation, "returnsUndefinedWhenTextIsNonNumeric", {
		value = InputNumberValidation.returnsUndefinedWhenTextIsNonNumeric,
	})
	if _descriptor_4 then
		InputNumberValidation.returnsUndefinedWhenTextIsNonNumeric = _descriptor_4.value
	end
end
return InputNumberValidation
