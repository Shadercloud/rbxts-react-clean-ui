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
local Table = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Table").Table
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedVertically = _layout.assertStackedVertically
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local COLUMN_COUNT = 3
local BODY_ROW_COUNT = 2
local function tableFixture(width)
	return React.createElement(Table, {
		width = width,
	}, React.createElement(Table.Header, nil, React.createElement(Table.Row, nil, React.createElement(Table.Head, {
		text = "Name",
	}), React.createElement(Table.Head, {
		text = "Role",
	}), React.createElement(Table.Head, {
		text = "Score",
	}))), React.createElement(Table.Body, nil, React.createElement(Table.Row, nil, React.createElement(Table.Cell, {
		text = "Alice",
	}), React.createElement(Table.Cell, {
		text = "Engineer",
	}), React.createElement(Table.Cell, {
		text = "92",
	})), React.createElement(Table.Row, nil, React.createElement(Table.Cell, {
		text = "Bob",
	}), React.createElement(Table.Cell, {
		text = "Designer",
	}), React.createElement(Table.Cell, {
		text = "88",
	}))))
end
local function getCells(root)
	local cells = {}
	for _, descendant in root:GetDescendants() do
		if descendant:IsA("GuiObject") and (descendant.Name == "TableHead" or descendant.Name == "TableCell") then
			table.insert(cells, descendant)
		end
	end
	return cells
end
local function waitForColumnsMeasured(host)
	local tableRoot = waitForGuiObject(host, "Table")
	waitForLayout(function()
		local cells = getCells(tableRoot)
		local expected = COLUMN_COUNT * (BODY_ROW_COUNT + 1)
		if #cells ~= expected then
			return nil
		end
		-- ▼ ReadonlyArray.every ▼
		local _result = true
		local _callback = function(cell)
			return cell.AbsoluteSize.X > 0 and cell.AbsoluteSize.Y > 0
		end
		for _k, _v in cells do
			if not _callback(_v, _k - 1, cells) then
				_result = false
				break
			end
		end
		-- ▲ ReadonlyArray.every ▲
		return if _result then true else nil
	end, "Timed out waiting for every tableRoot cell to be measured with a non-zero size")
	task.wait()
	task.wait()
	return tableRoot
end
local function getRows(section)
	local rows = {}
	for _, child in section:GetChildren() do
		if child:IsA("GuiObject") and child.Name == "TableRow" then
			table.insert(rows, child)
		end
	end
	return rows
end
local function firstCellText(row)
	local label = row:FindFirstChildWhichIsA("TextLabel", true)
	Assert:notUndefined(label, `Expected a TextLabel inside {row:GetFullName()}`)
	return label.Text
