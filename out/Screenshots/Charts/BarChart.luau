-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _index = TS.import(script, script.Parent.Parent.Parent)
local BarChart = _index.BarChart
local Container = _index.Container
local function BarChartScreenshot()
	return React.createElement(Container, {
		center = true,
		width = 600,
		height = 350,
	}, React.createElement(BarChart, {
		data = {
			labels = { "Alpha", "Beta", "Gamma", "Delta" },
			datasets = { {
				values = { 7, 4, 6, 5 },
			}, {
				values = { 2, 3, 1, 2 },
			} },
		},
	}))
end
return BarChartScreenshot
