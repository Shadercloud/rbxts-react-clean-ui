-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local withMounted = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout").withMounted
local _modal = TS.import(script, script.Parent.Parent.Parent, "Helpers", "modal")
local MODAL_HOST_HEIGHT = _modal.MODAL_HOST_HEIGHT
local MODAL_HOST_WIDTH = _modal.MODAL_HOST_WIDTH
local closeModal = _modal.closeModal
local modalSelectionApp = _modal.modalSelectionApp
local openModal = _modal.openModal
local waitForOutside = _modal.waitForOutside
local _selection = TS.import(script, script.Parent.Parent.Parent, "Helpers", "selection")
local SELECTION_SKIP_MESSAGE = _selection.SELECTION_SKIP_MESSAGE
local assertSelectionStays = _selection.assertSelectionStays
local selectObject = _selection.selectObject
local selectionUnavailable = _selection.selectionUnavailable
local waitForSelection = _selection.waitForSelection
local withSelectionReset = _selection.withSelectionReset
local ModalCloseSelection
do
	ModalCloseSelection = setmetatable({}, {
		__tostring = function()
			return "ModalCloseSelection"
		end,
	})
	ModalCloseSelection.__index = ModalCloseSelection
	function ModalCloseSelection.new(...)
		local self = setmetatable({}, ModalCloseSelection)
		return self:constructor(...) or self
	end
	function ModalCloseSelection:constructor()
	end
	function ModalCloseSelection:alwaysRestores()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				local outside = waitForOutside(mounted)
				selectObject(outside)
				local opened = openModal(mounted, {
					mode = "always",
				})
				waitForSelection(opened.panel, "while the always modal is open")
				closeModal(mounted, {
					mode = "always",
				})
				waitForSelection(outside, "after closing the always modal")
			end)
		end)
	end
	function ModalCloseSelection:defaultClearsInside()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				selectObject(waitForOutside(mounted))
				local opened = openModal(mounted, {})
				selectObject(opened.panel)
				closeModal(mounted, {})
				waitForSelection(nil, "after closing a default modal holding the selection")
			end)
		end)
	end
	function ModalCloseSelection:defaultKeepsOutside()
		withSelectionReset(function()
			withMounted(MODAL_HOST_WIDTH, MODAL_HOST_HEIGHT, modalSelectionApp({
				open = false,
			}), function(mounted)
				local outside = waitForOutside(mounted)
				selectObject(outside)
				openModal(mounted, {})
				closeModal(mounted, {})
				assertSelectionStays(outside, "after closing a default modal")
			end)
		end)
	end
	local _decorator = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_1 = DisplayName('selectionMode=\"always\" hands the selection back to what was selected before the modal opened')
	local _descriptor = Test(ModalCloseSelection, "alwaysRestores", {
		value = ModalCloseSelection.alwaysRestores,
	})
	if _descriptor then
		ModalCloseSelection.alwaysRestores = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ModalCloseSelection, "alwaysRestores", {
		value = ModalCloseSelection.alwaysRestores,
	})
	if _descriptor_1 then
		ModalCloseSelection.alwaysRestores = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ModalCloseSelection, "alwaysRestores", {
		value = ModalCloseSelection.alwaysRestores,
	})
	if _descriptor_2 then
		ModalCloseSelection.alwaysRestores = _descriptor_2.value
	end
	local _decorator_2 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("With the default selectionMode and no gamepad, a selection left inside the modal is cleared on close")
	local _descriptor_3 = Test(ModalCloseSelection, "defaultClearsInside", {
		value = ModalCloseSelection.defaultClearsInside,
	})
	if _descriptor_3 then
		ModalCloseSelection.defaultClearsInside = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ModalCloseSelection, "defaultClearsInside", {
		value = ModalCloseSelection.defaultClearsInside,
	})
	if _descriptor_4 then
		ModalCloseSelection.defaultClearsInside = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ModalCloseSelection, "defaultClearsInside", {
		value = ModalCloseSelection.defaultClearsInside,
	})
	if _descriptor_5 then
		ModalCloseSelection.defaultClearsInside = _descriptor_5.value
	end
	local _decorator_4 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("With the default selectionMode and no gamepad, a selection outside the modal survives the close")
	local _descriptor_6 = Test(ModalCloseSelection, "defaultKeepsOutside", {
		value = ModalCloseSelection.defaultKeepsOutside,
	})
	if _descriptor_6 then
		ModalCloseSelection.defaultKeepsOutside = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ModalCloseSelection, "defaultKeepsOutside", {
		value = ModalCloseSelection.defaultKeepsOutside,
	})
	if _descriptor_7 then
		ModalCloseSelection.defaultKeepsOutside = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ModalCloseSelection, "defaultKeepsOutside", {
		value = ModalCloseSelection.defaultKeepsOutside,
	})
	if _descriptor_8 then
		ModalCloseSelection.defaultKeepsOutside = _descriptor_8.value
	end
	ModalCloseSelection = Tag("Studio")(ModalCloseSelection) or ModalCloseSelection
end
return ModalCloseSelection
