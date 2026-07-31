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
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _HoverButton = TS.import(script, script.Parent.Parent, "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
local function Tab(_props)
	return nil
end
local function TabTitle(_props)
	return nil
end
local function TabContent(props)
	return nil
end
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
		radius = theme.components.tabs.button.cornerRadius,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.button.spacing),
	}), React.createElement(BoxShadow, {
		value = intent.boxShadow,
	}), React.createElement(Text, {
		TextColor3 = intent.textColor,
		text = props.text,
		typography = TypographyHelper:getTypography(theme, nil, intent.typography),
	}))
end
local Tabs = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local selected, setSelected = React.useState(0)
	local tabs = React.useMemo(function()
		local tabs = {}
		React.Children.forEach(props.children, function(child)
			if not React.isValidElement(child) or child.type ~= Tab then
				return nil
			end
			local title
			local content
			local tab = child
			React.Children.forEach(tab.props.children, function(tabChild)
				if not React.isValidElement(tabChild) then
					return nil
				end
				if tabChild.type == TabTitle then
					title = (tabChild.props)
				elseif tabChild.type == TabContent then
					content = (tabChild.props).children
				end
			end)
			if title ~= nil then
				local _arg0 = {
					title = title,
					content = content,
				}
				table.insert(tabs, _arg0)
			end
		end)
		return tabs
	end, { props.children })
	local tabCount = #tabs
	React.useEffect(function()
		if selected >= tabCount then
			setSelected(math.max(0, tabCount - 1))
		end
	end, { selected, tabCount })
	local selectedTab = tabs[selected + 1]
	local buttonDefault = ColorHelper:getIntentColors(theme, "primary", "default", theme.components.tabs.button.intents)
	local buttonHover = ColorHelper:getIntentColors(theme, "primary", "hover", theme.components.tabs.button.intents)
	local buttonFocus = ColorHelper:getIntentColors(theme, "primary", "focus", theme.components.tabs.button.intents)
	local _exp = React.createElement(Corners, {
		radius = theme.components.tabs.list.cornerRadius,
	})
	local _exp_1 = React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.list.spacing),
	})
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#tabs)
	local _callback = function(tab, index)
		return React.createElement(HoverButton, {
			isSelected = selected == index,
			default = {
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				ImageTransparency = 1,
				BackgroundColor3 = buttonDefault.backgroundColor,
				BackgroundTransparency = buttonDefault.backgroundTransparency,
				BorderSizePixel = 0,
				AutoButtonColor = false,
				Event = {
					Activated = function()
						setSelected(index)
					end,
				},
			},
			hover = {
				BackgroundColor3 = buttonHover.backgroundColor,
				BackgroundTransparency = buttonHover.backgroundTransparency,
			},
			focus = {
				BackgroundColor3 = buttonFocus.backgroundColor,
				BackgroundTransparency = buttonFocus.backgroundTransparency,
			},
		}, React.createElement(TabButtonContent, {
			text = tab.title.text,
		}))
	end
	for _k, _v in tabs do
		_newValue[_k] = _callback(_v, _k - 1, tabs)
	end
	-- ▲ ReadonlyArray.map ▲
	local _exp_2 = React.createElement(Container, {
		ref = ref,
		BackgroundColor3 = theme.components.tabs.list.backgroundColor,
		width = "100%",
		BackgroundTransparency = 0,
	}, _exp, _exp_1, React.createElement(HStack, nil, _newValue))
	local _exp_3 = React.createElement("uistroke", {
		Thickness = theme.components.tabs.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.tabs.borderColor,
	})
	local _exp_4 = React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.tabs.spacing),
	})
	local _exp_5 = React.createElement(Corners, {
		radius = theme.components.tabs.list.cornerRadius,
	})
	local _result = selectedTab
	if _result ~= nil then
		_result = _result.content
	end
	return React.createElement(VStack, nil, _exp_2, React.createElement(Container, nil, _exp_3, _exp_4, _exp_5, _result))
end)
Tabs.Title = TabTitle
Tabs.Tab = Tab
Tabs.Content = TabContent
return {
	Tabs = Tabs,
}
