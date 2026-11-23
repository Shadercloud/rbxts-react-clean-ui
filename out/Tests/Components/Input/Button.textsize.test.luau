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
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Button").Button
local TypographyHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers", "typography.helper").TypographyHelper
local CleanUiProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertTextSizeNotPinned = _layout.assertTextSizeNotPinned
local assertTextSizePinned = _layout.assertTextSizePinned
local settleFrames = _layout.settleFrames
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
	local typography = TypographyHelper:getTypography(DefaultTheme, scale, DefaultTheme.components.button.typography)
	local size = TypographyHelper:toTextSize(typography.size)
	Assert:notUndefined(size, `Expected the button typography size {typography.size.Name} to have a pixel size`)
	return size
end
local function waitForButtonText(host)
	return waitForDescendant(host, "ButtonText", function()
		return true
	end)
end
local ButtonPreferredTextSize
do
	ButtonPreferredTextSize = setmetatable({}, {
		__tostring = function()
			return "ButtonPreferredTextSize"
		end,
	})
	ButtonPreferredTextSize.__index = ButtonPreferredTextSize
	function ButtonPreferredTextSize.new(...)
		local self = setmetatable({}, ButtonPreferredTextSize)
		return self:constructor(...) or self
	end
	function ButtonPreferredTextSize:constructor()
	end
	function ButtonPreferredTextSize:pinsLabel(scale)
		withMounted(400, 200, app(true, React.createElement(Button, {
			text = "Save",
			scale = scale,
		})), function(mounted)
			local label = waitForButtonText(mounted.host)
			settleFrames(1)
			local expected = expectedSize(scale)
			assertTextSizePinned(label, expected)
			Assert:equal(label.TextSize, expected, "Expected the pin to match the label's own TextSize")
		end)
	end
	function ButtonPreferredTextSize:offNoPin()
		withMounted(400, 200, app(false, React.createElement(Button, {
			text = "Save",
		})), function(mounted)
			local label = waitForButtonText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
		end)
	end
	function ButtonPreferredTextSize:tracksScale()
		withMounted(400, 200, app(true, React.createElement(Button, {
			text = "Save",
			scale = "xs",
		})), function(mounted)
			local label = waitForButtonText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, expectedSize("xs"))
			mounted.update(app(true, React.createElement(Button, {
				text = "Save",
				scale = "xl",
			})))
			settleFrames(1)
			assertTextSizePinned(label, expectedSize("xl"))
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With the switch on, the button label is pinned to the button typography size for each scale")
	local _decorator_2 = Each({ { "xs" }, { "md" }, { "xl" } })
	local _descriptor = Test(ButtonPreferredTextSize, "pinsLabel", {
		value = ButtonPreferredTextSize.pinsLabel,
	})
	if _descriptor then
		ButtonPreferredTextSize.pinsLabel = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(ButtonPreferredTextSize, "pinsLabel", {
		value = ButtonPreferredTextSize.pinsLabel,
	})
	if _descriptor_1 then
		ButtonPreferredTextSize.pinsLabel = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(ButtonPreferredTextSize, "pinsLabel", {
		value = ButtonPreferredTextSize.pinsLabel,
	})
	if _descriptor_2 then
		ButtonPreferredTextSize.pinsLabel = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(ButtonPreferredTextSize, "pinsLabel", {
		value = ButtonPreferredTextSize.pinsLabel,
	})
	if _descriptor_3 then
		ButtonPreferredTextSize.pinsLabel = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With the switch off, the button label is left unpinned")
	local _descriptor_4 = Test(ButtonPreferredTextSize, "offNoPin", {
		value = ButtonPreferredTextSize.offNoPin,
	})
	if _descriptor_4 then
		ButtonPreferredTextSize.offNoPin = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(ButtonPreferredTextSize, "offNoPin", {
		value = ButtonPreferredTextSize.offNoPin,
	})
	if _descriptor_5 then
		ButtonPreferredTextSize.offNoPin = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(ButtonPreferredTextSize, "offNoPin", {
		value = ButtonPreferredTextSize.offNoPin,
	})
	if _descriptor_6 then
		ButtonPreferredTextSize.offNoPin = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Changing the button scale moves the pin on its label to the new size")
	local _descriptor_7 = Test(ButtonPreferredTextSize, "tracksScale", {
		value = ButtonPreferredTextSize.tracksScale,
	})
	if _descriptor_7 then
		ButtonPreferredTextSize.tracksScale = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(ButtonPreferredTextSize, "tracksScale", {
		value = ButtonPreferredTextSize.tracksScale,
	})
	if _descriptor_8 then
		ButtonPreferredTextSize.tracksScale = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(ButtonPreferredTextSize, "tracksScale", {
		value = ButtonPreferredTextSize.tracksScale,
	})
	if _descriptor_9 then
		ButtonPreferredTextSize.tracksScale = _descriptor_9.value
	end
	ButtonPreferredTextSize = Tag("Studio")(ButtonPreferredTextSize) or ButtonPreferredTextSize
end
return ButtonPreferredTextSize
