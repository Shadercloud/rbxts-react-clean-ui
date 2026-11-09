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
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertTextFits = _layout.assertTextFits
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local SHORT_TEXT = "Hello"
local LONG_TEXT = "The quick brown fox jumps over the lazy dog again and again until it wraps."
local MAX_WIDTH = 120
local SPACED_TEXT = "Hey"
local function waitForLabel(host)
	return waitForGuiObject(host, "Text")
end
local function textSizeConstraintsOf(instance)
	local found = {}
	for _, child in instance:GetChildren() do
		if child:IsA("UITextSizeConstraint") then
			table.insert(found, child)
		end
	end
	return found
end
local function soleTextSizeConstraint(instance)
	local found = textSizeConstraintsOf(instance)
	Assert:equal(#found, 1, `Expected exactly one UITextSizeConstraint directly on {instance:GetFullName()}`)
	Assert:equal(found[1].Name, "TextSizeConstraint", `Expected the UITextSizeConstraint on {instance.Name} to be named TextSizeConstraint`)
	return found[1]
end
local function boundsFor(kind, value)
	return if kind == "min" then {
		minTextSize = value,
	} else {
		maxTextSize = value,
	}
end
local function scaledLabel(maxTextSize)
	return React.createElement(Text, {
		text = "Hi",
		TextScaled = true,
		Size = UDim2.fromOffset(300, 200),
		AutomaticSize = Enum.AutomaticSize.None,
		maxTextSize = maxTextSize,
	})
end
local TextSizeLimits
do
	TextSizeLimits = setmetatable({}, {
		__tostring = function()
			return "TextSizeLimits"
		end,
	})
	TextSizeLimits.__index = TextSizeLimits
	function TextSizeLimits.new(...)
		local self = setmetatable({}, TextSizeLimits)
		return self:constructor(...) or self
	end
	function TextSizeLimits:constructor()
	end
	function TextSizeLimits:maxWidthConstraint()
		withMounted(400, 300, React.createElement(Text, {
			text = LONG_TEXT,
			maxWidth = MAX_WIDTH,
		}), function(mounted)
			local constraint = soleSizeConstraint(waitForLabel(mounted.host))
			Assert:equal(constraint.MaxSize.X, MAX_WIDTH, "Expected MaxSize.X to be the maxWidth")
		end)
	end
	function TextSizeLimits:maxWidthWraps()
		withMounted(400, 300, React.createElement(Text, {
			text = LONG_TEXT,
			maxWidth = MAX_WIDTH,
		}), function(mounted)
			local label = waitForGuiObject(mounted.host, "Text", function(gui)
				return gui.AbsoluteSize.X > 0 and gui.TextBounds.Y > gui.TextSize * 1.5
			end, "Timed out waiting for the maxWidth Text to wrap onto more than one line")
			Assert["true"](Assert, rect(label).width <= MAX_WIDTH + 1, `Expected the wrapped label width {rect(label).width} to stay within {MAX_WIDTH}px`)
			Assert["true"](Assert, rect(label).height > label.TextSize * 1.5, `Expected the label height {rect(label).height} to grow past one line of {label.TextSize}px`)
			assertTextFits(label, "maxWidth text")
		end)
	end
	function TextSizeLimits:shortKeepsNatural()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
		}), function(mounted)
			local label = waitForLabel(mounted.host)
			local natural = rect(label)
			Assert["true"](Assert, natural.width < MAX_WIDTH, `Expected the short text width {natural.width} to be under {MAX_WIDTH}px`)
			mounted.update(React.createElement(Text, {
				text = SHORT_TEXT,
				maxWidth = MAX_WIDTH,
			}))
			settleFrames(2)
			Assert["true"](Assert, math.abs(rect(label).width - natural.width) <= 1, `Expected width {rect(label).width} to stay at the natural {natural.width}`)
			Assert["true"](Assert, math.abs(rect(label).height - natural.height) <= 1, `Expected height {rect(label).height} to stay at the natural {natural.height}`)
		end)
	end
	function TextSizeLimits:shrinkDropsMaxWidth()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
			shrinkToFit = true,
			maxWidth = MAX_WIDTH,
		}), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			Assert:equal(#sizeConstraintsOf(label), 0, "Expected no UISizeConstraint while shrinkToFit uses maxWidth")
		end)
	end
	function TextSizeLimits:shrinkKeepsMinWidth()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
			shrinkToFit = true,
			maxWidth = MAX_WIDTH,
			minWidth = 10,
		}), function(mounted)
			local constraint = soleSizeConstraint(waitForLabel(mounted.host))
			Assert:equal(constraint.MinSize.X, 10, "Expected the minWidth to stay in the constraint")
			Assert:equal(constraint.MaxSize.X, math.huge, "Expected the maxWidth to be left out of the constraint")
		end)
	end
	function TextSizeLimits:textSizeClamped(minTextSize, maxTextSize, expectedMin, expectedMax)
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
			minTextSize = minTextSize,
			maxTextSize = maxTextSize,
		}), function(mounted)
			local constraint = soleTextSizeConstraint(waitForLabel(mounted.host))
			Assert:equal(constraint.MinTextSize, expectedMin, "Unexpected MinTextSize")
			Assert:equal(constraint.MaxTextSize, expectedMax, "Unexpected MaxTextSize")
		end)
	end
	function TextSizeLimits:textSizeDefaults(kind, value, expectedMin, expectedMax)
		local _attributes = {
			text = SHORT_TEXT,
		}
		for _k, _v in boundsFor(kind, value) do
			_attributes[_k] = _v
		end
		withMounted(400, 300, React.createElement(Text, _attributes), function(mounted)
			local constraint = soleTextSizeConstraint(waitForLabel(mounted.host))
			Assert:equal(constraint.MinTextSize, expectedMin, "Unexpected MinTextSize")
			Assert:equal(constraint.MaxTextSize, expectedMax, "Unexpected MaxTextSize")
		end)
	end
	function TextSizeLimits:spacedConstraintPerCharacter()
		withMounted(400, 300, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
			maxTextSize = 30,
		}), function(mounted)
			local frame = waitForGuiObject(mounted.host, "Text")
			local count = 0
			Assert:equal(#textSizeConstraintsOf(frame), 0, "Expected no UITextSizeConstraint on the frame itself")
			for _, child in frame:GetChildren() do
				if not child:IsA("TextLabel") then
					continue
				end
				count += 1
				Assert:equal(soleTextSizeConstraint(child).MaxTextSize, 30, `Unexpected MaxTextSize on {child.Name}`)
			end
			Assert:equal(count, #SPACED_TEXT, "Expected one character label per character")
		end)
	end
	function TextSizeLimits:scaledCapped()
		withMounted(400, 300, scaledLabel(), function(mounted)
			local label = waitForLabel(mounted.host)
			local uncapped = waitForLayout(function()
				return if label.TextBounds.Y > 48 then label.TextBounds.Y else nil
			end, `Timed out waiting for uncapped TextScaled text to exceed 48px (TextBounds.Y is {label.TextBounds.Y})`)
			mounted.update(scaledLabel(24))
			local capped = waitForLayout(function()
				return if label.TextBounds.Y <= 24 * 1.5 then label.TextBounds.Y else nil
			end, `Timed out waiting for maxTextSize=\{24\} to cap the text (TextBounds.Y is {label.TextBounds.Y}, uncapped was {uncapped})`)
			Assert["true"](Assert, capped >= 12, `Expected the capped text to stay near 24px, got TextBounds.Y={capped}`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("maxWidth on a plain label adds a single SizeConstraint capped at that width")
	local _descriptor = Test(TextSizeLimits, "maxWidthConstraint", {
		value = TextSizeLimits.maxWidthConstraint,
	})
	if _descriptor then
		TextSizeLimits.maxWidthConstraint = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextSizeLimits, "maxWidthConstraint", {
		value = TextSizeLimits.maxWidthConstraint,
	})
	if _descriptor_1 then
		TextSizeLimits.maxWidthConstraint = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextSizeLimits, "maxWidthConstraint", {
		value = TextSizeLimits.maxWidthConstraint,
	})
	if _descriptor_2 then
		TextSizeLimits.maxWidthConstraint = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Long text under maxWidth wraps onto several lines within that width and grows in height")
	local _descriptor_3 = Test(TextSizeLimits, "maxWidthWraps", {
		value = TextSizeLimits.maxWidthWraps,
	})
	if _descriptor_3 then
		TextSizeLimits.maxWidthWraps = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextSizeLimits, "maxWidthWraps", {
		value = TextSizeLimits.maxWidthWraps,
	})
	if _descriptor_4 then
		TextSizeLimits.maxWidthWraps = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextSizeLimits, "maxWidthWraps", {
		value = TextSizeLimits.maxWidthWraps,
	})
	if _descriptor_5 then
		TextSizeLimits.maxWidthWraps = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Short text under a wider maxWidth keeps its natural single-line width")
	local _descriptor_6 = Test(TextSizeLimits, "shortKeepsNatural", {
		value = TextSizeLimits.shortKeepsNatural,
	})
	if _descriptor_6 then
		TextSizeLimits.shortKeepsNatural = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextSizeLimits, "shortKeepsNatural", {
		value = TextSizeLimits.shortKeepsNatural,
	})
	if _descriptor_7 then
		TextSizeLimits.shortKeepsNatural = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextSizeLimits, "shortKeepsNatural", {
		value = TextSizeLimits.shortKeepsNatural,
	})
	if _descriptor_8 then
		TextSizeLimits.shortKeepsNatural = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("shrinkToFit with maxWidth leaves maxWidth out, so no SizeConstraint is rendered")
	local _descriptor_9 = Test(TextSizeLimits, "shrinkDropsMaxWidth", {
		value = TextSizeLimits.shrinkDropsMaxWidth,
	})
	if _descriptor_9 then
		TextSizeLimits.shrinkDropsMaxWidth = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextSizeLimits, "shrinkDropsMaxWidth", {
		value = TextSizeLimits.shrinkDropsMaxWidth,
	})
	if _descriptor_10 then
		TextSizeLimits.shrinkDropsMaxWidth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextSizeLimits, "shrinkDropsMaxWidth", {
		value = TextSizeLimits.shrinkDropsMaxWidth,
	})
	if _descriptor_11 then
		TextSizeLimits.shrinkDropsMaxWidth = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("shrinkToFit with maxWidth and minWidth keeps only the minimum in the SizeConstraint")
	local _descriptor_12 = Test(TextSizeLimits, "shrinkKeepsMinWidth", {
		value = TextSizeLimits.shrinkKeepsMinWidth,
	})
	if _descriptor_12 then
		TextSizeLimits.shrinkKeepsMinWidth = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TextSizeLimits, "shrinkKeepsMinWidth", {
		value = TextSizeLimits.shrinkKeepsMinWidth,
	})
	if _descriptor_13 then
		TextSizeLimits.shrinkKeepsMinWidth = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextSizeLimits, "shrinkKeepsMinWidth", {
		value = TextSizeLimits.shrinkKeepsMinWidth,
	})
	if _descriptor_14 then
		TextSizeLimits.shrinkKeepsMinWidth = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("minTextSize and maxTextSize are clamped to 1-100 and a maximum below the minimum is raised to it")
	local _decorator_12 = Each({ { 10, 40, 10, 40 }, { 0, 50, 1, 50 }, { 20, 200, 20, 100 }, { 40, 20, 40, 40 }, { 150, 150, 100, 100 } })
	local _descriptor_15 = Test(TextSizeLimits, "textSizeClamped", {
		value = TextSizeLimits.textSizeClamped,
	})
	if _descriptor_15 then
		TextSizeLimits.textSizeClamped = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_12(TextSizeLimits, "textSizeClamped", {
		value = TextSizeLimits.textSizeClamped,
	})
	if _descriptor_16 then
		TextSizeLimits.textSizeClamped = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_11(TextSizeLimits, "textSizeClamped", {
		value = TextSizeLimits.textSizeClamped,
	})
	if _descriptor_17 then
		TextSizeLimits.textSizeClamped = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_10(TextSizeLimits, "textSizeClamped", {
		value = TextSizeLimits.textSizeClamped,
	})
	if _descriptor_18 then
		TextSizeLimits.textSizeClamped = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("Setting only one text size bound defaults the other to 1 or 100")
	local _decorator_15 = Each({ { "max", 30, 1, 30 }, { "min", 30, 30, 100 } })
	local _descriptor_19 = Test(TextSizeLimits, "textSizeDefaults", {
		value = TextSizeLimits.textSizeDefaults,
	})
	if _descriptor_19 then
		TextSizeLimits.textSizeDefaults = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_15(TextSizeLimits, "textSizeDefaults", {
		value = TextSizeLimits.textSizeDefaults,
	})
	if _descriptor_20 then
		TextSizeLimits.textSizeDefaults = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_14(TextSizeLimits, "textSizeDefaults", {
		value = TextSizeLimits.textSizeDefaults,
	})
	if _descriptor_21 then
		TextSizeLimits.textSizeDefaults = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_13(TextSizeLimits, "textSizeDefaults", {
		value = TextSizeLimits.textSizeDefaults,
	})
	if _descriptor_22 then
		TextSizeLimits.textSizeDefaults = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("Letter-spaced text puts a TextSizeConstraint on every character label and none on the frame")
	local _descriptor_23 = Test(TextSizeLimits, "spacedConstraintPerCharacter", {
		value = TextSizeLimits.spacedConstraintPerCharacter,
	})
	if _descriptor_23 then
		TextSizeLimits.spacedConstraintPerCharacter = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_17(TextSizeLimits, "spacedConstraintPerCharacter", {
		value = TextSizeLimits.spacedConstraintPerCharacter,
	})
	if _descriptor_24 then
		TextSizeLimits.spacedConstraintPerCharacter = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_16(TextSizeLimits, "spacedConstraintPerCharacter", {
		value = TextSizeLimits.spacedConstraintPerCharacter,
	})
	if _descriptor_25 then
		TextSizeLimits.spacedConstraintPerCharacter = _descriptor_25.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("TextScaled text in a 300x200 box grows past 48px uncapped but stays about 24px with maxTextSize={24}")
	local _descriptor_26 = Test(TextSizeLimits, "scaledCapped", {
		value = TextSizeLimits.scaledCapped,
	})
	if _descriptor_26 then
		TextSizeLimits.scaledCapped = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_19(TextSizeLimits, "scaledCapped", {
		value = TextSizeLimits.scaledCapped,
	})
	if _descriptor_27 then
		TextSizeLimits.scaledCapped = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_18(TextSizeLimits, "scaledCapped", {
		value = TextSizeLimits.scaledCapped,
	})
	if _descriptor_28 then
		TextSizeLimits.scaledCapped = _descriptor_28.value
	end
	TextSizeLimits = Tag("Studio")(TextSizeLimits) or TextSizeLimits
end
return TextSizeLimits
