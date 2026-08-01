-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Layout = TS.import(script, script.Parent.Parent, "Layout")
local Container = _Layout.Container
local HStack = _Layout.HStack
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Tooltip = TS.import(script, script.Parent.Parent, "Interaction").Tooltip
local function BarChart(props)
	local theme = React.useContext(CleanThemeContext)
	local _exp = props.data.datasets
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp)
	local _callback = function(dataset)
		local _exp_1 = dataset.values
		-- ▼ ReadonlyArray.reduce ▼
		if #_exp_1 == 0 then
			error("Attempted to call `ReadonlyArray.reduce()` on an empty array without an initialValue.")
		end
		local _result = _exp_1[1]
		local _callback_1 = function(max, value)
			return math.max(max, value)
		end
		for _i = 2, #_exp_1 do
			_result = _callback_1(_result, _exp_1[_i], _i - 1, _exp_1)
		end
		-- ▲ ReadonlyArray.reduce ▲
		local max = _result
		local _exp_2 = dataset.values
		-- ▼ ReadonlyArray.reduce ▼
		local _result_1 = 0
		local _callback_2 = function(sum, value)
			return sum + value
		end
		for _i = 1, #_exp_2 do
			_result_1 = _callback_2(_result_1, _exp_2[_i], _i - 1, _exp_2)
		end
		-- ▲ ReadonlyArray.reduce ▲
		local total = _result_1
		local _exp_3 = dataset.values
		-- ▼ ReadonlyArray.map ▼
		local _newValue_1 = table.create(#_exp_3)
		local _callback_3 = function(value, index)
			local _attributes = {}
			local _condition = props.data.labels[index + 1]
			if _condition == nil then
				_condition = ""
			end
			_attributes.content = `{_condition}: {value}`
			_attributes.placement = "Center"
			return React.createElement(Tooltip, _attributes, React.createElement(Container, {
				BackgroundTransparency = 0,
				Size = UDim2.fromScale(0, value / max),
				BackgroundColor3 = theme.components.charts.colors[index % #theme.components.charts.colors + 1],
			}))
		end
		for _k, _v in _exp_3 do
			_newValue_1[_k] = _callback_3(_v, _k - 1, _exp_3)
		end
		-- ▲ ReadonlyArray.map ▲
		return _newValue_1
	end
	for _k, _v in _exp do
		_newValue[_k] = _callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(Container, {
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		HorizontalFlex = Enum.UIFlexAlignment.Fill,
		valign = "Bottom",
	}, _newValue))
end
return {
	BarChart = BarChart,
}
