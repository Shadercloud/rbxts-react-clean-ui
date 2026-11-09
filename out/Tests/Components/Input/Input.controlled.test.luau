-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local Input = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Input").Input
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local ECHO_DELAY = 0.1
local function echoLater(mode, apply)
	if mode == "defer" then
		task.defer(apply)
	else
		task.delay(ECHO_DELAY, apply)
	end
end
local function EchoParent(props)
	local value, setValue = React.useState("")
	return React.createElement(Input, {
		controlled = true,
		value = value,
		onChange = function(text)
			return echoLater(props.mode, function()
				return setValue(text)
			end)
		end,
	})
end
local function BlurFormatParent()
	local value, setValue = React.useState("4.00")
	return React.createElement(Input, {
		controlled = true,
		value = value,
		onChange = setValue,
		Event = {
			FocusLost = function()
				return setValue("4.00")
			end,
		},
	})
end
local function waitForTextBox(mounted)
	return findDescendant(waitForGuiObject(mounted.host, "Input"), "TextBox")
end
local function focus(textBox)
	textBox:CaptureFocus()
	waitForLayout(function()
		return if textBox:IsFocused() then true else nil
	end, "Timed out waiting for CaptureFocus to focus the TextBox")
	settleFrames(2)
end
local function blur(textBox)
	textBox:ReleaseFocus()
	waitForLayout(function()
		return if not textBox:IsFocused() then true else nil
	end, "Timed out waiting for ReleaseFocus to blur the TextBox")
end
local function waitForText(textBox, expected, message)
	waitForLayout(function()
		return if textBox.Text == expected then true else nil
	end, `{message} (Text="{textBox.Text}")`)
end
local InputControlledValidation
do
	InputControlledValidation = setmetatable({}, {
		__tostring = function()
			return "InputControlledValidation"
		end,
	})
	InputControlledValidation.__index = InputControlledValidation
	function InputControlledValidation.new(...)
		local self = setmetatable({}, InputControlledValidation)
		return self:constructor(...) or self
	end
	function InputControlledValidation:constructor()
	end
	function InputControlledValidation:focusedKeepsTyping(mode)
		withMounted(400, 200, React.createElement(EchoParent, {
			mode = mode,
		}), function(mounted)
			local textBox = waitForTextBox(mounted)
			focus(textBox)
			textBox.Text = "2"
			if mode == "delay" then
				task.wait()
			end
			textBox.Text = "24"
			task.wait(ECHO_DELAY * 3)
			settleFrames(10)
			Assert:equal(textBox.Text, "24", `{mode}: expected the focused TextBox to keep the latest typed text`)
			blur(textBox)
			settleFrames(5)
			Assert:equal(textBox.Text, "24", `{mode}: expected the blurred TextBox to show the echoed value`)
		end)
	end
	function InputControlledValidation:blurShowsFormatted()
		withMounted(400, 200, React.createElement(BlurFormatParent), function(mounted)
			local textBox = waitForTextBox(mounted)
			Assert:equal(textBox.Text, "4.00")
			focus(textBox)
			textBox.Text = "4"
			settleFrames(5)
			Assert:equal(textBox.Text, "4", "Expected the typed text while focused")
			blur(textBox)
			waitForText(textBox, "4.00", "Expected the TextBox to show the parent's reformatted value after FocusLost")
		end)
	end
	function InputControlledValidation:unfocusedSyncsValue()
		withMounted(400, 200, React.createElement(Input, {
			controlled = true,
			value = "1",
		}), function(mounted)
			local textBox = waitForTextBox(mounted)
			Assert:equal(textBox.Text, "1")
			mounted.update(React.createElement(Input, {
				controlled = true,
				value = "2",
			}))
			waitForText(textBox, "2", "Expected the unfocused TextBox to follow the new value")
			mounted.update(React.createElement(Input, {
				controlled = true,
				value = "",
			}))
			waitForText(textBox, "", "Expected the unfocused TextBox to follow an emptied value")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "defer" }, { "delay" } })
	local _decorator_2 = DisplayName("A parent echoing onChange late cannot overwrite what was typed while the controlled TextBox is focused")
	local _descriptor = Test(InputControlledValidation, "focusedKeepsTyping", {
		value = InputControlledValidation.focusedKeepsTyping,
	})
	if _descriptor then
		InputControlledValidation.focusedKeepsTyping = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(InputControlledValidation, "focusedKeepsTyping", {
		value = InputControlledValidation.focusedKeepsTyping,
	})
	if _descriptor_1 then
		InputControlledValidation.focusedKeepsTyping = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(InputControlledValidation, "focusedKeepsTyping", {
		value = InputControlledValidation.focusedKeepsTyping,
	})
	if _descriptor_2 then
		InputControlledValidation.focusedKeepsTyping = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(InputControlledValidation, "focusedKeepsTyping", {
		value = InputControlledValidation.focusedKeepsTyping,
	})
	if _descriptor_3 then
		InputControlledValidation.focusedKeepsTyping = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("A parent that reformats value to 4.00 in FocusLost shows 4.00 once the TextBox loses focus")
	local _descriptor_4 = Test(InputControlledValidation, "blurShowsFormatted", {
		value = InputControlledValidation.blurShowsFormatted,
	})
	if _descriptor_4 then
		InputControlledValidation.blurShowsFormatted = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(InputControlledValidation, "blurShowsFormatted", {
		value = InputControlledValidation.blurShowsFormatted,
	})
	if _descriptor_5 then
		InputControlledValidation.blurShowsFormatted = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(InputControlledValidation, "blurShowsFormatted", {
		value = InputControlledValidation.blurShowsFormatted,
	})
	if _descriptor_6 then
		InputControlledValidation.blurShowsFormatted = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Changing the controlled value while the TextBox is unfocused writes the new value into Text")
	local _descriptor_7 = Test(InputControlledValidation, "unfocusedSyncsValue", {
		value = InputControlledValidation.unfocusedSyncsValue,
	})
	if _descriptor_7 then
		InputControlledValidation.unfocusedSyncsValue = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(InputControlledValidation, "unfocusedSyncsValue", {
		value = InputControlledValidation.unfocusedSyncsValue,
	})
	if _descriptor_8 then
		InputControlledValidation.unfocusedSyncsValue = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(InputControlledValidation, "unfocusedSyncsValue", {
		value = InputControlledValidation.unfocusedSyncsValue,
	})
	if _descriptor_9 then
		InputControlledValidation.unfocusedSyncsValue = _descriptor_9.value
	end
	InputControlledValidation = Tag("Studio")(InputControlledValidation) or InputControlledValidation
end
return InputControlledValidation
