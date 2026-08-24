-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local _binding = Decorators
local Skip = _binding.Skip
local Input = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Input").Input
local InputMountValidation
do
	InputMountValidation = setmetatable({}, {
		__tostring = function()
			return "InputMountValidation"
		end,
	})
	InputMountValidation.__index = InputMountValidation
	function InputMountValidation.new(...)
		local self = setmetatable({}, InputMountValidation)
		return self:constructor(...) or self
	end
	function InputMountValidation:constructor()
	end
	function InputMountValidation:typingAnInvalidCharacterKeepsLastValidNumber()
		local host = Instance.new("Folder")
		local latestOnChangeValue = ""
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Input, {
			value = "",
			validation = "Number",
			onChange = function(value)
				latestOnChangeValue = value
			end,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		for _, candidate in { "1", "12", "123", "123A" } do
			textBox.Text = candidate
			task.wait()
		end
		Assert:equal(textBox.Text, "123")
		Assert:equal(latestOnChangeValue, "123")
		root:unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor = Test(InputMountValidation, "typingAnInvalidCharacterKeepsLastValidNumber", {
		value = InputMountValidation.typingAnInvalidCharacterKeepsLastValidNumber,
	})
	if _descriptor then
		InputMountValidation.typingAnInvalidCharacterKeepsLastValidNumber = _descriptor.value
	end
	local _descriptor_1 = _decorator(InputMountValidation, "typingAnInvalidCharacterKeepsLastValidNumber", {
		value = InputMountValidation.typingAnInvalidCharacterKeepsLastValidNumber,
	})
	if _descriptor_1 then
		InputMountValidation.typingAnInvalidCharacterKeepsLastValidNumber = _descriptor_1.value
	end
	InputMountValidation = Tag("Studio")(InputMountValidation) or InputMountValidation
end
return InputMountValidation
