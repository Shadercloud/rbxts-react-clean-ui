-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local _binding = Decorators
local Skip = _binding.Skip
local Modal = TS.import(script, script.Parent.Parent.Parent, "Components", "Interaction", "Modal").Modal
local Button = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Button").Button
local Card = TS.import(script, script.Parent.Parent.Parent, "Components", "Surface", "Card").Card
local OverlayContext = TS.import(script, script.Parent.Parent.Parent, "Contexts", "overlay.context").OverlayContext
local useModalClose = TS.import(script, script.Parent.Parent.Parent, "Contexts", "modal.context").useModalClose
local GuiHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "gui.helper").GuiHelper
local ModalProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "modal.provider").ModalProvider
local _registry_provider = TS.import(script, script.Parent.Parent.Parent, "Providers", "registry.provider")
local DraggableRegistryKey = _registry_provider.DraggableRegistryKey
local RegistryContext = _registry_provider.RegistryContext
local RegistryProvider = _registry_provider.RegistryProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultTheme
local latestRegistry
local function RegistryHarness()
	latestRegistry = React.useContext(RegistryContext)
	return nil
end
local function waitForValue(resolve, failureMessage)
	for attempt = 0, 29 do
		local value = resolve()
		if value ~= nil then
			return value
		end
		task.wait()
	end
	return Assert:fail(failureMessage)
end
local function waitForCondition(resolve, failureMessage)
	waitForValue(function()
		return if resolve() then true else nil
	end, failureMessage)
end
local function waitForDescendant(host, name, failureMessage)
	return waitForValue(function()
		return host:FindFirstChild(name, true)
	end, failureMessage)
end
local function createTestRoot(host)
	Assert:notUndefined(RegistryProvider, "Expected direct registry.provider import to export RegistryProvider")
	Assert:notUndefined(ThemeProvider, "Expected direct theme.provider import to export ThemeProvider")
	Assert:notUndefined(ModalProvider, "Expected direct modal.provider import to export ModalProvider")
	Assert:notUndefined(OverlayContext, "Expected direct overlay.context import to export OverlayContext")
	Assert:notUndefined(OverlayContext.Provider, "Expected OverlayContext to expose its React Provider element type")
	local renderHost = Instance.new("Folder")
	renderHost.Name = "ReactRenderHost"
	renderHost.Parent = host
	local overlay = Instance.new("Frame")
	overlay.Name = "TestOverlay"
	overlay.Size = UDim2.fromScale(1, 1)
	overlay.BackgroundTransparency = 1
	overlay.Parent = host
	local root = ReactRoblox.createRoot(renderHost)
	local renderGeneration = 0
	return {
		render = function(children)
			renderGeneration += 1
			local probeName = `ReactCommitProbe-{renderGeneration}`
			root:render(React.createElement(RegistryProvider, nil, React.createElement(ThemeProvider, {
				theme = DefaultTheme,
			}, React.createElement(OverlayContext.Provider, {
				value = {
					overlay = overlay,
				},
			}, React.createElement(ModalProvider, nil, React.createElement("frame", {
				key = probeName,
			}), children)))))
			waitForDescendant(renderHost, probeName, `Timed out waiting for createRoot().render() to commit {probeName} into ReactRenderHost`)
		end,
		unmount = function()
			root:unmount()
			waitForCondition(function()
				return #renderHost:GetChildren() == 0 and #overlay:GetChildren() == 0
			end, "Timed out waiting for the React root and Modal portal to unmount")
			overlay:Destroy()
			renderHost:Destroy()
		end,
	}
