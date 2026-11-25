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
local Textarea = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea").Textarea
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 200
local HOST_HEIGHT = 300
local FILLER = "go"
local LAST_WORD = "wrapping"
local CARET_OFFSET = 2
local MAX_FILLERS = 40
local RULER_FRAMES = 3
local BOUNDS_TOLERANCE = 0.5
local SCROLL_TOLERANCE = 1
local SCROLL_FRAMES = 60
local function textarea(value)
	return React.createElement(Textarea, {
		value = value,
		rows = 1,
		controlled = true,
	})
end
local function measure(ruler, text)
	ruler.Text = text
	settleFrames(RULER_FRAMES)
	return ruler.TextBounds.Y
end
local function findWrappingText(probe, lineHeight)
	local ruler = probe:Clone()
	ruler.Name = "Ruler"
	ruler.Parent = probe.Parent
	local _exitType, _returns = TS.try(function()
		local filler = FILLER
		for count = 1, MAX_FILLERS do
			local text = `{filler} {LAST_WORD}`
			local prefix = `{filler} {string.sub(LAST_WORD, 1, CARET_OFFSET)}`
			local fullBounds = measure(ruler, text)
			if fullBounds > lineHeight + BOUNDS_TOLERANCE then
				local prefixBounds = measure(ruler, prefix)
				Assert["true"](Assert, prefixBounds <= lineHeight + BOUNDS_TOLERANCE, `Fixture: expected {prefix} to fit on one line ({prefixBounds} vs line {lineHeight}) once {text} wraps ({fullBounds})`)
				return TS.TRY_RETURN, { {
					text = text,
					cursor = #prefix + 1,
					prefixBounds = prefixBounds,
					fullBounds = fullBounds,
				} }
			end
			filler = `{filler} {FILLER}`
		end
	end, nil, function()
		ruler:Destroy()
	end)
	if _exitType then
		return unpack(_returns)
	end
	return Assert:fail(`Fixture: no filler count up to {MAX_FILLERS} made {LAST_WORD} wrap at wrap width {probe.Size.X.Offset}`)
end
local function focus(box)
	box:CaptureFocus()
	waitForLayout(function()
		return if box:IsFocused() then true else nil
	end, "Timed out waiting for CaptureFocus to focus the Textarea TextBox; focus may be unavailable in this test runner")
	settleFrames(2)
end
local function maxScroll(frame)
	return math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y)
end
local function describeScroll(frame)
	return `CanvasPosition.Y {frame.CanvasPosition.Y}, canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y}, max {maxScroll(frame)}`
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
local function waitForProbe(probe, wrapping)
	for attempt = 0, SCROLL_FRAMES - 1 do
		if probe.Text == wrapping.text and math.abs(probe.TextBounds.Y - wrapping.fullBounds) <= BOUNDS_TOLERANCE then
			return nil
		end
		task.wait()
	end
	Assert:fail(`Expected CaretProbe to measure the whole last word ({wrapping.fullBounds}), got {probe.TextBounds.Y} for {#probe.Text} of {#wrapping.text} bytes; up to the caret alone is {wrapping.prefixBounds}`)
end
local TextareaCaretLineValidation
do
	TextareaCaretLineValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaCaretLineValidation"
		end,
	})
	TextareaCaretLineValidation.__index = TextareaCaretLineValidation
	function TextareaCaretLineValidation.new(...)
		local self = setmetatable({}, TextareaCaretLineValidation)
		return self:constructor(...) or self
	end
	function TextareaCaretLineValidation:constructor()
	end
	function TextareaCaretLineValidation:wrappedWordCaret()
		withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(""), function(mounted)
			local root = waitForGuiObject(mounted.host, "Textarea")
			local field = waitForGuiObject(root, "Field")
			local probe = findDescendant(field, "CaretProbe")
			local lineProbe = findDescendant(field, "LineProbe")
			waitForLayout(function()
				return if probe.Size.X.Offset > 0 and lineProbe.TextBounds.Y > 0 then true else nil
			end, `Timed out waiting for the probes to get a wrap width and a line height (width {probe.Size.X.Offset}, line {lineProbe.TextBounds.Y})`)
			local lineHeight = lineProbe.TextBounds.Y
			local wrapping = findWrappingText(probe, lineHeight)
			mounted.update(textarea(wrapping.text))
			local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
			Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
			waitForLayout(function()
				return if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then true else nil
			end, `Timed out waiting for the two-line text to overflow the one-row field ({describeScroll(frame)})`)
			settleFrames(3)
			local box = findDescendant(frame, "TextBox")
			focus(box)
			box.CursorPosition = 1
			waitForScrollY(frame, function()
				return 0
			end, "Expected the caret at the start to keep the view at the top")
			box.CursorPosition = wrapping.cursor
			waitForProbe(probe, wrapping)
			Assert["true"](Assert, probe.TextBounds.Y > lineHeight + BOUNDS_TOLERANCE, `Expected the caret line bottom to span more than one line ({probe.TextBounds.Y} vs line {lineHeight})`)
			waitForScrollY(frame, function()
				return maxScroll(frame)
			end, "Expected caret follow to scroll the wrapped line fully into view")
			Assert["true"](Assert, maxScroll(frame) > 0, `Expected a positive maximum scroll ({describeScroll(frame)})`)
			Assert["true"](Assert, frame.CanvasPosition.Y + frame.AbsoluteWindowSize.Y >= frame.AbsoluteCanvasSize.Y - SCROLL_TOLERANCE, `Expected the bottom of the canvas, the wrapped line and its padding, to be in view ({describeScroll(frame)})`)
			box:ReleaseFocus()
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A caret in the wrapped part of the last word measures two lines and scrolls that line fully into view")
	local _descriptor = Test(TextareaCaretLineValidation, "wrappedWordCaret", {
		value = TextareaCaretLineValidation.wrappedWordCaret,
	})
	if _descriptor then
		TextareaCaretLineValidation.wrappedWordCaret = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaCaretLineValidation, "wrappedWordCaret", {
		value = TextareaCaretLineValidation.wrappedWordCaret,
	})
	if _descriptor_1 then
		TextareaCaretLineValidation.wrappedWordCaret = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaCaretLineValidation, "wrappedWordCaret", {
		value = TextareaCaretLineValidation.wrappedWordCaret,
	})
	if _descriptor_2 then
		TextareaCaretLineValidation.wrappedWordCaret = _descriptor_2.value
	end
	TextareaCaretLineValidation = Tag("Studio")(TextareaCaretLineValidation) or TextareaCaretLineValidation
end
return TextareaCaretLineValidation
