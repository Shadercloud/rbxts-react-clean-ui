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
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Input = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Input").Input
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local FIELD_FILL = Color3.fromRGB(41, 88, 150)
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
	function InputMountValidation:rejectsInvalidChar()
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
	function InputMountValidation:defaultTransparent()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
		}), function(mounted)
			local root = waitForGuiObject(mounted.host, "Input")
			Assert:equal(root.BackgroundTransparency, 1)
		end)
	end
	function InputMountValidation:themedBackground()
		local theme = extendTheme(DefaultTheme, {
			components = {
				input = {
					backgroundColor = FIELD_FILL,
					backgroundTransparency = 0.25,
				},
			},
		})
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Input, {
			value = "",
		})), function(mounted)
			local root = waitForGuiObject(mounted.host, "Input")
			Assert:equal(root.BackgroundColor3, FIELD_FILL)
			Assert:equal(root.BackgroundTransparency, 0.25)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_1 = DisplayName("With Number validation, typing a letter reverts the TextBox and onChange to the last numeric text")
	local _descriptor = Test(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor then
		InputMountValidation.rejectsInvalidChar = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor_1 then
		InputMountValidation.rejectsInvalidChar = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor_2 then
		InputMountValidation.rejectsInvalidChar = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Without theme background keys the root Input ImageLabel stays fully transparent")
	local _descriptor_3 = Test(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_3 then
		InputMountValidation.defaultTransparent = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_4 then
		InputMountValidation.defaultTransparent = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_5 then
		InputMountValidation.defaultTransparent = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("theme.components.input backgroundColor and backgroundTransparency fill the root Input ImageLabel")
	local _descriptor_6 = Test(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_6 then
		InputMountValidation.themedBackground = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_7 then
		InputMountValidation.themedBackground = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_8 then
		InputMountValidation.themedBackground = _descriptor_8.value
	end
	InputMountValidation = Tag("Studio")(InputMountValidation) or InputMountValidation
end
return InputMountValidation
