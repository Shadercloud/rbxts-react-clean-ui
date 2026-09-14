-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _ = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local BreakpointHelper = _.BreakpointHelper
local SizeHelper = _.SizeHelper
local SpacingHelper = _.SpacingHelper
local SETTLE_POLL_FRAMES = 10
local function GridCell(props)
	local measurementRef = React.useRef()
	local reportMeasurement = React.useCallback(function()
		local instance = measurementRef.current
		if instance ~= nil then
			props.onMeasured(props.measureKey, props.index, instance.AbsoluteSize.Y)
		end
	end, { props.onMeasured, props.measureKey, props.index })
	React.useEffect(function()
		if props.locked then
			return nil
		end
		local mounted = true
		reportMeasurement()
		task.spawn(function()
			for frame = 0, SETTLE_POLL_FRAMES - 1 do
				task.wait()
				if not mounted then
					return nil
				end
				reportMeasurement()
			end
		end)
		return function()
			mounted = false
		end
	end, { props.locked, props.measureKey, reportMeasurement })
	return React.createElement("frame", {
		key = "GridCell",
		ref = measurementRef,
		LayoutOrder = props.index,
		Size = UDim2.new(props.width, UDim.new(0, if props.locked then props.height else 0)),
		AutomaticSize = if props.locked then Enum.AutomaticSize.None else Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Change = if props.locked then nil else {
			AbsoluteSize = reportMeasurement,
		},
	}, props.children)
end
local Grid = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local width, setWidth = React.useState(0)
	local heights, setHeights = React.useState({
		key = "",
		values = {},
	})
	local lock, setLock = React.useState(nil)
	local breakpoints = props.breakpoints or theme.breakpoints
	local breakpoint = BreakpointHelper:getBreakpoint(width, breakpoints)
	local _condition = SizeHelper:resolveResponsiveValue(props.cols, breakpoint)
	if _condition == nil then
		_condition = 1
	end
	local cols = math.max(_condition, 1)
	local gap = SpacingHelper:GetPadding(theme, props.gap)
	local cellWidthScale = 1 / cols
	local cellWidthOffset = math.floor(-gap * (cols - 1) / cols)
	local cellWidth = UDim.new(cellWidthScale, cellWidthOffset)
	local childCount = React.Children.count(props.children)
	local measureKey = `{width}:{cols}:{gap}:{childCount}`
	local locked = lock ~= nil and lock.key == measureKey
	local lockedHeight = if locked then lock.height else 0
	React.useEffect(function()
		local _condition_1 = locked or heights.key ~= measureKey
		if not _condition_1 then
			-- ▼ ReadonlyMap.size ▼
			local _size = 0
			for _1 in heights.values do
				_size += 1
			end
			-- ▲ ReadonlyMap.size ▲
			_condition_1 = _size < childCount
		end
		if _condition_1 then
			return nil
		end
		local cancelled = false
		task.spawn(function()
			task.wait()
			task.wait()
			if cancelled then
				return nil
			end
			local max = 0
			for _1, height in heights.values do
				max = math.max(max, height)
			end
			setLock({
				key = measureKey,
				height = max,
			})
		end)
		return function()
			cancelled = true
		end
	end, { heights, locked, measureKey, childCount })
	local reportHeight = React.useCallback(function(reportKey, index, height)
		setHeights(function(current)
			local values = if current.key == reportKey then current.values else {}
			local updated = {}
			for key, value in values do
				updated[key] = value
			end
			local _index = index
			local _height = height
			updated[_index] = _height
			return {
				key = reportKey,
				values = updated,
			}
		end)
	end, {})
	local cellIndex = 0
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Grid"
	end
	_attributes.key = _condition_1
	_attributes.ref = ref
	_attributes.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.BackgroundTransparency = 1
	_attributes.BorderSizePixel = 0
	_attributes.Change = {
		AbsoluteSize = function(instance)
			local nextWidth = instance.AbsoluteSize.X
			setWidth(function(currentWidth)
				return if currentWidth == nextWidth then currentWidth else nextWidth
			end)
		end,
	}
	return React.createElement("frame", _attributes, if locked then (React.createElement("uigridlayout", {
		key = "GridLayout",
		CellSize = UDim2.new(cellWidthScale, cellWidthOffset, 0, lockedHeight),
		CellPadding = UDim2.new(0, gap, 0, gap),
		FillDirection = Enum.FillDirection.Horizontal,
		FillDirectionMaxCells = cols,
		SortOrder = Enum.SortOrder.LayoutOrder,
	})) else (React.createElement("uilistlayout", {
		key = "GridMeasureLayout",
		FillDirection = Enum.FillDirection.Horizontal,
		Wraps = true,
		Padding = UDim.new(0, gap),
		SortOrder = Enum.SortOrder.LayoutOrder,
	})), React.Children.map(props.children, function(child)
		local _original = cellIndex
		cellIndex += 1
		local index = _original
		return React.createElement(GridCell, {
			key = index,
			index = index,
			width = cellWidth,
			height = lockedHeight,
			locked = locked,
			measureKey = measureKey,
			onMeasured = reportHeight,
		}, child)
	end))
end)
return {
	Grid = Grid,
}
