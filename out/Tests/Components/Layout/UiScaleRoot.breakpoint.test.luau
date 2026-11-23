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
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
local BreakpointProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "BreakpointProvider").BreakpointProvider
local Row = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Row").Row
local Column = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Column").Column
local Grid = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Grid").Grid
local Fieldset = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Fieldset").Fieldset
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _breakpoint_context = TS.import(script, script.Parent.Parent.Parent.Parent, "Contexts", "breakpoint.context")
local BreakpointContext = _breakpoint_context.BreakpointContext
local useBreakpoint = _breakpoint_context.useBreakpoint
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers", "breakpoint.helper").BreakpointHelper
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local SCREEN_WIDTH = 420
local HOST_HEIGHT = 300
local DEFAULT_GAP = 12
local latestBreakpoint
local latestContext
local function resetHarness()
	latestBreakpoint = nil
	latestContext = nil
end
local function BreakpointHarness()
	latestBreakpoint = useBreakpoint()
	latestContext = React.useContext(BreakpointContext)
	return nil
end
local function scaled(scale, children)
	return React.createElement(UiScaleRoot, {
		scale = scale,
	}, children)
end
local function assertFixturePredicts(scale, expected)
	local predicted = BreakpointHelper:getBreakpoint(SCREEN_WIDTH / scale, DefaultTheme.breakpoints)
	Assert:equal(predicted, expected, `Fixture out of date with DefaultTheme.breakpoints: {SCREEN_WIDTH}px / {scale} resolves to "{predicted}", not "{expected}"`)
end
local function screenBreakpoint()
	return BreakpointHelper:getBreakpoint(SCREEN_WIDTH, DefaultTheme.breakpoints)
end
local function assertNotRoomier(resolved, scale)
	local unscaled = screenBreakpoint()
	Assert["true"](Assert, BreakpointHelper:compare(resolved, "<=", unscaled), `Expected "{resolved}" at scale {scale} not to be roomier than the unscaled "{unscaled}"`)
	if scale > 1 then
		Assert["true"](Assert, BreakpointHelper:compare(resolved, "<", unscaled), `Expected "{resolved}" at scale {scale} to be narrower than the unscaled "{unscaled}"`)
	end
end
local function waitForBreakpoint(expected)
	waitForLayout(function()
		return if latestBreakpoint == expected then true else nil
	end, `Timed out waiting for useBreakpoint to return "{expected}" (last value "{latestBreakpoint}")`)
end
local function waitForScreenWidth(host, name)
	return waitForGuiObject(host, name, function(gui)
		return math.abs(gui.AbsoluteSize.X - SCREEN_WIDTH) <= 1
	end, `Timed out waiting for {name} to span the {SCREEN_WIDTH}px host on screen`)
end
local function expectedColumnWidth(rowWidth, span, gap)
	local fraction = math.floor((span / 12) * 1000) / 1000
	return fraction * rowWidth + (fraction - 1) * gap
end
local function viewportWidth()
	local camera = Workspace.CurrentCamera
	Assert:notUndefined(camera, "Expected Workspace.CurrentCamera to exist for the viewport fallback")
	return camera.ViewportSize.X
