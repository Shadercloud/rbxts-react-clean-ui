-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local OverlayContext = _Contexts.OverlayContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local FlexItem = _Layout.FlexItem
local HStack = _Layout.HStack
local Scroller = _Layout.Scroller
local VStack = _Layout.VStack
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local Icon = TS.import(script, script.Parent.Parent, "Surface").Icon
local SelectContext = React.createContext(nil)
local function SelectOption(props)
	local theme = React.useContext(CleanThemeContext)
	local hover, setHover = React.useState(false)
	local context = React.useContext(SelectContext)
	local _arg0 = context ~= nil
	assert(_arg0, "Select.Option must be used inside a Select")
	local _arg0_1 = props.index ~= nil
	assert(_arg0_1, "Select.Option must be a direct child of Select")
	local _attributes = {}
	local _object = {}
	local _spread = props.Event
	if _spread then
		for _k, _v in _spread do
			_object[_k] = _v
		end
	end
	_object.MouseEnter = function(button, x, y)
		setHover(true)
		local _result = props.Event
		if _result ~= nil then
			_result = _result.MouseEnter
			if _result ~= nil then
				_result(button, x, y)
			end
		end
	end
	_object.MouseLeave = function(button, x, y)
		setHover(false)
		local _result = props.Event
		if _result ~= nil then
			_result = _result.MouseLeave
			if _result ~= nil then
				_result(button, x, y)
			end
		end
	end
	_object.Activated = function()
		context.setSelected(props.index)
		context.toggleOpen()
	end
	_attributes.Event = _object
	_attributes.Size = UDim2.new(1, 0, 0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.BackgroundTransparency = 0
	_attributes.BackgroundColor3 = ColorHelper:getIntentColor(theme, if context.selected == props.index then "info" else "primary", if hover or context.selected == props.index then "hover" else "background", theme.components.select.intents, props.BackgroundColor3)
	_attributes.AutoButtonColor = false
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	return React.createElement("imagebutton", _attributes, React.createElement(Padding, _attributes_1), props.text ~= nil and React.createElement(Text, {
		text = props.text,
	}), props.children)
end
local function SelectRenderer()
	local context = React.useContext(SelectContext)
	local theme = React.useContext(CleanThemeContext)
	local overlay = React.useContext(OverlayContext)
	local contentHeight, setContentHeight = React.useState(0)
	local _arg0 = context ~= nil
	assert(_arg0, "SelectRenderer must be used inside a Select")
	local typography = TypographyHelper:getTypography(theme, context.props.scale, theme.components.select.typography)
	local children = React.Children.toArray(context.props.children)
	local selectedOption = (children[context.selected + 1] or children[1])
	local dropdownHeight = math.min(contentHeight, 200)
	local _exp = React.createElement("uistroke", {
		Thickness = theme.components.select.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.select.borderColor,
	})
	local _exp_1 = React.createElement(Corners, {
		radius = theme.components.select.cornerRadius,
	})
	local _attributes = table.clone(context.props)
	setmetatable(_attributes, nil)
	local _exp_2 = React.createElement(Padding, _attributes)
	local _attributes_1 = {}
	local _result = selectedOption
	if _result ~= nil then
		_result = _result.props.text
	end
	local _condition = _result
	if _condition == nil then
		_condition = "No Options"
	end
	_attributes_1.text = _condition
	_attributes_1.typography = typography
	local _exp_3 = React.createElement(HStack, nil, React.createElement(FlexItem, nil, React.createElement(Text, _attributes_1)), React.createElement(Icon, {
		icon = "caret-down",
		color = theme.colors.intents.primary.text,
	}))
	local _condition_1 = context.open and overlay.overlay ~= nil
	if _condition_1 then
		local _attributes_2 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = theme.components.select.dropDownBackgroundColor,
			AnchorPoint = Vector2.zero,
		}
		local _dropdownPosition = context.dropdownPosition
		local _uDim2 = UDim2.new(0, 0, 0, context.dropdownSize.Y.Offset)
		_attributes_2.Position = _dropdownPosition + _uDim2
		_attributes_2.Size = UDim2.fromOffset(context.dropdownSize.X.Offset, 0)
		_attributes_2.AutomaticSize = Enum.AutomaticSize.Y
		_attributes_2.ClipsDescendants = true
		_attributes_2.ZIndex = 1000
		_condition_1 = ReactRoblox.createPortal(React.createElement("frame", _attributes_2, React.createElement("uistroke", {
			Thickness = theme.components.select.borderThickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Outer,
			Color = theme.components.select.borderColor,
		}), React.createElement(Corners, {
			radius = theme.components.select.cornerRadius,
		}), React.createElement(Scroller, {
			Size = UDim2.new(1, 0, 0, dropdownHeight),
			spacing = "None",
		}, React.createElement(Corners, {
			radius = theme.components.select.cornerRadius,
		}), React.createElement(VStack, {
			spacing = "None",
			Change = {
				AbsoluteContentSize = function(layout)
					setContentHeight(layout.AbsoluteContentSize.Y)
				end,
			},
		}, React.Children.map(context.props.children, function(child, index)
			if not React.isValidElement(child) then
				return child
			end
			return React.cloneElement(child, {
				index = index - 1,
			})
		end)))), overlay.overlay)
	end
	return React.createElement("imagebutton", {
		ref = context.buttonRef,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Event = {
			Activated = function()
				local button = context.buttonRef.current
				if button and overlay.overlay then
					local buttonPosition = button.AbsolutePosition
					local overlayPosition = overlay.overlay.AbsolutePosition
					local localPosition = buttonPosition - overlayPosition
					context.setDropdown(UDim2.fromOffset(button.AbsoluteSize.X, button.AbsoluteSize.Y), UDim2.fromOffset(localPosition.X, localPosition.Y))
				end
				context.toggleOpen()
			end,
		},
	}, _exp, _exp_1, _exp_2, _exp_3, _condition_1)
end
local Select
do
	local super = Component
	Select = setmetatable({}, {
		__tostring = function()
			return "Select"
		end,
		__index = super,
	})
	Select.__index = Select
	function Select.new(...)
		local self = setmetatable({}, Select)
		return self:constructor(...) or self
	end
	function Select:constructor(...)
		super.constructor(self, ...)
		local _object = {}
		local _left = "selected"
		local _condition = self.props.selected
		if _condition == nil then
			_condition = 0
		end
		_object[_left] = _condition
		_object.open = false
		_object.dropdownSize = UDim2.fromOffset(0, 0)
		_object.dropdownPosition = UDim2.fromOffset(0, 0)
		self.state = _object
		self.buttonRef = React.createRef()
	end
	function Select:render()
		local context = {
			props = self.props,
			selected = self.state.selected,
			open = self.state.open,
			dropdownSize = self.state.dropdownSize,
			dropdownPosition = self.state.dropdownPosition,
			buttonRef = self.buttonRef,
			setSelected = function(selected)
				print(selected)
				self:setState({
					selected = selected,
				})
			end,
			setDropdown = function(size, position)
				self:setState({
					dropdownSize = size,
					dropdownPosition = position,
				})
			end,
			toggleOpen = function()
				self:setState(function(state)
					return {
						open = not state.open,
					}
				end)
			end,
		}
		return React.createElement(SelectContext.Provider, {
			value = context,
		}, React.createElement(SelectRenderer))
	end
	Select.Option = SelectOption
	Select = ReactComponent(Select) or Select
end
return {
	Select = Select,
}
