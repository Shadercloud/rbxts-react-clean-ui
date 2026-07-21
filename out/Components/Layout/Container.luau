-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local _Group = TS.import(script, script.Parent, "Group")
local Group = _Group.Group
local GroupContext = _Group.GroupContext
local function Container(props)
	local group = React.useContext(GroupContext)
	local _attributes = {}
	local _exp = props
	local _result
	if props.group then
		local _result_1 = group
		if _result_1 ~= nil then
			_result_1 = _result_1.size
			if _result_1 ~= nil then
				_result_1 = _result_1.X
			end
		end
		local _condition = _result_1
		if _condition == nil then
			_condition = 0
		end
		_result = _condition
	else
		_result = 0
	end
	_attributes.Size = SizeHelper:GetSize(_exp, UDim2.fromOffset(_result, 0))
	_attributes.AutomaticSize = SizeHelper:GetAutoSize(props)
	_attributes.Position = SizeHelper:GetPosition(props)
	_attributes.AnchorPoint = SizeHelper:GetAnchor(props)
	local _condition = props.BackgroundTransparency
	if _condition == nil then
		_condition = 1
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.ZIndex = props.ZIndex
	_attributes.Change = props.Change
	return React.createElement("frame", _attributes, React.createElement(Group.Element, {
		enabled = props.group,
	}, props.children))
end
return {
	Container = Container,
}
