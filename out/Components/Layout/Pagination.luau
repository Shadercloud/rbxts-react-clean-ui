-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ColorHelper = _Helpers.ColorHelper
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local _HoverButton = TS.import(script, script.Parent.Parent, "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
local Icon = TS.import(script, script.Parent.Parent, "Surface", "Icon").Icon
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local Container = TS.import(script, script.Parent, "Container").Container
local HStack = TS.import(script, script.Parent, "HStack").HStack
local function computePaginationItems(page, totalPages, siblingCount)
	local pageCount = math.max(0, math.floor(totalPages))
	if pageCount == 0 then
		return {}
	end
	local currentPage = math.clamp(math.floor(page), 1, pageCount)
	local siblings = math.max(0, math.floor(siblingCount))
	local visiblePageCount = siblings * 2 + 5
	if pageCount <= visiblePageCount then
		local allPages = {}
		do
			local value = 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					value += 1
				else
					_shouldIncrement = true
				end
				if not (value <= pageCount) then
					break
				end
				local _value = value
				table.insert(allPages, _value)
			end
		end
		return allPages
	end
	local leftSiblingIndex = math.max(currentPage - siblings, 1)
	local rightSiblingIndex = math.min(currentPage + siblings, pageCount)
	local showLeftEllipsis = leftSiblingIndex > 2
	local showRightEllipsis = rightSiblingIndex < pageCount - 1
	if not showLeftEllipsis and showRightEllipsis then
		-- Near the start: no left ellipsis needed, so extend the leading run of
		-- numbers to keep the total item count constant.
		local leftItemCount = siblings * 2 + 3
		local items = {}
		do
			local value = 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					value += 1
				else
					_shouldIncrement = true
				end
				if not (value <= leftItemCount) then
					break
				end
				local _value = value
				table.insert(items, _value)
			end
		end
		table.insert(items, "ellipsis")
		table.insert(items, pageCount)
		return items
	end
	if showLeftEllipsis and not showRightEllipsis then
		-- Near the end: no right ellipsis needed, so extend the trailing run of
		-- numbers to keep the total item count constant.
		local rightItemCount = siblings * 2 + 3
		local items = { 1, "ellipsis" }
		do
			local value = pageCount - rightItemCount + 1
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					value += 1
				else
					_shouldIncrement = true
				end
				if not (value <= pageCount) then
					break
				end
				local _value = value
				table.insert(items, _value)
			end
		end
		return items
	end
	-- Both ellipses shown (the normal middle case) — unchanged from before.
	local items = { 1, "ellipsis" }
	do
		local value = leftSiblingIndex
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				value += 1
			else
				_shouldIncrement = true
			end
			if not (value <= rightSiblingIndex) then
				break
			end
			local _value = value
			table.insert(items, _value)
		end
	end
	table.insert(items, "ellipsis")
	table.insert(items, pageCount)
	return items
end
local PaginationContext = React.createContext(nil)
local function usePagination()
	local context = React.useContext(PaginationContext)
	if context == nil then
		error("Pagination subparts must be rendered inside Pagination")
	end
	return context
end
local function PaginationItemVisual(props)
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
	local colors = ColorHelper:getIntentColors(theme, "primary", _result, theme.components.pagination.item.intents)
	local _exp = React.createElement(Corners, {
		radius = theme.components.pagination.item.cornerRadius,
	})
	local _exp_1 = React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, props, theme.components.pagination.item.spacing, theme.components.pagination.item.padding),
	})
	local _attributes = {}
	local _condition = colors.boxShadow
	if _condition == nil then
		_condition = theme.components.pagination.item.boxShadow
	end
	_attributes.value = _condition
	return React.createElement(React.Fragment, nil, _exp, _exp_1, React.createElement(BoxShadow, _attributes), if props.text ~= nil then (React.createElement(Text, {
		name = "PaginationItemText",
		text = props.text,
		TextColor3 = colors.textColor,
		typography = TypographyHelper:getTypography(theme, nil, colors.typography or theme.components.pagination.item.typography),
	})) else (React.createElement(Container, {
		name = "PaginationIconContainer",
	}, React.createElement(Icon, {
		name = "PaginationIcon",
		icon = props.icon,
		color = colors.textColor,
	}))))
