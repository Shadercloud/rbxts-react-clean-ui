-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _services = TS.import(script, TS.getModule(script, "@rbxts", "services"))
local GuiService = _services.GuiService
local RunService = _services.RunService
local UserInputService = _services.UserInputService
local gamepadInputTypes = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
}
local GamepadHelper
do
	GamepadHelper = setmetatable({}, {
		__tostring = function()
			return "GamepadHelper"
		end,
	})
	GamepadHelper.__index = GamepadHelper
	function GamepadHelper.new(...)
		local self = setmetatable({}, GamepadHelper)
		return self:constructor(...) or self
	end
	function GamepadHelper:constructor()
	end
	function GamepadHelper:isGamepadInputType(inputType)
		local _inputType = inputType
		return gamepadInputTypes[_inputType] ~= nil
	end
	function GamepadHelper:isGamepadActive()
		return self:isGamepadInputType(UserInputService:GetLastInputType())
	end
	function GamepadHelper:trySetSelectedObject(target)
		pcall(function()
			GuiService.SelectedObject = target
		end)
	end
	function GamepadHelper:isSelectionWithin(selected, scope)
		if selected == nil or scope == nil then
			return false
		end
		return selected == scope or selected:IsDescendantOf(scope)
	end
end
local function resolveTarget(target)
	if target == nil then
		return nil
	end
	local _target = target
	if type(_target) == "function" then
		return target()
	end
	return target.current
end
local function useGamepadSelection(target, options)
	if options == nil then
		options = {}
	end
	local _condition = options.enabled
	if _condition == nil then
		_condition = true
	end
	local enabled = _condition
	local targetRef = React.useRef(target)
	local optionsRef = React.useRef(options)
	React.useEffect(function()
		targetRef.current = target
		optionsRef.current = options
	end)
	React.useEffect(function()
		if not enabled then
			return nil
		end
		local lastScope
		local pendingClear
		local pendingSelect
		local resolveScope = function()
			local _scope = optionsRef.current.scope
			if _scope ~= nil then
				_scope = _scope.current
			end
			local scope = _scope
			if scope ~= nil then
				lastScope = scope
			end
			return lastScope
		end
		local isInScope = function(selected)
			if selected == nil then
				return false
			end
			if optionsRef.current.scope == nil then
				return true
			end
			return GamepadHelper:isSelectionWithin(selected, resolveScope())
		end
		local isAlways = function()
			return optionsRef.current.mode == "always"
		end
		local shouldHoldSelection = function()
			return isAlways() or GamepadHelper:isGamepadActive()
		end
		local selectTarget = function()
			local resolved = resolveTarget(targetRef.current)
			if resolved ~= nil then
				GamepadHelper:trySetSelectedObject(resolved)
			end
			return resolved ~= nil
		end
		local stopPendingSelect = function()
			local _result = pendingSelect
			if _result ~= nil then
				_result:Disconnect()
			end
			pendingSelect = nil
		end
		local clearIfInScope = function()
			if isInScope(GuiService.SelectedObject) then
				GamepadHelper:trySetSelectedObject(nil)
			end
		end
		resolveScope()
		local previousSelection = GuiService.SelectedObject
		if shouldHoldSelection() then
			if not selectTarget() then
				pendingSelect = RunService.Heartbeat:Connect(function()
					if not shouldHoldSelection() or selectTarget() then
						stopPendingSelect()
					end
				end)
			end
		else
			clearIfInScope()
		end
		local inputConnection = UserInputService.LastInputTypeChanged:Connect(function(inputType)
			if isAlways() then
				return nil
			end
			if not GamepadHelper:isGamepadInputType(inputType) then
				clearIfInScope()
				return nil
			end
			if isInScope(GuiService.SelectedObject) then
				return nil
			end
			local _result = optionsRef.current.canTakeSelection
			if _result ~= nil then
				_result = _result()
			end
			local _condition_1 = _result
			if _condition_1 == nil then
				_condition_1 = true
			end
			if _condition_1 then
				selectTarget()
			end
		end)
		local selectionConnection = if options.clearOnSelectionChange then GuiService:GetPropertyChangedSignal("SelectedObject"):Connect(function()
			if pendingClear ~= nil or shouldHoldSelection() or not isInScope(GuiService.SelectedObject) then
				return nil
			end
			pendingClear = task.defer(function()
				pendingClear = nil
				if not shouldHoldSelection() then
					clearIfInScope()
				end
			end)
		end) else nil
		return function()
			inputConnection:Disconnect()
			local _result = selectionConnection
			if _result ~= nil then
				_result:Disconnect()
			end
			stopPendingSelect()
			if pendingClear ~= nil then
				task.cancel(pendingClear)
				pendingClear = nil
			end
			if not optionsRef.current.restoreOnRelease then
				return nil
			end
			if shouldHoldSelection() then
				GamepadHelper:trySetSelectedObject(previousSelection)
			else
				clearIfInScope()
			end
		end
	end, { enabled })
end
return {
	useGamepadSelection = useGamepadSelection,
	GamepadHelper = GamepadHelper,
}
