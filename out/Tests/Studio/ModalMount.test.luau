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
local Button = TS.import(script, script.Parent.Parent.Parent, "Components", "Input").Button
local Card = TS.import(script, script.Parent.Parent.Parent, "Components", "Surface").Card
local GuiHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").GuiHelper
local CleanUiProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local _Providers = TS.import(script, script.Parent.Parent.Parent, "Providers")
local DraggableRegistryKey = _Providers.DraggableRegistryKey
local RegistryContext = _Providers.RegistryContext
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultTheme
local useModalClose = TS.import(script, script.Parent.Parent.Parent, "Contexts").useModalClose
local latestRegistry
local function RegistryHarness()
	latestRegistry = React.useContext(RegistryContext)
	return nil
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
	function ModalMountValidation:rendersBackdropAndPanelWhenOpenInsideCleanUiProvider()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
		})))
		task.wait()
		Assert:notUndefined(host:FindFirstChildWhichIsA("ImageButton", true))
		Assert:notUndefined(host:FindFirstChild("Modal", true))
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:wrapsThePanelInAContentSizedButtonThatShieldsTheBackdrop()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
		})))
		task.wait()
		local backdrop = host:FindFirstChild("ModalBackdrop", true)
		local shield = host:FindFirstChild("ModalPanelInputShield", true)
		local panel = host:FindFirstChild("Modal", true)
		Assert:notUndefined(backdrop)
		Assert:notUndefined(shield)
		Assert:notUndefined(panel)
		Assert["true"](Assert, backdrop:IsA("ImageButton"))
		Assert["true"](Assert, shield:IsA("ImageButton"))
		local shieldButton = shield
		Assert["true"](Assert, shieldButton.Active)
		Assert["false"](Assert, shieldButton.AutoButtonColor)
		Assert:equal(shieldButton.AutomaticSize, Enum.AutomaticSize.XY)
		Assert:equal(panel.Parent, shield)
		Assert["true"](Assert, shield:IsDescendantOf(backdrop))
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:resolvesPercentageAndScalePanelSizesAgainstTheOverlay()
		local host = Instance.new("Frame")
		host.Size = UDim2.fromOffset(800, 600)
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
			width = "50%",
			height = "40%",
		})))
		task.wait()
		local shield = host:FindFirstChild("ModalPanelInputShield", true)
		local panel = host:FindFirstChild("Modal", true)
		Assert:notUndefined(shield)
		Assert:notUndefined(panel)
		Assert:equal(shield.Size, UDim2.fromScale(0.5, 0.4))
		Assert:equal(panel.Size, UDim2.fromScale(1, 1))
		Assert["true"](Assert, shield.AbsoluteSize.X > 0)
		Assert["true"](Assert, shield.AbsoluteSize.Y > 0)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
			Size = UDim2.fromScale(0.25, 0.3),
		})))
		task.wait()
		shield = host:FindFirstChild("ModalPanelInputShield", true)
		panel = host:FindFirstChild("Modal", true)
		Assert:notUndefined(shield)
		Assert:notUndefined(panel)
		Assert:equal(shield.Size, UDim2.fromScale(0.25, 0.3))
		Assert:equal(panel.Size, UDim2.fromScale(1, 1))
		Assert["true"](Assert, shield.AbsoluteSize.X > 0)
		Assert["true"](Assert, shield.AbsoluteSize.Y > 0)
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:defaultsToANonDraggableCenteredPanel()
		local host = Instance.new("Folder")
		latestRegistry = nil
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
		}, React.createElement(Card.Header))))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("CenterLayout", true))
		Assert:notUndefined(latestRegistry)
		Assert:equal(#latestRegistry.getAll(DraggableRegistryKey), 0)
		local header = host:FindFirstChild("CardHeader", true)
		Assert:notUndefined(header)
		Assert["false"](Assert, header.Active)
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:makesTheHeaderADragHandleAndRetainsTheDroppedPosition()
		local host = Instance.new("Folder")
		latestRegistry = nil
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
			draggable = true,
		}, React.createElement(Card.Header))))
		task.wait()
		Assert:undefined(host:FindFirstChild("CenterLayout", true))
		Assert:notUndefined(latestRegistry)
		local registrations = latestRegistry.getAll(DraggableRegistryKey)
		Assert:equal(#registrations, 1)
		local registration = registrations[1]
		local header = host:FindFirstChild("CardHeader", true)
		Assert:notUndefined(header)
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
		Assert:equal(registration.guiObject.Position.X.Offset, 30)
		Assert:equal(registration.guiObject.Position.Y.Offset, 40)
		root:unmount()
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
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(RegistryHarness), React.createElement(Modal, {
			open = true,
			draggable = true,
			onOpenChange = function(open)
				local _open = open
				table.insert(openChanges, _open)
				return #openChanges
			end,
		}, React.createElement(Card.Header, nil, React.createElement(CloseButton)))))
		task.wait()
		local header = host:FindFirstChild("CardHeader", true)
		local closeButton = host:FindFirstChild("ModalCloseButton", true)
		Assert:notUndefined(header)
		Assert:notUndefined(closeButton)
		Assert:notUndefined(latestRegistry)
		Assert:notUndefined(activateClose)
		Assert["true"](Assert, closeButton:IsDescendantOf(header))
		local registration = latestRegistry.getAll(DraggableRegistryKey)[1]
		Assert:notUndefined(registration)
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
		activateClose()
		task.wait()
		Assert:deepEqual(openChanges, { false })
		Assert["false"](Assert, registration.draggable.isDragging)
		Assert:equal(registration.guiObject.Position, initialPosition)
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:opensAutomaticallyWhenDefaultOpenIsTrueWithoutControlledOpenOrOnOpenChange()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			defaultOpen = true,
		})))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("Modal", true))
		root:unmount()
		host:Destroy()
	end
	function ModalMountValidation:controlledOpenPropDrivesTheRenderedModalRatherThanDefaultOpen()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = false,
			defaultOpen = true,
		})))
		task.wait()
		Assert:undefined(host:FindFirstChild("Modal", true))
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
			defaultOpen = true,
		})))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("Modal", true))
		root:unmount()
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
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(CleanUiProvider, {
			theme = DefaultTheme,
		}, React.createElement(Modal, {
			open = true,
			onOpenChange = function(value)
				local _value = value
				table.insert(onOpenChangeValues, _value)
			end,
		}, React.createElement(CloseHarness))))
		task.wait()
		Assert:notUndefined(requestClose)
		requestClose()
		task.wait()
		Assert:deepEqual(onOpenChangeValues, { false })
		Assert:notUndefined(host:FindFirstChild("Modal", true))
		root:unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor = Test(ModalMountValidation, "rendersBackdropAndPanelWhenOpenInsideCleanUiProvider", {
		value = ModalMountValidation.rendersBackdropAndPanelWhenOpenInsideCleanUiProvider,
	})
	if _descriptor then
		ModalMountValidation.rendersBackdropAndPanelWhenOpenInsideCleanUiProvider = _descriptor.value
	end
	local _descriptor_1 = _decorator(ModalMountValidation, "rendersBackdropAndPanelWhenOpenInsideCleanUiProvider", {
		value = ModalMountValidation.rendersBackdropAndPanelWhenOpenInsideCleanUiProvider,
	})
	if _descriptor_1 then
		ModalMountValidation.rendersBackdropAndPanelWhenOpenInsideCleanUiProvider = _descriptor_1.value
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
