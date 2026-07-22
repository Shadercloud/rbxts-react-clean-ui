-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
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
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Event = {
			Activated = function()
				local _result = context.labelActivated
				if _result ~= nil then
					_result:Fire()
				end
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
local Fieldset
do
	local super = Component
	Fieldset = setmetatable({}, {
		__tostring = function()
			return "Fieldset"
		end,
		__index = super,
	})
	Fieldset.__index = Fieldset
	function Fieldset.new(...)
		local self = setmetatable({}, Fieldset)
		return self:constructor(...) or self
	end
	function Fieldset:constructor(...)
		super.constructor(self, ...)
		self.labelActivated = Instance.new("BindableEvent")
		self.fieldsetContext = {
			disabled = false,
			checkbox = false,
			labelActivated = self.labelActivated,
		}
	end
	function Fieldset:getFieldsetContext()
		local _condition = self.props.disabled
		if _condition == nil then
			_condition = false
		end
		local disabled = _condition
		local _condition_1 = self.props.checkbox
		if _condition_1 == nil then
			_condition_1 = false
		end
		local checkbox = _condition_1
		if self.fieldsetContext.disabled ~= disabled or self.fieldsetContext.checkbox ~= checkbox then
			self.fieldsetContext = {
				disabled = disabled,
				checkbox = checkbox,
				labelActivated = self.labelActivated,
			}
		end
		return self.fieldsetContext
	end
	function Fieldset:componentWillUnmount()
		self.labelActivated:Destroy()
	end
	function Fieldset:render()
		local context = self:getFieldsetContext()
		local wrap = false
		local breakpoints = (if self.props.breakpoints ~= nil then self.props.breakpoints else self.context.breakpoints)
		local _condition = self.state.width
		if _condition == nil then
			_condition = 0
		end
		local breakpoint = BreakpointHelper:getBreakpoint(_condition, breakpoints)
		if BreakpointHelper:compare(breakpoint, "<=", self.props.wrap or "lg") then
			wrap = true
		end
		return React.createElement(FieldsetContext.Provider, {
			value = context,
		}, React.createElement(Container, {
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
		}, React.createElement(HStack, {
			Wraps = wrap,
			valign = "Center",
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
		}, self.props.children)))
	end
	Fieldset.Label = FieldsetLabel
	Fieldset.Control = FieldsetControl
	Fieldset.contextType = CleanThemeContext
	Fieldset = ReactComponent(Fieldset) or Fieldset
end
return {
	FieldsetContext = FieldsetContext,
	Fieldset = Fieldset,
}
