-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Text
do
	local super = Component
	Text = setmetatable({}, {
		__tostring = function()
			return "Text"
		end,
		__index = super,
	})
	Text.__index = Text
	function Text.new(...)
		local self = setmetatable({}, Text)
		return self:constructor(...) or self
	end
	function Text:constructor(...)
		super.constructor(self, ...)
	end
	function Text:render()
		local style = self.props.typography or self.context.typography[self.props.variant or "body"]
		local weight = if self.props.weight == "bold" then Enum.FontWeight.Bold else self.props.weight or style.weight or Enum.FontWeight.Regular
		return React.createElement("textlabel", {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			LineHeight = style.lineHeight,
			BackgroundTransparency = 1,
			TextXAlignment = self.props.align or (self.props.TextXAlignment or Enum.TextXAlignment.Left),
			TextColor3 = self.props.TextColor3 or self.context.colors.intents.primary.text,
			Text = self.props.text,
			TextWrap = self.props.TextWrap == nil or self.props.TextWrap == true,
			FontFace = Font.fromName(style.font.Name, weight),
			FontSize = style.size,
			RichText = true,
			TextScaled = false,
		}, self.props.children)
	end
	Text.contextType = CleanThemeContext
	Text = ReactComponent(Text) or Text
end
return {
	Text = Text,
}
