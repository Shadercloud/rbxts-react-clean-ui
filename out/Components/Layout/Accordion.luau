-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _HoverButton = TS.import(script, script.Parent.Parent, "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
local Icon = TS.import(script, script.Parent.Parent, "Surface", "Icon").Icon
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local Container = TS.import(script, script.Parent, "Container").Container
local HStack = TS.import(script, script.Parent, "HStack").HStack
local VStack = TS.import(script, script.Parent, "VStack").VStack
local function AccordionItem(_props)
	return nil
end
local function AccordionHeader(_props)
	return nil
end
local function AccordionContent(_props)
	return nil
end
local function AccordionHeaderVisual(props)
	local theme = React.useContext(CleanThemeContext)
	local hover = React.useContext(HoverButtonContext)
	local _result
	if props.disabled then
		_result = "disabled"
	else
		local _result_1 = hover
		if _result_1 ~= nil then
			_result_1 = _result_1.isSelected
		end
		local _result_2
		if _result_1 then
			_result_2 = "focus"
		else
			local _result_3 = hover
			if _result_3 ~= nil then
				_result_3 = _result_3.hover
			end
			_result_2 = if _result_3 then "hover" else "default"
		end
		_result = _result_2
	end
	local state = _result
	local colors = ColorHelper:getIntentColors(theme, "primary", state, theme.components.accordion.header.intents)
	local rotation, rotationTween = useTween(if props.open then 180 else 0, {
		duration = props.duration,
	})
	React.useEffect(function()
		local goal = if props.open then 180 else 0
		rotationTween:setGoal(goal, {
			duration = props.duration,
		})
		if props.duration == 0 then
			rotationTween:setPosition(goal)
		end
		rotationTween:start()
	end, { props.duration, props.open, rotationTween })
	local _condition = props.header.text == nil and props.header.children ~= nil
	if _condition then
		local _children = props.header.children
		_condition = not (type(_children) == "string")
	end
	if _condition then
		return props.header.children
	end
	local _exp = React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props.header, theme.components.accordion.header.spacing, theme.components.accordion.header.padding),
	})
	local _exp_1 = props.header.icon ~= nil and React.createElement(Icon, {
		name = "AccordionHeaderIcon",
		icon = props.header.icon,
		color = colors.textColor,
	})
	local _result_1
	if props.header.text ~= nil then
		_result_1 = React.createElement(Text, {
			name = "AccordionHeaderText",
			text = props.header.text,
			TextColor3 = colors.textColor,
			typography = TypographyHelper:getTypography(theme, nil, colors.typography or theme.components.accordion.header.typography),
		})
	else
		local _children = props.header.children
		_result_1 = if type(_children) == "string" then React.createElement(Text, {
			name = "AccordionHeaderText",
			text = props.header.children,
			TextColor3 = colors.textColor,
			typography = TypographyHelper:getTypography(theme, nil, colors.typography or theme.components.accordion.header.typography),
		}) else props.header.children
	end
	return React.createElement(React.Fragment, nil, _exp, React.createElement(HStack, {
		valign = "Center",
		Wraps = false,
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
	}, _exp_1, React.createElement(Container, {
		name = "AccordionHeaderTextContainer",
		Size = UDim2.new(1, theme.components.accordion.header.indicatorSize, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, _result_1), React.createElement(Container, {
		name = "AccordionChevronContainer",
	}, React.createElement(Icon, {
		name = "AccordionChevronIcon",
		icon = "chevron-down",
		color = if props.disabled then colors.textColor else theme.components.accordion.header.indicatorColor,
		Size = UDim2.fromOffset(theme.components.accordion.header.indicatorSize, theme.components.accordion.header.indicatorSize),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Rotation = rotation,
	}))))
end
local function RenderedAccordionItem(props)
	local theme = React.useContext(CleanThemeContext)
	local mounted, setMounted = React.useState(props.open)
	local height, heightTween = useTween(0, {
		duration = props.duration,
	})
	React.useEffect(function()
		if props.open then
			setMounted(true)
		else
			heightTween:setGoal(0, {
				duration = props.duration,
			})
			if props.duration == 0 then
				heightTween:setPosition(0)
			end
			heightTween:start()
			if props.duration == 0 then
				setMounted(false)
			end
		end
	end, { props.duration, props.open, heightTween })
	React.useEffect(function()
		if props.duration == 0 then
			heightTween:setPosition(heightTween:getGoal())
		end
	end, { props.duration, heightTween })
	React.useEffect(function()
		return heightTween:onComplete(function(value)
			if value == 0 and not props.open then
				setMounted(false)
			end
		end)
	end, { heightTween, props.open })
	local defaultColors = ColorHelper:getIntentColors(theme, "primary", if props.disabled then "disabled" else "default", theme.components.accordion.header.intents)
	local hoverColors = ColorHelper:getIntentColors(theme, "primary", "hover", theme.components.accordion.header.intents)
	local focusColors = ColorHelper:getIntentColors(theme, "primary", "focus", theme.components.accordion.header.intents)
	local defaultBackgroundImage = CssHelper:resolveBackgroundImage(defaultColors.backgroundImage)
	local hoverBackgroundImage = CssHelper:resolveBackgroundImage(hoverColors.backgroundImage)
	local focusBackgroundImage = CssHelper:resolveBackgroundImage(focusColors.backgroundImage)
	local _condition = not props.first
	if _condition then
		local _attributes = {
			key = "Divider",
			BackgroundColor3 = theme.components.accordion.borderColor,
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
		}
		local _exp = UDim2.fromOffset(0, theme.components.accordion.borderThickness)
		local _arg0 = UDim2.fromScale(1, 0)
		_attributes.Size = _exp + _arg0
		_condition = (React.createElement("frame", _attributes))
	end
	local _attributes = {
		name = `AccordionHeaderButton-{props.value}`,
		isSelected = props.open,
	}
	local _object = {
		Active = not props.disabled and (props.content ~= nil or props.contentText ~= nil),
		Selectable = not props.disabled and (props.content ~= nil or props.contentText ~= nil),
		AutoButtonColor = false,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1, 0),
		BackgroundColor3 = defaultColors.backgroundColor,
	}
	local _left = "BackgroundTransparency"
	local _condition_1 = defaultColors.backgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 0
	end
	_object[_left] = _condition_1
	_object.BorderSizePixel = 0
	_object.Image = defaultBackgroundImage.Image
	_object.ImageColor3 = defaultBackgroundImage.ImageColor3
	_object.ImageTransparency = defaultBackgroundImage.ImageTransparency
	_object.ScaleType = defaultBackgroundImage.ScaleType
	_object.SliceCenter = defaultBackgroundImage.SliceCenter
	_object.SliceScale = defaultBackgroundImage.SliceScale
	_object.TileSize = defaultBackgroundImage.TileSize
	_object.Event = {
		Activated = props.onActivate,
	}
	_attributes.default = _object
	local _object_1 = {
		BackgroundColor3 = hoverColors.backgroundColor,
	}
	local _left_1 = "BackgroundTransparency"
	local _condition_2 = hoverColors.backgroundTransparency
	if _condition_2 == nil then
		_condition_2 = 0
	end
	_object_1[_left_1] = _condition_2
	_object_1.Image = hoverBackgroundImage.Image
	_object_1.ImageColor3 = hoverBackgroundImage.ImageColor3
	_object_1.ImageTransparency = hoverBackgroundImage.ImageTransparency
	_object_1.ScaleType = hoverBackgroundImage.ScaleType
	_object_1.SliceCenter = hoverBackgroundImage.SliceCenter
	_object_1.SliceScale = hoverBackgroundImage.SliceScale
	_object_1.TileSize = hoverBackgroundImage.TileSize
	_attributes.hover = _object_1
	local _object_2 = {
		BackgroundColor3 = focusColors.backgroundColor,
	}
	local _left_2 = "BackgroundTransparency"
	local _condition_3 = focusColors.backgroundTransparency
	if _condition_3 == nil then
		_condition_3 = 0
	end
	_object_2[_left_2] = _condition_3
	_object_2.Image = focusBackgroundImage.Image
	_object_2.ImageColor3 = focusBackgroundImage.ImageColor3
	_object_2.ImageTransparency = focusBackgroundImage.ImageTransparency
	_object_2.ScaleType = focusBackgroundImage.ScaleType
	_object_2.SliceCenter = focusBackgroundImage.SliceCenter
	_object_2.SliceScale = focusBackgroundImage.SliceScale
	_object_2.TileSize = focusBackgroundImage.TileSize
	_attributes.focus = _object_2
	return React.createElement(Container, {
		name = `AccordionItem-{props.value}`,
		width = "100%",
	}, React.createElement(VStack, {
		spacing = "None",
	}, _condition, React.createElement(HoverButton, _attributes, props.first and (React.createElement("uicorner", {
		key = "Corners",
		TopLeftRadius = SizeHelper:toUDim(theme.components.accordion.cornerRadius),
		TopRightRadius = SizeHelper:toUDim(theme.components.accordion.cornerRadius),
		BottomLeftRadius = UDim.new(0, 0),
		BottomRightRadius = UDim.new(0, 0),
	})), React.createElement(AccordionHeaderVisual, {
		header = props.header,
		disabled = props.disabled,
		duration = props.duration,
		open = props.open,
	})), mounted and (React.createElement("frame", {
		key = "ContentClip",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = height:map(function(value)
			local _exp = UDim2.fromScale(1, 0)
			local _arg0 = UDim2.fromOffset(0, value)
			return _exp + _arg0
		end),
	}, React.createElement("frame", {
		key = "Content",
		BackgroundColor3 = theme.components.accordion.content.backgroundColor,
		BackgroundTransparency = theme.components.accordion.content.backgroundTransparency,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Change = {
			AbsoluteSize = function(instance)
				if props.open then
					heightTween:setGoal(instance.AbsoluteSize.Y, {
						duration = props.duration,
					})
					if props.duration == 0 then
						heightTween:setPosition(instance.AbsoluteSize.Y)
					end
					heightTween:start()
				end
			end,
		},
	}, React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props.contentProps, theme.components.accordion.content.spacing, theme.components.accordion.content.padding),
	}), if props.contentText ~= nil then React.createElement(Text, {
		name = "AccordionContentText",
		text = props.contentText,
	}) else props.content)))))
