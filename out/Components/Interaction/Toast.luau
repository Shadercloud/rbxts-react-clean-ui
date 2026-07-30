-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local _Surface = TS.import(script, script.Parent.Parent, "Surface")
local Box = _Surface.Box
local Icon = _Surface.Icon
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FlexItem = _Layout.FlexItem
local HStack = _Layout.HStack
local VStack = _Layout.VStack
local Button = TS.import(script, script.Parent.Parent, "Input").Button
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _ = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _.CleanThemeContext
local useToast = _.useToast
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SizeHelper = _Helpers.SizeHelper
local TypographyHelper = _Helpers.TypographyHelper
local Corners = TS.import(script, script.Parent.Parent, "Decorator").Corners
local function Toast(_param)
	local title = _param.title
	if title == nil then
		title = nil
	end
	local description = _param.description
	if description == nil then
		description = nil
	end
	local icon = _param.icon
	if icon == nil then
		icon = nil
	end
	local intent = _param.intent
	if intent == nil then
		intent = "primary"
	end
	local duration = _param.duration
	if duration == nil then
		duration = 3
	end
	local dismissible = _param.dismissible
	if dismissible == nil then
		dismissible = true
	end
	local children = _param.children
	if children == nil then
		children = nil
	end
	local onDismiss = _param.onDismiss
	local theme = React.useContext(CleanThemeContext)
	local dismissRef = React.useRef(onDismiss)
	local dismissingRef = React.useRef(false)
	local fadeThreadRef = React.useRef()
	local statusBarTheme = theme.components.toast.statusBar
	local progress, progressTween = useTween(1, {
		duration = duration,
		easing = "linear",
	})
	React.useEffect(function()
		if statusBarTheme == nil or duration == math.huge or duration <= 0 then
			return nil
		end
		progressTween:setGoal(0)
	end, { duration, statusBarTheme })
	local TOAST_FADE_DURATION = theme.components.toast.fadeDuration
	local groupTransparency, transparencyTween = useTween(0, {
		duration = TOAST_FADE_DURATION,
		easing = "quadOut",
	})
	React.useEffect(function()
		dismissRef.current = onDismiss
	end, { onDismiss })
	local beginDismiss = React.useCallback(function()
		if dismissingRef.current then
			return nil
		end
		dismissingRef.current = true
		if TOAST_FADE_DURATION <= 0 then
			dismissRef.current()
			return nil
		end
		transparencyTween:setGoal(1)
		fadeThreadRef.current = task.delay(TOAST_FADE_DURATION, function()
			fadeThreadRef.current = nil
			dismissRef.current()
		end)
	end, { transparencyTween })
	React.useEffect(function()
		if duration == math.huge or duration <= 0 then
			return nil
		end
		local dismissThread = task.delay(duration, beginDismiss)
		return function()
			task.cancel(dismissThread)
		end
	end, { duration, beginDismiss })
	React.useEffect(function()
		if TOAST_FADE_DURATION <= 0 then
			return nil
		end
		return function()
			local fadeThread = fadeThreadRef.current
			if fadeThread ~= nil then
				task.cancel(fadeThread)
			end
		end
	end, {})
	local boxStyles = ColorHelper:getIntentColors(theme, intent, "default", theme.components.toast.intents)
	local _condition = children ~= nil and children
	if not _condition then
		local _exp = icon ~= nil and React.createElement(Icon, {
			icon = icon,
			scale = "sm",
			color = boxStyles.textColor,
		})
		local _attributes = {
			TextColor3 = boxStyles.textColor,
		}
		local _condition_1 = title
		if _condition_1 == nil then
			_condition_1 = ""
		end
		_attributes.text = _condition_1
		_attributes.typography = TypographyHelper:getTypography(theme, nil, theme.components.toast.header.typography)
		_condition = React.createElement(VStack, {
			spacing = "None",
		}, React.createElement(Container, nil, React.createElement(HStack, {
			valign = "Center",
		}, _exp, React.createElement(Text, _attributes), dismissible and (React.createElement(FlexItem, {
			align = "Right",
		}, React.createElement(Button, {
			intent = intent,
			spacing = "xs",
			Event = {
				Activated = beginDismiss,
			},
		}, React.createElement(Button.Icon, {
			intent = intent,
			icon = "times",
			scale = "sm",
		})))))), description ~= nil and (React.createElement(Container, nil, React.createElement(Text, {
			text = description,
			TextColor3 = boxStyles.textColor,
		}))))
	end
	return React.createElement("canvasgroup", {
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		GroupTransparency = groupTransparency,
	}, React.createElement(Box, {
		["border-color"] = boxStyles.borderColor,
		BackgroundColor3 = boxStyles.backgroundColor,
		BackgroundTransparency = boxStyles.backgroundTransparency,
	}, _condition), statusBarTheme ~= nil and React.createElement(React.Fragment, nil, React.createElement("frame", {
		Size = progress:map(function(value)
			return UDim2.new(UDim.new(value, 0), SizeHelper:toUDim(statusBarTheme.height))
		end),
		BackgroundColor3 = ColorHelper:getIntentColors(theme, intent, "default", statusBarTheme.intents).backgroundColor,
		BackgroundTransparency = ColorHelper:getIntentColors(theme, intent, "default", statusBarTheme.intents).backgroundTransparency,
		ZIndex = 2,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, if statusBarTheme.position == "Top" then 0 else 1),
		AnchorPoint = Vector2.new(0, if statusBarTheme.position == "Top" then 0 else 1),
	}), React.createElement(Corners, {
		radius = theme.components.box.cornerRadius,
	})))
end
local function ToastContainer(props)
	local _binding = useToast()
	local toasts = _binding.toasts
	local dismiss = _binding.dismiss
	local theme = React.useContext(CleanThemeContext)
	if #toasts == 0 then
		return nil
	end
	local position = if theme.components.toast.position then SizeHelper:GetPosition(theme.components.toast.position) else UDim2.fromOffset(5, 5)
	local anchor = if theme.components.toast.position then SizeHelper:GetAnchor(theme.components.toast.position) else Vector2.new(0, 0)
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#toasts)
	local _callback = function(toast)
		local _attributes = {
			key = toast.id,
		}
		for _k, _v in toast do
			_attributes[_k] = _v
		end
		_attributes.onDismiss = function()
			return dismiss(toast.id)
		end
		return React.createElement(Toast, _attributes)
	end
	for _k, _v in toasts do
		_newValue[_k] = _callback(_v, _k - 1, toasts)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(Container, {
		Size = SizeHelper:GetSize(props, UDim2.new(SizeHelper:toUDim(theme.components.toast.width), UDim.new(0, 0))),
		Position = position,
		AnchorPoint = anchor,
	}, React.createElement(VStack, {
		spacing = "xs",
	}, _newValue))
end
return {
	Toast = Toast,
	ToastContainer = ToastContainer,
}
