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
local Column = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Column").Column
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local HOST_HEIGHT = 300
local CONTENT_HEIGHT = 40
local function column(span)
	return React.createElement(Column, {
		span = span,
	}, React.createElement("frame", {
		key = "ColumnContent",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, CONTENT_HEIGHT),
	}))
end
local function waitForColumn(host)
	return waitForGuiObject(host, "Column")
end
local ColumnMountValidation
do
	ColumnMountValidation = setmetatable({}, {
		__tostring = function()
			return "ColumnMountValidation"
		end,
	})
	ColumnMountValidation.__index = ColumnMountValidation
	function ColumnMountValidation.new(...)
		local self = setmetatable({}, ColumnMountValidation)
		return self:constructor(...) or self
	end
	function ColumnMountValidation:constructor()
	end
	function ColumnMountValidation:fullWidthByDefault()
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(), function(mounted)
			local col = waitForColumn(mounted.host)
			assertSizeApprox(col, HOST_WIDTH, nil, 1, "default span")
		end)
	end
	function ColumnMountValidation:spanFraction(span, expectedWidth)
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(span), function(mounted)
			local col = waitForColumn(mounted.host)
			assertSizeApprox(col, expectedWidth, nil, 1, `span={span}`)
		end)
	end
	function ColumnMountValidation:autoHeightFromContent()
		withMounted(HOST_WIDTH, HOST_HEIGHT, column(6), function(mounted)
			local col = waitForGuiObject(mounted.host, "Column", function(gui)
				return gui.AbsoluteSize.Y >= CONTENT_HEIGHT
			end, `Timed out waiting for the Column to grow to its {CONTENT_HEIGHT}px content`)
			assertSizeApprox(col, nil, CONTENT_HEIGHT, 1, "auto height")
			assertAllDescendantsContained(col, "auto height")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without a span or an enclosing Row, the Column resolves to span 12 and fills the host width")
	local _descriptor = Test(ColumnMountValidation, "fullWidthByDefault", {
		value = ColumnMountValidation.fullWidthByDefault,
	})
	if _descriptor then
		ColumnMountValidation.fullWidthByDefault = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ColumnMountValidation, "fullWidthByDefault", {
		value = ColumnMountValidation.fullWidthByDefault,
	})
	if _descriptor_1 then
		ColumnMountValidation.fullWidthByDefault = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ColumnMountValidation, "fullWidthByDefault", {
		value = ColumnMountValidation.fullWidthByDefault,
	})
	if _descriptor_2 then
		ColumnMountValidation.fullWidthByDefault = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { 3, 100 }, { "6", 200 }, { 12, 400 } })
	local _decorator_4 = DisplayName("Numeric and numeric-string spans size the Column to span/12 of the host width")
	local _descriptor_3 = Test(ColumnMountValidation, "spanFraction", {
		value = ColumnMountValidation.spanFraction,
	})
	if _descriptor_3 then
		ColumnMountValidation.spanFraction = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(ColumnMountValidation, "spanFraction", {
		value = ColumnMountValidation.spanFraction,
	})
	if _descriptor_4 then
		ColumnMountValidation.spanFraction = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(ColumnMountValidation, "spanFraction", {
		value = ColumnMountValidation.spanFraction,
	})
	if _descriptor_5 then
		ColumnMountValidation.spanFraction = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(ColumnMountValidation, "spanFraction", {
		value = ColumnMountValidation.spanFraction,
	})
	if _descriptor_6 then
		ColumnMountValidation.spanFraction = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("The Column grows to its content's height and keeps that content inside its rect")
	local _descriptor_7 = Test(ColumnMountValidation, "autoHeightFromContent", {
		value = ColumnMountValidation.autoHeightFromContent,
	})
	if _descriptor_7 then
		ColumnMountValidation.autoHeightFromContent = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(ColumnMountValidation, "autoHeightFromContent", {
		value = ColumnMountValidation.autoHeightFromContent,
	})
	if _descriptor_8 then
		ColumnMountValidation.autoHeightFromContent = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(ColumnMountValidation, "autoHeightFromContent", {
		value = ColumnMountValidation.autoHeightFromContent,
	})
	if _descriptor_9 then
		ColumnMountValidation.autoHeightFromContent = _descriptor_9.value
	end
	ColumnMountValidation = Tag("Studio")(ColumnMountValidation) or ColumnMountValidation
end
return ColumnMountValidation
