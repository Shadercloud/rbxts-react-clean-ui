-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local RowContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").RowContext
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").BreakpointHelper
local Column
do
	local super = Component
	Column = setmetatable({}, {
		__tostring = function()
			return "Column"
		end,
		__index = super,
	})
	Column.__index = Column
	function Column.new(...)
		local self = setmetatable({}, Column)
		return self:constructor(...) or self
	end
	function Column:constructor(...)
		super.constructor(self, ...)
	end
	function Column:getSpan()
		local span = self.props.span
		if span == nil then
			return math.floor(12 / math.max(self.context.children, 1))
		end
		if type(span) == "number" then
			return span
		end
		if type(span) == "string" then
			local _condition = tonumber(span)
			if _condition == nil then
				_condition = 12
			end
			return _condition
		end
		return BreakpointHelper:getValue(self.context.breakpoint, span) or 12
	end
	function Column:render()
		local span = self:getSpan()
		local fraction = math.floor((span / 12) * 1000) / 1000
		local padding = self.context.padding
		local widthScale = fraction + ((fraction - 1) * padding.Scale)
		local widthOffset = (fraction - 1) * padding.Offset
		return React.createElement("frame", {
			Size = UDim2.new(widthScale, widthOffset, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
		}, self.props.children)
	end
	Column.contextType = RowContext
	Column = ReactComponent(Column) or Column
end
return {
	Column = Column,
}
