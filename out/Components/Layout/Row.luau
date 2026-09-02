-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Column = TS.import(script, script.Parent, "Column").Column
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local RowContext = _Contexts.RowContext
local _ = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local BreakpointHelper = _.BreakpointHelper
local SpacingHelper = _.SpacingHelper
local Row = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local width, setWidth = React.useState(0)
	local breakpoints = props.breakpoints or theme.breakpoints
	local padding = UDim.new(0, SpacingHelper:GetPadding(theme, props.spacing))
	local _exp = React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = padding,
		Wraps = true,
	})
	local _attributes = {}
	local _object = {
		width = width,
	}
	local _left = "children"
	local _exp_1 = React.Children.toArray(props.children)
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
	_object.breakpoint = BreakpointHelper:getBreakpoint(width, breakpoints)
	_attributes.value = _object
	return React.createElement("frame", {
		ref = ref,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Change = {
			AbsoluteSize = function(instance)
				local nextWidth = instance.AbsoluteSize.X
				setWidth(function(currentWidth)
					return if currentWidth == nextWidth then currentWidth else nextWidth
				end)
			end,
		},
	}, _exp, React.createElement(RowContext.Provider, _attributes, props.children))
end)
return {
	Row = Row,
}
