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
	_attributes.RichText = true
	_attributes.Event = props.Event
	_attributes.TextScaled = false
	return React.createElement("textlabel", _attributes, props.children)
end)
return {
	Text = Text,
}
