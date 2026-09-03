-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local Container = TS.import(script, script.Parent, "Container").Container
local HStack = TS.import(script, script.Parent, "HStack").HStack
local VStack = TS.import(script, script.Parent, "VStack").VStack
local TableSectionContext = React.createContext(nil)
local TableScaleContext = React.createContext(nil)
local TableLayoutContext = React.createContext(nil)
local TableColumnContext = React.createContext(0)
local nextTableCellId = 0
local function TableHeader(props)
	local theme = React.useContext(CleanThemeContext)
	local layout = React.useContext(TableLayoutContext)
	local _result = layout
	if _result ~= nil then
		_result = _result.autoWidth
	end
	local autoSectionWidth = if _result == true then layout.totalWidth else nil
	return React.createElement(TableSectionContext.Provider, {
		value = "header",
	}, React.createElement(Container, {
		name = "TableHeader",
		Size = if autoSectionWidth ~= nil then UDim2.fromOffset(autoSectionWidth, 0) else nil,
		width = if autoSectionWidth == nil then "100%" else nil,
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.components.table.header.backgroundColor,
		BackgroundTransparency = theme.components.table.header.backgroundTransparency,
	}, React.createElement("uicorner", {
		key = "Corners",
		TopLeftRadius = SizeHelper:toUDim(theme.components.table.cornerRadius),
		TopRightRadius = SizeHelper:toUDim(theme.components.table.cornerRadius),
		BottomLeftRadius = UDim.new(0, 0),
		BottomRightRadius = UDim.new(0, 0),
	}), React.createElement(VStack, {
		spacing = "None",
	}, props.children)))
