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
local FIELD_HEIGHT = 160
local RERENDERS = 5
local function longText(lines)
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
			if not (index <= lines) then
				break
			end
			local _arg0 = `Line {index}`
			table.insert(parts, _arg0)
		end
	end
	return table.concat(parts, "\n")
end
local LONG_TEXT = longText(40)
local function textarea(value, controlled)
	return React.createElement(Textarea, {
		value = value,
		height = FIELD_HEIGHT,
		controlled = controlled,
	})
end
local function waitForRoot(host)
	return waitForGuiObject(host, "Textarea")
end
local function waitForField(root)
	return waitForGuiObject(root, "Field", function(gui)
		return gui.AbsoluteSize.Y == FIELD_HEIGHT
	end, `Timed out waiting for the Textarea Field to be {FIELD_HEIGHT}px tall`)
end
local function findScrollingFrame(root)
	local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
	Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
	return frame
end
local function describeCanvas(frame)
	local box = frame:FindFirstChild("TextBox", true)
	local boxState = if box == nil then "no TextBox" else `TextBox Size={box.Size}, AbsoluteSize={box.AbsoluteSize}, TextBounds={box.TextBounds}`
	return `canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y}, CanvasSize={frame.CanvasSize}, AutomaticCanvasSize={frame.AutomaticCanvasSize}, {boxState}`
end
local function waitForOverflow(root)
	local frame = findScrollingFrame(root)
	for attempt = 0, 29 do
		if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then
			return frame
		end
		task.wait()
	end
	return Assert:fail(`Timed out waiting for the canvas to overflow the window ({describeCanvas(frame)})`)
end
local function waitForWindow(root)
	local frame = findScrollingFrame(root)
	waitForLayout(function()
		return if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > 0 then true else nil
	end, `Timed out waiting for the ScrollingFrame to lay out (canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y})`)
	return frame
end
local function assertOverflowing(frame, label)
	Assert["true"](Assert, frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y, `{label}: expected the canvas ({frame.AbsoluteCanvasSize.Y}) to exceed the window ({frame.AbsoluteWindowSize.Y})`)
	Assert["true"](Assert, frame.ScrollBarThickness > 0, `{label}: expected a visible scrollbar, ScrollBarThickness is {frame.ScrollBarThickness}`)
end
local function assertHeight(gui, expected, label)
	Assert:equal(gui.AbsoluteSize.Y, expected, `{label}: expected {describeGui(gui)} to be {expected}px tall, got {gui.AbsoluteSize.Y}`)
