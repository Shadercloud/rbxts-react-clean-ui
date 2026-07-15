-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local Column = TS.import(script, script.Parent, "Column").Column
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local RowContext = _Contexts.RowContext
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").BreakpointHelper
local Row
do
	local super = Component
	Row = setmetatable({}, {
		__tostring = function()
			return "Row"
		end,
		__index = super,
	})
	Row.__index = Row
	function Row.new(...)
		local self = setmetatable({}, Row)
		return self:constructor(...) or self
	end
	function Row:constructor(...)
		super.constructor(self, ...)
		self.state = {
			width = 0,
		}
	end
	function Row:render()
		local breakpoints = (if self.props.breakpoints ~= nil then self.props.breakpoints else self.context.breakpoints)
		local padding = UDim.new(0, self.context.spacing[self.props.spacing or self.context.default.spacing])
		local _exp = React.createElement("uilistlayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = padding,
			Wraps = true,
		})
		local _attributes = {}
		local _object = {
			width = self.state.width,
		}
		local _left = "children"
		local _exp_1 = React.Children.toArray(self.props.children)
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(child)
			return React.isValidElement(child) and child.type == Column
		end
		local _length = 0
		for _k, _v in _exp_1 do
			if _callback(_v, _k - 1, _exp_1) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		_object[_left] = #_newValue
		_object.padding = padding
		_object.breakpoint = BreakpointHelper:getBreakpoint(self.state.width, breakpoints)
		_attributes.value = _object
		return React.createElement("frame", {
			Size = UDim2.fromScale(1, 1),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Change = {
				AbsoluteSize = function(instance)
					local width = instance.AbsoluteSize.X
					if width ~= self.state.width then
						self:setState({
							width = width,
						})
					end
				end,
			},
		}, _exp, React.createElement(RowContext.Provider, _attributes, self.props.children))
	end
	Row.contextType = CleanThemeContext
	Row = ReactComponent(Row) or Row
end
return {
	Row = Row,
}
