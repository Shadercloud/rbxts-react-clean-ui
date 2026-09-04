-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local HStack = _Layout.HStack
local VStack = _Layout.VStack
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local function defaultValueFormatter(value, max)
	local percent = if max > 0 then (value / max) * 100 else 0
	return `{math.round(percent)}%`
end
local ProgressBar = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local progressBarTheme = theme.components.progressBar
	local _condition = props.max
	if _condition == nil then
		_condition = 100
	end
	local maxValue = math.max(_condition, 0)
	local clampedValue = math.clamp(props.value, 0, maxValue)
	local targetProgress = if maxValue > 0 then clampedValue / maxValue else 0
	local duration = progressBarTheme.animation.duration
	local progress, progressTween = useTween(targetProgress, {
		duration = duration,
	})
	React.useEffect(function()
		progressTween:setGoal(targetProgress, {
			duration = duration,
		})
		if duration == 0 then
			progressTween:setPosition(targetProgress)
		end
	end, { targetProgress, duration, progressTween })
	local colors = ColorHelper:getIntentColors(theme, props.intent, "default", progressBarTheme.fill.intents)
	local height = SizeHelper:toUDim(progressBarTheme.height[props.scale or theme.default.scale])
	local fillSize = progress:map(function(value)
		return UDim2.fromScale(value, 1)
	end)
	local fillPosition = UDim2.fromScale(0, 0)
	local stripeTheme = progressBarTheme.fill.stripe
	local _condition_1 = props.striped
	if _condition_1 == nil then
		local _result = stripeTheme
		if _result ~= nil then
			_result = _result.enabled
		end
		_condition_1 = _result
		if _condition_1 == nil then
			_condition_1 = false
		end
	end
	local striped = _condition_1
	local _condition_2 = props.stripeDuration
	if _condition_2 == nil then
		local _result = stripeTheme
		if _result ~= nil then
			_result = _result.duration
		end
		_condition_2 = _result
		if _condition_2 == nil then
			_condition_2 = 0.75
		end
	end
	local stripeDuration = _condition_2
	local _condition_3 = props.stripeDirection
	if _condition_3 == nil then
		local _result = stripeTheme
		if _result ~= nil then
			_result = _result.direction
		end
		_condition_3 = _result
	end
	local rawStripeDirection = _condition_3
	local stripeDirection = if rawStripeDirection == -1 then -1 else 1
	local _result = stripeTheme
	if _result ~= nil then
		_result = _result.image
	end
	local resolvedStripeImage = CssHelper:resolveBackgroundImage(_result)
	local stripeTileSize = resolvedStripeImage.TileSize or UDim2.fromOffset(16, 16)
	local stripeTileWidth = if stripeTileSize.X.Offset ~= 0 then stripeTileSize.X.Offset else 16
	local stripeProgress, stripeTween = useTween(0, {
		duration = stripeDuration,
		easing = "linear",
		repeats = math.huge,
		reverses = false,
	})
	React.useEffect(function()
		if not striped then
			return nil
		end
		stripeTween:setPosition(0)
		stripeTween:setGoal(1, {
			duration = stripeDuration,
		})
	end, { striped, stripeDuration, stripeTween })
	local stripePosition = stripeProgress:map(function(value)
		return if stripeDirection == 1 then UDim2.fromOffset(-stripeTileWidth + value * stripeTileWidth, 0) else UDim2.fromOffset(-value * stripeTileWidth, 0)
	end)
	local showHeader = props.label ~= nil or props.showValue == true
	local formattedValue = if props.showValue then (props.valueFormatter or defaultValueFormatter)(clampedValue, maxValue) else nil
	local labelTypography = TypographyHelper:getTypography(theme, props.scale, progressBarTheme.header.label.typography)
	local valueTypography = TypographyHelper:getTypography(theme, props.scale, progressBarTheme.header.value.typography or progressBarTheme.header.label.typography)
	local _attributes = {}
	local _condition_4 = props.name
	if _condition_4 == nil then
		_condition_4 = "ProgressBar"
	end
	_attributes.name = _condition_4
	_attributes.ref = ref
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = SizeHelper:GetSize(props, UDim2.new(UDim.new(1, 0), height))
	local _condition_5 = props.ClipsDescendants
	if _condition_5 == nil then
		_condition_5 = true
	end
	_attributes.ClipsDescendants = _condition_5
	_attributes.BackgroundColor3 = progressBarTheme.track.backgroundColor
	_attributes.BackgroundTransparency = progressBarTheme.track.backgroundTransparency
	_attributes.backgroundImage = progressBarTheme.track.backgroundImage
	_attributes.backgroundGradient = progressBarTheme.track.backgroundGradient
	local _exp = React.createElement("uistroke", {
		key = "Stroke",
		Thickness = progressBarTheme.track.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = progressBarTheme.track.borderColor,
	})
	local _exp_1 = React.createElement(Corners, {
		radius = progressBarTheme.track.cornerRadius,
	})
	local _attributes_1 = {
		key = "Fill",
		Size = fillSize,
		Position = fillPosition,
		BackgroundColor3 = colors.backgroundColor,
	}
	local _condition_6 = colors.backgroundTransparency
	if _condition_6 == nil then
		_condition_6 = 0
	end
	_attributes_1.BackgroundTransparency = _condition_6
	_attributes_1.BorderSizePixel = 0
	_attributes_1.ClipsDescendants = true
	local _exp_2 = React.createElement(Corners, {
		radius = progressBarTheme.fill.cornerRadius,
	})
	local _exp_3 = React.createElement(Gradient, {
		value = colors.backgroundGradient,
	})
	local _condition_7 = striped
	if _condition_7 then
		local _attributes_2 = {
			key = "Stripe",
			BackgroundTransparency = 1,
		}
		local _condition_8 = resolvedStripeImage.ImageTransparency
		if _condition_8 == nil then
			_condition_8 = 0.9
		end
		_attributes_2.ImageTransparency = _condition_8
		_attributes_2.ImageColor3 = resolvedStripeImage.ImageColor3
		_attributes_2.Size = UDim2.new(1, stripeTileWidth, 1, 0)
		_attributes_2.Position = stripePosition
		local _condition_9 = resolvedStripeImage.Image
		if _condition_9 == nil then
			_condition_9 = `rbxassetid://86644568183933`
		end
		_attributes_2.Image = _condition_9
		_attributes_2.ScaleType = Enum.ScaleType.Tile
		_attributes_2.TileSize = stripeTileSize
		_condition_7 = (React.createElement("imagelabel", _attributes_2))
	end
	local track = (React.createElement(Container, _attributes, _exp, _exp_1, React.createElement("frame", _attributes_1, _exp_2, _exp_3, _condition_7)))
	if not showHeader then
		return track
	end
	local _attributes_2 = {}
	local _condition_8 = props.name
	if _condition_8 == nil then
		_condition_8 = "ProgressBar"
	end
	_attributes_2.key = _condition_8
	_attributes_2.BackgroundTransparency = 1
	_attributes_2.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 0))
	_attributes_2.AutomaticSize = Enum.AutomaticSize.Y
	_attributes_2.Position = SizeHelper:GetPosition(props)
	_attributes_2.AnchorPoint = SizeHelper:GetAnchor(props)
	_attributes_2.ZIndex = props.ZIndex
	return React.createElement("frame", _attributes_2, React.createElement(VStack, {
		spacing = "None",
		HorizontalFlex = Enum.UIFlexAlignment.None,
		Padding = UDim.new(0, SpacingHelper:GetPadding(theme, props.scale, progressBarTheme.header.spacing)),
	}, React.createElement("frame", {
		key = "ProgressBarHeader",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, React.createElement(HStack, {
		valign = "Center",
		Wraps = false,
		HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween,
	}, props.label ~= nil and (React.createElement(Text, {
		name = "ProgressBarLabel",
		text = props.label,
		TextColor3 = labelTypography.color,
		typography = labelTypography,
	})), formattedValue ~= nil and (React.createElement(Text, {
		name = "ProgressBarValue",
		text = formattedValue,
		TextColor3 = valueTypography.color,
		typography = valueTypography,
	})))), track))
end)
return {
	ProgressBar = ProgressBar,
}
