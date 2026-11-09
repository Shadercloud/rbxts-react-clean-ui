-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Assert = _lunit.Assert
local Runtime = _lunit.Runtime
local GuiService = TS.import(script, TS.getModule(script, "@rbxts", "services")).GuiService
local GamepadHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "gamepad.helper").GamepadHelper
local settleFrames = TS.import(script, script.Parent, "layout").settleFrames
local SELECTION_SKIP_MESSAGE = "Requires Roblox Studio, a GuiService.SelectedObject that accepts a GuiObject under the CoreGui test host, and a non-gamepad last input type."
local selectionProbe
local function probeSelection()
	local coreGui = game:FindFirstChild("CoreGui")
	if coreGui == nil then
		return false
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = "SelectionProbe"
	local frame = Instance.new("Frame")
	frame.Name = "SelectionProbeTarget"
	frame.Selectable = true
	frame.Size = UDim2.fromOffset(10, 10)
	frame.Parent = gui
	gui.Parent = coreGui
	local previous = GuiService.SelectedObject
	local assigned = pcall(function()
		GuiService.SelectedObject = frame
	end)
	local accepted = assigned and GuiService.SelectedObject == frame
	pcall(function()
		GuiService.SelectedObject = previous
	end)
	gui:Destroy()
	return accepted
end
local function selectionUnavailable()
	if not Runtime.isRoblox() then
		return true
	end
	if selectionProbe == nil then
		selectionProbe = probeSelection()
	end
	return not selectionProbe or GamepadHelper:isGamepadActive()
end
local function resetSelection()
	GamepadHelper:trySetSelectedObject(nil)
end
local function withSelectionReset(fn)
	resetSelection()
	TS.try(function()
		fn()
	end, nil, function()
		resetSelection()
	end)
end
local function selectObject(target)
	GamepadHelper:trySetSelectedObject(target)
	Assert:equal(GuiService.SelectedObject, target, `Expected GuiService.SelectedObject to accept {target:GetFullName()} before the check`)
end
local function waitForSelection(expected, label, frames)
	if frames == nil then
		frames = 30
	end
	do
		local attempt = 0
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				attempt += 1
			else
				_shouldIncrement = true
			end
			if not (attempt < frames) then
				break
			end
			if GuiService.SelectedObject == expected then
				return nil
			end
			task.wait()
		end
	end
	local actual = GuiService.SelectedObject
	Assert:fail(`{label}: expected GuiService.SelectedObject to be {if expected == nil then "nil" else expected:GetFullName()} within {frames} frames, got {if actual == nil then "nil" else actual:GetFullName()}`)
end
local function assertSelectionStays(expected, label, frames)
	if frames == nil then
		frames = 5
	end
	settleFrames(frames)
	local actual = GuiService.SelectedObject
	Assert["true"](Assert, actual == expected, `{label}: expected GuiService.SelectedObject to stay {if expected == nil then "nil" else expected:GetFullName()}, got {if actual == nil then "nil" else actual:GetFullName()}`)
end
return {
	selectionUnavailable = selectionUnavailable,
	resetSelection = resetSelection,
	withSelectionReset = withSelectionReset,
	selectObject = selectObject,
	waitForSelection = waitForSelection,
	assertSelectionStays = assertSelectionStays,
	SELECTION_SKIP_MESSAGE = SELECTION_SKIP_MESSAGE,
}
