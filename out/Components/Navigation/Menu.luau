-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Button = TS.import(script, script.Parent.Parent, "Input").Button
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FlexItem = _Layout.FlexItem
local Group = _Layout.Group
local HStack = _Layout.HStack
local Scroller = _Layout.Scroller
local VStack = _Layout.VStack
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local NavigationContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").NavigationContext
local function MenuItem(props)
	local context = React.useContext(NavigationContext)
	return React.createElement(Button, {
		name = "MenuItem",
		text = if not context.collapsed then props.title else nil,
		icon = props.icon,
		Event = props.Event,
		group = true,
	})
end
local Menu = React.forwardRef(function(props, ref)
	local _condition = props.collapsed
	if _condition == nil then
		_condition = false
	end
	local collapsed, setCollapsed = React.useState(_condition)
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Menu"
	end
	_attributes.name = _condition_1
	_attributes.ref = ref
	return React.createElement(NavigationContext.Provider, {
		value = {
			collapsed = collapsed,
		},
	}, React.createElement(Container, _attributes, React.createElement(Group, nil, React.createElement(VStack, {
		spacing = "sm",
	}, React.createElement(Container, {
		name = "MenuHeader",
		group = true,
	}, React.createElement(HStack, {
		valign = "Center",
	}, React.createElement(Button, {
		name = "MenuToggleButton",
		icon = "bars",
		LayoutOrder = 1,
		Event = {
			Activated = function()
				setCollapsed(not collapsed)
			end,
		},
	}), not collapsed and React.createElement(Text, {
		name = "MenuTitle",
		text = props.title,
		variant = "heading",
		LayoutOrder = 2,
	}))), React.createElement(FlexItem, {
		mode = "Fill",
	}, React.createElement(Scroller, {
		height = "100%",
	}, React.createElement(VStack, {
		spacing = "sm",
		HorizontalFlex = Enum.UIFlexAlignment.None,
	}, props.children)))))))
end)
Menu.Item = MenuItem
return {
	MenuItem = MenuItem,
	Menu = Menu,
}