end
local function TableBody(props)
	local layout = React.useContext(TableLayoutContext)
	local _result = layout
	if _result ~= nil then
		_result = _result.autoWidth
	end
	local autoSectionWidth = if _result == true then layout.totalWidth else nil
	return React.createElement(TableSectionContext.Provider, {
		value = "body",
	}, React.createElement(Container, {
		name = "TableBody",
		Size = if autoSectionWidth ~= nil then UDim2.fromOffset(autoSectionWidth, 0) else nil,
		width = if autoSectionWidth == nil then "100%" else nil,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, React.createElement(VStack, {
		spacing = "None",
	}, props.children)))
end
local TableHead, TableCell
local function TableRow(props)
	local theme = React.useContext(CleanThemeContext)
	local section = React.useContext(TableSectionContext)
	local layout = React.useContext(TableLayoutContext)
	local columnIndex = 0
	local children = React.Children.map(props.children, function(child)
		if not React.isValidElement(child) or (child.type ~= TableHead and child.type ~= TableCell) then
			return child
		end
		local _original = columnIndex
		columnIndex += 1
		local currentColumnIndex = _original
		return React.createElement(TableColumnContext.Provider, {
			value = currentColumnIndex,
		}, child)
	end)
	local _result = layout
	if _result ~= nil then
		_result = _result.autoWidth
	end
	local autoRowWidth = if _result == true then layout.totalWidth else nil
	local _condition = section == "body"
	if _condition then
		local _attributes = {
			key = "Divider",
			BackgroundColor3 = theme.components.table.rowDividerColor,
			BorderSizePixel = 0,
		}
		local _exp = UDim2.fromOffset(0, theme.components.table.rowDividerThickness)
		local _arg0 = UDim2.fromScale(1, 0)
		_attributes.Size = _exp + _arg0
		_condition = (React.createElement("frame", _attributes))
	end
	return React.createElement(Container, {
		name = "TableRow",
		Size = if autoRowWidth ~= nil then UDim2.fromOffset(autoRowWidth, 0) else nil,
		width = if autoRowWidth == nil then "100%" else nil,
		AutomaticSize = Enum.AutomaticSize.Y,
	}, _condition, React.createElement(Container, {
		name = "TableRowContent",
		width = "100%",
		AutomaticSize = Enum.AutomaticSize.Y,
	}, React.createElement(HStack, {
		Padding = UDim.new(0, 0),
		Wraps = false,
	}, children)))
end
local function TableCellContent(props)
	local theme = React.useContext(CleanThemeContext)
	local tableScale = React.useContext(TableScaleContext)
	local layout = React.useContext(TableLayoutContext)
	local _original = nextTableCellId
	nextTableCellId += 1
	local id = React.useRef(_original).current
	local measurementRef = React.useRef()
	local typography = if props.header then TypographyHelper:getTypography(theme, tableScale, theme.components.table.header.typography) else TypographyHelper:getTypography(theme, tableScale, theme.components.table.cell.typography)
	local _condition = props.text
	if _condition == nil then
		_condition = props.children
	end
	local content = _condition
	local columnIndex = React.useContext(TableColumnContext)
	local _result = layout
	if _result ~= nil then
		_result = _result.columnWidths[columnIndex]
	end
	local _condition_1 = _result
	if _condition_1 == nil then
		_condition_1 = 0
	end
	local columnWidth = _condition_1
	local _result_1 = layout
	if _result_1 ~= nil then
		_result_1 = _result_1.autoWidth
	end
	local _condition_2 = _result_1 == false
	if _condition_2 then
		_condition_2 = layout.totalWidth > 0
	end
	local cellWidth = if _condition_2 then UDim.new(columnWidth / layout.totalWidth, 0) else UDim.new(0, columnWidth)
	local _exp = function(instance)
		local _result_2 = layout
		if _result_2 ~= nil then
			_result_2 = _result_2.reportWidth(id, columnIndex, instance.AbsoluteSize.X)
		end
		return _result_2
	end
	local _result_2 = layout
	if _result_2 ~= nil then
		_result_2 = _result_2.reportWidth
	end
	local reportMeasurement = React.useCallback(_exp, { _result_2, id, columnIndex })
	local _exp_1 = function()
		return function()
			local _result_3 = layout
			if _result_3 ~= nil then
				_result_3 = _result_3.removeWidth(id)
			end
			return _result_3
		end
	end
	local _result_3 = layout
	if _result_3 ~= nil then
		_result_3 = _result_3.removeWidth
	end
	React.useEffect(_exp_1, { _result_3 })
	React.useEffect(function()
		local mounted = true
		local reportMountedMeasurement = function()
			local instance = measurementRef.current
			if mounted and instance ~= nil then
				reportMeasurement(instance)
			end
		end
		reportMountedMeasurement()
		task.defer(reportMountedMeasurement)
		return function()
			mounted = false
		end
	end, { reportMeasurement })
	local _exp_2 = React.createElement("uilistlayout", {
		key = "TableCellLayout",
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = props.align or "Left",
	})
	local _attributes = {}
	local _object = table.clone(props)
	setmetatable(_object, nil)
	_object.spacing = props.spacing or tableScale
	_attributes.resolvedPadding = SpacingHelper:GetResolvedPadding(theme, _object, theme.components.table.cell.spacing, theme.components.table.cell.padding)
	return React.createElement(Container, {
		name = if props.header then "TableHead" else "TableCell",
		Size = UDim2.new(cellWidth, UDim.new(0, 0)),
		AutomaticSize = Enum.AutomaticSize.Y,
	}, _exp_2, React.createElement("frame", {
		key = "TableCellMeasurement",
		ref = measurementRef,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Change = {
			AbsoluteSize = reportMeasurement,
		},
	}, React.createElement(Padding, _attributes), if type(content) == "string" then React.createElement(Text, {
		text = content,
		typography = typography,
		TextWrap = false,
	}) else content))
end
function TableHead(props)
	local _object = table.clone(props)
	setmetatable(_object, nil)
	_object.header = true
	return TableCellContent(_object)
end
function TableCell(props)
	local _object = table.clone(props)
	setmetatable(_object, nil)
	_object.header = false
	return TableCellContent(_object)
end
local Table = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local measurements, setMeasurements = React.useState({})
	local autoWidth = props.Size == nil and props.width == nil
	local reportWidth = React.useCallback(function(id, columnIndex, width)
		setMeasurements(function(current)
			local _current = current
			local _id = id
			local previous = _current[_id]
			local _result = previous
			if _result ~= nil then
				_result = _result.columnIndex
			end
			local _condition = _result == columnIndex
			if _condition then
				_condition = previous.width == width
			end
			if _condition then
				return current
			end
			local updated = {}
			for currentId, measurement in current do
				updated[currentId] = measurement
			end
			local _id_1 = id
			local _arg1 = {
				columnIndex = columnIndex,
				width = width,
			}
			updated[_id_1] = _arg1
			return updated
		end)
	end, {})
	local removeWidth = React.useCallback(function(id)
		setMeasurements(function(current)
			local _current = current
			local _id = id
			if not (_current[_id] ~= nil) then
				return current
			end
			local updated = {}
			for currentId, measurement in current do
				updated[currentId] = measurement
			end
			local _id_1 = id
			updated[_id_1] = nil
			return updated
		end)
	end, {})
	local columnWidths = React.useMemo(function()
		local widths = {}
		for _, measurement in measurements do
			local _exp = measurement.columnIndex
			local _columnIndex = measurement.columnIndex
			local _condition = widths[_columnIndex]
			if _condition == nil then
				_condition = 0
			end
			local _arg1 = math.max(_condition, measurement.width)
			widths[_exp] = _arg1
		end
		return widths
	end, { measurements })
	local totalWidth = 0
	for _, width in columnWidths do
		totalWidth += width
	end
	local layout = React.useMemo(function()
		return {
			autoWidth = autoWidth,
			columnWidths = columnWidths,
			totalWidth = totalWidth,
			reportWidth = reportWidth,
			removeWidth = removeWidth,
		}
	end, { autoWidth, columnWidths, totalWidth, reportWidth, removeWidth })
	local _attributes = {
		ref = ref,
	}
	local _condition = props.name
	if _condition == nil then
		_condition = "Table"
	end
	_attributes.name = _condition
	_attributes.Size = props.Size
	_attributes.width = props.width
	_attributes.height = props.height
	_attributes.AutomaticSize = props.AutomaticSize
	_attributes.BackgroundColor3 = theme.components.table.backgroundColor
	_attributes.BackgroundTransparency = theme.components.table.backgroundTransparency
	_attributes.ClipsDescendants = true
	return React.createElement(TableScaleContext.Provider, {
		value = props.scale,
	}, React.createElement(TableLayoutContext.Provider, {
		value = layout,
	}, React.createElement(Container, _attributes, React.createElement(Corners, {
		radius = theme.components.table.cornerRadius,
	}), React.createElement("uistroke", {
		key = "Stroke",
		Color = theme.components.table.borderColor,
		Thickness = theme.components.table.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Outer,
	}), React.createElement(VStack, {
		spacing = "None",
		HorizontalFlex = if autoWidth then Enum.UIFlexAlignment.None else Enum.UIFlexAlignment.Fill,
	}, props.children))))
end)
Table.Header = TableHeader
Table.Body = TableBody
Table.Row = TableRow
Table.Head = TableHead
Table.Cell = TableCell
return {
	Table = Table,
}
