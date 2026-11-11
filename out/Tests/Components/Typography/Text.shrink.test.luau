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
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local mountInScreenGui = _layout.mountInScreenGui
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local TITLE = "SHRINK THIS TITLE"
local NARROW_SLOT = 60
local WIDE_SLOT = 600
local SCALE_EPSILON = 0.01
local PROBE_STEP = 0.005
local function shrinkApp(options)
	local padding = options.padding
	return React.createElement("frame", {
		key = "Slot",
		Size = UDim2.fromOffset(options.slot, 40),
		BackgroundTransparency = 1,
	}, padding ~= nil and (React.createElement("uipadding", {
		key = "SlotPadding",
		PaddingLeft = UDim.new(0, padding),
		PaddingRight = UDim.new(0, padding),
	})), React.createElement(Text, {
		text = TITLE,
		TextWrap = false,
		letterSpacing = if options.spaced == false then nil else 2,
		shrinkToFit = true,
		shrinkMinScale = options.minScale,
		maxWidth = options.maxWidth,
	}))
end
local function waitForRoot(host)
	return waitForGuiObject(host, "Text")
end
local function shrinkScaleOf(host)
	return waitForDescendant(host, "ShrinkScale", function()
		return true
	end)
end
local function waitForScale(host, predicate, message)
	local scale = shrinkScaleOf(host)
	return waitForLayout(function()
		return if predicate(scale.Scale) then scale.Scale else nil
	end, `{message} (Scale is {scale.Scale})`)
end
local function assertWidthNear(root, width, label)
	local actual = rect(root).width
	Assert["true"](Assert, actual <= width + 1, `{label}: expected the visual width {actual} to fit within {width}px`)
	Assert["true"](Assert, actual >= width - 2, `{label}: expected the visual width {actual} to fill about {width}px`)
end
local function probeApp(scale)
	return React.createElement("frame", {
		key = "Probe",
		Size = UDim2.fromOffset(WIDE_SLOT, 40),
		BackgroundTransparency = 1,
	}, React.createElement("uiscale", {
		key = "ProbeScale",
		Scale = scale,
	}), React.createElement(Text, {
		text = TITLE,
		TextWrap = false,
		letterSpacing = 2,
	}))
end
local function assertLargestFit(host, root, width, label)
	settleFrames(3)
	local actual = rect(root).width
	Assert["true"](Assert, actual <= width + 1, `{label}: expected the visual width {actual} to fit within {width}px`)
	local probeScale = shrinkScaleOf(host).Scale + PROBE_STEP
	withMounted(800, 200, probeApp(probeScale), function(probe)
		local probeRoot = waitForRoot(probe.host)
		waitForLayout(function()
			return if rect(probeRoot).width > width then true else nil
		end, `{label}: expected the text at scale {probeScale} to overflow {width}px, so {actual}px is the largest fit (is {rect(probeRoot).width})`)
	end)
