-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local GroupContext = _Contexts.GroupContext
local useGroupElement = _Contexts.useGroupElement
local GroupMeasurement = TS.import(script, script.Parent, "GroupMeasurement").GroupMeasurement
local function Group(props)
	local sizes = React.useRef({})
	local size, setSize = React.useState()
	local parentGroup = useGroupElement(props.group)
	local recalculateSize = function()
		local largestSize = Vector2.new(0, 0)
		local _exp = sizes.current
		-- ▼ ReadonlyMap.forEach ▼
		local _callback = function(elementSize)
			largestSize = Vector2.new(math.max(largestSize.X, elementSize.X), math.max(largestSize.Y, elementSize.Y))
		end
		for _k, _v in _exp do
			_callback(_v, _k, _exp)
		end
		-- ▲ ReadonlyMap.forEach ▲
		setSize(if largestSize.X > 0 or largestSize.Y > 0 then largestSize else nil)
	end
	local reportSize = function(id, absoluteSize)
		local _current = sizes.current
		local _id = id
		local _result = _current[_id]
		if _result ~= nil then
			_result = _result.X
		end
		local _condition = _result == absoluteSize.X
		if _condition then
			local _current_1 = sizes.current
			local _id_1 = id
			local _result_1 = _current_1[_id_1]
			if _result_1 ~= nil then
				_result_1 = _result_1.Y
			end
			_condition = _result_1 == absoluteSize.Y
		end
		if _condition then
			return nil
		end
		local _current_1 = sizes.current
		local _id_1 = id
		local _absoluteSize = absoluteSize
		_current_1[_id_1] = _absoluteSize
		recalculateSize()
	end
	local removeElement = function(id)
		local _current = sizes.current
		local _id = id
		_current[_id] = nil
		recalculateSize()
	end
	local context = React.useMemo(function()
		return {
			size = size,
			reportSize = reportSize,
			removeElement = removeElement,
		}
	end, { size })
	local _attributes = {
		AutomaticSize = Enum.AutomaticSize.XY,
	}
	local _result = parentGroup
	if _result ~= nil then
		_result = _result.groupSize
		if _result ~= nil then
			_result = _result.X
		end
	end
	local _condition = _result
	if _condition == nil then
		_condition = 0
	end
	_attributes.Size = UDim2.fromOffset(_condition, 0)
	_attributes.BackgroundTransparency = 1
	_attributes.Change = {
		AbsoluteSize = function(instance)
			local _result_1 = parentGroup
			if _result_1 ~= nil then
				_result_1.reportSize(instance.AbsoluteSize)
			end
		end,
	}
	return React.createElement("frame", _attributes, React.createElement(GroupContext.Provider, {
		value = context,
	}, React.createElement(GroupMeasurement, {
		enabled = props.group,
		group = parentGroup,
	}, props.children)))
end
return {
	Group = Group,
}
