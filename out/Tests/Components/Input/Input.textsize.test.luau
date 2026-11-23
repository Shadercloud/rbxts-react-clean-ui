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
local TypographyHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers", "typography.helper").TypographyHelper
local CleanUiProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertTextSizeNotPinned = _layout.assertTextSizeNotPinned
local assertTextSizePinned = _layout.assertTextSizePinned
local settleFrames = _layout.settleFrames
local textSizeConstraintsOf = _layout.textSizeConstraintsOf
local waitForDescendant = _layout.waitForDescendant
local withMounted = _layout.withMounted
local function app(ignore, child)
	return React.createElement(CleanUiProvider, {
		theme = DefaultTheme,
		toasts = false,
		ignorePreferredTextSize = ignore,
	}, child)
end
local function expectedSize(scale)
	local typography = TypographyHelper:getTypography(DefaultTheme, scale, DefaultTheme.components.input.typography)
	local size = TypographyHelper:toTextSize(typography.size)
	Assert:notUndefined(size, `Expected the input typography size {typography.size.Name} to have a pixel size`)
	return size
end
local function waitForTextBox(host)
	return waitForDescendant(host, "TextBox", function()
		return true
	end)
end
local InputPreferredTextSize
do
	InputPreferredTextSize = setmetatable({}, {
		__tostring = function()
			return "InputPreferredTextSize"
		end,
	})
	InputPreferredTextSize.__index = InputPreferredTextSize
	function InputPreferredTextSize.new(...)
		local self = setmetatable({}, InputPreferredTextSize)
		return self:constructor(...) or self
	end
	function InputPreferredTextSize:constructor()
	end
	function InputPreferredTextSize:pinsTextBox(scale)
		withMounted(400, 200, app(true, React.createElement(Input, {
			value = "Hello",
			scale = scale,
		})), function(mounted)
			local box = waitForTextBox(mounted.host)
			settleFrames(1)
			local expected = expectedSize(scale)
			assertTextSizePinned(box, expected)
			Assert:equal(box.TextSize, expected, "Expected the pin to match the TextBox's own TextSize")
		end)
	end
	function InputPreferredTextSize:offNoPin()
		withMounted(400, 200, app(false, React.createElement(Input, {
			value = "Hello",
		})), function(mounted)
			local box = waitForTextBox(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(box)
			Assert:equal(#textSizeConstraintsOf(box), 0, "Expected no UITextSizeConstraint with the switch off")
		end)
	end
	function InputPreferredTextSize:tracksScale()
		withMounted(400, 200, app(true, React.createElement(Input, {
			value = "Hello",
			scale = "xs",
		})), function(mounted)
			local box = waitForTextBox(mounted.host)
			settleFrames(1)
			assertTextSizePinned(box, expectedSize("xs"))
			mounted.update(app(true, React.createElement(Input, {
				value = "Hello",
				scale = "xl",
			})))
			settleFrames(1)
			assertTextSizePinned(box, expectedSize("xl"))
		end)
	end
	function InputPreferredTextSize:scaledSkipped()
		withMounted(400, 200, app(true, React.createElement(Input, {
			value = "Hello",
			TextScaled = true,
		})), function(mounted)
			local box = waitForTextBox(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(box)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With the switch on, the TextBox is pinned to its resolved typography size for each scale")
	local _decorator_2 = Each({ { "xs" }, { "sm" }, { "md" }, { "lg" }, { "xl" } })
	local _descriptor = Test(InputPreferredTextSize, "pinsTextBox", {
		value = InputPreferredTextSize.pinsTextBox,
	})
	if _descriptor then
		InputPreferredTextSize.pinsTextBox = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(InputPreferredTextSize, "pinsTextBox", {
		value = InputPreferredTextSize.pinsTextBox,
	})
	if _descriptor_1 then
		InputPreferredTextSize.pinsTextBox = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(InputPreferredTextSize, "pinsTextBox", {
		value = InputPreferredTextSize.pinsTextBox,
	})
	if _descriptor_2 then
		InputPreferredTextSize.pinsTextBox = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(InputPreferredTextSize, "pinsTextBox", {
		value = InputPreferredTextSize.pinsTextBox,
	})
	if _descriptor_3 then
		InputPreferredTextSize.pinsTextBox = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With the switch off, the TextBox has no text size constraint")
	local _descriptor_4 = Test(InputPreferredTextSize, "offNoPin", {
		value = InputPreferredTextSize.offNoPin,
	})
	if _descriptor_4 then
		InputPreferredTextSize.offNoPin = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(InputPreferredTextSize, "offNoPin", {
		value = InputPreferredTextSize.offNoPin,
	})
	if _descriptor_5 then
		InputPreferredTextSize.offNoPin = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(InputPreferredTextSize, "offNoPin", {
		value = InputPreferredTextSize.offNoPin,
	})
	if _descriptor_6 then
		InputPreferredTextSize.offNoPin = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Changing the scale on a mounted Input moves the pin to the new size")
	local _descriptor_7 = Test(InputPreferredTextSize, "tracksScale", {
		value = InputPreferredTextSize.tracksScale,
	})
	if _descriptor_7 then
		InputPreferredTextSize.tracksScale = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(InputPreferredTextSize, "tracksScale", {
		value = InputPreferredTextSize.tracksScale,
	})
	if _descriptor_8 then
		InputPreferredTextSize.tracksScale = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(InputPreferredTextSize, "tracksScale", {
		value = InputPreferredTextSize.tracksScale,
	})
	if _descriptor_9 then
		InputPreferredTextSize.tracksScale = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("A TextScaled TextBox is not pinned even with the switch on")
	local _descriptor_10 = Test(InputPreferredTextSize, "scaledSkipped", {
		value = InputPreferredTextSize.scaledSkipped,
	})
	if _descriptor_10 then
		InputPreferredTextSize.scaledSkipped = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(InputPreferredTextSize, "scaledSkipped", {
		value = InputPreferredTextSize.scaledSkipped,
	})
	if _descriptor_11 then
		InputPreferredTextSize.scaledSkipped = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(InputPreferredTextSize, "scaledSkipped", {
		value = InputPreferredTextSize.scaledSkipped,
	})
	if _descriptor_12 then
		InputPreferredTextSize.scaledSkipped = _descriptor_12.value
	end
	InputPreferredTextSize = Tag("Studio")(InputPreferredTextSize) or InputPreferredTextSize
end
return InputPreferredTextSize
