-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _ = TS.import(script, script.Parent.Parent.Parent, "Providers")
local DroppableRegistryKey = _.DroppableRegistryKey
local useRegistryRegistration = _.useRegistryRegistration
local DroppableContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").DroppableContext
local function Droppable(props)
	local _binding = useRegistryRegistration(DroppableRegistryKey, function(guiObject)
		return {
			guiObject = guiObject,
			id = props.id,
			drop = function(draggedObject)
				local _result = props.onDrop
				if _result ~= nil then
					_result(draggedObject)
				end
			end,
		}
	end, { props.id, props.onDrop })
	local ref = _binding.ref
	local registration = _binding.registration
	local child = React.cloneElement(props.children, {
		ref = ref,
	})
	return React.createElement(DroppableContext.Provider, {
		value = {
			registration = registration,
		},
	}, child)
end
return {
	Droppable = Droppable,
}
