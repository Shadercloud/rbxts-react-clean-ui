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
local PinTextSize = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "PinTextSize").PinTextSize
local useIgnorePreferredTextSize = TS.import(script, script.Parent.Parent.Parent.Parent, "Contexts", "textsize.context").useIgnorePreferredTextSize
local CleanUiProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertTextSizeNotPinned = _layout.assertTextSizeNotPinned
local assertTextSizePinned = _layout.assertTextSizePinned
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local withMounted = _layout.withMounted
local function pinnedLabel(size, enabled)
	local _attributes = {
		key = "Label",
		Text = "Pinned",
	}
	local _condition = size
	if _condition == nil then
		_condition = 14
	end
	_attributes.TextSize = _condition
	_attributes.Size = UDim2.fromOffset(100, 30)
	return React.createElement("textlabel", _attributes, React.createElement(PinTextSize, {
		size = size,
		enabled = enabled,
	}))
end
local function SwitchLabel()
	local enabled = useIgnorePreferredTextSize()
	return React.createElement("textlabel", {
		key = "Label",
		Text = "Switch",
		TextSize = 20,
		Size = UDim2.fromOffset(100, 30),
	}, React.createElement(PinTextSize, {
		size = 20,
		enabled = enabled,
	}))
end
local function waitForLabel(host)
	return waitForDescendant(host, "Label", function()
		return true
	end)
