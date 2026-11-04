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
local Tooltip = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Tooltip").Tooltip
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertCenteredIn = _layout.assertCenteredIn
local assertContained = _layout.assertContained
local findDescendant = _layout.findDescendant
local formatRect = _layout.formatRect
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local findHostFiber = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").findHostFiber
local CONTENT = "Helpful hint"
local hoverEvents
local HoverTarget = React.forwardRef(function(props, ref)
	hoverEvents = props.Event
	return React.createElement("frame", {
		key = "HoverTarget",
		ref = ref,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = UDim2.fromOffset(150, 130),
		Event = props.Event,
	})
end)
local function tooltipApp(placement, options)
	if options == nil then
		options = {}
	end
	return React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		content = CONTENT,
		placement = placement,
		disabled = options.disabled,
		open = options.open,
	}, React.createElement(HoverTarget)))
end
local function waitForTarget(host)
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, "HoverTarget")
end
local function hover(target)
	local events = waitForLayout(function()
		return hoverEvents
	end, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget")
	Assert:notUndefined(events.MouseEnter, "Expected Tooltip to inject a MouseEnter handler")
	events.MouseEnter(target, 0, 0)
end
local function unhover(target)
	local events = waitForLayout(function()
		return hoverEvents
	end, "Timed out waiting for Tooltip to inject hover handlers into HoverTarget")
	Assert:notUndefined(events.MouseLeave, "Expected Tooltip to inject a MouseLeave handler")
	events.MouseLeave(target, 0, 0)
end
local function nativeApp()
	return React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		content = CONTENT,
	}, React.createElement("frame", {
		key = "NativeTarget",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(100, 40),
		Position = UDim2.fromOffset(150, 130),
	})))
end
local function waitForNativeTarget(host)
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, "NativeTarget", nil, "Timed out waiting for the native <frame> inside Tooltip to mount - the tree failed to render (see the Studio output for the React error)")
end
local function edgeApp(placement, x, y, width)
	if width == nil then
		width = 100
	end
	return React.createElement(OverlayProvider, nil, React.createElement(Tooltip, {
		content = CONTENT,
		placement = placement,
		open = true,
	}, React.createElement("frame", {
		key = "EdgeTarget",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(width, 40),
		Position = UDim2.fromOffset(x, y),
	})))
end
local function waitForPlacedPopup(host, placed)
	local overlay = waitForGuiObject(host, "OverlayProvider")
	local target = waitForGuiObject(host, "EdgeTarget")
	local popup = waitForGuiObject(overlay, "Tooltip")
	for attempt = 0, 59 do
		if popup.GroupTransparency < 1 and placed(rect(popup), rect(target)) then
			break
		end
		task.wait()
	end
	return {
		popup = popup,
		target = target,
		overlay = overlay,
		popupRect = rect(popup),
		targetRect = rect(target),
	}
end
local function assertNoPopup(host, message)
	settleFrames(10)
	Assert:undefined(host:FindFirstChild("Tooltip", true), message)
