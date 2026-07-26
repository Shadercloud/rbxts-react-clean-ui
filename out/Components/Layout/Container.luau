-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local _Group = TS.import(script, script.Parent, "Group")
local Group = _Group.Group
local GroupContext = _Group.GroupContext
local Container = React.forwardRef(function(props, ref)
	local group = React.useContext(GroupContext)
	local _attributes = {
		ref = ref,
		Archivable = props.Archivable,
		Tag = props.Tag,
		Active = props.Active,
		AnchorPoint = SizeHelper:GetAnchor(props),
		AutomaticSize = SizeHelper:GetAutoSize(props),
		BackgroundColor3 = props.BackgroundColor3,
	}
	local _condition = props.BackgroundTransparency
	if _condition == nil then
		_condition = 1
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.Interactable = props.Interactable
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.Position = SizeHelper:GetPosition(props)
	_attributes.Rotation = props.Rotation
	_attributes.Selectable = props.Selectable
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.SelectionOrder = props.SelectionOrder
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
		local _condition_1 = _result_1
		if _condition_1 == nil then
			_condition_1 = 0
		end
		_result = _condition_1
	else
		_result = 0
	end
	_attributes.Size = SizeHelper:GetSize(_exp, UDim2.fromOffset(_result, 0))
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Visible = props.Visible
	_attributes.ZIndex = props.ZIndex
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.Style = props.Style
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement("frame", _attributes, React.createElement(Group.Element, {
		enabled = props.group,
	}, props.children))
end)
return {
	Container = Container,
}