end
local function getButtonState(theme)
	local itemTheme = theme.components.pagination.item
	local defaultColors = ColorHelper:getIntentColors(theme, "primary", "default", itemTheme.intents)
	local hoverColors = ColorHelper:getIntentColors(theme, "primary", "hover", itemTheme.intents)
	local focusColors = ColorHelper:getIntentColors(theme, "primary", "focus", itemTheme.intents)
	local disabledColors = ColorHelper:getIntentColors(theme, "primary", "disabled", itemTheme.intents)
	return {
		defaultColors = defaultColors,
		hoverColors = hoverColors,
		focusColors = focusColors,
		disabledColors = disabledColors,
		defaultImage = CssHelper:resolveBackgroundImage(defaultColors.backgroundImage),
		hoverImage = CssHelper:resolveBackgroundImage(hoverColors.backgroundImage),
		focusImage = CssHelper:resolveBackgroundImage(focusColors.backgroundImage),
	}
end
local function PaginationButton(props)
	local theme = React.useContext(CleanThemeContext)
	local state = getButtonState(theme)
	return React.createElement(HoverButton, {
		name = props.name,
		isSelected = props.selected,
		default = {
			Active = not props.disabled,
			Selectable = not props.disabled,
			LayoutOrder = props.layoutOrder,
			Size = UDim2.fromScale(0, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundColor3 = if props.disabled then state.disabledColors.backgroundColor else state.defaultColors.backgroundColor,
			BackgroundTransparency = if props.disabled then state.disabledColors.backgroundTransparency else state.defaultColors.backgroundTransparency,
			BorderSizePixel = theme.components.pagination.item.borderThickness,
			BorderColor3 = if props.disabled then state.disabledColors.borderColor else state.defaultColors.borderColor,
			AutoButtonColor = false,
			Image = state.defaultImage.Image,
			ImageColor3 = state.defaultImage.ImageColor3,
			ImageTransparency = if props.disabled then 0.7 else state.defaultImage.ImageTransparency,
			ScaleType = state.defaultImage.ScaleType,
			SliceCenter = state.defaultImage.SliceCenter,
			SliceScale = state.defaultImage.SliceScale,
			TileSize = state.defaultImage.TileSize,
			Event = {
				Activated = function()
					if not props.disabled then
						props.onActivate()
					end
				end,
			},
		},
		hover = if props.disabled then nil else {
			BackgroundColor3 = state.hoverColors.backgroundColor,
			BackgroundTransparency = state.hoverColors.backgroundTransparency,
			BorderColor3 = state.hoverColors.borderColor,
			Image = state.hoverImage.Image,
			ImageColor3 = state.hoverImage.ImageColor3,
			ImageTransparency = state.hoverImage.ImageTransparency,
			ScaleType = state.hoverImage.ScaleType,
			SliceCenter = state.hoverImage.SliceCenter,
			SliceScale = state.hoverImage.SliceScale,
			TileSize = state.hoverImage.TileSize,
		},
		focus = {
			BackgroundColor3 = state.focusColors.backgroundColor,
			BackgroundTransparency = state.focusColors.backgroundTransparency,
			BorderColor3 = state.focusColors.borderColor,
			Image = state.focusImage.Image,
			ImageColor3 = state.focusImage.ImageColor3,
			ImageTransparency = state.focusImage.ImageTransparency,
			ScaleType = state.focusImage.ScaleType,
			SliceCenter = state.focusImage.SliceCenter,
			SliceScale = state.focusImage.SliceScale,
			TileSize = state.focusImage.TileSize,
		},
	}, props.children)
end
local function PaginationItem(props)
	local _binding = usePagination()
	local page = _binding.page
	local setPage = _binding.setPage
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.text = `{props.value}`
	return React.createElement(PaginationButton, {
		name = `PaginationItem-{props.value}`,
		selected = page == props.value,
		layoutOrder = props.layoutOrder,
		onActivate = function()
			return setPage(props.value)
		end,
	}, React.createElement(PaginationItemVisual, _attributes))
end
local function PaginationPrev()
	local _binding = usePagination()
	local page = _binding.page
	local setPage = _binding.setPage
	local canGoPrev = _binding.canGoPrev
	return React.createElement(PaginationButton, {
		name = "PaginationPrev",
		disabled = not canGoPrev,
		onActivate = function()
			return setPage(page - 1)
		end,
	}, React.createElement(PaginationItemVisual, {
		icon = "chevron-left",
		disabled = not canGoPrev,
	}))
end
local function PaginationNext()
	local _binding = usePagination()
	local page = _binding.page
	local setPage = _binding.setPage
	local canGoNext = _binding.canGoNext
	return React.createElement(PaginationButton, {
		name = "PaginationNext",
		disabled = not canGoNext,
		onActivate = function()
			return setPage(page + 1)
		end,
	}, React.createElement(PaginationItemVisual, {
		icon = "chevron-right",
		disabled = not canGoNext,
	}))
end
local function PaginationEllipsis(props)
	local theme = React.useContext(CleanThemeContext)
	return React.createElement(Text, {
		name = "PaginationEllipsis",
		text = "…",
		LayoutOrder = props.layoutOrder,
		typography = TypographyHelper:getTypography(theme, nil, theme.components.pagination.item.typography),
	})
end
local function PaginationList(props)
	local _binding = usePagination()
	local items = _binding.items
	local _condition = props.children
	if _condition == nil then
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#items)
		local _callback = function(item, index)
			return if item == "ellipsis" then (React.createElement(PaginationEllipsis, {
				key = `ellipsis-{index}`,
				layoutOrder = index,
			})) else (React.createElement(PaginationItem, {
				key = item,
				value = item,
				layoutOrder = index,
			}))
		end
		for _k, _v in items do
			_newValue[_k] = _callback(_v, _k - 1, items)
		end
		-- ▲ ReadonlyArray.map ▲
		_condition = _newValue
	end
	return React.createElement(Container, {
		name = "PaginationList",
	}, React.createElement(HStack, {
		Wraps = false,
		valign = "Center",
	}, _condition))
end
local function PaginationDefaultLayout()
	local theme = React.useContext(CleanThemeContext)
	local paginationTheme = theme.components.pagination
	return React.createElement(HStack, {
		Wraps = false,
		valign = "Center",
		spacing = "None",
		Padding = UDim.new(0, SpacingHelper:GetPadding(theme, nil, paginationTheme.spacing)),
	}, React.createElement(PaginationPrev), React.createElement(PaginationList), React.createElement(PaginationNext))
end
local Pagination = React.forwardRef(function(props, _ref)
	local theme = React.useContext(CleanThemeContext)
	local pageCount = math.max(0, math.floor(props.totalPages))
	local currentPage = if pageCount == 0 then 0 else math.clamp(math.floor(props.page), 1, pageCount)
	local _condition = props.siblingCount
	if _condition == nil then
		_condition = 1
	end
	local siblingCount = math.max(0, math.floor(_condition))
	local items = React.useMemo(function()
		return computePaginationItems(currentPage, pageCount, siblingCount)
	end, { currentPage, pageCount, siblingCount })
	local setPage = function(page)
		if pageCount == 0 then
			return nil
		end
		props.onPageChange(math.clamp(math.floor(page), 1, pageCount))
	end
	local contextValue = React.useMemo(function()
		return {
			page = currentPage,
			totalPages = pageCount,
			items = items,
			setPage = setPage,
			canGoPrev = currentPage > 1,
			canGoNext = currentPage < pageCount,
		}
	end, { currentPage, pageCount, items, props.onPageChange })
	local paginationTheme = theme.components.pagination
	return React.createElement(PaginationContext.Provider, {
		value = contextValue,
	}, React.createElement(Container, {
		name = "Pagination",
		BackgroundColor3 = paginationTheme.backgroundColor,
		BackgroundTransparency = paginationTheme.backgroundTransparency,
		BorderSizePixel = 0,
	}, React.createElement("uistroke", {
		key = "PaginationBorder",
		Thickness = paginationTheme.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = paginationTheme.borderColor,
	}), React.createElement(Corners, {
		radius = paginationTheme.cornerRadius,
	}), React.createElement(Padding, {
		resolvedPadding = SpacingHelper:GetResolvedPadding(theme, {}, paginationTheme.spacing, paginationTheme.padding),
	}), if props.children ~= nil then props.children else React.createElement(PaginationDefaultLayout)))
end)
Pagination.Prev = PaginationPrev
Pagination.Next = PaginationNext
Pagination.Item = PaginationItem
Pagination.Ellipsis = PaginationEllipsis
Pagination.List = PaginationList
return {
	Pagination = Pagination,
}
