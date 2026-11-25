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
local HOST_WIDTH = 600
local HOST_HEIGHT = 700
local DESIGN_WIDTH = 300
local DESIGN_HEIGHT = 400
local FIELD_HEIGHT = 160
local SIZE_TOLERANCE = 0.5
local SCROLL_TOLERANCE = 1
local SCROLL_FRAMES = 60
local USER_SCROLL_FRAMES = 15
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
local function scaledTextarea(scale)
	return React.createElement("frame", {
		key = "Scaled",
		Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT),
		BackgroundTransparency = 1,
	}, React.createElement("uiscale", {
		key = "TestScale",
		Scale = scale,
	}), React.createElement(Textarea, {
		value = LONG_TEXT,
		height = FIELD_HEIGHT,
	}))
end
local function waitForScaled(host, scale)
	local expected = FIELD_HEIGHT * scale
	local root = waitForGuiObject(host, "Textarea")
	local field = waitForGuiObject(root, "Field", function(gui)
		return math.abs(gui.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE
	end, `Timed out waiting for the Textarea Field to be {expected}px tall at scale {scale}`)
	local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
	Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
	waitForLayout(function()
		return if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then true else nil
	end, `Timed out waiting for the canvas to overflow at scale {scale} (canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y})`)
	settleFrames(3)
	return {
		root = root,
		field = field,
		frame = frame,
		box = findDescendant(frame, "TextBox"),
	}
end
local function maxScroll(frame)
	return math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y)
end
local function describeScroll(frame)
	return `CanvasPosition.Y {frame.CanvasPosition.Y}, canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y}, max {maxScroll(frame)}`
end
local function focus(box)
	box:CaptureFocus()
	waitForLayout(function()
		return if box:IsFocused() then true else nil
	end, "Timed out waiting for CaptureFocus to focus the Textarea TextBox; focus may be unavailable in this test runner")
	settleFrames(2)
end
local function waitForScrollY(frame, target, message)
	for attempt = 0, SCROLL_FRAMES - 1 do
		if math.abs(frame.CanvasPosition.Y - target()) <= SCROLL_TOLERANCE then
			return nil
		end
		task.wait()
	end
	Assert:fail(`{message} (target {target()}, {describeScroll(frame)})`)
end
local function moveCaretToEnd(mounted, scale)
	mounted.box.CursorPosition = #mounted.box.Text + 1
	waitForScrollY(mounted.frame, function()
		return maxScroll(mounted.frame)
	end, `Scale {scale}: expected the caret at the end to scroll to the bottom`)
end
local function moveCaretToStart(mounted, scale)
	mounted.box.CursorPosition = 1
	waitForScrollY(mounted.frame, function()
		return 0
	end, `Scale {scale}: expected the caret at the start to scroll back to the top`)
