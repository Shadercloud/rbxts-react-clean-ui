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
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function eventArgs(eventName)
	return if eventName == "Activated" then { {}, 1 } else { 0, 0 }
end
local function loggingEvents(log, label)
	return {
		Activated = function()
			local _log = log
			local _arg0 = `{label}:Activated`
			table.insert(_log, _arg0)
		end,
		MouseEnter = function()
			local _log = log
			local _arg0 = `{label}:MouseEnter`
			table.insert(_log, _arg0)
		end,
	}
end
local function bothEventsButton(log)
	return React.createElement(HoverButton, {
		Event = loggingEvents(log, "top"),
		default = {
			Size = UDim2.fromOffset(120, 40),
			Event = loggingEvents(log, "default"),
		},
	})
end
local HoverButtonEventValidation
do
	HoverButtonEventValidation = setmetatable({}, {
		__tostring = function()
			return "HoverButtonEventValidation"
		end,
	})
	HoverButtonEventValidation.__index = HoverButtonEventValidation
	function HoverButtonEventValidation.new(...)
		local self = setmetatable({}, HoverButtonEventValidation)
		return self:constructor(...) or self
	end
	function HoverButtonEventValidation:constructor()
	end
	function HoverButtonEventValidation:runsBothHandlers(eventName)
		local log = {}
		withMounted(400, 200, bothEventsButton(log), function(mounted)
			local button = waitForGuiObject(mounted.host, "HoverButton")
			fireHostEvent(mounted, button, eventName, unpack(eventArgs(eventName)))
			Assert:deepEqual(log, { `default:{eventName}`, `top:{eventName}` })
		end)
	end
	function HoverButtonEventValidation:forwardsRef()
		local ref = React.createRef()
		withMounted(400, 200, React.createElement(HoverButton, {
			ref = ref,
			default = {
				Size = UDim2.fromOffset(120, 40),
			},
		}), function(mounted)
			local button = waitForGuiObject(mounted.host, "HoverButton")
			Assert:equal(ref.current, button)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "Activated" }, { "MouseEnter" } })
	local _decorator_2 = DisplayName("With both a top-level Event and default.Event, one host event runs each handler once with default's first")
	local _descriptor = Test(HoverButtonEventValidation, "runsBothHandlers", {
		value = HoverButtonEventValidation.runsBothHandlers,
	})
	if _descriptor then
		HoverButtonEventValidation.runsBothHandlers = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(HoverButtonEventValidation, "runsBothHandlers", {
		value = HoverButtonEventValidation.runsBothHandlers,
	})
	if _descriptor_1 then
		HoverButtonEventValidation.runsBothHandlers = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(HoverButtonEventValidation, "runsBothHandlers", {
		value = HoverButtonEventValidation.runsBothHandlers,
	})
	if _descriptor_2 then
		HoverButtonEventValidation.runsBothHandlers = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(HoverButtonEventValidation, "runsBothHandlers", {
		value = HoverButtonEventValidation.runsBothHandlers,
	})
	if _descriptor_3 then
		HoverButtonEventValidation.runsBothHandlers = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("A ref passed to HoverButton resolves to its root ImageButton")
	local _descriptor_4 = Test(HoverButtonEventValidation, "forwardsRef", {
		value = HoverButtonEventValidation.forwardsRef,
	})
	if _descriptor_4 then
		HoverButtonEventValidation.forwardsRef = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(HoverButtonEventValidation, "forwardsRef", {
		value = HoverButtonEventValidation.forwardsRef,
	})
	if _descriptor_5 then
		HoverButtonEventValidation.forwardsRef = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(HoverButtonEventValidation, "forwardsRef", {
		value = HoverButtonEventValidation.forwardsRef,
	})
	if _descriptor_6 then
		HoverButtonEventValidation.forwardsRef = _descriptor_6.value
	end
	HoverButtonEventValidation = Tag("Studio")(HoverButtonEventValidation) or HoverButtonEventValidation
end
return HoverButtonEventValidation
