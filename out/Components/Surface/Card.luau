-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Box = TS.import(script, script.Parent, "Box").Box
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local FlexItem = _Layout.FlexItem
local VStack = _Layout.VStack
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Padding = TS.import(script, script.Parent.Parent, "Decorator").Padding
local CardContext = React.createContext({})
local function resolveCssPositionOffset(position)
	local centerX = position.center == true or position.center == "x"
	local centerY = position.center == true or position.center == "y"
	local anchorX = if centerX then 0.5 else (if position.left == nil and position.right ~= nil then 1 else 0)
	local anchorY = if centerY then 0.5 else (if position.top == nil and position.bottom ~= nil then 1 else 0)
	local posX = if centerX then UDim.new(0.5, 0) elseif position.left ~= nil then SizeHelper:toUDim(position.left) elseif position.right ~= nil then UDim.new(1 - SizeHelper:toUDim(position.right).Scale, -SizeHelper:toUDim(position.right).Offset) else UDim.new(0, 0)
	local posY = if centerY then UDim.new(0.5, 0) elseif position.top ~= nil then SizeHelper:toUDim(position.top) elseif position.bottom ~= nil then UDim.new(1 - SizeHelper:toUDim(position.bottom).Scale, -SizeHelper:toUDim(position.bottom).Offset) else UDim.new(0, 0)
	local impliedWidth = if position.width == nil and position.left ~= nil and position.right ~= nil then (function()
		local leftUDim = SizeHelper:toUDim(position.left)
		local rightUDim = SizeHelper:toUDim(position.right)
		return UDim.new(1 - leftUDim.Scale - rightUDim.Scale, -leftUDim.Offset - rightUDim.Offset)
	end)() else nil
	local sizeOverride = if position.width ~= nil then {
		Size = UDim2.new(CssHelper:parseCssSize(position.width), UDim.new(0, 0)),
		AutomaticSize = Enum.AutomaticSize.Y,
	} elseif impliedWidth ~= nil then {
		Size = UDim2.new(impliedWidth, UDim.new(0, 0)),
		AutomaticSize = Enum.AutomaticSize.Y,
	} else {}
	local _object = {
		Position = UDim2.new(posX, posY),
		AnchorPoint = Vector2.new(anchorX, anchorY),
		ZIndex = position.zIndex,
	}
	for _k, _v in sizeOverride do
		_object[_k] = _v
	end
	return _object
end
local function resolveOverlayPosition(props, themePosition)
	local _condition = props.overlay
	if _condition == nil then
		local _result = themePosition
		if _result ~= nil then
			_result = _result.position
		end
		_condition = (_result == "absolute")
	end
	local overlay = _condition
	if not overlay then
		return {
			overlay = overlay,
			positionProps = {},
		}
	end
	local hasInstancePosition = props.Position ~= nil or props.AnchorPoint ~= nil or props.top ~= nil or props.left ~= nil or props.right ~= nil or props.bottom ~= nil or props.center ~= nil
	if hasInstancePosition then
		local _object = {
			overlay = overlay,
		}
		local _left = "positionProps"
		local _object_1 = {
			Position = SizeHelper:GetPosition(props),
			AnchorPoint = SizeHelper:GetAnchor(props),
		}
		local _left_1 = "ZIndex"
		local _condition_1 = props.ZIndex
		if _condition_1 == nil then
			local _result = themePosition
			if _result ~= nil then
				_result = _result.zIndex
			end
			_condition_1 = _result
			if _condition_1 == nil then
				_condition_1 = 2
			end
		end
		_object_1[_left_1] = _condition_1
		_object[_left] = _object_1
		return _object
	end
	if themePosition ~= nil then
		local resolved = resolveCssPositionOffset(themePosition)
		local _object = {
			overlay = overlay,
		}
		local _left = "positionProps"
		local _object_1 = {
			Position = resolved.Position,
			AnchorPoint = resolved.AnchorPoint,
		}
		local _left_1 = "ZIndex"
		local _condition_1 = props.ZIndex
		if _condition_1 == nil then
			_condition_1 = resolved.ZIndex
			if _condition_1 == nil then
				_condition_1 = 2
			end
		end
		_object_1[_left_1] = _condition_1
		_object_1.Size = resolved.Size
		_object_1.AutomaticSize = resolved.AutomaticSize
		_object[_left] = _object_1
		return _object
	end
	local _object = {
		overlay = overlay,
	}
	local _left = "positionProps"
	local _object_1 = {}
	local _left_1 = "ZIndex"
	local _condition_1 = props.ZIndex
	if _condition_1 == nil then
		_condition_1 = 2
	end
	_object_1[_left_1] = _condition_1
	_object[_left] = _object_1
	return _object
