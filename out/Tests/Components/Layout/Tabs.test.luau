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
local Tabs = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Tabs").Tabs
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local TAB_VALUES = { "one", "two", "three" }
local function tabsFixture(defaultValue)
	return React.createElement(Tabs, {
		defaultValue = defaultValue,
	}, React.createElement(Tabs.List, nil, React.createElement(Tabs.Title, {
		value = "one",
		text = "One",
	}), React.createElement(Tabs.Title, {
		value = "two",
		text = "Two",
	}), React.createElement(Tabs.Title, {
		value = "three",
		text = "Three",
	})), React.createElement(Tabs.Body, nil, React.createElement(Tabs.Content, {
		value = "one",
	}, React.createElement(Text, {
		text = "Panel one",
	})), React.createElement(Tabs.Content, {
		value = "two",
	}, React.createElement(Text, {
		text = "Panel two",
	})), React.createElement(Tabs.Content, {
		value = "three",
	}, React.createElement(Text, {
		text = "Panel three",
	}))))
end
local function waitForSelectedContent(host, value)
	return waitForGuiObject(host, `TabContent_{value}`, function(gui)
		return gui.Visible and gui.AbsoluteSize.X > 0
	end, `Timed out waiting for TabContent_{value} to become the visible panel`)
end
local function getVisiblePanels(host)
	local visible = {}
	for _, value in TAB_VALUES do
		local panel = host:FindFirstChild(`TabContent_{value}`, true)
		if panel ~= nil and panel.Visible then
			table.insert(visible, value)
		end
	end
	return visible
end
local function assertOnlySelectedVisible(host, selected)
	for _, value in TAB_VALUES do
		local panel = findDescendant(host, `TabContent_{value}`)
		Assert:equal(panel.Visible, value == selected, `Expected TabContent_{value} Visible to be {value == selected} while "{selected}" is selected`)
	end
end
local TabsMountValidation
do
	TabsMountValidation = setmetatable({}, {
		__tostring = function()
			return "TabsMountValidation"
		end,
	})
	TabsMountValidation.__index = TabsMountValidation
	function TabsMountValidation.new(...)
		local self = setmetatable({}, TabsMountValidation)
		return self:constructor(...) or self
	end
	function TabsMountValidation:constructor()
	end
	function TabsMountValidation:firstTabSelectedByDefault()
		withMounted(400, 300, tabsFixture(), function(mounted)
			local visible = waitForLayout(function()
				local panels = getVisiblePanels(mounted.host)
				return if #panels == 1 then panels else nil
			end, "Timed out waiting for exactly one TabContent panel to become visible")
			Assert:equal(visible[1], "one", `Expected the first declared tab "one" to be selected without a defaultValue, but "{visible[1]}" was visible`)
			assertOnlySelectedVisible(mounted.host, "one")
		end)
	end
	function TabsMountValidation:defaultValueSelectsTab()
		withMounted(400, 300, tabsFixture("two"), function(mounted)
			waitForSelectedContent(mounted.host, "two")
			assertOnlySelectedVisible(mounted.host, "two")
		end)
	end
	function TabsMountValidation:titlesInOrder()
		withMounted(400, 300, tabsFixture("one"), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = findDescendant(mounted.host, "TabsList")
			local buttons = {}
			for _, value in TAB_VALUES do
				local button = waitForGuiObject(list, `TabButton-{value}`)
				Assert:equal(button.Parent, list, `Expected TabButton-{value} to be a direct child of TabsList`)
				table.insert(buttons, button)
			end
			assertStackedHorizontally(buttons, "tab buttons")
		end)
	end
	function TabsMountValidation:contentsContained()
		withMounted(400, 300, tabsFixture("one"), function(mounted)
			waitForSelectedContent(mounted.host, "one")
			local list = waitForGuiObject(mounted.host, "TabsList")
			local body = waitForGuiObject(mounted.host, "TabsBody")
			assertContained(list, mounted.host, "list vs host")
			assertContained(body, mounted.host, "body vs host")
			assertAllDescendantsContained(list, "tabs list")
			assertAllDescendantsContained(body, "tabs body")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without defaultValue the first declared tab claims the selection, so only its panel is visible and the rest stay mounted but hidden")
	local _descriptor = Test(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor_1 then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TabsMountValidation, "firstTabSelectedByDefault", {
		value = TabsMountValidation.firstTabSelectedByDefault,
	})
	if _descriptor_2 then
		TabsMountValidation.firstTabSelectedByDefault = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("defaultValue seeds the selection so a non-first tab's panel is the one shown")
	local _descriptor_3 = Test(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_3 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_4 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TabsMountValidation, "defaultValueSelectsTab", {
		value = TabsMountValidation.defaultValueSelectsTab,
	})
	if _descriptor_5 then
		TabsMountValidation.defaultValueSelectsTab = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Tab buttons are laid out left-to-right in declaration order inside the list")
	local _descriptor_6 = Test(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_6 then
		TabsMountValidation.titlesInOrder = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_7 then
		TabsMountValidation.titlesInOrder = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TabsMountValidation, "titlesInOrder", {
		value = TabsMountValidation.titlesInOrder,
	})
	if _descriptor_8 then
		TabsMountValidation.titlesInOrder = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("The list, the body and every visible descendant of each stay inside their container and the host")
	local _descriptor_9 = Test(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_9 then
		TabsMountValidation.contentsContained = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_10 then
		TabsMountValidation.contentsContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TabsMountValidation, "contentsContained", {
		value = TabsMountValidation.contentsContained,
	})
	if _descriptor_11 then
		TabsMountValidation.contentsContained = _descriptor_11.value
	end
	TabsMountValidation = Tag("Studio")(TabsMountValidation) or TabsMountValidation
end
return TabsMountValidation
