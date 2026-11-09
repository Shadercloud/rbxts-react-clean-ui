-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local function isPointerPress(input)
	if input == nil then
		return false
	end
	return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
end
local function usePressRelease(onRelease)
	local onReleaseRef = React.useRef(onRelease)
	onReleaseRef.current = onRelease
	local connectionsRef = React.useRef()
	React.useEffect(function()
		return function()
			local _result = connectionsRef.current
			if _result ~= nil then
				-- ▼ ReadonlyMap.forEach ▼
				local _callback = function(connection)
					return connection:Disconnect()
				end
				for _k, _v in _result do
					_callback(_v, _k, _result)
				end
				-- ▲ ReadonlyMap.forEach ▲
			end
			local _result_1 = connectionsRef.current
			if _result_1 ~= nil then
				table.clear(_result_1)
			end
		end
	end, {})
	return React.useCallback(function(button, input)
		if connectionsRef.current == nil then
			connectionsRef.current = {}
		end
		local connections = connectionsRef.current
		local _input = input
		if connections[_input] ~= nil then
			return nil
		end
		local connection
		connection = input:GetPropertyChangedSignal("UserInputState"):Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End and input.UserInputState ~= Enum.UserInputState.Cancel then
				return nil
			end
			connection:Disconnect()
			local _input_1 = input
			connections[_input_1] = nil
			local _result = onReleaseRef.current
			if _result ~= nil then
				_result(button, input)
			end
		end)
		local _input_1 = input
		connections[_input_1] = connection
	end, {})
end
return {
	isPointerPress = isPointerPress,
	usePressRelease = usePressRelease,
}
