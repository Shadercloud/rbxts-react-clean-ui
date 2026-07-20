-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
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
local Menu
do
	local super = Component
	Menu = setmetatable({}, {
		__tostring = function()
			return "Menu"
		end,
		__index = super,
	})
	Menu.__index = Menu
	function Menu.new(...)
		local self = setmetatable({}, Menu)
		return self:constructor(...) or self
	end
	function Menu:constructor(...)
		super.constructor(self, ...)
		local _object = {}
		local _left = "collapsed"
		local _condition = self.props.collapsed
		if _condition == nil then
			_condition = false
		end
		_object[_left] = _condition
		self.state = _object
	end
	function Menu:render()
		return React.createElement(NavigationContext.Provider, {
			value = {
				collapsed = self.state.collapsed,
			},
		}, React.createElement(Group, nil, React.createElement(VStack, {
			spacing = "sm",
		}, React.createElement(Container, {
			group = true,
		}, React.createElement(HStack, {
			valign = "Center",
		}, React.createElement(Button, {
			icon = "bars",
			Event = {
				Activated = function()
					self:setState(function(state)
						return {
							collapsed = not state.collapsed,
						}
					end)
				end,
			},
		}), not self.state.collapsed and React.createElement(Text, {
			text = self.props.title,
			variant = "heading",
		}))), React.createElement(FlexItem, {
			mode = "Fill",
		}, React.createElement(Scroller, {
			height = "100%",
		}, React.createElement(VStack, {
			spacing = "sm",
			HorizontalFlex = Enum.UIFlexAlignment.None,
		}, self.props.children))))))
	end
	Menu = ReactComponent(Menu) or Menu
end
return {
	Menu = Menu,
}
