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
local BreakpointProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "BreakpointProvider").BreakpointProvider
local _breakpoint_context = TS.import(script, script.Parent.Parent.Parent.Parent, "Contexts", "breakpoint.context")
local BreakpointContext = _breakpoint_context.BreakpointContext
local useBreakpoint = _breakpoint_context.useBreakpoint
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local renderCount = 0
local latestBreakpoint
local latestContext
local function resetHarness()
	renderCount = 0
	latestBreakpoint = nil
	latestContext = nil
end
local function BreakpointHarness()
	renderCount += 1
	latestBreakpoint = useBreakpoint()
	latestContext = React.useContext(BreakpointContext)
	return nil
end
local function waitForProviderWidth(host, width)
	return waitForGuiObject(host, "BreakpointProvider", function(frame)
		return frame.AbsoluteSize.X == width
	end, `Timed out waiting for the BreakpointProvider frame to measure {width}px wide`)
end
local function waitForBreakpoint(expected)
	waitForLayout(function()
		return if latestBreakpoint == expected then true else nil
	end, `Timed out waiting for useBreakpoint to return "{expected}" (last value "{latestBreakpoint}")`)
end
local function settle(frames)
	do
		local frame = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				frame += 1
			else
				_shouldIncrement = true
			end
			if not (frame < frames) then
				break
			end
			task.wait()
		end
	end
