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
local settleFrames = _layout.settleFrames
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local FAST_TOOLTIP = _tooltip.FAST_TOOLTIP
local assertNoPopup = _tooltip.assertNoPopup
local assertStaysShown = _tooltip.assertStaysShown
local pressInput = _tooltip.pressInput
local tipApp = _tooltip.tipApp
local touchPress = _tooltip.touchPress
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipLongPressValidation
do
	TooltipLongPressValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipLongPressValidation"
		end,
	})
	TooltipLongPressValidation.__index = TooltipLongPressValidation
	function TooltipLongPressValidation.new(...)
		local self = setmetatable({}, TooltipLongPressValidation)
		return self:constructor(...) or self
	end
	function TooltipLongPressValidation:constructor()
	end
	function TooltipLongPressValidation:holdOpens()
		withMounted(400, 300, tipApp({
			longPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			local touch = touchPress()
			fireHostEvent(mounted, trigger, "InputBegan", touch.input)
			task.wait(FAST_TOOLTIP.longPressDelay * 0.5)
			Assert:undefined(mounted.host:FindFirstChild("Tooltip", true), "Expected no popup before longPressDelay")
			task.wait(FAST_TOOLTIP.longPressDelay * 0.5)
			waitForShown(mounted.host)
			assertStaysShown(mounted.host, 0.3, "Expected the popup to stay open while the finger is down")
			touch.finish(Enum.UserInputState.End)
		end)
	end
	function TooltipLongPressValidation:releaseCloses(state, pinOnPress)
		withMounted(400, 300, tipApp({
			longPress = true,
			pinOnPress = pinOnPress,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			local touch = touchPress()
			fireHostEvent(mounted, trigger, "InputBegan", touch.input)
			task.wait(FAST_TOOLTIP.longPressDelay)
			waitForShown(mounted.host)
			touch.finish(if state == "End" then Enum.UserInputState.End else Enum.UserInputState.Cancel)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipLongPressValidation:shortTapNoop()
		withMounted(400, 300, tipApp({
			longPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			local touch = touchPress()
			fireHostEvent(mounted, trigger, "InputBegan", touch.input)
			touch.finish(Enum.UserInputState.End)
			task.wait(FAST_TOOLTIP.longPressDelay + 0.2)
			assertNoPopup(mounted.host, "Expected a short tap not to open a longPress-only Tooltip")
		end)
	end
	function TooltipLongPressValidation:tapTogglesPin()
		withMounted(400, 300, tipApp({
			longPress = true,
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			local first = touchPress()
			fireHostEvent(mounted, trigger, "InputBegan", first.input)
			settleFrames(5)
			Assert:undefined(mounted.host:FindFirstChild("Tooltip", true), "Expected no popup on touch-down")
			first.finish(Enum.UserInputState.End)
			waitForShown(mounted.host)
			assertStaysShown(mounted.host, FAST_TOOLTIP.longPressDelay + 0.2, "Expected the tap to pin the popup")
			local second = touchPress()
			fireHostEvent(mounted, trigger, "InputBegan", second.input)
			second.finish(Enum.UserInputState.End)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipLongPressValidation:mousePressPins()
		withMounted(400, 300, tipApp({
			longPress = true,
			pinOnPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			waitForShown(mounted.host)
			assertStaysShown(mounted.host, 0.3, "Expected a mouse press to pin the popup")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A held touch on a longPress trigger shows nothing before longPressDelay and opens the popup after it")
	local _descriptor = Test(TooltipLongPressValidation, "holdOpens", {
		value = TooltipLongPressValidation.holdOpens,
	})
	if _descriptor then
		TooltipLongPressValidation.holdOpens = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipLongPressValidation, "holdOpens", {
		value = TooltipLongPressValidation.holdOpens,
	})
	if _descriptor_1 then
		TooltipLongPressValidation.holdOpens = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipLongPressValidation, "holdOpens", {
		value = TooltipLongPressValidation.holdOpens,
	})
	if _descriptor_2 then
		TooltipLongPressValidation.holdOpens = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "End", false }, { "Cancel", false }, { "End", true } })
	local _decorator_4 = DisplayName("Lifting or cancelling a long press closes the popup, and a long press never pins even with pinOnPress")
	local _descriptor_3 = Test(TooltipLongPressValidation, "releaseCloses", {
		value = TooltipLongPressValidation.releaseCloses,
	})
	if _descriptor_3 then
		TooltipLongPressValidation.releaseCloses = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(TooltipLongPressValidation, "releaseCloses", {
		value = TooltipLongPressValidation.releaseCloses,
	})
	if _descriptor_4 then
		TooltipLongPressValidation.releaseCloses = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(TooltipLongPressValidation, "releaseCloses", {
		value = TooltipLongPressValidation.releaseCloses,
	})
	if _descriptor_5 then
		TooltipLongPressValidation.releaseCloses = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(TooltipLongPressValidation, "releaseCloses", {
		value = TooltipLongPressValidation.releaseCloses,
	})
	if _descriptor_6 then
		TooltipLongPressValidation.releaseCloses = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("A short tap on a longPress trigger without pinOnPress never opens the popup")
	local _descriptor_7 = Test(TooltipLongPressValidation, "shortTapNoop", {
		value = TooltipLongPressValidation.shortTapNoop,
	})
	if _descriptor_7 then
		TooltipLongPressValidation.shortTapNoop = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TooltipLongPressValidation, "shortTapNoop", {
		value = TooltipLongPressValidation.shortTapNoop,
	})
	if _descriptor_8 then
		TooltipLongPressValidation.shortTapNoop = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TooltipLongPressValidation, "shortTapNoop", {
		value = TooltipLongPressValidation.shortTapNoop,
	})
	if _descriptor_9 then
		TooltipLongPressValidation.shortTapNoop = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With longPress and pinOnPress, a short tap pins on release rather than touch-down, and a second tap unpins")
	local _descriptor_10 = Test(TooltipLongPressValidation, "tapTogglesPin", {
		value = TooltipLongPressValidation.tapTogglesPin,
	})
	if _descriptor_10 then
		TooltipLongPressValidation.tapTogglesPin = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TooltipLongPressValidation, "tapTogglesPin", {
		value = TooltipLongPressValidation.tapTogglesPin,
	})
	if _descriptor_11 then
		TooltipLongPressValidation.tapTogglesPin = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TooltipLongPressValidation, "tapTogglesPin", {
		value = TooltipLongPressValidation.tapTogglesPin,
	})
	if _descriptor_12 then
		TooltipLongPressValidation.tapTogglesPin = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("With longPress and pinOnPress, a mouse press pins immediately instead of starting a long press")
	local _descriptor_13 = Test(TooltipLongPressValidation, "mousePressPins", {
		value = TooltipLongPressValidation.mousePressPins,
	})
	if _descriptor_13 then
		TooltipLongPressValidation.mousePressPins = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TooltipLongPressValidation, "mousePressPins", {
		value = TooltipLongPressValidation.mousePressPins,
	})
	if _descriptor_14 then
		TooltipLongPressValidation.mousePressPins = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TooltipLongPressValidation, "mousePressPins", {
		value = TooltipLongPressValidation.mousePressPins,
	})
	if _descriptor_15 then
		TooltipLongPressValidation.mousePressPins = _descriptor_15.value
	end
	TooltipLongPressValidation = Tag("Studio")(TooltipLongPressValidation) or TooltipLongPressValidation
end
return TooltipLongPressValidation
