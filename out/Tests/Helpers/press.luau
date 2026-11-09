-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local findHostFiber = TS.import(script, script.Parent, "fiber").findHostFiber
local function withPress(kind, fn)
	local changed = Instance.new("BindableEvent")
	local fields = {
		UserInputType = if kind == "Touch" then Enum.UserInputType.Touch else Enum.UserInputType.MouseButton1,
		UserInputState = Enum.UserInputState.Begin,
		GetPropertyChangedSignal = function()
			return changed.Event
		end,
	}
	TS.try(function()
		fn({
			input = fields,
			finish = function(state)
				fields.UserInputState = state
				changed:Fire()
				task.wait()
			end,
		})
	end, nil, function()
		changed:Destroy()
	end)
end
local function gamepadInput()
	return {
		UserInputType = Enum.UserInputType.Gamepad1,
		KeyCode = Enum.KeyCode.ButtonA,
		UserInputState = Enum.UserInputState.Begin,
	}
end
local function releaseState(label)
	return if label == "Cancel" then Enum.UserInputState.Cancel else Enum.UserInputState.End
end
local function hostHandler(mounted, instance, eventName)
	local eventKey = React.Event[eventName]
	local _result = findHostFiber(mounted, instance).memoizedProps
	if _result ~= nil then
		_result = _result[eventKey]
	end
	return _result
end
return {
	withPress = withPress,
	gamepadInput = gamepadInput,
	releaseState = releaseState,
	hostHandler = hostHandler,
}
