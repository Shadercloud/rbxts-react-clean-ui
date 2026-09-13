-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
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
local BreakpointProvider = TS.import(script, script.Parent.Parent.Parent, "Components", "Layout", "BreakpointProvider").BreakpointProvider
local _breakpoint_context = TS.import(script, script.Parent.Parent.Parent, "Contexts", "breakpoint.context")
local useBreakpoint = _breakpoint_context.useBreakpoint
local useBreakpointValue = _breakpoint_context.useBreakpointValue
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "breakpoint.helper").BreakpointHelper
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local latestBreakpoint
local latestValue
local harnessRendered = false
local function resetHarness()
	latestBreakpoint = nil
	latestValue = nil
	harnessRendered = false
end
local function BreakpointHarness()
	latestBreakpoint = useBreakpoint()
	harnessRendered = true
	return nil
end
local function ValueHarness(props)
	latestBreakpoint = useBreakpoint()
	latestValue = useBreakpointValue(props.value)
	harnessRendered = true
	return nil
end
local function viewportWidth()
	local camera = Workspace.CurrentCamera
	Assert:notUndefined(camera, "Expected Workspace.CurrentCamera to exist for the viewport fallback")
	return camera.ViewportSize.X
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
local BreakpointHookValidation
do
	BreakpointHookValidation = setmetatable({}, {
		__tostring = function()
			return "BreakpointHookValidation"
		end,
	})
	BreakpointHookValidation.__index = BreakpointHookValidation
	function BreakpointHookValidation.new(...)
		local self = setmetatable({}, BreakpointHookValidation)
		return self:constructor(...) or self
	end
	function BreakpointHookValidation:constructor()
	end
	function BreakpointHookValidation:viewportDefaultTheme()
		resetHarness()
		local expected = BreakpointHelper:getBreakpoint(viewportWidth(), DefaultTheme.breakpoints)
		withMounted(50, 300, React.createElement(BreakpointHarness), function()
			waitForLayout(function()
				return if harnessRendered then true else nil
			end, "Timed out waiting for the harness to render")
			settle(2)
			Assert:equal(latestBreakpoint, expected, `Expected the viewport breakpoint for width {viewportWidth()}`)
		end)
	end
	function BreakpointHookValidation:viewportIgnoresContainer()
		resetHarness()
		local width = viewportWidth()
		local _object = table.clone(DefaultTheme)
		setmetatable(_object, nil)
		_object.breakpoints = {
			xs = 0,
			sm = 1,
			md = width,
			lg = width + 1,
			xl = width + 2,
		}
		local theme = _object
		local element = (React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(BreakpointHarness)))
		withMounted(100, 300, element, function()
			waitForBreakpoint("md")
			settle(2)
			Assert:equal(latestBreakpoint, "md", "Expected the viewport width to land exactly on the md threshold")
		end)
	end
	function BreakpointHookValidation:valueFallsBack(width, breakpoint, expected)
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(ValueHarness, {
			value = {
				xs = "xs-value",
				md = "md-value",
			},
		})))
		withMounted(width, 300, element, function(mounted)
			waitForGuiObject(mounted.host, "BreakpointProvider", function(frame)
				return frame.AbsoluteSize.X == width
			end)
			settle(2)
			waitForBreakpoint(breakpoint)
			Assert:equal(latestValue, expected, `Expected {breakpoint} to resolve to "{expected}"`)
		end)
	end
	function BreakpointHookValidation:valueUndefinedBelow()
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(ValueHarness, {
			value = {
				lg = "lg-value",
			},
		})))
		withMounted(250, 300, element, function()
			waitForBreakpoint("sm")
			settle(2)
			Assert:undefined(latestValue, "Expected no value when only lg is set and the breakpoint is sm")
		end)
	end
	function BreakpointHookValidation:plainValue()
		resetHarness()
		local element = (React.createElement(BreakpointProvider, nil, React.createElement(ValueHarness, {
			value = "plain",
		})))
		withMounted(450, 300, element, function()
			waitForBreakpoint("lg")
			Assert:equal(latestValue, "plain", "Expected a non-object value to pass straight through")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without a provider the hook resolves the camera viewport width against the default theme breakpoints")
	local _descriptor = Test(BreakpointHookValidation, "viewportDefaultTheme", {
		value = BreakpointHookValidation.viewportDefaultTheme,
	})
	if _descriptor then
		BreakpointHookValidation.viewportDefaultTheme = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BreakpointHookValidation, "viewportDefaultTheme", {
		value = BreakpointHookValidation.viewportDefaultTheme,
	})
	if _descriptor_1 then
		BreakpointHookValidation.viewportDefaultTheme = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BreakpointHookValidation, "viewportDefaultTheme", {
		value = BreakpointHookValidation.viewportDefaultTheme,
	})
	if _descriptor_2 then
		BreakpointHookValidation.viewportDefaultTheme = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Without a provider the hook uses the viewport and theme thresholds, not the width of its container")
	local _descriptor_3 = Test(BreakpointHookValidation, "viewportIgnoresContainer", {
		value = BreakpointHookValidation.viewportIgnoresContainer,
	})
	if _descriptor_3 then
		BreakpointHookValidation.viewportIgnoresContainer = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(BreakpointHookValidation, "viewportIgnoresContainer", {
		value = BreakpointHookValidation.viewportIgnoresContainer,
	})
	if _descriptor_4 then
		BreakpointHookValidation.viewportIgnoresContainer = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(BreakpointHookValidation, "viewportIgnoresContainer", {
		value = BreakpointHookValidation.viewportIgnoresContainer,
	})
	if _descriptor_5 then
		BreakpointHookValidation.viewportIgnoresContainer = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A breakpoint object falls back to the nearest set entry at or below the current breakpoint")
	local _decorator_6 = Each({ { 450, "lg", "md-value" }, { 350, "md", "md-value" }, { 250, "sm", "xs-value" }, { 50, "xs", "xs-value" } })
	local _descriptor_6 = Test(BreakpointHookValidation, "valueFallsBack", {
		value = BreakpointHookValidation.valueFallsBack,
	})
	if _descriptor_6 then
		BreakpointHookValidation.valueFallsBack = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(BreakpointHookValidation, "valueFallsBack", {
		value = BreakpointHookValidation.valueFallsBack,
	})
	if _descriptor_7 then
		BreakpointHookValidation.valueFallsBack = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(BreakpointHookValidation, "valueFallsBack", {
		value = BreakpointHookValidation.valueFallsBack,
	})
	if _descriptor_8 then
		BreakpointHookValidation.valueFallsBack = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(BreakpointHookValidation, "valueFallsBack", {
		value = BreakpointHookValidation.valueFallsBack,
	})
	if _descriptor_9 then
		BreakpointHookValidation.valueFallsBack = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("A breakpoint object with nothing set at or below the current breakpoint resolves to undefined")
	local _descriptor_10 = Test(BreakpointHookValidation, "valueUndefinedBelow", {
		value = BreakpointHookValidation.valueUndefinedBelow,
	})
	if _descriptor_10 then
		BreakpointHookValidation.valueUndefinedBelow = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(BreakpointHookValidation, "valueUndefinedBelow", {
		value = BreakpointHookValidation.valueUndefinedBelow,
	})
	if _descriptor_11 then
		BreakpointHookValidation.valueUndefinedBelow = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(BreakpointHookValidation, "valueUndefinedBelow", {
		value = BreakpointHookValidation.valueUndefinedBelow,
	})
	if _descriptor_12 then
		BreakpointHookValidation.valueUndefinedBelow = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("A plain value is returned unchanged at any breakpoint")
	local _descriptor_13 = Test(BreakpointHookValidation, "plainValue", {
		value = BreakpointHookValidation.plainValue,
	})
	if _descriptor_13 then
		BreakpointHookValidation.plainValue = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(BreakpointHookValidation, "plainValue", {
		value = BreakpointHookValidation.plainValue,
	})
	if _descriptor_14 then
		BreakpointHookValidation.plainValue = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(BreakpointHookValidation, "plainValue", {
		value = BreakpointHookValidation.plainValue,
	})
	if _descriptor_15 then
		BreakpointHookValidation.plainValue = _descriptor_15.value
	end
	BreakpointHookValidation = Tag("Studio")(BreakpointHookValidation) or BreakpointHookValidation
end
return BreakpointHookValidation
