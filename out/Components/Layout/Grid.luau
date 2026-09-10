-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _ = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local BreakpointHelper = _.BreakpointHelper
local SizeHelper = _.SizeHelper
local SpacingHelper = _.SpacingHelper
-- How many real engine frames a cell keeps re-reporting its own AbsoluteSize
-- for after a measure pass starts. See the effect below for why this is a
-- fixed poll window rather than a "wait until it stops changing" check.
local SETTLE_POLL_FRAMES = 10
local function GridCell(props)
	local measurementRef = React.useRef()
	local reportMeasurement = React.useCallback(function()
		local instance = measurementRef.current
		if instance ~= nil then
			props.onMeasured(props.measureKey, props.index, instance.AbsoluteSize.Y)
		end
	end, { props.onMeasured, props.measureKey, props.index })
	-- Nested AutomaticSize content (e.g. this cell's frame auto-sizing to fit
	-- a TextLabel that is itself auto-sizing to fit wrapped text) can take
	-- several real engine frames - not one Lua resumption cycle - to reach
	-- its final size, and there is no reliable signal for "done": a poll
	-- that keeps reading the same not-yet-updated value is indistinguishable
	-- from one that has genuinely settled. So instead of trying to detect
	-- settling, just keep re-reporting every real frame for a fixed window;
	-- Grid's own settle effect (see there) only ever commits once this
	-- window's reports stop arriving, so it naturally waits out however long
	-- this takes rather than racing it. The live `Change` binding below
	-- keeps reporting indefinitely after this window too, for content that
	-- keeps resizing beyond it.
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
		ClipsDescendants = true,
		Change = if props.locked then nil else {
			AbsoluteSize = reportMeasurement,
		},
	}, props.children)
end
-- A measure pass's collected cell heights, tagged with the `measureKey` they
-- were collected under. Tagging (rather than clearing the map via a separate
-- effect whenever the key changes) is what avoids the race that used to exist
-- here: a cell's own report and a parent-driven "reset" both wrote to the same
-- state, from two different effects in the same commit, in an order React
-- gives no guarantee about - so the reset could (and did) permanently wipe
-- out a report that had already landed. Tagging instead lets staleness be
-- detected lazily, as plain data, with no competing writer.
-- A completed lock, similarly tagged. `locked` is a value derived from
-- comparing this tag to the current `measureKey`, not its own effect-driven
-- state, so a change to width/cols/gap/childCount unlocks the grid the very
-- same render it happens in - no extra round trip required.
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
	-- Floored (not just divided) so each cell's per-pixel-rounded offset never
	-- sums, across a row, to more than the container's actual width - an exact
	-- fractional offset (e.g. gap=8, cols=5 => -6.4) rounds up on some cells,
	-- overflows the row by a couple of pixels, and makes UIGridLayout wrap the
	-- last cell early regardless of FillDirectionMaxCells.
	local cellWidthOffset = math.floor(-gap * (cols - 1) / cols)
	local cellWidth = UDim.new(cellWidthScale, cellWidthOffset)
	local childCount = React.Children.count(props.children)
	-- Identifies the current measure pass. Any change to the grid's measured
	-- width invalidates the locked row height, not just a breakpoint
	-- crossing: cell widths are Scale-based, so within one breakpoint a
	-- narrower window still re-wraps text taller (and a wider one shorter).
	-- Without this, shrinking then widening the window would leave every cell
	-- stuck at the tallest height ever measured. Width only changes when the
	-- parent resizes (unlocking alters the root's height, not its width), so
	-- this can't feed back into itself.
	local measureKey = `{width}:{cols}:{gap}:{childCount}`
	local locked = lock ~= nil and lock.key == measureKey
	local lockedHeight = if locked then lock.height else 0
	-- Nested AutomaticSize content (e.g. a Box wrapping a Text) can take more
	-- than one real engine frame - not just one Lua resumption cycle - to
	-- settle into its final height (text wrapping in particular depends on
	-- the engine's own layout pass, which runs on a frame boundary). Each
	-- further settle re-fires a cell's AbsoluteSize report and cancels this
	-- attempt via the cleanup below, which reschedules a fresh one since
	-- `heights` is a dependency. Waiting two real frames (task.wait, inside a
	-- spawned coroutine so this effect body itself never yields) - rather
	-- than a same-tick task.defer - gives that layout pass room to actually
	-- finish before we commit to a height.
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
	-- Deliberately always writes a fresh { key, values } object, even when
	-- the reported height hasn't visibly changed from last time: the cell's
	-- settle-poll (see GridCell) calls this every real frame for a fixed
	-- window specifically so each poll keeps resetting Grid's settle-effect
	-- dependency below, which is what makes that effect wait out the whole
	-- window instead of committing on a value that merely hasn't updated yet.
	local reportHeight = React.useCallback(function(reportKey, index, height)
		setHeights(function(current)
			-- A report from a stale pass (its measureKey no longer matches
			-- what Grid last computed) starts a fresh map instead of merging
			-- into whatever is currently there.
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
		-- Own 0-based counter rather than the map callback's index: the
		-- Luau React port passes a 1-based index there, and LayoutOrder
		-- is specified as the child's 0-based position.
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
