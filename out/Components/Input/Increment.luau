-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FlexItem = _Layout.FlexItem
local HStack = _Layout.HStack
local Button = TS.import(script, script.Parent, "Button").Button
local resolveSteppedValue = TS.import(script, script.Parent, "Increment.step").resolveSteppedValue
local Input = TS.import(script, script.Parent, "Input").Input
local Increment = React.forwardRef(function(props, ref)
	local value, setValue = React.useState(props.value)
	local current = if props.controlled then props.value else value
	local _condition = props.step
	if _condition == nil then
		_condition = 1
	end
	local step = _condition
	local decrementDisabled = resolveSteppedValue(current, "decrement", step, props.min, props.max) == nil
	local incrementDisabled = resolveSteppedValue(current, "increment", step, props.min, props.max) == nil
	local applyValue = function(nextValue)
		if not props.controlled then
			setValue(nextValue)
		end
		local _result = props.onChange
		if _result ~= nil then
			_result(nextValue)
		end
	end
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = UDim2.fromScale(1, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	return React.createElement(Container, _attributes, React.createElement(HStack, {
		Wraps = false,
		valign = "Center",
		spacing = props.spacing,
	}, React.createElement(Button, {
		icon = "minus",
		intent = props.intent,
		scale = props.scale,
		spacing = props.spacing,
		disabled = decrementDisabled,
		LayoutOrder = 0,
		Event = {
			Activated = function()
				local nextValue = resolveSteppedValue(current, "decrement", step, props.min, props.max)
				if nextValue == nil then
					return nil
				end
				applyValue(nextValue)
			end,
		},
	}), React.createElement(FlexItem, {
		HorizontalFlex = "Fill",
		LayoutOrder = 1,
	}, React.createElement(Input, {
		Size = UDim2.fromScale(0, 0),
		scale = props.scale,
		spacing = props.spacing,
		controlled = true,
		validation = "Number",
		min = props.min,
		max = props.max,
		value = tostring(current),
		TextXAlignment = Enum.TextXAlignment.Center,
		onChange = function(text)
			local parsed = tonumber(text)
			if parsed == nil then
				return nil
			end
			applyValue(parsed)
		end,
	})), React.createElement(Button, {
		icon = "plus",
		intent = props.intent,
		scale = props.scale,
		spacing = props.spacing,
		disabled = incrementDisabled,
		LayoutOrder = 2,
		Event = {
			Activated = function()
				local nextValue = resolveSteppedValue(current, "increment", step, props.min, props.max)
				if nextValue == nil then
					return nil
				end
				applyValue(nextValue)
			end,
		},
	})))
end)
return {
	Increment = Increment,
}
