-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local SizeHelper = _Helpers.SizeHelper
local TypographyHelper = _Helpers.TypographyHelper
local Icon = TS.import(script, script.Parent.Parent, "Surface", "Icon").Icon
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local HALF_MASK = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4999, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0) })
local SMALLER_SCALE = {
	xs = "xs",
	sm = "xs",
	md = "sm",
	lg = "md",
	xl = "lg",
}
local function wrapDegrees(angle)
	return angle - math.floor(angle / 360) * 360
end
local function resolveContent(content, state)
	local _content = content
	return if type(_content) == "function" then content(state) else content
end
local function RadialMenuWedge(props)
	if props.sweep >= 360 then
		local _attributes = {
			key = props.name,
			Size = UDim2.fromScale(1, 1),
			BackgroundColor3 = props.color,
		}
		local _condition = props.transparency
		if _condition == nil then
			_condition = 0
		end
		_attributes.BackgroundTransparency = _condition
		_attributes.BorderSizePixel = 0
		_attributes.ZIndex = props.ZIndex
		return React.createElement("frame", _attributes, React.createElement("uicorner", {
			key = "Corners",
			CornerRadius = UDim.new(0.5, 0),
		}))
	end
	local _attributes = {
		key = "Fill",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromScale(2, 1),
		BackgroundColor3 = props.color,
	}
	local _condition = props.transparency
	if _condition == nil then
		_condition = 0
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.BorderSizePixel = 0
	return React.createElement("frame", {
		key = props.name,
		Size = UDim2.fromScale(1, 1),
		Rotation = props.start,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
	}, React.createElement("canvasgroup", {
		key = "Clip",
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.5, 1),
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("frame", _attributes, React.createElement("uicorner", {
		key = "Corners",
		CornerRadius = UDim.new(0.5, 0),
	}), React.createElement("uigradient", {
		key = "Mask",
		Transparency = HALF_MASK,
		Rotation = props.sweep - 180,
	}))))
