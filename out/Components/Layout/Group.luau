-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
-- import { HttpService } from "@rbxts/services";
local RegistryContext = TS.import(script, script.Parent.Parent.Parent, "Providers").RegistryContext
local GroupContext = React.createContext(nil)
local function GroupElement(props)
	local registry = React.useContext(RegistryContext)
	local context = React.useContext(GroupContext)
	local _result = registry
	if _result ~= nil then
		_result = _result.GetNextId()
	end
	local _condition = _result
	if _condition == nil then
		_condition = ""
	end
	local id = React.useRef(_condition).current
	local enabled = props.enabled == true and context ~= nil
	local _exp = function()
		if not enabled then
			local _result_1 = context
			if _result_1 ~= nil then
				_result_1.removeElement(id)
			end
			return nil
		end
		return function()
			context.removeElement(id)
		end
	end
	local _result_1 = context
	if _result_1 ~= nil then
		_result_1 = _result_1.removeElement
	end
	React.useEffect(_exp, { enabled, _result_1 })
	if not enabled then
		return props.children
	end
	local _result_2 = props.padding
	if _result_2 ~= nil then
		_result_2 = _result_2.left
	end
	local _condition_1 = _result_2
	if _condition_1 == nil then
		_condition_1 = 0
	end
	local _result_3 = props.padding
	if _result_3 ~= nil then
		_result_3 = _result_3.right
	end
	local _condition_2 = _result_3
	if _condition_2 == nil then
		_condition_2 = 0
	end
	local horizontalPadding = _condition_1 + _condition_2
	local _result_4 = props.padding
	if _result_4 ~= nil then
		_result_4 = _result_4.top
	end
	local _condition_3 = _result_4
	if _condition_3 == nil then
		_condition_3 = 0
	end
	local _result_5 = props.padding
	if _result_5 ~= nil then
		_result_5 = _result_5.bottom
	end
	local _condition_4 = _result_5
	if _condition_4 == nil then
		_condition_4 = 0
	end
	local verticalPadding = _condition_3 + _condition_4
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Change = {
			AbsoluteSize = function(instance)
				context.reportSize(id, Vector2.new(instance.AbsoluteSize.X + horizontalPadding, instance.AbsoluteSize.Y + verticalPadding))
			end,
		},
	}, props.children)
end
local function getMaxVector2(map)
	local max
	for _, vector in map do
		if max == nil then
			max = vector
		else
			max = Vector2.new(math.max(max.X, vector.X), math.max(max.Y, vector.Y))
		end
	end
	return max
end
local Group = React.forwardRef(function(props, _ref)
	local sizes, setSizes = React.useState({})
	local size = React.useMemo(function()
		return getMaxVector2(sizes) or Vector2.zero
	end, { sizes })
	local reportSize = React.useCallback(function(id, reportedSize)
		setSizes(function(currentSizes)
			local _currentSizes = currentSizes
			local _id = id
			local current = _currentSizes[_id]
			if current ~= nil and current.X == reportedSize.X and current.Y == reportedSize.Y then
				return currentSizes
			end
			local newSizes = {}
			for elementId, elementSize in currentSizes do
				newSizes[elementId] = elementSize
			end
			local _id_1 = id
			local _reportedSize = reportedSize
			newSizes[_id_1] = _reportedSize
			return newSizes
		end)
	end, {})
	local removeElement = React.useCallback(function(id)
		setSizes(function(currentSizes)
			local _currentSizes = currentSizes
			local _id = id
			if not (_currentSizes[_id] ~= nil) then
				return currentSizes
			end
			local newSizes = {}
			for elementId, elementSize in currentSizes do
				if elementId ~= id then
					newSizes[elementId] = elementSize
				end
			end
			return newSizes
		end)
	end, {})
	local context = React.useMemo(function()
		return {
			size = size,
			sizes = sizes,
			reportSize = reportSize,
			removeElement = removeElement,
		}
	end, { size, sizes, reportSize, removeElement })
	return React.createElement(GroupContext.Provider, {
		value = context,
	}, props.children)
end)
Group.Element = GroupElement
return {
	GroupContext = GroupContext,
	Group = Group,
}
