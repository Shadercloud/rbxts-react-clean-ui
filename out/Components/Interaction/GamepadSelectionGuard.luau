-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useGamepadSelection = TS.import(script, script.Parent.Parent.Parent, "Helpers", "gamepad.helper").useGamepadSelection
local function GamepadSelectionGuard(props)
	local _object = {}
	local _left = "enabled"
	local _condition = props.enabled
	if _condition == nil then
		_condition = true
	end
	_object[_left] = _condition
	_object.clearOnSelectionChange = true
	useGamepadSelection(nil, _object)
	return React.createElement(React.Fragment, nil, props.children)
end
return {
	GamepadSelectionGuard = GamepadSelectionGuard,
}
