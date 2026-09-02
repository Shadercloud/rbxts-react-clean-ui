-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local HStack = _Layout.HStack
local VStack = _Layout.VStack
local Tooltip = TS.import(script, script.Parent.Parent, "Interaction").Tooltip
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local function niceStep(max, targetTicks)
	if targetTicks == nil then
		targetTicks = 5
	end
	if max <= 0 or targetTicks <= 0 then
		return 0
	end
	local rawStep = max / targetTicks
	local magnitude = math.pow(10, math.floor(math.log10(rawStep)))
	local residual = rawStep / magnitude
	local niceResidual
	if residual <= 1 then
		niceResidual = 1
	elseif residual <= 2 then
		niceResidual = 2
	elseif residual <= 5 then
		niceResidual = 5
	else
		niceResidual = 10
	end
	return niceResidual * magnitude
end
local function BarChart(props)
	local theme = React.useContext(CleanThemeContext)
	local barTheme = theme.components.charts.bar
	local xAxis = if props.data.xAxis == false then nil else props.data.xAxis
	local yAxis = if props.data.yAxis == false then nil else props.data.yAxis
	local showXAxis = props.data.xAxis ~= false
	local showYAxis = props.data.yAxis ~= false
	local stacked = props.data.stacked ~= false
	local _result = props.data.tooltips
	if _result ~= nil then
		_result = _result.combined
	end
	local combinedTooltips = _result == true
	local _exp = props.data.labels
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp)
	local _callback = function(_, index)
		local _exp_1 = props.data.datasets
		-- ▼ ReadonlyArray.reduce ▼
		local _result_1 = 0
		local _callback_1 = function(sum, dataset)
			local _exp_2 = sum
			local _condition = dataset.values[index + 1]
			if _condition == nil then
				_condition = 0
			end
			return _exp_2 + math.max(_condition, 0)
		end
		for _i = 1, #_exp_1 do
			_result_1 = _callback_1(_result_1, _exp_1[_i], _i - 1, _exp_1)
		end
		-- ▲ ReadonlyArray.reduce ▲
		return _result_1
	end
	for _k, _v in _exp do
		_newValue[_k] = _callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.map ▲
	local positiveSums = _newValue
	local _exp_1 = props.data.labels
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#_exp_1)
	local _callback_1 = function(_, index)
		local _exp_2 = props.data.datasets
		-- ▼ ReadonlyArray.reduce ▼
		local _result_1 = 0
		local _callback_2 = function(sum, dataset)
			local _exp_3 = sum
			local _condition = dataset.values[index + 1]
			if _condition == nil then
				_condition = 0
			end
			return _exp_3 + math.min(_condition, 0)
		end
		for _i = 1, #_exp_2 do
			_result_1 = _callback_2(_result_1, _exp_2[_i], _i - 1, _exp_2)
		end
		-- ▲ ReadonlyArray.reduce ▲
		return _result_1
	end
	for _k, _v in _exp_1 do
		_newValue_1[_k] = _callback_1(_v, _k - 1, _exp_1)
	end
	-- ▲ ReadonlyArray.map ▲
	local negativeSums = _newValue_1
	local _result_1
	if stacked then
		_result_1 = positiveSums
	else
		local _exp_2 = props.data.labels
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#_exp_2)
		local _callback_2 = function(_, index)
			local _exp_3 = props.data.datasets
			-- ▼ ReadonlyArray.reduce ▼
			local _result_2 = 0
			local _callback_3 = function(currentMax, dataset)
				local _exp_4 = currentMax
				local _condition = dataset.values[index + 1]
				if _condition == nil then
					_condition = 0
				end
				return math.max(_exp_4, _condition)
			end
			for _i = 1, #_exp_3 do
				_result_2 = _callback_3(_result_2, _exp_3[_i], _i - 1, _exp_3)
			end
			-- ▲ ReadonlyArray.reduce ▲
			return _result_2
		end
		for _k, _v in _exp_2 do
			_newValue_2[_k] = _callback_2(_v, _k - 1, _exp_2)
		end
		-- ▲ ReadonlyArray.map ▲
		_result_1 = _newValue_2
	end
	local positiveExtents = _result_1
	local _result_2
	if stacked then
		_result_2 = negativeSums
	else
		local _exp_2 = props.data.labels
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#_exp_2)
		local _callback_2 = function(_, index)
			local _exp_3 = props.data.datasets
			-- ▼ ReadonlyArray.reduce ▼
			local _result_3 = 0
			local _callback_3 = function(currentMin, dataset)
				local _exp_4 = currentMin
				local _condition = dataset.values[index + 1]
				if _condition == nil then
					_condition = 0
				end
				return math.min(_exp_4, _condition)
			end
			for _i = 1, #_exp_3 do
				_result_3 = _callback_3(_result_3, _exp_3[_i], _i - 1, _exp_3)
			end
			-- ▲ ReadonlyArray.reduce ▲
			return _result_3
		end
		for _k, _v in _exp_2 do
			_newValue_2[_k] = _callback_2(_v, _k - 1, _exp_2)
		end
		-- ▲ ReadonlyArray.map ▲
		_result_2 = _newValue_2
	end
	local negativeExtents = _result_2
	-- ▼ ReadonlyArray.reduce ▼
	local _result_3 = 0
	local _callback_2 = function(currentMax, value)
		return math.max(currentMax, value)
	end
	for _i = 1, #positiveExtents do
		_result_3 = _callback_2(_result_3, positiveExtents[_i], _i - 1, positiveExtents)
	end
	-- ▲ ReadonlyArray.reduce ▲
	local max = _result_3
	-- ▼ ReadonlyArray.reduce ▼
	local _result_4 = 0
	local _callback_3 = function(currentMin, value)
		return math.min(currentMin, value)
	end
	for _i = 1, #negativeExtents do
		_result_4 = _callback_3(_result_4, negativeExtents[_i], _i - 1, negativeExtents)
	end
	-- ▲ ReadonlyArray.reduce ▲
	local min = _result_4
	local _specifiedGridValues = yAxis
	if _specifiedGridValues ~= nil then
		_specifiedGridValues = _specifiedGridValues.gridLines
		if _specifiedGridValues ~= nil then
			_specifiedGridValues = _specifiedGridValues.values
		end
	end
	local specifiedGridValues = _specifiedGridValues
	local _result_5 = specifiedGridValues
	if _result_5 ~= nil then
		-- ▼ ReadonlyArray.reduce ▼
		local _result_6 = 0
		local _callback_4 = function(currentMax, value)
			return math.max(currentMax, value)
		end
		for _i = 1, #_result_5 do
			_result_6 = _callback_4(_result_6, _result_5[_i], _i - 1, _result_5)
		end
		-- ▲ ReadonlyArray.reduce ▲
		_result_5 = _result_6
	end
	local _condition = _result_5
	if _condition == nil then
		_condition = 0
	end
	local specifiedMax = _condition
	local _result_6 = specifiedGridValues
	if _result_6 ~= nil then
		-- ▼ ReadonlyArray.reduce ▼
		local _result_7 = 0
		local _callback_4 = function(currentMin, value)
			return math.min(currentMin, value)
		end
		for _i = 1, #_result_6 do
			_result_7 = _callback_4(_result_7, _result_6[_i], _i - 1, _result_6)
		end
		-- ▲ ReadonlyArray.reduce ▲
		_result_6 = _result_7
	end
	local _condition_1 = _result_6
	if _condition_1 == nil then
		_condition_1 = 0
	end
	local specifiedMin = _condition_1
	local _exp_2 = max - min
	local _result_7 = yAxis
	if _result_7 ~= nil then
		_result_7 = _result_7.ticks
	end
	local step = niceStep(_exp_2, _result_7)
	local chartMax = math.max(if step > 0 then math.ceil(max / step) * step else max, specifiedMax)
	local chartMin = math.min(if step > 0 then math.floor(min / step) * step else min, specifiedMin)
	local chartRange = chartMax - chartMin
	local gridValues = {}
	if specifiedGridValues ~= nil then
		-- ▼ ReadonlyArray.forEach ▼
		local _callback_4 = function(value)
			local _value = value
			table.insert(gridValues, _value)
			return #gridValues
		end
		for _k, _v in specifiedGridValues do
			_callback_4(_v, _k - 1, specifiedGridValues)
		end
		-- ▲ ReadonlyArray.forEach ▲
	elseif step > 0 then
		do
			local value = chartMin
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					value += step
				else
					_shouldIncrement = true
				end
				if not (value <= chartMax) then
					break
				end
				local _value = value
				table.insert(gridValues, _value)
			end
		end
	end
	local _result_8
	if showXAxis then
		local _result_9 = xAxis
		if _result_9 ~= nil then
			_result_9 = _result_9.size
		end
		local _condition_2 = _result_9
		if _condition_2 == nil then
			_condition_2 = barTheme.xAxis.size
		end
		_result_8 = _condition_2
	else
		_result_8 = 0
	end
	local xAxisSize = _result_8
	local _result_9
	if showYAxis then
		local _result_10 = yAxis
		if _result_10 ~= nil then
			_result_10 = _result_10.size
		end
		local _condition_2 = _result_10
		if _condition_2 == nil then
			_condition_2 = barTheme.yAxis.size
		end
		_result_9 = _condition_2
	else
		_result_9 = 0
	end
	local yAxisSize = _result_9
	local _result_10 = xAxis
	if _result_10 ~= nil then
		_result_10 = _result_10.gap
	end
	local _condition_2 = _result_10
	if _condition_2 == nil then
		_condition_2 = SpacingHelper:GetPadding(theme, nil, barTheme.spacing)
	end
	local barSpacing = UDim.new(0, _condition_2)
	local _result_11 = xAxis
	if _result_11 ~= nil then
		_result_11 = _result_11.spacing
	end
	local _condition_3 = _result_11
	if _condition_3 == nil then
		_condition_3 = barTheme.xAxis.spacing
	end
	local xAxisSpacing = _condition_3
	local _result_12 = yAxis
	if _result_12 ~= nil then
		_result_12 = _result_12.spacing
	end
	local _condition_4 = _result_12
	if _condition_4 == nil then
		_condition_4 = barTheme.yAxis.spacing
	end
	local yAxisSpacing = _condition_4
	local _condition_5 = props.data.unstackedTransparency
	if _condition_5 == nil then
		_condition_5 = barTheme.unstackedTransparency
	end
	local unstackedTransparency = _condition_5
	local xLine = xAxis or {}
	local yLine = yAxis or {}
	local _gridStyle = yAxis
	if _gridStyle ~= nil then
		_gridStyle = _gridStyle.gridLines
	end
	local gridStyle = _gridStyle
	local getLineColor = function(style, fallback)
		return style.color or fallback.color or barTheme.axis.color
	end
	local getLineTransparency = function(style, fallback)
		local _condition_6 = style.transparency
		if _condition_6 == nil then
			_condition_6 = fallback.transparency
			if _condition_6 == nil then
				_condition_6 = barTheme.axis.transparency
			end
		end
		return _condition_6
	end
	local getLineThickness = function(style, fallback)
		local _condition_6 = style.thickness
		if _condition_6 == nil then
			_condition_6 = fallback.thickness
			if _condition_6 == nil then
				_condition_6 = barTheme.axis.thickness
			end
		end
		return _condition_6
	end
	local getYPosition = function(value)
		return (chartMax - value) / chartRange
	end
	local getBarColor = function(dataset, datasetIndex, valueIndex)
		if dataset.color ~= nil then
			return dataset.color
		end
		if dataset.colors ~= nil and dataset.colors[valueIndex + 1] ~= nil then
			return dataset.colors[valueIndex + 1]
		end
		if props.data.colors ~= nil and #props.data.colors > 0 then
			return props.data.colors[datasetIndex % #props.data.colors + 1]
		end
		return theme.components.charts.colors[datasetIndex % #theme.components.charts.colors + 1]
	end
	local getCombinedTooltip = function(index)
		local _exp_3 = props.data.datasets
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#_exp_3)
		local _callback_4 = function(dataset)
			local _condition_6 = dataset.values[index + 1]
			if _condition_6 == nil then
				_condition_6 = 0
			end
			local value = _condition_6
			local _result_13 = dataset.labels
			if _result_13 ~= nil then
				_result_13 = _result_13[index + 1]
			end
			local _condition_7 = _result_13
			if _condition_7 == nil then
				_condition_7 = props.data.labels[index + 1]
			end
			return `{_condition_7}: {value}`
		end
		for _k, _v in _exp_3 do
			_newValue_2[_k] = _callback_4(_v, _k - 1, _exp_3)
		end
		-- ▲ ReadonlyArray.map ▲
		return table.concat(_newValue_2, "\n")
	end
	local barCornerRadius = SizeHelper:toUDim(barTheme.cornerRadius)
	local animationProgress, animationTween = useTween(if barTheme.tweenTime > 0 then 0 else 1, {
		duration = barTheme.tweenTime,
		easing = "quadOut",
	})
	React.useEffect(function()
		if barTheme.tweenTime > 0 then
			animationTween:setGoal(1)
		end
	end, { animationTween, barTheme.tweenTime })
	local _attributes = {}
	local _condition_6 = props.name
	if _condition_6 == nil then
		_condition_6 = "BarChart"
	end
	_attributes.name = _condition_6
	_attributes.Size = UDim2.fromScale(1, 1)
	local _exp_3 = showYAxis and React.createElement(Container, {
		name = "YAxisContainer",
		Size = UDim2.new(0, yAxisSize, 1, -xAxisSize),
	}, React.createElement("frame", {
		key = "YAxisLine",
		Size = UDim2.new(0, getLineThickness(yLine, barTheme.axis), 1, 0),
		Position = UDim2.new(1, -yAxisSpacing, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = getLineColor(yLine, barTheme.axis),
		BackgroundTransparency = getLineTransparency(yLine, barTheme.axis),
	}))
	local _condition_7 = showYAxis and chartRange > 0
	if _condition_7 then
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#gridValues)
		local _callback_4 = function(value)
			local _attributes_1 = {
				key = "Tick",
			}
			local _result_13 = yAxis
			if _result_13 ~= nil then
				_result_13 = _result_13.tickSize
			end
			local _condition_8 = _result_13
			if _condition_8 == nil then
				_condition_8 = barTheme.yAxis.tickSize
			end
			local _result_14 = yAxis
			if _result_14 ~= nil then
				_result_14 = _result_14.tickThickness
			end
			local _condition_9 = _result_14
			if _condition_9 == nil then
				_condition_9 = barTheme.yAxis.tickThickness
			end
			_attributes_1.Size = UDim2.new(0, _condition_8, 0, _condition_9)
			_attributes_1.Position = UDim2.new(0, -yAxisSpacing, 0, 0)
			_attributes_1.AnchorPoint = Vector2.new(1, 0)
			_attributes_1.BorderSizePixel = 0
			local _result_15 = yAxis
			if _result_15 ~= nil then
				_result_15 = _result_15.tickColor
			end
			local _condition_10 = _result_15
			if _condition_10 == nil then
				_condition_10 = barTheme.yAxis.tickColor
			end
			_attributes_1.BackgroundColor3 = _condition_10
			local _result_16 = yAxis
			if _result_16 ~= nil then
				_result_16 = _result_16.tickTransparency
			end
			local _condition_11 = _result_16
			if _condition_11 == nil then
				_condition_11 = barTheme.yAxis.tickTransparency
			end
			_attributes_1.BackgroundTransparency = _condition_11
			return React.createElement("frame", {
				key = `GridLine-{value}`,
				Size = UDim2.new(1, 0, 0, getLineThickness(gridStyle or {}, barTheme.gridLines)),
				Position = UDim2.new(0, 0, getYPosition(value), 0),
				BorderSizePixel = 0,
				BackgroundColor3 = getLineColor(gridStyle or {}, barTheme.gridLines),
				BackgroundTransparency = getLineTransparency(gridStyle or {}, barTheme.gridLines),
			}, React.createElement("frame", _attributes_1), React.createElement(Text, {
				name = "GridLineLabel",
				text = `{value}`,
				TextWrap = false,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.new(0, -15 - yAxisSpacing, 0, 0),
			}))
		end
		for _k, _v in gridValues do
			_newValue_2[_k] = _callback_4(_v, _k - 1, gridValues)
		end
		-- ▲ ReadonlyArray.map ▲
		_condition_7 = _newValue_2
	end
	local _condition_8 = chartRange > 0
	if _condition_8 then
		local _exp_4 = props.data.labels
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#_exp_4)
		local _callback_4 = function(label, index)
			local _result_13
			if stacked then
				local _exp_5 = props.data.datasets
				-- ▼ ReadonlyArray.map ▼
				local _newValue_3 = table.create(#_exp_5)
				local _callback_5 = function(dataset, datasetIndex)
					local _condition_9 = dataset.values[index + 1]
					if _condition_9 == nil then
						_condition_9 = 0
					end
					local value = _condition_9
					local _result_14 = dataset.labels
					if _result_14 ~= nil then
						_result_14 = _result_14[index + 1]
					end
					local _condition_10 = _result_14
					if _condition_10 == nil then
						_condition_10 = label
					end
					local tooltipLabel = _condition_10
					local _exp_6 = props.data.datasets
					-- ▼ ReadonlyArray.reduce ▼
					local _result_15 = 0
					local _callback_6 = function(sum, previousDataset, previousIndex)
						if previousIndex >= datasetIndex then
							return sum
						end
						local _condition_11 = previousDataset.values[index + 1]
						if _condition_11 == nil then
							_condition_11 = 0
						end
						local previousValue = _condition_11
						return if (value >= 0) == (previousValue >= 0) then sum + previousValue else sum
					end
					for _i = 1, #_exp_6 do
						_result_15 = _callback_6(_result_15, _exp_6[_i], _i - 1, _exp_6)
					end
					-- ▲ ReadonlyArray.reduce ▲
					local start = _result_15
					local segmentEnd = start + value
					local top = math.max(start, segmentEnd)
					local _result_16
					if value > 0 then
						local _exp_7 = props.data.datasets
						-- ▼ ReadonlyArray.some ▼
						local _result_17 = false
						local _callback_7 = function(otherDataset, otherIndex)
							local _condition_11 = otherIndex > datasetIndex
							if _condition_11 then
								local _condition_12 = otherDataset.values[index + 1]
								if _condition_12 == nil then
									_condition_12 = 0
								end
								_condition_11 = _condition_12 > 0
							end
							return _condition_11
						end
						for _k, _v in _exp_7 do
							if _callback_7(_v, _k - 1, _exp_7) then
								_result_17 = true
								break
							end
						end
						-- ▲ ReadonlyArray.some ▲
						_result_16 = not _result_17
					else
						local _condition_11 = positiveSums[index + 1] <= 0 and value < 0
						if _condition_11 then
							local _exp_7 = props.data.datasets
							-- ▼ ReadonlyArray.some ▼
							local _result_17 = false
							local _callback_7 = function(otherDataset, otherIndex)
								local _condition_12 = otherIndex < datasetIndex
								if _condition_12 then
									local _condition_13 = otherDataset.values[index + 1]
									if _condition_13 == nil then
										_condition_13 = 0
									end
									_condition_12 = _condition_13 < 0
								end
								return _condition_12
							end
							for _k, _v in _exp_7 do
								if _callback_7(_v, _k - 1, _exp_7) then
									_result_17 = true
									break
								end
							end
							-- ▲ ReadonlyArray.some ▲
							_condition_11 = not _result_17
						end
						_result_16 = _condition_11
					end
					local isTopSegment = _result_16
					local segment = React.createElement(Container, {
						key = `Segment-{datasetIndex}`,
						name = `Segment-{datasetIndex}`,
						Size = animationProgress:map(function(progress)
							return UDim2.fromScale(1, math.abs(value) / chartRange * progress)
						end),
						Position = animationProgress:map(function(progress)
							return UDim2.fromScale(0, getYPosition(top * progress))
						end),
						BackgroundTransparency = 0,
						BackgroundColor3 = getBarColor(dataset, datasetIndex, index),
					}, React.createElement("uistroke", {
						key = "Stroke",
						Color = barTheme.borderColor,
						Thickness = barTheme.borderThickness,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					}), isTopSegment and React.createElement("uicorner", {
						key = "Corners",
						TopLeftRadius = barCornerRadius,
						TopRightRadius = barCornerRadius,
						BottomLeftRadius = UDim.new(0, 0),
						BottomRightRadius = UDim.new(0, 0),
					}))
					return if combinedTooltips then segment else React.createElement(Tooltip, {
						content = `{tooltipLabel}: {value}`,
						placement = "Center",
					}, segment)
				end
				for _k, _v in _exp_5 do
					_newValue_3[_k] = _callback_5(_v, _k - 1, _exp_5)
				end
				-- ▲ ReadonlyArray.map ▲
				_result_13 = React.createElement(Container, {
					name = "StackedBar",
					Size = UDim2.fromScale(1, 1),
				}, _newValue_3, combinedTooltips and React.createElement(Tooltip, {
					content = getCombinedTooltip(index),
					placement = "Center",
				}, React.createElement(Container, {
					name = "CombinedTooltipTarget",
					Size = animationProgress:map(function(progress)
						return UDim2.fromScale(1, (positiveExtents[index + 1] - negativeExtents[index + 1]) / chartRange * progress)
					end),
					Position = animationProgress:map(function(progress)
						return UDim2.fromScale(0, getYPosition(positiveExtents[index + 1] * progress))
					end),
					BackgroundTransparency = 1,
				})))
			else
				local _exp_5 = props.data.datasets
				-- ▼ ReadonlyArray.map ▼
				local _newValue_3 = table.create(#_exp_5)
				local _callback_5 = function(dataset, datasetIndex)
					local _condition_9 = dataset.values[index + 1]
					if _condition_9 == nil then
						_condition_9 = 0
					end
					local value = _condition_9
					local _result_14 = dataset.labels
					if _result_14 ~= nil then
						_result_14 = _result_14[index + 1]
					end
					local _condition_10 = _result_14
					if _condition_10 == nil then
						_condition_10 = label
					end
					local tooltipLabel = _condition_10
					local magnitude = math.abs(value)
					local _exp_6 = props.data.datasets
					-- ▼ ReadonlyArray.some ▼
					local _result_15 = false
					local _callback_6 = function(otherDataset, otherIndex)
						local _condition_11 = otherIndex > datasetIndex
						if _condition_11 then
							local _condition_12 = otherDataset.values[index + 1]
							if _condition_12 == nil then
								_condition_12 = 0
							end
							_condition_11 = _condition_12 == value
						end
						return _condition_11
					end
					for _k, _v in _exp_6 do
						if _callback_6(_v, _k - 1, _exp_6) then
							_result_15 = true
							break
						end
					end
					-- ▲ ReadonlyArray.some ▲
					local hasLaterEqualValue = _result_15
					if magnitude == 0 or hasLaterEqualValue then
						return nil
					end
					local _exp_7 = props.data.datasets
					-- ▼ ReadonlyArray.reduce ▼
					local _result_16 = 0
					local _callback_7 = function(covered, otherDataset)
						local _condition_11 = otherDataset.values[index + 1]
						if _condition_11 == nil then
							_condition_11 = 0
						end
						local otherValue = _condition_11
						local otherMagnitude = math.abs(otherValue)
						local sameDirection = (value >= 0) == (otherValue >= 0)
						return if sameDirection and otherMagnitude < magnitude then math.max(covered, otherMagnitude) else covered
					end
					for _i = 1, #_exp_7 do
						_result_16 = _callback_7(_result_16, _exp_7[_i], _i - 1, _exp_7)
					end
					-- ▲ ReadonlyArray.reduce ▲
					local coveredMagnitude = _result_16
					local visibleMagnitude = magnitude - coveredMagnitude
					local _exp_8 = props.data.datasets
					-- ▼ ReadonlyArray.filter ▼
					local _newValue_4 = {}
					local _callback_8 = function(otherDataset)
						local _condition_11 = otherDataset.values[index + 1]
						if _condition_11 == nil then
							_condition_11 = 0
						end
						return math.abs(_condition_11) > magnitude
					end
					local _length = 0
					for _k, _v in _exp_8 do
						if _callback_8(_v, _k - 1, _exp_8) == true then
							_length += 1
							_newValue_4[_length] = _v
						end
					end
					-- ▲ ReadonlyArray.filter ▲
					local zIndex = #_newValue_4
					local top = if value >= 0 then value else -coveredMagnitude
					local _exp_9 = props.data.datasets
					-- ▼ ReadonlyArray.some ▼
					local _result_17 = false
					local _callback_9 = function(otherDataset)
						local _condition_11 = otherDataset.values[index + 1]
						if _condition_11 == nil then
							_condition_11 = 0
						end
						local otherValue = _condition_11
						return (value >= 0) == (otherValue >= 0) and math.abs(otherValue) > magnitude
					end
					for _k, _v in _exp_9 do
						if _callback_9(_v, _k - 1, _exp_9) then
							_result_17 = true
							break
						end
					end
					-- ▲ ReadonlyArray.some ▲
					local isTallest = not _result_17
					local visibleSection = React.createElement(Container, {
						key = `Segment-{datasetIndex}`,
						name = `Segment-{datasetIndex}`,
						Size = animationProgress:map(function(progress)
							return UDim2.fromScale(1, visibleMagnitude / chartRange * progress)
						end),
						Position = animationProgress:map(function(progress)
							return UDim2.fromScale(0, getYPosition(top * progress))
						end),
						ZIndex = zIndex,
						BackgroundTransparency = unstackedTransparency,
						BackgroundColor3 = getBarColor(dataset, datasetIndex, index),
					}, React.createElement("uistroke", {
						key = "Stroke",
						Color = barTheme.borderColor,
						Thickness = barTheme.borderThickness,
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
					}), isTallest and React.createElement("uicorner", {
						key = "Corners",
						TopLeftRadius = barCornerRadius,
						TopRightRadius = barCornerRadius,
						BottomLeftRadius = UDim.new(0, 0),
						BottomRightRadius = UDim.new(0, 0),
					}))
					return if combinedTooltips then visibleSection else React.createElement(Tooltip, {
						content = `{tooltipLabel}: {value}`,
						placement = "Center",
					}, visibleSection)
				end
				for _k, _v in _exp_5 do
					_newValue_3[_k] = _callback_5(_v, _k - 1, _exp_5)
				end
				-- ▲ ReadonlyArray.map ▲
				_result_13 = React.createElement(Container, {
					name = "UnstackedBar",
					Size = UDim2.fromScale(1, 1),
				}, _newValue_3, combinedTooltips and React.createElement(Tooltip, {
					content = getCombinedTooltip(index),
					placement = "Center",
				}, React.createElement(Container, {
					name = "CombinedTooltipTarget",
					Size = animationProgress:map(function(progress)
						return UDim2.fromScale(1, (positiveExtents[index + 1] - negativeExtents[index + 1]) / chartRange * progress)
					end),
					Position = animationProgress:map(function(progress)
						return UDim2.fromScale(0, getYPosition(positiveExtents[index + 1] * progress))
					end),
					BackgroundTransparency = 1,
				})))
			end
			return React.createElement(Container, {
				key = `BarGroup-{index}`,
				name = `BarGroup-{index}`,
				Size = UDim2.fromScale(0, 1),
			}, _result_13)
		end
		for _k, _v in _exp_4 do
			_newValue_2[_k] = _callback_4(_v, _k - 1, _exp_4)
		end
		-- ▲ ReadonlyArray.map ▲
		_condition_8 = React.createElement(Container, {
			name = "BarsContainer",
			Size = UDim2.fromScale(1, 1),
		}, React.createElement(HStack, {
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			valign = "Bottom",
			Padding = barSpacing,
		}, _newValue_2))
	end
	local _exp_4 = React.createElement(Container, {
		name = "ChartArea",
		Size = UDim2.new(1, 0, 1, -xAxisSize),
	}, _condition_7, _condition_8)
	local _condition_9 = showXAxis
	if _condition_9 then
		local _exp_5 = React.createElement("frame", {
			key = "XAxisLine",
			Size = UDim2.new(1, 0, 0, getLineThickness(xLine, barTheme.axis)),
			Position = UDim2.new(0, 0, 0, xAxisSpacing),
			BorderSizePixel = 0,
			BackgroundColor3 = getLineColor(xLine, barTheme.axis),
			BackgroundTransparency = getLineTransparency(xLine, barTheme.axis),
		})
		local _exp_6 = props.data.labels
		-- ▼ ReadonlyArray.map ▼
		local _newValue_2 = table.create(#_exp_6)
		local _callback_4 = function(label, index)
			local _attributes_1 = {
				key = "Tick",
			}
			local _result_13 = xAxis
			if _result_13 ~= nil then
				_result_13 = _result_13.tickThickness
			end
			local _condition_10 = _result_13
			if _condition_10 == nil then
				_condition_10 = barTheme.xAxis.tickThickness
			end
			local _result_14 = xAxis
			if _result_14 ~= nil then
				_result_14 = _result_14.tickSize
			end
			local _condition_11 = _result_14
			if _condition_11 == nil then
				_condition_11 = barTheme.xAxis.tickSize
			end
			_attributes_1.Size = UDim2.new(0, _condition_10, 0, _condition_11)
			_attributes_1.Position = UDim2.new(0.5, 0, 0, xAxisSpacing)
			_attributes_1.AnchorPoint = Vector2.new(0.5, 0)
			_attributes_1.BorderSizePixel = 0
			local _result_15 = xAxis
			if _result_15 ~= nil then
				_result_15 = _result_15.tickColor
			end
			local _condition_12 = _result_15
			if _condition_12 == nil then
				_condition_12 = barTheme.xAxis.tickColor
			end
			_attributes_1.BackgroundColor3 = _condition_12
			local _result_16 = xAxis
			if _result_16 ~= nil then
				_result_16 = _result_16.tickTransparency
			end
			local _condition_13 = _result_16
			if _condition_13 == nil then
				_condition_13 = barTheme.xAxis.tickTransparency
			end
			_attributes_1.BackgroundTransparency = _condition_13
			return React.createElement(Container, {
				key = `XAxisTick-{index}`,
				name = `XAxisTick-{index}`,
				Size = UDim2.fromScale(0, 1),
			}, React.createElement("frame", _attributes_1), React.createElement(Container, {
				name = "XAxisLabel",
				center = true,
			}, React.createElement(Text, {
				name = "XAxisLabelText",
				text = label,
				TextWrapped = false,
			})))
		end
		for _k, _v in _exp_6 do
			_newValue_2[_k] = _callback_4(_v, _k - 1, _exp_6)
		end
		-- ▲ ReadonlyArray.map ▲
		_condition_9 = React.createElement(Container, {
			name = "XAxisContainer",
			Size = UDim2.new(1, 0, 0, xAxisSize),
		}, _exp_5, React.createElement(Container, {
			name = "XAxisLabels",
			Size = UDim2.fromScale(1, 1),
		}, React.createElement(HStack, {
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			Padding = barSpacing,
		}, _newValue_2)))
	end
	return React.createElement(Container, _attributes, React.createElement(HStack, {
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		spacing = "None",
	}, _exp_3, React.createElement(Container, {
		name = "PlotArea",
		Size = UDim2.new(1, -yAxisSize, 1, 0),
	}, React.createElement(VStack, {
		spacing = "None",
	}, _exp_4, _condition_9))))
end
return {
	BarChart = BarChart,
}
