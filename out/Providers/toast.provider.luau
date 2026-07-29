-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ToastContext = TS.import(script, script.Parent.Parent, "Contexts", "toast.context").ToastContext
local nextToastId = 0
local function generateId()
	nextToastId += 1
	return `toast-{nextToastId}`
end
local function ToastProvider(props)
	local toasts, setToasts = React.useState({})
	local show = React.useCallback(function(options)
		local _condition = options.id
		if _condition == nil then
			_condition = generateId()
		end
		local id = _condition
		setToasts(function(current)
			local _array = {}
			local _length = #_array
			local _currentLength = #current
			table.move(current, 1, _currentLength, _length + 1, _array)
			_length += _currentLength
			local _object = table.clone(options)
			setmetatable(_object, nil)
			_object.id = id
			_array[_length + 1] = _object
			return _array
		end)
		return id
	end, {})
	local update = React.useCallback(function(id, options)
		setToasts(function(current)
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#current)
			local _callback = function(toast)
				local _result
				if toast.id == id then
					local _object = table.clone(toast)
					setmetatable(_object, nil)
					for _k, _v in options do
						_object[_k] = _v
					end
					_object.id = id
					_result = _object
				else
					_result = toast
				end
				return _result
			end
			for _k, _v in current do
				_newValue[_k] = _callback(_v, _k - 1, current)
			end
			-- ▲ ReadonlyArray.map ▲
			return _newValue
		end)
	end, {})
	local dismiss = React.useCallback(function(id)
		setToasts(function(current)
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback = function(toast)
				return toast.id ~= id
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
	local dismissAll = React.useCallback(function()
		setToasts({})
	end, {})
	local value = React.useMemo(function()
		return {
			toasts = toasts,
			show = show,
			update = update,
			dismiss = dismiss,
			dismissAll = dismissAll,
		}
	end, { toasts, show, update, dismiss, dismissAll })
	return React.createElement(ToastContext.Provider, {
		value = value,
	}, props.children)
end
return {
	ToastProvider = ToastProvider,
}
