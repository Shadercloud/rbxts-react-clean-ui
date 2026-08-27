-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local OverlayContext = _Contexts.OverlayContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SizeHelper = _Helpers.SizeHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FieldsetContext = _Layout.FieldsetContext
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
		context.setSelected(props.index, props.value)
		context.closeDropdown()
	end
	_attributes.Event = _object
	_attributes.Size = UDim2.new(1, 0, 0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.BackgroundTransparency = 0
	_attributes.BackgroundColor3 = ColorHelper:getIntentColors(theme, "primary", if context.selected == props.index then "focus" elseif hover then "hover" else "default", theme.components.select.intents).backgroundColor
	_attributes.AutoButtonColor = false
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	return React.createElement("imagebutton", _attributes, React.createElement(Padding, _attributes_1), props.text ~= nil and props.children == nil and React.createElement(Text, {
		text = props.text,
		TextColor3 = ColorHelper:getIntentColors(theme, "primary", if context.selected == props.index then "focus" elseif hover then "hover" else "default", theme.components.select.intents).textColor,
	}), props.children)
end
local Select = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local overlay = React.useContext(OverlayContext)
	local fieldset = React.useContext(FieldsetContext)
	local _condition = props.selected
	if _condition == nil then
		_condition = 0
	end
	local selected, setSelected = React.useState(_condition)
	local open, setOpen = React.useState(false)
	local dropdownSize, setDropdownSize = React.useState(UDim2.fromOffset(0, 0))
	local dropdownPosition, setDropdownPosition = React.useState(UDim2.fromOffset(0, 0))
	local contentHeight, setContentHeight = React.useState(0)
	local buttonRef = React.useRef()
	local context = React.useMemo(function()
		return {
			selected = selected,
			open = open,
			dropdownSize = dropdownSize,
			dropdownPosition = dropdownPosition,
			buttonRef = buttonRef,
			setSelected = function(index, value)
				local _result = props.onChange
				if _result ~= nil then
					_result(index, value)
				end
				setSelected(index)
			end,
			openDropdown = function(size, position)
				setDropdownPosition(position)
				setDropdownSize(size)
				setOpen(true)
			end,
			closeDropdown = function()
				setOpen(false)
			end,
			toggleOpen = function()
				setOpen(function(current)
					return not current
				end)
			end,
		}
	end, { props.onChange, selected, open, dropdownSize, dropdownPosition })
	local typography = TypographyHelper:getTypography(theme, props.scale, theme.components.select.typography)
	local children = React.Children.toArray(props.children)
	local selectedOption = (children[selected + 1] or children[1])
	local dropdownHeight = math.min(contentHeight, if props["max-height"] ~= nil then SizeHelper:toUDim(props["max-height"]).Offset else theme.components.select.maxDropDownHeight)
	local activateSelect = React.useCallback(function()
		local button = buttonRef.current
		local overlayInstance = overlay.overlay
		if not button or not overlayInstance then
			return nil
		end
		if open then
			setOpen(false)
			return nil
		end
		local _absolutePosition = button.AbsolutePosition
		local _absolutePosition_1 = overlayInstance.AbsolutePosition
		local localPosition = _absolutePosition - _absolutePosition_1
		setDropdownPosition(UDim2.fromOffset(localPosition.X, localPosition.Y))
		setDropdownSize(UDim2.fromOffset(button.AbsoluteSize.X, button.AbsoluteSize.Y))
		setOpen(true)
	end, { open, overlay.overlay })
	local _exp = function()
		local _labelActivated = fieldset
		if _labelActivated ~= nil then
			_labelActivated = _labelActivated.labelActivated
		end
		local labelActivated = _labelActivated
		if not labelActivated then
			return nil
		end
		local connection = labelActivated.Event:Connect(activateSelect)
		return function()
			return connection:Disconnect()
		end
	end
	local _result = fieldset
	if _result ~= nil then
		_result = _result.labelActivated
	end
	React.useEffect(_exp, { _result, activateSelect })
	if open and overlay.overlay == nil then
		warn("You have used a Select component without using the Overlay Provider")
	end
	local _attributes = {
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = UDim2.fromScale(1, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.backgroundImage = props.backgroundImage or theme.components.select.backgroundImage
	local _exp_1 = React.createElement("uistroke", {
		Thickness = theme.components.select.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.select.borderColor,
	})
	local _exp_2 = React.createElement(Corners, {
		radius = theme.components.select.cornerRadius,
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	local _exp_3 = React.createElement(Padding, _attributes_1)
	local _attributes_2 = {}
	local _result_1 = selectedOption
	if _result_1 ~= nil then
		_result_1 = _result_1.props.text
	end
	local _condition_1 = _result_1
	if _condition_1 == nil then
		_condition_1 = "No Options"
	end
	_attributes_2.text = _condition_1
	_attributes_2.typography = typography
	local _exp_4 = React.createElement(HStack, nil, React.createElement(FlexItem, nil, React.createElement(Text, _attributes_2)), React.createElement(Icon, {
		icon = "caret-down",
		color = theme.colors.intents.primary.default.textColor,
	}))
	local _condition_2 = open and overlay.overlay ~= nil
	if _condition_2 then
		local _attributes_3 = {
			BackgroundTransparency = 0,
			BackgroundColor3 = theme.components.select.dropDownBackgroundColor,
			AnchorPoint = Vector2.zero,
		}
		local _uDim2 = UDim2.new(0, 0, 0, dropdownSize.Y.Offset)
		_attributes_3.Position = dropdownPosition + _uDim2
		_attributes_3.Size = UDim2.fromOffset(dropdownSize.X.Offset, 0)
		_attributes_3.AutomaticSize = Enum.AutomaticSize.Y
		_attributes_3.ClipsDescendants = true
		_condition_2 = ReactRoblox.createPortal(React.createElement("frame", _attributes_3, React.createElement("uistroke", {
			Thickness = theme.components.select.borderThickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Outer,
			Color = theme.components.select.borderColor,
		}), React.createElement(Corners, {
			radius = theme.components.select.cornerRadius,
		}), React.createElement(Scroller, {
			Size = UDim2.new(1, 0, 0, dropdownHeight),
			spacing = "None",
		}, React.createElement(VStack, {
			spacing = "None",
			Change = {
				AbsoluteContentSize = function(layout)
					setContentHeight(layout.AbsoluteContentSize.Y)
				end,
			},
		}, React.Children.map(props.children, function(child, childIndex)
			if not React.isValidElement(child) then
				return child
			end
			-- React.Children.map uses a 1-based index in roblox-ts.
			local optionIndex = childIndex - 1
			return React.cloneElement(child, {
				index = optionIndex,
			})
		end)))), overlay.overlay)
	end
	return React.createElement(Container, _attributes, React.createElement(SelectContext.Provider, {
		value = context,
	}, React.createElement("imagebutton", {
		ref = buttonRef,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Event = {
			Activated = activateSelect,
		},
	}, _exp_1, _exp_2, _exp_3, _exp_4, _condition_2)))
end)
Select.Option = SelectOption
return {
	Select = Select,
}