end
local RadialMenu = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local radialTheme = theme.components.radialMenu
	local controlled = props.value ~= nil
	local internalValue, setInternalValue = React.useState(props.defaultValue)
	local hoverIndex, setHoverIndex = React.useState(-1)
	local selectedValue = if controlled then props.value else internalValue
	local count = #props.items
	local step = if count > 0 then 360 / count else 360
	local _exp = props.items
	-- ▼ ReadonlyArray.findIndex ▼
	local _callback = function(item)
		return item.value == selectedValue
	end
	local _result = -1
	for _i, _v in _exp do
		if _callback(_v, _i - 1, _exp) == true then
			_result = _i - 1
			break
		end
	end
	-- ▲ ReadonlyArray.findIndex ▲
	local selectedIndex = _result
	local hovered = if hoverIndex >= 0 and hoverIndex < count then hoverIndex else -1
	local _condition = props.thickness
	if _condition == nil then
		_condition = radialTheme.thickness
	end
	local thickness = SizeHelper:toUDim(_condition)
	local _condition_1 = props.size
	if _condition_1 == nil then
		_condition_1 = radialTheme.size
	end
	local diameter = SizeHelper:toUDim(_condition_1)
	local innerScale = 1 - thickness.Scale
	local innerOffset = -2 * thickness.Offset
	local itemRadiusScale = 0.5 - thickness.Scale / 4
	local itemRadiusOffset = -thickness.Offset / 2
	local duration = radialTheme.animation.duration
	local initialAngle = if selectedIndex >= 0 then selectedIndex * step else 0
	local rotation, rotationTween = useTween(initialAngle, {
		duration = duration,
	})
	local goalRef = React.useRef(if selectedIndex >= 0 then initialAngle else nil)
	React.useEffect(function()
		if selectedIndex < 0 then
			goalRef.current = nil
			return nil
		end
		local target = selectedIndex * step
		local previous = goalRef.current
		local goal = if previous == nil then target else previous + wrapDegrees(target - previous + 180) - 180
		goalRef.current = goal
		rotationTween:setGoal(goal, {
			duration = duration,
		})
		if previous == nil or duration <= 0 then
			rotationTween:setPosition(goal)
		end
		rotationTween:start()
	end, { selectedIndex, step, duration, rotationTween })
	local selectIndex = function(index)
		local item = props.items[index + 1]
		if item == nil then
			return nil
		end
		if not controlled then
			setInternalValue(item.value)
		end
		local _result_1 = props.onValueChange
		if _result_1 ~= nil then
			_result_1(item.value, item)
		end
	end
	local resolveIndex = function(rbx, position)
		if count == 0 then
			return -1
		end
		local size = rbx.AbsoluteSize
		local outer = math.min(size.X, size.Y) / 2
		if outer <= 0 then
			return -1
		end
		local inner = math.max(0, outer - (thickness.Scale * outer + thickness.Offset))
		local dx = position.X - (rbx.AbsolutePosition.X + size.X / 2)
		local dy = position.Y - (rbx.AbsolutePosition.Y + size.Y / 2)
		local distance = math.sqrt(dx * dx + dy * dy)
		if distance > outer or distance < inner then
			return -1
		end
		local angle = wrapDegrees(math.deg(math.atan2(dx, -dy)) + step / 2)
		return math.min(math.floor(angle / step), count - 1)
	end
	local schemeFor = function(index)
		return ColorHelper:getIntentColors(theme, "primary", if index == selectedIndex then "focus" elseif index == hovered then "hover" else "default", radialTheme.intents)
	end
	local ringScheme = ColorHelper:getIntentColors(theme, "primary", "default", radialTheme.intents)
	local hoverScheme = ColorHelper:getIntentColors(theme, "primary", "hover", radialTheme.intents)
	local focusScheme = ColorHelper:getIntentColors(theme, "primary", "focus", radialTheme.intents)
	local scale = props.scale or theme.default.scale
	local labelTypography = TypographyHelper:getTypography(theme, SMALLER_SCALE[scale], radialTheme.labels.typography)
	local titleTypography = TypographyHelper:getTypography(theme, scale, radialTheme.center.title.typography)
	local descriptionTypography = TypographyHelper:getTypography(theme, SMALLER_SCALE[scale], radialTheme.center.description.typography)
	local centerTextColor = theme.colors.intents.primary.default.textColor
	local selectedItem = if selectedIndex >= 0 then props.items[selectedIndex + 1] else nil
	local _result_1
	if selectedItem ~= nil then
		_result_1 = selectedItem.icon
	else
		local _result_2 = props.placeholder
		if _result_2 ~= nil then
			_result_2 = _result_2.icon
		end
		_result_1 = _result_2
	end
	local centerIcon = _result_1
	local _result_2
	if selectedItem ~= nil then
		_result_2 = selectedItem.text
	else
		local _result_3 = props.placeholder
		if _result_3 ~= nil then
			_result_3 = _result_3.text
		end
		_result_2 = _result_3
	end
	local centerText = _result_2
	local _result_3
	if selectedItem ~= nil then
		_result_3 = selectedItem.description
	else
		local _result_4 = props.placeholder
		if _result_4 ~= nil then
			_result_4 = _result_4.description
		end
		_result_3 = _result_4
	end
	local centerDescription = _result_3
	local ringIconSize = theme.iconSize[props.scale or radialTheme.iconScale or theme.default.scale]
	local customCenter
	local hasCustomCenter = false
	if selectedItem ~= nil then
		if selectedItem.centerContent ~= nil then
			hasCustomCenter = true
			customCenter = resolveContent(selectedItem.centerContent, {
				selected = true,
				hovered = selectedIndex == hovered,
			})
		end
	else
		local _result_4 = props.placeholder
		if _result_4 ~= nil then
			_result_4 = _result_4.centerContent
		end
		if _result_4 ~= nil then
			hasCustomCenter = true
			customCenter = props.placeholder.centerContent
		end
	end
	local _exp_1 = props.items
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp_1)
	local _callback_1 = function(item, index)
		local radians = math.rad(index * step)
		local sin = math.sin(radians)
		local cos = math.cos(radians)
		local scheme = schemeFor(index)
		local hasLabel = props.showLabels == true and item.text ~= nil and item.text ~= ""
		return React.createElement("frame", {
			key = `RadialMenuItem-{item.value}`,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5 + sin * itemRadiusScale, sin * itemRadiusOffset, 0.5 - cos * itemRadiusScale, -cos * itemRadiusOffset),
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, React.createElement("uilistlayout", {
			key = "ItemLayout",
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}), item.content ~= nil and (React.createElement("frame", {
			key = "ItemContent",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(ringIconSize, ringIconSize),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Interactable = false,
		}, resolveContent(item.content, {
			selected = index == selectedIndex,
			hovered = index == hovered,
		}))), item.content == nil and item.icon ~= nil and (React.createElement(Icon, {
			name = "ItemIcon",
			LayoutOrder = 1,
			icon = item.icon,
			scale = props.scale or radialTheme.iconScale,
			color = scheme.textColor,
		})), item.content == nil and hasLabel and (React.createElement(Text, {
			name = "ItemLabel",
			LayoutOrder = 2,
			text = item.text,
			align = "Center",
			typography = labelTypography,
			TextColor3 = labelTypography.color or scheme.textColor,
		})))
	end
	for _k, _v in _exp_1 do
		_newValue[_k] = _callback_1(_v, _k - 1, _exp_1)
	end
	-- ▲ ReadonlyArray.map ▲
	local items = _newValue
	local _attributes = {}
	local _condition_2 = props.name
	if _condition_2 == nil then
		_condition_2 = "RadialMenu"
	end
	_attributes.key = _condition_2
	_attributes.ref = ref
	_attributes.Size = UDim2.new(diameter, diameter)
	_attributes.Position = props.Position
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.ZIndex = props.ZIndex
	_attributes.BackgroundTransparency = 1
	_attributes.BorderSizePixel = 0
	local _exp_2 = React.createElement("uiaspectratioconstraint", {
		key = "AspectRatio",
		AspectRatio = 1,
	})
	local _attributes_1 = {
		key = "Ring",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = ringScheme.backgroundColor,
	}
	local _condition_3 = ringScheme.backgroundTransparency
	if _condition_3 == nil then
		_condition_3 = 0
	end
	_attributes_1.BackgroundTransparency = _condition_3
	_attributes_1.BorderSizePixel = 0
	_attributes_1.ZIndex = 1
	local _exp_3 = React.createElement("frame", _attributes_1, React.createElement("uicorner", {
		key = "Corners",
		CornerRadius = UDim.new(0.5, 0),
	}))
	local _exp_4 = hovered >= 0 and hovered ~= selectedIndex and (React.createElement(RadialMenuWedge, {
		name = "HoverWedge",
		start = hovered * step - step / 2,
		sweep = step,
		color = hoverScheme.backgroundColor,
		transparency = hoverScheme.backgroundTransparency,
		ZIndex = 2,
	}))
	local _exp_5 = React.createElement("frame", {
		key = "SelectedWedge",
		Size = UDim2.fromScale(1, 1),
		Rotation = rotation,
		Visible = selectedIndex >= 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
	}, React.createElement(RadialMenuWedge, {
		name = "Wedge",
		start = -step / 2,
		sweep = step,
		color = focusScheme.backgroundColor,
		transparency = focusScheme.backgroundTransparency,
	}))
	local _exp_6 = React.createElement("uicorner", {
		key = "Corners",
		CornerRadius = UDim.new(0.5, 0),
	})
	local _attributes_2 = {
		key = "CenterLayout",
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}
	local _condition_4 = radialTheme.center.gap
	if _condition_4 == nil then
		_condition_4 = 0
	end
	_attributes_2.Padding = UDim.new(0, _condition_4)
	return React.createElement("frame", _attributes, _exp_2, _exp_3, _exp_4, _exp_5, React.createElement("frame", {
		key = "Center",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(innerScale, innerOffset, innerScale, innerOffset),
		BackgroundColor3 = radialTheme.center.backgroundColor,
		BackgroundTransparency = radialTheme.center.backgroundTransparency,
		BorderSizePixel = 0,
		ZIndex = 4,
	}, _exp_6, React.createElement("frame", {
		key = "CenterContent",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(0.75, 0.75),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, React.createElement("uilistlayout", _attributes_2), hasCustomCenter and (React.createElement("frame", {
		key = "CenterSlot",
		LayoutOrder = 1,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Interactable = false,
	}, customCenter)), not hasCustomCenter and centerIcon ~= nil and (React.createElement(Icon, {
		name = "CenterIcon",
		LayoutOrder = 1,
		icon = centerIcon,
		Size = UDim2.fromOffset(radialTheme.center.iconSize, radialTheme.center.iconSize),
		color = radialTheme.center.iconColor or centerTextColor,
	})), not hasCustomCenter and centerText ~= nil and centerText ~= "" and (React.createElement(Text, {
		name = "CenterTitle",
		LayoutOrder = 2,
		text = centerText,
		align = "Center",
		TextWrap = true,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		typography = titleTypography,
		TextColor3 = titleTypography.color or centerTextColor,
	})), not hasCustomCenter and centerDescription ~= nil and centerDescription ~= "" and (React.createElement(Text, {
		name = "CenterDescription",
		LayoutOrder = 3,
		text = centerDescription,
		align = "Center",
		TextWrap = true,
		Size = UDim2.fromScale(1, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		typography = descriptionTypography,
		TextColor3 = descriptionTypography.color or centerTextColor,
	})))), React.createElement("frame", {
		key = "Items",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 5,
	}, items), React.createElement("frame", {
		key = "HitArea",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Active = true,
		ZIndex = 6,
		Event = {
			InputBegan = function(rbx, input)
				if input.UserInputType ~= Enum.UserInputType.Touch then
					return nil
				end
				setHoverIndex(resolveIndex(rbx, input.Position))
			end,
			InputChanged = function(rbx, input)
				if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
					return nil
				end
				setHoverIndex(resolveIndex(rbx, input.Position))
			end,
			InputEnded = function(rbx, input)
				local touch = input.UserInputType == Enum.UserInputType.Touch
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 and not touch then
					return nil
				end
				local index = resolveIndex(rbx, input.Position)
				if touch then
					setHoverIndex(-1)
				end
				if index >= 0 then
					selectIndex(index)
				end
			end,
			MouseLeave = function()
				setHoverIndex(-1)
			end,
		},
	}))
end)
return {
	RadialMenu = RadialMenu,
}
