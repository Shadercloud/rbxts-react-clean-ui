-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local _Group = TS.import(script, script.Parent, "Group")
local Group = _Group.Group
local GroupContext = _Group.GroupContext
local Container = React.forwardRef(function(props, ref)
	local group = React.useContext(GroupContext)
	local autoSize = SizeHelper:GetAutoSize(props)
	local isAutoSizeActive = autoSize ~= Enum.AutomaticSize.None and autoSize ~= "None"
	local centerViaLayout = props.center == true and props.Position == nil and props.AnchorPoint == nil and isAutoSizeActive
	local _attributes = {
		ref = ref,
		Archivable = props.Archivable,
		Tag = props.Tag,
		Active = props.Active,
		AnchorPoint = if centerViaLayout then Vector2.zero else SizeHelper:GetAnchor(props),
		AutomaticSize = autoSize,
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
	_attributes.Position = if centerViaLayout then UDim2.fromOffset(0, 0) else SizeHelper:GetPosition(props)
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
	local content = (React.createElement("frame", _attributes, React.createElement(Group.Element, {
		enabled = props.group,
	}, props.children)))
	if not centerViaLayout then
		return content
	end
	return React.createElement("frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
	}, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}), content)
end)
return {
	Container = Container,
}