end
local TableMountValidation
do
	TableMountValidation = setmetatable({}, {
		__tostring = function()
			return "TableMountValidation"
		end,
	})
	TableMountValidation.__index = TableMountValidation
	function TableMountValidation.new(...)
		local self = setmetatable({}, TableMountValidation)
		return self:constructor(...) or self
	end
	function TableMountValidation:constructor()
	end
	function TableMountValidation:headerThenRowsInOrder()
		withMounted(500, 300, tableFixture(), function(mounted)
			local tableRoot = waitForColumnsMeasured(mounted.host)
			local header = findDescendant(tableRoot, "TableHeader")
			local body = findDescendant(tableRoot, "TableBody")
			local bodyRows = getRows(body)
			Assert:equal(#bodyRows, BODY_ROW_COUNT, "Expected two body rows")
			Assert:equal(firstCellText(bodyRows[1]), "Alice")
			Assert:equal(firstCellText(bodyRows[2]), "Bob")
			local _array = { header }
			local _length = #_array
			table.move(bodyRows, 1, #bodyRows, _length + 1, _array)
			assertStackedVertically(_array, "header then body rows")
		end)
	end
	function TableMountValidation:columnCountMatchesData()
		withMounted(500, 300, tableFixture(), function(mounted)
			local tableRoot = waitForColumnsMeasured(mounted.host)
			local header = findDescendant(tableRoot, "TableHeader")
			local body = findDescendant(tableRoot, "TableBody")
			local headerRows = getRows(header)
			Assert:equal(#headerRows, 1, "Expected a single header row")
			Assert:equal(#getCells(headerRows[1]), COLUMN_COUNT, "Expected one TableHead per column")
			for _, row in getRows(body) do
				Assert:equal(#getCells(row), COLUMN_COUNT, `Expected {COLUMN_COUNT} cells in {row:GetFullName()}`)
			end
		end)
	end
	function TableMountValidation:cellsContained()
		withMounted(500, 300, tableFixture(), function(mounted)
			local tableRoot = waitForColumnsMeasured(mounted.host)
			assertContained(tableRoot, mounted.host, "tableRoot vs host")
			assertAllDescendantsContained(tableRoot, "auto-width tableRoot")
		end)
	end
	function TableMountValidation:explicitWidth()
		withMounted(500, 300, tableFixture(300), function(mounted)
			local tableRoot = waitForColumnsMeasured(mounted.host)
			assertSizeApprox(tableRoot, 300, nil, 1, "explicit width tableRoot")
			assertAllDescendantsContained(tableRoot, "explicit width tableRoot")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("The header row sits above the body rows, which follow in declaration order")
	local _descriptor = Test(TableMountValidation, "headerThenRowsInOrder", {
		value = TableMountValidation.headerThenRowsInOrder,
	})
	if _descriptor then
		TableMountValidation.headerThenRowsInOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TableMountValidation, "headerThenRowsInOrder", {
		value = TableMountValidation.headerThenRowsInOrder,
	})
	if _descriptor_1 then
		TableMountValidation.headerThenRowsInOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TableMountValidation, "headerThenRowsInOrder", {
		value = TableMountValidation.headerThenRowsInOrder,
	})
	if _descriptor_2 then
		TableMountValidation.headerThenRowsInOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Every row renders exactly one cell per column of the data")
	local _descriptor_3 = Test(TableMountValidation, "columnCountMatchesData", {
		value = TableMountValidation.columnCountMatchesData,
	})
	if _descriptor_3 then
		TableMountValidation.columnCountMatchesData = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TableMountValidation, "columnCountMatchesData", {
		value = TableMountValidation.columnCountMatchesData,
	})
	if _descriptor_4 then
		TableMountValidation.columnCountMatchesData = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TableMountValidation, "columnCountMatchesData", {
		value = TableMountValidation.columnCountMatchesData,
	})
	if _descriptor_5 then
		TableMountValidation.columnCountMatchesData = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("With no width the tableRoot hugs its columns and every visible descendant stays inside it")
	local _descriptor_6 = Test(TableMountValidation, "cellsContained", {
		value = TableMountValidation.cellsContained,
	})
	if _descriptor_6 then
		TableMountValidation.cellsContained = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TableMountValidation, "cellsContained", {
		value = TableMountValidation.cellsContained,
	})
	if _descriptor_7 then
		TableMountValidation.cellsContained = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TableMountValidation, "cellsContained", {
		value = TableMountValidation.cellsContained,
	})
	if _descriptor_8 then
		TableMountValidation.cellsContained = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("An explicit width pins the tableRoot to that pixel width while cells stay inside it")
	local _descriptor_9 = Test(TableMountValidation, "explicitWidth", {
		value = TableMountValidation.explicitWidth,
	})
	if _descriptor_9 then
		TableMountValidation.explicitWidth = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TableMountValidation, "explicitWidth", {
		value = TableMountValidation.explicitWidth,
	})
	if _descriptor_10 then
		TableMountValidation.explicitWidth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TableMountValidation, "explicitWidth", {
		value = TableMountValidation.explicitWidth,
	})
	if _descriptor_11 then
		TableMountValidation.explicitWidth = _descriptor_11.value
	end
	TableMountValidation = Tag("Studio")(TableMountValidation) or TableMountValidation
end
return TableMountValidation
