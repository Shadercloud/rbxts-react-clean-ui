-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ModalStackContext = TS.import(script, script.Parent.Parent, "Contexts", "modal.context").ModalStackContext
local CustomInputService = TS.import(script, script.Parent.Parent, "Helpers", "input.helper").CustomInputService
local function ModalProvider(props)
	local stack, setStack = React.useState({})
	local stackRef = React.useRef(stack)
	React.useEffect(function()
		stackRef.current = stack
	end, { stack })
	local register = React.useCallback(function(layer)
		setStack(function(current)
			local _array = {}
			local _length = #_array
			local _currentLength = #current
			table.move(current, 1, _currentLength, _length + 1, _array)
			_length += _currentLength
			_array[_length + 1] = layer
			return _array
		end)
	end, {})
	local unregister = React.useCallback(function(id)
		setStack(function(current)
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback = function(layer)
				return layer.id ~= id
			end
			local _length = 0
			for _k, _v in current do
				if _callback(_v, _k - 1, current) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			return _newValue
		end)
	end, {})
	local getLayerIndex = React.useCallback(function(id)
		-- ▼ ReadonlyArray.findIndex ▼
		local _callback = function(layer)
			return layer.id == id
		end
		local _result = -1
		for _i, _v in stack do
			if _callback(_v, _i - 1, stack) == true then
				_result = _i - 1
				break
			end
		end
		-- ▲ ReadonlyArray.findIndex ▲
		return _result
	end, { stack })
	React.useEffect(function()
		local connection = CustomInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return nil
			end
			if input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode ~= Enum.KeyCode.ButtonB then
				return nil
			end
			local top = stackRef.current[#stackRef.current]
			if top ~= nil and top.closeOnEscape() then
				top.requestClose()
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, {})
	local value = React.useMemo(function()
		return {
			register = register,
			unregister = unregister,
			getLayerIndex = getLayerIndex,
		}
	end, { register, unregister, getLayerIndex })
	return React.createElement(ModalStackContext.Provider, {
		value = value,
	}, props.children)
end
return {
	ModalProvider = ModalProvider,
}
