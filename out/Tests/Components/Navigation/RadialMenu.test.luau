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
local RadialMenu = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Navigation", "RadialMenu").RadialMenu
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local MENU_SIZE = 200
local RING_RADIUS = 82
local ITEMS = { {
	value = "north",
	icon = "plane",
	text = "North",
	description = "Top item",
}, {
	value = "east",
	icon = "wifi",
	text = "East",
	description = "Right item",
}, {
	value = "south",
	icon = "bluetooth",
	text = "South",
	description = "Bottom item",
}, {
	value = "west",
	icon = "phone",
	text = "West",
	description = "Left item",
} }
local PLACEHOLDER = {
	icon = "cog",
	text = "System Settings",
	description = "Radial Menu",
}
local function menuFixture(props)
	if props == nil then
		props = {}
	end
	local log = props.log
	return React.createElement(RadialMenu, {
		items = ITEMS,
		size = MENU_SIZE,
		value = props.value,
		defaultValue = props.defaultValue,
		placeholder = props.placeholder,
		onValueChange = function(value)
			if log ~= nil then
				local _value = value
				table.insert(log, _value)
			end
		end,
	})
end
local function waitForHitArea(host)
	return waitForGuiObject(host, "HitArea")
end
local function waitForCenterTitle(host, text)
	return waitForDescendant(host, "CenterTitle", function(label)
		return label.Text == text
	end, `Timed out waiting for CenterTitle to read "{text}"`)
end
local function centerTitleText(host)
	local label = host:FindFirstChild("CenterTitle", true)
	local _result = label
	if _result ~= nil then
		_result = _result.Text
	end
	return _result
end
local function pointAt(hitArea, angle, radius)
	local centerX = hitArea.AbsolutePosition.X + hitArea.AbsoluteSize.X / 2
	local centerY = hitArea.AbsolutePosition.Y + hitArea.AbsoluteSize.Y / 2
	local radians = math.rad(angle)
	return Vector3.new(centerX + radius * math.sin(radians), centerY - radius * math.cos(radians), 0)
end
local function pointerInput(userInputType, position)
	return {
		UserInputType = userInputType,
		Position = position,
	}
end
local function release(mounted, hitArea, angle, radius, userInputType)
	if userInputType == nil then
		userInputType = Enum.UserInputType.MouseButton1
	end
	fireHostEvent(mounted, hitArea, "InputEnded", pointerInput(userInputType, pointAt(hitArea, angle, radius)))
end
local function move(mounted, hitArea, angle, radius)
	fireHostEvent(mounted, hitArea, "InputChanged", pointerInput(Enum.UserInputType.MouseMovement, pointAt(hitArea, angle, radius)))
end
local function assertCenterEmpty(host, label)
	for _, name in { "CenterIcon", "CenterTitle", "CenterDescription" } do
		Assert:undefined(host:FindFirstChild(name, true), `{label}: expected no {name} in the centre`)
	end
end
local function itemIconImage(host, value)
	local item = findDescendant(host, `RadialMenuItem-{value}`)
	return findDescendant(item, "ItemIcon").Image
