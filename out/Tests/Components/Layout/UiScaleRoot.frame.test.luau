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
local UiScaleRoot = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "UiScaleRoot").UiScaleRoot
local Tooltip = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Tooltip").Tooltip
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertCenteredIn = _layout.assertCenteredIn
local findDescendant = _layout.findDescendant
local formatRect = _layout.formatRect
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local FAST_THEME = TS.import(script, script.Parent.Parent.Parent, "Helpers", "tooltip").FAST_THEME
local HOST_WIDTH = 600
local HOST_HEIGHT = 450
local function tooltip()
	return React.createElement(Tooltip, {
		content = "Scaled hint",
		placement = "Bottom",
		open = true,
	}, React.createElement("frame", {
		key = "ScaledTrigger",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = UDim2.fromOffset(150, 60),
	}))
end
local function app(placement, scale)
	if placement == "outside" then
		return React.createElement(ThemeProvider, {
			theme = FAST_THEME,
		}, React.createElement(OverlayProvider, nil, React.createElement(UiScaleRoot, {
			scale = scale,
		}, tooltip())))
	end
	if placement == "inside" then
		return React.createElement(ThemeProvider, {
			theme = FAST_THEME,
		}, React.createElement(UiScaleRoot, {
			scale = scale,
		}, React.createElement(OverlayProvider, nil, tooltip())))
	end
	return React.createElement(ThemeProvider, {
		theme = FAST_THEME,
	}, React.createElement(OverlayProvider, nil, tooltip()))
end
local function waitForAlignedPopup(host)
	local overlay = waitForGuiObject(host, "OverlayProvider")
	local trigger = waitForGuiObject(host, "ScaledTrigger")
	local popup = waitForGuiObject(overlay, "Tooltip")
	for attempt = 0, 59 do
		local popupRect = rect(popup)
		local triggerRect = rect(trigger)
		if popup.GroupTransparency < 1 and math.abs(popupRect.centerX - triggerRect.centerX) <= 1.5 and popupRect.top >= triggerRect.bottom - 1 then
			break
		end
		task.wait()
	end
	return {
		popup = popup,
		trigger = trigger,
		overlay = overlay,
	}
end
local function assertBelowAndCentered(popup, trigger, label)
	local popupRect = rect(popup)
	local triggerRect = rect(trigger)
	assertCenteredIn(popup, trigger, "x", 1.5, label)
	Assert["true"](Assert, popupRect.top >= triggerRect.bottom - 1, `{label}: expected the popup {formatRect(popupRect)} to sit below the trigger {formatRect(triggerRect)}`)