end
local ModalMountValidation
do
	ModalMountValidation = setmetatable({}, {
		__tostring = function()
			return "ModalMountValidation"
		end,
	})
	ModalMountValidation.__index = ModalMountValidation
	function ModalMountValidation.new(...)
		local self = setmetatable({}, ModalMountValidation)
		return self:constructor(...) or self
	end
	function ModalMountValidation:constructor()
	end
	function ModalMountValidation:rendersBackdropAndPanelWithExplicitModalProviders()
		local host = Instance.new("Folder")
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
		})))
		waitForDescendant(host, "ModalBackdrop", "Expected Modal to portal ModalBackdrop into the explicit TestOverlay")
		waitForDescendant(host, "Modal", "Expected the Modal Card inside the portal")
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop()
		local host = Instance.new("Folder")
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
		})))
		local backdrop = waitForDescendant(host, "ModalBackdrop", "Expected ModalBackdrop after the portal commit")
		local shield = waitForDescendant(host, "ModalPanelInputShield", "Expected ModalPanelInputShield inside ModalBackdrop")
		local panel = waitForDescendant(host, "Modal", "Expected the Modal Card inside its input shield")
		Assert["true"](Assert, backdrop:IsA("ImageButton"))
		Assert["true"](Assert, shield:IsA("ImageButton"))
		local shieldButton = shield
		Assert["true"](Assert, shieldButton.Active)
		Assert["false"](Assert, shieldButton.AutoButtonColor)
		Assert:equal(shieldButton.AutomaticSize, Enum.AutomaticSize.Y)
		Assert:equal(panel.Parent, shield)
		Assert["true"](Assert, shield:IsDescendantOf(backdrop))
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:resolvesPercentageAndScalePanelSizesAgainstTheOverlay()
		local host = Instance.new("Frame")
		host.Size = UDim2.fromOffset(800, 600)
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
			width = "50%",
			height = "40%",
		})))
		local shield = waitForDescendant(host, "ModalPanelInputShield", "Expected the percentage-sized ModalPanelInputShield")
		local panel = waitForDescendant(host, "Modal", "Expected the percentage-sized Modal Card")
		Assert:equal(shield.Size, UDim2.fromScale(0.5, 0.4))
		Assert:equal(panel.Size, UDim2.fromScale(1, 1))
		Assert["true"](Assert, shield.AbsoluteSize.X > 0)
		Assert["true"](Assert, shield.AbsoluteSize.Y > 0)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
			Size = UDim2.fromScale(0.25, 0.3),
		})))
		shield = waitForDescendant(host, "ModalPanelInputShield", "Expected the scale-sized ModalPanelInputShield after rerender")
		panel = waitForDescendant(host, "Modal", "Expected the scale-sized Modal Card after rerender")
		Assert:equal(shield.Size, UDim2.fromScale(0.25, 0.3))
		Assert:equal(panel.Size, UDim2.fromScale(1, 1))
		Assert["true"](Assert, shield.AbsoluteSize.X > 0)
		Assert["true"](Assert, shield.AbsoluteSize.Y > 0)
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:defaultsToANonDraggableCenteredPanel()
		local host = Instance.new("Folder")
		latestRegistry = nil
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
		}, React.createElement(Card.Header))))
		waitForDescendant(host, "CenterLayout", "Expected default Modal centering layout")
		local registry = waitForValue(function()
			return latestRegistry
		end, "Expected RegistryHarness to publish RegistryContext")
		Assert:equal(#registry.getAll(DraggableRegistryKey), 0)
		local header = waitForDescendant(host, "CardHeader", "Expected the non-draggable CardHeader")
		Assert["false"](Assert, header.Active)
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:makesTheHeaderADragHandleAndRetainsTheDroppedPosition()
		local host = Instance.new("Folder")
		latestRegistry = nil
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
			draggable = true,
		}, React.createElement(Card.Header))))
		Assert:undefined(host:FindFirstChild("CenterLayout", true))
		local registry = waitForValue(function()
			return latestRegistry
		end, "Expected RegistryHarness to publish RegistryContext")
		local registrations = waitForValue(function()
			local current = registry.getAll(DraggableRegistryKey)
			return if #current == 1 then current else nil
		end, "Expected one draggable Modal registration")
		local registration = registrations[1]
		local header = waitForDescendant(host, "CardHeader", "Expected CardHeader to render as the drag handle")
		Assert["true"](Assert, header.Active)
		Assert:equal(registration.guiObject.AnchorPoint, Vector2.new(0.5, 0.5))
		Assert:equal(registration.guiObject.Position, UDim2.fromScale(0.5, 0.5))
		local dragStart = {
			Position = Vector3.new(10, 20, 0),
		}
		local dragEnd = {
			Position = Vector3.new(40, 60, 0),
		}
		registration.draggable.beginDrag(dragStart, header)
		registration.draggable.endDrag(dragEnd)
		waitForCondition(function()
			return registration.guiObject.Position.X.Offset == 30 and registration.guiObject.Position.Y.Offset == 40
		end, "Expected retained draggable position to reach the 30px, 40px drop offset")
		Assert:equal(registration.guiObject.Position.X.Offset, 30)
		Assert:equal(registration.guiObject.Position.Y.Offset, 40)
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:nestedHeaderButtonClosesWithoutStartingOrCommittingADrag()
		local host = Instance.new("Frame")
		host.Size = UDim2.fromOffset(800, 600)
		latestRegistry = nil
		local openChanges = {}
		local activateClose
		local function CloseButton()
			local close = useModalClose()
			activateClose = close
			return React.createElement(Button, {
				name = "ModalCloseButton",
				text = "Close",
				Event = {
					Activated = close,
				},
			})
		end
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
			draggable = true,
			onOpenChange = function(open)
				local _open = open
				table.insert(openChanges, _open)
				return #openChanges
			end,
		}, React.createElement(Card.Header, nil, React.createElement(CloseButton)))))
		local header = waitForDescendant(host, "CardHeader", "Expected CardHeader around the nested close button")
		local closeButton = waitForDescendant(host, "ModalCloseButton", "Expected the nested ModalCloseButton")
		local registry = waitForValue(function()
			return latestRegistry
		end, "Expected RegistryHarness to publish RegistryContext")
		local close = waitForValue(function()
			return activateClose
		end, "Expected CloseButton to capture useModalClose()")
		Assert["true"](Assert, closeButton:IsDescendantOf(header))
		local registration = waitForValue(function()
			return registry.getAll(DraggableRegistryKey)[1]
		end, "Expected draggable Modal registration")
		local _absolutePosition = closeButton.AbsolutePosition
		local _arg0 = closeButton.AbsoluteSize / 2
		local buttonPoint = _absolutePosition + _arg0
		local hitObjects = GuiHelper:getGuiObjectsAtPosition(header, buttonPoint)
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		local _callback = function(guiObject)
			return guiObject == closeButton
		end
		for _k, _v in hitObjects do
			if _callback(_v, _k - 1, hitObjects) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		Assert["true"](Assert, _result)
		local initialPosition = registration.guiObject.Position
		close()
		waitForCondition(function()
			return #openChanges == 1
		end, "Expected nested close button to publish onOpenChange(false)")
		Assert:deepEqual(openChanges, { false })
		Assert["false"](Assert, registration.draggable.isDragging)
		Assert:equal(registration.guiObject.Position, initialPosition)
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange()
		local host = Instance.new("Folder")
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			defaultOpen = true,
		})))
		waitForDescendant(host, "Modal", "Expected defaultOpen Modal Card in the portal")
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen()
		local host = Instance.new("Folder")
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = false,
			defaultOpen = true,
		})))
		Assert:undefined(host:FindFirstChild("Modal", true))
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
			defaultOpen = true,
		})))
		waitForDescendant(host, "Modal", "Expected controlled Modal Card after open changed to true")
		root.unmount()
		host:Destroy()
	end
	function ModalMountValidation:closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal()
		local host = Instance.new("Folder")
		local onOpenChangeValues = {}
		local requestClose
		local function CloseHarness()
			requestClose = useModalClose()
			return nil
		end
		local root = createTestRoot(host)
		root.render(React.createElement(React.Fragment, nil, React.createElement(Modal, {
			open = true,
			onOpenChange = function(value)
				local _value = value
				table.insert(onOpenChangeValues, _value)
			end,
		}, React.createElement(CloseHarness))))
		local close = waitForValue(function()
			return requestClose
		end, "Expected CloseHarness to capture useModalClose()")
		close()
		waitForCondition(function()
			return #onOpenChangeValues == 1
		end, "Expected modal close request to publish onOpenChange(false)")
		Assert:deepEqual(onOpenChangeValues, { false })
		waitForDescendant(host, "Modal", "Expected controlled Modal to remain rendered until its open prop changes")
		root.unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor = Test(ModalMountValidation, "rendersBackdropAndPanelWithExplicitModalProviders", {
		value = ModalMountValidation.rendersBackdropAndPanelWithExplicitModalProviders,
	})
	if _descriptor then
		ModalMountValidation.rendersBackdropAndPanelWithExplicitModalProviders = _descriptor.value
	end
	local _descriptor_1 = _decorator(ModalMountValidation, "rendersBackdropAndPanelWithExplicitModalProviders", {
		value = ModalMountValidation.rendersBackdropAndPanelWithExplicitModalProviders,
	})
	if _descriptor_1 then
		ModalMountValidation.rendersBackdropAndPanelWithExplicitModalProviders = _descriptor_1.value
	end
	local _decorator_1 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_2 = Test(ModalMountValidation, "wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop", {
		value = ModalMountValidation.wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop,
	})
	if _descriptor_2 then
		ModalMountValidation.wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(ModalMountValidation, "wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop", {
		value = ModalMountValidation.wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop,
	})
	if _descriptor_3 then
		ModalMountValidation.wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop = _descriptor_3.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_4 = Test(ModalMountValidation, "resolvesPercentageAndScalePanelSizesAgainstTheOverlay", {
		value = ModalMountValidation.resolvesPercentageAndScalePanelSizesAgainstTheOverlay,
	})
	if _descriptor_4 then
		ModalMountValidation.resolvesPercentageAndScalePanelSizesAgainstTheOverlay = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ModalMountValidation, "resolvesPercentageAndScalePanelSizesAgainstTheOverlay", {
		value = ModalMountValidation.resolvesPercentageAndScalePanelSizesAgainstTheOverlay,
	})
	if _descriptor_5 then
		ModalMountValidation.resolvesPercentageAndScalePanelSizesAgainstTheOverlay = _descriptor_5.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_6 = Test(ModalMountValidation, "defaultsToANonDraggableCenteredPanel", {
		value = ModalMountValidation.defaultsToANonDraggableCenteredPanel,
	})
	if _descriptor_6 then
		ModalMountValidation.defaultsToANonDraggableCenteredPanel = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(ModalMountValidation, "defaultsToANonDraggableCenteredPanel", {
		value = ModalMountValidation.defaultsToANonDraggableCenteredPanel,
	})
	if _descriptor_7 then
		ModalMountValidation.defaultsToANonDraggableCenteredPanel = _descriptor_7.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_8 = Test(ModalMountValidation, "makesTheHeaderADragHandleAndRetainsTheDroppedPosition", {
		value = ModalMountValidation.makesTheHeaderADragHandleAndRetainsTheDroppedPosition,
	})
	if _descriptor_8 then
		ModalMountValidation.makesTheHeaderADragHandleAndRetainsTheDroppedPosition = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(ModalMountValidation, "makesTheHeaderADragHandleAndRetainsTheDroppedPosition", {
		value = ModalMountValidation.makesTheHeaderADragHandleAndRetainsTheDroppedPosition,
	})
	if _descriptor_9 then
		ModalMountValidation.makesTheHeaderADragHandleAndRetainsTheDroppedPosition = _descriptor_9.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_10 = Test(ModalMountValidation, "nestedHeaderButtonClosesWithoutStartingOrCommittingADrag", {
		value = ModalMountValidation.nestedHeaderButtonClosesWithoutStartingOrCommittingADrag,
	})
	if _descriptor_10 then
		ModalMountValidation.nestedHeaderButtonClosesWithoutStartingOrCommittingADrag = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(ModalMountValidation, "nestedHeaderButtonClosesWithoutStartingOrCommittingADrag", {
		value = ModalMountValidation.nestedHeaderButtonClosesWithoutStartingOrCommittingADrag,
	})
	if _descriptor_11 then
		ModalMountValidation.nestedHeaderButtonClosesWithoutStartingOrCommittingADrag = _descriptor_11.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_12 = Test(ModalMountValidation, "opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange", {
		value = ModalMountValidation.opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange,
	})
	if _descriptor_12 then
		ModalMountValidation.opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(ModalMountValidation, "opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange", {
		value = ModalMountValidation.opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange,
	})
	if _descriptor_13 then
		ModalMountValidation.opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange = _descriptor_13.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_14 = Test(ModalMountValidation, "controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen", {
		value = ModalMountValidation.controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen,
	})
	if _descriptor_14 then
		ModalMountValidation.controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(ModalMountValidation, "controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen", {
		value = ModalMountValidation.controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen,
	})
	if _descriptor_15 then
		ModalMountValidation.controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen = _descriptor_15.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_16 = Test(ModalMountValidation, "closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal", {
		value = ModalMountValidation.closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal,
	})
	if _descriptor_16 then
		ModalMountValidation.closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_8(ModalMountValidation, "closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal", {
		value = ModalMountValidation.closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal,
	})
	if _descriptor_17 then
		ModalMountValidation.closeRequestNotifiesOnOpenChangeWithFalseWithoutClosingAControlledModal = _descriptor_17.value
	end
	ModalMountValidation = Tag("Studio")(ModalMountValidation) or ModalMountValidation
end
return ModalMountValidation
