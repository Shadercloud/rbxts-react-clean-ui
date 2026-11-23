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
local function app(ignore, child)
	return React.createElement(CleanUiProvider, {
		theme = DefaultTheme,
		toasts = false,
		ignorePreferredTextSize = ignore,
	}, child)
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
local function boundsFor(minTextSize, maxTextSize)
	return {
		minTextSize = if minTextSize > 0 then minTextSize else nil,
		maxTextSize = if maxTextSize > 0 then maxTextSize else nil,
	}
end
local TextPreferredTextSize
do
	TextPreferredTextSize = setmetatable({}, {
		__tostring = function()
			return "TextPreferredTextSize"
		end,
	})
	TextPreferredTextSize.__index = TextPreferredTextSize
	function TextPreferredTextSize.new(...)
		local self = setmetatable({}, TextPreferredTextSize)
		return self:constructor(...) or self
	end
	function TextPreferredTextSize:constructor()
	end
	function TextPreferredTextSize:pinsVariant(variant, expected)
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hello",
			variant = variant,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, expected)
			Assert:equal(label.TextSize, expected, "Expected the pin to match the label's own TextSize")
		end)
	end
	function TextPreferredTextSize:offNoPin()
		withMounted(400, 300, app(false, React.createElement(Text, {
			text = "Hello",
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
			Assert:equal(#textSizeConstraintsOf(label), 0, "Expected no UITextSizeConstraint with the switch off")
		end)
	end
	function TextPreferredTextSize:noProviderNoPin()
		withMounted(400, 300, React.createElement(Text, {
			text = "Hello",
		}), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
		end)
	end
	function TextPreferredTextSize:pinsTypographyOverride()
		local _object = table.clone(DefaultTheme.typography.body)
		setmetatable(_object, nil)
		_object.size = Enum.FontSize.Size12
		local typography = _object
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hello",
			typography = typography,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, 12)
		end)
	end
	function TextPreferredTextSize:pinsSpacedChars()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
			variant = "heading",
		})), function(mounted)
			local frame = waitForText(mounted.host)
			settleFrames(1)
			Assert["true"](Assert, frame:IsA("Frame"), "Expected the letter-spaced root to be a Frame")
			Assert:equal(#textSizeConstraintsOf(frame), 0, "Expected no UITextSizeConstraint on the frame itself")
			local labels = characterLabels(frame)
			Assert:equal(#labels, #SPACED_TEXT, "Expected one character label per character")
			for _, label in labels do
				assertTextSizePinned(label, 24)
			end
		end)
	end
	function TextPreferredTextSize:spacedOffNoPin()
		withMounted(400, 300, app(false, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
		})), function(mounted)
			local frame = waitForText(mounted.host)
			settleFrames(2)
			for _, label in characterLabels(frame) do
				assertTextSizeNotPinned(label)
			end
		end)
	end
	function TextPreferredTextSize:tracksVariant()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hello",
			variant = "body",
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, 18)
			mounted.update(app(true, React.createElement(Text, {
				text = "Hello",
				variant = "title",
			})))
			settleFrames(1)
			assertTextSizePinned(label, 32)
		end)
	end
	function TextPreferredTextSize:tracksSwitch()
		withMounted(400, 300, app(false, React.createElement(Text, {
			text = "Hello",
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizeNotPinned(label)
			mounted.update(app(true, React.createElement(Text, {
				text = "Hello",
			})))
			settleFrames(1)
			assertTextSizePinned(label, 18)
			mounted.update(app(false, React.createElement(Text, {
				text = "Hello",
			})))
			settleFrames(1)
			assertTextSizeNotPinned(label)
		end)
	end
	function TextPreferredTextSize:scaledSkipped()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hi",
			TextScaled = true,
			Size = UDim2.fromOffset(300, 200),
			AutomaticSize = Enum.AutomaticSize.None,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(2)
			assertTextSizeNotPinned(label)
			Assert:equal(#textSizeConstraintsOf(label), 0, "Expected no UITextSizeConstraint on scaled text")
		end)
	end
	function TextPreferredTextSize:scaledKeepsBounds()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hi",
			TextScaled = true,
			maxTextSize = 24,
			Size = UDim2.fromOffset(300, 200),
			AutomaticSize = Enum.AutomaticSize.None,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			local found = textSizeConstraintsOf(label)
			Assert:equal(#found, 1, "Expected exactly one UITextSizeConstraint")
			Assert:equal(found[1].Name, "TextSizeConstraint", "Expected the bounds constraint, not a pin")
			Assert:equal(found[1].MaxTextSize, 24, "Unexpected MaxTextSize")
		end)
	end
	function TextPreferredTextSize:scaledBinding()
		local scaled, setScaled = React.createBinding(true)
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "Hi",
			TextScaled = scaled,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			local pin = label:FindFirstChild("PinTextSize")
			Assert:notUndefined(pin, "Expected a PinTextSize constraint driven by the binding")
			Assert:equal(#textSizeConstraintsOf(label), 1, "Expected only the binding-driven constraint")
			Assert:equal(pin.MinTextSize, 1, "Expected MinTextSize 1 while scaled")
			Assert:equal(pin.MaxTextSize, 100, "Expected MaxTextSize 100 while scaled")
			setScaled(false)
			settleFrames(1)
			assertTextSizePinned(label, 18)
		end)
	end
	function TextPreferredTextSize:boundsReplaced(minTextSize, maxTextSize, expected)
		local _attributes = {
			text = "Hello",
		}
		for _k, _v in boundsFor(minTextSize, maxTextSize) do
			_attributes[_k] = _v
		end
		withMounted(400, 300, app(true, React.createElement(Text, _attributes)), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			assertTextSizePinned(label, expected)
		end)
	end
	function TextPreferredTextSize:boundsKeptWhenOff()
		withMounted(400, 300, app(false, React.createElement(Text, {
			text = "Hello",
			minTextSize = 10,
			maxTextSize = 30,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(1)
			local found = textSizeConstraintsOf(label)
			Assert:equal(#found, 1, "Expected exactly one UITextSizeConstraint")
			Assert:equal(found[1].Name, "TextSizeConstraint", "Expected the bounds constraint")
			Assert:equal(found[1].MinTextSize, 10, "Unexpected MinTextSize")
			Assert:equal(found[1].MaxTextSize, 30, "Unexpected MaxTextSize")
		end)
	end
	function TextPreferredTextSize:spacedBoundsReplaced()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
			maxTextSize = 12,
		})), function(mounted)
			local frame = waitForText(mounted.host)
			settleFrames(1)
			for _, label in characterLabels(frame) do
				assertTextSizePinned(label, 12)
			end
		end)
	end
	function TextPreferredTextSize:shrinkKeepsPin()
		withMounted(400, 300, app(true, React.createElement(Text, {
			text = "A long title",
			shrinkToFit = true,
			maxWidth = 40,
		})), function(mounted)
			local label = waitForText(mounted.host)
			settleFrames(3)
			assertTextSizePinned(label, 18)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With the switch on, each variant's label is pinned to its theme size in pixels")
	local _decorator_2 = Each({ { "display", 48 }, { "title", 32 }, { "heading", 24 }, { "body", 18 }, { "label", 14 }, { "caption", 10 } })
	local _descriptor = Test(TextPreferredTextSize, "pinsVariant", {
		value = TextPreferredTextSize.pinsVariant,
	})
	if _descriptor then
		TextPreferredTextSize.pinsVariant = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextPreferredTextSize, "pinsVariant", {
		value = TextPreferredTextSize.pinsVariant,
	})
	if _descriptor_1 then
		TextPreferredTextSize.pinsVariant = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextPreferredTextSize, "pinsVariant", {
		value = TextPreferredTextSize.pinsVariant,
	})
	if _descriptor_2 then
		TextPreferredTextSize.pinsVariant = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextPreferredTextSize, "pinsVariant", {
		value = TextPreferredTextSize.pinsVariant,
	})
	if _descriptor_3 then
		TextPreferredTextSize.pinsVariant = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With the switch off, a plain label has no PinTextSize and no other text size constraint")
	local _descriptor_4 = Test(TextPreferredTextSize, "offNoPin", {
		value = TextPreferredTextSize.offNoPin,
	})
	if _descriptor_4 then
		TextPreferredTextSize.offNoPin = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TextPreferredTextSize, "offNoPin", {
		value = TextPreferredTextSize.offNoPin,
	})
	if _descriptor_5 then
		TextPreferredTextSize.offNoPin = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextPreferredTextSize, "offNoPin", {
		value = TextPreferredTextSize.offNoPin,
	})
	if _descriptor_6 then
		TextPreferredTextSize.offNoPin = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Without any CleanUiProvider the label is never pinned")
	local _descriptor_7 = Test(TextPreferredTextSize, "noProviderNoPin", {
		value = TextPreferredTextSize.noProviderNoPin,
	})
	if _descriptor_7 then
		TextPreferredTextSize.noProviderNoPin = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TextPreferredTextSize, "noProviderNoPin", {
		value = TextPreferredTextSize.noProviderNoPin,
	})
	if _descriptor_8 then
		TextPreferredTextSize.noProviderNoPin = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TextPreferredTextSize, "noProviderNoPin", {
		value = TextPreferredTextSize.noProviderNoPin,
	})
	if _descriptor_9 then
		TextPreferredTextSize.noProviderNoPin = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("A typography override's size is the one pinned, not the variant's")
	local _descriptor_10 = Test(TextPreferredTextSize, "pinsTypographyOverride", {
		value = TextPreferredTextSize.pinsTypographyOverride,
	})
	if _descriptor_10 then
		TextPreferredTextSize.pinsTypographyOverride = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TextPreferredTextSize, "pinsTypographyOverride", {
		value = TextPreferredTextSize.pinsTypographyOverride,
	})
	if _descriptor_11 then
		TextPreferredTextSize.pinsTypographyOverride = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TextPreferredTextSize, "pinsTypographyOverride", {
		value = TextPreferredTextSize.pinsTypographyOverride,
	})
	if _descriptor_12 then
		TextPreferredTextSize.pinsTypographyOverride = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Letter-spaced text pins every character label and leaves the frame without a constraint")
	local _descriptor_13 = Test(TextPreferredTextSize, "pinsSpacedChars", {
		value = TextPreferredTextSize.pinsSpacedChars,
	})
	if _descriptor_13 then
		TextPreferredTextSize.pinsSpacedChars = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TextPreferredTextSize, "pinsSpacedChars", {
		value = TextPreferredTextSize.pinsSpacedChars,
	})
	if _descriptor_14 then
		TextPreferredTextSize.pinsSpacedChars = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TextPreferredTextSize, "pinsSpacedChars", {
		value = TextPreferredTextSize.pinsSpacedChars,
	})
	if _descriptor_15 then
		TextPreferredTextSize.pinsSpacedChars = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Letter-spaced text with the switch off leaves every character label unpinned")
	local _descriptor_16 = Test(TextPreferredTextSize, "spacedOffNoPin", {
		value = TextPreferredTextSize.spacedOffNoPin,
	})
	if _descriptor_16 then
		TextPreferredTextSize.spacedOffNoPin = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(TextPreferredTextSize, "spacedOffNoPin", {
		value = TextPreferredTextSize.spacedOffNoPin,
	})
	if _descriptor_17 then
		TextPreferredTextSize.spacedOffNoPin = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(TextPreferredTextSize, "spacedOffNoPin", {
		value = TextPreferredTextSize.spacedOffNoPin,
	})
	if _descriptor_18 then
		TextPreferredTextSize.spacedOffNoPin = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("Re-rendering with a different variant updates the pin to the new size")
	local _descriptor_19 = Test(TextPreferredTextSize, "tracksVariant", {
		value = TextPreferredTextSize.tracksVariant,
	})
	if _descriptor_19 then
		TextPreferredTextSize.tracksVariant = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(TextPreferredTextSize, "tracksVariant", {
		value = TextPreferredTextSize.tracksVariant,
	})
	if _descriptor_20 then
		TextPreferredTextSize.tracksVariant = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(TextPreferredTextSize, "tracksVariant", {
		value = TextPreferredTextSize.tracksVariant,
	})
	if _descriptor_21 then
		TextPreferredTextSize.tracksVariant = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("Turning the switch on and off at runtime adds and removes the pin")
	local _descriptor_22 = Test(TextPreferredTextSize, "tracksSwitch", {
		value = TextPreferredTextSize.tracksSwitch,
	})
	if _descriptor_22 then
		TextPreferredTextSize.tracksSwitch = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(TextPreferredTextSize, "tracksSwitch", {
		value = TextPreferredTextSize.tracksSwitch,
	})
	if _descriptor_23 then
		TextPreferredTextSize.tracksSwitch = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(TextPreferredTextSize, "tracksSwitch", {
		value = TextPreferredTextSize.tracksSwitch,
	})
	if _descriptor_24 then
		TextPreferredTextSize.tracksSwitch = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("TextScaled={true} text is never pinned even with the switch on")
	local _descriptor_25 = Test(TextPreferredTextSize, "scaledSkipped", {
		value = TextPreferredTextSize.scaledSkipped,
	})
	if _descriptor_25 then
		TextPreferredTextSize.scaledSkipped = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(TextPreferredTextSize, "scaledSkipped", {
		value = TextPreferredTextSize.scaledSkipped,
	})
	if _descriptor_26 then
		TextPreferredTextSize.scaledSkipped = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(TextPreferredTextSize, "scaledSkipped", {
		value = TextPreferredTextSize.scaledSkipped,
	})
	if _descriptor_27 then
		TextPreferredTextSize.scaledSkipped = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("TextScaled={true} with maxTextSize keeps the plain TextSizeConstraint instead of a pin")
	local _descriptor_28 = Test(TextPreferredTextSize, "scaledKeepsBounds", {
		value = TextPreferredTextSize.scaledKeepsBounds,
	})
	if _descriptor_28 then
		TextPreferredTextSize.scaledKeepsBounds = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_20(TextPreferredTextSize, "scaledKeepsBounds", {
		value = TextPreferredTextSize.scaledKeepsBounds,
	})
	if _descriptor_29 then
		TextPreferredTextSize.scaledKeepsBounds = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_19(TextPreferredTextSize, "scaledKeepsBounds", {
		value = TextPreferredTextSize.scaledKeepsBounds,
	})
	if _descriptor_30 then
		TextPreferredTextSize.scaledKeepsBounds = _descriptor_30.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName("A TextScaled binding opens the pin to 1-100 while true and pins the style size while false")
	local _descriptor_31 = Test(TextPreferredTextSize, "scaledBinding", {
		value = TextPreferredTextSize.scaledBinding,
	})
	if _descriptor_31 then
		TextPreferredTextSize.scaledBinding = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_22(TextPreferredTextSize, "scaledBinding", {
		value = TextPreferredTextSize.scaledBinding,
	})
	if _descriptor_32 then
		TextPreferredTextSize.scaledBinding = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_21(TextPreferredTextSize, "scaledBinding", {
		value = TextPreferredTextSize.scaledBinding,
	})
	if _descriptor_33 then
		TextPreferredTextSize.scaledBinding = _descriptor_33.value
	end
	local _decorator_23 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_24 = DisplayName("With minTextSize/maxTextSize the pin replaces TextSizeConstraint, at the body size clamped into the range")
	local _decorator_25 = Each({ { 0, 12, 12 }, { 24, 0, 24 }, { 10, 30, 18 }, { 18, 18, 18 }, { 0, 150, 18 } })
	local _descriptor_34 = Test(TextPreferredTextSize, "boundsReplaced", {
		value = TextPreferredTextSize.boundsReplaced,
	})
	if _descriptor_34 then
		TextPreferredTextSize.boundsReplaced = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_25(TextPreferredTextSize, "boundsReplaced", {
		value = TextPreferredTextSize.boundsReplaced,
	})
	if _descriptor_35 then
		TextPreferredTextSize.boundsReplaced = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_24(TextPreferredTextSize, "boundsReplaced", {
		value = TextPreferredTextSize.boundsReplaced,
	})
	if _descriptor_36 then
		TextPreferredTextSize.boundsReplaced = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_23(TextPreferredTextSize, "boundsReplaced", {
		value = TextPreferredTextSize.boundsReplaced,
	})
	if _descriptor_37 then
		TextPreferredTextSize.boundsReplaced = _descriptor_37.value
	end
	local _decorator_26 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_27 = DisplayName("With the switch off, minTextSize/maxTextSize still render the plain TextSizeConstraint")
	local _descriptor_38 = Test(TextPreferredTextSize, "boundsKeptWhenOff", {
		value = TextPreferredTextSize.boundsKeptWhenOff,
	})
	if _descriptor_38 then
		TextPreferredTextSize.boundsKeptWhenOff = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_27(TextPreferredTextSize, "boundsKeptWhenOff", {
		value = TextPreferredTextSize.boundsKeptWhenOff,
	})
	if _descriptor_39 then
		TextPreferredTextSize.boundsKeptWhenOff = _descriptor_39.value
	end
	local _descriptor_40 = _decorator_26(TextPreferredTextSize, "boundsKeptWhenOff", {
		value = TextPreferredTextSize.boundsKeptWhenOff,
	})
	if _descriptor_40 then
		TextPreferredTextSize.boundsKeptWhenOff = _descriptor_40.value
	end
	local _decorator_28 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_29 = DisplayName("Letter-spaced text with maxTextSize pins each character to the clamped size with no leftover bounds constraint")
	local _descriptor_41 = Test(TextPreferredTextSize, "spacedBoundsReplaced", {
		value = TextPreferredTextSize.spacedBoundsReplaced,
	})
	if _descriptor_41 then
		TextPreferredTextSize.spacedBoundsReplaced = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_29(TextPreferredTextSize, "spacedBoundsReplaced", {
		value = TextPreferredTextSize.spacedBoundsReplaced,
	})
	if _descriptor_42 then
		TextPreferredTextSize.spacedBoundsReplaced = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_28(TextPreferredTextSize, "spacedBoundsReplaced", {
		value = TextPreferredTextSize.spacedBoundsReplaced,
	})
	if _descriptor_43 then
		TextPreferredTextSize.spacedBoundsReplaced = _descriptor_43.value
	end
	local _decorator_30 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_31 = DisplayName("shrinkToFit leaves the pin at the style size since it shrinks through UIScale")
	local _descriptor_44 = Test(TextPreferredTextSize, "shrinkKeepsPin", {
		value = TextPreferredTextSize.shrinkKeepsPin,
	})
	if _descriptor_44 then
		TextPreferredTextSize.shrinkKeepsPin = _descriptor_44.value
	end
	local _descriptor_45 = _decorator_31(TextPreferredTextSize, "shrinkKeepsPin", {
		value = TextPreferredTextSize.shrinkKeepsPin,
	})
	if _descriptor_45 then
		TextPreferredTextSize.shrinkKeepsPin = _descriptor_45.value
	end
	local _descriptor_46 = _decorator_30(TextPreferredTextSize, "shrinkKeepsPin", {
		value = TextPreferredTextSize.shrinkKeepsPin,
	})
	if _descriptor_46 then
		TextPreferredTextSize.shrinkKeepsPin = _descriptor_46.value
	end
	TextPreferredTextSize = Tag("Studio")(TextPreferredTextSize) or TextPreferredTextSize
end
return TextPreferredTextSize
