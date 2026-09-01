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
-- Resolves a theme-driven CssPosition into raw Position/AnchorPoint offsets.
-- This is a one-off resolver rather than a SizeHelper addition because
-- CssPosition's `center` is axis-aware (`"x"` / `"y"`) so it can express
-- "center horizontally, anchor to the top with an offset" — something
-- SizeHelper.GetPosition/GetAnchor can't do since they apply `center`
-- identically to both axes, and that symmetric behavior is relied on
-- elsewhere in the codebase so isn't something to widen here.
local function resolveCssPositionOffset(position)
	local centerX = position.center == true or position.center == "x"
	local centerY = position.center == true or position.center == "y"
	local anchorX = if centerX then 0.5 else (if position.left == nil and position.right ~= nil then 1 else 0)
	local anchorY = if centerY then 0.5 else (if position.top == nil and position.bottom ~= nil then 1 else 0)
	local posX = if centerX then UDim.new(0.5, 0) elseif position.left ~= nil then SizeHelper:toUDim(position.left) elseif position.right ~= nil then UDim.new(1 - SizeHelper:toUDim(position.right).Scale, -SizeHelper:toUDim(position.right).Offset) else UDim.new(0, 0)
	local posY = if centerY then UDim.new(0.5, 0) elseif position.top ~= nil then SizeHelper:toUDim(position.top) elseif position.bottom ~= nil then UDim.new(1 - SizeHelper:toUDim(position.bottom).Scale, -SizeHelper:toUDim(position.bottom).Offset) else UDim.new(0, 0)
	-- A theme-driven fixed/relative width (only meaningful in overlay mode,
	-- see CssPosition.width) forces a fixed-width/auto-height Size, taking
	-- over the caller's default Size={fromScale(0,0)}/AutomaticSize={XY} —
	-- otherwise Size/AutomaticSize are left undefined so the caller's own
	-- default applies unchanged. Parsed via CssHelper.parseCssSize (not
	-- SizeHelper.toUDim, used for top/left/right/bottom above) since it's
	-- the one that understands the "<percent>% - <px>px" calc() shape a
	-- width value may use (e.g. "100% - 50px").
	--
	-- When `width` isn't explicit but both `left` and `right` are set, imply
	-- a width from them the same way CSS does for an absolutely-positioned
	-- element: width = 100% - left - right. Explicit `width` always wins if
	-- somehow both are set.
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
-- Header/footer overlay mode escapes the card's VStack (a UIListLayout
-- forcibly repositions every sibling it lays out, so there's no way to keep
-- a custom Position/AnchorPoint on a child that stays inside it) — Card
-- pulls an overlay-requesting Header/Footer out of the flow and renders it
-- as an absolutely-positioned sibling of the Box instead. Overlay mode is
-- requested via the instance `overlay` prop or `theme.components.card.header
-- /footer.position.position === "absolute"`; when the instance sets any of
-- its own Position/AnchorPoint/top/left/right/bottom/center fields, those
-- win wholesale over the theme's CssPosition (mixing partial fields across
-- the two differently-shaped position vocabularies isn't attempted), exactly
-- mirroring the precedence the previous PositionElementProps-based
-- implementation gave instance props.
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
	local _binding = resolveOverlayPosition(props, theme.components.card.header.position)
	local overlay = _binding.overlay
	local positionProps = _binding.positionProps
	local _attributes = {
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
	local _attributes_1 = {}
	local _condition = theme.components.card.header.borderThickness
	if _condition == nil then
		_condition = theme.components.card.borderThickness
	end
	_attributes_1.Thickness = _condition
	_attributes_1.Color = intent.borderColor
	_attributes_1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	return React.createElement(Container, _attributes, _exp, React.createElement("uistroke", _attributes_1), React.createElement("uicorner", {
		TopLeftRadius = corners,
		TopRightRadius = corners,
		BottomLeftRadius = UDim.new(0, 0),
		BottomRightRadius = UDim.new(0, 0),
	}), props.children)
end)
local CardBody = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	-- Unified 4-tier padding resolution (see SpacingHelper.GetResolvedPadding):
	-- `card.body.spacing` (tier 2) overrides the global spacing map per
	-- scale key, falling back to it for any key it doesn't define, and
	-- `card.body.padding` (tier 3) overrides the scale-based tiers
	-- entirely at the active key. CardBody wraps its children in a
	-- Container, not a Box, so it doesn't get Box's automatic
	-- `box.padding` application for free — this resolves independently
	-- against `theme.components.card.body`'s own tiers.
	local paddingSourceProps = props
	local _attributes = {
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
	local _binding = resolveOverlayPosition(props, theme.components.card.footer.position)
	local overlay = _binding.overlay
	local positionProps = _binding.positionProps
	local _attributes = {
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
	local _attributes_1 = {}
	local _condition = theme.components.card.footer.borderThickness
	if _condition == nil then
		_condition = theme.components.card.borderThickness
	end
	_attributes_1.Thickness = _condition
	_attributes_1.Color = intent.borderColor
	_attributes_1.BorderStrokePosition = Enum.BorderStrokePosition.Inner
	return React.createElement(Container, _attributes, _exp, React.createElement("uistroke", _attributes_1), React.createElement("uicorner", {
		TopLeftRadius = UDim.new(0, 0),
		TopRightRadius = UDim.new(0, 0),
		BottomLeftRadius = corners,
		BottomRightRadius = corners,
	}), props.children)
end)
local Card = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	-- Overlay clearance: an overlay header (see resolveOverlayPosition)
	-- is pulled out of the VStack entirely, so nothing reserves space
	-- for it — its rendered box typically extends downward past its own
	-- anchor point and overlaps into the top of the Box. These two
	-- pieces of state capture the header's reported rect (via
	-- CardContext.reportOverlayHeaderRect, set on CardHeader below) and
	-- the overlay wrapper frame's own AbsolutePosition, so the amount of
	-- that overlap can be measured and reserved as extra top padding on
	-- the Box (see headerClearance/boxProps below). Both are undefined
	-- until their first Change event fires after mount, which is the
	-- same measure-then-settle characteristic Accordion.tsx accepts for
	-- its own AbsoluteSize-driven measurements.
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
	-- Pull out a Header/Footer that wants overlay placement so it can be
	-- rendered outside the VStack below (see resolveOverlayPosition above
	-- for why it can't stay inside the VStack and still be positioned).
	-- Everything else renders in place, in its original order.
	local _binding = React.useMemo(function()
		local flow = {}
		local header
		local footer
		React.Children.forEach(props.children, function(child)
			if child == nil then
				return nil
			end
			if React.isValidElement(child) and child.type == CardHeader and header == nil then
				local headerElement = child
				local _condition = headerElement.props.overlay
				if _condition == nil then
					local _result = theme.components.card.header.position
					if _result ~= nil then
						_result = _result.position
					end
					_condition = (_result == "absolute")
				end
				if _condition then
					header = headerElement
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
	React.useEffect(function()
		if not hasOverlay then
			return nil
		end
		local frame = overlayWrapperRef.current
		if not frame then
			return nil
		end
		-- Some renderers (e.g. the browser-based Loom scene preview) don't
		-- back this ref with an instance that supports property-changed
		-- signals, so guard the subscription instead of throwing and
		-- losing overlay clearance tracking.
		local positionConn
		local sizeConn
		pcall(function()
			positionConn = frame:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
				return setWrapperAbsoluteY(frame.AbsolutePosition.Y)
			end)
		end)
		pcall(function()
			sizeConn = frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				return setWrapperAbsoluteSize(frame.AbsoluteSize)
			end)
		end)
		return function()
			local _result = positionConn
			if _result ~= nil then
				_result:Disconnect()
			end
			local _result_1 = sizeConn
			if _result_1 ~= nil then
				_result_1:Disconnect()
			end
		end
	end, { hasOverlay })
	-- How far the overlay header's bottom edge extends past the
	-- wrapper's (i.e. the Box's) top edge — 0 when there's no overlap
	-- (e.g. a small/no theme offset) or nothing has been measured yet.
	local headerClearance = if overlayHeader ~= nil and headerRect ~= nil and wrapperAbsoluteY ~= nil then math.max(0, (headerRect.position.Y + headerRect.size.Y) - wrapperAbsoluteY) else 0
	-- Same idea, mirrored for the footer: the wrapper's bottom edge
	-- (its top plus its own height) minus the footer's reported top
	-- edge (AbsolutePosition is always the top-left corner regardless
	-- of AnchorPoint) is how far the footer's top edge sits above the
	-- Box's bottom edge, i.e. how much it overlaps upward into it.
	local wrapperBottomY = if wrapperAbsoluteY ~= nil and wrapperAbsoluteSize ~= nil then wrapperAbsoluteY + wrapperAbsoluteSize.Y else nil
	local footerClearance = if overlayFooter ~= nil and footerRect ~= nil and wrapperBottomY ~= nil then math.max(0, wrapperBottomY - footerRect.position.Y) else 0
	-- The Box below now sits inside an extra positioning frame (see
	-- boxWithOverlay), so its own Position/AnchorPoint/ZIndex/LayoutOrder
	-- are cleared here to avoid double-applying them — the wrapper frame
	-- owns those instead.
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
	-- When there's no footer at all, footerClearance is always 0 (there's
	-- nothing to measure an overlap against), so fall back to the Box's
	-- own explicit theme.components.box.padding bottom inset — if the
	-- theme sets one — as a floor instead. This keeps content clear of a
	-- themed Box's decorative border image (e.g. wooden's wood-frame art,
	-- which needs a real bottom inset) even when there's no footer to
	-- reserve that space via measured overlap. Themes that don't set an
	-- explicit box padding (GetExplicitPadding returns undefined) resolve
	-- this floor to 0, so behavior there is unchanged. When a footer IS
	-- present, footerClearance (its real measured overlap) is used as-is
	-- exactly as before — this floor never applies then, since the
	-- footer's own overlap already reserves whatever space it needs.
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
	-- When an overlay header and/or footer measurably overlaps into the
	-- Box (headerClearance/footerClearance > 0), or the footer-absent
	-- floor above is nonzero, reserve that much extra top/bottom padding
	-- via resolvedPadding — this takes over Box's own outer padding,
	-- which is otherwise 0/0/0/0 since Card always forces spacing="None"
	-- on Box below.
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
	_attributes.ref = ref
	_attributes.center = nil
	_attributes.spacing = "None"
	_attributes["border-color"] = intent.borderColor
	local cardBox = (React.createElement(Box, _attributes, React.createElement(VStack, {
		spacing = "None",
	}, flowChildren)))
	-- ClipsDescendants is off so an overlay header/footer can protrude
	-- past the Box's own edges (e.g. a plaque mounted above the top
	-- border). This frame takes over the Position/AnchorPoint the Box
	-- would otherwise have used, and auto-sizes to hug the Box (plus
	-- whatever the overlay siblings protrude by).
	--
	-- `center` is stripped before deriving Position/AnchorPoint here,
	-- the same way `cardBox`'s Box always gets `center={undefined}`:
	-- when `center` is set, centering is handled by the outer
	-- `isCentered` wrapper below (a UIListLayout that centers this
	-- whole frame), not by this frame's own Position/AnchorPoint. If
	-- both applied `center` at once, the UIListLayout would place the
	-- frame using an (0,0)-anchor assumption while the frame itself
	-- reported a (0.5,0.5) AnchorPoint, offsetting it by half its own
	-- size and letting its (ClipsDescendants=false) contents spill out.
	-- Explicit top/left/right/bottom/Position/AnchorPoint overrides are
	-- unaffected and still apply directly to this frame.
	local _object = table.clone(props)
	setmetatable(_object, nil)
	_object.center = nil
	local wrapperPositionProps = _object
	local boxWithOverlay = if hasOverlay then (React.createElement("frame", {
		ref = overlayWrapperRef,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
		Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1)),
		AutomaticSize = SizeHelper:GetAutoSize(props),
		Position = SizeHelper:GetPosition(wrapperPositionProps),
		AnchorPoint = SizeHelper:GetAnchor(wrapperPositionProps),
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
	}, cardBox, overlayHeader, overlayFooter)) else cardBox
	local isCentered = props.center == true and props.Position == nil and props.AnchorPoint == nil
	return React.createElement(CardContext.Provider, {
		value = contextValue,
	}, if isCentered then (React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
	}, React.createElement("uilistlayout", {
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
