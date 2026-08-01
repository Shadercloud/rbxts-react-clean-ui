-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
-- This registry is used to keep a global map of GuiObjects => React components
-- For example Droppable zones use this to register themselves
local DroppableRegistryKey = {
	name = "Droppable",
}
local DraggableRegistryKey = {
	name = "Draggable",
}
local RegistryContext = React.createContext(nil)
local function RegistryProvider(props)
	local entries = React.useRef({})
	local register = function(guiObject, key, value)
		local _current = entries.current
		local _name = key.name
		local keyEntries = _current[_name]
		if keyEntries == nil then
			keyEntries = {}
			local _current_1 = entries.current
			local _name_1 = key.name
			local _keyEntries = keyEntries
			_current_1[_name_1] = _keyEntries
		end
		local _keyEntries = keyEntries
		local _guiObject = guiObject
		local _value = value
		_keyEntries[_guiObject] = _value
	end
	local unregister = function(guiObject, key)
		local _current = entries.current
		local _name = key.name
		local keyEntries = _current[_name]
		if keyEntries == nil then
			return nil
		end
		local _guiObject = guiObject
		keyEntries[_guiObject] = nil
		-- ▼ ReadonlyMap.size ▼
		local _size = 0
		for _ in keyEntries do
			_size += 1
		end
		-- ▲ ReadonlyMap.size ▲
		if _size == 0 then
			local _current_1 = entries.current
			local _name_1 = key.name
			_current_1[_name_1] = nil
		end
	end
	local get = function(guiObject, key)
		local _current = entries.current
		local _name = key.name
		local _result = _current[_name]
		if _result ~= nil then
			local _guiObject = guiObject
			_result = _result[_guiObject]
		end
		return _result
	end
	local getAll = function(key)
		local _current = entries.current
		local _name = key.name
		local keyEntries = _current[_name]
		if keyEntries == nil then
			return {}
		end
		local result = {}
		for _, value in keyEntries do
			table.insert(result, value)
		end
		return result
	end
	local GetNextId = function()
		return HttpService:GenerateGUID(false)
	end
	local contextValue = {
		register = register,
		unregister = unregister,
		get = get,
		getAll = getAll,
		GetNextId = GetNextId,
	}
	return React.createElement(RegistryContext.Provider, {
		value = contextValue,
	}, props.children)
end
local function useRegistryRegistration(key, createRegistration, dependencies)
	local registry = React.useContext(RegistryContext)
	local guiObject, setGuiObject = React.useState()
	local _exp = function()
		if guiObject == nil then
			return nil
		end
		return createRegistration(guiObject)
	end
	local _array = { guiObject }
	local _length = #_array
	table.move(dependencies, 1, #dependencies, _length + 1, _array)
	local registration = React.useMemo(_exp, _array)
	React.useEffect(function()
		if registry == nil or guiObject == nil or registration == nil then
			return nil
		end
		registry.register(guiObject, key, registration)
		return function()
			registry.unregister(guiObject, key)
		end
	end, { registry, guiObject, key, registration })
	return {
		ref = setGuiObject,
		guiObject = guiObject,
		registration = registration,
	}
end
return {
	RegistryProvider = RegistryProvider,
	useRegistryRegistration = useRegistryRegistration,
	DroppableRegistryKey = DroppableRegistryKey,
	DraggableRegistryKey = DraggableRegistryKey,
	RegistryContext = RegistryContext,
}
