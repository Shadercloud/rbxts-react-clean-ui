-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local HStack = TS.import(script, script.Parent, "HStack").HStack
local VStack = TS.import(script, script.Parent, "VStack").VStack
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local Container = TS.import(script, script.Parent, "Container").Container
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
local Padding = _Decorator.Padding
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _HoverButton = TS.import(script, script.Parent.Parent, "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
local TabsContext = React.createContext({
	selected = nil,
	claimTab = function() end,
	selectTab = function() end,
})
local TabsListContext = React.createContext({
	fill = false,
})
local function TabButtonCorners()
	local theme = React.useContext(CleanThemeContext)
	local cornerRadius = theme.components.tabs.button.cornerRadius
	if not (type(cornerRadius) == "table") then
		return React.createElement(Corners, {
			radius = theme.components.tabs.list.cornerRadius,
		})
	end
	local fallback = SizeHelper:toUDim(theme.components.tabs.list.cornerRadius)
	local topLeftRadius = if cornerRadius.topLeft ~= nil then CssHelper:parseCssSize(cornerRadius.topLeft) else fallback
	local topRightRadius = if cornerRadius.topRight ~= nil then CssHelper:parseCssSize(cornerRadius.topRight) else fallback
	local bottomLeftRadius = if cornerRadius.bottomLeft ~= nil then CssHelper:parseCssSize(cornerRadius.bottomLeft) else fallback
	local bottomRightRadius = if cornerRadius.bottomRight ~= nil then CssHelper:parseCssSize(cornerRadius.bottomRight) else fallback
	local isZero = function(radius)
		return radius.Scale == 0 and radius.Offset == 0
	end
	if isZero(topLeftRadius) and isZero(topRightRadius) and isZero(bottomLeftRadius) and isZero(bottomRightRadius) then
		return nil
	end
	return React.createElement("uicorner", {
		key = "Corners",
		TopLeftRadius = topLeftRadius,
		TopRightRadius = topRightRadius,
		BottomLeftRadius = bottomLeftRadius,
		BottomRightRadius = bottomRightRadius,
	})
end
local function TabButtonContent(props)
	local theme = React.useContext(CleanThemeContext)
	local hover = React.useContext(HoverButtonContext)
	local _binding = React.useContext(TabsListContext)
	local fill = _binding.fill
	local _result = hover
	if _result ~= nil then
		_result = _result.isSelected
	end
	local _result_1
	if _result then
		_result_1 = "focus"
	else
		local _result_2 = hover
		if _result_2 ~= nil then
			_result_2 = _result_2.hover
		end
		_result_1 = if _result_2 then "hover" else "default"
	end
	local intent = ColorHelper:getIntentColors(theme, "primary", _result_1, theme.components.tabs.button.intents)
	local _condition = intent.borderThickness
	if _condition == nil then
		_condition = theme.components.tabs.button.borderThickness
	end
	local borderThickness = _condition
	return React.createElement(React.Fragment, nil, React.createElement(TabButtonCorners), borderThickness > 0 and (React.createElement("uistroke", {
		key = "Stroke",
		Thickness = borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = intent.borderColor,
	})), React.createElement(Gradient, {
		value = intent.backgroundGradient,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.tabs.button.spacing, theme.components.tabs.button.padding),
	}), React.createElement(BoxShadow, {
		value = intent.boxShadow,
	}), fill and (React.createElement("uilistlayout", {
		key = "TitleLayout",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})), React.createElement(Text, {
		name = "TabTitleText",
		TextColor3 = intent.textColor,
		text = props.text,
		typography = TypographyHelper:getTypography(theme, nil, intent.typography),
	}))
