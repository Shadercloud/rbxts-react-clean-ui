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
local SpacingHelper = _Helpers.SpacingHelper
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
local Input = TS.import(script, script.Parent, "Input").Input
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
	-- Fragment-wrapped children (`<>...</>`) are unwrapped/recursed into so
	-- consumers can conditionally compose Option/OptGroup lists (a common
	-- React pattern) without breaking option indexing.
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
	-- Plain-text/literal find (the trailing `true`) avoids treating Lua
	-- pattern characters in the query (e.g. `%`, `-`) as patterns.
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
	local _binding = React.useMemo(function()
		return parseSelectChildren(props.children)
	end, { props.children })
	local sections = _binding.sections
	local flatOptions = _binding.flatOptions
	local _result = flatOptions[selected + 1]
	if _result ~= nil then
		_result = _result.element
	end
	local _condition_1 = _result
	if _condition_1 == nil then
		local _result_1 = flatOptions[1]
		if _result_1 ~= nil then
			_result_1 = _result_1.element
		end
		_condition_1 = _result_1
	end
	local selectedOption = _condition_1
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
			local _result_1
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
				_result_1 = _newValue_1
			else
				_result_1 = section.group.options
			end
			local visibleOptions = _result_1
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
	local _condition_2 = not props.searchable or query == ""
	if not _condition_2 then
		-- ▼ ReadonlyArray.some ▼
		local _result_1 = false
		local _callback = function(option)
			return optionMatchesQuery(option, normalizedQuery)
		end
		for _k, _v in flatOptions do
			if _callback(_v, _k - 1, flatOptions) then
				_result_1 = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		_condition_2 = _result_1
	end
	local hasVisibleOptions = _condition_2
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
	local _result_1 = fieldset
	if _result_1 ~= nil then
		_result_1 = _result_1.labelActivated
	end
	React.useEffect(_exp, { _result_1, activateSelect })
	if open and overlay.overlay == nil then
		warn("You have used a Select component without using the Overlay Provider")
	end
	local _attributes = {}
	local _condition_3 = props.name
	if _condition_3 == nil then
		_condition_3 = "Select"
	end
	_attributes.name = _condition_3
	_attributes.ref = ref
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.Size = UDim2.fromScale(1, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.backgroundImage = props.backgroundImage or theme.components.select.backgroundImage
	local _exp_1 = React.createElement("uistroke", {
		key = "Stroke",
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
	local _attributes_2 = {
		name = "SelectedText",
	}
	local _result_2 = selectedOption
	if _result_2 ~= nil then
		_result_2 = _result_2.props.text
	end
	local _condition_4 = _result_2
	if _condition_4 == nil then
		_condition_4 = "No Options"
	end
	_attributes_2.text = _condition_4
	_attributes_2.typography = typography
	local _exp_4 = React.createElement(HStack, nil, React.createElement(FlexItem, nil, React.createElement(Text, _attributes_2)), React.createElement(Icon, {
		name = "SelectCaret",
		icon = "caret-down",
		color = theme.colors.intents.primary.default.textColor,
	}))
	local _condition_5 = open and overlay.overlay ~= nil
	if _condition_5 then
		local _attributes_3 = {
			key = "SelectDropdown",
			BackgroundTransparency = 0,
			BackgroundColor3 = theme.components.select.dropDownBackgroundColor,
			AnchorPoint = Vector2.zero,
		}
		local _uDim2 = UDim2.new(0, 0, 0, dropdownSize.Y.Offset)
		_attributes_3.Position = dropdownPosition + _uDim2
		_attributes_3.Size = UDim2.fromOffset(dropdownSize.X.Offset, 0)
		_attributes_3.AutomaticSize = Enum.AutomaticSize.Y
		_attributes_3.ClipsDescendants = true
		_condition_5 = ReactRoblox.createPortal(React.createElement("frame", _attributes_3, React.createElement("uistroke", {
			key = "Stroke",
			Thickness = theme.components.select.borderThickness,
			BorderStrokePosition = Enum.BorderStrokePosition.Outer,
			Color = theme.components.select.borderColor,
		}), React.createElement(Corners, {
			radius = theme.components.select.cornerRadius,
		}), React.createElement(VStack, {
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
	return React.createElement(Container, _attributes, React.createElement(SelectContext.Provider, {
		value = context,
	}, React.createElement("imagebutton", {
		key = "SelectButton",
		ref = buttonRef,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Event = {
			Activated = activateSelect,
		},
	}, _exp_1, _exp_2, _exp_3, _exp_4, _condition_5)))
end)
Select.Option = SelectOption
Select.OptGroup = SelectOptGroup
return {
	Select = Select,
}
