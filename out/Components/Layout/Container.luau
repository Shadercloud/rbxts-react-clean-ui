-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local useGroupElement = TS.import(script, script.Parent.Parent.Parent, "Contexts").useGroupElement
local GroupMeasurement = TS.import(script, script.Parent, "GroupMeasurement").GroupMeasurement
local function Container(props)
	local group = useGroupElement(props.group)
	local _attributes = {}
	local _exp = props
	local _result = group
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
	_attributes.Size = SizeHelper:GetSize(_exp, UDim2.fromOffset(_condition, 0))
	_attributes.AutomaticSize = SizeHelper:GetAutoSize(props)
	_attributes.Position = SizeHelper:GetPosition(props)
	_attributes.AnchorPoint = SizeHelper:GetAnchor(props)
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 1
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.ZIndex = props.ZIndex
	_attributes.Change = props.Change
	return React.createElement("frame", _attributes, React.createElement(GroupMeasurement, {
		enabled = props.group,
		group = group,
	}, props.children))
end
return {
	Container = Container,
}
