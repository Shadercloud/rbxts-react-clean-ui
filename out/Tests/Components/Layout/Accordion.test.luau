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
local Accordion = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Accordion").Accordion
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertStackedVertically = _layout.assertStackedVertically
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 400
local function accordion(props)
	if props == nil then
		props = {}
	end
	return React.createElement(Accordion, {
		defaultValue = props.defaultValue,
		value = props.value,
		animationDuration = 0,
	}, React.createElement(Accordion.Item, {
		value = "one",
	}, React.createElement(Accordion.Header, {
		text = "Section one",
	}), React.createElement(Accordion.Content, {
		text = "Content for section one.",
	})), React.createElement(Accordion.Item, {
		value = "two",
	}, React.createElement(Accordion.Header, {
		text = "Section two",
	}), React.createElement(Accordion.Content, {
		text = "Content for section two.",
	})))
end
local function waitForAccordion(host)
	return waitForGuiObject(host, "Accordion")
end
local function findItem(root, value)
	return findDescendant(root, `AccordionItem-{value}`)
end
local function findHeader(root, value)
	return findDescendant(root, `AccordionHeaderButton-{value}`)
end
local function assertContentUnmounted(item, value)
	Assert["true"](Assert, item:FindFirstChild("ContentClip", true) == nil, `Expected the closed item "{value}" to have no mounted ContentClip`)
end
local AccordionMountValidation
do
	AccordionMountValidation = setmetatable({}, {
		__tostring = function()
			return "AccordionMountValidation"
		end,
	})
	AccordionMountValidation.__index = AccordionMountValidation
	function AccordionMountValidation.new(...)
		local self = setmetatable({}, AccordionMountValidation)
		return self:constructor(...) or self
	end
	function AccordionMountValidation:constructor()
	end
	function AccordionMountValidation:defaultValueExpandsItem(openValue, closedValue)
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({
			defaultValue = openValue,
		}), function(mounted)
			local root = waitForAccordion(mounted.host)
			local openItem = findItem(root, openValue)
			local closedItem = findItem(root, closedValue)
			local clip = waitForGuiObject(openItem, "ContentClip")
			local contentText = findDescendant(clip, "AccordionContentText")
			assertNonZeroSize(clip, `open item {openValue}`)
			assertContained(contentText, clip, `open item {openValue}`)
			assertContained(clip, root, `open item {openValue}`)
			assertContentUnmounted(closedItem, closedValue)
		end)
	end
	function AccordionMountValidation:itemsStackVertically()
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({
			defaultValue = "one",
		}), function(mounted)
			local root = waitForAccordion(mounted.host)
			local clip = waitForGuiObject(findItem(root, "one"), "ContentClip")
			local headerOne = findHeader(root, "one")
			local headerTwo = findHeader(root, "two")
			assertStackedVertically({ headerOne, clip, headerTwo }, "accordion items")
		end)
	end
	function AccordionMountValidation:controlledValueSwitches()
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({
			value = "one",
		}), function(mounted)
			local root = waitForAccordion(mounted.host)
			local itemOne = findItem(root, "one")
			local itemTwo = findItem(root, "two")
			waitForGuiObject(itemOne, "ContentClip")
			assertContentUnmounted(itemTwo, "two")
			mounted.update(accordion({
				value = "two",
			}))
			waitForLayout(function()
				return if itemOne:FindFirstChild("ContentClip", true) == nil then true else nil
			end, "Timed out waiting for item one's ContentClip to be unmounted after the controlled value moved to two")
			local clipTwo = waitForGuiObject(itemTwo, "ContentClip")
			assertNonZeroSize(clipTwo, "item two after value switch")
			assertContained(clipTwo, root, "item two after value switch")
		end)
	end
	function AccordionMountValidation:allContained()
		withMounted(HOST_WIDTH, HOST_HEIGHT, accordion({
			defaultValue = "one",
		}), function(mounted)
			local root = waitForAccordion(mounted.host)
			waitForGuiObject(findItem(root, "one"), "ContentClip")
			assertAllDescendantsContained(root, "expanded accordion")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "one", "two" }, { "two", "one" } })
	local _decorator_2 = DisplayName("defaultValue expands that item's content to a visible height and leaves the other item's content unmounted")
	local _descriptor = Test(AccordionMountValidation, "defaultValueExpandsItem", {
		value = AccordionMountValidation.defaultValueExpandsItem,
	})
	if _descriptor then
		AccordionMountValidation.defaultValueExpandsItem = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(AccordionMountValidation, "defaultValueExpandsItem", {
		value = AccordionMountValidation.defaultValueExpandsItem,
	})
	if _descriptor_1 then
		AccordionMountValidation.defaultValueExpandsItem = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(AccordionMountValidation, "defaultValueExpandsItem", {
		value = AccordionMountValidation.defaultValueExpandsItem,
	})
	if _descriptor_2 then
		AccordionMountValidation.defaultValueExpandsItem = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(AccordionMountValidation, "defaultValueExpandsItem", {
		value = AccordionMountValidation.defaultValueExpandsItem,
	})
	if _descriptor_3 then
		AccordionMountValidation.defaultValueExpandsItem = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Headers and the expanded content are stacked top-to-bottom in item order")
	local _descriptor_4 = Test(AccordionMountValidation, "itemsStackVertically", {
		value = AccordionMountValidation.itemsStackVertically,
	})
	if _descriptor_4 then
		AccordionMountValidation.itemsStackVertically = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(AccordionMountValidation, "itemsStackVertically", {
		value = AccordionMountValidation.itemsStackVertically,
	})
	if _descriptor_5 then
		AccordionMountValidation.itemsStackVertically = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(AccordionMountValidation, "itemsStackVertically", {
		value = AccordionMountValidation.itemsStackVertically,
	})
	if _descriptor_6 then
		AccordionMountValidation.itemsStackVertically = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Switching a controlled value from one to two unmounts item one's content and expands item two")
	local _descriptor_7 = Test(AccordionMountValidation, "controlledValueSwitches", {
		value = AccordionMountValidation.controlledValueSwitches,
	})
	if _descriptor_7 then
		AccordionMountValidation.controlledValueSwitches = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(AccordionMountValidation, "controlledValueSwitches", {
		value = AccordionMountValidation.controlledValueSwitches,
	})
	if _descriptor_8 then
		AccordionMountValidation.controlledValueSwitches = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(AccordionMountValidation, "controlledValueSwitches", {
		value = AccordionMountValidation.controlledValueSwitches,
	})
	if _descriptor_9 then
		AccordionMountValidation.controlledValueSwitches = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With one item expanded, every visible descendant stays inside the Accordion")
	local _descriptor_10 = Test(AccordionMountValidation, "allContained", {
		value = AccordionMountValidation.allContained,
	})
	if _descriptor_10 then
		AccordionMountValidation.allContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(AccordionMountValidation, "allContained", {
		value = AccordionMountValidation.allContained,
	})
	if _descriptor_11 then
		AccordionMountValidation.allContained = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(AccordionMountValidation, "allContained", {
		value = AccordionMountValidation.allContained,
	})
	if _descriptor_12 then
		AccordionMountValidation.allContained = _descriptor_12.value
	end
	AccordionMountValidation = Tag("Studio")(AccordionMountValidation) or AccordionMountValidation
end
return AccordionMountValidation
