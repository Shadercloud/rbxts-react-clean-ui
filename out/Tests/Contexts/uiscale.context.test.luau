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
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
local _uiscale_context = TS.import(script, script.Parent.Parent.Parent, "Contexts", "uiscale.context")
local useDesignViewportSize = _uiscale_context.useDesignViewportSize
local useUiScale = _uiscale_context.useUiScale
local _layout = TS.import(script, script.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local settleFrames = _layout.settleFrames
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local EPSILON = 1e-6
local VIEWPORT_EPSILON = 0.01
local latestScale
local latestViewport
local function resetHarness()
	latestScale = nil
	latestViewport = nil
end
local function ScaleHarness()
	latestScale = useUiScale()
	latestViewport = useDesignViewportSize()
	return nil
end
local function cameraViewport()
	local camera = Workspace.CurrentCamera
	Assert:notUndefined(camera, "Expected Workspace.CurrentCamera to exist for useDesignViewportSize")
	return camera.ViewportSize
end
local function waitForScale(expected)
	return waitForLayout(function()
		return if latestScale ~= nil and math.abs(latestScale - expected) <= EPSILON then latestScale else nil
	end, `Timed out waiting for useUiScale to return {expected} (last value {latestScale})`)
end
local function waitForDesignViewport(scale)
	local viewport = cameraViewport()
	local _scale = scale
	local expected = viewport / _scale
	return waitForLayout(function()
		return if latestViewport ~= nil and math.abs(latestViewport.X - expected.X) <= VIEWPORT_EPSILON and math.abs(latestViewport.Y - expected.Y) <= VIEWPORT_EPSILON then latestViewport else nil
	end, `Timed out waiting for useDesignViewportSize to return ({expected.X}, {expected.Y}) at scale {scale} (last value {latestViewport})`)
end
local function scaled(scale)
	return React.createElement(UiScaleRoot, {
		scale = scale,
	}, React.createElement(ScaleHarness))
end
local UiScaleHookValidation
do
	UiScaleHookValidation = setmetatable({}, {
		__tostring = function()
			return "UiScaleHookValidation"
		end,
	})
	UiScaleHookValidation.__index = UiScaleHookValidation
	function UiScaleHookValidation.new(...)
		local self = setmetatable({}, UiScaleHookValidation)
		return self:constructor(...) or self
	end
	function UiScaleHookValidation:constructor()
	end
	function UiScaleHookValidation:defaultScale()
		resetHarness()
		withMounted(200, 200, React.createElement(ScaleHarness), function()
			waitForLayout(function()
				return latestScale
			end, "Timed out waiting for the harness to render")
			Assert:equal(latestScale, 1, "Expected useUiScale to default to 1 with no root")
		end)
	end
	function UiScaleHookValidation:rootScale(scale)
		resetHarness()
		withMounted(200, 200, scaled(scale), function()
			waitForScale(scale)
		end)
	end
	function UiScaleHookValidation:nestedMultiply(outer, inner, expected)
		resetHarness()
		local element = (React.createElement(UiScaleRoot, {
			scale = outer,
		}, React.createElement(UiScaleRoot, {
			name = "InnerRoot",
			scale = inner,
		}, React.createElement(ScaleHarness))))
		withMounted(200, 200, element, function()
			waitForScale(expected)
		end)
	end
	function UiScaleHookValidation:viewportUnscaled()
		resetHarness()
		withMounted(200, 200, React.createElement(ScaleHarness), function()
			waitForDesignViewport(1)
		end)
	end
	function UiScaleHookValidation:viewportDivided(scale)
		resetHarness()
		withMounted(200, 200, scaled(scale), function()
			waitForDesignViewport(scale)
		end)
	end
	function UiScaleHookValidation:viewportFollowsScale()
		resetHarness()
		withMounted(200, 200, scaled(1), function(mounted)
			waitForDesignViewport(1)
			mounted.update(scaled(1.5))
			waitForScale(1.5)
			waitForDesignViewport(1.5)
			mounted.update(scaled(1.25))
			waitForScale(1.25)
			waitForDesignViewport(1.25)
			settleFrames(2)
			waitForDesignViewport(1.25)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Outside any UiScaleRoot the effective scale is the context default of 1")
	local _descriptor = Test(UiScaleHookValidation, "defaultScale", {
		value = UiScaleHookValidation.defaultScale,
	})
	if _descriptor then
		UiScaleHookValidation.defaultScale = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(UiScaleHookValidation, "defaultScale", {
		value = UiScaleHookValidation.defaultScale,
	})
	if _descriptor_1 then
		UiScaleHookValidation.defaultScale = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(UiScaleHookValidation, "defaultScale", {
		value = UiScaleHookValidation.defaultScale,
	})
	if _descriptor_2 then
		UiScaleHookValidation.defaultScale = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { 1 }, { 1.25 }, { 1.5 } })
	local _decorator_4 = DisplayName("Inside a single UiScaleRoot the effective scale is that root's scale prop")
	local _descriptor_3 = Test(UiScaleHookValidation, "rootScale", {
		value = UiScaleHookValidation.rootScale,
	})
	if _descriptor_3 then
		UiScaleHookValidation.rootScale = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(UiScaleHookValidation, "rootScale", {
		value = UiScaleHookValidation.rootScale,
	})
	if _descriptor_4 then
		UiScaleHookValidation.rootScale = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(UiScaleHookValidation, "rootScale", {
		value = UiScaleHookValidation.rootScale,
	})
	if _descriptor_5 then
		UiScaleHookValidation.rootScale = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(UiScaleHookValidation, "rootScale", {
		value = UiScaleHookValidation.rootScale,
	})
	if _descriptor_6 then
		UiScaleHookValidation.rootScale = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { 1.25, 1.2, 1.5 }, { 1.5, 1, 1.5 }, { 2, 0.5, 1 } })
	local _decorator_7 = DisplayName("Nested roots publish the product of every scale above the caller")
	local _descriptor_7 = Test(UiScaleHookValidation, "nestedMultiply", {
		value = UiScaleHookValidation.nestedMultiply,
	})
	if _descriptor_7 then
		UiScaleHookValidation.nestedMultiply = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(UiScaleHookValidation, "nestedMultiply", {
		value = UiScaleHookValidation.nestedMultiply,
	})
	if _descriptor_8 then
		UiScaleHookValidation.nestedMultiply = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(UiScaleHookValidation, "nestedMultiply", {
		value = UiScaleHookValidation.nestedMultiply,
	})
	if _descriptor_9 then
		UiScaleHookValidation.nestedMultiply = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(UiScaleHookValidation, "nestedMultiply", {
		value = UiScaleHookValidation.nestedMultiply,
	})
	if _descriptor_10 then
		UiScaleHookValidation.nestedMultiply = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("With no root the design viewport size equals the camera's ViewportSize")
	local _descriptor_11 = Test(UiScaleHookValidation, "viewportUnscaled", {
		value = UiScaleHookValidation.viewportUnscaled,
	})
	if _descriptor_11 then
		UiScaleHookValidation.viewportUnscaled = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(UiScaleHookValidation, "viewportUnscaled", {
		value = UiScaleHookValidation.viewportUnscaled,
	})
	if _descriptor_12 then
		UiScaleHookValidation.viewportUnscaled = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(UiScaleHookValidation, "viewportUnscaled", {
		value = UiScaleHookValidation.viewportUnscaled,
	})
	if _descriptor_13 then
		UiScaleHookValidation.viewportUnscaled = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = Each({ { 1.25 }, { 1.5 } })
	local _decorator_12 = DisplayName("Inside a root the design viewport size is the camera's ViewportSize divided by the effective scale")
	local _descriptor_14 = Test(UiScaleHookValidation, "viewportDivided", {
		value = UiScaleHookValidation.viewportDivided,
	})
	if _descriptor_14 then
		UiScaleHookValidation.viewportDivided = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_12(UiScaleHookValidation, "viewportDivided", {
		value = UiScaleHookValidation.viewportDivided,
	})
	if _descriptor_15 then
		UiScaleHookValidation.viewportDivided = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(UiScaleHookValidation, "viewportDivided", {
		value = UiScaleHookValidation.viewportDivided,
	})
	if _descriptor_16 then
		UiScaleHookValidation.viewportDivided = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(UiScaleHookValidation, "viewportDivided", {
		value = UiScaleHookValidation.viewportDivided,
	})
	if _descriptor_17 then
		UiScaleHookValidation.viewportDivided = _descriptor_17.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("Changing the root's scale prop re-renders consumers with the new design viewport size")
	local _descriptor_18 = Test(UiScaleHookValidation, "viewportFollowsScale", {
		value = UiScaleHookValidation.viewportFollowsScale,
	})
	if _descriptor_18 then
		UiScaleHookValidation.viewportFollowsScale = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_14(UiScaleHookValidation, "viewportFollowsScale", {
		value = UiScaleHookValidation.viewportFollowsScale,
	})
	if _descriptor_19 then
		UiScaleHookValidation.viewportFollowsScale = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_13(UiScaleHookValidation, "viewportFollowsScale", {
		value = UiScaleHookValidation.viewportFollowsScale,
	})
	if _descriptor_20 then
		UiScaleHookValidation.viewportFollowsScale = _descriptor_20.value
	end
	UiScaleHookValidation = Tag("Studio")(UiScaleHookValidation) or UiScaleHookValidation
end
return UiScaleHookValidation
