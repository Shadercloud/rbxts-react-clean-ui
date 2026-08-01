-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Box = TS.import(script, script.Parent, "Box").Box
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FlexItem = _Layout.FlexItem
local VStack = _Layout.VStack
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Padding = TS.import(script, script.Parent.Parent, "Decorator").Padding
local CardContext = React.createContext({})
local CardHeader = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local card = React.useContext(CardContext)
	local intent = ColorHelper:getIntentColors(theme, props.intent or card.intent or "primary", "default", theme.components.card.header.intents)
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, "md", theme.components.card.header.spacing))
	local corners = CssHelper:parseCssSize(theme.components.card.cornerRadius)
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.BackgroundTransparency = intent.backgroundTransparency
	_attributes.BackgroundColor3 = intent.backgroundColor
	_attributes.BorderSizePixel = 0
	return React.createElement(Container, _attributes, React.createElement(Padding, {
		resolvedPadding = padding,
	}), React.createElement("uistroke", {
		Thickness = 1,
		Color = intent.borderColor,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
	}), React.createElement("uicorner", {
		TopLeftRadius = corners,
		TopRightRadius = corners,
		BottomLeftRadius = UDim.new(0, 0),
		BottomRightRadius = UDim.new(0, 0),
	}), props.children)
end)
local CardBody = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, "md", theme.components.card.header.spacing))
	local _attributes = {
		ref = ref,
		Size = SizeHelper:GetSize(props, UDim2.fromScale(0, 0)),
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	return React.createElement(FlexItem, nil, React.createElement(Container, _attributes, React.createElement(Padding, {
		resolvedPadding = padding,
	}), props.children))
end)
local CardFooter = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local card = React.useContext(CardContext)
	local intent = ColorHelper:getIntentColors(theme, props.intent or card.intent or "primary", "default", theme.components.card.footer.intents)
	local padding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, "md", theme.components.card.footer.spacing))
	local corners = CssHelper:parseCssSize(theme.components.card.cornerRadius)
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.BackgroundTransparency = intent.backgroundTransparency
	_attributes.BackgroundColor3 = intent.backgroundColor
	_attributes.BorderSizePixel = 0
	return React.createElement(Container, _attributes, React.createElement(Padding, {
		resolvedPadding = padding,
	}), React.createElement("uistroke", {
		Thickness = 1,
		Color = intent.borderColor,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
	}), React.createElement("uicorner", {
		TopLeftRadius = UDim.new(0, 0),
		TopRightRadius = UDim.new(0, 0),
		BottomLeftRadius = corners,
		BottomRightRadius = corners,
	}), props.children)
end)
local Card = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local contextValue = React.useMemo(function()
		return {
			intent = props.intent,
		}
	end, { props.intent })
	local intent = ColorHelper:getIntentColors(theme, props.intent or "primary", "default", theme.components.card.header.intents)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.ref = ref
	_attributes.spacing = "None"
	_attributes["border-color"] = intent.borderColor
	return React.createElement(CardContext.Provider, {
		value = contextValue,
	}, React.createElement(Box, _attributes, React.createElement(VStack, {
		spacing = "None",
	}, props.children)))
end)
Card.Header = CardHeader
Card.Footer = CardFooter
Card.Body = CardBody
return {
	CardHeader = CardHeader,
	CardBody = CardBody,
	CardFooter = CardFooter,
	Card = Card,
}
