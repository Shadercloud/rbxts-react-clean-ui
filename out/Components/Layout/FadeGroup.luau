-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local FadeGroup = React.forwardRef(function(props, ref)
	local sizeConstraint = SizeHelper:GetSizeConstraint(props)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "FadeGroup"
	end
	_attributes.key = _condition
	_attributes.ref = ref
	_attributes.Archivable = props.Archivable
	_attributes.Tag = props.Tag
	_attributes.Active = props.Active
	_attributes.AnchorPoint = SizeHelper:GetAnchor(props)
	_attributes.AutomaticSize = SizeHelper:GetAutoSize(props)
	_attributes.BackgroundColor3 = props.BackgroundColor3
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 1
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = if props.BorderSizePixel == nil then 0 else props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.GroupColor3 = props.GroupColor3
	local _condition_2 = props.GroupTransparency
	if _condition_2 == nil then
		_condition_2 = 0
	end
	_attributes.GroupTransparency = _condition_2
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
	_attributes.Size = SizeHelper:GetSize(props, UDim2.fromOffset(0, 0))
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Visible = props.Visible
	_attributes.ZIndex = props.ZIndex
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement("canvasgroup", _attributes, sizeConstraint ~= nil and (React.createElement("uisizeconstraint", {
		key = "SizeConstraint",
		MinSize = sizeConstraint.MinSize,
		MaxSize = sizeConstraint.MaxSize,
	})), props.children)
end)
return {
	FadeGroup = FadeGroup,
}
