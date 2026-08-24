-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Text = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local style = props.typography or theme.typography[props.variant or "body"]
	local weight = if props.weight == "bold" then Enum.FontWeight.Bold else props.weight or style.weight or Enum.FontWeight.Regular
	local textwrapped = props.TextWrap ~= false and props.TextWrapped ~= false
	local _attributes = {
		ref = ref,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = props.AnchorPoint,
	}
	local _condition = props.LineHeight
	if _condition == nil then
		_condition = style.lineHeight
	end
	_attributes.LineHeight = _condition
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 1
	end
	_attributes.BackgroundTransparency = _condition_1
	_attributes.TextXAlignment = props.align or (props.TextXAlignment or Enum.TextXAlignment.Left)
	_attributes.TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor
	_attributes.Text = props.text
	_attributes.Position = props.Position
	_attributes.TextWrap = textwrapped
	_attributes.TextWrapped = textwrapped
	_attributes.FontFace = Font.fromName(style.font.Name, weight)
	_attributes.FontSize = style.size
	local _condition_2 = props.RichText
	if _condition_2 == nil then
		_condition_2 = true
	end
	_attributes.RichText = _condition_2
	local _condition_3 = props.TextScaled
	if _condition_3 == nil then
		_condition_3 = false
	end
	_attributes.TextScaled = _condition_3
	_attributes.ZIndex = props.ZIndex
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Visible = props.Visible
	_attributes.Rotation = props.Rotation
	_attributes.Active = props.Active
	_attributes.Archivable = props.Archivable
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.Selectable = props.Selectable
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Tag = props.Tag
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionOrder = props.SelectionOrder
	_attributes.TextStrokeColor3 = props.TextStrokeColor3
	_attributes.TextStrokeTransparency = props.TextStrokeTransparency
	_attributes.TextTransparency = props.TextTransparency
	_attributes.TextTruncate = props.TextTruncate
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement("textlabel", _attributes, props.children)
end)
return {
	Text = Text,
}
