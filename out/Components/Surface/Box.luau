-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorators = TS.import(script, script.Parent.Parent, "Decorators")
local Padding = _Decorators.Padding
local Corners = _Decorators.Corners
local BoxShadow = _Decorators.BoxShadow
local Box
do
	local super = Component
	Box = setmetatable({}, {
		__tostring = function()
			return "Box"
		end,
		__index = super,
	})
	Box.__index = Box
	function Box.new(...)
		local self = setmetatable({}, Box)
		return self:constructor(...) or self
	end
	function Box:constructor(...)
		super.constructor(self, ...)
	end
	function Box:render()
		local _attributes = {
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
		}
		local _condition = self.props.BackgroundTransparency
		if _condition == nil then
			_condition = self.context.components.box.backgroundTransparency
		end
		_attributes.BackgroundTransparency = _condition
		_attributes.BackgroundColor3 = self.props.BackgroundColor3 or self.context.components.box.backgroundColor
		_attributes.ZIndex = self.props.ZIndex
		local _exp = React.createElement(Corners, {
			radius = self.context.components.box.cornerRadius,
		})
		local _exp_1 = React.createElement("uistroke", {
			Thickness = self.context.components.box.borderThickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Inner,
			Color = self.context.components.box.borderColor,
		})
		local _attributes_1 = table.clone(self.props)
		setmetatable(_attributes_1, nil)
		_attributes_1.value = self.context.components.box.boxShadow
		local _exp_2 = React.createElement(BoxShadow, _attributes_1)
		local _attributes_2 = table.clone(self.props)
		setmetatable(_attributes_2, nil)
		return React.createElement("frame", _attributes, _exp, _exp_1, _exp_2, React.createElement(Padding, _attributes_2), self.props.children)
	end
	Box.contextType = CleanThemeContext
	Box = ReactComponent(Box) or Box
end
return {
	Box = Box,
}
