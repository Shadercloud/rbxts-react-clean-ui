-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local HStack = _Layout.HStack
local VStack = _Layout.VStack
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Tooltip = TS.import(script, script.Parent.Parent, "Interaction").Tooltip
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local function niceStep(max, targetTicks)
	if targetTicks == nil then
		targetTicks = 5
	end
	if targetTicks <= 0 then
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
	local _exp = props.data.labels
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp)
	local _callback = function(_, index)
		local _exp_1 = props.data.datasets
		-- ▼ ReadonlyArray.reduce ▼
		local _result = 0
		local _callback_1 = function(sum, dataset)
			local _exp_2 = sum
			local _condition = dataset.values[index + 1]
			if _condition == nil then
				_condition = 0
			end
			return _exp_2 + _condition
		end
		for _i = 1, #_exp_1 do
			_result = _callback_1(_result, _exp_1[_i], _i - 1, _exp_1)
		end
		-- ▲ ReadonlyArray.reduce ▲
		return _result
	end
	for _k, _v in _exp do
		_newValue[_k] = _callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.map ▲
	local sumValues = _newValue
	-- ▼ ReadonlyArray.reduce ▼
	local _result = 0
	local _callback_1 = function(max, value)
		return math.max(max, value)
	end
	for _i = 1, #sumValues do
		_result = _callback_1(_result, sumValues[_i], _i - 1, sumValues)
	end
	-- ▲ ReadonlyArray.reduce ▲
	local max = _result
	local _result_1 = props.data.yAxis
	if _result_1 ~= nil then
		_result_1 = _result_1.ticks
	end
	local step = niceStep(max, _result_1)
	local chartMax = if step > 0 then math.ceil(max / step) * step else max
	local gridValues = {}
	if step > 0 then
		do
			local value = 0
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
	local labelHeight = 50
	local xLabelWidth = 50
	local axisLineSpace = 5
	local axisTickThickness = 2
	local barSpacing = UDim.new(0, 8)
	local tickSize = 10
	local _exp_1 = React.createElement(Container, {
		Size = UDim2.new(0, xLabelWidth, 1, -labelHeight),
	}, React.createElement("frame", {
		Size = UDim2.new(0, theme.components.charts.bar.axis.thickness, 1, 0),
		Position = UDim2.new(1, -axisLineSpace, 0, 0),
		AnchorPoint = Vector2.new(1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = theme.components.charts.bar.axis.color,
		BackgroundTransparency = theme.components.charts.bar.axis.transparency,
	}))
	-- ▼ ReadonlyArray.map ▼
	local _newValue_1 = table.create(#gridValues)
	local _callback_2 = function(g, gi)
		return React.createElement("frame", {
			Size = UDim2.new(1, axisLineSpace, 0, 2),
			Position = UDim2.new(1, 0, 1 - (g / chartMax), 0),
			AnchorPoint = Vector2.new(1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.components.charts.bar.axis.color,
			BackgroundTransparency = 0.8,
		}, React.createElement("frame", {
			Size = UDim2.new(0, tickSize, 1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.components.charts.bar.axis.color,
			BackgroundTransparency = theme.components.charts.bar.axis.transparency,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(1, 0),
		}), React.createElement(Text, {
			text = `{g}`,
			TextWrap = false,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(0, -15, 0, 0),
		}))
	end
	for _k, _v in gridValues do
		_newValue_1[_k] = _callback_2(_v, _k - 1, gridValues)
	end
	-- ▲ ReadonlyArray.map ▲
	local _exp_2 = props.data.labels
	-- ▼ ReadonlyArray.map ▼
	local _newValue_2 = table.create(#_exp_2)
	local _callback_3 = function(label, index)
		local _exp_3 = props.data.datasets
		-- ▼ ReadonlyArray.map ▼
		local _newValue_3 = table.create(#_exp_3)
		local _callback_4 = function(dataset)
			local _condition = dataset.values[index + 1]
			if _condition == nil then
				_condition = 0
			end
			return _condition
		end
		for _k, _v in _exp_3 do
			_newValue_3[_k] = _callback_4(_v, _k - 1, _exp_3)
		end
		-- ▲ ReadonlyArray.map ▲
		local values = _newValue_3
		-- const total = values.reduce((sum, value) => sum + value, 0);
		-- ▼ ReadonlyArray.map ▼
		local _newValue_4 = table.create(#values)
		local _callback_5 = function(value, datasetIndex)
			return React.createElement(Tooltip, {
				content = `{label}: {value}`,
				placement = "Center",
			}, React.createElement(Container, {
				LayoutOrder = 1000 - datasetIndex,
				Size = UDim2.fromScale(1, value / chartMax),
				BackgroundTransparency = 0,
				BackgroundColor3 = theme.components.charts.colors[datasetIndex % #theme.components.charts.colors + 1],
			}))
		end
		for _k, _v in values do
			_newValue_4[_k] = _callback_5(_v, _k - 1, values)
		end
		-- ▲ ReadonlyArray.map ▲
		return React.createElement(Container, {
			Size = UDim2.fromScale(0, 1),
		}, React.createElement(VStack, {
			VerticalFlex = Enum.UIFlexAlignment.None,
			valign = "Bottom",
			spacing = "None",
		}, _newValue_4))
	end
	for _k, _v in _exp_2 do
		_newValue_2[_k] = _callback_3(_v, _k - 1, _exp_2)
	end
	-- ▲ ReadonlyArray.map ▲
	local _exp_3 = React.createElement(Container, {
		Size = UDim2.new(1, 0, 1, -labelHeight),
	}, _newValue_1, React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		valign = "Bottom",
		Padding = barSpacing,
	}, _newValue_2)))
	local _exp_4 = React.createElement("uipadding", {
		PaddingTop = UDim.new(0, axisLineSpace),
	})
	local _exp_5 = React.createElement("frame", {
		Size = UDim2.new(1, 0, 0, theme.components.charts.bar.axis.thickness),
		BorderSizePixel = 0,
		BackgroundColor3 = theme.components.charts.bar.axis.color,
		BackgroundTransparency = theme.components.charts.bar.axis.transparency,
	})
	local _exp_6 = props.data.labels
	-- ▼ ReadonlyArray.map ▼
	local _newValue_3 = table.create(#_exp_6)
	local _callback_4 = function(label, index)
		return React.createElement(Container, {
			Size = UDim2.fromScale(0, 1),
		}, index == 0 and React.createElement("frame", {
			Position = UDim2.fromOffset(0, axisTickThickness),
			Size = UDim2.fromOffset(axisTickThickness, tickSize),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.components.charts.bar.axis.color,
			BackgroundTransparency = theme.components.charts.bar.axis.transparency,
		}), React.createElement("frame", {
			Size = UDim2.fromOffset(axisTickThickness, tickSize),
			Position = if index >= #label + 1 then UDim2.new(1, 0, 0, axisTickThickness) else UDim2.new(1, math.ceil((barSpacing.Offset / 2) + (axisTickThickness / 2)), 0, axisTickThickness),
			AnchorPoint = Vector2.new(1, 0),
			BorderSizePixel = 0,
			BackgroundColor3 = theme.components.charts.bar.axis.color,
			BackgroundTransparency = theme.components.charts.bar.axis.transparency,
		}), React.createElement(Container, {
			center = true,
		}, React.createElement(Text, {
			text = label,
			TextWrapped = false,
		})))
	end
	for _k, _v in _exp_6 do
		_newValue_3[_k] = _callback_4(_v, _k - 1, _exp_6)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		spacing = "None",
	}, _exp_1, React.createElement(Container, {
		Size = UDim2.new(1, -xLabelWidth, 1, 0),
	}, React.createElement(VStack, {
		spacing = "None",
	}, _exp_3, React.createElement(Container, {
		Size = UDim2.new(1, 0, 0, labelHeight),
	}, _exp_4, _exp_5, React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		Padding = barSpacing,
	}, _newValue_3)))))))
end
return {
	BarChart = BarChart,
}
