-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local BarChart = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Chart", "BarChart").BarChart
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local VALUES = { 10, 30, 20 }
local MAX_INDEX = 1
local DATA = {
	labels = { "A", "B", "C" },
	datasets = { {
		values = VALUES,
	} },
}
local function waitForBarsToSettle(host)
	local barsContainer = waitForGuiObject(host, "BarsContainer")
	task.wait(DefaultTheme.components.charts.bar.tweenTime + 0.25)
	waitForGuiObject(findDescendant(barsContainer, `BarGroup-{MAX_INDEX}`), "Segment-0", function(segment)
		return math.abs(segment.AbsoluteSize.Y - barsContainer.AbsoluteSize.Y) <= 1
	end, "Timed out waiting for the max-value bar to finish its mount animation and fill the chart height")
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#VALUES)
	local _callback = function(_, index)
		return findDescendant(findDescendant(barsContainer, `BarGroup-{index}`), "Segment-0")
	end
	for _k, _v in VALUES do
		_newValue[_k] = _callback(_v, _k - 1, VALUES)
	end
	-- ▲ ReadonlyArray.map ▲
	local bars = _newValue
	return {
		barsContainer = barsContainer,
		bars = bars,
	}
end
local BarChartMountValidation
do
	BarChartMountValidation = setmetatable({}, {
		__tostring = function()
			return "BarChartMountValidation"
		end,
	})
	BarChartMountValidation.__index = BarChartMountValidation
	function BarChartMountValidation.new(...)
		local self = setmetatable({}, BarChartMountValidation)
		return self:constructor(...) or self
	end
	function BarChartMountValidation:constructor()
	end
	function BarChartMountValidation:oneBarPerDataPoint()
		withMounted(400, 300, React.createElement(BarChart, {
			data = DATA,
		}), function(mounted)
			local barsContainer = waitForGuiObject(mounted.host, "BarsContainer")
			for index = 0, #VALUES - 1 do
				local group = findDescendant(barsContainer, `BarGroup-{index}`)
				findDescendant(group, "Segment-0")
			end
			Assert:undefined(barsContainer:FindFirstChild(`BarGroup-{#VALUES}`, true), `Expected no BarGroup-{#VALUES} for a chart with {#VALUES} labels`)
		end)
	end
	function BarChartMountValidation:tallestBarMatchesMax()
		withMounted(400, 300, React.createElement(BarChart, {
			data = DATA,
		}), function(mounted)
			local _binding_1 = waitForBarsToSettle(mounted.host)
			local barsContainer = _binding_1.barsContainer
			local bars = _binding_1.bars
			local maxBar = bars[MAX_INDEX + 1]
			Assert:approximately(rect(maxBar).height, rect(barsContainer).height, 1)
			for index = 0, #bars - 1 do
				if index == MAX_INDEX then
					continue
				end
				Assert:greaterThan(rect(maxBar).height, rect(bars[index + 1]).height, `Expected the max-value bar (value {VALUES[MAX_INDEX + 1]}) to be taller than the bar for value {VALUES[index + 1]}`)
			end
		end)
	end
	function BarChartMountValidation:barsContainedAndOrdered()
		withMounted(400, 300, React.createElement(BarChart, {
			data = DATA,
		}), function(mounted)
			local _binding_1 = waitForBarsToSettle(mounted.host)
			local barsContainer = _binding_1.barsContainer
			local bars = _binding_1.bars
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#VALUES)
			local _callback = function(_, index)
				return findDescendant(barsContainer, `BarGroup-{index}`)
			end
			for _k, _v in VALUES do
				_newValue[_k] = _callback(_v, _k - 1, VALUES)
			end
			-- ▲ ReadonlyArray.map ▲
			local groups = _newValue
			for index = 0, #groups - 1 do
				assertContained(groups[index + 1], barsContainer, `bar group {index}`)
				assertContained(bars[index + 1], barsContainer, `bar segment {index}`)
			end
			assertStackedHorizontally(groups, "bar groups")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Renders exactly one BarGroup (each with a Segment-0) per label in the data")
	local _descriptor = Test(BarChartMountValidation, "oneBarPerDataPoint", {
		value = BarChartMountValidation.oneBarPerDataPoint,
	})
	if _descriptor then
		BarChartMountValidation.oneBarPerDataPoint = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BarChartMountValidation, "oneBarPerDataPoint", {
		value = BarChartMountValidation.oneBarPerDataPoint,
	})
	if _descriptor_1 then
		BarChartMountValidation.oneBarPerDataPoint = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BarChartMountValidation, "oneBarPerDataPoint", {
		value = BarChartMountValidation.oneBarPerDataPoint,
	})
	if _descriptor_2 then
		BarChartMountValidation.oneBarPerDataPoint = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("After the mount animation, the bar for the maximum value is the tallest and fills the chart height")
	local _descriptor_3 = Test(BarChartMountValidation, "tallestBarMatchesMax", {
		value = BarChartMountValidation.tallestBarMatchesMax,
	})
	if _descriptor_3 then
		BarChartMountValidation.tallestBarMatchesMax = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(BarChartMountValidation, "tallestBarMatchesMax", {
		value = BarChartMountValidation.tallestBarMatchesMax,
	})
	if _descriptor_4 then
		BarChartMountValidation.tallestBarMatchesMax = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(BarChartMountValidation, "tallestBarMatchesMax", {
		value = BarChartMountValidation.tallestBarMatchesMax,
	})
	if _descriptor_5 then
		BarChartMountValidation.tallestBarMatchesMax = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Bar groups stay inside the BarsContainer and are laid out left-to-right in data order")
	local _descriptor_6 = Test(BarChartMountValidation, "barsContainedAndOrdered", {
		value = BarChartMountValidation.barsContainedAndOrdered,
	})
	if _descriptor_6 then
		BarChartMountValidation.barsContainedAndOrdered = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(BarChartMountValidation, "barsContainedAndOrdered", {
		value = BarChartMountValidation.barsContainedAndOrdered,
	})
	if _descriptor_7 then
		BarChartMountValidation.barsContainedAndOrdered = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(BarChartMountValidation, "barsContainedAndOrdered", {
		value = BarChartMountValidation.barsContainedAndOrdered,
	})
	if _descriptor_8 then
		BarChartMountValidation.barsContainedAndOrdered = _descriptor_8.value
	end
	BarChartMountValidation = Tag("Studio")(BarChartMountValidation) or BarChartMountValidation
end
return BarChartMountValidation
