-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local resolveValidatedText = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Input.validation").resolveValidatedText
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
	local _descriptor = Test(InputNumberValidation, "keepsLastValidTextWhenAnInvalidCharacterIsTyped", {
		value = InputNumberValidation.keepsLastValidTextWhenAnInvalidCharacterIsTyped,
	})
	if _descriptor then
		InputNumberValidation.keepsLastValidTextWhenAnInvalidCharacterIsTyped = _descriptor.value
	end
end
return InputNumberValidation