end
local function fieldset(scale)
	return scaled(scale, React.createElement("frame", {
		key = "Form",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(VStack, nil, React.createElement(Fieldset, {
		wrap = "md",
	}, React.createElement(Fieldset.Label, nil, React.createElement(Text, {
		text = "Label",
	})), React.createElement(Fieldset.Control, nil, React.createElement("frame", {
		key = "ControlContent",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(120, 32),
	}))))))
end
local UiScaleBreakpointValidation
do
	UiScaleBreakpointValidation = setmetatable({}, {
		__tostring = function()
			return "UiScaleBreakpointValidation"
		end,
	})
	UiScaleBreakpointValidation.__index = UiScaleBreakpointValidation
	function UiScaleBreakpointValidation.new(...)
		local self = setmetatable({}, UiScaleBreakpointValidation)
		return self:constructor(...) or self
	end
	function UiScaleBreakpointValidation:constructor()
	end
	function UiScaleBreakpointValidation:providerDesignWidth(scale, expected)
		assertFixturePredicts(scale, expected)
		resetHarness()
		local element = scaled(scale, React.createElement(BreakpointProvider, nil, React.createElement(BreakpointHarness)))
		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, function(mounted)
			waitForScreenWidth(mounted.host, "BreakpointProvider")
			settleFrames(2)
			waitForBreakpoint(expected)
			Assert:notUndefined(latestContext, "Expected the harness to read a BreakpointContext value")
			Assert["true"](Assert, math.abs(latestContext.width - SCREEN_WIDTH / scale) <= 1, `Expected the published width {latestContext.width} to be the design width {SCREEN_WIDTH / scale}`)
			assertNotRoomier(latestBreakpoint, scale)
		end)
	end
	function UiScaleBreakpointValidation:providerRescales()
		resetHarness()
		local element = function(scale)
			return scaled(scale, React.createElement(BreakpointProvider, nil, React.createElement(BreakpointHarness)))
		end
		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element(1), function(mounted)
			waitForScreenWidth(mounted.host, "BreakpointProvider")
			waitForBreakpoint("lg")
			mounted.update(element(1.5))
			waitForBreakpoint("sm")
			settleFrames(3)
			Assert:equal(latestBreakpoint, "sm", "Expected the provider to stay at sm after rescaling to 1.5")
			mounted.update(element(1))
			waitForBreakpoint("lg")
		end)
	end
	function UiScaleBreakpointValidation:viewportDesignWidth(scale, expected)
		resetHarness()
		local width = viewportWidth()
		local _object = table.clone(DefaultTheme)
		setmetatable(_object, nil)
		_object.breakpoints = {
			xs = 0,
			sm = width / 1.5 - 1,
			md = width / 1.25 - 1,
			lg = width - 1,
			xl = width + 1,
		}
		local theme = _object
		Assert:equal(BreakpointHelper:getBreakpoint(width / scale, theme.breakpoints), expected, `Fixture thresholds do not predict "{expected}" for viewport width {width} at scale {scale}`)
		local element = scaled(scale, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(BreakpointHarness)))
		withMounted(100, HOST_HEIGHT, element, function()
			waitForBreakpoint(expected)
			settleFrames(2)
			Assert:equal(latestBreakpoint, expected, `Expected the viewport fallback to stay at "{expected}"`)
		end)
	end
	function UiScaleBreakpointValidation:rowDesignWidth(scale, breakpoint, span)
		assertFixturePredicts(scale, breakpoint)
		local element = scaled(scale, React.createElement(Row, nil, React.createElement(Column, {
			name = "Responsive",
			span = {
				xs = 12,
				sm = 9,
				md = 6,
				lg = 4,
			},
		}, React.createElement("frame", {
			key = "ResponsiveContent",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 40),
		}))))
		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, function(mounted)
			local row = waitForScreenWidth(mounted.host, "Row")
			local expected = scale * expectedColumnWidth(SCREEN_WIDTH / scale, span, DEFAULT_GAP)
			local col = waitForGuiObject(row, "Responsive", function(gui)
				return math.abs(gui.AbsoluteSize.X - expected) <= 1.5
			end, `Timed out waiting for the Column to resolve span {span} ({expected}px on screen) at scale {scale}`)
			settleFrames(2)
			assertSizeApprox(col, expected, nil, 1.5, `span {span} at scale {scale}`)
		end)
	end
	function UiScaleBreakpointValidation:gridDesignWidth(scale, breakpoint, cols)
		assertFixturePredicts(scale, breakpoint)
		local element = scaled(scale, React.createElement(Grid, {
			cols = {
				xs = 1,
				sm = 2,
				md = 3,
				lg = 4,
			},
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		withMounted(SCREEN_WIDTH, HOST_HEIGHT, element, function(mounted)
			waitForScreenWidth(mounted.host, "Grid")
			waitForDescendant(mounted.host, "GridLayout", function(layout)
				return layout.FillDirectionMaxCells == cols
			end, `Timed out waiting for the Grid to lock {cols} columns at scale {scale}`)
			settleFrames(3)
			local layout = waitForDescendant(mounted.host, "GridLayout", function()
				return true
			end)
			Assert:equal(layout.FillDirectionMaxCells, cols, `Expected the Grid to stay at {cols} columns at scale {scale}`)
		end)
	end
	function UiScaleBreakpointValidation:fieldsetDesignWidth(scale, breakpoint, expectedWraps)
		assertFixturePredicts(scale, breakpoint)
		withMounted(SCREEN_WIDTH, HOST_HEIGHT, fieldset(1), function(mounted)
			local root = waitForScreenWidth(mounted.host, "Fieldset")
			waitForDescendant(root, "HStack", function(layout)
				return layout.Wraps == false
			end, "Timed out waiting for the unscaled Fieldset to measure lg and stop wrapping")
			mounted.update(fieldset(scale))
			local layout = waitForDescendant(root, "HStack", function(candidate)
				return candidate.Wraps == expectedWraps
			end, `Timed out waiting for the Fieldset's UIListLayout to report Wraps={expectedWraps} at scale {scale}`)
			settleFrames(3)
			Assert:equal(layout.Wraps, expectedWraps, `Expected Wraps={expectedWraps} to hold at scale {scale}`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { 1, "lg" }, { 1.25, "md" }, { 1.5, "sm" } })
	local _decorator_2 = DisplayName("BreakpointProvider resolves a 420px-wide screen area against its design width, screen width / scale")
	local _descriptor = Test(UiScaleBreakpointValidation, "providerDesignWidth", {
		value = UiScaleBreakpointValidation.providerDesignWidth,
	})
	if _descriptor then
		UiScaleBreakpointValidation.providerDesignWidth = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(UiScaleBreakpointValidation, "providerDesignWidth", {
		value = UiScaleBreakpointValidation.providerDesignWidth,
	})
	if _descriptor_1 then
		UiScaleBreakpointValidation.providerDesignWidth = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(UiScaleBreakpointValidation, "providerDesignWidth", {
		value = UiScaleBreakpointValidation.providerDesignWidth,
	})
	if _descriptor_2 then
		UiScaleBreakpointValidation.providerDesignWidth = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(UiScaleBreakpointValidation, "providerDesignWidth", {
		value = UiScaleBreakpointValidation.providerDesignWidth,
	})
	if _descriptor_3 then
		UiScaleBreakpointValidation.providerDesignWidth = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Changing the root's scale re-resolves the provider's breakpoint without the screen width changing")
	local _descriptor_4 = Test(UiScaleBreakpointValidation, "providerRescales", {
		value = UiScaleBreakpointValidation.providerRescales,
	})
	if _descriptor_4 then
		UiScaleBreakpointValidation.providerRescales = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(UiScaleBreakpointValidation, "providerRescales", {
		value = UiScaleBreakpointValidation.providerRescales,
	})
	if _descriptor_5 then
		UiScaleBreakpointValidation.providerRescales = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(UiScaleBreakpointValidation, "providerRescales", {
		value = UiScaleBreakpointValidation.providerRescales,
	})
	if _descriptor_6 then
		UiScaleBreakpointValidation.providerRescales = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { 1, "lg" }, { 1.25, "md" }, { 1.5, "sm" } })
	local _decorator_7 = DisplayName("Without a provider, useBreakpoint resolves the camera viewport width divided by the effective scale")
	local _descriptor_7 = Test(UiScaleBreakpointValidation, "viewportDesignWidth", {
		value = UiScaleBreakpointValidation.viewportDesignWidth,
	})
	if _descriptor_7 then
		UiScaleBreakpointValidation.viewportDesignWidth = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(UiScaleBreakpointValidation, "viewportDesignWidth", {
		value = UiScaleBreakpointValidation.viewportDesignWidth,
	})
	if _descriptor_8 then
		UiScaleBreakpointValidation.viewportDesignWidth = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(UiScaleBreakpointValidation, "viewportDesignWidth", {
		value = UiScaleBreakpointValidation.viewportDesignWidth,
	})
	if _descriptor_9 then
		UiScaleBreakpointValidation.viewportDesignWidth = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(UiScaleBreakpointValidation, "viewportDesignWidth", {
		value = UiScaleBreakpointValidation.viewportDesignWidth,
	})
	if _descriptor_10 then
		UiScaleBreakpointValidation.viewportDesignWidth = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = Each({ { 1, "lg", 4 }, { 1.25, "md", 6 }, { 1.5, "sm", 9 } })
	local _decorator_10 = DisplayName("A responsive Column span follows the Row's design-pixel breakpoint, giving fewer columns at higher scales")
	local _descriptor_11 = Test(UiScaleBreakpointValidation, "rowDesignWidth", {
		value = UiScaleBreakpointValidation.rowDesignWidth,
	})
	if _descriptor_11 then
		UiScaleBreakpointValidation.rowDesignWidth = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_10(UiScaleBreakpointValidation, "rowDesignWidth", {
		value = UiScaleBreakpointValidation.rowDesignWidth,
	})
	if _descriptor_12 then
		UiScaleBreakpointValidation.rowDesignWidth = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(UiScaleBreakpointValidation, "rowDesignWidth", {
		value = UiScaleBreakpointValidation.rowDesignWidth,
	})
	if _descriptor_13 then
		UiScaleBreakpointValidation.rowDesignWidth = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(UiScaleBreakpointValidation, "rowDesignWidth", {
		value = UiScaleBreakpointValidation.rowDesignWidth,
	})
	if _descriptor_14 then
		UiScaleBreakpointValidation.rowDesignWidth = _descriptor_14.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = Each({ { 1, "lg", 4 }, { 1.25, "md", 3 }, { 1.5, "sm", 2 } })
	local _decorator_13 = DisplayName("Responsive Grid cols follow the Grid's design-pixel breakpoint, locking fewer columns at higher scales")
	local _descriptor_15 = Test(UiScaleBreakpointValidation, "gridDesignWidth", {
		value = UiScaleBreakpointValidation.gridDesignWidth,
	})
	if _descriptor_15 then
		UiScaleBreakpointValidation.gridDesignWidth = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_13(UiScaleBreakpointValidation, "gridDesignWidth", {
		value = UiScaleBreakpointValidation.gridDesignWidth,
	})
	if _descriptor_16 then
		UiScaleBreakpointValidation.gridDesignWidth = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(UiScaleBreakpointValidation, "gridDesignWidth", {
		value = UiScaleBreakpointValidation.gridDesignWidth,
	})
	if _descriptor_17 then
		UiScaleBreakpointValidation.gridDesignWidth = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(UiScaleBreakpointValidation, "gridDesignWidth", {
		value = UiScaleBreakpointValidation.gridDesignWidth,
	})
	if _descriptor_18 then
		UiScaleBreakpointValidation.gridDesignWidth = _descriptor_18.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = Each({ { 1, "lg", false }, { 1.25, "md", true }, { 1.5, "sm", true } })
	local _decorator_16 = DisplayName("A Fieldset set to wrap at md starts wrapping once the root's scale brings its design width to md or below")
	local _descriptor_19 = Test(UiScaleBreakpointValidation, "fieldsetDesignWidth", {
		value = UiScaleBreakpointValidation.fieldsetDesignWidth,
	})
	if _descriptor_19 then
		UiScaleBreakpointValidation.fieldsetDesignWidth = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_16(UiScaleBreakpointValidation, "fieldsetDesignWidth", {
		value = UiScaleBreakpointValidation.fieldsetDesignWidth,
	})
	if _descriptor_20 then
		UiScaleBreakpointValidation.fieldsetDesignWidth = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(UiScaleBreakpointValidation, "fieldsetDesignWidth", {
		value = UiScaleBreakpointValidation.fieldsetDesignWidth,
	})
	if _descriptor_21 then
		UiScaleBreakpointValidation.fieldsetDesignWidth = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(UiScaleBreakpointValidation, "fieldsetDesignWidth", {
		value = UiScaleBreakpointValidation.fieldsetDesignWidth,
	})
	if _descriptor_22 then
		UiScaleBreakpointValidation.fieldsetDesignWidth = _descriptor_22.value
	end
	UiScaleBreakpointValidation = Tag("Studio")(UiScaleBreakpointValidation) or UiScaleBreakpointValidation
end
return UiScaleBreakpointValidation
