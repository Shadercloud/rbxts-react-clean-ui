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
local HoverButton = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "HoverButton").HoverButton
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local _press = TS.import(script, script.Parent.Parent.Parent, "Helpers", "press")
local gamepadInput = _press.gamepadInput
local hostHandler = _press.hostHandler
local releaseState = _press.releaseState
local withPress = _press.withPress
local function newLog()
	return {
		events = {},
		released = {},
	}
end
local function pressOnFor(mode)
	return if mode == "unset" then nil elseif mode == "up" then "up" else "down"
end
local function pressHoverButton(log, options)
	if options == nil then
		options = {}
	end
	local _attributes = {}
	local _condition = options.mode
	if _condition == nil then
		_condition = "down"
	end
	_attributes.pressOn = pressOnFor(_condition)
	_attributes.onRelease = function(_button, input)
		local _released = log.released
		local _name = input.UserInputType.Name
		table.insert(_released, _name)
	end
	_attributes.default = {
		Size = UDim2.fromOffset(120, 40),
		Active = options.active,
		Event = {
			Activated = function(_button, input)
				local _events = log.events
				local _arg0 = `default:{input.UserInputType.Name}`
				table.insert(_events, _arg0)
			end,
		},
	}
	_attributes.hover = if options.hoverActivated then {
		Event = {
			Activated = function(_button, input)
				local _events = log.events
				local _arg0 = `hover:{input.UserInputType.Name}`
				table.insert(_events, _arg0)
			end,
		},
	} else nil
	return React.createElement(HoverButton, _attributes)
end
local function waitForHoverButton(host)
	return waitForGuiObject(host, "HoverButton")
