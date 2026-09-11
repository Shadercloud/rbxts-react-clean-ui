-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local Row = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Row").Row
local Column = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Column").Column
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 600
local HOST_HEIGHT = 300
local DEFAULT_GAP = 12
local function column(name, span)
	return React.createElement(Column, {
		name = name,
		span = span,
	}, React.createElement("frame", {
		key = `{name}Content`,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 40),
	}))
end
local function expectedColumnWidth(rowWidth, span, gap)
	local fraction = math.floor((span / 12) * 1000) / 1000
	return fraction * rowWidth + (fraction - 1) * gap
end
local function waitForRow(host)
	return waitForGuiObject(host, "Row")
end
local RowMountValidation
do
	RowMountValidation = setmetatable({}, {
		__tostring = function()
			return "RowMountValidation"
		end,
	})
	RowMountValidation.__index = RowMountValidation
	function RowMountValidation.new(...)
		local self = setmetatable({}, RowMountValidation)
		return self:constructor(...) or self
	end
	function RowMountValidation:constructor()
	end
	function RowMountValidation:columnsInOrder()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Row, nil, column("First"), column("Second"), column("Third")), function(mounted)
			local row = waitForRow(mounted.host)
			local first = waitForGuiObject(row, "First")
			local second = findDescendant(row, "Second")
			local third = findDescendant(row, "Third")
			assertAlignedLeft(first, row, 1, "row order")
			assertStackedHorizontally({ first, second, third }, "row order")
		end)
	end
	function RowMountValidation:equalSplitWithoutSpan()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Row, nil, column("First"), column("Second"), column("Third")), function(mounted)
			local row = waitForRow(mounted.host)
			local expected = expectedColumnWidth(HOST_WIDTH, 4, DEFAULT_GAP)
			for _, name in { "First", "Second", "Third" } do
				local col = waitForGuiObject(row, name)
				assertSizeApprox(col, expected, nil, 1, `equal split {name}`)
			end
		end)
	end
	function RowMountValidation:spansSizeColumns(leftSpan, rightSpan)
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Row, nil, column("Left", leftSpan), column("Right", rightSpan)), function(mounted)
			local row = waitForRow(mounted.host)
			local left = waitForGuiObject(row, "Left")
			local right = waitForGuiObject(row, "Right")
			assertSizeApprox(left, expectedColumnWidth(HOST_WIDTH, leftSpan, DEFAULT_GAP), nil, 1, `span {leftSpan}`)
			assertSizeApprox(right, expectedColumnWidth(HOST_WIDTH, rightSpan, DEFAULT_GAP), nil, 1, `span {rightSpan}`)
			assertStackedHorizontally({ left, right }, `spans {leftSpan}+{rightSpan}`)
			assertContained(right, row, `spans {leftSpan}+{rightSpan}`)
		end)
	end
	function RowMountValidation:responsiveSpanFollowsWidth()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Row, nil, column("Responsive", {
			xs = 12,
			md = 6,
		})), function(mounted)
			local row = waitForRow(mounted.host)
			local wideExpected = expectedColumnWidth(HOST_WIDTH, 6, DEFAULT_GAP)
			local col = waitForGuiObject(row, "Responsive", function(gui)
				return math.abs(gui.AbsoluteSize.X - wideExpected) <= 1
			end, `Timed out waiting for the responsive Column to resolve md=6 at {HOST_WIDTH}px`)
			assertSizeApprox(col, wideExpected, nil, 1, "responsive span at 600px")
			mounted.resize(250, HOST_HEIGHT)
			local narrowExpected = expectedColumnWidth(250, 12, DEFAULT_GAP)
			waitForGuiObject(row, "Responsive", function(gui)
				return math.abs(gui.AbsoluteSize.X - narrowExpected) <= 1
			end, "Timed out waiting for the responsive Column to resolve xs=12 at 250px")
			assertSizeApprox(col, narrowExpected, nil, 1, "responsive span at 250px")
		end)
	end
	function RowMountValidation:allContained()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Row, nil, column("First", 4), column("Second", 4), column("Third", 4)), function(mounted)
			local row = waitForRow(mounted.host)
			waitForGuiObject(row, "Third")
			assertAllDescendantsContained(row, "row columns")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Columns are laid out left-to-right in JSX order, starting at the Row's left edge")
	local _descriptor = Test(RowMountValidation, "columnsInOrder", {
		value = RowMountValidation.columnsInOrder,
	})
	if _descriptor then
		RowMountValidation.columnsInOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(RowMountValidation, "columnsInOrder", {
		value = RowMountValidation.columnsInOrder,
	})
	if _descriptor_1 then
		RowMountValidation.columnsInOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(RowMountValidation, "columnsInOrder", {
		value = RowMountValidation.columnsInOrder,
	})
	if _descriptor_2 then
		RowMountValidation.columnsInOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Three Columns without a span each take a third of the Row, less their share of the default gap")
	local _descriptor_3 = Test(RowMountValidation, "equalSplitWithoutSpan", {
		value = RowMountValidation.equalSplitWithoutSpan,
	})
	if _descriptor_3 then
		RowMountValidation.equalSplitWithoutSpan = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(RowMountValidation, "equalSplitWithoutSpan", {
		value = RowMountValidation.equalSplitWithoutSpan,
	})
	if _descriptor_4 then
		RowMountValidation.equalSplitWithoutSpan = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(RowMountValidation, "equalSplitWithoutSpan", {
		value = RowMountValidation.equalSplitWithoutSpan,
	})
	if _descriptor_5 then
		RowMountValidation.equalSplitWithoutSpan = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = Each({ { 4, 8 }, { 3, 9 } })
	local _decorator_6 = DisplayName("Explicit spans that sum to 12 size each Column by span/12 and keep both on one line inside the Row")
	local _descriptor_6 = Test(RowMountValidation, "spansSizeColumns", {
		value = RowMountValidation.spansSizeColumns,
	})
	if _descriptor_6 then
		RowMountValidation.spansSizeColumns = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(RowMountValidation, "spansSizeColumns", {
		value = RowMountValidation.spansSizeColumns,
	})
	if _descriptor_7 then
		RowMountValidation.spansSizeColumns = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(RowMountValidation, "spansSizeColumns", {
		value = RowMountValidation.spansSizeColumns,
	})
	if _descriptor_8 then
		RowMountValidation.spansSizeColumns = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(RowMountValidation, "spansSizeColumns", {
		value = RowMountValidation.spansSizeColumns,
	})
	if _descriptor_9 then
		RowMountValidation.spansSizeColumns = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("A responsive span re-resolves against the Row's breakpoint when the host narrows from 600px to 250px")
	local _descriptor_10 = Test(RowMountValidation, "responsiveSpanFollowsWidth", {
		value = RowMountValidation.responsiveSpanFollowsWidth,
	})
	if _descriptor_10 then
		RowMountValidation.responsiveSpanFollowsWidth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(RowMountValidation, "responsiveSpanFollowsWidth", {
		value = RowMountValidation.responsiveSpanFollowsWidth,
	})
	if _descriptor_11 then
		RowMountValidation.responsiveSpanFollowsWidth = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(RowMountValidation, "responsiveSpanFollowsWidth", {
		value = RowMountValidation.responsiveSpanFollowsWidth,
	})
	if _descriptor_12 then
		RowMountValidation.responsiveSpanFollowsWidth = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Every visible Column and its content stays inside the Row")
	local _descriptor_13 = Test(RowMountValidation, "allContained", {
		value = RowMountValidation.allContained,
	})
	if _descriptor_13 then
		RowMountValidation.allContained = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(RowMountValidation, "allContained", {
		value = RowMountValidation.allContained,
	})
	if _descriptor_14 then
		RowMountValidation.allContained = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(RowMountValidation, "allContained", {
		value = RowMountValidation.allContained,
	})
	if _descriptor_15 then
		RowMountValidation.allContained = _descriptor_15.value
	end
	RowMountValidation = Tag("Studio")(RowMountValidation) or RowMountValidation
end
return RowMountValidation
