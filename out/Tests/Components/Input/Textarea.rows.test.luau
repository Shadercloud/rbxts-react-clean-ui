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
local Textarea = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea").Textarea
local resolveTextareaWholePixels = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea.layout").resolveTextareaWholePixels
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SpacingHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local describeGui = _layout.describeGui
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 400
local ROWS = 4
local FIELD_HEIGHT = 125
local ROOT_WITH_COUNT = 155
local function lines(count)
	local parts = {}
	do
		local index = 1
		local _shouldIncrement = false
		while true do
			if _shouldIncrement then
				index += 1
			else
				_shouldIncrement = true
			end
			if not (index <= count) then
				break
			end
			local _arg0 = `Line {index}`
			table.insert(parts, _arg0)
		end
	end
	return table.concat(parts, "\n")
end
local LONG_TEXT = lines(40)
local function textarea(value, showCount)
	return React.createElement(Textarea, {
		value = value,
		rows = ROWS,
		showCount = showCount,
	})
end
local function waitForMounted(host)
	local root = waitForGuiObject(host, "Textarea")
	local field = waitForGuiObject(root, "Field")
	local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
	Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
	local box = findDescendant(frame, "TextBox")
	waitForLayout(function()
		return if box.AbsoluteSize.X > 0 then true else nil
	end, `Timed out waiting for the TextBox to get a width ({describeGui(box)})`)
	settleFrames(5)
	return {
		root = root,
		field = field,
		frame = frame,
		box = box,
	}
end
local TextareaRowsValidation
do
	TextareaRowsValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaRowsValidation"
		end,
	})
	TextareaRowsValidation.__index = TextareaRowsValidation
	function TextareaRowsValidation.new(...)
		local self = setmetatable({}, TextareaRowsValidation)
		return self:constructor(...) or self
	end
	function TextareaRowsValidation:constructor()
	end
	function TextareaRowsValidation:wholePixelField(showCount)
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT, showCount), function(mounted)
			local view = waitForMounted(mounted.host)
			Assert:equal(view.field.Size.Y.Offset, FIELD_HEIGHT, `Expected the computed field height to be {FIELD_HEIGHT}, got {view.field.Size.Y.Offset}`)
			Assert:equal(view.field.AbsoluteSize.Y, FIELD_HEIGHT, `Expected {describeGui(view.field)} to render {FIELD_HEIGHT}px tall`)
			local expectedRoot = if showCount then ROOT_WITH_COUNT else FIELD_HEIGHT
			Assert:equal(view.root.AbsoluteSize.Y, expectedRoot, `Expected {describeGui(view.root)} to be {expectedRoot}px tall`)
		end)
	end
	function TextareaRowsValidation:unitScale()
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), function(mounted)
			local view = waitForMounted(mounted.host)
			waitForLayout(function()
				return if view.frame.AbsoluteCanvasSize.Y > view.frame.AbsoluteWindowSize.Y then true else nil
			end, "Timed out waiting for 40 lines to overflow the four-row field")
			settleFrames(3)
			local padding = SpacingHelper:GetResolvedPadding(DefaultTheme, {})
			local measure = findDescendant(view.field, "TextMeasure")
			local canvas = findDescendant(view.frame, "Canvas")
			local expected = resolveTextareaWholePixels(measure.TextBounds.Y + padding.top + padding.bottom)
			Assert:equal(canvas.Size.Y.Offset, expected, `Expected the canvas to be ceil({measure.TextBounds.Y} + {padding.top} + {padding.bottom}) = {expected} at scale 1, got {canvas.Size.Y.Offset}`)
		end)
	end
	function TextareaRowsValidation:probesMatchTextBox(width)
		withMounted(width, HOST_HEIGHT, textarea(LONG_TEXT, true), function(mounted)
			local view = waitForMounted(mounted.host)
			local boxWidth = view.box.AbsoluteSize.X
			for _, name in { "TextMeasure", "CaretProbe", "LineProbe" } do
				local label = findDescendant(view.field, name)
				Assert:equal(label.Size.X.Offset, boxWidth, `Host {width}: expected {name} to be {boxWidth}px wide like the TextBox, got {label.Size.X.Offset}`)
				Assert:equal(label.AbsoluteSize.X, boxWidth, `Host {width}: expected {name} to render {boxWidth}px wide, got {label.AbsoluteSize.X}`)
			end
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Four default-theme rows render a 125px field, and with showCount a 155px root")
	local _decorator_2 = Each({ { false }, { true } })
	local _descriptor = Test(TextareaRowsValidation, "wholePixelField", {
		value = TextareaRowsValidation.wholePixelField,
	})
	if _descriptor then
		TextareaRowsValidation.wholePixelField = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextareaRowsValidation, "wholePixelField", {
		value = TextareaRowsValidation.wholePixelField,
	})
	if _descriptor_1 then
		TextareaRowsValidation.wholePixelField = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextareaRowsValidation, "wholePixelField", {
		value = TextareaRowsValidation.wholePixelField,
	})
	if _descriptor_2 then
		TextareaRowsValidation.wholePixelField = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextareaRowsValidation, "wholePixelField", {
		value = TextareaRowsValidation.wholePixelField,
	})
	if _descriptor_3 then
		TextareaRowsValidation.wholePixelField = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With four rows the canvas is the unscaled measured text plus padding, so the scale used is exactly 1")
	local _descriptor_4 = Test(TextareaRowsValidation, "unitScale", {
		value = TextareaRowsValidation.unitScale,
	})
	if _descriptor_4 then
		TextareaRowsValidation.unitScale = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TextareaRowsValidation, "unitScale", {
		value = TextareaRowsValidation.unitScale,
	})
	if _descriptor_5 then
		TextareaRowsValidation.unitScale = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextareaRowsValidation, "unitScale", {
		value = TextareaRowsValidation.unitScale,
	})
	if _descriptor_6 then
		TextareaRowsValidation.unitScale = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("TextMeasure and CaretProbe are exactly as wide as the rendered TextBox at odd and even host widths")
	local _decorator_7 = Each({ { 289 }, { 300 }, { 301 } })
	local _descriptor_7 = Test(TextareaRowsValidation, "probesMatchTextBox", {
		value = TextareaRowsValidation.probesMatchTextBox,
	})
	if _descriptor_7 then
		TextareaRowsValidation.probesMatchTextBox = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(TextareaRowsValidation, "probesMatchTextBox", {
		value = TextareaRowsValidation.probesMatchTextBox,
	})
	if _descriptor_8 then
		TextareaRowsValidation.probesMatchTextBox = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(TextareaRowsValidation, "probesMatchTextBox", {
		value = TextareaRowsValidation.probesMatchTextBox,
	})
	if _descriptor_9 then
		TextareaRowsValidation.probesMatchTextBox = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(TextareaRowsValidation, "probesMatchTextBox", {
		value = TextareaRowsValidation.probesMatchTextBox,
	})
	if _descriptor_10 then
		TextareaRowsValidation.probesMatchTextBox = _descriptor_10.value
	end
	TextareaRowsValidation = Tag("Studio")(TextareaRowsValidation) or TextareaRowsValidation
end
return TextareaRowsValidation