end
local Accordion = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local items = React.useMemo(function()
		local parsed = {}
		local seen = {}
		React.Children.forEach(props.children, function(child)
			if not React.isValidElement(child) or child.type ~= AccordionItem then
				return nil
			end
			local item = child
			local _value = item.props.value
			if seen[_value] ~= nil then
				return nil
			end
			local header
			local contentProps
			local contentText
			local content
			React.Children.forEach(item.props.children, function(itemChild)
				if not React.isValidElement(itemChild) then
					return nil
				end
				if itemChild.type == AccordionHeader and header == nil then
					header = itemChild.props
				end
				if itemChild.type == AccordionContent and content == nil then
					contentProps = itemChild.props
					contentText = contentProps.text
					content = contentProps.children
				end
			end)
			if header ~= nil then
				local _value_1 = item.props.value
				seen[_value_1] = true
				local _object = {
					value = item.props.value,
				}
				local _left = "disabled"
				local _condition = item.props.disabled
				if _condition == nil then
					_condition = false
				end
				_object[_left] = _condition
				_object.header = header
				_object.contentProps = contentProps or {}
				_object.contentText = contentText
				_object.content = content
				table.insert(parsed, _object)
			end
		end)
		return parsed
	end, { props.children })
	local initial = if props.defaultValue ~= nil then { props.defaultValue } else {}
	local uncontrolled, setUncontrolled = React.useState(initial)
	local supplied = if props.value ~= nil then { props.value } else uncontrolled
	local _set = {}
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#items)
	local _callback = function(item)
		return item.value
	end
	for _k, _v in items do
		_newValue[_k] = _callback(_v, _k - 1, items)
	end
	-- ▲ ReadonlyArray.map ▲
	for _, _v in _newValue do
		_set[_v] = true
	end
	local available = _set
	-- ▼ ReadonlyArray.filter ▼
	local _newValue_1 = {}
	local _callback_1 = function(value)
		local _value = value
		return available[_value] ~= nil
	end
	local _length = 0
	for _k, _v in supplied do
		if _callback_1(_v, _k - 1, supplied) == true then
			_length += 1
			_newValue_1[_length] = _v
		end
	end
	-- ▲ ReadonlyArray.filter ▲
	local openValues = _newValue_1
	React.useEffect(function()
		local _condition = props.value == nil
		if _condition then
			local _condition_1 = #uncontrolled ~= #openValues
			if not _condition_1 then
				-- ▼ ReadonlyArray.some ▼
				local _result = false
				local _callback_2 = function(value)
					local _value = value
					return not (available[_value] ~= nil)
				end
				for _k, _v in uncontrolled do
					if _callback_2(_v, _k - 1, uncontrolled) then
						_result = true
						break
					end
				end
				-- ▲ ReadonlyArray.some ▲
				_condition_1 = _result
			end
			_condition = _condition_1
		end
		if _condition then
			setUncontrolled(openValues)
		end
	end, { items, props.value })
	local activate = function(item)
		if item.disabled or (item.content == nil and item.contentText == nil) then
			return nil
		end
		local _value = item.value
		local isOpen = table.find(openValues, _value) ~= nil
		local nextValues
		if isOpen then
			if not props.collapsible then
				return nil
			end
			nextValues = {}
		else
			nextValues = { item.value }
		end
		if props.value == nil then
			setUncontrolled(nextValues)
		end
		local _result = props.onValueChange
		if _result ~= nil then
			_result(nextValues[1])
		end
	end
	local _attributes = {
		ref = ref,
	}
	local _condition = props.name
	if _condition == nil then
		_condition = "Accordion"
	end
	_attributes.name = _condition
	_attributes.width = "100%"
	_attributes.height = "100%"
	_attributes.ClipsDescendants = true
	local _exp = React.createElement(Corners, {
		radius = theme.components.accordion.cornerRadius,
	})
	local _exp_1 = React.createElement("uistroke", {
		key = "Stroke",
		Color = theme.components.accordion.borderColor,
		Thickness = theme.components.accordion.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Outer,
	})
	-- ▼ ReadonlyArray.map ▼
	local _newValue_2 = table.create(#items)
	local _callback_2 = function(item, index)
		local _attributes_1 = {
			key = item.value,
		}
		for _k, _v in item do
			_attributes_1[_k] = _v
		end
		_attributes_1.first = index == 0
		local _value = item.value
		_attributes_1.open = table.find(openValues, _value) ~= nil
		local _condition_1 = props.animationDuration
		if _condition_1 == nil then
			_condition_1 = theme.components.accordion.animation.duration
		end
		_attributes_1.duration = _condition_1
		_attributes_1.onActivate = function()
			return activate(item)
		end
		return React.createElement(RenderedAccordionItem, _attributes_1)
	end
	for _k, _v in items do
		_newValue_2[_k] = _callback_2(_v, _k - 1, items)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(Container, _attributes, _exp, _exp_1, React.createElement(VStack, {
		Padding = UDim.new(0, SpacingHelper:GetPadding(theme, props.scale, theme.components.accordion.spacing)),
	}, _newValue_2))
end)
Accordion.Item = AccordionItem
Accordion.Header = AccordionHeader
Accordion.Content = AccordionContent
return {
	Accordion = Accordion,
}