end
local PinTextSizeStandalone
do
	PinTextSizeStandalone = setmetatable({}, {
		__tostring = function()
			return "PinTextSizeStandalone"
		end,
	})
	PinTextSizeStandalone.__index = PinTextSizeStandalone
	function PinTextSizeStandalone.new(...)
		local self = setmetatable({}, PinTextSizeStandalone)
		return self:constructor(...) or self
	end
	function PinTextSizeStandalone:constructor()
	end
	function PinTextSizeStandalone:pinsSize(size)
		withMounted(300, 200, pinnedLabel(size), function(mounted)
			assertTextSizePinned(waitForLabel(mounted.host), size)
		end)
	end
	function PinTextSizeStandalone:clampsRange(size, expected)
		withMounted(300, 200, pinnedLabel(size), function(mounted)
			assertTextSizePinned(waitForLabel(mounted.host), expected)
		end)
	end
	function PinTextSizeStandalone:undefinedSize()
		withMounted(300, 200, pinnedLabel(nil), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			Assert:equal(#label:GetChildren(), 0, "Expected the label to have no children")
		end)
	end
	function PinTextSizeStandalone:enabledToggle()
		withMounted(300, 200, pinnedLabel(18, false), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			Assert:equal(#label:GetChildren(), 0, "Expected no constraint while enabled is false")
			mounted.update(pinnedLabel(18, true))
			settleFrames(1)
			assertTextSizePinned(label, 18)
		end)
	end
	function PinTextSizeStandalone:tracksSize()
		withMounted(300, 200, pinnedLabel(18), function(mounted)
			local label = waitForLabel(mounted.host)
			assertTextSizePinned(label, 18)
			mounted.update(pinnedLabel(30))
			settleFrames(1)
			assertTextSizePinned(label, 30)
		end)
	end
	function PinTextSizeStandalone:hookDefaultsOff()
		withMounted(300, 200, React.createElement(SwitchLabel), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
		end)
	end
	function PinTextSizeStandalone:hookFollowsProvider(ignore)
		withMounted(300, 200, React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
			toasts = false,
			ignorePreferredTextSize = ignore,
		}, React.createElement(SwitchLabel)), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			if ignore then
				assertTextSizePinned(label, 20)
			else
				assertTextSizeNotPinned(label)
			end
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A size renders one PinTextSize constraint with equal min and max at that size")
	local _decorator_2 = Each({ { 8 }, { 18 }, { 42 } })
	local _descriptor = Test(PinTextSizeStandalone, "pinsSize", {
		value = PinTextSizeStandalone.pinsSize,
	})
	if _descriptor then
		PinTextSizeStandalone.pinsSize = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(PinTextSizeStandalone, "pinsSize", {
		value = PinTextSizeStandalone.pinsSize,
	})
	if _descriptor_1 then
		PinTextSizeStandalone.pinsSize = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(PinTextSizeStandalone, "pinsSize", {
		value = PinTextSizeStandalone.pinsSize,
	})
	if _descriptor_2 then
		PinTextSizeStandalone.pinsSize = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(PinTextSizeStandalone, "pinsSize", {
		value = PinTextSizeStandalone.pinsSize,
	})
	if _descriptor_3 then
		PinTextSizeStandalone.pinsSize = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Sizes outside Roblox's 1-100 text size range are clamped into it")
	local _decorator_5 = Each({ { 0, 1 }, { -5, 1 }, { 150, 100 } })
	local _descriptor_4 = Test(PinTextSizeStandalone, "clampsRange", {
		value = PinTextSizeStandalone.clampsRange,
	})
	if _descriptor_4 then
		PinTextSizeStandalone.clampsRange = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(PinTextSizeStandalone, "clampsRange", {
		value = PinTextSizeStandalone.clampsRange,
	})
	if _descriptor_5 then
		PinTextSizeStandalone.clampsRange = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(PinTextSizeStandalone, "clampsRange", {
		value = PinTextSizeStandalone.clampsRange,
	})
	if _descriptor_6 then
		PinTextSizeStandalone.clampsRange = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(PinTextSizeStandalone, "clampsRange", {
		value = PinTextSizeStandalone.clampsRange,
	})
	if _descriptor_7 then
		PinTextSizeStandalone.clampsRange = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("An undefined size renders no constraint at all")
	local _descriptor_8 = Test(PinTextSizeStandalone, "undefinedSize", {
		value = PinTextSizeStandalone.undefinedSize,
	})
	if _descriptor_8 then
		PinTextSizeStandalone.undefinedSize = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_7(PinTextSizeStandalone, "undefinedSize", {
		value = PinTextSizeStandalone.undefinedSize,
	})
	if _descriptor_9 then
		PinTextSizeStandalone.undefinedSize = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_6(PinTextSizeStandalone, "undefinedSize", {
		value = PinTextSizeStandalone.undefinedSize,
	})
	if _descriptor_10 then
		PinTextSizeStandalone.undefinedSize = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("enabled={false} renders nothing and switching it back on adds the pin")
	local _descriptor_11 = Test(PinTextSizeStandalone, "enabledToggle", {
		value = PinTextSizeStandalone.enabledToggle,
	})
	if _descriptor_11 then
		PinTextSizeStandalone.enabledToggle = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(PinTextSizeStandalone, "enabledToggle", {
		value = PinTextSizeStandalone.enabledToggle,
	})
	if _descriptor_12 then
		PinTextSizeStandalone.enabledToggle = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(PinTextSizeStandalone, "enabledToggle", {
		value = PinTextSizeStandalone.enabledToggle,
	})
	if _descriptor_13 then
		PinTextSizeStandalone.enabledToggle = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Changing the size prop updates the existing constraint to the new size")
	local _descriptor_14 = Test(PinTextSizeStandalone, "tracksSize", {
		value = PinTextSizeStandalone.tracksSize,
	})
	if _descriptor_14 then
		PinTextSizeStandalone.tracksSize = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(PinTextSizeStandalone, "tracksSize", {
		value = PinTextSizeStandalone.tracksSize,
	})
	if _descriptor_15 then
		PinTextSizeStandalone.tracksSize = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(PinTextSizeStandalone, "tracksSize", {
		value = PinTextSizeStandalone.tracksSize,
	})
	if _descriptor_16 then
		PinTextSizeStandalone.tracksSize = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("Gated by useIgnorePreferredTextSize, the pin is absent without a provider")
	local _descriptor_17 = Test(PinTextSizeStandalone, "hookDefaultsOff", {
		value = PinTextSizeStandalone.hookDefaultsOff,
	})
	if _descriptor_17 then
		PinTextSizeStandalone.hookDefaultsOff = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(PinTextSizeStandalone, "hookDefaultsOff", {
		value = PinTextSizeStandalone.hookDefaultsOff,
	})
	if _descriptor_18 then
		PinTextSizeStandalone.hookDefaultsOff = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(PinTextSizeStandalone, "hookDefaultsOff", {
		value = PinTextSizeStandalone.hookDefaultsOff,
	})
	if _descriptor_19 then
		PinTextSizeStandalone.hookDefaultsOff = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Gated by useIgnorePreferredTextSize, the pin follows CleanUiProvider's ignorePreferredTextSize")
	local _decorator_16 = Each({ { true }, { false } })
	local _descriptor_20 = Test(PinTextSizeStandalone, "hookFollowsProvider", {
		value = PinTextSizeStandalone.hookFollowsProvider,
	})
	if _descriptor_20 then
		PinTextSizeStandalone.hookFollowsProvider = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_16(PinTextSizeStandalone, "hookFollowsProvider", {
		value = PinTextSizeStandalone.hookFollowsProvider,
	})
	if _descriptor_21 then
		PinTextSizeStandalone.hookFollowsProvider = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(PinTextSizeStandalone, "hookFollowsProvider", {
		value = PinTextSizeStandalone.hookFollowsProvider,
	})
	if _descriptor_22 then
		PinTextSizeStandalone.hookFollowsProvider = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(PinTextSizeStandalone, "hookFollowsProvider", {
		value = PinTextSizeStandalone.hookFollowsProvider,
	})
	if _descriptor_23 then
		PinTextSizeStandalone.hookFollowsProvider = _descriptor_23.value
	end
	PinTextSizeStandalone = Tag("Studio")(PinTextSizeStandalone) or PinTextSizeStandalone
end
return PinTextSizeStandalone
