-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local OverlayContext = _Contexts.OverlayContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Gradient = _Decorator.Gradient
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
local Input = TS.import(script, script.Parent, "Input").Input
local _Input_field = TS.import(script, script.Parent, "Input.field")
local FieldBoxShadow = _Input_field.FieldBoxShadow
local FieldInnerShadow = _Input_field.FieldInnerShadow
local resolveFieldState = _Input_field.resolveFieldState
local resolveFieldStateStyle = _Input_field.resolveFieldStateStyle
local SelectContext = React.createContext(nil)
local function SelectOption(props)
	local theme = React.useContext(CleanThemeContext)
	local hover, setHover = React.useState(false)
	local context = React.useContext(SelectContext)
	local _arg0 = context ~= nil
	assert(_arg0, "Select.Option must be used inside a Select")
	local _arg0_1 = props.index ~= nil
	assert(_arg0_1, "Select.Option must be a direct child of Select or Select.OptGroup")
	local _attributes = {
		key = "Option",
	}
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
	_attributes.BorderSizePixel = 0
	_attributes.BackgroundColor3 = ColorHelper:getIntentColors(theme, "primary", if context.selected == props.index then "focus" elseif hover then "hover" else "default", theme.components.select.intents).backgroundColor
	_attributes.AutoButtonColor = false
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	return React.createElement("imagebutton", _attributes, React.createElement(Padding, _attributes_1), props.text ~= nil and props.children == nil and React.createElement(Text, {
		name = "OptionText",
		text = props.text,
		TextColor3 = ColorHelper:getIntentColors(theme, "primary", if context.selected == props.index then "focus" elseif hover then "hover" else "default", theme.components.select.intents).textColor,
	}), props.children)
end
local function SelectOptGroup(_props)
	return nil
end
local function parseSelectChildren(children)
	local sections = {}
	local flatOptions = {}
	local index = 0
	local nodeCount = 0
	local groupCount = 0
	local collectGroupOptions
	collectGroupOptions = function(node, options)
		React.Children.forEach(node, function(groupChild)
			if React.isValidElement(groupChild) and groupChild.type == React.Fragment then
				collectGroupOptions((groupChild.props).children, options)
				return nil
			end
			if not React.isValidElement(groupChild) or groupChild.type ~= SelectOption then
				return nil
			end
			local _object = {}
			local _left = "index"
			local _original = index
			index += 1
			_object[_left] = _original
			_object.element = groupChild
			_object.text = groupChild.props.text
			local option = _object
			table.insert(options, option)
			table.insert(flatOptions, option)
		end)
	end
	local visit
	visit = function(child)
		if React.isValidElement(child) and child.type == React.Fragment then
			React.Children.forEach((child.props).children, visit)
			return nil
		end
		if React.isValidElement(child) and child.type == SelectOption then
			local _object = {}
			local _left = "index"
			local _original = index
			index += 1
			_object[_left] = _original
			_object.element = child
			_object.text = child.props.text
			local option = _object
			local _arg0 = {
				kind = "option",
				option = option,
			}
			table.insert(sections, _arg0)
			table.insert(flatOptions, option)
			return nil
		end
		if React.isValidElement(child) and child.type == SelectOptGroup then
			local options = {}
			collectGroupOptions(child.props.children, options)
			local _object = {
				kind = "group",
			}
			local _left = "group"
			local _object_1 = {}
			local _left_1 = "key"
			local _original = groupCount
			groupCount += 1
			_object_1[_left_1] = `group-{_original}`
			_object_1.label = child.props.label
			_object_1.options = options
			_object[_left] = _object_1
			table.insert(sections, _object)
			return nil
		end
		local _object = {
			kind = "node",
		}
		local _left = "key"
		local _original = nodeCount
		nodeCount += 1
		_object[_left] = `node-{_original}`
		_object.node = child
		table.insert(sections, _object)
	end
	React.Children.forEach(children, visit)
	return {
		sections = sections,
		flatOptions = flatOptions,
	}
