-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorators = TS.import(script, script.Parent.Parent, "Decorators")
local BoxShadow = _Decorators.BoxShadow
local Corners = _Decorators.Corners
local Padding = _Decorators.Padding
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local ColorHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").ColorHelper
local Button
do
	local super = Component
	Button = setmetatable({}, {
		__tostring = function()
			return "Button"
		end,
		__index = super,
	})
	Button.__index = Button
	function Button.new(...)
		local self = setmetatable({}, Button)
		return self:constructor(...) or self
	end
	function Button:constructor(...)
		super.constructor(self, ...)
	end
	function Button:render()
		local _attributes = {
			Event = {
				MouseEnter = function()
					self:setState({
						hover = true,
					})
				end,
				MouseLeave = function()
					self:setState({
						hover = false,
					})
				end,
			},
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
		}
		local _condition = self.props.BackgroundTransparency
		if _condition == nil then
			_condition = self.context.components.button.backgroundTransparency
		end
		_attributes.BackgroundTransparency = _condition
		_attributes.BackgroundColor3 = ColorHelper:getIntentColor(self.context, self.props.intent, if self.state.hover then "hover" else "background", self.context.components.button.intents, self.props.BackgroundColor3)
		_attributes.AutoButtonColor = false
		_attributes.ZIndex = self.props.ZIndex
		local _exp = React.createElement(Corners, {
			radius = self.context.components.button.cornerRadius,
		})
		local _exp_1 = React.createElement("uistroke", {
			Thickness = self.context.components.button.borderThickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,
			Color = ColorHelper:getIntentColor(self.context, self.props.intent, "border", self.context.components.button.intents),
		})
		local _attributes_1 = table.clone(self.props)
		setmetatable(_attributes_1, nil)
		_attributes_1.value = self.context.components.button.boxShadow
		local _exp_2 = React.createElement(BoxShadow, _attributes_1)
		local _attributes_2 = table.clone(self.props)
		setmetatable(_attributes_2, nil)
		return React.createElement("imagebutton", _attributes, _exp, _exp_1, _exp_2, React.createElement(Padding, _attributes_2), self.props.icon ~= nil and React.createElement("imagelabel", {
			Size = UDim2.fromOffset(20, 20),
			Image = `rbxassetid://{self.context.icons[self.props.icon]}`,
			BackgroundTransparency = 1,
			ImageColor3 = ColorHelper:getIntentColor(self.context, self.props.intent, "text", self.context.components.button.intents, nil, self.context.components.button.textColor),
		}), self.props.text ~= nil and React.createElement(Text, {
			text = self.props.text,
			typography = self.context.components.button.typography,
			TextColor3 = ColorHelper:getIntentColor(self.context, self.props.intent, "text", self.context.components.button.intents, nil, self.context.components.button.textColor),
		}), self.props.children)
	end
	Button.contextType = CleanThemeContext
	Button = ReactComponent(Button) or Button
end
return {
	Button = Button,
}