end
local function stackedShrinkApp(spaced)
	return React.createElement("frame", {
		key = "Stack",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, React.createElement(VStack, nil, React.createElement(Text, {
		text = string.rep("W", 24),
		variant = "heading",
		letterSpacing = if spaced then 2 else nil,
		shrinkToFit = true,
	})))
end
local function spacedFor(kind)
	return kind == "spaced"
end
local TextShrinkToFit
do
	TextShrinkToFit = setmetatable({}, {
		__tostring = function()
			return "TextShrinkToFit"
		end,
	})
	TextShrinkToFit.__index = TextShrinkToFit
	function TextShrinkToFit.new(...)
		local self = setmetatable({}, TextShrinkToFit)
		return self:constructor(...) or self
	end
	function TextShrinkToFit:constructor()
	end
	function TextShrinkToFit:shrinksIntoSlot(kind)
		withMounted(400, 200, shrinkApp({
			slot = NARROW_SLOT,
			spaced = spacedFor(kind),
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			local scale = waitForScale(mounted.host, function(value)
				return value < 1 - SCALE_EPSILON and rect(root).width <= NARROW_SLOT + 1
			end, `Timed out waiting for {kind} text to shrink into {NARROW_SLOT}px`)
			Assert["true"](Assert, scale > 0 and scale < 1, `Expected a scale between 0 and 1, got {scale}`)
			if spacedFor(kind) then
				assertLargestFit(mounted.host, root, NARROW_SLOT, `{kind} text`)
			else
				assertWidthNear(root, NARROW_SLOT, `{kind} text`)
			end
		end)
	end
	function TextShrinkToFit:respectsSlotPadding()
		withMounted(400, 200, shrinkApp({
			slot = 80,
			padding = 10,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			waitForScale(mounted.host, function()
				return rect(root).width <= 61
			end, "Timed out waiting for the text to shrink into the 60px padded content width")
			assertLargestFit(mounted.host, root, 60, "padded slot")
		end)
	end
	function TextShrinkToFit:stopsAtMinScale()
		withMounted(400, 200, shrinkApp({
			slot = 20,
			minScale = 0.75,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			waitForScale(mounted.host, function(value)
				return math.abs(value - 0.75) <= SCALE_EPSILON
			end, "Timed out waiting for the scale to settle at shrinkMinScale 0.75")
			settleFrames(3)
			local scale = shrinkScaleOf(mounted.host).Scale
			Assert["true"](Assert, math.abs(scale - 0.75) <= SCALE_EPSILON, `Expected the scale to stay at 0.75, got {scale}`)
			Assert["true"](Assert, rect(root).width > 20, `Expected the floored text {rect(root).width}px to overflow the 20px slot`)
		end)
	end
	function TextShrinkToFit:minScaleClamped()
		withMounted(400, 200, shrinkApp({
			slot = NARROW_SLOT,
			minScale = 2,
		}), function(mounted)
			waitForRoot(mounted.host)
			settleFrames(5)
			local scale = shrinkScaleOf(mounted.host).Scale
			Assert["true"](Assert, math.abs(scale - 1) <= 0.001, `Expected the scale to stay at 1, got {scale}`)
		end)
	end
	function TextShrinkToFit:neverScalesUp()
		withMounted(800, 200, shrinkApp({
			slot = WIDE_SLOT,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			settleFrames(5)
			local scale = shrinkScaleOf(mounted.host).Scale
			Assert["true"](Assert, math.abs(scale - 1) <= 0.001, `Expected the scale to stay at 1, got {scale}`)
			Assert["true"](Assert, rect(root).width < WIDE_SLOT, `Expected the natural width {rect(root).width} to be under {WIDE_SLOT}px`)
		end)
	end
	function TextShrinkToFit:recoversWhenWidened()
		withMounted(800, 200, shrinkApp({
			slot = NARROW_SLOT,
		}), function(mounted)
			waitForRoot(mounted.host)
			waitForScale(mounted.host, function(value)
				return value < 1 - SCALE_EPSILON
			end, "Timed out waiting for the initial shrink")
			mounted.update(shrinkApp({
				slot = WIDE_SLOT,
			}))
			waitForScale(mounted.host, function(value)
				return math.abs(value - 1) <= 0.001
			end, `Timed out waiting for the scale to return to 1 in a {WIDE_SLOT}px slot`)
			settleFrames(3)
			local scale = shrinkScaleOf(mounted.host).Scale
			Assert["true"](Assert, scale <= 1, `Expected the scale never to exceed 1, got {scale}`)
		end)
	end
	function TextShrinkToFit:shrinksIntoMaxWidth()
		withMounted(800, 200, shrinkApp({
			slot = WIDE_SLOT,
			maxWidth = NARROW_SLOT,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			waitForScale(mounted.host, function(value)
				return value < 1 - SCALE_EPSILON and rect(root).width <= NARROW_SLOT + 1
			end, `Timed out waiting for the text to shrink into maxWidth {NARROW_SLOT}px`)
			assertLargestFit(mounted.host, root, NARROW_SLOT, "maxWidth target")
		end)
	end
	function TextShrinkToFit:quietUnmount(kind)
		local mounted = mountInScreenGui(360, 200, stackedShrinkApp(spacedFor(kind)))
		local messages = {}
		local connection
		TS.try(function()
			waitForRoot(mounted.host)
			shrinkScaleOf(mounted.host)
			settleFrames(5)
			connection = game:GetService("LogService").MessageOut:Connect(function(message)
				if (string.find(message, "re-entrancy", 1, true)) ~= nil then
					local _message = message
					table.insert(messages, _message)
				end
			end)
			mounted.unmount()
			settleFrames(2)
		end, nil, function()
			local _result = connection
			if _result ~= nil then
				_result:Disconnect()
			end
			if mounted.host.Parent ~= nil then
				mounted.unmount()
			end
		end)
		local _exp = #messages
		local _exp_1 = kind
		local _exp_2 = #messages
		local _condition = messages[1]
		if _condition == nil then
			_condition = ""
		end
		Assert:equal(_exp, 0, `Expected no re-entrancy warnings when unmounting {_exp_1} text, got {_exp_2}: {_condition}`)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("In a slot narrower than the text, the ShrinkScale drops below 1 until the text fits the slot")
	local _decorator_2 = Each({ { "spaced" }, { "plain" } })
	local _descriptor = Test(TextShrinkToFit, "shrinksIntoSlot", {
		value = TextShrinkToFit.shrinksIntoSlot,
	})
	if _descriptor then
		TextShrinkToFit.shrinksIntoSlot = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextShrinkToFit, "shrinksIntoSlot", {
		value = TextShrinkToFit.shrinksIntoSlot,
	})
	if _descriptor_1 then
		TextShrinkToFit.shrinksIntoSlot = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextShrinkToFit, "shrinksIntoSlot", {
		value = TextShrinkToFit.shrinksIntoSlot,
	})
	if _descriptor_2 then
		TextShrinkToFit.shrinksIntoSlot = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextShrinkToFit, "shrinksIntoSlot", {
		value = TextShrinkToFit.shrinksIntoSlot,
	})
	if _descriptor_3 then
		TextShrinkToFit.shrinksIntoSlot = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("The slot's UIPadding is taken off the width the text shrinks into")
	local _descriptor_4 = Test(TextShrinkToFit, "respectsSlotPadding", {
		value = TextShrinkToFit.respectsSlotPadding,
	})
	if _descriptor_4 then
		TextShrinkToFit.respectsSlotPadding = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TextShrinkToFit, "respectsSlotPadding", {
		value = TextShrinkToFit.respectsSlotPadding,
	})
	if _descriptor_5 then
		TextShrinkToFit.respectsSlotPadding = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextShrinkToFit, "respectsSlotPadding", {
		value = TextShrinkToFit.respectsSlotPadding,
	})
	if _descriptor_6 then
		TextShrinkToFit.respectsSlotPadding = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("shrinkMinScale stops the shrink at its floor and the text then overflows the slot")
	local _descriptor_7 = Test(TextShrinkToFit, "stopsAtMinScale", {
		value = TextShrinkToFit.stopsAtMinScale,
	})
	if _descriptor_7 then
		TextShrinkToFit.stopsAtMinScale = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TextShrinkToFit, "stopsAtMinScale", {
		value = TextShrinkToFit.stopsAtMinScale,
	})
	if _descriptor_8 then
		TextShrinkToFit.stopsAtMinScale = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TextShrinkToFit, "stopsAtMinScale", {
		value = TextShrinkToFit.stopsAtMinScale,
	})
	if _descriptor_9 then
		TextShrinkToFit.stopsAtMinScale = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("A shrinkMinScale above 1 is clamped to 1, so the text never shrinks")
	local _descriptor_10 = Test(TextShrinkToFit, "minScaleClamped", {
		value = TextShrinkToFit.minScaleClamped,
	})
	if _descriptor_10 then
		TextShrinkToFit.minScaleClamped = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TextShrinkToFit, "minScaleClamped", {
		value = TextShrinkToFit.minScaleClamped,
	})
	if _descriptor_11 then
		TextShrinkToFit.minScaleClamped = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TextShrinkToFit, "minScaleClamped", {
		value = TextShrinkToFit.minScaleClamped,
	})
	if _descriptor_12 then
		TextShrinkToFit.minScaleClamped = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("In a slot wider than the text, the scale stays exactly 1 and never grows")
	local _descriptor_13 = Test(TextShrinkToFit, "neverScalesUp", {
		value = TextShrinkToFit.neverScalesUp,
	})
	if _descriptor_13 then
		TextShrinkToFit.neverScalesUp = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TextShrinkToFit, "neverScalesUp", {
		value = TextShrinkToFit.neverScalesUp,
	})
	if _descriptor_14 then
		TextShrinkToFit.neverScalesUp = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TextShrinkToFit, "neverScalesUp", {
		value = TextShrinkToFit.neverScalesUp,
	})
	if _descriptor_15 then
		TextShrinkToFit.neverScalesUp = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Widening the slot after a shrink brings the scale back to 1 and no higher")
	local _descriptor_16 = Test(TextShrinkToFit, "recoversWhenWidened", {
		value = TextShrinkToFit.recoversWhenWidened,
	})
	if _descriptor_16 then
		TextShrinkToFit.recoversWhenWidened = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(TextShrinkToFit, "recoversWhenWidened", {
		value = TextShrinkToFit.recoversWhenWidened,
	})
	if _descriptor_17 then
		TextShrinkToFit.recoversWhenWidened = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(TextShrinkToFit, "recoversWhenWidened", {
		value = TextShrinkToFit.recoversWhenWidened,
	})
	if _descriptor_18 then
		TextShrinkToFit.recoversWhenWidened = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("With maxWidth set, the text shrinks into maxWidth even inside a much wider slot")
	local _descriptor_19 = Test(TextShrinkToFit, "shrinksIntoMaxWidth", {
		value = TextShrinkToFit.shrinksIntoMaxWidth,
	})
	if _descriptor_19 then
		TextShrinkToFit.shrinksIntoMaxWidth = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(TextShrinkToFit, "shrinksIntoMaxWidth", {
		value = TextShrinkToFit.shrinksIntoMaxWidth,
	})
	if _descriptor_20 then
		TextShrinkToFit.shrinksIntoMaxWidth = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(TextShrinkToFit, "shrinksIntoMaxWidth", {
		value = TextShrinkToFit.shrinksIntoMaxWidth,
	})
	if _descriptor_21 then
		TextShrinkToFit.shrinksIntoMaxWidth = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("Unmounting shrinking text inside a VStack logs no AbsoluteSizeChanged re-entrancy warnings")
	local _decorator_17 = Each({ { "spaced" }, { "plain" } })
	local _descriptor_22 = Test(TextShrinkToFit, "quietUnmount", {
		value = TextShrinkToFit.quietUnmount,
	})
	if _descriptor_22 then
		TextShrinkToFit.quietUnmount = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_17(TextShrinkToFit, "quietUnmount", {
		value = TextShrinkToFit.quietUnmount,
	})
	if _descriptor_23 then
		TextShrinkToFit.quietUnmount = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_16(TextShrinkToFit, "quietUnmount", {
		value = TextShrinkToFit.quietUnmount,
	})
	if _descriptor_24 then
		TextShrinkToFit.quietUnmount = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_15(TextShrinkToFit, "quietUnmount", {
		value = TextShrinkToFit.quietUnmount,
	})
	if _descriptor_25 then
		TextShrinkToFit.quietUnmount = _descriptor_25.value
	end
	TextShrinkToFit = Tag("Studio")(TextShrinkToFit) or TextShrinkToFit
end
return TextShrinkToFit
