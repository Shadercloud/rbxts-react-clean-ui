-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local BreakpointContext = _Contexts.BreakpointContext
local CleanThemeContext = _Contexts.CleanThemeContext
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").BreakpointHelper
local BreakpointProvider = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local breakpoints = props.breakpoints or theme.breakpoints
	local frameRef = React.useRef()
	local widthRef = React.useRef(0)
	local value, setValue = React.useState(function()
		return {
			width = 0,
			breakpoint = BreakpointHelper:getBreakpoint(0, breakpoints),
		}
	end)
	local valueRef = React.useRef(value)
	local resolve = function(width)
		widthRef.current = width
		local breakpoint = BreakpointHelper:getBreakpoint(width, breakpoints)
		if breakpoint == valueRef.current.breakpoint then
			return nil
		end
		local resolved = {
			width = width,
			breakpoint = breakpoint,
		}
		valueRef.current = resolved
		setValue(resolved)
	end
	React.useEffect(function()
		local instance = frameRef.current
		resolve(if instance ~= nil then instance.AbsoluteSize.X else widthRef.current)
	end, { breakpoints })
	local setFrame = React.useCallback(function(instance)
		frameRef.current = instance
		local _ref = ref
		if type(_ref) == "function" then
			ref(instance)
		elseif ref ~= nil then
			ref.current = instance
		end
	end, { ref })
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "BreakpointProvider"
	end
	_attributes.key = _condition
	_attributes.ref = setFrame
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Size = UDim2.fromScale(1, 1)
	_attributes.BackgroundTransparency = 1
	_attributes.Change = {
		AbsoluteSize = function(instance)
			return resolve(instance.AbsoluteSize.X)
		end,
	}
	return React.createElement("frame", _attributes, React.createElement(BreakpointContext.Provider, {
		value = value,
	}, props.children))
end)
return {
	BreakpointProvider = BreakpointProvider,
}
