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
local GamepadSelectionGuard = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "GamepadSelectionGuard").GamepadSelectionGuard
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local mountInScreenGui = _layout.mountInScreenGui
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local _selection = TS.import(script, script.Parent.Parent.Parent, "Helpers", "selection")
local SELECTION_SKIP_MESSAGE = _selection.SELECTION_SKIP_MESSAGE
local assertSelectionStays = _selection.assertSelectionStays
local selectObject = _selection.selectObject
local selectionUnavailable = _selection.selectionUnavailable
local waitForSelection = _selection.waitForSelection
local withSelectionReset = _selection.withSelectionReset
local function selectableTarget(name)
	return React.createElement("frame", {
		key = name,
		Selectable = true,
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
	})
end
local function guardApp(enabled)
	return React.createElement(GamepadSelectionGuard, {
		enabled = enabled,
	}, selectableTarget("Target"))
end
local function waitForTarget(host, name)
	if name == nil then
		name = "Target"
	end
	return waitForGuiObject(host, name)
end
local GamepadSelectionGuardClearing
do
	GamepadSelectionGuardClearing = setmetatable({}, {
		__tostring = function()
			return "GamepadSelectionGuardClearing"
		end,
	})
	GamepadSelectionGuardClearing.__index = GamepadSelectionGuardClearing
	function GamepadSelectionGuardClearing.new(...)
		local self = setmetatable({}, GamepadSelectionGuardClearing)
		return self:constructor(...) or self
	end
	function GamepadSelectionGuardClearing:constructor()
	end
	function GamepadSelectionGuardClearing:rendersChildren()
		withMounted(200, 200, guardApp(true), function(mounted)
			local target = waitForTarget(mounted.host)
			Assert:equal(target.Parent, mounted.host, "Expected the child frame to sit directly under the host")
			Assert:equal(#mounted.host:GetChildren(), 1, "Expected the guard to add no instances")
		end)
	end
	function GamepadSelectionGuardClearing:clearsOnEnable()
		withSelectionReset(function()
			withMounted(200, 200, guardApp(false), function(mounted)
				selectObject(waitForTarget(mounted.host))
				mounted.update(guardApp(true))
				waitForSelection(nil, "after enabling the guard")
			end)
		end)
	end
	function GamepadSelectionGuardClearing:clearsLaterSelection()
		withSelectionReset(function()
			withMounted(200, 200, guardApp(true), function(mounted)
				selectObject(waitForTarget(mounted.host))
				waitForSelection(nil, "after selecting under an enabled guard")
			end)
		end)
	end
	function GamepadSelectionGuardClearing:disabledKeeps()
		withSelectionReset(function()
			withMounted(200, 200, guardApp(false), function(mounted)
				local target = waitForTarget(mounted.host)
				selectObject(target)
				assertSelectionStays(target, "under a disabled guard")
			end)
		end)
	end
	function GamepadSelectionGuardClearing:disableDisconnects()
		withSelectionReset(function()
			withMounted(200, 200, guardApp(true), function(mounted)
				local target = waitForTarget(mounted.host)
				mounted.update(guardApp(false))
				selectObject(target)
				assertSelectionStays(target, "after disabling the guard")
			end)
		end)
	end
	function GamepadSelectionGuardClearing:unmountDisconnects()
		withSelectionReset(function()
			local guarded = mountInScreenGui(200, 200, guardApp(true))
			local guardedMounted = true
			TS.try(function()
				withMounted(200, 200, selectableTarget("Outside"), function(other)
					local outside = waitForTarget(other.host, "Outside")
					waitForTarget(guarded.host)
					guarded.unmount()
					guardedMounted = false
					selectObject(outside)
					assertSelectionStays(outside, "after the guard unmounted")
				end)
			end, nil, function()
				if guardedMounted then
					guarded.unmount()
				end
			end)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Renders its children unchanged with no instance of its own")
	local _descriptor = Test(GamepadSelectionGuardClearing, "rendersChildren", {
		value = GamepadSelectionGuardClearing.rendersChildren,
	})
	if _descriptor then
		GamepadSelectionGuardClearing.rendersChildren = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(GamepadSelectionGuardClearing, "rendersChildren", {
		value = GamepadSelectionGuardClearing.rendersChildren,
	})
	if _descriptor_1 then
		GamepadSelectionGuardClearing.rendersChildren = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(GamepadSelectionGuardClearing, "rendersChildren", {
		value = GamepadSelectionGuardClearing.rendersChildren,
	})
	if _descriptor_2 then
		GamepadSelectionGuardClearing.rendersChildren = _descriptor_2.value
	end
	local _decorator_2 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Turning the guard on clears a selection that already exists")
	local _descriptor_3 = Test(GamepadSelectionGuardClearing, "clearsOnEnable", {
		value = GamepadSelectionGuardClearing.clearsOnEnable,
	})
	if _descriptor_3 then
		GamepadSelectionGuardClearing.clearsOnEnable = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(GamepadSelectionGuardClearing, "clearsOnEnable", {
		value = GamepadSelectionGuardClearing.clearsOnEnable,
	})
	if _descriptor_4 then
		GamepadSelectionGuardClearing.clearsOnEnable = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(GamepadSelectionGuardClearing, "clearsOnEnable", {
		value = GamepadSelectionGuardClearing.clearsOnEnable,
	})
	if _descriptor_5 then
		GamepadSelectionGuardClearing.clearsOnEnable = _descriptor_5.value
	end
	local _decorator_4 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A selection made while the guard is on is cleared a frame later")
	local _descriptor_6 = Test(GamepadSelectionGuardClearing, "clearsLaterSelection", {
		value = GamepadSelectionGuardClearing.clearsLaterSelection,
	})
	if _descriptor_6 then
		GamepadSelectionGuardClearing.clearsLaterSelection = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(GamepadSelectionGuardClearing, "clearsLaterSelection", {
		value = GamepadSelectionGuardClearing.clearsLaterSelection,
	})
	if _descriptor_7 then
		GamepadSelectionGuardClearing.clearsLaterSelection = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(GamepadSelectionGuardClearing, "clearsLaterSelection", {
		value = GamepadSelectionGuardClearing.clearsLaterSelection,
	})
	if _descriptor_8 then
		GamepadSelectionGuardClearing.clearsLaterSelection = _descriptor_8.value
	end
	local _decorator_6 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("With enabled={false} a selection is left alone")
	local _descriptor_9 = Test(GamepadSelectionGuardClearing, "disabledKeeps", {
		value = GamepadSelectionGuardClearing.disabledKeeps,
	})
	if _descriptor_9 then
		GamepadSelectionGuardClearing.disabledKeeps = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(GamepadSelectionGuardClearing, "disabledKeeps", {
		value = GamepadSelectionGuardClearing.disabledKeeps,
	})
	if _descriptor_10 then
		GamepadSelectionGuardClearing.disabledKeeps = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(GamepadSelectionGuardClearing, "disabledKeeps", {
		value = GamepadSelectionGuardClearing.disabledKeeps,
	})
	if _descriptor_11 then
		GamepadSelectionGuardClearing.disabledKeeps = _descriptor_11.value
	end
	local _decorator_8 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Switching the guard off stops it clearing selections made afterwards")
	local _descriptor_12 = Test(GamepadSelectionGuardClearing, "disableDisconnects", {
		value = GamepadSelectionGuardClearing.disableDisconnects,
	})
	if _descriptor_12 then
		GamepadSelectionGuardClearing.disableDisconnects = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(GamepadSelectionGuardClearing, "disableDisconnects", {
		value = GamepadSelectionGuardClearing.disableDisconnects,
	})
	if _descriptor_13 then
		GamepadSelectionGuardClearing.disableDisconnects = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(GamepadSelectionGuardClearing, "disableDisconnects", {
		value = GamepadSelectionGuardClearing.disableDisconnects,
	})
	if _descriptor_14 then
		GamepadSelectionGuardClearing.disableDisconnects = _descriptor_14.value
	end
	local _decorator_10 = Skip(selectionUnavailable, SELECTION_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("After the guard unmounts a new selection elsewhere is no longer cleared")
	local _descriptor_15 = Test(GamepadSelectionGuardClearing, "unmountDisconnects", {
		value = GamepadSelectionGuardClearing.unmountDisconnects,
	})
	if _descriptor_15 then
		GamepadSelectionGuardClearing.unmountDisconnects = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(GamepadSelectionGuardClearing, "unmountDisconnects", {
		value = GamepadSelectionGuardClearing.unmountDisconnects,
	})
	if _descriptor_16 then
		GamepadSelectionGuardClearing.unmountDisconnects = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(GamepadSelectionGuardClearing, "unmountDisconnects", {
		value = GamepadSelectionGuardClearing.unmountDisconnects,
	})
	if _descriptor_17 then
		GamepadSelectionGuardClearing.unmountDisconnects = _descriptor_17.value
	end
	GamepadSelectionGuardClearing = Tag("Studio")(GamepadSelectionGuardClearing) or GamepadSelectionGuardClearing
end
return GamepadSelectionGuardClearing