end
local UiScaleOverlayValidation
do
	UiScaleOverlayValidation = setmetatable({}, {
		__tostring = function()
			return "UiScaleOverlayValidation"
		end,
	})
	UiScaleOverlayValidation.__index = UiScaleOverlayValidation
	function UiScaleOverlayValidation.new(...)
		local self = setmetatable({}, UiScaleOverlayValidation)
		return self:constructor(...) or self
	end
	function UiScaleOverlayValidation:constructor()
	end
	function UiScaleOverlayValidation:wrapsOutsideRoot(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("outside", scale), function(mounted)
			local _binding_1 = waitForAlignedPopup(mounted.host)
			local popup = _binding_1.popup
			local overlay = _binding_1.overlay
			local wrapper = popup:FindFirstAncestor("UiScaleOverlay")
			Assert:notUndefined(wrapper, "Expected the popup to sit inside a UiScaleOverlay wrapper")
			Assert:equal(wrapper.Parent, overlay, "Expected the UiScaleOverlay wrapper directly under the overlay")
			local uiScale = findDescendant(wrapper, "UiScale")
			Assert:equal(uiScale.Parent, wrapper, "Expected the wrapper's own UiScale directly under it")
			Assert:equal(uiScale.Scale, scale, "Expected the wrapper to scale by the root's scale over the overlay's scale of 1")
		end)
	end
	function UiScaleOverlayValidation:alignsOutsideRoot(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("outside", scale), function(mounted)
			local _binding_1 = waitForAlignedPopup(mounted.host)
			local popup = _binding_1.popup
			local trigger = _binding_1.trigger
			Assert["true"](Assert, math.abs(trigger.AbsoluteSize.X - 100 * scale) <= 0.5, `Expected the trigger to render at {100 * scale}px on screen, got {trigger.AbsoluteSize.X}`)
			assertBelowAndCentered(popup, trigger, `outside root at {scale}`)
		end)
	end
	function UiScaleOverlayValidation:noWrapperInsideRoot(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("inside", scale), function(mounted)
			local _binding_1 = waitForAlignedPopup(mounted.host)
			local popup = _binding_1.popup
			local trigger = _binding_1.trigger
			settleFrames(2)
			Assert:undefined(mounted.host:FindFirstChild("UiScaleOverlay", true), "Expected no UiScaleOverlay inside the root")
			assertBelowAndCentered(popup, trigger, `inside root at {scale}`)
		end)
	end
	function UiScaleOverlayValidation:noWrapperWithoutRoot()
		withMounted(HOST_WIDTH, HOST_HEIGHT, app("none", 1), function(mounted)
			local _binding_1 = waitForAlignedPopup(mounted.host)
			local popup = _binding_1.popup
			local trigger = _binding_1.trigger
			local overlay = _binding_1.overlay
			settleFrames(2)
			Assert:undefined(mounted.host:FindFirstChild("UiScaleOverlay", true), "Expected no UiScaleOverlay without a root")
			Assert:undefined(popup:FindFirstAncestor("UiScaleOverlay"), "Expected the popup not to be wrapped")
			Assert["true"](Assert, popup:IsDescendantOf(overlay), "Expected the popup to be portalled into the overlay")
			assertBelowAndCentered(popup, trigger, "no root")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { 1.25 }, { 1.5 } })
	local _decorator_2 = DisplayName("With the OverlayProvider outside the root, the popup is wrapped in a UiScaleOverlay at the root's scale")
	local _descriptor = Test(UiScaleOverlayValidation, "wrapsOutsideRoot", {
		value = UiScaleOverlayValidation.wrapsOutsideRoot,
	})
	if _descriptor then
		UiScaleOverlayValidation.wrapsOutsideRoot = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(UiScaleOverlayValidation, "wrapsOutsideRoot", {
		value = UiScaleOverlayValidation.wrapsOutsideRoot,
	})
	if _descriptor_1 then
		UiScaleOverlayValidation.wrapsOutsideRoot = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(UiScaleOverlayValidation, "wrapsOutsideRoot", {
		value = UiScaleOverlayValidation.wrapsOutsideRoot,
	})
	if _descriptor_2 then
		UiScaleOverlayValidation.wrapsOutsideRoot = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(UiScaleOverlayValidation, "wrapsOutsideRoot", {
		value = UiScaleOverlayValidation.wrapsOutsideRoot,
	})
	if _descriptor_3 then
		UiScaleOverlayValidation.wrapsOutsideRoot = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = Each({ { 1.25 }, { 1.5 } })
	local _decorator_5 = DisplayName("With the OverlayProvider outside the root, the wrapped popup still lines up below and centred on its scaled trigger")
	local _descriptor_4 = Test(UiScaleOverlayValidation, "alignsOutsideRoot", {
		value = UiScaleOverlayValidation.alignsOutsideRoot,
	})
	if _descriptor_4 then
		UiScaleOverlayValidation.alignsOutsideRoot = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(UiScaleOverlayValidation, "alignsOutsideRoot", {
		value = UiScaleOverlayValidation.alignsOutsideRoot,
	})
	if _descriptor_5 then
		UiScaleOverlayValidation.alignsOutsideRoot = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(UiScaleOverlayValidation, "alignsOutsideRoot", {
		value = UiScaleOverlayValidation.alignsOutsideRoot,
	})
	if _descriptor_6 then
		UiScaleOverlayValidation.alignsOutsideRoot = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(UiScaleOverlayValidation, "alignsOutsideRoot", {
		value = UiScaleOverlayValidation.alignsOutsideRoot,
	})
	if _descriptor_7 then
		UiScaleOverlayValidation.alignsOutsideRoot = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { 1.25 }, { 1.5 } })
	local _decorator_8 = DisplayName("With the OverlayProvider inside the root, no UiScaleOverlay is rendered and the popup still lines up")
	local _descriptor_8 = Test(UiScaleOverlayValidation, "noWrapperInsideRoot", {
		value = UiScaleOverlayValidation.noWrapperInsideRoot,
	})
	if _descriptor_8 then
		UiScaleOverlayValidation.noWrapperInsideRoot = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_8(UiScaleOverlayValidation, "noWrapperInsideRoot", {
		value = UiScaleOverlayValidation.noWrapperInsideRoot,
	})
	if _descriptor_9 then
		UiScaleOverlayValidation.noWrapperInsideRoot = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(UiScaleOverlayValidation, "noWrapperInsideRoot", {
		value = UiScaleOverlayValidation.noWrapperInsideRoot,
	})
	if _descriptor_10 then
		UiScaleOverlayValidation.noWrapperInsideRoot = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(UiScaleOverlayValidation, "noWrapperInsideRoot", {
		value = UiScaleOverlayValidation.noWrapperInsideRoot,
	})
	if _descriptor_11 then
		UiScaleOverlayValidation.noWrapperInsideRoot = _descriptor_11.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("With no UiScaleRoot at all, the popup portals straight into the overlay without a wrapper")
	local _descriptor_12 = Test(UiScaleOverlayValidation, "noWrapperWithoutRoot", {
		value = UiScaleOverlayValidation.noWrapperWithoutRoot,
	})
	if _descriptor_12 then
		UiScaleOverlayValidation.noWrapperWithoutRoot = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_10(UiScaleOverlayValidation, "noWrapperWithoutRoot", {
		value = UiScaleOverlayValidation.noWrapperWithoutRoot,
	})
	if _descriptor_13 then
		UiScaleOverlayValidation.noWrapperWithoutRoot = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_9(UiScaleOverlayValidation, "noWrapperWithoutRoot", {
		value = UiScaleOverlayValidation.noWrapperWithoutRoot,
	})
	if _descriptor_14 then
		UiScaleOverlayValidation.noWrapperWithoutRoot = _descriptor_14.value
	end
	UiScaleOverlayValidation = Tag("Studio")(UiScaleOverlayValidation) or UiScaleOverlayValidation
end
return UiScaleOverlayValidation