end
local BreakpointProviderMountValidation
do
	BreakpointProviderMountValidation = setmetatable({}, {
		__tostring = function()
			return "BreakpointProviderMountValidation"
		end,
	})
	BreakpointProviderMountValidation.__index = BreakpointProviderMountValidation
	function BreakpointProviderMountValidation.new(...)
		local self = setmetatable({}, BreakpointProviderMountValidation)
		return self:constructor(...) or self
	end
	function BreakpointProviderMountValidation:constructor()
	end
	function BreakpointProviderMountValidation:measuredBreakpoint(width, expected)
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(BreakpointHarness)))
		withMounted(width, 300, element, function(mounted)
			waitForProviderWidth(mounted.host, width)
			settle(2)
			waitForBreakpoint(expected)
		end)
	end
	function BreakpointProviderMountValidation:publishesWidth()
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(BreakpointHarness)))
		withMounted(250, 300, element, function(mounted)
			waitForProviderWidth(mounted.host, 250)
			waitForBreakpoint("sm")
			Assert:notUndefined(latestContext, "Expected the consumer to read a BreakpointContext value under the provider")
			Assert:equal(latestContext.width, 250, "Expected the context width to be the provider's measured width")
		end)
	end
	function BreakpointProviderMountValidation:breakpointsProp()
		resetHarness()
		local element = (React.createElement(BreakpointProvider, {
			breakpoints = {
				xs = 0,
				sm = 50,
				md = 100,
				lg = 150,
				xl = 1000,
			},
		}, React.createElement(BreakpointHarness)))
		withMounted(150, 300, element, function(mounted)
			waitForProviderWidth(mounted.host, 150)
			waitForBreakpoint("lg")
		end)
	end
	function BreakpointProviderMountValidation:rerendersOnCrossing()
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(BreakpointHarness)))
		withMounted(250, 300, element, function(mounted)
			waitForProviderWidth(mounted.host, 250)
			waitForBreakpoint("sm")
			settle(3)
			local baseline = renderCount
			mounted.resize(280, 300)
			waitForProviderWidth(mounted.host, 280)
			settle(3)
			Assert:equal(latestBreakpoint, "sm", "Expected a 280px provider to stay at sm")
			Assert:equal(renderCount, baseline, `Expected no consumer renders while resizing within sm (baseline {baseline}, now {renderCount})`)
			mounted.resize(290, 300)
			waitForProviderWidth(mounted.host, 290)
			settle(3)
			Assert:equal(renderCount, baseline, `Expected no consumer renders after a second resize within sm (baseline {baseline}, now {renderCount})`)
			mounted.resize(350, 300)
			waitForProviderWidth(mounted.host, 350)
			waitForBreakpoint("md")
			settle(3)
			Assert:equal(renderCount, baseline + 1, `Expected exactly one consumer render when crossing into md (baseline {baseline}, now {renderCount})`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A consumer receives the breakpoint matching the provider's measured width against the theme breakpoints")
	local _decorator_2 = Each({ { 50, "xs" }, { 250, "sm" }, { 350, "md" }, { 450, "lg" }, { 600, "xl" } })
	local _descriptor = Test(BreakpointProviderMountValidation, "measuredBreakpoint", {
		value = BreakpointProviderMountValidation.measuredBreakpoint,
	})
	if _descriptor then
		BreakpointProviderMountValidation.measuredBreakpoint = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(BreakpointProviderMountValidation, "measuredBreakpoint", {
		value = BreakpointProviderMountValidation.measuredBreakpoint,
	})
	if _descriptor_1 then
		BreakpointProviderMountValidation.measuredBreakpoint = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(BreakpointProviderMountValidation, "measuredBreakpoint", {
		value = BreakpointProviderMountValidation.measuredBreakpoint,
	})
	if _descriptor_2 then
		BreakpointProviderMountValidation.measuredBreakpoint = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(BreakpointProviderMountValidation, "measuredBreakpoint", {
		value = BreakpointProviderMountValidation.measuredBreakpoint,
	})
	if _descriptor_3 then
		BreakpointProviderMountValidation.measuredBreakpoint = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("The context publishes the width measured when the breakpoint was resolved")
	local _descriptor_4 = Test(BreakpointProviderMountValidation, "publishesWidth", {
		value = BreakpointProviderMountValidation.publishesWidth,
	})
	if _descriptor_4 then
		BreakpointProviderMountValidation.publishesWidth = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(BreakpointProviderMountValidation, "publishesWidth", {
		value = BreakpointProviderMountValidation.publishesWidth,
	})
	if _descriptor_5 then
		BreakpointProviderMountValidation.publishesWidth = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(BreakpointProviderMountValidation, "publishesWidth", {
		value = BreakpointProviderMountValidation.publishesWidth,
	})
	if _descriptor_6 then
		BreakpointProviderMountValidation.publishesWidth = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("A breakpoints prop overrides the theme thresholds")
	local _descriptor_7 = Test(BreakpointProviderMountValidation, "breakpointsProp", {
		value = BreakpointProviderMountValidation.breakpointsProp,
	})
	if _descriptor_7 then
		BreakpointProviderMountValidation.breakpointsProp = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(BreakpointProviderMountValidation, "breakpointsProp", {
		value = BreakpointProviderMountValidation.breakpointsProp,
	})
	if _descriptor_8 then
		BreakpointProviderMountValidation.breakpointsProp = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(BreakpointProviderMountValidation, "breakpointsProp", {
		value = BreakpointProviderMountValidation.breakpointsProp,
	})
	if _descriptor_9 then
		BreakpointProviderMountValidation.breakpointsProp = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Resizing within a breakpoint leaves consumers alone, crossing a threshold re-renders them once")
	local _descriptor_10 = Test(BreakpointProviderMountValidation, "rerendersOnCrossing", {
		value = BreakpointProviderMountValidation.rerendersOnCrossing,
	})
	if _descriptor_10 then
		BreakpointProviderMountValidation.rerendersOnCrossing = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(BreakpointProviderMountValidation, "rerendersOnCrossing", {
		value = BreakpointProviderMountValidation.rerendersOnCrossing,
	})
	if _descriptor_11 then
		BreakpointProviderMountValidation.rerendersOnCrossing = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(BreakpointProviderMountValidation, "rerendersOnCrossing", {
		value = BreakpointProviderMountValidation.rerendersOnCrossing,
	})
	if _descriptor_12 then
		BreakpointProviderMountValidation.rerendersOnCrossing = _descriptor_12.value
	end
	BreakpointProviderMountValidation = Tag("Studio")(BreakpointProviderMountValidation) or BreakpointProviderMountValidation
end
return BreakpointProviderMountValidation
