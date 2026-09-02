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
local Padding = _Decorator.Padding
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _HoverButton = TS.import(script, script.Parent.Parent, "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
-- Selection only — Tabs.List/Tabs.Body/Tabs.Title/Tabs.Content each render
-- themselves for real (see Card.tsx's CardHeader/CardFooter for the same
-- "Root provides Context, subparts consume it independently" pattern), so
-- there's nothing here to scan or harvest from children.
local TabsContext = React.createContext({
	selected = nil,
	setSelected = function() end,
})
local function TabButtonContent(props)
	local theme = React.useContext(CleanThemeContext)
	local hover = React.useContext(HoverButtonContext)
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
	return React.createElement(React.Fragment, nil, React.createElement(Corners, {
		radius = theme.components.tabs.list.cornerRadius,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.tabs.button.spacing, theme.components.tabs.button.padding),
	}), React.createElement(BoxShadow, {
		value = intent.boxShadow,
	}), React.createElement(Text, {
		name = "TabTitleText",
		TextColor3 = intent.textColor,
		text = props.text,
		typography = TypographyHelper:getTypography(theme, nil, intent.typography),
	}))
end
-- The real per-tab button — derives its own default/hover/focus color scheme
-- from the theme (same per-instance derivation Card.Header/Card.Footer use,
-- not hoisted to Root) and drives selection itself via TabsContext.
local function TabTitle(props)
	local theme = React.useContext(CleanThemeContext)
	local _binding = React.useContext(TabsContext)
	local selected = _binding.selected
	local setSelected = _binding.setSelected
	local isSelected = selected == props.value
	-- The first-mounted Tabs.Title claims the selection if none is set yet,
	-- preserving "first tab selected by default" now that nothing scans the
	-- tab list up front. Known limitation: if the currently-selected tab's
	-- Tabs.Title unmounts, selection isn't automatically reassigned.
	React.useEffect(function()
		if selected == nil then
			setSelected(props.value)
		end
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
			AutomaticSize = Enum.AutomaticSize.XY,
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
					setSelected(props.value)
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
-- Always mounted — visibility is toggled rather than the panel being
-- unmounted/remounted, so per-tab local state (e.g. a Scroller's scroll
-- position) survives switching tabs. Roblox excludes a GuiObject with
-- Visible=false from its ancestors' AutomaticSize/UIListLayout
-- content-size calculations, so the hidden panels don't inflate Tabs.Body's
-- own AutomaticSize; since only one panel is ever visible at a time, the
-- default (unset) Position/AnchorPoint every panel shares never causes a
-- visible overlap either.
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
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing, theme.components.tabs.list.padding),
	}), React.createElement(HStack, nil, props.children))
end)
local TabsBody = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	return React.createElement(Container, {
		name = "TabsBody",
		ref = ref,
		width = "100%",
		backgroundImage = props.backgroundImage or theme.components.tabs.backgroundImage,
	}, React.createElement("uistroke", {
		key = "Stroke",
		Thickness = theme.components.tabs.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.tabs.borderColor,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.spacing, theme.components.tabs.padding),
	}), React.createElement(Corners, {
		radius = theme.components.tabs.cornerRadius,
	}), props.children)
end)
-- Root doesn't render a real Roblox Instance of its own (just a Context
-- Provider around a VStack, itself just a Fragment) — see Group.tsx for the
-- same shape. It's still wrapped in React.forwardRef, not a plain function,
-- because roblox-ts compiles a bare arrow function to an actual Lua
-- `function` value, and Lua functions can't have table-style properties
-- (Tabs.List = ...) assigned onto them — forwardRef's return value compiles
-- to a table instead. The ref itself is genuinely unused: there's no
-- sensible Instance for it to point at, so RefAttributes<Frame> below is a
-- type-level placeholder to keep this consistent with every other compound
-- component's shape, not a real forwarded ref — Tabs does not support a
-- `ref` prop in practice.
local Tabs = React.forwardRef(function(props, _ref)
	local selected, setSelected = React.useState(props.defaultValue)
	local contextValue = React.useMemo(function()
		return {
			selected = selected,
			setSelected = setSelected,
		}
	end, { selected })
	return React.createElement(TabsContext.Provider, {
		value = contextValue,
	}, React.createElement(VStack, nil, props.children))
end)
Tabs.List = TabsList
Tabs.Body = TabsBody
Tabs.Title = TabTitle
Tabs.Content = TabContent
return {
	Tabs = Tabs,
}
