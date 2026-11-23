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
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
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
local SPACED_TEXT = "Hey"
local SCALE_EPSILON = 0.01
local function app(ignore, child)
	return React.createElement(CleanUiProvider, {
		theme = DefaultTheme,
		toasts = false,
		ignorePreferredTextSize = ignore,
	}, child)
end
local function scaled(scale, child, ignore)
	if ignore == nil then
		ignore = true
	end
	return app(ignore, React.createElement(UiScaleRoot, {
		scale = scale,
	}, child))
end
local function waitForText(host)
	return waitForDescendant(host, "Text", function()
		return true
	end)
end
local function characterLabels(frame)
	local labels = {}
	for _, child in frame:GetChildren() do
		if child:IsA("TextLabel") then
			table.insert(labels, child)
		end
	end
	return labels
end
local function assertBoundsConstraint(label, expectedMin, expectedMax)
	local found = textSizeConstraintsOf(label)
	Assert:equal(#found, 1, "Expected exactly one UITextSizeConstraint")
	Assert:equal(found[1].Name, "TextSizeConstraint", "Expected the bounds constraint, not a pin")
	Assert:equal(found[1].MinTextSize, expectedMin, "Unexpected MinTextSize")
	Assert:equal(found[1].MaxTextSize, expectedMax, "Unexpected MaxTextSize")
end
local TextPreferredTextSizeUiScale
do
	TextPreferredTextSizeUiScale = setmetatable({}, {
		__tostring = function()
			return "TextPreferredTextSizeUiScale"
		end,
	})
	TextPreferredTextSizeUiScale.__index = TextPreferredTextSizeUiScale
	function TextPreferredTextSizeUiScale.new(...)
		local self = setmetatable({}, TextPreferredTextSizeUiScale)
		return self:constructor(...) or self
	end
	function TextPreferredTextSizeUiScale:constructor()
	end
	function TextPreferredTextSizeUiScale:pinsScaled(scale, variant, size)
		withMounted(400, 300, scaled(scale, React.createElement(Text, {
			text = "Hello",
			variant = variant,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			Assert:equal(label.TextSize, size, "Expected the label's TextSize to stay at the design size")
			assertTextSizePinned(label, label.TextSize * scale)
		end)
	end
	function TextPreferredTextSizeUiScale:pinsSpacedScaled()
		withMounted(400, 300, scaled(1.5, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
			variant = "heading",
		})), function(mounted)
			local frame = waitForText(mounted.host)
			settleFrames(1)
			Assert:equal(#textSizeConstraintsOf(frame), 0, "Expected no UITextSizeConstraint on the frame itself")
			local labels = characterLabels(frame)
			Assert:equal(#labels, #SPACED_TEXT, "Expected one character label per character")
			for _, label in labels do
				assertTextSizePinned(label, 36)
			end
		end)
	end
	function TextPreferredTextSizeUiScale:nestedMultiplies()
		local tree = app(true, React.createElement(UiScaleRoot, {
			scale = 1.25,
			name = "OuterRoot",
		}, React.createElement(UiScaleRoot, {
			scale = 1.2,
			name = "InnerRoot",
		}, React.createElement(Text, {
			text = "Hello",
		}))))
		withMounted(400, 300, tree, function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, 27)
		end)
	end
	function TextPreferredTextSizeUiScale:tracksScale()
		withMounted(400, 300, scaled(1, React.createElement(Text, {
			text = "Hello",
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, 18)
			mounted.update(scaled(1.5, React.createElement(Text, {
				text = "Hello",
			})))
			settleFrames(1)
			assertTextSizePinned(label, 27)
			mounted.update(scaled(3, React.createElement(Text, {
				text = "Hello",
			})))
			settleFrames(1)
			assertTextSizePinned(label, 54)
		end)
	end
	function TextPreferredTextSizeUiScale:overCapNoPin(variant, scale)
		withMounted(400, 300, scaled(scale, React.createElement(Text, {
			text = "Hello",
			variant = variant,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
			Assert:equal(#textSizeConstraintsOf(label), 0, "Expected no UITextSizeConstraint without min/max bounds")
		end)
	end
	function TextPreferredTextSizeUiScale:overrideOverCap()
		local _object = table.clone(DefaultTheme.typography.body)
		setmetatable(_object, nil)
		_object.size = Enum.FontSize.Size96
		local typography = _object
		withMounted(400, 300, scaled(3, React.createElement(Text, {
			text = "Hi",
			typography = typography,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
		end)
	end
	function TextPreferredTextSizeUiScale:exactCapPins()
		withMounted(400, 300, scaled(5, React.createElement(Text, {
			text = "Hello",
			minTextSize = 20,
			maxTextSize = 20,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, 100)
		end)
	end
	function TextPreferredTextSizeUiScale:overCapBounds(scale, minTextSize, maxTextSize, expectedMin, expectedMax)
		withMounted(400, 300, scaled(scale, React.createElement(Text, {
			text = "Hello",
			variant = "display",
			minTextSize = minTextSize,
			maxTextSize = maxTextSize,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
			assertBoundsConstraint(label, expectedMin, expectedMax)
		end)
	end
	function TextPreferredTextSizeUiScale:offBoundsScaled()
		withMounted(400, 300, scaled(1.5, React.createElement(Text, {
			text = "Hello",
			minTextSize = 10,
			maxTextSize = 30,
		}), false), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertBoundsConstraint(label, 15, 45)
		end)
	end
	function TextPreferredTextSizeUiScale:shrinkScaledPin()
		withMounted(400, 300, scaled(1.5, React.createElement(Text, {
			text = "A long title",
			shrinkToFit = true,
			maxWidth = 40,
		})), function(mounted)
			local label = waitForText(mounted.host)
			local shrink = waitForDescendant(mounted.host, "ShrinkScale", function()
				return true
			end)
			settleFrames(3)
			Assert["true"](Assert, shrink.Scale < 1 - SCALE_EPSILON, `Expected the text to shrink (ShrinkScale is {shrink.Scale})`)
			local found = textSizeConstraintsOf(label)
			Assert:equal(#found, 1, "Expected exactly one UITextSizeConstraint")
			Assert:equal(found[1].Name, "PinTextSize", "Expected the pin constraint")
			Assert:equal(found[1].MinTextSize, found[1].MaxTextSize, "Expected MinTextSize to equal MaxTextSize")
			local expected = 18 * 1.5 * shrink.Scale
			Assert["true"](Assert, math.abs(found[1].MinTextSize - expected) <= 1, `Expected the pin to be about {expected}, got {found[1].MinTextSize}`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Under a UiScaleRoot the pin is the label's own TextSize times the root scale")
	local _decorator_2 = Each({ { 1, "body", 18 }, { 1.5, "body", 18 }, { 3, "body", 18 }, { 1, "heading", 24 }, { 1.5, "heading", 24 }, { 3, "heading", 24 } })
	local _descriptor = Test(TextPreferredTextSizeUiScale, "pinsScaled", {
		value = TextPreferredTextSizeUiScale.pinsScaled,
	})
	if _descriptor then
		TextPreferredTextSizeUiScale.pinsScaled = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextPreferredTextSizeUiScale, "pinsScaled", {
		value = TextPreferredTextSizeUiScale.pinsScaled,
	})
	if _descriptor_1 then
		TextPreferredTextSizeUiScale.pinsScaled = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextPreferredTextSizeUiScale, "pinsScaled", {
		value = TextPreferredTextSizeUiScale.pinsScaled,
	})
	if _descriptor_2 then
		TextPreferredTextSizeUiScale.pinsScaled = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextPreferredTextSizeUiScale, "pinsScaled", {
		value = TextPreferredTextSizeUiScale.pinsScaled,
	})
	if _descriptor_3 then
		TextPreferredTextSizeUiScale.pinsScaled = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Letter-spaced text under a 1.5 root pins every character label at 1.5 times the size")
	local _descriptor_4 = Test(TextPreferredTextSizeUiScale, "pinsSpacedScaled", {
		value = TextPreferredTextSizeUiScale.pinsSpacedScaled,
	})
	if _descriptor_4 then
		TextPreferredTextSizeUiScale.pinsSpacedScaled = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TextPreferredTextSizeUiScale, "pinsSpacedScaled", {
		value = TextPreferredTextSizeUiScale.pinsSpacedScaled,
	})
	if _descriptor_5 then
		TextPreferredTextSizeUiScale.pinsSpacedScaled = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextPreferredTextSizeUiScale, "pinsSpacedScaled", {
		value = TextPreferredTextSizeUiScale.pinsSpacedScaled,
	})
	if _descriptor_6 then
		TextPreferredTextSizeUiScale.pinsSpacedScaled = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Nested roots of 1.25 and 1.2 multiply into a 1.5 times pin")
	local _descriptor_7 = Test(TextPreferredTextSizeUiScale, "nestedMultiplies", {
		value = TextPreferredTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_7 then
		TextPreferredTextSizeUiScale.nestedMultiplies = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TextPreferredTextSizeUiScale, "nestedMultiplies", {
		value = TextPreferredTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_8 then
		TextPreferredTextSizeUiScale.nestedMultiplies = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TextPreferredTextSizeUiScale, "nestedMultiplies", {
		value = TextPreferredTextSizeUiScale.nestedMultiplies,
	})
	if _descriptor_9 then
		TextPreferredTextSizeUiScale.nestedMultiplies = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Changing the root scale prop re-pins the same label at each new screen size")
	local _descriptor_10 = Test(TextPreferredTextSizeUiScale, "tracksScale", {
		value = TextPreferredTextSizeUiScale.tracksScale,
	})
	if _descriptor_10 then
		TextPreferredTextSizeUiScale.tracksScale = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TextPreferredTextSizeUiScale, "tracksScale", {
		value = TextPreferredTextSizeUiScale.tracksScale,
	})
	if _descriptor_11 then
		TextPreferredTextSizeUiScale.tracksScale = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TextPreferredTextSizeUiScale, "tracksScale", {
		value = TextPreferredTextSizeUiScale.tracksScale,
	})
	if _descriptor_12 then
		TextPreferredTextSizeUiScale.tracksScale = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("A pin that would exceed 100 on screen is dropped and no other constraint takes its place")
	local _decorator_11 = Each({ { "display", 3 }, { "title", 3.5 } })
	local _descriptor_13 = Test(TextPreferredTextSizeUiScale, "overCapNoPin", {
		value = TextPreferredTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_13 then
		TextPreferredTextSizeUiScale.overCapNoPin = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_11(TextPreferredTextSizeUiScale, "overCapNoPin", {
		value = TextPreferredTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_14 then
		TextPreferredTextSizeUiScale.overCapNoPin = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_10(TextPreferredTextSizeUiScale, "overCapNoPin", {
		value = TextPreferredTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_15 then
		TextPreferredTextSizeUiScale.overCapNoPin = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_9(TextPreferredTextSizeUiScale, "overCapNoPin", {
		value = TextPreferredTextSizeUiScale.overCapNoPin,
	})
	if _descriptor_16 then
		TextPreferredTextSizeUiScale.overCapNoPin = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A 96 typography override at scale 3 renders no PinTextSize")
	local _descriptor_17 = Test(TextPreferredTextSizeUiScale, "overrideOverCap", {
		value = TextPreferredTextSizeUiScale.overrideOverCap,
	})
	if _descriptor_17 then
		TextPreferredTextSizeUiScale.overrideOverCap = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(TextPreferredTextSizeUiScale, "overrideOverCap", {
		value = TextPreferredTextSizeUiScale.overrideOverCap,
	})
	if _descriptor_18 then
		TextPreferredTextSizeUiScale.overrideOverCap = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(TextPreferredTextSizeUiScale, "overrideOverCap", {
		value = TextPreferredTextSizeUiScale.overrideOverCap,
	})
	if _descriptor_19 then
		TextPreferredTextSizeUiScale.overrideOverCap = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("A pin landing on exactly 100 on screen is still emitted")
	local _descriptor_20 = Test(TextPreferredTextSizeUiScale, "exactCapPins", {
		value = TextPreferredTextSizeUiScale.exactCapPins,
	})
	if _descriptor_20 then
		TextPreferredTextSizeUiScale.exactCapPins = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(TextPreferredTextSizeUiScale, "exactCapPins", {
		value = TextPreferredTextSizeUiScale.exactCapPins,
	})
	if _descriptor_21 then
		TextPreferredTextSizeUiScale.exactCapPins = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(TextPreferredTextSizeUiScale, "exactCapPins", {
		value = TextPreferredTextSizeUiScale.exactCapPins,
	})
	if _descriptor_22 then
		TextPreferredTextSizeUiScale.exactCapPins = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("Above the cap, minTextSize/maxTextSize fall back to a TextSizeConstraint scaled and clamped to 1-100")
	local _decorator_18 = Each({ { 3, 10, 40, 30, 100 }, { 3, 12, 50, 36, 100 }, { 2.5, 20, 60, 50, 100 } })
	local _descriptor_23 = Test(TextPreferredTextSizeUiScale, "overCapBounds", {
		value = TextPreferredTextSizeUiScale.overCapBounds,
	})
	if _descriptor_23 then
		TextPreferredTextSizeUiScale.overCapBounds = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_18(TextPreferredTextSizeUiScale, "overCapBounds", {
		value = TextPreferredTextSizeUiScale.overCapBounds,
	})
	if _descriptor_24 then
		TextPreferredTextSizeUiScale.overCapBounds = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(TextPreferredTextSizeUiScale, "overCapBounds", {
		value = TextPreferredTextSizeUiScale.overCapBounds,
	})
	if _descriptor_25 then
		TextPreferredTextSizeUiScale.overCapBounds = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(TextPreferredTextSizeUiScale, "overCapBounds", {
		value = TextPreferredTextSizeUiScale.overCapBounds,
	})
	if _descriptor_26 then
		TextPreferredTextSizeUiScale.overCapBounds = _descriptor_26.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("With the switch off, minTextSize/maxTextSize under a 1.5 root render a 1.5 times TextSizeConstraint")
	local _descriptor_27 = Test(TextPreferredTextSizeUiScale, "offBoundsScaled", {
		value = TextPreferredTextSizeUiScale.offBoundsScaled,
	})
	if _descriptor_27 then
		TextPreferredTextSizeUiScale.offBoundsScaled = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_20(TextPreferredTextSizeUiScale, "offBoundsScaled", {
		value = TextPreferredTextSizeUiScale.offBoundsScaled,
	})
	if _descriptor_28 then
		TextPreferredTextSizeUiScale.offBoundsScaled = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_19(TextPreferredTextSizeUiScale, "offBoundsScaled", {
		value = TextPreferredTextSizeUiScale.offBoundsScaled,
	})
	if _descriptor_29 then
		TextPreferredTextSizeUiScale.offBoundsScaled = _descriptor_29.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName("shrinkToFit under a 1.5 root pins at the size times the root scale times the ShrinkScale")
	local _descriptor_30 = Test(TextPreferredTextSizeUiScale, "shrinkScaledPin", {
		value = TextPreferredTextSizeUiScale.shrinkScaledPin,
	})
	if _descriptor_30 then
		TextPreferredTextSizeUiScale.shrinkScaledPin = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_22(TextPreferredTextSizeUiScale, "shrinkScaledPin", {
		value = TextPreferredTextSizeUiScale.shrinkScaledPin,
	})
	if _descriptor_31 then
		TextPreferredTextSizeUiScale.shrinkScaledPin = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_21(TextPreferredTextSizeUiScale, "shrinkScaledPin", {
		value = TextPreferredTextSizeUiScale.shrinkScaledPin,
	})
	if _descriptor_32 then
		TextPreferredTextSizeUiScale.shrinkScaledPin = _descriptor_32.value
	end
	TextPreferredTextSizeUiScale = Tag("Studio")(TextPreferredTextSizeUiScale) or TextPreferredTextSizeUiScale
end
return TextPreferredTextSizeUiScale
