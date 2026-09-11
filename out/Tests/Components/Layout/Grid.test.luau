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
local Each = _binding.Each
local Grid = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Grid").Grid
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local mountInScreenGui = _layout.mountInScreenGui
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local function mountGrid(width, element)
	local _binding_1 = mountInScreenGui(width, 600, element)
	local host = _binding_1.host
	local root = _binding_1.root
	local update = _binding_1.update
	return {
		host = host,
		root = root,
		update = update,
	}
end
local function unmount(root, host)
	local gui = host.Parent
	root:unmount()
	host:Destroy()
	if gui ~= nil and gui:IsA("ScreenGui") then
		gui:Destroy()
	end
end
local function waitForFillDirectionMaxCells(host, expectedCols)
	return waitForDescendant(host, "GridLayout", function(layout)
		return layout.FillDirectionMaxCells == expectedCols
	end, `Timed out waiting for Grid to lock with cols={expectedCols}`)
end
local function waitForFreshLock(host, previous, expectedCols)
	return waitForDescendant(host, "GridLayout", function(layout)
		return layout.FillDirectionMaxCells == expectedCols and (previous == nil or layout ~= previous)
	end, `Timed out waiting for Grid to relock (cols={expectedCols}) with a fresh GridLayout instance`)
end
local function waitForGridWidth(host, expectedWidth)
	return waitForGuiObject(host, "Grid", function(gridFrame)
		return gridFrame.AbsoluteSize.X == expectedWidth
	end, `Timed out waiting for Grid's root frame to reach an AbsoluteSize.X of {expectedWidth}`)