end
local CardHeader = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local card = React.useContext(CardContext)
	local intent = ColorHelper:getIntentColors(theme, props.intent or card.intent or "primary", "default", theme.components.card.header.intents)
	local padding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.card.header.spacing, theme.components.card.header.padding, "md")
	local corners = CssHelper:parseCssSize(theme.components.card.cornerRadius)
	local headerCorners = theme.components.card.header.cornerRadius
	local noCorner = UDim.new(0, 0)
	local _result = headerCorners
	if _result ~= nil then
		_result = _result.topLeft
	end
	local topLeftRadius = if _result ~= nil then CssHelper:parseCssSize(headerCorners.topLeft) else corners
	local _result_1 = headerCorners
	if _result_1 ~= nil then
		_result_1 = _result_1.topRight
	end
	local topRightRadius = if _result_1 ~= nil then CssHelper:parseCssSize(headerCorners.topRight) else corners
	local _result_2 = headerCorners
	if _result_2 ~= nil then
		_result_2 = _result_2.bottomLeft
	end
	local bottomLeftRadius = if _result_2 ~= nil then CssHelper:parseCssSize(headerCorners.bottomLeft) else noCorner
	local _result_3 = headerCorners
	if _result_3 ~= nil then
		_result_3 = _result_3.bottomRight
	end
	local bottomRightRadius = if _result_3 ~= nil then CssHelper:parseCssSize(headerCorners.bottomRight) else noCorner
	local _binding = resolveOverlayPosition(props, theme.components.card.header.position)
	local overlay = _binding.overlay
	local positionProps = _binding.positionProps
	local _attributes = {
		name = "CardHeader",
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	for _k, _v in positionProps do
		_attributes[_k] = _v
	end
	_attributes.Size = positionProps.Size or UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = positionProps.AutomaticSize or Enum.AutomaticSize.XY
	_attributes.BackgroundTransparency = intent.backgroundTransparency
	_attributes.BackgroundColor3 = intent.backgroundColor
	_attributes.BorderSizePixel = 0
	_attributes.backgroundImage = intent.backgroundImage
	_attributes.backgroundGradient = intent.backgroundGradient
	_attributes.Change = if overlay and card.reportOverlayHeaderRect ~= nil then {
		AbsolutePosition = function(instance)
			return card.reportOverlayHeaderRect(instance.AbsolutePosition, instance.AbsoluteSize)
		end,
		AbsoluteSize = function(instance)
			return card.reportOverlayHeaderRect(instance.AbsolutePosition, instance.AbsoluteSize)
		end,
	} else nil
	local _exp = React.createElement(Padding, {
		resolvedPadding = padding,
	})
	local _attributes_1 = {
		key = "Stroke",
	}
	local _condition = theme.components.card.header.borderThickness
	if _condition == nil then
		_condition = theme.components.card.borderThickness
	end
	_attributes_1.Thickness = _condition
	_attributes_1.Color = intent.borderColor
	_attributes_1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	return React.createElement(Container, _attributes, _exp, React.createElement("uistroke", _attributes_1), React.createElement("uicorner", {
		key = "Corners",
		TopLeftRadius = topLeftRadius,
		TopRightRadius = topRightRadius,
		BottomLeftRadius = bottomLeftRadius,
		BottomRightRadius = bottomRightRadius,
	}), props.children)
end)
local CardBody = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local paddingSourceProps = props
	local _attributes = {
		name = "CardBody",
		ref = ref,
		Size = SizeHelper:GetSize(props, UDim2.fromScale(0, 0)),
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	local _attributes_1 = {}
	local _result = theme.components.card.body
	if _result ~= nil then
		_result = _result.spacing
	end
	local _result_1 = theme.components.card.body
	if _result_1 ~= nil then
		_result_1 = _result_1.padding
	end
	_attributes_1.resolvedPadding = SpacingHelper:GetResolvedPadding(theme, paddingSourceProps, _result, _result_1)
	return React.createElement(FlexItem, nil, React.createElement(Container, _attributes, React.createElement(Padding, _attributes_1), props.children))
end)
local CardFooter = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local card = React.useContext(CardContext)
	local intent = ColorHelper:getIntentColors(theme, props.intent or card.intent or "primary", "default", theme.components.card.footer.intents)
	local padding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.card.footer.spacing, theme.components.card.footer.padding, "md")
	local corners = CssHelper:parseCssSize(theme.components.card.cornerRadius)
	local footerCorners = theme.components.card.footer.cornerRadius
	local noCorner = UDim.new(0, 0)
	local _result = footerCorners
	if _result ~= nil then
		_result = _result.topLeft
	end
	local topLeftRadius = if _result ~= nil then CssHelper:parseCssSize(footerCorners.topLeft) else noCorner
	local _result_1 = footerCorners
	if _result_1 ~= nil then
		_result_1 = _result_1.topRight
	end
	local topRightRadius = if _result_1 ~= nil then CssHelper:parseCssSize(footerCorners.topRight) else noCorner
	local _result_2 = footerCorners
	if _result_2 ~= nil then
		_result_2 = _result_2.bottomLeft
	end
	local bottomLeftRadius = if _result_2 ~= nil then CssHelper:parseCssSize(footerCorners.bottomLeft) else corners
	local _result_3 = footerCorners
	if _result_3 ~= nil then
		_result_3 = _result_3.bottomRight
	end
	local bottomRightRadius = if _result_3 ~= nil then CssHelper:parseCssSize(footerCorners.bottomRight) else corners
	local _binding = resolveOverlayPosition(props, theme.components.card.footer.position)
	local overlay = _binding.overlay
	local positionProps = _binding.positionProps
	local _attributes = {
		name = "CardFooter",
		ref = ref,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	for _k, _v in positionProps do
		_attributes[_k] = _v
	end
	_attributes.Size = positionProps.Size or UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = positionProps.AutomaticSize or Enum.AutomaticSize.XY
	_attributes.BackgroundTransparency = intent.backgroundTransparency
	_attributes.BackgroundColor3 = intent.backgroundColor
	_attributes.BorderSizePixel = 0
	_attributes.backgroundImage = intent.backgroundImage
	_attributes.backgroundGradient = intent.backgroundGradient
	_attributes.Change = if overlay and card.reportOverlayFooterRect ~= nil then {
		AbsolutePosition = function(instance)
			return card.reportOverlayFooterRect(instance.AbsolutePosition, instance.AbsoluteSize)
		end,
		AbsoluteSize = function(instance)
			return card.reportOverlayFooterRect(instance.AbsolutePosition, instance.AbsoluteSize)
		end,
	} else nil
	local _exp = React.createElement(Padding, {
		resolvedPadding = padding,
	})
	local _attributes_1 = {
		key = "Stroke",
	}
	local _condition = theme.components.card.footer.borderThickness
	if _condition == nil then
		_condition = theme.components.card.borderThickness
	end
	_attributes_1.Thickness = _condition
	_attributes_1.Color = intent.borderColor
	_attributes_1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	return React.createElement(Container, _attributes, _exp, React.createElement("uistroke", _attributes_1), React.createElement("uicorner", {
		key = "Corners",
		TopLeftRadius = topLeftRadius,
		TopRightRadius = topRightRadius,
		BottomLeftRadius = bottomLeftRadius,
		BottomRightRadius = bottomRightRadius,
	}), props.children)
end)
local Card = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local headerRect, setHeaderRect = React.useState()
	local footerRect, setFooterRect = React.useState()
	local wrapperAbsoluteY, setWrapperAbsoluteY = React.useState()
	local wrapperAbsoluteSize, setWrapperAbsoluteSize = React.useState()
	local overlayWrapperRef = React.useRef()
	local reportOverlayHeaderRect = React.useCallback(function(position, size)
		setHeaderRect({
			position = position,
			size = size,
		})
	end, {})
	local reportOverlayFooterRect = React.useCallback(function(position, size)
		setFooterRect({
			position = position,
			size = size,
		})
	end, {})
	local contextValue = React.useMemo(function()
		return {
			intent = props.intent,
			reportOverlayHeaderRect = reportOverlayHeaderRect,
			reportOverlayFooterRect = reportOverlayFooterRect,
		}
	end, { props.intent, reportOverlayHeaderRect, reportOverlayFooterRect })
	local intent = ColorHelper:getIntentColors(theme, props.intent or "primary", "default", theme.components.card.header.intents)
	local _binding = React.useMemo(function()
		local flow = {}
		local header
		local footer
		React.Children.forEach(props.children, function(child)
			if child == nil then
				return nil
			end
			local directHeader = if React.isValidElement(child) and child.type == CardHeader then child else nil
			local wrappedChild = if React.isValidElement(child) then (child.props).children else nil
			local wrappedHeader = if React.isValidElement(wrappedChild) and wrappedChild.type == CardHeader then wrappedChild else nil
			local headerElement = directHeader or wrappedHeader
			if headerElement ~= nil and header == nil then
				local _condition = headerElement.props.overlay
				if _condition == nil then
					local _result = theme.components.card.header.position
					if _result ~= nil then
						_result = _result.position
					end
					_condition = (_result == "absolute")
				end
				if _condition then
					header = child
					return nil
				end
			end
			if React.isValidElement(child) and child.type == CardFooter and footer == nil then
				local footerElement = child
				local _condition = footerElement.props.overlay
				if _condition == nil then
					local _result = theme.components.card.footer.position
					if _result ~= nil then
						_result = _result.position
					end
					_condition = (_result == "absolute")
				end
				if _condition then
					footer = footerElement
					return nil
				end
			end
			local _child = child
			table.insert(flow, _child)
		end)
		return {
			flowChildren = flow,
			overlayHeader = header,
			overlayFooter = footer,
		}
	end, { props.children, theme })
	local flowChildren = _binding.flowChildren
	local overlayHeader = _binding.overlayHeader
	local overlayFooter = _binding.overlayFooter
	local hasOverlay = overlayHeader ~= nil or overlayFooter ~= nil
	local headerClearance = if overlayHeader ~= nil and headerRect ~= nil and wrapperAbsoluteY ~= nil then math.max(0, (headerRect.position.Y + headerRect.size.Y) - wrapperAbsoluteY) else 0
	local wrapperBottomY = if wrapperAbsoluteY ~= nil and wrapperAbsoluteSize ~= nil then wrapperAbsoluteY + wrapperAbsoluteSize.Y else nil
	local footerClearance = if overlayFooter ~= nil and footerRect ~= nil and wrapperBottomY ~= nil then math.max(0, wrapperBottomY - footerRect.position.Y) else 0
	local _result
	if hasOverlay then
		local _object = table.clone(props)
		setmetatable(_object, nil)
		_object.Position = nil
		_object.AnchorPoint = nil
		_object.top = nil
		_object.left = nil
		_object.right = nil
		_object.bottom = nil
		_object.ZIndex = nil
		_object.LayoutOrder = nil
		_result = _object
	else
		_result = props
	end
	local boxProps = _result
	local _result_1
	if overlayFooter == nil then
		local _result_2 = SpacingHelper:GetExplicitPadding(theme.components.box.padding, theme.default.spacing)
		if _result_2 ~= nil then
			_result_2 = _result_2.bottom
		end
		local _condition = _result_2
		if _condition == nil then
			_condition = 0
		end
		_result_1 = _condition
	else
		_result_1 = 0
	end
	local explicitBoxBottomFloor = _result_1
	local _result_2
	if headerClearance > 0 or footerClearance > 0 or explicitBoxBottomFloor > 0 then
		local _object = table.clone(boxProps)
		setmetatable(_object, nil)
		_object.resolvedPadding = {
			top = headerClearance,
			bottom = math.max(footerClearance, explicitBoxBottomFloor),
			left = 0,
			right = 0,
		}
		_result_2 = _object
	else
		_result_2 = boxProps
	end
	local boxPropsWithOverlayClearance = _result_2
	local _attributes = table.clone(boxPropsWithOverlayClearance)
	setmetatable(_attributes, nil)
	local _condition = props.name
	if _condition == nil then
		_condition = "Card"
	end
	_attributes.name = _condition
	_attributes.ref = ref
	_attributes.center = nil
	_attributes.spacing = "None"
	_attributes["border-color"] = intent.borderColor
	local cardBox = (React.createElement(Box, _attributes, React.createElement(VStack, {
		spacing = "None",
	}, flowChildren)))
	local _object = table.clone(props)
	setmetatable(_object, nil)
	_object.center = nil
	local wrapperPositionProps = _object
	local _result_3
	if hasOverlay then
		local _attributes_1 = {}
		local _condition_1 = props.name
		if _condition_1 == nil then
			_condition_1 = "CardOverlayWrapper"
		end
		_attributes_1.key = _condition_1
		_attributes_1.ref = overlayWrapperRef
		_attributes_1.BackgroundTransparency = 1
		_attributes_1.ClipsDescendants = false
		_attributes_1.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
		_attributes_1.AutomaticSize = SizeHelper:GetAutoSize(props)
		_attributes_1.Position = SizeHelper:GetPosition(wrapperPositionProps)
		_attributes_1.AnchorPoint = SizeHelper:GetAnchor(wrapperPositionProps)
		_attributes_1.ZIndex = props.ZIndex
		_attributes_1.LayoutOrder = props.LayoutOrder
		_attributes_1.Change = {
			AbsolutePosition = function(instance)
				return setWrapperAbsoluteY(instance.AbsolutePosition.Y)
			end,
			AbsoluteSize = function(instance)
				return setWrapperAbsoluteSize(instance.AbsoluteSize)
			end,
		}
		_result_3 = (React.createElement("frame", _attributes_1, cardBox, overlayHeader, overlayFooter))
	else
		_result_3 = cardBox
	end
	local boxWithOverlay = _result_3
	local isCentered = props.center == true and props.Position == nil and props.AnchorPoint == nil
	return React.createElement(CardContext.Provider, {
		value = contextValue,
	}, if isCentered then (React.createElement(Container, {
		name = "CardCenterWrapper",
		Size = UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
	}, React.createElement("uilistlayout", {
		key = "CenterLayout",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	}), boxWithOverlay)) else boxWithOverlay)
end)
Card.Header = CardHeader
Card.Footer = CardFooter
Card.Body = CardBody
return {
	CardHeader = CardHeader,
	CardBody = CardBody,
	CardFooter = CardFooter,
	Card = Card,
}
