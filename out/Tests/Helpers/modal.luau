-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local GamepadSelectionGuard = TS.import(script, script.Parent.Parent.Parent, "Components", "Interaction", "GamepadSelectionGuard").GamepadSelectionGuard
local Modal = TS.import(script, script.Parent.Parent.Parent, "Components", "Interaction", "Modal").Modal
local Text = TS.import(script, script.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local ModalProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "modal.provider").ModalProvider
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local RegistryProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "registry.provider").RegistryProvider
local _layout = TS.import(script, script.Parent, "layout")
local waitForGuiObject = _layout.waitForGuiObject
local waitForRemoval = _layout.waitForRemoval
local MODAL_HOST_WIDTH = 800
local MODAL_HOST_HEIGHT = 600
local function modalSelectionApp(options)
	local tree = (React.createElement(ModalProvider, nil, React.createElement("frame", {
		key = "Outside",
		Selectable = true,
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
	}), React.createElement(Modal, {
		open = options.open,
		selectionMode = options.mode,
		initialFocus = options.focus,
	}, React.createElement(Text, {
		text = "Body",
	}), options.focus ~= nil and (React.createElement("frame", {
		key = "Focus",
		ref = options.focus,
		Selectable = true,
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
	})))))
	return React.createElement(RegistryProvider, nil, React.createElement(OverlayProvider, nil, if options.guard == true then React.createElement(GamepadSelectionGuard, nil, tree) else tree))
end
local function waitForOutside(mounted)
	waitForGuiObject(mounted.host, "OverlayProvider")
	return waitForGuiObject(mounted.host, "Outside")
end
local function waitForOpenModal(mounted)
	local shield = waitForGuiObject(mounted.host, "ModalPanelInputShield")
	local panel = waitForGuiObject(shield, "Modal")
	return {
		shield = shield,
		panel = panel,
	}
end
local function openModal(mounted, options)
	local _mounted = mounted
	local _object = table.clone(options)
	setmetatable(_object, nil)
	_object.open = true
	_mounted.update(modalSelectionApp(_object))
	return waitForOpenModal(mounted)
end
local function closeModal(mounted, options)
	local _mounted = mounted
	local _object = table.clone(options)
	setmetatable(_object, nil)
	_object.open = false
	_mounted.update(modalSelectionApp(_object))
	waitForRemoval(mounted.host, "ModalBackdrop")
end
return {
	modalSelectionApp = modalSelectionApp,
	waitForOutside = waitForOutside,
	waitForOpenModal = waitForOpenModal,
	openModal = openModal,
	closeModal = closeModal,
	MODAL_HOST_WIDTH = MODAL_HOST_WIDTH,
	MODAL_HOST_HEIGHT = MODAL_HOST_HEIGHT,
}
