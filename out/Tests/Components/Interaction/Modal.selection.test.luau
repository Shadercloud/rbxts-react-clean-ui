-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local withMounted = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout").withMounted
local _modal = TS.import(script, script.Parent.Parent.Parent, "Helpers", "modal")
local MODAL_HOST_HEIGHT = _modal.MODAL_HOST_HEIGHT
local MODAL_HOST_WIDTH = _modal.MODAL_HOST_WIDTH
local modalSelectionApp = _modal.modalSelectionApp
local openModal = _modal.openModal
local waitForOpenModal = _modal.waitForOpenModal
local waitForOutside = _modal.waitForOutside
local _selection = TS.import(script, script.Parent.Parent.Parent, "Helpers", "selection")
local SELECTION_SKIP_MESSAGE = _selection.SELECTION_SKIP_MESSAGE
local assertSelectionStays = _selection.assertSelectionStays
local selectObject = _selection.selectObject
local selectionUnavailable = _selection.selectionUnavailable
local waitForSelection = _selection.waitForSelection
local withSelectionReset = _selection.withSelectionReset
local ModalOpenSelection
do
	ModalOpenSelection = setmetatable({}, {
		__tostring = function()
			return "ModalOpenSelection"
		end,
	})
	ModalOpenSelection.__index = ModalOpenSelection
	function ModalOpenSelection.new(...)
		local self = setmetatable({}, ModalOpenSelection)
		return self:constructor(...) or self
	end
	function ModalOpenSelection:constructor()
	end
	function ModalOpenSelection:defaultSelectsNothing()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				waitForOutside(mounted)
				openModal(mounted, {})
				assertSelectionStays(nil, "after opening a default modal")
			end)
		end)
	end
	function ModalOpenSelection:defaultKeepsOutside()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				local outside = waitForOutside(mounted)
				selectObject(outside)
				openModal(mounted, {})
				assertSelectionStays(outside, "after opening a default modal")
			end)
		end)
	end
	function ModalOpenSelection:alwaysSelectsPanel()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				selectObject(waitForOutside(mounted))
				local opened = openModal(mounted, {
					mode = "always",
				})
				waitForSelection(opened.panel, "after opening an always modal")
			end)
		end)
	end
	function ModalOpenSelection:alwaysSelectsInitialFocus()
		local focus = React.createRef()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
				focus = focus,
			}), function(mounted)
				waitForOutside(mounted)
				openModal(mounted, {
					mode = "always",
					focus = focus,
				})
				Assert:notUndefined(focus.current, "Expected the initialFocus frame to be mounted")
				waitForSelection(focus.current, "after opening an always modal with initialFocus")
			end)
		end)
	end
	function ModalOpenSelection:alwaysSelectsMountedOpen()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = true,
				mode = "always",
			}), function(mounted)
				local opened = waitForOpenModal(mounted)
				waitForSelection(opened.panel, "after mounting an always modal open")
			end)
		end)
	end
	function ModalOpenSelection:guardBeatsAlways()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
				guard = true,
			}), function(mounted)
				waitForOutside(mounted)
				openModal(mounted, {
					mode = "always",
					guard = true,
				})
				waitForSelection(nil, "after opening an always modal under a guard")
				assertSelectionStays(nil, "while the guarded always modal stays open")
			end)
		end)
	end
	local _decorator = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With the default selectionMode and no gamepad, opening selects nothing")
	local _descriptor = Test(ModalOpenSelection, "defaultSelectsNothing", {
		value = ModalOpenSelection.defaultSelectsNothing,
	})
	if _descriptor then
		ModalOpenSelection.defaultSelectsNothing = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ModalOpenSelection, "defaultSelectsNothing", {
		value = ModalOpenSelection.defaultSelectsNothing,
	})
	if _descriptor_1 then
		ModalOpenSelection.defaultSelectsNothing = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ModalOpenSelection, "defaultSelectsNothing", {
		value = ModalOpenSelection.defaultSelectsNothing,
	})
	if _descriptor_2 then
		ModalOpenSelection.defaultSelectsNothing = _descriptor_2.value
	end
	local _decorator_2 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With the default selectionMode and no gamepad, a selection outside the modal is left alone on open")
	local _descriptor_3 = Test(ModalOpenSelection, "defaultKeepsOutside", {
		value = ModalOpenSelection.defaultKeepsOutside,
	})
	if _descriptor_3 then
		ModalOpenSelection.defaultKeepsOutside = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ModalOpenSelection, "defaultKeepsOutside", {
		value = ModalOpenSelection.defaultKeepsOutside,
	})
	if _descriptor_4 then
		ModalOpenSelection.defaultKeepsOutside = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ModalOpenSelection, "defaultKeepsOutside", {
		value = ModalOpenSelection.defaultKeepsOutside,
	})
	if _descriptor_5 then
		ModalOpenSelection.defaultKeepsOutside = _descriptor_5.value
	end
	local _decorator_4 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_5 = DisplayName('selectionMode=\"always\" moves the selection to the panel Card on open whatever the input')
	local _descriptor_6 = Test(ModalOpenSelection, "alwaysSelectsPanel", {
		value = ModalOpenSelection.alwaysSelectsPanel,
	})
	if _descriptor_6 then
		ModalOpenSelection.alwaysSelectsPanel = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ModalOpenSelection, "alwaysSelectsPanel", {
		value = ModalOpenSelection.alwaysSelectsPanel,
	})
	if _descriptor_7 then
		ModalOpenSelection.alwaysSelectsPanel = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ModalOpenSelection, "alwaysSelectsPanel", {
		value = ModalOpenSelection.alwaysSelectsPanel,
	})
	if _descriptor_8 then
		ModalOpenSelection.alwaysSelectsPanel = _descriptor_8.value
	end
	local _decorator_6 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_7 = DisplayName('selectionMode=\"always\" with initialFocus selects that element instead of the panel')
	local _descriptor_9 = Test(ModalOpenSelection, "alwaysSelectsInitialFocus", {
		value = ModalOpenSelection.alwaysSelectsInitialFocus,
	})
	if _descriptor_9 then
		ModalOpenSelection.alwaysSelectsInitialFocus = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ModalOpenSelection, "alwaysSelectsInitialFocus", {
		value = ModalOpenSelection.alwaysSelectsInitialFocus,
	})
	if _descriptor_10 then
		ModalOpenSelection.alwaysSelectsInitialFocus = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ModalOpenSelection, "alwaysSelectsInitialFocus", {
		value = ModalOpenSelection.alwaysSelectsInitialFocus,
	})
	if _descriptor_11 then
		ModalOpenSelection.alwaysSelectsInitialFocus = _descriptor_11.value
	end
	local _decorator_8 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_9 = DisplayName('selectionMode=\"always\" selects the panel even when the modal mounts already open next to a new OverlayProvider')
	local _descriptor_12 = Test(ModalOpenSelection, "alwaysSelectsMountedOpen", {
		value = ModalOpenSelection.alwaysSelectsMountedOpen,
	})
	if _descriptor_12 then
		ModalOpenSelection.alwaysSelectsMountedOpen = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ModalOpenSelection, "alwaysSelectsMountedOpen", {
		value = ModalOpenSelection.alwaysSelectsMountedOpen,
	})
	if _descriptor_13 then
		ModalOpenSelection.alwaysSelectsMountedOpen = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ModalOpenSelection, "alwaysSelectsMountedOpen", {
		value = ModalOpenSelection.alwaysSelectsMountedOpen,
	})
	if _descriptor_14 then
		ModalOpenSelection.alwaysSelectsMountedOpen = _descriptor_14.value
	end
	local _decorator_10 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A GamepadSelectionGuard clears the panel selection an always modal takes for a non-gamepad player")
	local _descriptor_15 = Test(ModalOpenSelection, "guardBeatsAlways", {
		value = ModalOpenSelection.guardBeatsAlways,
	})
	if _descriptor_15 then
		ModalOpenSelection.guardBeatsAlways = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ModalOpenSelection, "guardBeatsAlways", {
		value = ModalOpenSelection.guardBeatsAlways,
	})
	if _descriptor_16 then
		ModalOpenSelection.guardBeatsAlways = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ModalOpenSelection, "guardBeatsAlways", {
		value = ModalOpenSelection.guardBeatsAlways,
	})
	if _descriptor_17 then
		ModalOpenSelection.guardBeatsAlways = _descriptor_17.value
	end
	ModalOpenSelection = Tag("Studio")(ModalOpenSelection) or ModalOpenSelection
end
return ModalOpenSelection
