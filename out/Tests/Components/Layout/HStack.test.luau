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
local HStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "HStack").HStack
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertStackedHorizontally = _layout.assertStackedHorizontally
local describeGui = _layout.describeGui
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local STACK_WIDTH = 400
local STACK_HEIGHT = 200
local function stackChild(name, order)
	return React.createElement("frame", {
		key = name,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(60, 30),
		LayoutOrder = order,
	})
end
local function hstack(children, props)
	if props == nil then
		props = {}
	end
	return React.createElement("frame", {
		key = "Stack",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		spacing = props.spacing,
		valign = props.valign,
		HorizontalAlignment = props.HorizontalAlignment,
	}, children))
end
local function threeChildren()
	return React.createElement(React.Fragment, nil, stackChild("First", 1), stackChild("Second", 2), stackChild("Third", 3))
end
local function assertHorizontalGap(leading, trailing, expectedGap, label)
	local gap = rect(trailing).left - rect(leading).right
	Assert["true"](Assert, math.abs(gap - expectedGap) <= 1, `{label}: expected a {expectedGap}px gap between {describeGui(leading)} and {describeGui(trailing)}, got {gap}px`)
end
local HStackMountValidation
do
	HStackMountValidation = setmetatable({}, {
		__tostring = function()
			return "HStackMountValidation"
		end,
	})
	HStackMountValidation.__index = HStackMountValidation
	function HStackMountValidation.new(...)
		local self = setmetatable({}, HStackMountValidation)
		return self:constructor(...) or self
	end
	function HStackMountValidation:constructor()
	end
	function HStackMountValidation:childrenInOrder()
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren()), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local first = waitForGuiObject(stack, "First")
			local second = findDescendant(stack, "Second")
			local third = findDescendant(stack, "Third")
			assertAlignedLeft(first, stack, 1, "hstack order")
			assertStackedHorizontally({ first, second, third }, "hstack order")
		end)
	end
	function HStackMountValidation:gapMatchesSpacing(spacing, expectedGap)
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren(), {
			spacing = spacing,
		}), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local first = waitForGuiObject(stack, "First")
			local second = findDescendant(stack, "Second")
			local third = findDescendant(stack, "Third")
			assertHorizontalGap(first, second, expectedGap, `spacing={spacing}`)
			assertHorizontalGap(second, third, expectedGap, `spacing={spacing}`)
		end)
	end
	function HStackMountValidation:centerAlignment()
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(stackChild("Only", 1), {
			valign = "Center",
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local only = waitForGuiObject(stack, "Only")
			assertCenteredIn(only, stack, "both", 1, "centered hstack child")
		end)
	end
	function HStackMountValidation:allContained()
		withMounted(STACK_WIDTH, STACK_HEIGHT, hstack(threeChildren()), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			waitForGuiObject(stack, "Third")
			assertAllDescendantsContained(stack, "hstack children")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Children are laid out left-to-right in LayoutOrder, starting at the stack's left edge")
	local _descriptor = Test(HStackMountValidation, "childrenInOrder", {
		value = HStackMountValidation.childrenInOrder,
	})
	if _descriptor then
		HStackMountValidation.childrenInOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(HStackMountValidation, "childrenInOrder", {
		value = HStackMountValidation.childrenInOrder,
	})
	if _descriptor_1 then
		HStackMountValidation.childrenInOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(HStackMountValidation, "childrenInOrder", {
		value = HStackMountValidation.childrenInOrder,
	})
	if _descriptor_2 then
		HStackMountValidation.childrenInOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "None", 0 }, { "md", 6 }, { "xl", 12 } })
	local _decorator_4 = DisplayName("The gap between siblings is half the theme spacing value for the given spacing key")
	local _descriptor_3 = Test(HStackMountValidation, "gapMatchesSpacing", {
		value = HStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_3 then
		HStackMountValidation.gapMatchesSpacing = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(HStackMountValidation, "gapMatchesSpacing", {
		value = HStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_4 then
		HStackMountValidation.gapMatchesSpacing = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(HStackMountValidation, "gapMatchesSpacing", {
		value = HStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_5 then
		HStackMountValidation.gapMatchesSpacing = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(HStackMountValidation, "gapMatchesSpacing", {
		value = HStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_6 then
		HStackMountValidation.gapMatchesSpacing = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("valign=Center with HorizontalAlignment=Center places a lone child in the middle of the stack")
	local _descriptor_7 = Test(HStackMountValidation, "centerAlignment", {
		value = HStackMountValidation.centerAlignment,
	})
	if _descriptor_7 then
		HStackMountValidation.centerAlignment = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(HStackMountValidation, "centerAlignment", {
		value = HStackMountValidation.centerAlignment,
	})
	if _descriptor_8 then
		HStackMountValidation.centerAlignment = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(HStackMountValidation, "centerAlignment", {
		value = HStackMountValidation.centerAlignment,
	})
	if _descriptor_9 then
		HStackMountValidation.centerAlignment = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With default props every visible child stays inside the stack's parent frame")
	local _descriptor_10 = Test(HStackMountValidation, "allContained", {
		value = HStackMountValidation.allContained,
	})
	if _descriptor_10 then
		HStackMountValidation.allContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(HStackMountValidation, "allContained", {
		value = HStackMountValidation.allContained,
	})
	if _descriptor_11 then
		HStackMountValidation.allContained = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(HStackMountValidation, "allContained", {
		value = HStackMountValidation.allContained,
	})
	if _descriptor_12 then
		HStackMountValidation.allContained = _descriptor_12.value
	end
	HStackMountValidation = Tag("Studio")(HStackMountValidation) or HStackMountValidation
end
return HStackMountValidation
