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
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Button").Button
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
local function pressButton(log, options)
	if options == nil then
		options = {}
	end
	local _attributes = {
		text = "Hold",
	}
	local _condition = options.mode
	if _condition == nil then
		_condition = "down"
	end
	_attributes.pressOn = pressOnFor(_condition)
	_attributes.disabled = options.disabled
	_attributes.Event = {
		Activated = function(_button, input)
			local _events = log.events
			local _arg0 = `activated:{input.UserInputType.Name}`
			table.insert(_events, _arg0)
		end,
		InputBegan = if options.callerInputBegan then function(_button, input)
			local _events = log.events
			local _arg0 = `began:{input.UserInputType.Name}`
			table.insert(_events, _arg0)
		end else nil,
	}
	_attributes.onRelease = function(_button, input)
		local _released = log.released
		local _name = input.UserInputType.Name
		table.insert(_released, _name)
	end
	return React.createElement(Button, _attributes)
end
local function waitForButton(host)
	return waitForGuiObject(host, "Button")
end
local ButtonPressDownValidation
do
	ButtonPressDownValidation = setmetatable({}, {
		__tostring = function()
			return "ButtonPressDownValidation"
		end,
	})
	ButtonPressDownValidation.__index = ButtonPressDownValidation
	function ButtonPressDownValidation.new(...)
		local self = setmetatable({}, ButtonPressDownValidation)
		return self:constructor(...) or self
	end
	function ButtonPressDownValidation:constructor()
	end
	function ButtonPressDownValidation:firesOnBegan(kind)
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			withPress(kind, function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				Assert:deepEqual(log.events, { `activated:{kind}` })
				fireHostEvent(mounted, button, "Activated", press.input, 1)
				Assert:deepEqual(log.events, { `activated:{kind}` })
			end)
		end)
	end
	function ButtonPressDownValidation:gamepadPassesThrough()
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			local input = gamepadInput()
			fireHostEvent(mounted, button, "InputBegan", input)
			Assert:deepEqual(log.events, {})
			fireHostEvent(mounted, button, "Activated", input, 1)
			Assert:deepEqual(log.events, { "activated:Gamepad1" })
			settleFrames(3)
			Assert:deepEqual(log.released, {}, "Expected a gamepad activation never to call onRelease")
		end)
	end
	function ButtonPressDownValidation:releasesOnEnd(state)
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				settleFrames(2)
				Assert:deepEqual(log.released, {}, "Expected no release while the press is still held")
				press.finish(releaseState(state))
				Assert:deepEqual(log.released, { "MouseButton1" })
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.released, { "MouseButton1" }, "Expected the release connection to be gone after it fired")
			end)
		end)
	end
	function ButtonPressDownValidation:touchesTrackedSeparately()
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("Touch", function(first)
				withPress("Touch", function(second)
					fireHostEvent(mounted, button, "InputBegan", first.input)
					fireHostEvent(mounted, button, "InputBegan", second.input)
					Assert:deepEqual(log.events, { "activated:Touch", "activated:Touch" })
					first.finish(Enum.UserInputState.End)
					Assert:deepEqual(log.released, { "Touch" })
					second.finish(Enum.UserInputState.End)
					Assert:deepEqual(log.released, { "Touch", "Touch" })
				end)
			end)
		end)
	end
	function ButtonPressDownValidation:disabledBlocks()
		local log = newLog()
		withMounted(400, 200, pressButton(log, {
			disabled = true,
		}), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				fireHostEvent(mounted, button, "Activated", press.input, 1)
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.events, {})
				Assert:deepEqual(log.released, {})
			end)
		end)
	end
	function ButtonPressDownValidation:disabledMidHold()
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				mounted.update(pressButton(log, {
					disabled = true,
				}))
				Assert["false"](Assert, button.Active, "Expected the button to be disabled before the release")
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.released, { "MouseButton1" })
			end)
		end)
	end
	function ButtonPressDownValidation:unmountDropsRelease()
		local log = newLog()
		withMounted(400, 200, pressButton(log), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				mounted.update(React.createElement("frame", {
					key = "Empty",
					BackgroundTransparency = 1,
				}))
				press.finish(Enum.UserInputState.End)
				settleFrames(2)
				Assert:deepEqual(log.released, {})
			end)
		end)
	end
	function ButtonPressDownValidation:callerInputBeganFirst()
		local log = newLog()
		withMounted(400, 200, pressButton(log, {
			callerInputBegan = true,
		}), function(mounted)
			local button = waitForButton(mounted.host)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "InputBegan", press.input)
				Assert:deepEqual(log.events, { "began:MouseButton1", "activated:MouseButton1" })
			end)
		end)
	end
	function ButtonPressDownValidation:upUnchanged(mode)
		local log = newLog()
		withMounted(400, 200, pressButton(log, {
			mode = mode,
		}), function(mounted)
			local button = waitForButton(mounted.host)
			Assert:undefined(hostHandler(mounted, button, "InputBegan"), `{mode}: expected no InputBegan handler`)
			withPress("MouseButton1", function(press)
				fireHostEvent(mounted, button, "Activated", press.input, 1)
				press.finish(Enum.UserInputState.End)
				Assert:deepEqual(log.events, { "activated:MouseButton1" })
				Assert:deepEqual(log.released, {}, `{mode}: expected onRelease to be unused`)
			end)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "MouseButton1" }, { "Touch" } })
	local _decorator_2 = DisplayName("A pointer InputBegan activates once and the later native Activated for the same press is swallowed")
	local _descriptor = Test(ButtonPressDownValidation, "firesOnBegan", {
		value = ButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor then
		ButtonPressDownValidation.firesOnBegan = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(ButtonPressDownValidation, "firesOnBegan", {
		value = ButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_1 then
		ButtonPressDownValidation.firesOnBegan = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(ButtonPressDownValidation, "firesOnBegan", {
		value = ButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_2 then
		ButtonPressDownValidation.firesOnBegan = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(ButtonPressDownValidation, "firesOnBegan", {
		value = ButtonPressDownValidation.firesOnBegan,
	})
	if _descriptor_3 then
		ButtonPressDownValidation.firesOnBegan = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("A gamepad ButtonA press is ignored on InputBegan and passes through the native Activated unchanged")
	local _descriptor_4 = Test(ButtonPressDownValidation, "gamepadPassesThrough", {
		value = ButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_4 then
		ButtonPressDownValidation.gamepadPassesThrough = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(ButtonPressDownValidation, "gamepadPassesThrough", {
		value = ButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_5 then
		ButtonPressDownValidation.gamepadPassesThrough = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(ButtonPressDownValidation, "gamepadPassesThrough", {
		value = ButtonPressDownValidation.gamepadPassesThrough,
	})
	if _descriptor_6 then
		ButtonPressDownValidation.gamepadPassesThrough = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { "End" }, { "Cancel" } })
	local _decorator_7 = DisplayName("onRelease fires once, only when the pressed input's UserInputState becomes End or Cancel")
	local _descriptor_7 = Test(ButtonPressDownValidation, "releasesOnEnd", {
		value = ButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_7 then
		ButtonPressDownValidation.releasesOnEnd = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(ButtonPressDownValidation, "releasesOnEnd", {
		value = ButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_8 then
		ButtonPressDownValidation.releasesOnEnd = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(ButtonPressDownValidation, "releasesOnEnd", {
		value = ButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_9 then
		ButtonPressDownValidation.releasesOnEnd = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(ButtonPressDownValidation, "releasesOnEnd", {
		value = ButtonPressDownValidation.releasesOnEnd,
	})
	if _descriptor_10 then
		ButtonPressDownValidation.releasesOnEnd = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Two simultaneous touches give two activations and each touch's own release")
	local _descriptor_11 = Test(ButtonPressDownValidation, "touchesTrackedSeparately", {
		value = ButtonPressDownValidation.touchesTrackedSeparately,
	})
	if _descriptor_11 then
		ButtonPressDownValidation.touchesTrackedSeparately = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(ButtonPressDownValidation, "touchesTrackedSeparately", {
		value = ButtonPressDownValidation.touchesTrackedSeparately,
	})
	if _descriptor_12 then
		ButtonPressDownValidation.touchesTrackedSeparately = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(ButtonPressDownValidation, "touchesTrackedSeparately", {
		value = ButtonPressDownValidation.touchesTrackedSeparately,
	})
	if _descriptor_13 then
		ButtonPressDownValidation.touchesTrackedSeparately = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A disabled button ignores press-down, the native Activated and never tracks a release")
	local _descriptor_14 = Test(ButtonPressDownValidation, "disabledBlocks", {
		value = ButtonPressDownValidation.disabledBlocks,
	})
	if _descriptor_14 then
		ButtonPressDownValidation.disabledBlocks = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(ButtonPressDownValidation, "disabledBlocks", {
		value = ButtonPressDownValidation.disabledBlocks,
	})
	if _descriptor_15 then
		ButtonPressDownValidation.disabledBlocks = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(ButtonPressDownValidation, "disabledBlocks", {
		value = ButtonPressDownValidation.disabledBlocks,
	})
	if _descriptor_16 then
		ButtonPressDownValidation.disabledBlocks = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A press that began while enabled still releases after the button is disabled mid-hold")
	local _descriptor_17 = Test(ButtonPressDownValidation, "disabledMidHold", {
		value = ButtonPressDownValidation.disabledMidHold,
	})
	if _descriptor_17 then
		ButtonPressDownValidation.disabledMidHold = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(ButtonPressDownValidation, "disabledMidHold", {
		value = ButtonPressDownValidation.disabledMidHold,
	})
	if _descriptor_18 then
		ButtonPressDownValidation.disabledMidHold = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(ButtonPressDownValidation, "disabledMidHold", {
		value = ButtonPressDownValidation.disabledMidHold,
	})
	if _descriptor_19 then
		ButtonPressDownValidation.disabledMidHold = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Presses still held when the button unmounts are dropped without calling onRelease")
	local _descriptor_20 = Test(ButtonPressDownValidation, "unmountDropsRelease", {
		value = ButtonPressDownValidation.unmountDropsRelease,
	})
	if _descriptor_20 then
		ButtonPressDownValidation.unmountDropsRelease = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(ButtonPressDownValidation, "unmountDropsRelease", {
		value = ButtonPressDownValidation.unmountDropsRelease,
	})
	if _descriptor_21 then
		ButtonPressDownValidation.unmountDropsRelease = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(ButtonPressDownValidation, "unmountDropsRelease", {
		value = ButtonPressDownValidation.unmountDropsRelease,
	})
	if _descriptor_22 then
		ButtonPressDownValidation.unmountDropsRelease = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("The caller's own InputBegan runs before the press-down activation")
	local _descriptor_23 = Test(ButtonPressDownValidation, "callerInputBeganFirst", {
		value = ButtonPressDownValidation.callerInputBeganFirst,
	})
	if _descriptor_23 then
		ButtonPressDownValidation.callerInputBeganFirst = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_17(ButtonPressDownValidation, "callerInputBeganFirst", {
		value = ButtonPressDownValidation.callerInputBeganFirst,
	})
	if _descriptor_24 then
		ButtonPressDownValidation.callerInputBeganFirst = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_16(ButtonPressDownValidation, "callerInputBeganFirst", {
		value = ButtonPressDownValidation.callerInputBeganFirst,
	})
	if _descriptor_25 then
		ButtonPressDownValidation.callerInputBeganFirst = _descriptor_25.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = Each({ { "unset" }, { "up" } })
	local _decorator_20 = DisplayName("Without pressOn down there is no InputBegan handler and a pointer Activated fires as before")
	local _descriptor_26 = Test(ButtonPressDownValidation, "upUnchanged", {
		value = ButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_26 then
		ButtonPressDownValidation.upUnchanged = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_20(ButtonPressDownValidation, "upUnchanged", {
		value = ButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_27 then
		ButtonPressDownValidation.upUnchanged = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(ButtonPressDownValidation, "upUnchanged", {
		value = ButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_28 then
		ButtonPressDownValidation.upUnchanged = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(ButtonPressDownValidation, "upUnchanged", {
		value = ButtonPressDownValidation.upUnchanged,
	})
	if _descriptor_29 then
		ButtonPressDownValidation.upUnchanged = _descriptor_29.value
	end
	ButtonPressDownValidation = Tag("Studio")(ButtonPressDownValidation) or ButtonPressDownValidation
end
return ButtonPressDownValidation
