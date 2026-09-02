-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local FlexItem = TS.import(script, script.Parent, "FlexItem").FlexItem
local Container = TS.import(script, script.Parent, "Container").Container
local HStack = TS.import(script, script.Parent, "HStack").HStack
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local BreakpointHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").BreakpointHelper
local FieldsetContext = React.createContext(nil)
local function FieldsetLabel(props)
	local context = React.useContext(FieldsetContext)
	local _arg0 = context ~= nil
	assert(_arg0, "Fieldset.Label must be used inside a Fieldset")
	return React.createElement(FlexItem, {
		mode = "Custom",
		ShrinkRatio = 0,
		GrowRatio = 0,
	}, React.createElement("imagebutton", {
		key = "FieldsetLabelButton",
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Event = {
			Activated = function()
				context.labelActivated:Fire()
			end,
		},
	}, props.children))
end
local function FieldsetControl(props)
	local context = React.useContext(FieldsetContext)
	local _arg0 = context ~= nil
	assert(_arg0, "Fieldset.Control must be used inside a Fieldset")
	return React.createElement(FlexItem, {
		mode = "Custom",
		ShrinkRatio = if context.checkbox then 0 else 1,
		GrowRatio = if context.checkbox then 0 else 1,
	}, props.children)
end
local Fieldset = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local width, setWidth = React.useState(0)
	local labelActivated = React.useRef(Instance.new("BindableEvent")).current
	React.useEffect(function()
		return function()
			labelActivated:Destroy()
		end
	end, {})
	local fieldsetContext = React.useMemo(function()
		local _object = {}
		local _left = "disabled"
		local _condition = props.disabled
		if _condition == nil then
			_condition = false
		end
		_object[_left] = _condition
		local _left_1 = "checkbox"
		local _condition_1 = props.checkbox
		if _condition_1 == nil then
			_condition_1 = false
		end
		_object[_left_1] = _condition_1
		_object.labelActivated = labelActivated
		return _object
	end, { props.disabled, props.checkbox })
	local breakpoints = props.breakpoints or theme.breakpoints
	local breakpoint = BreakpointHelper:getBreakpoint(width, breakpoints)
	local wrap = BreakpointHelper:compare(breakpoint, "<=", props.wrap or "lg")
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Fieldset"
	end
	_attributes.name = _condition
	_attributes.ref = ref
	_attributes.Change = {
		AbsoluteSize = function(instance)
			setWidth(instance.AbsoluteSize.X)
		end,
	}
	return React.createElement(FieldsetContext.Provider, {
		value = fieldsetContext,
	}, React.createElement(Container, _attributes, React.createElement(HStack, {
		Wraps = wrap,
		valign = "Center",
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
	}, props.children)))
end)
Fieldset.Label = FieldsetLabel
Fieldset.Control = FieldsetControl
return {
	FieldsetContext = FieldsetContext,
	Fieldset = Fieldset,
}
