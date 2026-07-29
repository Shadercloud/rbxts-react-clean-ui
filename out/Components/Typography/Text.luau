-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Text = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local style = props.typography or theme.typography[props.variant or "body"]
	local weight = if props.weight == "bold" then Enum.FontWeight.Bold else props.weight or style.weight or Enum.FontWeight.Regular
	return React.createElement("textlabel", {
		ref = ref,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		LineHeight = style.lineHeight,
		BackgroundTransparency = 1,
		TextXAlignment = props.align or (props.TextXAlignment or Enum.TextXAlignment.Left),
		TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor,
		Text = props.text,
		TextWrap = props.TextWrap == nil or props.TextWrap == true,
		FontFace = Font.fromName(style.font.Name, weight),
		FontSize = style.size,
		RichText = true,
		Event = props.Event,
		TextScaled = false,
	}, props.children)
end)
return {
	Text = Text,
}
