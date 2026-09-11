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
local Menu = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Navigation", "Menu").Menu
local Box = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Box").Box
local RegistryProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "registry.provider").RegistryProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertStackedVertically = _layout.assertStackedVertically
local assertTextFits = _layout.assertTextFits
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local MENU_TITLE = "Main"
local ITEM_TITLES = { "Home", "Settings", "Tools" }
local STORY_ITEM_TITLES = { "New Game", "Create Character and Start", "Load Game ", "Quit" }
local function menuFixture(collapsed)
	return React.createElement(RegistryProvider, nil, React.createElement(Menu, {
		title = MENU_TITLE,
		collapsed = collapsed,
	}, React.createElement(Menu.Item, {
		title = "Home",
		icon = "home",
	}), React.createElement(Menu.Item, {
		title = "Settings",
		icon = "gear",
	}), React.createElement(Menu.Item, {
		title = "Tools",
		icon = "gears",
	})))
end
local function storyFixture()
	return React.createElement(RegistryProvider, nil, React.createElement(Box, {
		width = "Auto",
		height = "100%",
	}, React.createElement(Menu, {
		title = "Main Menu",
	}, React.createElement(Menu.Item, {
		title = STORY_ITEM_TITLES[1],
		icon = "plus-circle",
	}), React.createElement(Menu.Item, {
		title = STORY_ITEM_TITLES[2],
		icon = "user-plus",
	}), React.createElement(Menu.Item, {
		title = STORY_ITEM_TITLES[3],
		icon = "database",
	}), React.createElement(Menu.Item, {
		title = STORY_ITEM_TITLES[4],
		icon = "sign-out",
	}))))
end
local ignoreScrollerChrome = function(gui)
	return gui:IsA("ScrollingFrame") or gui.Name == "ScrollerContent"
end
local function waitForMenu(host)
	return waitForGuiObject(host, "Menu")
end
local function waitForItems(menu, expected)
	if expected == nil then
		expected = #ITEM_TITLES
	end
	return waitForLayout(function()
		local first = menu:FindFirstChild("MenuItem", true)
		if first == nil or first.Parent == nil then
			return nil
		end
		local items = {}
		for _, child in first.Parent:GetChildren() do
			if child:IsA("ImageButton") and child.Name == "MenuItem" then
				table.insert(items, child)
			end
		end
		if #items ~= expected then
			return nil
		end
		-- ▼ ReadonlyArray.every ▼
		local _result = true
		local _callback = function(item)
			return item.AbsoluteSize.X > 0 and item.AbsoluteSize.Y > 0
		end
		for _k, _v in items do
			if not _callback(_v, _k - 1, items) then
				_result = false
				break
			end
		end
		-- ▲ ReadonlyArray.every ▲
		return if _result then items else nil
	end, `Timed out waiting for {expected} laid-out MenuItem buttons`)
end
local function itemLabel(item)
	return item:FindFirstChild("ButtonText", true)
end
local function widestItemWidth(items)
	local widest = 0
	for _, item in items do
		widest = math.max(widest, item.AbsoluteSize.X)
	end
	return widest
end
local function waitForGroupSettled(menu, items)
	local header = findDescendant(menu, "MenuHeader")
	for attempt = 0, 29 do
		-- ▼ ReadonlyArray.every ▼
		local _result = true
		local _callback = function(item)
			return item.AbsoluteSize.X > 0 and item.AbsoluteSize.Y > 0
		end
		for _k, _v in items do
			if not _callback(_v, _k - 1, items) then
				_result = false
				break
			end
		end
		-- ▲ ReadonlyArray.every ▲
		local laidOut = _result
		if laidOut and header.AbsoluteSize.X >= widestItemWidth(items) then
			return header
		end
		task.wait()
	end
	return Assert:fail(`Timed out waiting for the Menu's Group to settle: MenuHeader is {header.AbsoluteSize.X}px wide but the widest MenuItem is {widestItemWidth(items)}px`)
