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
local PLACEHOLDER = {
	icon = "cog",
	text = "System Settings",
	description = "Radial Menu",
}
local function menuFixture(props)
	local log = props.log
	return React.createElement(RadialMenu, {
		items = props.items,
		size = MENU_SIZE,
		defaultValue = props.defaultValue,
		placeholder = props.placeholder,
		showLabels = props.showLabels,
		onValueChange = function(value)
			if log ~= nil then
				local _value = value
				table.insert(log, _value)
			end
		end,
	})
end
local function badge(name)
	return React.createElement("imagelabel", {
		key = name,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})
end
local function centreLabel(name, text)
	return React.createElement("textlabel", {
		key = name,
		Text = text,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})
end
local function stateText(state)
	return `{state.selected}:{state.hovered}`
end
local function probe(name)
	return function(state)
		return React.createElement("textlabel", {
			key = name,
			Text = stateText(state),
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})
	end
end
local function plainItems()
	return { {
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
end
local function withItem(value, patch)
	local _exp = plainItems()
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp)
	local _callback = function(item)
		local _result
		if item.value == value then
			local _object = table.clone(item)
			setmetatable(_object, nil)
			for _k, _v in patch do
				_object[_k] = _v
			end
			_result = _object
		else
			_result = item
		end
		return _result
	end
	for _k, _v in _exp do
		_newValue[_k] = _callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.map ▲
	return _newValue
end
local function waitForHitArea(host)
	return waitForGuiObject(host, "HitArea")
end
local function itemFrame(host, value)
	return findDescendant(host, `RadialMenuItem-{value}`)
end
local function waitForCenterTitle(host, text)
	return waitForDescendant(host, "CenterTitle", function(label)
		return label.Text == text
	end, `Timed out waiting for CenterTitle to read "{text}"`)
end
local function waitForProbe(root, name, expected, label)
	local _exp = root
	local _exp_1 = name
	local _exp_2 = function(probeLabel)
		return probeLabel.Text == expected
	end
	local _exp_3 = label
	local _exp_4 = name
	local _exp_5 = expected
	local _result = (root:FindFirstChild(name, true))
	if _result ~= nil then
		_result = _result.Text
	end
	return waitForDescendant(_exp, _exp_1, _exp_2, `{_exp_3}: timed out waiting for {_exp_4} to read "{_exp_5}" (reads "{_result}")`)
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
local function release(mounted, hitArea, angle, radius)
	fireHostEvent(mounted, hitArea, "InputEnded", pointerInput(Enum.UserInputType.MouseButton1, pointAt(hitArea, angle, radius)))
end
local function move(mounted, hitArea, angle, radius)
	fireHostEvent(mounted, hitArea, "InputChanged", pointerInput(Enum.UserInputType.MouseMovement, pointAt(hitArea, angle, radius)))
end
local function assertDefaultCentreAbsent(host, label)
	for _, name in { "CenterIcon", "CenterTitle", "CenterDescription" } do
		Assert:undefined(host:FindFirstChild(name, true), `{label}: expected no {name} in the centre`)
	end
end
local RadialMenuContentValidation
do
	RadialMenuContentValidation = setmetatable({}, {
		__tostring = function()
			return "RadialMenuContentValidation"
		end,
	})
	RadialMenuContentValidation.__index = RadialMenuContentValidation
	function RadialMenuContentValidation.new(...)
		local self = setmetatable({}, RadialMenuContentValidation)
		return self:constructor(...) or self
	end
	function RadialMenuContentValidation:constructor()
	end
	function RadialMenuContentValidation:contentReplacesIcon()
		withMounted(300, 300, menuFixture({
			items = withItem("east", {
				content = badge("EastBadge"),
			}),
		}), function(mounted)
			waitForHitArea(mounted.host)
			settleFrames(2)
			local east = itemFrame(mounted.host, "east")
			local slot = findDescendant(east, "ItemContent")
			Assert:notUndefined(slot:FindFirstChild("EastBadge"), "Expected the content to be parented directly to ItemContent")
			Assert:undefined(east:FindFirstChild("ItemIcon", true), "Expected no ItemIcon for an item with content")
		end)
	end
	function RadialMenuContentValidation:contentHidesLabel()
		withMounted(300, 300, menuFixture({
			items = withItem("east", {
				content = badge("EastBadge"),
			}),
			showLabels = true,
		}), function(mounted)
			waitForHitArea(mounted.host)
			settleFrames(2)
			local east = itemFrame(mounted.host, "east")
			findDescendant(east, "ItemContent")
			Assert:undefined(east:FindFirstChild("ItemLabel", true), "Expected no ItemLabel for an item with content")
			local north = itemFrame(mounted.host, "north")
			Assert:equal(findDescendant(north, "ItemLabel").Text, "North", "Expected the plain item's label to stay")
		end)
	end
	function RadialMenuContentValidation:mixedItems()
		withMounted(300, 300, menuFixture({
			items = withItem("east", {
				content = badge("EastBadge"),
			}),
		}), function(mounted)
			waitForHitArea(mounted.host)
			settleFrames(2)
			for _, value in { "north", "south", "west" } do
				local item = itemFrame(mounted.host, value)
				Assert["true"](Assert, findDescendant(item, "ItemIcon").Image ~= "", `Expected {value} to render an ItemIcon with an image`)
				Assert:undefined(item:FindFirstChild("ItemContent", true), `Expected no ItemContent for plain item {value}`)
			end
		end)
	end
	function RadialMenuContentValidation:functionContentState()
		local _exp = plainItems()
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#_exp)
		local _callback = function(item)
			local _object = table.clone(item)
			setmetatable(_object, nil)
			_object.content = probe(`Probe-{item.value}`)
			return _object
		end
		for _k, _v in _exp do
			_newValue[_k] = _callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.map ▲
		local items = _newValue
		withMounted(300, 300, menuFixture({
			items = items,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			for _, item in items do
				waitForProbe(mounted.host, `Probe-{item.value}`, "false:false", "on mount")
			end
			move(mounted, hitArea, 90, RING_RADIUS)
			waitForProbe(mounted.host, "Probe-east", "false:true", "hovering east")
			waitForProbe(mounted.host, "Probe-north", "false:false", "hovering east")
			release(mounted, hitArea, 90, RING_RADIUS)
			waitForProbe(mounted.host, "Probe-east", "true:true", "after selecting east under the pointer")
			move(mounted, hitArea, 0, RING_RADIUS)
			waitForProbe(mounted.host, "Probe-east", "true:false", "hovering north with east selected")
			waitForProbe(mounted.host, "Probe-north", "false:true", "hovering north with east selected")
			move(mounted, hitArea, 0, 20)
			waitForProbe(mounted.host, "Probe-north", "false:false", "pointer in the centre hole")
			waitForProbe(mounted.host, "Probe-east", "true:false", "pointer in the centre hole")
		end)
	end
	function RadialMenuContentValidation:functionCentreState()
		local items = withItem("east", {
			centerContent = probe("CentreProbe"),
		})
		withMounted(300, 300, menuFixture({
			items = items,
			defaultValue = "east",
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			local slot = waitForGuiObject(mounted.host, "CenterSlot", function()
				return true
			end)
			waitForProbe(slot, "CentreProbe", "true:false", "east selected, no hover")
			move(mounted, hitArea, 90, RING_RADIUS)
			waitForProbe(slot, "CentreProbe", "true:true", "hovering selected east")
			move(mounted, hitArea, 180, RING_RADIUS)
			waitForProbe(slot, "CentreProbe", "true:false", "hovering south")
		end)
	end
	function RadialMenuContentValidation:itemCentreContent()
		local items = withItem("east", {
			centerContent = centreLabel("EastCentre", "Custom east"),
		})
		withMounted(300, 300, menuFixture({
			items = items,
			placeholder = PLACEHOLDER,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "System Settings")
			release(mounted, hitArea, 90, RING_RADIUS)
			local slot = waitForGuiObject(mounted.host, "CenterSlot", function()
				return true
			end)
			Assert:equal(findDescendant(mounted.host, "CenterContent"), slot.Parent, "Expected CenterSlot inside CenterContent")
			Assert:equal(findDescendant(slot, "EastCentre").Text, "Custom east", "Expected east's centreContent in the slot")
			assertDefaultCentreAbsent(mounted.host, "east selected")
			release(mounted, hitArea, 180, RING_RADIUS)
			waitForCenterTitle(mounted.host, "South")
			waitForRemoval(mounted.host, "CenterSlot", 30)
			Assert:undefined(mounted.host:FindFirstChild("EastCentre", true), "Expected east's centreContent gone once south is selected")
			Assert:equal(findDescendant(mounted.host, "CenterDescription").Text, "Bottom item", "Expected south's default description")
		end)
	end
	function RadialMenuContentValidation:placeholderCentreContent()
		local _object = table.clone(PLACEHOLDER)
		setmetatable(_object, nil)
		_object.centerContent = centreLabel("PlaceholderCentre", "Pick one")
		local placeholder = _object
		withMounted(300, 300, menuFixture({
			items = plainItems(),
			placeholder = placeholder,
		}), function(mounted)
			waitForHitArea(mounted.host)
			local slot = waitForGuiObject(mounted.host, "CenterSlot", function()
				return true
			end)
			Assert:equal(findDescendant(slot, "PlaceholderCentre").Text, "Pick one", "Expected the placeholder's centreContent in the slot")
			assertDefaultCentreAbsent(mounted.host, "placeholder centreContent")
		end)
	end
	function RadialMenuContentValidation:selectedIgnoresPlaceholder()
		local _object = table.clone(PLACEHOLDER)
		setmetatable(_object, nil)
		_object.centerContent = centreLabel("PlaceholderCentre", "Pick one")
		local placeholder = _object
		withMounted(300, 300, menuFixture({
			items = plainItems(),
			placeholder = placeholder,
			defaultValue = "north",
		}), function(mounted)
			waitForHitArea(mounted.host)
			waitForCenterTitle(mounted.host, "North")
			settleFrames(3)
			Assert:undefined(mounted.host:FindFirstChild("CenterSlot", true), "Expected no CenterSlot for a selected plain item")
			Assert:undefined(mounted.host:FindFirstChild("PlaceholderCentre", true), "Expected the placeholder's centreContent not to render")
			Assert:equal(findDescendant(mounted.host, "CenterDescription").Text, "Top item", "Expected north's default description")
		end)
	end
	function RadialMenuContentValidation:activeButtonInert()
		local log = {}
		local button = React.createElement("textbutton", {
			key = "ContentButton",
			Active = true,
			Text = "",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		})
		local items = withItem("east", {
			content = button,
			centerContent = centreLabel("EastCentre", "Custom east"),
		})
		withMounted(300, 300, menuFixture({
			items = items,
			placeholder = PLACEHOLDER,
			log = log,
		}), function(mounted)
			local hitArea = waitForHitArea(mounted.host)
			local contentButton = waitForGuiObject(mounted.host, "ContentButton")
			waitForCenterTitle(mounted.host, "System Settings")
			Assert["false"](Assert, findDescendant(mounted.host, "ItemContent").Interactable, "Expected ItemContent to be non-interactable")
			local _absolutePosition = contentButton.AbsolutePosition
			local _arg0 = contentButton.AbsoluteSize / 2
			local centre = _absolutePosition + _arg0
			local layer = contentButton
			while layer.Parent ~= nil and layer.Parent ~= hitArea.Parent do
				layer = layer.Parent
			end
			Assert:equal(layer.Parent, hitArea.Parent, "Expected the content to share a sibling layer with HitArea")
			Assert["true"](Assert, layer.ZIndex < hitArea.ZIndex, `Expected HitArea (ZIndex {hitArea.ZIndex}) above the content's layer {layer.Name} (ZIndex {layer.ZIndex})`)
			local hitCentreX = hitArea.AbsolutePosition.X + hitArea.AbsoluteSize.X / 2
			local hitCentreY = hitArea.AbsolutePosition.Y + hitArea.AbsoluteSize.Y / 2
			local angle = math.deg(math.atan2(centre.X - hitCentreX, -(centre.Y - hitCentreY)))
			local radius = math.sqrt((centre.X - hitCentreX) ^ 2 + (centre.Y - hitCentreY) ^ 2)
			release(mounted, hitArea, angle, radius)
			local slot = waitForGuiObject(mounted.host, "CenterSlot", function()
				return true
			end)
			Assert["false"](Assert, slot.Interactable, "Expected CenterSlot to be non-interactable")
			waitForLayout(function()
				return if #log > 0 then true else nil
			end, "Expected a release over the content button to select east")
			Assert:equal(table.concat(log, ","), "east", "Expected onValueChange to report east")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Node content renders inside an ItemContent slot in place of the item's ItemIcon")
	local _descriptor = Test(RadialMenuContentValidation, "contentReplacesIcon", {
		value = RadialMenuContentValidation.contentReplacesIcon,
	})
	if _descriptor then
		RadialMenuContentValidation.contentReplacesIcon = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(RadialMenuContentValidation, "contentReplacesIcon", {
		value = RadialMenuContentValidation.contentReplacesIcon,
	})
	if _descriptor_1 then
		RadialMenuContentValidation.contentReplacesIcon = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(RadialMenuContentValidation, "contentReplacesIcon", {
		value = RadialMenuContentValidation.contentReplacesIcon,
	})
	if _descriptor_2 then
		RadialMenuContentValidation.contentReplacesIcon = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With showLabels on, an item with content renders no ItemLabel while plain items keep theirs")
	local _descriptor_3 = Test(RadialMenuContentValidation, "contentHidesLabel", {
		value = RadialMenuContentValidation.contentHidesLabel,
	})
	if _descriptor_3 then
		RadialMenuContentValidation.contentHidesLabel = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(RadialMenuContentValidation, "contentHidesLabel", {
		value = RadialMenuContentValidation.contentHidesLabel,
	})
	if _descriptor_4 then
		RadialMenuContentValidation.contentHidesLabel = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(RadialMenuContentValidation, "contentHidesLabel", {
		value = RadialMenuContentValidation.contentHidesLabel,
	})
	if _descriptor_5 then
		RadialMenuContentValidation.contentHidesLabel = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("In a mixed menu plain items still render ItemIcon and only the custom item gets an ItemContent slot")
	local _descriptor_6 = Test(RadialMenuContentValidation, "mixedItems", {
		value = RadialMenuContentValidation.mixedItems,
	})
	if _descriptor_6 then
		RadialMenuContentValidation.mixedItems = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(RadialMenuContentValidation, "mixedItems", {
		value = RadialMenuContentValidation.mixedItems,
	})
	if _descriptor_7 then
		RadialMenuContentValidation.mixedItems = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(RadialMenuContentValidation, "mixedItems", {
		value = RadialMenuContentValidation.mixedItems,
	})
	if _descriptor_8 then
		RadialMenuContentValidation.mixedItems = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Function content gets raw hover and selection per item, with both true while hovering the selected item")
	local _descriptor_9 = Test(RadialMenuContentValidation, "functionContentState", {
		value = RadialMenuContentValidation.functionContentState,
	})
	if _descriptor_9 then
		RadialMenuContentValidation.functionContentState = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(RadialMenuContentValidation, "functionContentState", {
		value = RadialMenuContentValidation.functionContentState,
	})
	if _descriptor_10 then
		RadialMenuContentValidation.functionContentState = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(RadialMenuContentValidation, "functionContentState", {
		value = RadialMenuContentValidation.functionContentState,
	})
	if _descriptor_11 then
		RadialMenuContentValidation.functionContentState = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Function centreContent always gets selected true and follows hover of the selected item's segment")
	local _descriptor_12 = Test(RadialMenuContentValidation, "functionCentreState", {
		value = RadialMenuContentValidation.functionCentreState,
	})
	if _descriptor_12 then
		RadialMenuContentValidation.functionCentreState = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(RadialMenuContentValidation, "functionCentreState", {
		value = RadialMenuContentValidation.functionCentreState,
	})
	if _descriptor_13 then
		RadialMenuContentValidation.functionCentreState = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(RadialMenuContentValidation, "functionCentreState", {
		value = RadialMenuContentValidation.functionCentreState,
	})
	if _descriptor_14 then
		RadialMenuContentValidation.functionCentreState = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("An item's centreContent fills the centre while it is selected and the default centre returns for other items")
	local _descriptor_15 = Test(RadialMenuContentValidation, "itemCentreContent", {
		value = RadialMenuContentValidation.itemCentreContent,
	})
	if _descriptor_15 then
		RadialMenuContentValidation.itemCentreContent = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(RadialMenuContentValidation, "itemCentreContent", {
		value = RadialMenuContentValidation.itemCentreContent,
	})
	if _descriptor_16 then
		RadialMenuContentValidation.itemCentreContent = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(RadialMenuContentValidation, "itemCentreContent", {
		value = RadialMenuContentValidation.itemCentreContent,
	})
	if _descriptor_17 then
		RadialMenuContentValidation.itemCentreContent = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("With nothing selected the placeholder's centreContent replaces its icon, title and description")
	local _descriptor_18 = Test(RadialMenuContentValidation, "placeholderCentreContent", {
		value = RadialMenuContentValidation.placeholderCentreContent,
	})
	if _descriptor_18 then
		RadialMenuContentValidation.placeholderCentreContent = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(RadialMenuContentValidation, "placeholderCentreContent", {
		value = RadialMenuContentValidation.placeholderCentreContent,
	})
	if _descriptor_19 then
		RadialMenuContentValidation.placeholderCentreContent = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(RadialMenuContentValidation, "placeholderCentreContent", {
		value = RadialMenuContentValidation.placeholderCentreContent,
	})
	if _descriptor_20 then
		RadialMenuContentValidation.placeholderCentreContent = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("A selected item without centreContent shows its own default centre, never the placeholder's centreContent")
	local _descriptor_21 = Test(RadialMenuContentValidation, "selectedIgnoresPlaceholder", {
		value = RadialMenuContentValidation.selectedIgnoresPlaceholder,
	})
	if _descriptor_21 then
		RadialMenuContentValidation.selectedIgnoresPlaceholder = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(RadialMenuContentValidation, "selectedIgnoresPlaceholder", {
		value = RadialMenuContentValidation.selectedIgnoresPlaceholder,
	})
	if _descriptor_22 then
		RadialMenuContentValidation.selectedIgnoresPlaceholder = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(RadialMenuContentValidation, "selectedIgnoresPlaceholder", {
		value = RadialMenuContentValidation.selectedIgnoresPlaceholder,
	})
	if _descriptor_23 then
		RadialMenuContentValidation.selectedIgnoresPlaceholder = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("An Active TextButton in an item's content sits under HitArea and a release over it still selects the item")
	local _descriptor_24 = Test(RadialMenuContentValidation, "activeButtonInert", {
		value = RadialMenuContentValidation.activeButtonInert,
	})
	if _descriptor_24 then
		RadialMenuContentValidation.activeButtonInert = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(RadialMenuContentValidation, "activeButtonInert", {
		value = RadialMenuContentValidation.activeButtonInert,
	})
	if _descriptor_25 then
		RadialMenuContentValidation.activeButtonInert = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(RadialMenuContentValidation, "activeButtonInert", {
		value = RadialMenuContentValidation.activeButtonInert,
	})
	if _descriptor_26 then
		RadialMenuContentValidation.activeButtonInert = _descriptor_26.value
	end
	RadialMenuContentValidation = Tag("Studio")(RadialMenuContentValidation) or RadialMenuContentValidation
end
return RadialMenuContentValidation