end
local function optionMatchesQuery(option, normalizedQuery)
	if normalizedQuery == "" then
		return true
	end
	if option.text == nil then
		return true
	end
	local _exp = string.lower(option.text)
	local _normalizedQuery = normalizedQuery
	return (string.find(_exp, _normalizedQuery, 1, true)) ~= nil
end
local function SelectSearchInput(props)
	local theme = React.useContext(CleanThemeContext)
	local _exp = React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.select.search.spacing, theme.components.select.search.padding),
	})
	local _attributes = {
		icon = "search",
		controlled = true,
		value = props.value,
		onChange = props.onChange,
	}
	local _condition = props.placeholder
	if _condition == nil then
		_condition = "Search"
	end
	_attributes.placeholder = _condition
	_attributes.scale = props.scale
	return React.createElement("frame", {
		key = "SearchInput",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, _exp, React.createElement(Input, _attributes))
end
local function SelectGroupHeader(props)
	local theme = React.useContext(CleanThemeContext)
	local typography = TypographyHelper:getTypography(theme, props.scale, theme.components.select.optGroup.typography)
	local _attributes = {
		key = "OptGroupHeader",
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.components.select.optGroup.backgroundColor,
	}
	local _condition = theme.components.select.optGroup.backgroundTransparency
	if _condition == nil then
		_condition = 1
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BorderSizePixel = 0
	return React.createElement("frame", _attributes, React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, theme.components.select.optGroup.spacing, theme.components.select.optGroup.padding),
	}), React.createElement(Text, {
		name = "OptGroupLabel",
		text = props.label,
		TextColor3 = theme.components.select.optGroup.textColor,
		typography = typography,
	}))
