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
local FlexItem = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "FlexItem").FlexItem
local HStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "HStack").HStack
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAlignedRight = _layout.assertAlignedRight
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local STACK_WIDTH = 400
local STACK_HEIGHT = 100
local FIXED_WIDTH = 100
local REMAINING_WIDTH = STACK_WIDTH - FIXED_WIDTH
local ITEM_HEIGHT = 40
local function stackWithFlexItem(flexItem)
	return React.createElement("frame", {
		key = "Stack",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		spacing = "None",
		Wraps = false,
	}, React.createElement("frame", {
		key = "Fixed",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(FIXED_WIDTH, ITEM_HEIGHT),
		LayoutOrder = 1,
	}), flexItem))
end
local function child()
	return React.createElement("frame", {
		key = "Child",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(50, 20),
	})
end
local function waitForGrownFlexItem(host)
	return waitForGuiObject(host, "FlexItem", function(gui)
		return gui.AbsoluteSize.X == REMAINING_WIDTH
	end, `Timed out waiting for the FlexItem to grow to the remaining {REMAINING_WIDTH}px`)
end
local FlexItemMountValidation
do
	FlexItemMountValidation = setmetatable({}, {
		__tostring = function()
			return "FlexItemMountValidation"
		end,
	})
	FlexItemMountValidation.__index = FlexItemMountValidation
	function FlexItemMountValidation.new(...)
		local self = setmetatable({}, FlexItemMountValidation)
		return self:constructor(...) or self
	end
	function FlexItemMountValidation:constructor()
	end
	function FlexItemMountValidation:growsToFillRemaining()
		withMounted(STACK_WIDTH, STACK_HEIGHT, stackWithFlexItem(React.createElement(FlexItem, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, ITEM_HEIGHT),
		}, child())), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local flexItem = waitForGrownFlexItem(stack)
			assertSizeApprox(flexItem, REMAINING_WIDTH, ITEM_HEIGHT, 1, "grown flex item")
			assertAlignedRight(flexItem, stack, 1, "grown flex item")
		end)
	end
	function FlexItemMountValidation:modeNoneKeepsOwnSize()
		withMounted(STACK_WIDTH, STACK_HEIGHT, stackWithFlexItem(React.createElement(FlexItem, {
			LayoutOrder = 2,
			mode = "None",
			Size = UDim2.new(0, 80, 0, ITEM_HEIGHT),
		}, child())), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local flexItem = waitForGuiObject(stack, "FlexItem")
			assertSizeApprox(flexItem, 80, ITEM_HEIGHT, 1, "mode=None flex item")
		end)
	end
	function FlexItemMountValidation:alignPlacesChild(align)
		withMounted(STACK_WIDTH, STACK_HEIGHT, stackWithFlexItem(React.createElement(FlexItem, {
			LayoutOrder = 2,
			align = align,
			Size = UDim2.new(0, 0, 0, ITEM_HEIGHT),
		}, child())), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local flexItem = waitForGrownFlexItem(stack)
			local inner = waitForGuiObject(flexItem, "Child")
			if align == "Left" then
				assertAlignedLeft(inner, flexItem, 1, "align=Left")
			elseif align == "Right" then
				assertAlignedRight(inner, flexItem, 1, "align=Right")
			else
				assertCenteredIn(inner, flexItem, "x", 1, "align=Center")
			end
		end)
	end
	function FlexItemMountValidation:allContained()
		withMounted(STACK_WIDTH, STACK_HEIGHT, stackWithFlexItem(React.createElement(FlexItem, {
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, ITEM_HEIGHT),
		}, child())), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local flexItem = waitForGrownFlexItem(stack)
			waitForGuiObject(flexItem, "Child")
			assertAllDescendantsContained(flexItem, "flex item children")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With the default Grow mode the FlexItem claims all width left over by its fixed sibling")
	local _descriptor = Test(FlexItemMountValidation, "growsToFillRemaining", {
		value = FlexItemMountValidation.growsToFillRemaining,
	})
	if _descriptor then
		FlexItemMountValidation.growsToFillRemaining = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(FlexItemMountValidation, "growsToFillRemaining", {
		value = FlexItemMountValidation.growsToFillRemaining,
	})
	if _descriptor_1 then
		FlexItemMountValidation.growsToFillRemaining = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(FlexItemMountValidation, "growsToFillRemaining", {
		value = FlexItemMountValidation.growsToFillRemaining,
	})
	if _descriptor_2 then
		FlexItemMountValidation.growsToFillRemaining = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("mode=None leaves the FlexItem at its own explicit Size instead of growing")
	local _descriptor_3 = Test(FlexItemMountValidation, "modeNoneKeepsOwnSize", {
		value = FlexItemMountValidation.modeNoneKeepsOwnSize,
	})
	if _descriptor_3 then
		FlexItemMountValidation.modeNoneKeepsOwnSize = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(FlexItemMountValidation, "modeNoneKeepsOwnSize", {
		value = FlexItemMountValidation.modeNoneKeepsOwnSize,
	})
	if _descriptor_4 then
		FlexItemMountValidation.modeNoneKeepsOwnSize = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(FlexItemMountValidation, "modeNoneKeepsOwnSize", {
		value = FlexItemMountValidation.modeNoneKeepsOwnSize,
	})
	if _descriptor_5 then
		FlexItemMountValidation.modeNoneKeepsOwnSize = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = Each({ { "Left" }, { "Center" }, { "Right" } })
	local _decorator_6 = DisplayName("The align prop places the FlexItem's child at the matching horizontal edge or center of the grown item")
	local _descriptor_6 = Test(FlexItemMountValidation, "alignPlacesChild", {
		value = FlexItemMountValidation.alignPlacesChild,
	})
	if _descriptor_6 then
		FlexItemMountValidation.alignPlacesChild = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(FlexItemMountValidation, "alignPlacesChild", {
		value = FlexItemMountValidation.alignPlacesChild,
	})
	if _descriptor_7 then
		FlexItemMountValidation.alignPlacesChild = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(FlexItemMountValidation, "alignPlacesChild", {
		value = FlexItemMountValidation.alignPlacesChild,
	})
	if _descriptor_8 then
		FlexItemMountValidation.alignPlacesChild = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(FlexItemMountValidation, "alignPlacesChild", {
		value = FlexItemMountValidation.alignPlacesChild,
	})
	if _descriptor_9 then
		FlexItemMountValidation.alignPlacesChild = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Every visible descendant of a grown FlexItem stays inside it")
	local _descriptor_10 = Test(FlexItemMountValidation, "allContained", {
		value = FlexItemMountValidation.allContained,
	})
	if _descriptor_10 then
		FlexItemMountValidation.allContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(FlexItemMountValidation, "allContained", {
		value = FlexItemMountValidation.allContained,
	})
	if _descriptor_11 then
		FlexItemMountValidation.allContained = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(FlexItemMountValidation, "allContained", {
		value = FlexItemMountValidation.allContained,
	})
	if _descriptor_12 then
		FlexItemMountValidation.allContained = _descriptor_12.value
	end
	FlexItemMountValidation = Tag("Studio")(FlexItemMountValidation) or FlexItemMountValidation
end
return FlexItemMountValidation
