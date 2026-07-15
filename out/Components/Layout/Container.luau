-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local Container
do
	local super = Component
	Container = setmetatable({}, {
		__tostring = function()
			return "Container"
		end,
		__index = super,
	})
	Container.__index = Container
	function Container.new(...)
		local self = setmetatable({}, Container)
		return self:constructor(...) or self
	end
	function Container:constructor(...)
		super.constructor(self, ...)
	end
	function Container:render()
		return React.createElement("frame", {
			Size = SizeHelper:GetSize(self.props),
			AutomaticSize = SizeHelper:GetAutoSize(self.props),
			Position = SizeHelper:GetPosition(self.props),
			AnchorPoint = SizeHelper:GetAnchor(self.props),
			BackgroundTransparency = 1,
			ZIndex = self.props.ZIndex,
		}, self.props.children)
	end
	Container = ReactComponent(Container) or Container
end
return {
	Container = Container,
}
