-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
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
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local HOLD_SECONDS = _tooltip.HOLD_SECONDS
local assertStaysShown = _tooltip.assertStaysShown
local pressInput = _tooltip.pressInput
local tipApp = _tooltip.tipApp
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipPinValidation
do
	TooltipPinValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipPinValidation"
		end,
	})
	TooltipPinValidation.__index = TooltipPinValidation
	function TooltipPinValidation.new(...)
		local self = setmetatable({}, TooltipPinValidation)
		return self:constructor(...) or self
	end
	function TooltipPinValidation:constructor()
	end
	function TooltipPinValidation:pressPins()
		withMounted(400, 300, tipApp({
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			waitForShown(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected a pinned popup to survive MouseLeave")
		end)
	end
	function TooltipPinValidation:pressTriggerUnpins(kind)
		withMounted(400, 300, tipApp({
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind))
			waitForShown(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind))
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipPinValidation:hoveredUnpinOpen()
		withMounted(400, 300, tipApp({
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected the hovered trigger to keep an unpinned popup open")
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipPinValidation:pressPopupUnpins(kind)
		withMounted(400, 300, tipApp({
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			local popup = waitForShown(mounted.host)
			Assert["true"](Assert, popup.Active, "Expected a pinOnPress Tooltip popup to be Active")
			fireHostEvent(mounted, popup, "InputBegan", pressInput(kind))
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipPinValidation:popupPressNoPin()
		withMounted(400, 300, tipApp({
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			local popup = waitForShown(mounted.host)
			fireHostEvent(mounted, popup, "InputBegan", pressInput())
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With pinOnPress, a press on the hovered trigger keeps the popup open after MouseLeave")
	local _descriptor = Test(TooltipPinValidation, "pressPins", {
		value = TooltipPinValidation.pressPins,
	})
	if _descriptor then
		TooltipPinValidation.pressPins = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipPinValidation, "pressPins", {
		value = TooltipPinValidation.pressPins,
	})
	if _descriptor_1 then
		TooltipPinValidation.pressPins = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipPinValidation, "pressPins", {
		value = TooltipPinValidation.pressPins,
	})
	if _descriptor_2 then
		TooltipPinValidation.pressPins = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_4 = DisplayName("With pinOnPress, a first press opens the popup without a hover and a second press on the trigger closes it")
	local _descriptor_3 = Test(TooltipPinValidation, "pressTriggerUnpins", {
		value = TooltipPinValidation.pressTriggerUnpins,
	})
	if _descriptor_3 then
		TooltipPinValidation.pressTriggerUnpins = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(TooltipPinValidation, "pressTriggerUnpins", {
		value = TooltipPinValidation.pressTriggerUnpins,
	})
	if _descriptor_4 then
		TooltipPinValidation.pressTriggerUnpins = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(TooltipPinValidation, "pressTriggerUnpins", {
		value = TooltipPinValidation.pressTriggerUnpins,
	})
	if _descriptor_5 then
		TooltipPinValidation.pressTriggerUnpins = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(TooltipPinValidation, "pressTriggerUnpins", {
		value = TooltipPinValidation.pressTriggerUnpins,
	})
	if _descriptor_6 then
		TooltipPinValidation.pressTriggerUnpins = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Unpinning while the trigger is still hovered leaves the popup open until the pointer leaves")
	local _descriptor_7 = Test(TooltipPinValidation, "hoveredUnpinOpen", {
		value = TooltipPinValidation.hoveredUnpinOpen,
	})
	if _descriptor_7 then
		TooltipPinValidation.hoveredUnpinOpen = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TooltipPinValidation, "hoveredUnpinOpen", {
		value = TooltipPinValidation.hoveredUnpinOpen,
	})
	if _descriptor_8 then
		TooltipPinValidation.hoveredUnpinOpen = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TooltipPinValidation, "hoveredUnpinOpen", {
		value = TooltipPinValidation.hoveredUnpinOpen,
	})
	if _descriptor_9 then
		TooltipPinValidation.hoveredUnpinOpen = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_9 = DisplayName("A press anywhere on a pinned popup unpins and closes it, and its pinOnPress popup is Active")
	local _descriptor_10 = Test(TooltipPinValidation, "pressPopupUnpins", {
		value = TooltipPinValidation.pressPopupUnpins,
	})
	if _descriptor_10 then
		TooltipPinValidation.pressPopupUnpins = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_9(TooltipPinValidation, "pressPopupUnpins", {
		value = TooltipPinValidation.pressPopupUnpins,
	})
	if _descriptor_11 then
		TooltipPinValidation.pressPopupUnpins = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(TooltipPinValidation, "pressPopupUnpins", {
		value = TooltipPinValidation.pressPopupUnpins,
	})
	if _descriptor_12 then
		TooltipPinValidation.pressPopupUnpins = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(TooltipPinValidation, "pressPopupUnpins", {
		value = TooltipPinValidation.pressPopupUnpins,
	})
	if _descriptor_13 then
		TooltipPinValidation.pressPopupUnpins = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A press on an unpinned, hover-opened popup does not pin it, so leaving the trigger still closes it")
	local _descriptor_14 = Test(TooltipPinValidation, "popupPressNoPin", {
		value = TooltipPinValidation.popupPressNoPin,
	})
	if _descriptor_14 then
		TooltipPinValidation.popupPressNoPin = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(TooltipPinValidation, "popupPressNoPin", {
		value = TooltipPinValidation.popupPressNoPin,
	})
	if _descriptor_15 then
		TooltipPinValidation.popupPressNoPin = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(TooltipPinValidation, "popupPressNoPin", {
		value = TooltipPinValidation.popupPressNoPin,
	})
	if _descriptor_16 then
		TooltipPinValidation.popupPressNoPin = _descriptor_16.value
	end
	TooltipPinValidation = Tag("Studio")(TooltipPinValidation) or TooltipPinValidation
end
return TooltipPinValidation
