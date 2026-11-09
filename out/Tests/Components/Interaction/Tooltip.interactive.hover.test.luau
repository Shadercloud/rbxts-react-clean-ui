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
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local FAST_THEME = _tooltip.FAST_THEME
local HOLD_SECONDS = _tooltip.HOLD_SECONDS
local assertNoPopup = _tooltip.assertNoPopup
local assertStaysShown = _tooltip.assertStaysShown
local fadesBy = _tooltip.fadesBy
local pressInput = _tooltip.pressInput
local tipApp = _tooltip.tipApp
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipHoverValidation
do
	TooltipHoverValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipHoverValidation"
		end,
	})
	TooltipHoverValidation.__index = TooltipHoverValidation
	function TooltipHoverValidation.new(...)
		local self = setmetatable({}, TooltipHoverValidation)
		return self:constructor(...) or self
	end
	function TooltipHoverValidation:constructor()
	end
	function TooltipHoverValidation:plainClosesAtOnce()
		withMounted(400, 300, tipApp(), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			local popup = waitForShown(mounted.host)
			Assert["false"](Assert, popup.Active, "Expected a plain Tooltip popup not to be Active")
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			Assert["true"](Assert, fadesBy(popup, os.clock() + 0.5), "Expected a plain Tooltip to start fading right after MouseLeave")
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipHoverValidation:plainPressNoop(kind)
		withMounted(400, 300, tipApp(), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind))
			assertNoPopup(mounted.host, `Expected a {kind} press not to open a plain Tooltip`)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			waitForShown(mounted.host)
			fireHostEvent(mounted, trigger, "InputBegan", pressInput(kind))
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipHoverValidation:crossToPopup()
		withMounted(400, 300, tipApp({
			interactive = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			local popup = waitForShown(mounted.host)
			Assert["true"](Assert, popup.Active, "Expected an interactive Tooltip popup to be Active")
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			fireHostEvent(mounted, popup, "MouseEnter", 0, 0)
			assertStaysShown(mounted.host, HOLD_SECONDS, "Expected the popup to stay open while it is hovered")
			fireHostEvent(mounted, popup, "MouseLeave", 0, 0)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipHoverValidation:closeAfterDelay()
		withMounted(400, 300, tipApp({
			interactive = true,
		}, DefaultTheme), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			local popup = waitForShown(mounted.host)
			local early = os.clock() + DefaultTheme.components.tooltip.closeDelay * 0.6
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			Assert["false"](Assert, fadesBy(popup, early), "Expected no fade before closeDelay has elapsed")
			Assert["true"](Assert, fadesBy(popup, os.clock() + 1), "Expected the popup to fade once closeDelay has elapsed")
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipHoverValidation:themeCloseDelay()
		local theme = extendTheme(FAST_THEME, {
			components = {
				tooltip = {
					closeDelay = 1,
				},
			},
		})
		withMounted(400, 300, tipApp({
			interactive = true,
		}, theme), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			fireHostEvent(mounted, trigger, "MouseEnter", 0, 0)
			waitForShown(mounted.host)
			fireHostEvent(mounted, trigger, "MouseLeave", 0, 0)
			assertStaysShown(mounted.host, 0.6, "Expected the overridden closeDelay to keep the popup open")
			waitForRemoval(mounted.host, "Tooltip", 240)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without the opt-in props, leaving the trigger starts the fade at once and the popup is not Active")
	local _descriptor = Test(TooltipHoverValidation, "plainClosesAtOnce", {
		value = TooltipHoverValidation.plainClosesAtOnce,
	})
	if _descriptor then
		TooltipHoverValidation.plainClosesAtOnce = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipHoverValidation, "plainClosesAtOnce", {
		value = TooltipHoverValidation.plainClosesAtOnce,
	})
	if _descriptor_1 then
		TooltipHoverValidation.plainClosesAtOnce = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipHoverValidation, "plainClosesAtOnce", {
		value = TooltipHoverValidation.plainClosesAtOnce,
	})
	if _descriptor_2 then
		TooltipHoverValidation.plainClosesAtOnce = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_4 = DisplayName("Without pinOnPress or longPress, a press neither opens the popup nor keeps it open after MouseLeave")
	local _descriptor_3 = Test(TooltipHoverValidation, "plainPressNoop", {
		value = TooltipHoverValidation.plainPressNoop,
	})
	if _descriptor_3 then
		TooltipHoverValidation.plainPressNoop = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(TooltipHoverValidation, "plainPressNoop", {
		value = TooltipHoverValidation.plainPressNoop,
	})
	if _descriptor_4 then
		TooltipHoverValidation.plainPressNoop = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(TooltipHoverValidation, "plainPressNoop", {
		value = TooltipHoverValidation.plainPressNoop,
	})
	if _descriptor_5 then
		TooltipHoverValidation.plainPressNoop = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(TooltipHoverValidation, "plainPressNoop", {
		value = TooltipHoverValidation.plainPressNoop,
	})
	if _descriptor_6 then
		TooltipHoverValidation.plainPressNoop = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("An interactive popup is Active and stays open while the pointer crosses from the trigger onto it")
	local _descriptor_7 = Test(TooltipHoverValidation, "crossToPopup", {
		value = TooltipHoverValidation.crossToPopup,
	})
	if _descriptor_7 then
		TooltipHoverValidation.crossToPopup = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TooltipHoverValidation, "crossToPopup", {
		value = TooltipHoverValidation.crossToPopup,
	})
	if _descriptor_8 then
		TooltipHoverValidation.crossToPopup = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TooltipHoverValidation, "crossToPopup", {
		value = TooltipHoverValidation.crossToPopup,
	})
	if _descriptor_9 then
		TooltipHoverValidation.crossToPopup = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Once the pointer leaves an interactive tooltip it stays fully shown for the theme closeDelay, then fades")
	local _descriptor_10 = Test(TooltipHoverValidation, "closeAfterDelay", {
		value = TooltipHoverValidation.closeAfterDelay,
	})
	if _descriptor_10 then
		TooltipHoverValidation.closeAfterDelay = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TooltipHoverValidation, "closeAfterDelay", {
		value = TooltipHoverValidation.closeAfterDelay,
	})
	if _descriptor_11 then
		TooltipHoverValidation.closeAfterDelay = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TooltipHoverValidation, "closeAfterDelay", {
		value = TooltipHoverValidation.closeAfterDelay,
	})
	if _descriptor_12 then
		TooltipHoverValidation.closeAfterDelay = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("A ThemeProvider closeDelay override of 1s keeps an interactive popup open well past the default delay")
	local _descriptor_13 = Test(TooltipHoverValidation, "themeCloseDelay", {
		value = TooltipHoverValidation.themeCloseDelay,
	})
	if _descriptor_13 then
		TooltipHoverValidation.themeCloseDelay = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TooltipHoverValidation, "themeCloseDelay", {
		value = TooltipHoverValidation.themeCloseDelay,
	})
	if _descriptor_14 then
		TooltipHoverValidation.themeCloseDelay = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TooltipHoverValidation, "themeCloseDelay", {
		value = TooltipHoverValidation.themeCloseDelay,
	})
	if _descriptor_15 then
		TooltipHoverValidation.themeCloseDelay = _descriptor_15.value
	end
	TooltipHoverValidation = Tag("Studio")(TooltipHoverValidation) or TooltipHoverValidation
end
return TooltipHoverValidation
