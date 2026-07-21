-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local HttpService = TS.import(script, TS.getModule(script, "@rbxts", "services")).HttpService
local GroupContext = React.createContext(nil)
local function GroupElement(props)
	local context = React.useContext(GroupContext)
	local id = React.useRef(HttpService:GenerateGUID(false)).current
	local _result = context
	if _result ~= nil then
		_result = _result.removeElement
	end
	local removeElementRef = React.useRef(_result)
	local _result_1 = context
	if _result_1 ~= nil then
		_result_1 = _result_1.removeElement
	end
	removeElementRef.current = _result_1
	React.useEffect(function()
		return function()
			local _result_2 = removeElementRef.current
			if _result_2 ~= nil then
				_result_2(id)
			end
		end
	end, {})
	if not props.enabled or context == nil then
		return props.children
	end
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Change = {
			AbsoluteSize = function(instance)
				local _exp = instance.AbsoluteSize.X
				local _result_2 = props.padding
				if _result_2 ~= nil then
					_result_2 = _result_2.left
				end
				local _condition = _result_2
				if _condition == nil then
					_condition = 0
				end
				local _exp_1 = _exp + _condition
				local _result_3 = props.padding
				if _result_3 ~= nil then
					_result_3 = _result_3.right
				end
				local _condition_1 = _result_3
				if _condition_1 == nil then
					_condition_1 = 0
				end
				local _exp_2 = _exp_1 + _condition_1
				local _exp_3 = instance.AbsoluteSize.Y
				local _result_4 = props.padding
				if _result_4 ~= nil then
					_result_4 = _result_4.top
				end
				local _condition_2 = _result_4
				if _condition_2 == nil then
					_condition_2 = 0
				end
				local _exp_4 = _exp_3 + _condition_2
				local _result_5 = props.padding
				if _result_5 ~= nil then
					_result_5 = _result_5.bottom
				end
				local _condition_3 = _result_5
				if _condition_3 == nil then
					_condition_3 = 0
				end
				context.reportSize(id, Vector2.new(_exp_2, _exp_4 + _condition_3))
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
local Group
do
	local super = Component
	Group = setmetatable({}, {
		__tostring = function()
			return "Group"
		end,
		__index = super,
	})
	Group.__index = Group
	function Group.new(...)
		local self = setmetatable({}, Group)
		return self:constructor(...) or self
	end
	function Group:constructor(...)
		super.constructor(self, ...)
		self.state = {
			size = Vector2.new(0, 0),
			sizes = {},
		}
	end
	function Group:render()
		local context = {
			size = self.state.size,
			sizes = self.state.sizes,
			reportSize = function(id, size)
				local _sizes = self.state.sizes
				local _id = id
				local current = _sizes[_id]
				if current ~= nil and current.X == size.X and current.Y == size.Y then
					return nil
				end
				self:setState(function(state)
					local sizes = {}
					for elementId, elementSize in state.sizes do
						sizes[elementId] = elementSize
					end
					local _id_1 = id
					local _size = size
					sizes[_id_1] = _size
					return {
						sizes = sizes,
						size = getMaxVector2(sizes) or Vector2.new(0, 0),
					}
				end)
			end,
			removeElement = function(id)
				local _sizes = self.state.sizes
				local _id = id
				if not (_sizes[_id] ~= nil) then
					return nil
				end
				self:setState(function(state)
					local sizes = {}
					for elementId, elementSize in state.sizes do
						if elementId ~= id then
							sizes[elementId] = elementSize
						end
					end
					return {
						sizes = sizes,
						size = getMaxVector2(sizes) or Vector2.new(0, 0),
					}
				end)
			end,
		}
		return React.createElement(GroupContext.Provider, {
			value = context,
		}, self.props.children)
	end
	Group.Element = GroupElement
	Group.contextType = GroupContext
	Group = ReactComponent(Group) or Group
end
return {
	GroupContext = GroupContext,
	Group = Group,
}