end
local TextareaScaleValidation
do
	TextareaScaleValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaScaleValidation"
		end,
	})
	TextareaScaleValidation.__index = TextareaScaleValidation
	function TextareaScaleValidation.new(...)
		local self = setmetatable({}, TextareaScaleValidation)
		return self:constructor(...) or self
	end
	function TextareaScaleValidation:constructor()
	end
	function TextareaScaleValidation:scaledField(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), function(host)
			local mounted = waitForScaled(host.host, scale)
			local expected = FIELD_HEIGHT * scale
			Assert["true"](Assert, math.abs(mounted.field.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE, `Scale {scale}: expected {describeGui(mounted.field)} to be {expected}px tall, got {mounted.field.AbsoluteSize.Y}`)
			Assert["true"](Assert, mounted.frame.AbsoluteCanvasSize.Y > mounted.frame.AbsoluteWindowSize.Y, `Scale {scale}: expected the canvas ({mounted.frame.AbsoluteCanvasSize.Y}) to exceed the window ({mounted.frame.AbsoluteWindowSize.Y})`)
		end)
	end
	function TextareaScaleValidation:caretFollowsScaled(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), function(host)
			local mounted = waitForScaled(host.host, scale)
			focus(mounted.box)
			moveCaretToEnd(mounted, scale)
			Assert["true"](Assert, maxScroll(mounted.frame) > 0, `Scale {scale}: expected a positive maximum scroll ({describeScroll(mounted.frame)})`)
			moveCaretToStart(mounted, scale)
			mounted.box:ReleaseFocus()
		end)
	end
	function TextareaScaleValidation:userScrollStays(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), function(host)
			local mounted = waitForScaled(host.host, scale)
			local frame = mounted.frame
			focus(mounted.box)
			moveCaretToEnd(mounted, scale)
			moveCaretToStart(mounted, scale)
			settleFrames(3)
			local userY = math.floor(maxScroll(frame) / 2)
			Assert["true"](Assert, userY > 0, `Scale {scale}: expected room to scroll ({describeScroll(frame)})`)
			frame.CanvasPosition = Vector2.new(frame.CanvasPosition.X, userY)
			settleFrames(USER_SCROLL_FRAMES)
			Assert["true"](Assert, mounted.box:IsFocused(), `Scale {scale}: expected the TextBox to still be focused`)
			Assert["true"](Assert, math.abs(frame.CanvasPosition.Y - userY) <= SCROLL_TOLERANCE, `Scale {scale}: expected the user scroll to stay at {userY} ({describeScroll(frame)})`)
			mounted.box:ReleaseFocus()
		end)
	end
	function TextareaScaleValidation:measureOutOfLayout(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale), function(host)
			local mounted = waitForScaled(host.host, scale)
			local measure = findDescendant(mounted.field, "Measure")
			local textMeasure = findDescendant(measure, "TextMeasure")
			Assert["false"](Assert, measure.Visible, "Expected the Measure frame to be hidden")
			Assert["true"](Assert, textMeasure.TextBounds.Y > mounted.field.AbsoluteSize.Y, `Scale {scale}: expected TextMeasure to measure the full text ({textMeasure.TextBounds.Y}) past the field ({mounted.field.AbsoluteSize.Y})`)
			Assert["true"](Assert, math.abs(mounted.root.AbsoluteSize.Y - mounted.field.AbsoluteSize.Y) <= SIZE_TOLERANCE, `Scale {scale}: expected {describeGui(mounted.root)} to stay at the field height {mounted.field.AbsoluteSize.Y}, got {mounted.root.AbsoluteSize.Y}`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Under a plain UIScale the 160px field lays out at 160 times the scale and the canvas still overflows")
	local _decorator_2 = Each({ { 0.75 }, { 1 }, { 1.5 } })
	local _descriptor = Test(TextareaScaleValidation, "scaledField", {
		value = TextareaScaleValidation.scaledField,
	})
	if _descriptor then
		TextareaScaleValidation.scaledField = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextareaScaleValidation, "scaledField", {
		value = TextareaScaleValidation.scaledField,
	})
	if _descriptor_1 then
		TextareaScaleValidation.scaledField = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextareaScaleValidation, "scaledField", {
		value = TextareaScaleValidation.scaledField,
	})
	if _descriptor_2 then
		TextareaScaleValidation.scaledField = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextareaScaleValidation, "scaledField", {
		value = TextareaScaleValidation.scaledField,
	})
	if _descriptor_3 then
		TextareaScaleValidation.scaledField = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With focus, a caret at the end scrolls to the maximum and a caret at position 1 scrolls back to 0")
	local _decorator_5 = Each({ { 0.75 }, { 1 }, { 1.5 } })
	local _descriptor_4 = Test(TextareaScaleValidation, "caretFollowsScaled", {
		value = TextareaScaleValidation.caretFollowsScaled,
	})
	if _descriptor_4 then
		TextareaScaleValidation.caretFollowsScaled = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(TextareaScaleValidation, "caretFollowsScaled", {
		value = TextareaScaleValidation.caretFollowsScaled,
	})
	if _descriptor_5 then
		TextareaScaleValidation.caretFollowsScaled = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(TextareaScaleValidation, "caretFollowsScaled", {
		value = TextareaScaleValidation.caretFollowsScaled,
	})
	if _descriptor_6 then
		TextareaScaleValidation.caretFollowsScaled = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(TextareaScaleValidation, "caretFollowsScaled", {
		value = TextareaScaleValidation.caretFollowsScaled,
	})
	if _descriptor_7 then
		TextareaScaleValidation.caretFollowsScaled = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A mid-canvas scroll made while focused is not pulled back to the caret over the following frames")
	local _decorator_8 = Each({ { 0.75 }, { 1 }, { 1.5 } })
	local _descriptor_8 = Test(TextareaScaleValidation, "userScrollStays", {
		value = TextareaScaleValidation.userScrollStays,
	})
	if _descriptor_8 then
		TextareaScaleValidation.userScrollStays = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_8(TextareaScaleValidation, "userScrollStays", {
		value = TextareaScaleValidation.userScrollStays,
	})
	if _descriptor_9 then
		TextareaScaleValidation.userScrollStays = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextareaScaleValidation, "userScrollStays", {
		value = TextareaScaleValidation.userScrollStays,
	})
	if _descriptor_10 then
		TextareaScaleValidation.userScrollStays = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextareaScaleValidation, "userScrollStays", {
		value = TextareaScaleValidation.userScrollStays,
	})
	if _descriptor_11 then
		TextareaScaleValidation.userScrollStays = _descriptor_11.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("The 100000px measuring labels in the hidden Measure frame never stretch the root past the field")
	local _decorator_11 = Each({ { 0.75 }, { 1 }, { 1.5 } })
	local _descriptor_12 = Test(TextareaScaleValidation, "measureOutOfLayout", {
		value = TextareaScaleValidation.measureOutOfLayout,
	})
	if _descriptor_12 then
		TextareaScaleValidation.measureOutOfLayout = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_11(TextareaScaleValidation, "measureOutOfLayout", {
		value = TextareaScaleValidation.measureOutOfLayout,
	})
	if _descriptor_13 then
		TextareaScaleValidation.measureOutOfLayout = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TextareaScaleValidation, "measureOutOfLayout", {
		value = TextareaScaleValidation.measureOutOfLayout,
	})
	if _descriptor_14 then
		TextareaScaleValidation.measureOutOfLayout = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TextareaScaleValidation, "measureOutOfLayout", {
		value = TextareaScaleValidation.measureOutOfLayout,
	})
	if _descriptor_15 then
		TextareaScaleValidation.measureOutOfLayout = _descriptor_15.value
	end
	TextareaScaleValidation = Tag("Studio")(TextareaScaleValidation) or TextareaScaleValidation
end
return TextareaScaleValidation
