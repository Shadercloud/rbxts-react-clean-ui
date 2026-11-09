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
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _tooltip = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip")
local FAST_TOOLTIP = _tooltip.FAST_TOOLTIP
local assertNoPopup = _tooltip.assertNoPopup
local fadesBy = _tooltip.fadesBy
local pressInput = _tooltip.pressInput
local tipApp = _tooltip.tipApp
local touchPress = _tooltip.touchPress
local waitForShown = _tooltip.waitForShown
local waitForTrigger = _tooltip.waitForTrigger
local TooltipControlledValidation
do
	TooltipControlledValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipControlledValidation"
		end,
	})
	TooltipControlledValidation.__index = TooltipControlledValidation
	function TooltipControlledValidation.new(...)
		local self = setmetatable({}, TooltipControlledValidation)
		return self:constructor(...) or self
	end
	function TooltipControlledValidation:constructor()
	end
	function TooltipControlledValidation:controlledIgnoresPress(kind)
		withMounted(400, 300, tipApp({
			open = false,
			interactive = true,
			pinOnPress = true,
			longPress = true,
		}), function(mounted)
			local trigger = waitForTrigger(mounted.host)
			if kind == "Touch" then
				local touch = touchPress()
				fireHostEvent(mounted, trigger, "InputBegan", touch.input)
				task.wait(FAST_TOOLTIP.longPressDelay + 0.2)
				assertNoPopup(mounted.host, "Expected a long press not to open a controlled Tooltip")
				touch.finish(Enum.UserInputState.End)
			else
				fireHostEvent(mounted, trigger, "InputBegan", pressInput())
			end
			assertNoPopup(mounted.host, `Expected a {kind} press not to open a controlled Tooltip`)
		end)
	end
	function TooltipControlledValidation:controlledCloseImmediate()
		withMounted(400, 300, tipApp({
			open = true,
			interactive = true,
		}, DefaultTheme), function(mounted)
			local popup = waitForShown(mounted.host)
			mounted.update(tipApp({
				open = false,
				interactive = true,
			}, DefaultTheme))
			Assert["true"](Assert, fadesBy(popup, os.clock() + DefaultTheme.components.tooltip.closeDelay * 0.6), "Expected a controlled close to start fading before closeDelay")
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_2 = DisplayName("With open={false}, presses and long presses on a trigger with every opt-in prop open nothing")
	local _descriptor = Test(TooltipControlledValidation, "controlledIgnoresPress", {
		value = TooltipControlledValidation.controlledIgnoresPress,
	})
	if _descriptor then
		TooltipControlledValidation.controlledIgnoresPress = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TooltipControlledValidation, "controlledIgnoresPress", {
		value = TooltipControlledValidation.controlledIgnoresPress,
	})
	if _descriptor_1 then
		TooltipControlledValidation.controlledIgnoresPress = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TooltipControlledValidation, "controlledIgnoresPress", {
		value = TooltipControlledValidation.controlledIgnoresPress,
	})
	if _descriptor_2 then
		TooltipControlledValidation.controlledIgnoresPress = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TooltipControlledValidation, "controlledIgnoresPress", {
		value = TooltipControlledValidation.controlledIgnoresPress,
	})
	if _descriptor_3 then
		TooltipControlledValidation.controlledIgnoresPress = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Switching an interactive Tooltip from open={true} to open={false} fades it at once with no closeDelay")
	local _descriptor_4 = Test(TooltipControlledValidation, "controlledCloseImmediate", {
		value = TooltipControlledValidation.controlledCloseImmediate,
	})
	if _descriptor_4 then
		TooltipControlledValidation.controlledCloseImmediate = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TooltipControlledValidation, "controlledCloseImmediate", {
		value = TooltipControlledValidation.controlledCloseImmediate,
	})
	if _descriptor_5 then
		TooltipControlledValidation.controlledCloseImmediate = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TooltipControlledValidation, "controlledCloseImmediate", {
		value = TooltipControlledValidation.controlledCloseImmediate,
	})
	if _descriptor_6 then
		TooltipControlledValidation.controlledCloseImmediate = _descriptor_6.value
	end
	TooltipControlledValidation = Tag("Studio")(TooltipControlledValidation) or TooltipControlledValidation
end
return TooltipControlledValidation