end
local RadialMenuMountValidation
do
	RadialMenuMountValidation = setmetatable({}, {
		__tostring = function()
			return "RadialMenuMountValidation"
		end,
	})
	RadialMenuMountValidation.__index = RadialMenuMountValidation
	function RadialMenuMountValidation.new(...)
		local self = setmetatable({}, RadialMenuMountValidation)
		return self:constructor(...) or self
	end
	function RadialMenuMountValidation:constructor()
	end
	function RadialMenuMountValidation:placeholderCentre()
		withMounted(300, 300, menuFixture({
			placeholder = PLACEHOLDER,
		}), function(mounted)
			waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			local description = findDescendant(mounted.host, "CenterDescription")
			Assert:equal(description.Text, "Radial Menu", "Expected the placeholder description in the centre")
			local icon = findDescendant(mounted.host, "CenterIcon")
			Assert["true"](Assert, icon.Image ~= "", "Expected the placeholder icon to have an image")
			for _, item in ITEMS do
				Assert["true"](Assert, icon.Image ~= itemIconImage(mounted.host, item.value), `Expected the centre icon not to be {item.value}'s icon`)
			end
			local wedge = findDescendant(mounted.host, "SelectedWedge")
			Assert["false"](Assert, wedge.Visible, "Expected SelectedWedge to be hidden while nothing is selected")
		end)
	end
	function RadialMenuMountValidation:emptyCentre()
		withMounted(300, 300, menuFixture(), function(mounted)
			waitForHitArea(mounted.host)
			settleFrames(2)
			assertCenterEmpty(mounted.host, "no placeholder")
		end)
	end
	function RadialMenuMountValidation:defaultValueCentre()
		withMounted(300, 300, menuFixture({
			defaultValue = "south",
			placeholder = PLACEHOLDER,
		}), function(mounted)
			waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "South")
			local description = findDescendant(mounted.host, "CenterDescription")
			Assert:equal(description.Text, "Bottom item", "Expected the default item's description in the centre")
			local icon = findDescendant(mounted.host, "CenterIcon")
			Assert:equal(icon.Image, itemIconImage(mounted.host, "south"), "Expected the centre icon to match the selected item's icon")
			local wedge = findDescendant(mounted.host, "SelectedWedge")
			Assert["true"](Assert, wedge.Visible, "Expected SelectedWedge to be visible once an item is selected")
		end)
	end
	function RadialMenuMountValidation:unknownDefault()
		withMounted(300, 300, menuFixture({
			defaultValue = "missing",
			placeholder = PLACEHOLDER,
		}), function(mounted)
			waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			Assert["false"](Assert, findDescendant(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge to stay hidden")
		end)
	end
	function RadialMenuMountValidation:controlledRerender()
		withMounted(300, 300, menuFixture({
			value = "east",
			placeholder = PLACEHOLDER,
		}), function(mounted)
			waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "East")
			mounted.update(menuFixture({
				value = "west",
				placeholder = PLACEHOLDER,
			}))
			waitForCenterTitle(mounted.host, "West")
			Assert:equal(findDescendant(mounted.host, "CenterDescription").Text, "Left item", "Expected west's description")
			mounted.update(menuFixture({
				value = "missing",
				placeholder = PLACEHOLDER,
			}))
			waitForCenterTitle(mounted.host, "System Settings")
			Assert["false"](Assert, findDescendant(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge hidden for an unmatched value")
		end)
	end
	function RadialMenuMountValidation:selectsByAngle(angle, radius, expected)
		local log = {}
		withMounted(300, 300, menuFixture({
			placeholder = PLACEHOLDER,
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			release(mounted, hitArea, angle, radius)
			-- ▼ ReadonlyArray.find ▼
			local _callback = function(entry)
				return entry.value == expected
			end
			local _result
			for _i, _v in ITEMS do
				if _callback(_v, _i - 1, ITEMS) == true then
					_result = _v
					break
				end
			end
			-- ▲ ReadonlyArray.find ▲
			local item = _result
			waitForCenterTitle(mounted.host, item.text)
			Assert:equal(table.concat(log, ","), expected, `Expected onValueChange to report only {expected} at {angle} degrees, radius {radius}`)
		end)
	end
	function RadialMenuMountValidation:missSelectsNothing(angle, radius)
		local log = {}
		withMounted(300, 300, menuFixture({
			placeholder = PLACEHOLDER,
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			release(mounted, hitArea, angle, radius)
			settleFrames(3)
			Assert:equal(#log, 0, `Expected no onValueChange for a release at {angle} degrees, radius {radius}, got [{table.concat(log, ",")}]`)
			Assert:equal(centerTitleText(mounted.host), "System Settings", "Expected the placeholder to remain in the centre")
			Assert["false"](Assert, findDescendant(mounted.host, "SelectedWedge").Visible, "Expected SelectedWedge to stay hidden")
		end)
	end
	function RadialMenuMountValidation:missKeepsSelection()
		local log = {}
		withMounted(300, 300, menuFixture({
			defaultValue = "east",
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "East")
			release(mounted, hitArea, 0, 20)
			settleFrames(3)
			Assert:equal(#log, 0, "Expected no onValueChange for a centre-hole release")
			Assert:equal(centerTitleText(mounted.host), "East", "Expected east to stay selected")
		end)
	end
	function RadialMenuMountValidation:releaseInputTypes()
		local log = {}
		withMounted(300, 300, menuFixture({
			placeholder = PLACEHOLDER,
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			release(mounted, hitArea, 90, RING_RADIUS, Enum.UserInputType.MouseButton2)
			settleFrames(3)
			Assert:equal(#log, 0, "Expected a MouseButton2 release to select nothing")
			Assert:equal(centerTitleText(mounted.host), "System Settings", "Expected the placeholder after a MouseButton2 release")
			release(mounted, hitArea, 180, RING_RADIUS, Enum.UserInputType.Touch)
			waitForCenterTitle(mounted.host, "South")
			Assert:equal(table.concat(log, ","), "south", "Expected the touch release to report south")
		end)
	end
	function RadialMenuMountValidation:reselectFires()
		local log = {}
		withMounted(300, 300, menuFixture({
			defaultValue = "north",
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "North")
			settleFrames(2)
			Assert:equal(#log, 0, "Expected onValueChange not to fire on mount")
			release(mounted, hitArea, 0, RING_RADIUS)
			settleFrames(2)
			Assert:equal(table.concat(log, ","), "north", "Expected one onValueChange for the reselect")
			Assert:equal(centerTitleText(mounted.host), "North", "Expected north to stay selected")
		end)
	end
	function RadialMenuMountValidation:controlledClickReports()
		local log = {}
		withMounted(300, 300, menuFixture({
			value = "north",
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "North")
			release(mounted, hitArea, 270, RING_RADIUS)
			settleFrames(3)
			Assert:equal(table.concat(log, ","), "west", "Expected onValueChange to report west")
			Assert:equal(centerTitleText(mounted.host), "North", "Expected the controlled centre to keep north until value changes")
			mounted.update(menuFixture({
				value = "west",
				log = log,
			}))
			waitForCenterTitle(mounted.host, "West")
		end)
	end
	function RadialMenuMountValidation:hoverFollowsPointer()
		withMounted(300, 300, menuFixture({
			defaultValue = "north",
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "North")
			Assert:undefined(mounted.host:FindFirstChild("HoverWedge", true), "Expected no HoverWedge before any pointer movement")
			move(mounted, hitArea, 90, RING_RADIUS)
			waitForDescendant(mounted.host, "HoverWedge", function()
				return true
			end, "Timed out waiting for HoverWedge over east")
			move(mounted, hitArea, 0, 20)
			waitForRemoval(mounted.host, "HoverWedge", 30)
			move(mounted, hitArea, 0, RING_RADIUS)
			settleFrames(3)
			Assert:undefined(mounted.host:FindFirstChild("HoverWedge", true), "Expected no HoverWedge over the already-selected segment")
			waitForLayout(function()
				return if centerTitleText(mounted.host) == "North" then true else nil
			end, "Expected hover not to change the selection")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With nothing selected the centre shows the placeholder icon, title and description and the selected wedge is hidden")
	local _descriptor = Test(RadialMenuMountValidation, "placeholderCentre", {
		value = RadialMenuMountValidation.placeholderCentre,
	})
	if _descriptor then
		RadialMenuMountValidation.placeholderCentre = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(RadialMenuMountValidation, "placeholderCentre", {
		value = RadialMenuMountValidation.placeholderCentre,
	})
	if _descriptor_1 then
		RadialMenuMountValidation.placeholderCentre = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(RadialMenuMountValidation, "placeholderCentre", {
		value = RadialMenuMountValidation.placeholderCentre,
	})
	if _descriptor_2 then
		RadialMenuMountValidation.placeholderCentre = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With no selection and no placeholder the centre renders no icon, title or description")
	local _descriptor_3 = Test(RadialMenuMountValidation, "emptyCentre", {
		value = RadialMenuMountValidation.emptyCentre,
	})
	if _descriptor_3 then
		RadialMenuMountValidation.emptyCentre = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(RadialMenuMountValidation, "emptyCentre", {
		value = RadialMenuMountValidation.emptyCentre,
	})
	if _descriptor_4 then
		RadialMenuMountValidation.emptyCentre = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(RadialMenuMountValidation, "emptyCentre", {
		value = RadialMenuMountValidation.emptyCentre,
	})
	if _descriptor_5 then
		RadialMenuMountValidation.emptyCentre = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("defaultValue selects its item on mount so the centre shows that item's icon, text and description")
	local _descriptor_6 = Test(RadialMenuMountValidation, "defaultValueCentre", {
		value = RadialMenuMountValidation.defaultValueCentre,
	})
	if _descriptor_6 then
		RadialMenuMountValidation.defaultValueCentre = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(RadialMenuMountValidation, "defaultValueCentre", {
		value = RadialMenuMountValidation.defaultValueCentre,
	})
	if _descriptor_7 then
		RadialMenuMountValidation.defaultValueCentre = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(RadialMenuMountValidation, "defaultValueCentre", {
		value = RadialMenuMountValidation.defaultValueCentre,
	})
	if _descriptor_8 then
		RadialMenuMountValidation.defaultValueCentre = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("An unknown defaultValue selects nothing and the centre falls back to the placeholder")
	local _descriptor_9 = Test(RadialMenuMountValidation, "unknownDefault", {
		value = RadialMenuMountValidation.unknownDefault,
	})
	if _descriptor_9 then
		RadialMenuMountValidation.unknownDefault = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(RadialMenuMountValidation, "unknownDefault", {
		value = RadialMenuMountValidation.unknownDefault,
	})
	if _descriptor_10 then
		RadialMenuMountValidation.unknownDefault = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(RadialMenuMountValidation, "unknownDefault", {
		value = RadialMenuMountValidation.unknownDefault,
	})
	if _descriptor_11 then
		RadialMenuMountValidation.unknownDefault = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A controlled value drives the centre and a rerender with a new value swaps the centre content")
	local _descriptor_12 = Test(RadialMenuMountValidation, "controlledRerender", {
		value = RadialMenuMountValidation.controlledRerender,
	})
	if _descriptor_12 then
		RadialMenuMountValidation.controlledRerender = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(RadialMenuMountValidation, "controlledRerender", {
		value = RadialMenuMountValidation.controlledRerender,
	})
	if _descriptor_13 then
		RadialMenuMountValidation.controlledRerender = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(RadialMenuMountValidation, "controlledRerender", {
		value = RadialMenuMountValidation.controlledRerender,
	})
	if _descriptor_14 then
		RadialMenuMountValidation.controlledRerender = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = Each({ { 0, RING_RADIUS, "north" }, { 90, RING_RADIUS, "east" }, { 180, RING_RADIUS, "south" }, { 270, RING_RADIUS, "west" }, { 350, RING_RADIUS, "north" }, { 44, RING_RADIUS, "north" }, { 46, RING_RADIUS, "east" }, { 224, RING_RADIUS, "south" }, { 316, RING_RADIUS, "north" }, { 0, 66, "north" }, { 90, 98, "east" } })
	local _decorator_12 = DisplayName("A mouse release on the ring selects the segment under it by clockwise angle from 12 o'clock and reports it")
	local _descriptor_15 = Test(RadialMenuMountValidation, "selectsByAngle", {
		value = RadialMenuMountValidation.selectsByAngle,
	})
	if _descriptor_15 then
		RadialMenuMountValidation.selectsByAngle = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_12(RadialMenuMountValidation, "selectsByAngle", {
		value = RadialMenuMountValidation.selectsByAngle,
	})
	if _descriptor_16 then
		RadialMenuMountValidation.selectsByAngle = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_11(RadialMenuMountValidation, "selectsByAngle", {
		value = RadialMenuMountValidation.selectsByAngle,
	})
	if _descriptor_17 then
		RadialMenuMountValidation.selectsByAngle = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_10(RadialMenuMountValidation, "selectsByAngle", {
		value = RadialMenuMountValidation.selectsByAngle,
	})
	if _descriptor_18 then
		RadialMenuMountValidation.selectsByAngle = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = Each({ { 0, 0 }, { 0, 30 }, { 90, 60 }, { 45, 130 }, { 180, 104 } })
	local _decorator_15 = DisplayName("A release in the centre hole or outside the ring's outer edge selects nothing and fires no callback")
	local _descriptor_19 = Test(RadialMenuMountValidation, "missSelectsNothing", {
		value = RadialMenuMountValidation.missSelectsNothing,
	})
	if _descriptor_19 then
		RadialMenuMountValidation.missSelectsNothing = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_15(RadialMenuMountValidation, "missSelectsNothing", {
		value = RadialMenuMountValidation.missSelectsNothing,
	})
	if _descriptor_20 then
		RadialMenuMountValidation.missSelectsNothing = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_14(RadialMenuMountValidation, "missSelectsNothing", {
		value = RadialMenuMountValidation.missSelectsNothing,
	})
	if _descriptor_21 then
		RadialMenuMountValidation.missSelectsNothing = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_13(RadialMenuMountValidation, "missSelectsNothing", {
		value = RadialMenuMountValidation.missSelectsNothing,
	})
	if _descriptor_22 then
		RadialMenuMountValidation.missSelectsNothing = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("A miss leaves an existing selection untouched rather than clearing it")
	local _descriptor_23 = Test(RadialMenuMountValidation, "missKeepsSelection", {
		value = RadialMenuMountValidation.missKeepsSelection,
	})
	if _descriptor_23 then
		RadialMenuMountValidation.missKeepsSelection = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_17(RadialMenuMountValidation, "missKeepsSelection", {
		value = RadialMenuMountValidation.missKeepsSelection,
	})
	if _descriptor_24 then
		RadialMenuMountValidation.missKeepsSelection = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_16(RadialMenuMountValidation, "missKeepsSelection", {
		value = RadialMenuMountValidation.missKeepsSelection,
	})
	if _descriptor_25 then
		RadialMenuMountValidation.missKeepsSelection = _descriptor_25.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("A touch release selects like a mouse release, while a right-button release is ignored")
	local _descriptor_26 = Test(RadialMenuMountValidation, "releaseInputTypes", {
		value = RadialMenuMountValidation.releaseInputTypes,
	})
	if _descriptor_26 then
		RadialMenuMountValidation.releaseInputTypes = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_19(RadialMenuMountValidation, "releaseInputTypes", {
		value = RadialMenuMountValidation.releaseInputTypes,
	})
	if _descriptor_27 then
		RadialMenuMountValidation.releaseInputTypes = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_18(RadialMenuMountValidation, "releaseInputTypes", {
		value = RadialMenuMountValidation.releaseInputTypes,
	})
	if _descriptor_28 then
		RadialMenuMountValidation.releaseInputTypes = _descriptor_28.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_21 = DisplayName("Releasing on the already-selected item still fires onValueChange and keeps it selected")
	local _descriptor_29 = Test(RadialMenuMountValidation, "reselectFires", {
		value = RadialMenuMountValidation.reselectFires,
	})
	if _descriptor_29 then
		RadialMenuMountValidation.reselectFires = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_21(RadialMenuMountValidation, "reselectFires", {
		value = RadialMenuMountValidation.reselectFires,
	})
	if _descriptor_30 then
		RadialMenuMountValidation.reselectFires = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_20(RadialMenuMountValidation, "reselectFires", {
		value = RadialMenuMountValidation.reselectFires,
	})
	if _descriptor_31 then
		RadialMenuMountValidation.reselectFires = _descriptor_31.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("In controlled mode a release only reports the hit item and the centre waits for the parent's new value")
	local _descriptor_32 = Test(RadialMenuMountValidation, "controlledClickReports", {
		value = RadialMenuMountValidation.controlledClickReports,
	})
	if _descriptor_32 then
		RadialMenuMountValidation.controlledClickReports = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_23(RadialMenuMountValidation, "controlledClickReports", {
		value = RadialMenuMountValidation.controlledClickReports,
	})
	if _descriptor_33 then
		RadialMenuMountValidation.controlledClickReports = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_22(RadialMenuMountValidation, "controlledClickReports", {
		value = RadialMenuMountValidation.controlledClickReports,
	})
	if _descriptor_34 then
		RadialMenuMountValidation.controlledClickReports = _descriptor_34.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = DisplayName("Moving over an unselected segment shows the hover wedge and moving into the centre hole clears it")
	local _descriptor_35 = Test(RadialMenuMountValidation, "hoverFollowsPointer", {
		value = RadialMenuMountValidation.hoverFollowsPointer,
	})
	if _descriptor_35 then
		RadialMenuMountValidation.hoverFollowsPointer = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_25(RadialMenuMountValidation, "hoverFollowsPointer", {
		value = RadialMenuMountValidation.hoverFollowsPointer,
	})
	if _descriptor_36 then
		RadialMenuMountValidation.hoverFollowsPointer = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_24(RadialMenuMountValidation, "hoverFollowsPointer", {
		value = RadialMenuMountValidation.hoverFollowsPointer,
	})
	if _descriptor_37 then
		RadialMenuMountValidation.hoverFollowsPointer = _descriptor_37.value
	end
	RadialMenuMountValidation = Tag("Studio")(RadialMenuMountValidation) or RadialMenuMountValidation
end
return RadialMenuMountValidation