end
local function SelectCaretCap(props)
	local theme = React.useContext(CleanThemeContext)
	local caret = props.caret
	local _result
	if caret.size ~= nil then
		_result = SizeHelper:toUDim(caret.size).Offset
	else
		local _condition = theme.iconSize[theme.default.scale]
		if _condition == nil then
			_condition = 0
		end
		_result = _condition
	end
	local size = _result
	local margin = if caret.margin ~= nil then CssHelper:parseCssQuad(caret.margin) else SpacingHelper:ResolveNumberPadding(0)
	local _condition = caret.borderThickness
	if _condition == nil then
		_condition = 0
	end
	local borderThickness = _condition
	local filled = caret.backgroundColor ~= nil or caret.backgroundGradient ~= nil
	local _attributes = {
		key = "SelectCaretCapFlex",
	}
	local _result_1 = Enum.ItemLineAlignment
	if _result_1 ~= nil then
		_result_1 = _result_1.Center
	end
	_attributes.ItemLineAlignment = _result_1
	local _exp = React.createElement("uiflexitem", _attributes)
	local _attributes_1 = {
		key = "Cap",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, margin.left, 0.5, (margin.top - margin.bottom) / 2),
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = caret.backgroundColor or Color3.new(1, 1, 1),
	}
	local _condition_1 = caret.backgroundTransparency
	if _condition_1 == nil then
		_condition_1 = (if filled then 0 else 1)
	end
	_attributes_1.BackgroundTransparency = _condition_1
	_attributes_1.BorderSizePixel = 0
	return React.createElement("frame", {
		key = "SelectCaretCap",
		Size = UDim2.fromOffset(math.max(0, size + margin.left + margin.right), math.max(0, size + margin.top + margin.bottom - props.inset)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, _exp, React.createElement("frame", _attributes_1, borderThickness > 0 and (React.createElement("uistroke", {
		key = "Stroke",
		Thickness = borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = caret.borderColor,
	})), React.createElement(Corners, {
		radius = caret.cornerRadius,
	}), React.createElement(Gradient, {
		value = caret.backgroundGradient,
	}), React.createElement(Icon, {
		name = "SelectCaret",
		icon = "caret-down",
		color = props.color,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
	})))
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
	local query, setQuery = React.useState("")
	local hovered, setHovered = React.useState(false)
	local selectTheme = theme.components.select
	local stateStyle = resolveFieldStateStyle(selectTheme.states, resolveFieldState(props.disabled, open, hovered))
	local _condition_1 = stateStyle.borderThickness
	if _condition_1 == nil then
		_condition_1 = selectTheme.borderThickness
	end
	local borderThickness = _condition_1
	local _result = selectTheme.dropDown
	if _result ~= nil then
		_result = _result.gap
	end
	local _condition_2 = _result
	if _condition_2 == nil then
		_condition_2 = 0
	end
	local dropDownGap = _condition_2
	local buttonRef = React.useRef()
	local context = React.useMemo(function()
		return {
			selected = selected,
			open = open,
			dropdownSize = dropdownSize,
			dropdownPosition = dropdownPosition,
			buttonRef = buttonRef,
			setSelected = function(index, value)
				local _result_1 = props.onChange
				if _result_1 ~= nil then
					_result_1(index, value)
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
	local _binding = React.useMemo(function()
		return parseSelectChildren(props.children)
	end, { props.children })
	local sections = _binding.sections
	local flatOptions = _binding.flatOptions
	local _result_1 = flatOptions[selected + 1]
	if _result_1 ~= nil then
		_result_1 = _result_1.element
	end
	local _condition_3 = _result_1
	if _condition_3 == nil then
		local _result_2 = flatOptions[1]
		if _result_2 ~= nil then
			_result_2 = _result_2.element
		end
		_condition_3 = _result_2
	end
	local selectedOption = _condition_3
	React.useEffect(function()
		if not open then
			setQuery("")
		end
	end, { open })
	local normalizedQuery = if props.searchable then string.lower(query) else ""
	local renderOption = function(option)
		return React.cloneElement(option.element, {
			index = option.index,
			key = `option-{option.index}`,
		})
	end
	local renderSections = function()
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#sections)
		local _callback = function(section)
			if section.kind == "node" then
				return section.node
			end
			if section.kind == "option" then
				if props.searchable and not optionMatchesQuery(section.option, normalizedQuery) then
					return nil
				end
				return renderOption(section.option)
			end
			if #section.group.options == 0 then
				return nil
			end
			local _result_2
			if props.searchable then
				local _exp = section.group.options
				-- ▼ ReadonlyArray.filter ▼
				local _newValue_1 = {}
				local _callback_1 = function(option)
					return optionMatchesQuery(option, normalizedQuery)
				end
				local _length = 0
				for _k, _v in _exp do
					if _callback_1(_v, _k - 1, _exp) == true then
						_length += 1
						_newValue_1[_length] = _v
					end
				end
				-- ▲ ReadonlyArray.filter ▲
				_result_2 = _newValue_1
			else
				_result_2 = section.group.options
			end
			local visibleOptions = _result_2
			if props.searchable and query ~= "" and #visibleOptions == 0 then
				return nil
			end
			local _exp = React.createElement(SelectGroupHeader, {
				label = section.group.label,
				scale = props.scale,
			})
			-- ▼ ReadonlyArray.map ▼
			local _newValue_1 = table.create(#visibleOptions)
			for _k, _v in visibleOptions do
				_newValue_1[_k] = renderOption(_v, _k - 1, visibleOptions)
			end
			-- ▲ ReadonlyArray.map ▲
			return React.createElement(React.Fragment, {
				key = section.group.key,
			}, _exp, _newValue_1)
		end
		for _k, _v in sections do
			_newValue[_k] = _callback(_v, _k - 1, sections)
		end
		-- ▲ ReadonlyArray.map ▲
		return _newValue
	end
	local _condition_4 = not props.searchable or query == ""
	if not _condition_4 then
		-- ▼ ReadonlyArray.some ▼
		local _result_2 = false
		local _callback = function(option)
			return optionMatchesQuery(option, normalizedQuery)
		end
		for _k, _v in flatOptions do
			if _callback(_v, _k - 1, flatOptions) then
				_result_2 = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		_condition_4 = _result_2
	end
	local hasVisibleOptions = _condition_4
	local dropdownHeight = math.min(contentHeight, if props["max-height"] ~= nil then SizeHelper:toUDim(props["max-height"]).Offset else theme.components.select.maxDropDownHeight)
	local activateSelect = React.useCallback(function()
		local button = buttonRef.current
		local overlayInstance = overlay.overlay
		if not button or not overlayInstance or props.disabled then
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
	end, { open, overlay.overlay, props.disabled })
	React.useEffect(function()
		if props.disabled then
			setOpen(false)
		end
	end, { props.disabled })
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
	local _result_2 = fieldset
	if _result_2 ~= nil then
		_result_2 = _result_2.labelActivated
	end
	React.useEffect(_exp, { _result_2, activateSelect })
	local _condition_5 = stateStyle.backgroundTransparency
	if _condition_5 == nil then
		_condition_5 = selectTheme.backgroundTransparency
		if _condition_5 == nil then
			_condition_5 = 1
		end
	end
	local themeBackgroundTransparency = _condition_5
	local _result_3 = selectTheme.caret
	if _result_3 ~= nil then
		_result_3 = _result_3.iconColor
	end
	local _condition_6 = _result_3
	if _condition_6 == nil then
		_condition_6 = selectTheme.iconColor or theme.colors.intents.primary.default.textColor
	end
	local caretColor = _condition_6
	local fieldPadding = SpacingHelper:GetResolvedPadding(theme, props)
	local capInset = fieldPadding.top + fieldPadding.bottom - 2 * selectTheme.borderThickness
	if open and overlay.overlay == nil then
		warn("You have used a Select component without using the Overlay Provider")
	end
	local _attributes = {}
	local _condition_7 = props.name
	if _condition_7 == nil then
		_condition_7 = "Select"
	end
	_attributes.name = _condition_7
	_attributes.ref = ref
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = if props.width ~= nil then nil else UDim2.fromScale(1, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.BackgroundColor3 = props.BackgroundColor3 or stateStyle.backgroundColor or selectTheme.backgroundColor
	local _condition_8 = props.BackgroundTransparency
	if _condition_8 == nil then
		_condition_8 = themeBackgroundTransparency
	end
	_attributes.BackgroundTransparency = _condition_8
	_attributes.backgroundImage = props.backgroundImage or theme.components.select.backgroundImage
	local _exp_1 = themeBackgroundTransparency < 1 and React.createElement(Corners, {
		radius = theme.components.select.cornerRadius,
	})
	local _exp_2 = React.createElement(Gradient, {
		value = props.backgroundGradient or stateStyle.backgroundGradient or selectTheme.backgroundGradient,
	})
	local _exp_3 = React.createElement(FieldBoxShadow, {
		value = selectTheme.boxShadow,
	})
	local _exp_4 = selectTheme.innerShadow ~= nil and (React.createElement(FieldInnerShadow, {
		value = selectTheme.innerShadow,
		cornerRadius = selectTheme.cornerRadius,
		inset = borderThickness,
	}))
	local _exp_5 = React.createElement("uistroke", {
		key = "Stroke",
		Thickness = borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = stateStyle.borderColor or selectTheme.borderColor,
	})
	local _exp_6 = React.createElement(Corners, {
		radius = theme.components.select.cornerRadius,
	})
	local _attributes_1 = table.clone(props)
	setmetatable(_attributes_1, nil)
	local _exp_7 = React.createElement(Padding, _attributes_1)
	local _attributes_2 = {}
	local _result_4 = Enum.ItemLineAlignment
	if _result_4 ~= nil then
		_result_4 = _result_4.Center
	end
	_attributes_2.ItemLineAlignment = _result_4
	local _attributes_3 = {
		name = "SelectedText",
	}
	local _result_5 = selectedOption
	if _result_5 ~= nil then
		_result_5 = _result_5.props.text
	end
	local _condition_9 = _result_5
	if _condition_9 == nil then
		_condition_9 = "No Options"
	end
	_attributes_3.text = _condition_9
	_attributes_3.typography = typography
	_attributes_3.TextColor3 = theme.components.select.textColor
	local _exp_8 = React.createElement(HStack, nil, React.createElement(FlexItem, _attributes_2, React.createElement(Text, _attributes_3)), if selectTheme.caret == nil then React.createElement(Icon, {
		name = "SelectCaret",
		icon = "caret-down",
		color = caretColor,
	}) else React.createElement(SelectCaretCap, {
		caret = selectTheme.caret,
		color = caretColor,
		inset = capInset,
	}))
	local _condition_10 = open and overlay.overlay ~= nil
	if _condition_10 then
		local _attributes_4 = {
			key = "SelectDropdown",
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = theme.components.select.dropDownBackgroundColor,
			AnchorPoint = Vector2.zero,
		}
		local _uDim2 = UDim2.new(0, 0, 0, dropdownSize.Y.Offset + dropDownGap)
		_attributes_4.Position = dropdownPosition + _uDim2
		_attributes_4.Size = UDim2.fromOffset(dropdownSize.X.Offset, 0)
		_attributes_4.AutomaticSize = Enum.AutomaticSize.Y
		_attributes_4.ClipsDescendants = true
		local _attributes_5 = {
			key = "Stroke",
		}
		local _result_6 = selectTheme.dropDown
		if _result_6 ~= nil then
			_result_6 = _result_6.borderThickness
		end
		local _condition_11 = _result_6
		if _condition_11 == nil then
			_condition_11 = selectTheme.borderThickness
		end
		_attributes_5.Thickness = _condition_11
		_attributes_5.BorderStrokePosition = Enum.BorderStrokePosition.Outer
		local _result_7 = selectTheme.dropDown
		if _result_7 ~= nil then
			_result_7 = _result_7.borderColor
		end
		local _condition_12 = _result_7
		if _condition_12 == nil then
			_condition_12 = selectTheme.borderColor
		end
		_attributes_5.Color = _condition_12
		local _exp_9 = React.createElement("uistroke", _attributes_5)
		local _attributes_6 = {}
		local _result_8 = selectTheme.dropDown
		if _result_8 ~= nil then
			_result_8 = _result_8.cornerRadius
		end
		local _condition_13 = _result_8
		if _condition_13 == nil then
			_condition_13 = selectTheme.cornerRadius
		end
		_attributes_6.radius = _condition_13
		local _exp_10 = React.createElement(Corners, _attributes_6)
		local _attributes_7 = {}
		local _result_9 = selectTheme.dropDown
		if _result_9 ~= nil then
			_result_9 = _result_9.boxShadow
		end
		_attributes_7.value = _result_9
		_condition_10 = ReactRoblox.createPortal(React.createElement("frame", _attributes_4, _exp_9, _exp_10, React.createElement(FieldBoxShadow, _attributes_7), React.createElement(VStack, {
			spacing = "None",
		}, props.searchable and (React.createElement(SelectSearchInput, {
			value = query,
			onChange = setQuery,
			placeholder = props.searchPlaceholder,
			scale = props.scale,
		})), React.createElement(Scroller, {
			Size = UDim2.new(1, 0, 0, dropdownHeight),
			spacing = "None",
		}, React.createElement(VStack, {
			spacing = "None",
			Change = {
				AbsoluteContentSize = function(layout)
					setContentHeight(layout.AbsoluteContentSize.Y)
				end,
			},
		}, if hasVisibleOptions then renderSections() else React.createElement(Text, {
			name = "NoResultsText",
			text = "No Results",
			typography = typography,
		}))))), overlay.overlay)
	end
	return React.createElement(Container, _attributes, _exp_1, _exp_2, _exp_3, _exp_4, React.createElement(SelectContext.Provider, {
		value = context,
	}, React.createElement("imagebutton", {
		key = "SelectButton",
		ref = buttonRef,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = if selectTheme.innerShadow ~= nil then 2 else nil,
		Event = {
			Activated = activateSelect,
			MouseEnter = function()
				return setHovered(true)
			end,
			MouseLeave = function()
				return setHovered(false)
			end,
		},
	}, _exp_5, _exp_6, _exp_7, _exp_8, _condition_10)))
end)
Select.Option = SelectOption
Select.OptGroup = SelectOptGroup
return {
	Select = Select,
}
