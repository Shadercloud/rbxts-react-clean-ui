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
	local rowRef = React.useRef()
	local setRowRef = function(instance)
		rowRef.current = instance
		local _ref = ref
		if type(_ref) == "function" then
			ref(instance)
		else
			local _condition = ref ~= nil
			if _condition then
				local _ref_1 = ref
				_condition = type(_ref_1) == "table"
			end
			if _condition then
				ref.current = instance
			end
		end
	end
	React.useEffect(function()
		local frame = rowRef.current
		if not frame then
			return nil
		end
		-- Some renderers (e.g. the browser-based Loom scene preview) don't
		-- back this ref with an instance that supports property-changed
		-- signals, so guard the subscription instead of throwing and
		-- losing breakpoint width tracking.
		local conn
		pcall(function()
			conn = frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local nextWidth = frame.AbsoluteSize.X
				setWidth(function(currentWidth)
					return if currentWidth == nextWidth then currentWidth else nextWidth
				end)
			end)
		end)
		return function()
			local _result = conn
			if _result ~= nil then
				_result:Disconnect()
			end
		end
	end, {})
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
		ref = setRowRef,
		Size = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, _exp, React.createElement(RowContext.Provider, _attributes, props.children))
end)
return {
	Row = Row,
}