end
local MenuMountValidation
do
	MenuMountValidation = setmetatable({}, {
		__tostring = function()
			return "MenuMountValidation"
		end,
	})
	MenuMountValidation.__index = MenuMountValidation
	function MenuMountValidation.new(...)
		local self = setmetatable({}, MenuMountValidation)
		return self:constructor(...) or self
	end
	function MenuMountValidation:constructor()
	end
	function MenuMountValidation:itemsRenderInOrder()
		withMounted(300, 400, menuFixture(), function(mounted)
			local menu = waitForMenu(mounted.host)
			local items = waitForItems(menu)
			local title = findDescendant(menu, "MenuTitle")
			Assert:equal(title.Text, MENU_TITLE)
			local labels = {}
			for _, item in items do
				local label = itemLabel(item)
				Assert:notUndefined(label, `Expected a ButtonText label under {item:GetFullName()}`)
				local _text = label.Text
				table.insert(labels, _text)
			end
			Assert:deepEqual(labels, ITEM_TITLES)
			assertStackedVertically(items, "menu items")
		end)
	end
	function MenuMountValidation:everythingContained()
		withMounted(300, 400, menuFixture(), function(mounted)
			local menu = waitForMenu(mounted.host)
			local items = waitForItems(menu)
			local header = waitForGroupSettled(menu, items)
			assertContained(menu, mounted.host, "menu vs host")
			assertContained(header, menu, "header vs menu")
			for _, item in items do
				assertContained(item, menu, "item vs menu")
			end
			assertAllDescendantsContained(menu, "expanded menu", ignoreScrollerChrome)
		end)
	end
	function MenuMountValidation:collapsedHidesLabels()
		withMounted(300, 400, menuFixture(true), function(mounted)
			local menu = waitForMenu(mounted.host)
			local items = waitForItems(menu)
			Assert:undefined(menu:FindFirstChild("MenuTitle", true), "Expected no MenuTitle while collapsed")
			Assert:notUndefined(menu:FindFirstChild("MenuToggleButton", true), "Expected the toggle button to remain")
			for _, item in items do
				Assert:undefined(itemLabel(item), `Expected no ButtonText under {item:GetFullName()} while collapsed`)
				Assert:notUndefined(item:FindFirstChild("ButtonIcon", true), `Expected the ButtonIcon under {item:GetFullName()} to remain while collapsed`)
			end
		end)
	end
	function MenuMountValidation:storyShapeContained()
		withMounted(1200, 800, storyFixture(), function(mounted)
			local box = waitForGuiObject(mounted.host, "Box")
			local menu = waitForMenu(mounted.host)
			local items = waitForItems(menu, #STORY_ITEM_TITLES)
			local header = waitForGroupSettled(menu, items)
			waitForLayout(function()
				-- ▼ ReadonlyArray.every ▼
				local _result = true
				local _callback = function(item)
					local label = itemLabel(item)
					return label ~= nil and label.TextFits
				end
				for _k, _v in items do
					if not _callback(_v, _k - 1, items) then
						_result = false
						break
					end
				end
				-- ▲ ReadonlyArray.every ▲
				local settled = _result
				return if settled then true else nil
			end, "Timed out waiting for every Menu label inside the Box to fit on one line")
			assertContained(box, mounted.host, "box vs host")
			assertContained(menu, box, "menu vs box")
			assertContained(header, menu, "header vs menu")
			for _, item in items do
				local label = itemLabel(item)
				Assert:notUndefined(label, `Expected a ButtonText label under {item:GetFullName()}`)
				assertTextFits(label, `label "{label.Text}"`)
				assertContained(item, menu, "item vs menu")
			end
			assertAllDescendantsContained(menu, "menu inside auto-width box", ignoreScrollerChrome)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Expanded, the title is shown and the items render top-to-bottom in declaration order with their labels")
	local _descriptor = Test(MenuMountValidation, "itemsRenderInOrder", {
		value = MenuMountValidation.itemsRenderInOrder,
	})
	if _descriptor then
		MenuMountValidation.itemsRenderInOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(MenuMountValidation, "itemsRenderInOrder", {
		value = MenuMountValidation.itemsRenderInOrder,
	})
	if _descriptor_1 then
		MenuMountValidation.itemsRenderInOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(MenuMountValidation, "itemsRenderInOrder", {
		value = MenuMountValidation.itemsRenderInOrder,
	})
	if _descriptor_2 then
		MenuMountValidation.itemsRenderInOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Every visible descendant stays inside the Menu, and the Menu inside its host")
	local _descriptor_3 = Test(MenuMountValidation, "everythingContained", {
		value = MenuMountValidation.everythingContained,
	})
	if _descriptor_3 then
		MenuMountValidation.everythingContained = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(MenuMountValidation, "everythingContained", {
		value = MenuMountValidation.everythingContained,
	})
	if _descriptor_4 then
		MenuMountValidation.everythingContained = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(MenuMountValidation, "everythingContained", {
		value = MenuMountValidation.everythingContained,
	})
	if _descriptor_5 then
		MenuMountValidation.everythingContained = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("collapsed={true} omits the menu title and every item label while keeping the toggle and item icons")
	local _descriptor_6 = Test(MenuMountValidation, "collapsedHidesLabels", {
		value = MenuMountValidation.collapsedHidesLabels,
	})
	if _descriptor_6 then
		MenuMountValidation.collapsedHidesLabels = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(MenuMountValidation, "collapsedHidesLabels", {
		value = MenuMountValidation.collapsedHidesLabels,
	})
	if _descriptor_7 then
		MenuMountValidation.collapsedHidesLabels = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(MenuMountValidation, "collapsedHidesLabels", {
		value = MenuMountValidation.collapsedHidesLabels,
	})
	if _descriptor_8 then
		MenuMountValidation.collapsedHidesLabels = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Inside an auto-width Box under a RegistryProvider (story shape) no label wraps and the Menu's content stays inside the Menu, Box and host")
	local _descriptor_9 = Test(MenuMountValidation, "storyShapeContained", {
		value = MenuMountValidation.storyShapeContained,
	})
	if _descriptor_9 then
		MenuMountValidation.storyShapeContained = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(MenuMountValidation, "storyShapeContained", {
		value = MenuMountValidation.storyShapeContained,
	})
	if _descriptor_10 then
		MenuMountValidation.storyShapeContained = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(MenuMountValidation, "storyShapeContained", {
		value = MenuMountValidation.storyShapeContained,
	})
	if _descriptor_11 then
		MenuMountValidation.storyShapeContained = _descriptor_11.value
	end
	MenuMountValidation = Tag("Studio")(MenuMountValidation) or MenuMountValidation
end
return MenuMountValidation