end
local HoverButtonPressDownValidation
do
	HoverButtonPressDownValidation = setmetatable({}, {
		__tostring = function()
			return "HoverButtonPressDownValidation"
		end,
	})
	HoverButtonPressDownValidation.__index = HoverButtonPressDownValidation
	function HoverButtonPressDownValidation.new(...)
		local self = setmetatable({}, HoverButtonPressDownValidation)
		return self:constructor(...) or self
	end
	function HoverButtonPressDownValidation:constructor()
	end
	function HoverButtonPressDownValidation:firesOnBegan(kind)
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log), function(mounted)
			local button = waitForHoverButton(mounted.host)
			withPress(kind, function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				Assert:deepEqual(log.events, { `default:{kind}` })
				fireHostEvent(mounted, button, "Activated", press.input, 1)
				Assert:deepEqual(log.events, { `default:{kind}` })
			end)
		end)
	end
	function HoverButtonPressDownValidation:gamepadPassesThrough()
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log), function(mounted)
			local button = waitForHoverButton(mounted.host)
			local input = gamepadInput()
			fireHostEvent(mounted, button, "InputBegan", input)
			Assert:deepEqual(log.events, {})
			fireHostEvent(mounted, button, "Activated", input, 1)
			Assert:deepEqual(log.events, { "default:Gamepad1" })
		end)
	end
	function HoverButtonPressDownValidation:releasesOnEnd(state)
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log), function(mounted)
			local button = waitForHoverButton(mounted.host)
			withPress("Touch", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				settleFrames(2)
				Assert:deepEqual(log.released, {}, "Expected no release while the touch is still held")
				press.finish(releaseState(state))
				Assert:deepEqual(log.released, { "Touch" })
			end)
		end)
	end
	function HoverButtonPressDownValidation:inactiveBlocks()
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log, {
			active = false,
		}), function(mounted)
			local button = waitForHoverButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.events, {})
				Assert:deepEqual(log.released, {})
			end)
		end)
	end
	function HoverButtonPressDownValidation:hoverSetActivated()
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log, {
			hoverActivated = true,
		}), function(mounted)
			local button = waitForHoverButton(mounted.host)
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				Assert:deepEqual(log.events, { "hover:MouseButton1" })
			end)
		end)
	end
	function HoverButtonPressDownValidation:upUnchanged(mode)
		local log = newLog()
		withMounted(400, 200, pressHoverButton(log, {
			mode = mode,
		}), function(mounted)
			local button = waitForHoverButton(mounted.host)
			Assert:undefined(hostHandler(mounted, button, "InputBegan"), `{mode}: expected no InputBegan handler`)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "Activated", press.input, 1)
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.events, { "default:MouseButton1" })
				Assert:deepEqual(log.released, {}, `{mode}: expected onRelease to be unused`)
			end)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_2 = DisplayName("A pointer InputBegan calls the default Activated once and the later native pointer Activated is swallowed")
	local _descriptor = Test(HoverButtonPressDownValidation, "firesOnBegan", {
		value = HoverButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor then
		HoverButtonPressDownValidation.firesOnBegan = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(HoverButtonPressDownValidation, "firesOnBegan", {
		value = HoverButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_1 then
		HoverButtonPressDownValidation.firesOnBegan = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(HoverButtonPressDownValidation, "firesOnBegan", {
		value = HoverButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_2 then
		HoverButtonPressDownValidation.firesOnBegan = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(HoverButtonPressDownValidation, "firesOnBegan", {
		value = HoverButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_3 then
		HoverButtonPressDownValidation.firesOnBegan = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("A gamepad ButtonA press is ignored on InputBegan and passes through the native Activated")
	local _descriptor_4 = Test(HoverButtonPressDownValidation, "gamepadPassesThrough", {
		value = HoverButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_4 then
		HoverButtonPressDownValidation.gamepadPassesThrough = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(HoverButtonPressDownValidation, "gamepadPassesThrough", {
		value = HoverButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_5 then
		HoverButtonPressDownValidation.gamepadPassesThrough = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(HoverButtonPressDownValidation, "gamepadPassesThrough", {
		value = HoverButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_6 then
		HoverButtonPressDownValidation.gamepadPassesThrough = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { "End" }, { "Cancel" } })
	local _decorator_7 = DisplayName("onRelease fires once when the pressed input's UserInputState becomes End or Cancel")
	local _descriptor_7 = Test(HoverButtonPressDownValidation, "releasesOnEnd", {
		value = HoverButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_7 then
		HoverButtonPressDownValidation.releasesOnEnd = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(HoverButtonPressDownValidation, "releasesOnEnd", {
		value = HoverButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_8 then
		HoverButtonPressDownValidation.releasesOnEnd = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(HoverButtonPressDownValidation, "releasesOnEnd", {
		value = HoverButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_9 then
		HoverButtonPressDownValidation.releasesOnEnd = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(HoverButtonPressDownValidation, "releasesOnEnd", {
		value = HoverButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_10 then
		HoverButtonPressDownValidation.releasesOnEnd = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Active=false in the merged prop set blocks press-down activation and its release")
	local _descriptor_11 = Test(HoverButtonPressDownValidation, "inactiveBlocks", {
		value = HoverButtonPressDownValidation.inactiveBlocks,
	})
	if _descriptor_11 then
		HoverButtonPressDownValidation.inactiveBlocks = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(HoverButtonPressDownValidation, "inactiveBlocks", {
		value = HoverButtonPressDownValidation.inactiveBlocks,
	})
	if _descriptor_12 then
		HoverButtonPressDownValidation.inactiveBlocks = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(HoverButtonPressDownValidation, "inactiveBlocks", {
		value = HoverButtonPressDownValidation.inactiveBlocks,
	})
	if _descriptor_13 then
		HoverButtonPressDownValidation.inactiveBlocks = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("While hovered, press-down calls the hover set's Activated instead of the default one")
	local _descriptor_14 = Test(HoverButtonPressDownValidation, "hoverSetActivated", {
		value = HoverButtonPressDownValidation.hoverSetActivated,
	})
	if _descriptor_14 then
		HoverButtonPressDownValidation.hoverSetActivated = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(HoverButtonPressDownValidation, "hoverSetActivated", {
		value = HoverButtonPressDownValidation.hoverSetActivated,
	})
	if _descriptor_15 then
		HoverButtonPressDownValidation.hoverSetActivated = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(HoverButtonPressDownValidation, "hoverSetActivated", {
		value = HoverButtonPressDownValidation.hoverSetActivated,
	})
	if _descriptor_16 then
		HoverButtonPressDownValidation.hoverSetActivated = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = Each({ { "unset" }, { "up" } })
	local _decorator_14 = DisplayName("Without pressOn down there is no InputBegan handler and a pointer Activated reaches the default set")
	local _descriptor_17 = Test(HoverButtonPressDownValidation, "upUnchanged", {
		value = HoverButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_17 then
		HoverButtonPressDownValidation.upUnchanged = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_14(HoverButtonPressDownValidation, "upUnchanged", {
		value = HoverButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_18 then
		HoverButtonPressDownValidation.upUnchanged = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(HoverButtonPressDownValidation, "upUnchanged", {
		value = HoverButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_19 then
		HoverButtonPressDownValidation.upUnchanged = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(HoverButtonPressDownValidation, "upUnchanged", {
		value = HoverButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_20 then
		HoverButtonPressDownValidation.upUnchanged = _descriptor_20.value
	end
	HoverButtonPressDownValidation = Tag("Studio")(HoverButtonPressDownValidation) or HoverButtonPressDownValidation
end
return HoverButtonPressDownValidation
