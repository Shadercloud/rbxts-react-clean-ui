-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local FieldsetContext = TS.import(script, script.Parent.Parent, "Layout").FieldsetContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local BoxShadow = _Decorator.BoxShadow
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SizeHelper = _Helpers.SizeHelper
-- Linearly interpolates between two UDim values by treating Scale and Offset
-- as independent components, since UDim itself has no Lerp method.
local function lerpUDim(from, to, alpha)
	return UDim.new(from.Scale + (to.Scale - from.Scale) * alpha, from.Offset + (to.Offset - from.Offset) * alpha)
end
local function Switch(props)
	local theme = React.useContext(CleanThemeContext)
	local fieldset = React.useContext(FieldsetContext)
	local switchTheme = theme.components.switch
	local _condition = props.checked
	if _condition == nil then
		_condition = false
	end
	local checked, setChecked = React.useState(_condition)
	React.useEffect(function()
		if not fieldset then
			return nil
		end
		local _connection = fieldset.labelActivated
		if _connection ~= nil then
			_connection = _connection.Event:Connect(function()
				if props.disabled then
					return nil
				end
				setChecked(function(current)
					return not current
				end)
			end)
		end
		local connection = _connection
		return function()
			local _result = connection
			if _result ~= nil then
				_result:Disconnect()
			end
		end
	end, { fieldset, props.disabled })
	React.useEffect(function()
		local _result = props.onChange
		if _result ~= nil then
			_result(checked)
		end
	end, { checked })
	local duration = switchTheme.animation.duration
	local progress, progressTween = useTween(if checked then 1 else 0, {
		duration = duration,
	})
	React.useEffect(function()
		local goal = if checked then 1 else 0
		progressTween:setGoal(goal, {
			duration = duration,
		})
		if duration == 0 then
			progressTween:setPosition(goal)
		end
		progressTween:start()
	end, { checked, duration, progressTween })
	local onColors = ColorHelper:getIntentColors(theme, props.intent, if props.disabled then "disabled" else "default", switchTheme.track.intents)
	local offBackgroundColor = switchTheme.track.backgroundColor
	local offBorderColor = switchTheme.track.borderColor
	local trackBackgroundColor = progress:map(function(value)
		return offBackgroundColor:Lerp(onColors.backgroundColor, value)
	end)
	local trackBorderColor = progress:map(function(value)
		return offBorderColor:Lerp(onColors.borderColor, value)
	end)
	local trackWidth = SizeHelper:toUDim(switchTheme.width)
	local trackHeight = SizeHelper:toUDim(switchTheme.height)
	local inset = SizeHelper:toUDim(switchTheme.thumb.inset)
	local insetDoubled = inset + inset
	local thumbDiameter = trackHeight - insetDoubled
	local thumbOffX = inset
	local thumbOnX = trackWidth - inset - thumbDiameter
	local thumbPosition = progress:map(function(value)
		return UDim2.new(lerpUDim(thumbOffX, thumbOnX, value), UDim.new(0.5, 0))
	end)
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Switch"
	end
	_attributes.key = _condition_1
	_attributes.Active = not props.disabled
	_attributes.Selectable = not props.disabled
	_attributes.AutoButtonColor = false
	_attributes.Size = UDim2.new(trackWidth, trackHeight)
	_attributes.ZIndex = props.ZIndex
	_attributes.BackgroundColor3 = trackBackgroundColor
	local _result
	if props.disabled then
		_result = switchTheme.disabledTransparency
	else
		local _condition_2 = props.BackgroundTransparency
		if _condition_2 == nil then
			_condition_2 = switchTheme.track.backgroundTransparency
		end
		_result = _condition_2
	end
	_attributes.BackgroundTransparency = _result
	_attributes.Event = {
		Activated = function()
			if props.disabled then
				return nil
			end
			setChecked(not checked)
		end,
	}
	return React.createElement("imagebutton", _attributes, React.createElement(Corners, {
		radius = switchTheme.cornerRadius,
	}), React.createElement("uistroke", {
		Thickness = switchTheme.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = trackBorderColor,
	}), React.createElement("frame", {
		Position = thumbPosition,
		AnchorPoint = Vector2.new(0, 0.5),
		Size = UDim2.new(thumbDiameter, thumbDiameter),
		BackgroundColor3 = switchTheme.thumb.backgroundColor,
		BackgroundTransparency = if props.disabled then switchTheme.disabledTransparency else switchTheme.thumb.backgroundTransparency,
		BorderSizePixel = 0,
	}, React.createElement("uistroke", {
		Thickness = switchTheme.thumb.borderThickness,
		Color = switchTheme.thumb.borderColor,
	}), React.createElement(Corners, {
		radius = switchTheme.thumb.cornerRadius,
	}), React.createElement(BoxShadow, {
		["box-shadow"] = switchTheme.thumb.boxShadow,
	})))
end
return {
	Switch = Switch,
}