end
local function getGridCells(host)
	local gridFrame = host:FindFirstChild("Grid", true)
	Assert:notUndefined(gridFrame, "Expected to find the Grid's root frame")
	local cells = {}
	for _, child in gridFrame:GetChildren() do
		if child:IsA("GuiObject") and child.Name == "GridCell" then
			table.insert(cells, child)
		end
	end
	table.sort(cells, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	return cells
end
local function firstGuiObjectName(instance)
	for _, child in instance:GetChildren() do
		if child:IsA("GuiObject") then
			return child.Name
		end
	end
	return nil
end
local GridMountValidation
do
	GridMountValidation = setmetatable({}, {
		__tostring = function()
			return "GridMountValidation"
		end,
	})
	GridMountValidation.__index = GridMountValidation
	function GridMountValidation.new(...)
		local self = setmetatable({}, GridMountValidation)
		return self:constructor(...) or self
	end
	function GridMountValidation:constructor()
	end
	function GridMountValidation:numericCols()
		local _binding_1 = mountGrid(50, React.createElement(Grid, {
			cols = 3,
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForFillDirectionMaxCells(host, 3)
		unmount(root, host)
	end
	function GridMountValidation:defaultCols()
		local _binding_1 = mountGrid(150, React.createElement(Grid, {
			cols = {
				lg = 3,
			},
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForFillDirectionMaxCells(host, 1)
		unmount(root, host)
	end
	function GridMountValidation:breakpointCols()
		local _binding_1 = mountGrid(250, React.createElement(Grid, {
			cols = {
				xs = 1,
				md = 3,
				xl = 5,
			},
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForFillDirectionMaxCells(host, 1)
		host.Size = UDim2.fromOffset(350, 600)
		task.wait()
		waitForFillDirectionMaxCells(host, 3)
		host.Size = UDim2.fromOffset(550, 600)
		task.wait()
		waitForFillDirectionMaxCells(host, 5)
		unmount(root, host)
	end
	function GridMountValidation:customBreakpoints()
		local _binding_1 = mountGrid(120, React.createElement(Grid, {
			cols = {
				xs = 2,
				md = 4,
			},
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		local update = _binding_1.update
		waitForFillDirectionMaxCells(host, 2)
		update(React.createElement(Grid, {
			cols = {
				xs = 2,
				md = 4,
			},
			breakpoints = {
				xs = 0,
				sm = 50,
				md = 100,
				lg = 150,
				xl = 200,
			},
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		waitForFillDirectionMaxCells(host, 4)
		unmount(root, host)
	end
	function GridMountValidation:cellSizing(cols, gapKey, gapPixels, expectedScale, expectedOffset)
		local _binding_1 = mountGrid(600, React.createElement(Grid, {
			cols = cols,
			gap = gapKey,
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		local layout = waitForFillDirectionMaxCells(host, cols)
		Assert:approximately(layout.CellSize.X.Scale, expectedScale, 1e-6)
		Assert:approximately(layout.CellSize.X.Offset, expectedOffset, 1e-6)
		Assert:equal(layout.CellPadding, UDim2.new(0, gapPixels, 0, gapPixels))
		unmount(root, host)
	end
	function GridMountValidation:childOrder()
		local _binding_1 = mountGrid(600, React.createElement(Grid, {
			cols = 2,
			gap = "None",
		}, React.createElement("textlabel", {
			key = "Alpha",
			Text = "Alpha",
			Size = UDim2.fromOffset(20, 20),
		}), React.createElement(Container, {
			name = "CustomCard",
			width = 20,
			height = 20,
		}), React.createElement("frame", {
			key = "Gamma",
			Size = UDim2.fromOffset(20, 20),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForFillDirectionMaxCells(host, 2)
		local cells = waitForLayout(function()
			local found = getGridCells(host)
			return if #found == 3 then found else nil
		end, "Timed out waiting for all three cells to render")
		local names = {}
		local orders = {}
		for _, cell in cells do
			local _condition = firstGuiObjectName(cell)
			if _condition == nil then
				_condition = ""
			end
			table.insert(names, _condition)
			local _layoutOrder = cell.LayoutOrder
			table.insert(orders, _layoutOrder)
		end
		Assert:deepEqual(names, { "Alpha", "CustomCard", "Gamma" })
		Assert:deepEqual(orders, { 0, 1, 2 })
		unmount(root, host)
	end
	function GridMountValidation:relockOnChildAdded()
		local _binding_1 = mountGrid(600, React.createElement(Grid, {
			cols = 2,
			gap = "None",
		}, React.createElement("frame", {
			key = "Alpha",
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			key = "Beta",
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		local update = _binding_1.update
		local initialLayout = waitForFillDirectionMaxCells(host, 2)
		Assert:equal(#getGridCells(host), 2)
		update(React.createElement(Grid, {
			cols = 2,
			gap = "None",
		}, React.createElement("frame", {
			key = "Alpha",
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			key = "Beta",
			Size = UDim2.fromOffset(10, 10),
		}), React.createElement("frame", {
			key = "Gamma",
			Size = UDim2.fromOffset(10, 10),
		})))
		waitForFreshLock(host, initialLayout, 2)
		Assert:equal(#getGridCells(host), 3)
		unmount(root, host)
	end
	function GridMountValidation:relockOnWidthChange()
		local prose = "The quick brown fox jumps over the lazy dog while the grid measures every cell, " .. "locks the tallest height it saw, and must let that height go again once the " .. "container widens back out and the very same text wraps onto fewer lines."
		local _binding_1 = mountGrid(600, React.createElement(Grid, {
			cols = 1,
			gap = "None",
		}, React.createElement("textlabel", {
			key = "Prose",
			Text = prose,
			TextSize = 14,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		local wideLayout = waitForFillDirectionMaxCells(host, 1)
		local wideHeight = wideLayout.CellSize.Y.Offset
		Assert:greaterThan(wideHeight, 0, "Expected the initial lock to capture a non-zero wrapped text height")
		host.Size = UDim2.fromOffset(150, 600)
		task.wait()
		local narrowLayout = waitForFreshLock(host, wideLayout, 1)
		local narrowHeight = narrowLayout.CellSize.Y.Offset
		Assert:greaterThan(narrowHeight, wideHeight, "Expected the text to wrap taller once the cell became narrower")
		host.Size = UDim2.fromOffset(600, 600)
		task.wait()
		local restoredLayout = waitForFreshLock(host, narrowLayout, 1)
		Assert:equal(restoredLayout.CellSize.Y.Offset, wideHeight, "Expected the row height to drop back to the wide-width measurement after widening the container")
		unmount(root, host)
	end
	function GridMountValidation:pixelWidth()
		local _binding_1 = mountGrid(800, React.createElement(Grid, {
			width = 300,
			cols = 2,
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForGridWidth(host, 300)
		unmount(root, host)
	end
	function GridMountValidation:percentWidth(hostWidth, expectedGridWidth)
		local _binding_1 = mountGrid(hostWidth, React.createElement(Grid, {
			width = "50%",
			cols = 2,
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForGridWidth(host, expectedGridWidth)
		unmount(root, host)
	end
	function GridMountValidation:defaultWidth()
		local _binding_1 = mountGrid(500, React.createElement(Grid, {
			cols = 2,
		}, React.createElement("frame", {
			Size = UDim2.fromOffset(10, 10),
		})))
		local host = _binding_1.host
		local root = _binding_1.root
		waitForGridWidth(host, 500)
		unmount(root, host)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A plain numeric cols value locks that column count even in a tiny container")
	local _descriptor = Test(GridMountValidation, "numericCols", {
		value = GridMountValidation.numericCols,
	})
	if _descriptor then
		GridMountValidation.numericCols = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(GridMountValidation, "numericCols", {
		value = GridMountValidation.numericCols,
	})
	if _descriptor_1 then
		GridMountValidation.numericCols = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(GridMountValidation, "numericCols", {
		value = GridMountValidation.numericCols,
	})
	if _descriptor_2 then
		GridMountValidation.numericCols = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Cols falls back to one when the breakpoint object has no value at or below the active breakpoint")
	local _descriptor_3 = Test(GridMountValidation, "defaultCols", {
		value = GridMountValidation.defaultCols,
	})
	if _descriptor_3 then
		GridMountValidation.defaultCols = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(GridMountValidation, "defaultCols", {
		value = GridMountValidation.defaultCols,
	})
	if _descriptor_4 then
		GridMountValidation.defaultCols = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(GridMountValidation, "defaultCols", {
		value = GridMountValidation.defaultCols,
	})
	if _descriptor_5 then
		GridMountValidation.defaultCols = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Resizing the host across sm, md and xl picks the nearest lower breakpoint's cols value")
	local _descriptor_6 = Test(GridMountValidation, "breakpointCols", {
		value = GridMountValidation.breakpointCols,
	})
	if _descriptor_6 then
		GridMountValidation.breakpointCols = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(GridMountValidation, "breakpointCols", {
		value = GridMountValidation.breakpointCols,
	})
	if _descriptor_7 then
		GridMountValidation.breakpointCols = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(GridMountValidation, "breakpointCols", {
		value = GridMountValidation.breakpointCols,
	})
	if _descriptor_8 then
		GridMountValidation.breakpointCols = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Passing custom thresholds moves a 120px container from xs to md without changing its size")
	local _descriptor_9 = Test(GridMountValidation, "customBreakpoints", {
		value = GridMountValidation.customBreakpoints,
	})
	if _descriptor_9 then
		GridMountValidation.customBreakpoints = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(GridMountValidation, "customBreakpoints", {
		value = GridMountValidation.customBreakpoints,
	})
	if _descriptor_10 then
		GridMountValidation.customBreakpoints = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(GridMountValidation, "customBreakpoints", {
		value = GridMountValidation.customBreakpoints,
	})
	if _descriptor_11 then
		GridMountValidation.customBreakpoints = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = Each({ { 2, "md", 12, 0.5, -6 }, { 4, "lg", 16, 0.25, -12 }, { 3, "xl", 24, 1 / 3, -16 }, { 5, "sm", 8, 0.2, -7 }, { 3, "None", 0, 1 / 3, 0 } })
	local _decorator_10 = DisplayName("Each cell is 1/cols wide minus a floored share of the gap, with CellPadding set to the gap in pixels")
	local _descriptor_12 = Test(GridMountValidation, "cellSizing", {
		value = GridMountValidation.cellSizing,
	})
	if _descriptor_12 then
		GridMountValidation.cellSizing = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_10(GridMountValidation, "cellSizing", {
		value = GridMountValidation.cellSizing,
	})
	if _descriptor_13 then
		GridMountValidation.cellSizing = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_9(GridMountValidation, "cellSizing", {
		value = GridMountValidation.cellSizing,
	})
	if _descriptor_14 then
		GridMountValidation.cellSizing = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_8(GridMountValidation, "cellSizing", {
		value = GridMountValidation.cellSizing,
	})
	if _descriptor_15 then
		GridMountValidation.cellSizing = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Native and custom children each get their own GridCell, numbered in source order from zero")
	local _descriptor_16 = Test(GridMountValidation, "childOrder", {
		value = GridMountValidation.childOrder,
	})
	if _descriptor_16 then
		GridMountValidation.childOrder = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(GridMountValidation, "childOrder", {
		value = GridMountValidation.childOrder,
	})
	if _descriptor_17 then
		GridMountValidation.childOrder = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(GridMountValidation, "childOrder", {
		value = GridMountValidation.childOrder,
	})
	if _descriptor_18 then
		GridMountValidation.childOrder = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("Appending a child with cols, gap and width unchanged still invalidates and rebuilds the locked layout")
	local _descriptor_19 = Test(GridMountValidation, "relockOnChildAdded", {
		value = GridMountValidation.relockOnChildAdded,
	})
	if _descriptor_19 then
		GridMountValidation.relockOnChildAdded = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(GridMountValidation, "relockOnChildAdded", {
		value = GridMountValidation.relockOnChildAdded,
	})
	if _descriptor_20 then
		GridMountValidation.relockOnChildAdded = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(GridMountValidation, "relockOnChildAdded", {
		value = GridMountValidation.relockOnChildAdded,
	})
	if _descriptor_21 then
		GridMountValidation.relockOnChildAdded = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("Wrapped text grows the locked row height when the host narrows and shrinks it back when it widens")
	local _descriptor_22 = Test(GridMountValidation, "relockOnWidthChange", {
		value = GridMountValidation.relockOnWidthChange,
	})
	if _descriptor_22 then
		GridMountValidation.relockOnWidthChange = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(GridMountValidation, "relockOnWidthChange", {
		value = GridMountValidation.relockOnWidthChange,
	})
	if _descriptor_23 then
		GridMountValidation.relockOnWidthChange = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(GridMountValidation, "relockOnWidthChange", {
		value = GridMountValidation.relockOnWidthChange,
	})
	if _descriptor_24 then
		GridMountValidation.relockOnWidthChange = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("A pixel width of 300 lands at exactly 300 inside an 800px host")
	local _descriptor_25 = Test(GridMountValidation, "pixelWidth", {
		value = GridMountValidation.pixelWidth,
	})
	if _descriptor_25 then
		GridMountValidation.pixelWidth = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(GridMountValidation, "pixelWidth", {
		value = GridMountValidation.pixelWidth,
	})
	if _descriptor_26 then
		GridMountValidation.pixelWidth = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(GridMountValidation, "pixelWidth", {
		value = GridMountValidation.pixelWidth,
	})
	if _descriptor_27 then
		GridMountValidation.pixelWidth = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = Each({ { 800, 400 }, { 240, 120 } })
	local _decorator_21 = DisplayName("A 50% width scales with the host, yielding different pixel sizes at different host widths")
	local _descriptor_28 = Test(GridMountValidation, "percentWidth", {
		value = GridMountValidation.percentWidth,
	})
	if _descriptor_28 then
		GridMountValidation.percentWidth = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_21(GridMountValidation, "percentWidth", {
		value = GridMountValidation.percentWidth,
	})
	if _descriptor_29 then
		GridMountValidation.percentWidth = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_20(GridMountValidation, "percentWidth", {
		value = GridMountValidation.percentWidth,
	})
	if _descriptor_30 then
		GridMountValidation.percentWidth = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_19(GridMountValidation, "percentWidth", {
		value = GridMountValidation.percentWidth,
	})
	if _descriptor_31 then
		GridMountValidation.percentWidth = _descriptor_31.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("Leaving width unset keeps the legacy full-parent fill behavior")
	local _descriptor_32 = Test(GridMountValidation, "defaultWidth", {
		value = GridMountValidation.defaultWidth,
	})
	if _descriptor_32 then
		GridMountValidation.defaultWidth = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_23(GridMountValidation, "defaultWidth", {
		value = GridMountValidation.defaultWidth,
	})
	if _descriptor_33 then
		GridMountValidation.defaultWidth = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_22(GridMountValidation, "defaultWidth", {
		value = GridMountValidation.defaultWidth,
	})
	if _descriptor_34 then
		GridMountValidation.defaultWidth = _descriptor_34.value
	end
	GridMountValidation = Tag("Studio")(GridMountValidation) or GridMountValidation
end
return GridMountValidation
