-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ElementHelper
do
	ElementHelper = setmetatable({}, {
		__tostring = function()
			return "ElementHelper"
		end,
	})
	ElementHelper.__index = ElementHelper
	function ElementHelper.new(...)
		local self = setmetatable({}, ElementHelper)
		return self:constructor(...) or self
	end
	function ElementHelper:constructor()
	end
	function ElementHelper:isHostElement(element)
		local _type = element.type
		return type(_type) == "string"
	end
	function ElementHelper:assignRef(ref, instance)
		local _ref = ref
		if type(_ref) == "function" then
			ref(instance)
		elseif ref then
			ref.current = instance
		end
	end
	function ElementHelper:getEventKey(name)
		return React.Event[name]
	end
	function ElementHelper:cloneWithEvents(element, props, events)
		local config = {}
		for key, value in pairs(props) do
			config[key] = value
		end
		local elementProps = element.props
		if self:isHostElement(element) then
			for name, handler in pairs(events) do
				local key = self:getEventKey(name)
				local original = elementProps[key]
				config[key] = function(...)
					local args = { ... }
					local _result = original
					if _result ~= nil then
						_result(unpack(args))
					end
					handler(unpack(args))
				end
			end
		else
			local originalEvents = elementProps.Event
			local _result
			if originalEvents ~= nil then
				local _object = table.clone(originalEvents)
				setmetatable(_object, nil)
				_result = _object
			else
				_result = {}
			end
			local mergedEvents = _result
			for name, handler in pairs(events) do
				local _original = originalEvents
				if _original ~= nil then
					_original = _original[name]
				end
				local original = _original
				mergedEvents[name] = function(...)
					local args = { ... }
					local _result_1 = original
					if _result_1 ~= nil then
						_result_1(unpack(args))
					end
					handler(unpack(args))
				end
			end
			config.Event = mergedEvents
		end
		return React.cloneElement(element, config)
	end
end
return {
	ElementHelper = ElementHelper,
}
