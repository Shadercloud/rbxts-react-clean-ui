-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _Input_validation = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Input.validation")
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
	function InputNumberValidation:rejectsInvalidChar()
		local lastValid = ""
		for _, candidate in { "1", "12", "123", "123A" } do
			local resolved = resolveValidatedText("Number", candidate, lastValid)
			if resolved == candidate then
				lastValid = candidate
			end
		end
		Assert:equal(lastValid, "123")
	end
	function InputNumberValidation:clampsToMax()
		local resolved = resolveClampedText("Number", "50", 0, 10)
		Assert:equal(resolved, "10")
	end
	function InputNumberValidation:clampsToMin()
		local resolved = resolveClampedText("Number", "-5", 0, 10)
		Assert:equal(resolved, "0")
	end
	function InputNumberValidation:inRangeUntouched()
		local resolved = resolveClampedText("Number", "5", 0, 10)
		Assert:undefined(resolved)
	end
	function InputNumberValidation:nonNumericUntouched()
		local resolved = resolveClampedText("Number", "abc", 0, 10)
		Assert:undefined(resolved)
	end
	local _decorator = DisplayName("Number validation rejects a candidate containing a letter and keeps the previous numeric text")
	local _descriptor = Test(InputNumberValidation, "rejectsInvalidChar", {
		value = InputNumberValidation.rejectsInvalidChar,
	})
	if _descriptor then
		InputNumberValidation.rejectsInvalidChar = _descriptor.value
	end
	local _descriptor_1 = _decorator(InputNumberValidation, "rejectsInvalidChar", {
		value = InputNumberValidation.rejectsInvalidChar,
	})
	if _descriptor_1 then
		InputNumberValidation.rejectsInvalidChar = _descriptor_1.value
	end
	local _decorator_1 = DisplayName("Text above the range resolves to the max as a string")
	local _descriptor_2 = Test(InputNumberValidation, "clampsToMax", {
		value = InputNumberValidation.clampsToMax,
	})
	if _descriptor_2 then
		InputNumberValidation.clampsToMax = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(InputNumberValidation, "clampsToMax", {
		value = InputNumberValidation.clampsToMax,
	})
	if _descriptor_3 then
		InputNumberValidation.clampsToMax = _descriptor_3.value
	end
	local _decorator_2 = DisplayName("Negative text below the range resolves to the min as a string")
	local _descriptor_4 = Test(InputNumberValidation, "clampsToMin", {
		value = InputNumberValidation.clampsToMin,
	})
	if _descriptor_4 then
		InputNumberValidation.clampsToMin = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(InputNumberValidation, "clampsToMin", {
		value = InputNumberValidation.clampsToMin,
	})
	if _descriptor_5 then
		InputNumberValidation.clampsToMin = _descriptor_5.value
	end
	local _decorator_3 = DisplayName("Text already inside the range needs no clamping and resolves to undefined")
	local _descriptor_6 = Test(InputNumberValidation, "inRangeUntouched", {
		value = InputNumberValidation.inRangeUntouched,
	})
	if _descriptor_6 then
		InputNumberValidation.inRangeUntouched = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(InputNumberValidation, "inRangeUntouched", {
		value = InputNumberValidation.inRangeUntouched,
	})
	if _descriptor_7 then
		InputNumberValidation.inRangeUntouched = _descriptor_7.value
	end
	local _decorator_4 = DisplayName("Non-numeric text cannot be clamped and resolves to undefined")
	local _descriptor_8 = Test(InputNumberValidation, "nonNumericUntouched", {
		value = InputNumberValidation.nonNumericUntouched,
	})
	if _descriptor_8 then
		InputNumberValidation.nonNumericUntouched = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(InputNumberValidation, "nonNumericUntouched", {
		value = InputNumberValidation.nonNumericUntouched,
	})
	if _descriptor_9 then
		InputNumberValidation.nonNumericUntouched = _descriptor_9.value
	end
	InputNumberValidation = Tag("Lune")(InputNumberValidation) or InputNumberValidation
end
return InputNumberValidation