end
local function TabTitle(props)
	local theme = React.useContext(CleanThemeContext)
	local _binding = React.useContext(TabsContext)
	local selected = _binding.selected
	local claimTab = _binding.claimTab
	local selectTab = _binding.selectTab
	local _binding_1 = React.useContext(TabsListContext)
	local fill = _binding_1.fill
	local isSelected = selected == props.value
	React.useEffect(function()
		claimTab(props.value)
	end, {})
	local buttonDefault = ColorHelper:getIntentColors(theme, "primary", "default", theme.components.tabs.button.intents)
	local buttonHover = ColorHelper:getIntentColors(theme, "primary", "hover", theme.components.tabs.button.intents)
	local buttonFocus = ColorHelper:getIntentColors(theme, "primary", "focus", theme.components.tabs.button.intents)
	local buttonDefaultBackgroundImage = CssHelper:resolveBackgroundImage(buttonDefault.backgroundImage)
	local buttonHoverBackgroundImage = CssHelper:resolveBackgroundImage(buttonHover.backgroundImage)
	local buttonFocusBackgroundImage = CssHelper:resolveBackgroundImage(buttonFocus.backgroundImage)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	return React.createElement(HoverButton, {
		isSelected = isSelected,
		name = `TabButton-{props.value}`,
		default = {
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = if fill then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY,
			BackgroundColor3 = buttonDefault.backgroundColor,
			BackgroundTransparency = buttonDefault.backgroundTransparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Image = buttonDefaultBackgroundImage.Image,
			ImageColor3 = buttonDefaultBackgroundImage.ImageColor3,
			ImageTransparency = buttonDefaultBackgroundImage.ImageTransparency,
			ScaleType = buttonDefaultBackgroundImage.ScaleType,
			SliceCenter = buttonDefaultBackgroundImage.SliceCenter,
			SliceScale = buttonDefaultBackgroundImage.SliceScale,
			TileSize = buttonDefaultBackgroundImage.TileSize,
			Event = {
				Activated = function()
					selectTab(props.value)
				end,
			},
		},
		hover = {
			BackgroundColor3 = buttonHover.backgroundColor,
			BackgroundTransparency = buttonHover.backgroundTransparency,
			Image = buttonHoverBackgroundImage.Image,
			ImageColor3 = buttonHoverBackgroundImage.ImageColor3,
			ImageTransparency = buttonHoverBackgroundImage.ImageTransparency,
			ScaleType = buttonHoverBackgroundImage.ScaleType,
			SliceCenter = buttonHoverBackgroundImage.SliceCenter,
			SliceScale = buttonHoverBackgroundImage.SliceScale,
			TileSize = buttonHoverBackgroundImage.TileSize,
		},
		focus = {
			BackgroundColor3 = buttonFocus.backgroundColor,
			BackgroundTransparency = buttonFocus.backgroundTransparency,
			Image = buttonFocusBackgroundImage.Image,
			ImageColor3 = buttonFocusBackgroundImage.ImageColor3,
			ImageTransparency = buttonFocusBackgroundImage.ImageTransparency,
			ScaleType = buttonFocusBackgroundImage.ScaleType,
			SliceCenter = buttonFocusBackgroundImage.SliceCenter,
			SliceScale = buttonFocusBackgroundImage.SliceScale,
			TileSize = buttonFocusBackgroundImage.TileSize,
		},
	}, React.createElement(TabButtonContent, _attributes))
end
local function TabContent(props)
	local _binding = React.useContext(TabsContext)
	local selected = _binding.selected
	return React.createElement(Container, {
		name = `TabContent_{props.value}`,
		width = "100%",
		Visible = selected == props.value,
	}, props.children)
end
local TabsList = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {
		name = "TabsList",
		ref = ref,
		BackgroundColor3 = theme.components.tabs.list.backgroundColor,
		width = "100%",
	}
	local _condition = theme.components.tabs.list.backgroundTransparency
	if _condition == nil then
		_condition = 0
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.backgroundImage = theme.components.tabs.list.backgroundImage
	return React.createElement(Container, _attributes, React.createElement(Corners, {
		radius = theme.components.tabs.list.cornerRadius,
	}), React.createElement(Gradient, {
		value = theme.components.tabs.list.backgroundGradient,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing, theme.components.tabs.list.padding),
	}), React.createElement(TabsListContext.Provider, {
		value = {
			fill = props.fill == true,
		},
	}, React.createElement(HStack, {
		HorizontalFlex = if props.fill then Enum.UIFlexAlignment.Fill else nil,
		Wraps = if props.fill then false else nil,
		Padding = if theme.components.tabs.list.gap ~= nil then UDim.new(0, theme.components.tabs.list.gap) else nil,
	}, props.children)))
end)
local TabsBody = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	return React.createElement(Container, {
		name = "TabsBody",
		ref = ref,
		width = "100%",
		backgroundImage = props.backgroundImage or theme.components.tabs.backgroundImage,
	}, theme.components.tabs.borderThickness > 0 and (React.createElement("uistroke", {
		key = "Stroke",
		Thickness = theme.components.tabs.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.tabs.borderColor,
	})), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.spacing, theme.components.tabs.padding),
	}), React.createElement(Corners, {
		radius = theme.components.tabs.cornerRadius,
	}), React.createElement(Gradient, {
		value = props.backgroundGradient or theme.components.tabs.backgroundGradient,
	}), props.children)
end)
local Tabs = React.forwardRef(function(props, _ref)
	local theme = React.useContext(CleanThemeContext)
	local uncontrolledSelected, setUncontrolledSelected = React.useState(props.defaultValue)
	local controlled = props.value ~= nil
	local selected = if controlled then props.value else uncontrolledSelected
	local onValueChange = props.onValueChange
	local contextValue = React.useMemo(function()
		return {
			selected = selected,
			claimTab = function(value)
				if not controlled then
					setUncontrolledSelected(function(current)
						local _condition = current
						if _condition == nil then
							_condition = value
						end
						return _condition
					end)
				end
			end,
			selectTab = function(value)
				if not controlled then
					setUncontrolledSelected(value)
				end
				local _result = onValueChange
				if _result ~= nil then
					_result(value)
				end
			end,
		}
	end, { selected, controlled, onValueChange })
	return React.createElement(TabsContext.Provider, {
		value = contextValue,
	}, React.createElement(VStack, {
		Padding = if theme.components.tabs.gap ~= nil then UDim.new(0, theme.components.tabs.gap) else nil,
	}, props.children))
end)
Tabs.List = TabsList
Tabs.Body = TabsBody
Tabs.Title = TabTitle
Tabs.Content = TabContent
return {
	Tabs = Tabs,
}
