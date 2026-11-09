-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Assert = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out).Assert
local function findHostFiber(mounted, instance)
	local internalRoot = (mounted.root)._internalRoot
	local pending = { internalRoot.current }
	while #pending > 0 do
		-- ▼ Array.pop ▼
		local _length = #pending
		local _result = pending[_length]
		pending[_length] = nil
		-- ▲ Array.pop ▲
		local fiber = _result
		if fiber.stateNode == instance then
			return fiber
		end
		if fiber.child ~= nil then
			local _child = fiber.child
			table.insert(pending, _child)
		end
		if fiber.sibling ~= nil then
			local _sibling = fiber.sibling
			table.insert(pending, _sibling)
		end
	end
	return Assert:fail(`Expected a mounted host fiber for {instance:GetFullName()}`)
end
local function activateButton(mounted, button)
	local activatedKey = React.Event.Activated
	local _result = findHostFiber(mounted, button).memoizedProps
	if _result ~= nil then
		_result = _result[activatedKey]
	end
	local handler = _result
	Assert:notUndefined(handler, `Expected {button.Name} to have an Activated handler`)
	handler(button, {}, 1)
	task.wait()
end
local function fireHostEvent(mounted, instance, eventName, ...)
	local args = { ... }
	local eventKey = React.Event[eventName]
	local _result = findHostFiber(mounted, instance).memoizedProps
	if _result ~= nil then
		_result = _result[eventKey]
	end
	local handler = _result
	Assert:notUndefined(handler, `Expected {instance.Name} to have a {eventName} handler`)
	handler(instance, unpack(args))
	task.wait()
end
return {
	findHostFiber = findHostFiber,
	activateButton = activateButton,
	fireHostEvent = fireHostEvent,
}