end
local TextareaMountValidation
do
	TextareaMountValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaMountValidation"
		end,
	})
	TextareaMountValidation.__index = TextareaMountValidation
	function TextareaMountValidation.new(...)
		local self = setmetatable({}, TextareaMountValidation)
		return self:constructor(...) or self
	end
	function TextareaMountValidation:constructor()
	end
	function TextareaMountValidation:fixedHeightOverflow()
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), function(mounted)
			local root = waitForRoot(mounted.host)
			local field = waitForField(root)
			local frame = waitForOverflow(root)
			settleFrames(3)
			assertHeight(field, FIELD_HEIGHT, "Field")
			assertHeight(root, FIELD_HEIGHT, "Root without showCount")
			assertOverflowing(frame, "Initial mount")
		end)
	end
	function TextareaMountValidation:noToggle()
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(LONG_TEXT), function(mounted)
			local root = waitForRoot(mounted.host)
			local field = waitForField(root)
			local frame = waitForOverflow(root)
			settleFrames(3)
			local content = findDescendant(frame, "ScrollerContent")
			local contentWidth = content.AbsoluteSize.X
			local canvasHeight = frame.AbsoluteCanvasSize.Y
			for pass = 1, RERENDERS do
				mounted.update(textarea(LONG_TEXT))
				settleFrames(3)
				local label = `Re-render {pass}`
				assertOverflowing(frame, label)
				Assert:equal(content.AbsoluteSize.X, contentWidth, `{label}: expected ScrollerContent to stay {contentWidth}px wide, got {content.AbsoluteSize.X}`)
				Assert:equal(frame.AbsoluteCanvasSize.Y, canvasHeight, `{label}: expected the canvas to stay {canvasHeight}px tall, got {frame.AbsoluteCanvasSize.Y}`)
				assertHeight(field, FIELD_HEIGHT, label)
				assertHeight(root, FIELD_HEIGHT, label)
			end
		end)
	end
	function TextareaMountValidation:shortNoScrollbar(value)
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(value), function(mounted)
			local root = waitForRoot(mounted.host)
			local field = waitForField(root)
			local frame = waitForWindow(root)
			settleFrames(5)
			assertHeight(field, FIELD_HEIGHT, "Field")
			Assert["true"](Assert, frame.AbsoluteCanvasSize.Y <= frame.AbsoluteWindowSize.Y, `Expected the canvas ({frame.AbsoluteCanvasSize.Y}) not to exceed the window ({frame.AbsoluteWindowSize.Y})`)
		end)
	end
	function TextareaMountValidation:stableWrapWidth()
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea("Hello", true), function(mounted)
			local root = waitForRoot(mounted.host)
			waitForField(root)
			local frame = waitForWindow(root)
			settleFrames(3)
			local content = findDescendant(frame, "ScrollerContent")
			local box = findDescendant(frame, "TextBox")
			local contentWidth = content.AbsoluteSize.X
			local boxWidth = box.AbsoluteSize.X
			Assert["true"](Assert, boxWidth > 0, `Expected the TextBox to have a width, got {boxWidth}`)
			mounted.update(textarea(LONG_TEXT, true))
			waitForOverflow(root)
			settleFrames(3)
			Assert:equal(content.AbsoluteSize.X, contentWidth, `Expected ScrollerContent to stay {contentWidth}px wide, got {content.AbsoluteSize.X}`)
			Assert:equal(box.AbsoluteSize.X, boxWidth, `Expected the TextBox to stay {boxWidth}px wide, got {box.AbsoluteSize.X}`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Forty lines in a 160px textarea keep the field and root at 160px and show a scrollbar")
	local _descriptor = Test(TextareaMountValidation, "fixedHeightOverflow", {
		value = TextareaMountValidation.fixedHeightOverflow,
	})
	if _descriptor then
		TextareaMountValidation.fixedHeightOverflow = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaMountValidation, "fixedHeightOverflow", {
		value = TextareaMountValidation.fixedHeightOverflow,
	})
	if _descriptor_1 then
		TextareaMountValidation.fixedHeightOverflow = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaMountValidation, "fixedHeightOverflow", {
		value = TextareaMountValidation.fixedHeightOverflow,
	})
	if _descriptor_2 then
		TextareaMountValidation.fixedHeightOverflow = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Re-rendering the same long value never toggles the scrollbar or changes the content width")
	local _descriptor_3 = Test(TextareaMountValidation, "noToggle", {
		value = TextareaMountValidation.noToggle,
	})
	if _descriptor_3 then
		TextareaMountValidation.noToggle = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextareaMountValidation, "noToggle", {
		value = TextareaMountValidation.noToggle,
	})
	if _descriptor_4 then
		TextareaMountValidation.noToggle = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextareaMountValidation, "noToggle", {
		value = TextareaMountValidation.noToggle,
	})
	if _descriptor_5 then
		TextareaMountValidation.noToggle = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Empty and single-line values fit the field, so the canvas is no taller than the window")
	local _decorator_6 = Each({ { "" }, { "Hello" } })
	local _descriptor_6 = Test(TextareaMountValidation, "shortNoScrollbar", {
		value = TextareaMountValidation.shortNoScrollbar,
	})
	if _descriptor_6 then
		TextareaMountValidation.shortNoScrollbar = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(TextareaMountValidation, "shortNoScrollbar", {
		value = TextareaMountValidation.shortNoScrollbar,
	})
	if _descriptor_7 then
		TextareaMountValidation.shortNoScrollbar = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(TextareaMountValidation, "shortNoScrollbar", {
		value = TextareaMountValidation.shortNoScrollbar,
	})
	if _descriptor_8 then
		TextareaMountValidation.shortNoScrollbar = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(TextareaMountValidation, "shortNoScrollbar", {
		value = TextareaMountValidation.shortNoScrollbar,
	})
	if _descriptor_9 then
		TextareaMountValidation.shortNoScrollbar = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Growing a controlled value from short to overflowing keeps the content and TextBox widths")
	local _descriptor_10 = Test(TextareaMountValidation, "stableWrapWidth", {
		value = TextareaMountValidation.stableWrapWidth,
	})
	if _descriptor_10 then
		TextareaMountValidation.stableWrapWidth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(TextareaMountValidation, "stableWrapWidth", {
		value = TextareaMountValidation.stableWrapWidth,
	})
	if _descriptor_11 then
		TextareaMountValidation.stableWrapWidth = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(TextareaMountValidation, "stableWrapWidth", {
		value = TextareaMountValidation.stableWrapWidth,
	})
	if _descriptor_12 then
		TextareaMountValidation.stableWrapWidth = _descriptor_12.value
	end
	TextareaMountValidation = Tag("Studio")(TextareaMountValidation) or TextareaMountValidation
end
return TextareaMountValidation
