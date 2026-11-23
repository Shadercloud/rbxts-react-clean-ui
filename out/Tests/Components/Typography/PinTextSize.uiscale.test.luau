-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local PinTextSize = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "PinTextSize").PinTextSize
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertTextSizeNotPinned = _layout.assertTextSizeNotPinned
local assertTextSizePinned = _layout.assertTextSizePinned
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local withMounted = _layout.withMounted
local function pinnedLabel(size)
	return React.createElement("textlabel", {
		key = "Label",
		Text = "Pinned",
		TextSize = size,
		Size = UDim2.fromOffset(100, 30),
	}, React.createElement(PinTextSize, {
		size = size,
	}))
end
local function scaledLabel(scale, size)
	return React.createElement(UiScaleRoot, {
		scale = scale,
	}, pinnedLabel(size))
end
local function nestedLabel(outer, inner, size)
	return React.createElement(UiScaleRoot, {
		scale = outer,
		name = "OuterRoot",
	}, React.createElement(UiScaleRoot, {
		scale = inner,
		name = "InnerRoot",
	}, pinnedLabel(size)))
end
local function waitForLabel(host)
	return waitForDescendant(host, "Label", function()
		return true
	end)
end
local PinTextSizeUiScale
do
	PinTextSizeUiScale = setmetatable({}, {
		__tostring = function()
			return "PinTextSizeUiScale"
		end,
	})
	PinTextSizeUiScale.__index = PinTextSizeUiScale
	function PinTextSizeUiScale.new(...)
		local self = setmetatable({}, PinTextSizeUiScale)
		return self:constructor(...) or self
	end
	function PinTextSizeUiScale:constructor()
	end
	function PinTextSizeUiScale:scalesPin(scale, size, expected)
		withMounted(400, 300, scaledLabel(scale, size), function(mounted)
			assertTextSizePinned(waitForLabel(mounted.host), expected)
		end)
	end
	function PinTextSizeUiScale:nestedMultiplies(outer, inner, size, expected)
		withMounted(400, 300, nestedLabel(outer, inner, size), function(mounted)
			assertTextSizePinned(waitForLabel(mounted.host), expected)
		end)
	end
	function PinTextSizeUiScale:tracksScale()
		withMounted(400, 300, scaledLabel(1, 18), function(mounted)
			local label = waitForLabel(mounted.host)
			assertTextSizePinned(label, 18)
			mounted.update(scaledLabel(1.5, 18))
			settleFrames(1)
			assertTextSizePinned(label, 27)
			mounted.update(scaledLabel(3, 18))
			settleFrames(1)
			assertTextSizePinned(label, 54)
		end)
	end
	function PinTextSizeUiScale:overCapNoPin(scale, size)
		withMounted(400, 300, scaledLabel(scale, size), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
		end)
	end
	function PinTextSizeUiScale:exactCapPins(scale, size)
		withMounted(400, 300, scaledLabel(scale, size), function(mounted)
			assertTextSizePinned(waitForLabel(mounted.host), 100)
		end)
	end
	function PinTextSizeUiScale:capToggles()
		withMounted(400, 300, scaledLabel(1, 48), function(mounted)
			local label = waitForLabel(mounted.host)
			assertTextSizePinned(label, 48)
			mounted.update(scaledLabel(3, 48))
			settleFrames(2)
			assertTextSizeNotPinned(label)
			mounted.update(scaledLabel(2, 48))
			settleFrames(1)
			assertTextSizePinned(label, 96)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Under a UiScaleRoot the pin is the design size times the root scale")
	local _decorator_2 = Each({ { 1, 18, 18 }, { 1.5, 18, 27 }, { 3, 18, 54 }, { 1.5, 24, 36 }, { 3, 24, 72 } })
	local _descriptor = Test(PinTextSizeUiScale, "scalesPin", {
		value = PinTextSizeUiScale.scalesPin,
	})
	if _descriptor then
		PinTextSizeUiScale.scalesPin = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(PinTextSizeUiScale, "scalesPin", {
		value = PinTextSizeUiScale.scalesPin,
	})
	if _descriptor_1 then
		PinTextSizeUiScale.scalesPin = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(PinTextSizeUiScale, "scalesPin", {
		value = PinTextSizeUiScale.scalesPin,
	})
	if _descriptor_2 then
		PinTextSizeUiScale.scalesPin = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(PinTextSizeUiScale, "scalesPin", {
		value = PinTextSizeUiScale.scalesPin,
	})
	if _descriptor_3 then
		PinTextSizeUiScale.scalesPin = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Nested UiScaleRoots multiply, so 1.25 inside 1.2 pins at 1.5 times the size")
	local _decorator_5 = Each({ { 1.25, 1.2, 18, 27 }, { 2, 1.5, 10, 30 } })
	local _descriptor_4 = Test(PinTextSizeUiScale, "nestedMultiplies", {
		value = PinTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_4 then
		PinTextSizeUiScale.nestedMultiplies = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(PinTextSizeUiScale, "nestedMultiplies", {
		value = PinTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_5 then
		PinTextSizeUiScale.nestedMultiplies = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(PinTextSizeUiScale, "nestedMultiplies", {
		value = PinTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_6 then
		PinTextSizeUiScale.nestedMultiplies = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(PinTextSizeUiScale, "nestedMultiplies", {
		value = PinTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_7 then
		PinTextSizeUiScale.nestedMultiplies = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Changing the root scale prop re-pins the existing label at the new screen size")
	local _descriptor_8 = Test(PinTextSizeUiScale, "tracksScale", {
		value = PinTextSizeUiScale.tracksScale,
	})
	if _descriptor_8 then
		PinTextSizeUiScale.tracksScale = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_7(PinTextSizeUiScale, "tracksScale", {
		value = PinTextSizeUiScale.tracksScale,
	})
	if _descriptor_9 then
		PinTextSizeUiScale.tracksScale = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_6(PinTextSizeUiScale, "tracksScale", {
		value = PinTextSizeUiScale.tracksScale,
	})
	if _descriptor_10 then
		PinTextSizeUiScale.tracksScale = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A screen size above 100 renders no pin rather than a capped one")
	local _decorator_10 = Each({ { 3, 48 }, { 3, 96 }, { 2, 60 } })
	local _descriptor_11 = Test(PinTextSizeUiScale, "overCapNoPin", {
		value = PinTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_11 then
		PinTextSizeUiScale.overCapNoPin = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_10(PinTextSizeUiScale, "overCapNoPin", {
		value = PinTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_12 then
		PinTextSizeUiScale.overCapNoPin = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(PinTextSizeUiScale, "overCapNoPin", {
		value = PinTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_13 then
		PinTextSizeUiScale.overCapNoPin = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(PinTextSizeUiScale, "overCapNoPin", {
		value = PinTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_14 then
		PinTextSizeUiScale.overCapNoPin = _descriptor_14.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("A screen size of exactly 100 is still pinned")
	local _decorator_13 = Each({ { 1, 100 }, { 2, 50 }, { 2.5, 40 } })
	local _descriptor_15 = Test(PinTextSizeUiScale, "exactCapPins", {
		value = PinTextSizeUiScale.exactCapPins,
	})
	if _descriptor_15 then
		PinTextSizeUiScale.exactCapPins = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_13(PinTextSizeUiScale, "exactCapPins", {
		value = PinTextSizeUiScale.exactCapPins,
	})
	if _descriptor_16 then
		PinTextSizeUiScale.exactCapPins = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(PinTextSizeUiScale, "exactCapPins", {
		value = PinTextSizeUiScale.exactCapPins,
	})
	if _descriptor_17 then
		PinTextSizeUiScale.exactCapPins = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(PinTextSizeUiScale, "exactCapPins", {
		value = PinTextSizeUiScale.exactCapPins,
	})
	if _descriptor_18 then
		PinTextSizeUiScale.exactCapPins = _descriptor_18.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Scaling the root up past the cap removes the pin and scaling back down restores it")
	local _descriptor_19 = Test(PinTextSizeUiScale, "capToggles", {
		value = PinTextSizeUiScale.capToggles,
	})
	if _descriptor_19 then
		PinTextSizeUiScale.capToggles = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_15(PinTextSizeUiScale, "capToggles", {
		value = PinTextSizeUiScale.capToggles,
	})
	if _descriptor_20 then
		PinTextSizeUiScale.capToggles = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_14(PinTextSizeUiScale, "capToggles", {
		value = PinTextSizeUiScale.capToggles,
	})
	if _descriptor_21 then
		PinTextSizeUiScale.capToggles = _descriptor_21.value
	end
	PinTextSizeUiScale = Tag("Studio")(PinTextSizeUiScale) or PinTextSizeUiScale
end
return PinTextSizeUiScale