end
local TooltipMountValidation
do
	TooltipMountValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipMountValidation"
		end,
	})
	TooltipMountValidation.__index = TooltipMountValidation
	function TooltipMountValidation.new(...)
		local self = setmetatable({}, TooltipMountValidation)
		return self:constructor(...) or self
	end
	function TooltipMountValidation:constructor()
	end
	function TooltipMountValidation:hiddenUntilHover()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(), function(mounted)
			waitForTarget(mounted.host)
			task.wait()
			Assert:undefined(mounted.host:FindFirstChild("Tooltip", true), "Expected no Tooltip popup before hovering")
		end)
	end
	function TooltipMountValidation:showsOnHover(placement)
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(placement), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			local overlay = findDescendant(mounted.host, "OverlayProvider")
			local tooltip = waitForGuiObject(overlay, "Tooltip")
			local content = waitForGuiObject(tooltip, "Content")
			local text = findDescendant(content, "TooltipText")
			Assert:equal(text.Text, CONTENT, "Expected a string content prop to render as TooltipText")
			assertContained(text, content, `{placement} tooltip text`)
			assertContained(tooltip, overlay, `{placement} tooltip vs overlay`)
			assertCenteredIn(tooltip, target, "x", 1, `{placement} tooltip`)
			local tooltipRect = rect(tooltip)
			local targetRect = rect(target)
			if placement == "Top" then
				Assert["true"](Assert, tooltipRect.bottom <= targetRect.top + 1, `Expected a Top tooltip (bottom={tooltipRect.bottom}) to sit above the target (top={targetRect.top})`)
			else
				Assert["true"](Assert, tooltipRect.top >= targetRect.bottom - 1, `Expected a Bottom tooltip (top={tooltipRect.top}) to sit below the target (bottom={targetRect.bottom})`)
			end
		end)
	end
	function TooltipMountValidation:hidesAfterLeave()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			waitForGuiObject(mounted.host, "Tooltip")
			unhover(target)
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipMountValidation:disabledNoPopup()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(nil, {
			disabled = true,
		}), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			assertNoPopup(mounted.host, "Expected no Tooltip popup while disabled")
		end)
	end
	function TooltipMountValidation:disabledKeepsInstance()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(nil, {
			disabled = false,
		}), function(mounted)
			local target = waitForTarget(mounted.host)
			mounted.update(tooltipApp(nil, {
				disabled = true,
			}))
			settleFrames(2)
			Assert:equal(findDescendant(mounted.host, "HoverTarget"), target, "Expected disabling not to remount the child")
			local _result = hoverEvents
			if _result ~= nil then
				_result = _result.MouseEnter
			end
			Assert:notUndefined(_result, "Expected the child to keep its MouseEnter handler while disabled")
			mounted.update(tooltipApp(nil, {
				disabled = false,
			}))
			settleFrames(2)
			Assert:equal(findDescendant(mounted.host, "HoverTarget"), target, "Expected re-enabling not to remount the child")
			hover(target)
			waitForGuiObject(mounted.host, "Tooltip")
		end)
	end
	function TooltipMountValidation:disableHidesOpen()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			waitForGuiObject(mounted.host, "Tooltip")
			mounted.update(tooltipApp(nil, {
				disabled = true,
			}))
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipMountValidation:controlledOpen()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(nil, {
			open = true,
		}), function(mounted)
			local target = waitForTarget(mounted.host)
			local tooltip = waitForGuiObject(mounted.host, "Tooltip")
			assertCenteredIn(tooltip, target, "x", 1, "controlled tooltip")
			unhover(target)
			settleFrames(20)
			Assert:notUndefined(mounted.host:FindFirstChild("Tooltip", true), "Expected MouseLeave not to close a controlled open Tooltip")
			mounted.update(tooltipApp(nil, {
				open = false,
			}))
			waitForRemoval(mounted.host, "Tooltip")
		end)
	end
	function TooltipMountValidation:controlledClosedIgnoresHover()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(nil, {
			open = false,
		}), function(mounted)
			local target = waitForTarget(mounted.host)
			hover(target)
			assertNoPopup(mounted.host, "Expected hover not to open a Tooltip controlled with open={false}")
		end)
	end
	function TooltipMountValidation:disabledOverridesOpen()
		hoverEvents = nil
		withMounted(400, 300, tooltipApp(nil, {
			open = true,
			disabled = true,
		}), function(mounted)
			waitForTarget(mounted.host)
			assertNoPopup(mounted.host, "Expected disabled to suppress a Tooltip controlled with open={true}")
		end)
	end
	function TooltipMountValidation:nativeChildMounts()
		withMounted(400, 300, nativeApp(), function(mounted)
			local target = waitForNativeTarget(mounted.host)
			Assert:equal(target.Parent, mounted.host, "Expected the native child to render unwrapped under the host")
		end)
	end
	function TooltipMountValidation:nativeChildShows()
		withMounted(400, 300, nativeApp(), function(mounted)
			local target = waitForNativeTarget(mounted.host)
			local mouseEnterKey = React.Event.MouseEnter
			local _result = findHostFiber(mounted, target).memoizedProps
			if _result ~= nil then
				_result = _result[mouseEnterKey]
			end
			local handler = _result
			Assert:notUndefined(handler, "Expected the native child to carry a MouseEnter handler under React.Event.MouseEnter")
			handler(target, 0, 0)
			local tooltip = waitForGuiObject(mounted.host, "Tooltip")
			assertCenteredIn(tooltip, target, "x", 1, "native-child tooltip")
		end)
	end
	function TooltipMountValidation:rightEdgeFlips()
		withMounted(400, 300, edgeApp("Right", 290, 130), function(mounted)
			local placed = waitForPlacedPopup(mounted.host, function(popup, target)
				return popup.right <= target.left + 1
			end)
			Assert["true"](Assert, placed.popupRect.right <= placed.targetRect.left + 1, `Expected the popup {formatRect(placed.popupRect)} to open left of the target {formatRect(placed.targetRect)}`)
			assertContained(placed.popup, placed.overlay, "flipped Right tooltip vs overlay")
		end)
	end
	function TooltipMountValidation:topEdgeFlips()
		withMounted(400, 300, edgeApp("Top", 150, 4), function(mounted)
			local placed = waitForPlacedPopup(mounted.host, function(popup, target)
				return popup.top >= target.bottom - 1
			end)
			Assert["true"](Assert, placed.popupRect.top >= placed.targetRect.bottom - 1, `Expected the popup {formatRect(placed.popupRect)} to open below the target {formatRect(placed.targetRect)}`)
			assertContained(placed.popup, placed.overlay, "flipped Top tooltip vs overlay")
		end)
	end
	function TooltipMountValidation:leftEdgeShifts()
		withMounted(400, 300, edgeApp("Top", 0, 130, 40), function(mounted)
			local placed = waitForPlacedPopup(mounted.host, function(popup)
				return popup.left >= 8 - 0.5
			end)
			local pointer = findDescendant(placed.popup, "Pointer")
			local pointerRect = rect(pointer)
			Assert["true"](Assert, placed.popupRect.bottom <= placed.targetRect.top + 1, `Expected the popup {formatRect(placed.popupRect)} to stay above the target {formatRect(placed.targetRect)}`)
			Assert["true"](Assert, placed.popupRect.left >= placed.targetRect.left + 8 - 0.5, `Expected the popup {formatRect(placed.popupRect)} to keep the 8px edge margin`)
			Assert["true"](Assert, pointerRect.centerX >= placed.targetRect.left and pointerRect.centerX <= placed.targetRect.right, `Expected the pointer {formatRect(pointerRect)} to sit over the target {formatRect(placed.targetRect)}`)
			assertContained(pointer, placed.popup, "shifted pointer vs popup")
			assertContained(placed.popup, placed.overlay, "shifted Top tooltip vs overlay")
		end)
	end
	function TooltipMountValidation:autoRightEdge()
		withMounted(400, 300, edgeApp("Auto", 340, 130, 50), function(mounted)
			local placed = waitForPlacedPopup(mounted.host, function(popup, target)
				return popup.right <= target.left + 1
			end)
			Assert["true"](Assert, placed.popupRect.right <= placed.targetRect.left + 1, `Expected an Auto popup {formatRect(placed.popupRect)} to open left of the target {formatRect(placed.targetRect)}`)
			assertCenteredIn(placed.popup, placed.target, "y", 1, "Auto tooltip")
			assertContained(placed.popup, placed.overlay, "Auto tooltip vs overlay")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Before any hover the target is rendered but no Tooltip popup exists in the overlay")
	local _descriptor = Test(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor then
		TooltipMountValidation.hiddenUntilHover = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor_1 then
		TooltipMountValidation.hiddenUntilHover = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TooltipMountValidation, "hiddenUntilHover", {
		value = TooltipMountValidation.hiddenUntilHover,
	})
	if _descriptor_2 then
		TooltipMountValidation.hiddenUntilHover = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "Top" }, { "Bottom" } })
	local _decorator_4 = DisplayName("Hovering the target portals a Tooltip into the overlay, centered on the target and on the requested side")
	local _descriptor_3 = Test(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_3 then
		TooltipMountValidation.showsOnHover = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_4 then
		TooltipMountValidation.showsOnHover = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_5 then
		TooltipMountValidation.showsOnHover = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(TooltipMountValidation, "showsOnHover", {
		value = TooltipMountValidation.showsOnHover,
	})
	if _descriptor_6 then
		TooltipMountValidation.showsOnHover = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Leaving the target fades the Tooltip out and removes it from the overlay")
	local _descriptor_7 = Test(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_7 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_8 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TooltipMountValidation, "hidesAfterLeave", {
		value = TooltipMountValidation.hidesAfterLeave,
	})
	if _descriptor_9 then
		TooltipMountValidation.hidesAfterLeave = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("With disabled set, hovering the target never portals a popup into the overlay")
	local _descriptor_10 = Test(TooltipMountValidation, "disabledNoPopup", {
		value = TooltipMountValidation.disabledNoPopup,
	})
	if _descriptor_10 then
		TooltipMountValidation.disabledNoPopup = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TooltipMountValidation, "disabledNoPopup", {
		value = TooltipMountValidation.disabledNoPopup,
	})
	if _descriptor_11 then
		TooltipMountValidation.disabledNoPopup = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TooltipMountValidation, "disabledNoPopup", {
		value = TooltipMountValidation.disabledNoPopup,
	})
	if _descriptor_12 then
		TooltipMountValidation.disabledNoPopup = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Toggling disabled on and off keeps the very same target instance mounted, with hover handlers still injected")
	local _descriptor_13 = Test(TooltipMountValidation, "disabledKeepsInstance", {
		value = TooltipMountValidation.disabledKeepsInstance,
	})
	if _descriptor_13 then
		TooltipMountValidation.disabledKeepsInstance = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TooltipMountValidation, "disabledKeepsInstance", {
		value = TooltipMountValidation.disabledKeepsInstance,
	})
	if _descriptor_14 then
		TooltipMountValidation.disabledKeepsInstance = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TooltipMountValidation, "disabledKeepsInstance", {
		value = TooltipMountValidation.disabledKeepsInstance,
	})
	if _descriptor_15 then
		TooltipMountValidation.disabledKeepsInstance = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Disabling a Tooltip whose popup is open hides and removes the popup")
	local _descriptor_16 = Test(TooltipMountValidation, "disableHidesOpen", {
		value = TooltipMountValidation.disableHidesOpen,
	})
	if _descriptor_16 then
		TooltipMountValidation.disableHidesOpen = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(TooltipMountValidation, "disableHidesOpen", {
		value = TooltipMountValidation.disableHidesOpen,
	})
	if _descriptor_17 then
		TooltipMountValidation.disableHidesOpen = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(TooltipMountValidation, "disableHidesOpen", {
		value = TooltipMountValidation.disableHidesOpen,
	})
	if _descriptor_18 then
		TooltipMountValidation.disableHidesOpen = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("With open={true} the popup shows without a hover, survives a MouseLeave, and goes away once open becomes false")
	local _descriptor_19 = Test(TooltipMountValidation, "controlledOpen", {
		value = TooltipMountValidation.controlledOpen,
	})
	if _descriptor_19 then
		TooltipMountValidation.controlledOpen = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(TooltipMountValidation, "controlledOpen", {
		value = TooltipMountValidation.controlledOpen,
	})
	if _descriptor_20 then
		TooltipMountValidation.controlledOpen = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(TooltipMountValidation, "controlledOpen", {
		value = TooltipMountValidation.controlledOpen,
	})
	if _descriptor_21 then
		TooltipMountValidation.controlledOpen = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("With open={false}, hovering the target does not show the popup")
	local _descriptor_22 = Test(TooltipMountValidation, "controlledClosedIgnoresHover", {
		value = TooltipMountValidation.controlledClosedIgnoresHover,
	})
	if _descriptor_22 then
		TooltipMountValidation.controlledClosedIgnoresHover = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(TooltipMountValidation, "controlledClosedIgnoresHover", {
		value = TooltipMountValidation.controlledClosedIgnoresHover,
	})
	if _descriptor_23 then
		TooltipMountValidation.controlledClosedIgnoresHover = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(TooltipMountValidation, "controlledClosedIgnoresHover", {
		value = TooltipMountValidation.controlledClosedIgnoresHover,
	})
	if _descriptor_24 then
		TooltipMountValidation.controlledClosedIgnoresHover = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("disabled wins over open={true}: no popup is shown")
	local _descriptor_25 = Test(TooltipMountValidation, "disabledOverridesOpen", {
		value = TooltipMountValidation.disabledOverridesOpen,
	})
	if _descriptor_25 then
		TooltipMountValidation.disabledOverridesOpen = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(TooltipMountValidation, "disabledOverridesOpen", {
		value = TooltipMountValidation.disabledOverridesOpen,
	})
	if _descriptor_26 then
		TooltipMountValidation.disabledOverridesOpen = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(TooltipMountValidation, "disabledOverridesOpen", {
		value = TooltipMountValidation.disabledOverridesOpen,
	})
	if _descriptor_27 then
		TooltipMountValidation.disabledOverridesOpen = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("Tooltip wrapping a native <frame> mounts without error and leaves the frame in place")
	local _descriptor_28 = Test(TooltipMountValidation, "nativeChildMounts", {
		value = TooltipMountValidation.nativeChildMounts,
	})
	if _descriptor_28 then
		TooltipMountValidation.nativeChildMounts = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_20(TooltipMountValidation, "nativeChildMounts", {
		value = TooltipMountValidation.nativeChildMounts,
	})
	if _descriptor_29 then
		TooltipMountValidation.nativeChildMounts = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_19(TooltipMountValidation, "nativeChildMounts", {
		value = TooltipMountValidation.nativeChildMounts,
	})
	if _descriptor_30 then
		TooltipMountValidation.nativeChildMounts = _descriptor_30.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName("A native <frame> child carries a real MouseEnter handler, and firing it opens the popup")
	local _descriptor_31 = Test(TooltipMountValidation, "nativeChildShows", {
		value = TooltipMountValidation.nativeChildShows,
	})
	if _descriptor_31 then
		TooltipMountValidation.nativeChildShows = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_22(TooltipMountValidation, "nativeChildShows", {
		value = TooltipMountValidation.nativeChildShows,
	})
	if _descriptor_32 then
		TooltipMountValidation.nativeChildShows = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_21(TooltipMountValidation, "nativeChildShows", {
		value = TooltipMountValidation.nativeChildShows,
	})
	if _descriptor_33 then
		TooltipMountValidation.nativeChildShows = _descriptor_33.value
	end
	local _decorator_23 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_24 = DisplayName("A Right tooltip on a trigger at the right edge opens to the left and stays inside the overlay")
	local _descriptor_34 = Test(TooltipMountValidation, "rightEdgeFlips", {
		value = TooltipMountValidation.rightEdgeFlips,
	})
	if _descriptor_34 then
		TooltipMountValidation.rightEdgeFlips = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_24(TooltipMountValidation, "rightEdgeFlips", {
		value = TooltipMountValidation.rightEdgeFlips,
	})
	if _descriptor_35 then
		TooltipMountValidation.rightEdgeFlips = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_23(TooltipMountValidation, "rightEdgeFlips", {
		value = TooltipMountValidation.rightEdgeFlips,
	})
	if _descriptor_36 then
		TooltipMountValidation.rightEdgeFlips = _descriptor_36.value
	end
	local _decorator_25 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_26 = DisplayName("A Top tooltip on a trigger at the top edge opens below it and stays inside the overlay")
	local _descriptor_37 = Test(TooltipMountValidation, "topEdgeFlips", {
		value = TooltipMountValidation.topEdgeFlips,
	})
	if _descriptor_37 then
		TooltipMountValidation.topEdgeFlips = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_26(TooltipMountValidation, "topEdgeFlips", {
		value = TooltipMountValidation.topEdgeFlips,
	})
	if _descriptor_38 then
		TooltipMountValidation.topEdgeFlips = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_25(TooltipMountValidation, "topEdgeFlips", {
		value = TooltipMountValidation.topEdgeFlips,
	})
	if _descriptor_39 then
		TooltipMountValidation.topEdgeFlips = _descriptor_39.value
	end
	local _decorator_27 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_28 = DisplayName("A Top tooltip on a narrow trigger at the left edge shifts right, clears the edge margin and keeps its pointer over the trigger")
	local _descriptor_40 = Test(TooltipMountValidation, "leftEdgeShifts", {
		value = TooltipMountValidation.leftEdgeShifts,
	})
	if _descriptor_40 then
		TooltipMountValidation.leftEdgeShifts = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_28(TooltipMountValidation, "leftEdgeShifts", {
		value = TooltipMountValidation.leftEdgeShifts,
	})
	if _descriptor_41 then
		TooltipMountValidation.leftEdgeShifts = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_27(TooltipMountValidation, "leftEdgeShifts", {
		value = TooltipMountValidation.leftEdgeShifts,
	})
	if _descriptor_42 then
		TooltipMountValidation.leftEdgeShifts = _descriptor_42.value
	end
	local _decorator_29 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_30 = DisplayName("Auto on a trigger at the right edge opens to the left, where it needs no sideways shift")
	local _descriptor_43 = Test(TooltipMountValidation, "autoRightEdge", {
		value = TooltipMountValidation.autoRightEdge,
	})
	if _descriptor_43 then
		TooltipMountValidation.autoRightEdge = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_30(TooltipMountValidation, "autoRightEdge", {
		value = TooltipMountValidation.autoRightEdge,
	})
	if _descriptor_44 then
		TooltipMountValidation.autoRightEdge = _descriptor_44.value
	end
	local _descriptor_45 = _decorator_29(TooltipMountValidation, "autoRightEdge", {
		value = TooltipMountValidation.autoRightEdge,
	})
	if _descriptor_45 then
		TooltipMountValidation.autoRightEdge = _descriptor_45.value
	end
	TooltipMountValidation = Tag("Studio")(TooltipMountValidation) or TooltipMountValidation
end
return TooltipMountValidation
