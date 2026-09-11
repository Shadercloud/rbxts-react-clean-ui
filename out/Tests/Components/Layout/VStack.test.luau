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
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedTop = _layout.assertAlignedTop
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedVertically = _layout.assertStackedVertically
local describeGui = _layout.describeGui
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local STACK_WIDTH = 300
local STACK_HEIGHT = 400
local CHILD_WIDTH = 60
local CHILD_HEIGHT = 30
local function stackChild(name, order)
	return React.createElement("frame", {
		key = name,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(CHILD_WIDTH, CHILD_HEIGHT),
		LayoutOrder = order,
	})
end
local function vstack(children, props)
	if props == nil then
		props = {}
	end
	return React.createElement("frame", {
		key = "Stack",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(VStack, {
		spacing = props.spacing,
		valign = props.valign,
		HorizontalAlignment = props.HorizontalAlignment,
		HorizontalFlex = props.HorizontalFlex,
	}, children))
end
local function threeChildren()
	return React.createElement(React.Fragment, nil, stackChild("First", 1), stackChild("Second", 2), stackChild("Third", 3))
end
local function assertVerticalGap(above, below, expectedGap, label)
	local gap = rect(below).top - rect(above).bottom
	Assert["true"](Assert, math.abs(gap - expectedGap) <= 1, `{label}: expected a {expectedGap}px gap between {describeGui(above)} and {describeGui(below)}, got {gap}px`)
end
local VStackMountValidation
do
	VStackMountValidation = setmetatable({}, {
		__tostring = function()
			return "VStackMountValidation"
		end,
	})
	VStackMountValidation.__index = VStackMountValidation
	function VStackMountValidation.new(...)
		local self = setmetatable({}, VStackMountValidation)
		return self:constructor(...) or self
	end
	function VStackMountValidation:constructor()
	end
	function VStackMountValidation:childrenInOrder()
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local first = waitForGuiObject(stack, "First")
			local second = findDescendant(stack, "Second")
			local third = findDescendant(stack, "Third")
			assertAlignedTop(first, stack, 1, "vstack order")
			assertStackedVertically({ first, second, third }, "vstack order")
		end)
	end
	function VStackMountValidation:gapMatchesSpacing(spacing, expectedGap)
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren(), {
			spacing = spacing,
		}), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local first = waitForGuiObject(stack, "First")
			local second = findDescendant(stack, "Second")
			local third = findDescendant(stack, "Third")
			assertVerticalGap(first, second, expectedGap, `spacing={spacing}`)
			assertVerticalGap(second, third, expectedGap, `spacing={spacing}`)
		end)
	end
	function VStackMountValidation:fillStretchesChildren()
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local first = waitForGuiObject(stack, "First", function(gui)
				return gui.AbsoluteSize.X == STACK_WIDTH
			end, "Timed out waiting for the first child to be stretched to the stack width")
			assertSizeApprox(first, STACK_WIDTH, CHILD_HEIGHT, 1, "fill-stretched child")
		end)
	end
	function VStackMountValidation:centerAlignment()
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(stackChild("Only", 1), {
			valign = "Center",
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			HorizontalFlex = Enum.UIFlexAlignment.None,
		}), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local only = waitForGuiObject(stack, "Only")
			assertSizeApprox(only, CHILD_WIDTH, CHILD_HEIGHT, 1, "centered vstack child")
			assertCenteredIn(only, stack, "both", 1, "centered vstack child")
		end)
	end
	function VStackMountValidation:allContained()
		withMounted(STACK_WIDTH, STACK_HEIGHT, vstack(threeChildren()), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			waitForGuiObject(stack, "Third")
			assertAllDescendantsContained(stack, "vstack children")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Children are laid out top-to-bottom in LayoutOrder, starting at the stack's top edge")
	local _descriptor = Test(VStackMountValidation, "childrenInOrder", {
		value = VStackMountValidation.childrenInOrder,
	})
	if _descriptor then
		VStackMountValidation.childrenInOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(VStackMountValidation, "childrenInOrder", {
		value = VStackMountValidation.childrenInOrder,
	})
	if _descriptor_1 then
		VStackMountValidation.childrenInOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(VStackMountValidation, "childrenInOrder", {
		value = VStackMountValidation.childrenInOrder,
	})
	if _descriptor_2 then
		VStackMountValidation.childrenInOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "None", 0 }, { "md", 12 }, { "xl", 24 } })
	local _decorator_4 = DisplayName("The gap between siblings equals the theme spacing value for the given spacing key")
	local _descriptor_3 = Test(VStackMountValidation, "gapMatchesSpacing", {
		value = VStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_3 then
		VStackMountValidation.gapMatchesSpacing = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(VStackMountValidation, "gapMatchesSpacing", {
		value = VStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_4 then
		VStackMountValidation.gapMatchesSpacing = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(VStackMountValidation, "gapMatchesSpacing", {
		value = VStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_5 then
		VStackMountValidation.gapMatchesSpacing = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(VStackMountValidation, "gapMatchesSpacing", {
		value = VStackMountValidation.gapMatchesSpacing,
	})
	if _descriptor_6 then
		VStackMountValidation.gapMatchesSpacing = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("The default HorizontalFlex=Fill stretches a fixed-width child to the full stack width")
	local _descriptor_7 = Test(VStackMountValidation, "fillStretchesChildren", {
		value = VStackMountValidation.fillStretchesChildren,
	})
	if _descriptor_7 then
		VStackMountValidation.fillStretchesChildren = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(VStackMountValidation, "fillStretchesChildren", {
		value = VStackMountValidation.fillStretchesChildren,
	})
	if _descriptor_8 then
		VStackMountValidation.fillStretchesChildren = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(VStackMountValidation, "fillStretchesChildren", {
		value = VStackMountValidation.fillStretchesChildren,
	})
	if _descriptor_9 then
		VStackMountValidation.fillStretchesChildren = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With HorizontalFlex=None, valign=Center and HorizontalAlignment=Center place a lone child in the middle of the stack")
	local _descriptor_10 = Test(VStackMountValidation, "centerAlignment", {
		value = VStackMountValidation.centerAlignment,
	})
	if _descriptor_10 then
		VStackMountValidation.centerAlignment = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(VStackMountValidation, "centerAlignment", {
		value = VStackMountValidation.centerAlignment,
	})
	if _descriptor_11 then
		VStackMountValidation.centerAlignment = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(VStackMountValidation, "centerAlignment", {
		value = VStackMountValidation.centerAlignment,
	})
	if _descriptor_12 then
		VStackMountValidation.centerAlignment = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("With default props every visible child stays inside the stack's parent frame")
	local _descriptor_13 = Test(VStackMountValidation, "allContained", {
		value = VStackMountValidation.allContained,
	})
	if _descriptor_13 then
		VStackMountValidation.allContained = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(VStackMountValidation, "allContained", {
		value = VStackMountValidation.allContained,
	})
	if _descriptor_14 then
		VStackMountValidation.allContained = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(VStackMountValidation, "allContained", {
		value = VStackMountValidation.allContained,
	})
	if _descriptor_15 then
		VStackMountValidation.allContained = _descriptor_15.value
	end
	VStackMountValidation = Tag("Studio")(VStackMountValidation) or VStackMountValidation
end
return VStackMountValidation
