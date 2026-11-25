-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Each = _binding.Each
local _Textarea_layout = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea.layout")
local TEXTAREA_DEFAULT_ROWS = _Textarea_layout.TEXTAREA_DEFAULT_ROWS
local formatTextareaCount = _Textarea_layout.formatTextareaCount
local resolveTextareaCanvasHeight = _Textarea_layout.resolveTextareaCanvasHeight
local resolveTextareaCaretScroll = _Textarea_layout.resolveTextareaCaretScroll
local resolveTextareaCaretText = _Textarea_layout.resolveTextareaCaretText
local resolveTextareaHeight = _Textarea_layout.resolveTextareaHeight
local resolveTextareaLength = _Textarea_layout.resolveTextareaLength
local resolveTextareaScreenScale = _Textarea_layout.resolveTextareaScreenScale
local resolveTextareaWrapWidth = _Textarea_layout.resolveTextareaWrapWidth
local trimTextareaText = _Textarea_layout.trimTextareaText
local LINE_HEIGHT = 18
local PADDING_TOP = 8
local PADDING_BOTTOM = 6
local E_ACUTE = "\u{E9}"
local GRINNING = "\u{1F600}"
local TextareaLayoutValidation
do
	TextareaLayoutValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaLayoutValidation"
		end,
	})
	TextareaLayoutValidation.__index = TextareaLayoutValidation
	function TextareaLayoutValidation.new(...)
		local self = setmetatable({}, TextareaLayoutValidation)
		return self:constructor(...) or self
	end
	function TextareaLayoutValidation:constructor()
	end
	function TextareaLayoutValidation:rowsHeight(rows)
		Assert:equal(resolveTextareaHeight(nil, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), rows * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:heightBeatsRows()
		Assert:equal(resolveTextareaHeight(160, 10, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), 160)
	end
	function TextareaLayoutValidation:negativeHeight()
		Assert:equal(resolveTextareaHeight(-20, 4, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), 0)
	end
	function TextareaLayoutValidation:rowsFloored(rows, expectedRows)
		Assert:equal(resolveTextareaHeight(nil, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), expectedRows * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:atLeastOneRow(rows)
		Assert:equal(resolveTextareaHeight(nil, rows, LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM), LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:defaultRows()
		Assert:equal(TEXTAREA_DEFAULT_ROWS, 4)
	end
	function TextareaLayoutValidation:canvasForLines(lines)
		Assert:equal(resolveTextareaCanvasHeight(lines * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160), lines * LINE_HEIGHT + PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:canvasFloor(lines)
		Assert:equal(resolveTextareaCanvasHeight(lines * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160), 160)
	end
	function TextareaLayoutValidation:screenScaleRatio(screen, design, expected)
		Assert:equal(resolveTextareaScreenScale(screen, design, 2), expected)
	end
	function TextareaLayoutValidation:screenScaleFallback(screen, design)
		Assert:equal(resolveTextareaScreenScale(screen, design, 1.25), 1.25)
	end
	function TextareaLayoutValidation:screenScaleBadFallback(fallback)
		Assert:equal(resolveTextareaScreenScale(0, 160, fallback), 1)
	end
	function TextareaLayoutValidation:canvasNoViewport()
		Assert:equal(resolveTextareaCanvasHeight(36, PADDING_TOP, PADDING_BOTTOM), 36 + PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:canvasBadText(textHeight)
		Assert:equal(resolveTextareaCanvasHeight(textHeight, PADDING_TOP, PADDING_BOTTOM, 160), 160)
		Assert:equal(resolveTextareaCanvasHeight(textHeight, PADDING_TOP, PADDING_BOTTOM), PADDING_TOP + PADDING_BOTTOM)
	end
	function TextareaLayoutValidation:wrapWidth(field, left, right, gutter, expected)
		Assert:equal(resolveTextareaWrapWidth(field, left, right, gutter), expected)
	end
	function TextareaLayoutValidation:wrapIgnoresOverflow()
		local fitting = resolveTextareaCanvasHeight(LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160)
		local before = resolveTextareaWrapWidth(300, 8, 8, 12)
		local overflowing = resolveTextareaCanvasHeight(40 * LINE_HEIGHT, PADDING_TOP, PADDING_BOTTOM, 160)
		local after = resolveTextareaWrapWidth(300, 8, 8, 12)
		Assert:equal(fitting, 160, "Expected the short text to fit the viewport")
		Assert["true"](Assert, overflowing > 160, `Expected the long text canvas {overflowing} to overflow the 160px viewport`)
		Assert:equal(after, before, "Expected the wrap width not to change once the content overflows")
		Assert:equal(after, 300 - 8 - 8 - 12)
	end
	function TextareaLayoutValidation:negativeGutter()
		Assert:equal(resolveTextareaWrapWidth(300, 8, 8, -5), 284)
	end
	function TextareaLayoutValidation:wrapNotNegative()
		Assert:equal(resolveTextareaWrapWidth(10, 8, 8, 12), 0)
	end
	function TextareaLayoutValidation:scrollsDown()
		Assert:equal(resolveTextareaCaretScroll(150, 170, 0, 100), 70)
	end
	function TextareaLayoutValidation:scrollsDownPartial()
		Assert:equal(resolveTextareaCaretScroll(90, 110, 0, 100), 10)
	end
	function TextareaLayoutValidation:scrollsUp()
		Assert:equal(resolveTextareaCaretScroll(50, 70, 200, 100), 50)
	end
	function TextareaLayoutValidation:scrollsUpClamped()
		Assert:equal(resolveTextareaCaretScroll(-5, 15, 10, 100), 0)
	end
	function TextareaLayoutValidation:visibleUnchanged(top, bottom, canvasY)
		Assert:equal(resolveTextareaCaretScroll(top, bottom, canvasY, 100), canvasY)
	end
	function TextareaLayoutValidation:tallLineTop()
		Assert:equal(resolveTextareaCaretScroll(300, 450, 0, 100), 300)
	end
	function TextareaLayoutValidation:caretUndefined(cursor)
		Assert:undefined(resolveTextareaCaretText("hello", cursor))
	end
	function TextareaLayoutValidation:caretPrefix()
		Assert:equal(resolveTextareaCaretText("hello world", 6), "hello")
	end
	function TextareaLayoutValidation:caretAtStart()
		Assert:equal(resolveTextareaCaretText("hello", 1), " ")
	end
	function TextareaLayoutValidation:caretAfterNewline()
		Assert:equal(resolveTextareaCaretText("one\ntwo\n", 9), "one\ntwo\n ")
	end
	function TextareaLayoutValidation:caretMultibyte()
		local text = `h{E_ACUTE}llo`
		Assert:equal(resolveTextareaCaretText(text, 4), `h{E_ACUTE}`)
		Assert:equal(resolveTextareaCaretText(`{GRINNING}a`, 5), GRINNING)
	end
	function TextareaLayoutValidation:caretPastEnd()
		Assert:equal(resolveTextareaCaretText("ab", 10), "ab")
	end
	function TextareaLayoutValidation:lengthCodePoints(text, expected)
		Assert:equal(resolveTextareaLength(text), expected)
	end
	function TextareaLayoutValidation:lengthInvalid()
		Assert:equal(resolveTextareaLength(`a{string.char(0xff)}b`), 3)
	end
	function TextareaLayoutValidation:trimNoLimit()
		Assert:equal(trimTextareaText("hello world"), "hello world")
	end
	function TextareaLayoutValidation:trimWithin(limit)
		Assert:equal(trimTextareaText(`h{E_ACUTE}llo`, limit), `h{E_ACUTE}llo`)
	end
	function TextareaLayoutValidation:trimCuts()
		Assert:equal(trimTextareaText("hello world", 5), "hello")
	end
	function TextareaLayoutValidation:trimMultibyte()
		Assert:equal(trimTextareaText(`h{E_ACUTE}llo`, 2), `h{E_ACUTE}`)
		Assert:equal(trimTextareaText(`{GRINNING}{GRINNING}{GRINNING}`, 2), `{GRINNING}{GRINNING}`)
	end
	function TextareaLayoutValidation:trimLimitEdges()
		Assert:equal(trimTextareaText("hello", 0), "")
		Assert:equal(trimTextareaText("hello", 2.7), "he")
	end
	function TextareaLayoutValidation:countPlain(length, expected)
		Assert:equal(formatTextareaCount(length), expected)
	end
	function TextareaLayoutValidation:countWithLimit(length, limit, expected)
		Assert:equal(formatTextareaCount(length, limit), expected)
	end
	local _decorator = DisplayName("Without a height, the field is rows times the line height plus top and bottom padding")
	local _decorator_1 = Each({ { 1 }, { 2 }, { 4 }, { 10 } })
	local _descriptor = Test(TextareaLayoutValidation, "rowsHeight", {
		value = TextareaLayoutValidation.rowsHeight,
	})
	if _descriptor then
		TextareaLayoutValidation.rowsHeight = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaLayoutValidation, "rowsHeight", {
		value = TextareaLayoutValidation.rowsHeight,
	})
	if _descriptor_1 then
		TextareaLayoutValidation.rowsHeight = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaLayoutValidation, "rowsHeight", {
		value = TextareaLayoutValidation.rowsHeight,
	})
	if _descriptor_2 then
		TextareaLayoutValidation.rowsHeight = _descriptor_2.value
	end
	local _decorator_2 = DisplayName("An explicit pixel height wins over rows, line height and padding")
	local _descriptor_3 = Test(TextareaLayoutValidation, "heightBeatsRows", {
		value = TextareaLayoutValidation.heightBeatsRows,
	})
	if _descriptor_3 then
		TextareaLayoutValidation.heightBeatsRows = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_2(TextareaLayoutValidation, "heightBeatsRows", {
		value = TextareaLayoutValidation.heightBeatsRows,
	})
	if _descriptor_4 then
		TextareaLayoutValidation.heightBeatsRows = _descriptor_4.value
	end
	local _decorator_3 = DisplayName("A negative explicit height is clamped to zero")
	local _descriptor_5 = Test(TextareaLayoutValidation, "negativeHeight", {
		value = TextareaLayoutValidation.negativeHeight,
	})
	if _descriptor_5 then
		TextareaLayoutValidation.negativeHeight = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextareaLayoutValidation, "negativeHeight", {
		value = TextareaLayoutValidation.negativeHeight,
	})
	if _descriptor_6 then
		TextareaLayoutValidation.negativeHeight = _descriptor_6.value
	end
	local _decorator_4 = DisplayName("Fractional rows are floored before multiplying by the line height")
	local _decorator_5 = Each({ { 2.9, 2 }, { 1.01, 1 }, { 4.5, 4 } })
	local _descriptor_7 = Test(TextareaLayoutValidation, "rowsFloored", {
		value = TextareaLayoutValidation.rowsFloored,
	})
	if _descriptor_7 then
		TextareaLayoutValidation.rowsFloored = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(TextareaLayoutValidation, "rowsFloored", {
		value = TextareaLayoutValidation.rowsFloored,
	})
	if _descriptor_8 then
		TextareaLayoutValidation.rowsFloored = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(TextareaLayoutValidation, "rowsFloored", {
		value = TextareaLayoutValidation.rowsFloored,
	})
	if _descriptor_9 then
		TextareaLayoutValidation.rowsFloored = _descriptor_9.value
	end
	local _decorator_6 = DisplayName("Zero, negative, sub-one and NaN rows still give one visible line")
	local _decorator_7 = Each({ { 0 }, { -3 }, { 0.5 }, { 0 / 0 } })
	local _descriptor_10 = Test(TextareaLayoutValidation, "atLeastOneRow", {
		value = TextareaLayoutValidation.atLeastOneRow,
	})
	if _descriptor_10 then
		TextareaLayoutValidation.atLeastOneRow = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_7(TextareaLayoutValidation, "atLeastOneRow", {
		value = TextareaLayoutValidation.atLeastOneRow,
	})
	if _descriptor_11 then
		TextareaLayoutValidation.atLeastOneRow = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(TextareaLayoutValidation, "atLeastOneRow", {
		value = TextareaLayoutValidation.atLeastOneRow,
	})
	if _descriptor_12 then
		TextareaLayoutValidation.atLeastOneRow = _descriptor_12.value
	end
	local _decorator_8 = DisplayName("The exported default row count is four")
	local _descriptor_13 = Test(TextareaLayoutValidation, "defaultRows", {
		value = TextareaLayoutValidation.defaultRows,
	})
	if _descriptor_13 then
		TextareaLayoutValidation.defaultRows = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextareaLayoutValidation, "defaultRows", {
		value = TextareaLayoutValidation.defaultRows,
	})
	if _descriptor_14 then
		TextareaLayoutValidation.defaultRows = _descriptor_14.value
	end
	local _decorator_9 = DisplayName("Text taller than the viewport gives a canvas of N line heights plus top and bottom padding")
	local _decorator_10 = Each({ { 10 }, { 40 }, { 100 } })
	local _descriptor_15 = Test(TextareaLayoutValidation, "canvasForLines", {
		value = TextareaLayoutValidation.canvasForLines,
	})
	if _descriptor_15 then
		TextareaLayoutValidation.canvasForLines = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(TextareaLayoutValidation, "canvasForLines", {
		value = TextareaLayoutValidation.canvasForLines,
	})
	if _descriptor_16 then
		TextareaLayoutValidation.canvasForLines = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_9(TextareaLayoutValidation, "canvasForLines", {
		value = TextareaLayoutValidation.canvasForLines,
	})
	if _descriptor_17 then
		TextareaLayoutValidation.canvasForLines = _descriptor_17.value
	end
	local _decorator_11 = DisplayName("Text shorter than the viewport gives a canvas exactly as tall as the viewport")
	local _decorator_12 = Each({ { 0 }, { 1 }, { 4 } })
	local _descriptor_18 = Test(TextareaLayoutValidation, "canvasFloor", {
		value = TextareaLayoutValidation.canvasFloor,
	})
	if _descriptor_18 then
		TextareaLayoutValidation.canvasFloor = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(TextareaLayoutValidation, "canvasFloor", {
		value = TextareaLayoutValidation.canvasFloor,
	})
	if _descriptor_19 then
		TextareaLayoutValidation.canvasFloor = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_11(TextareaLayoutValidation, "canvasFloor", {
		value = TextareaLayoutValidation.canvasFloor,
	})
	if _descriptor_20 then
		TextareaLayoutValidation.canvasFloor = _descriptor_20.value
	end
	local _decorator_13 = DisplayName("Screen scale is the laid-out height divided by the design height")
	local _decorator_14 = Each({ { 120, 160, 0.75 }, { 160, 160, 1 }, { 240, 160, 1.5 }, { 50, 200, 0.25 } })
	local _descriptor_21 = Test(TextareaLayoutValidation, "screenScaleRatio", {
		value = TextareaLayoutValidation.screenScaleRatio,
	})
	if _descriptor_21 then
		TextareaLayoutValidation.screenScaleRatio = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(TextareaLayoutValidation, "screenScaleRatio", {
		value = TextareaLayoutValidation.screenScaleRatio,
	})
	if _descriptor_22 then
		TextareaLayoutValidation.screenScaleRatio = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_13(TextareaLayoutValidation, "screenScaleRatio", {
		value = TextareaLayoutValidation.screenScaleRatio,
	})
	if _descriptor_23 then
		TextareaLayoutValidation.screenScaleRatio = _descriptor_23.value
	end
	local _decorator_15 = DisplayName("Before layout, a zero, negative or NaN height on either side falls back to the context scale")
	local _decorator_16 = Each({ { 0, 160 }, { 120, 0 }, { 0, 0 }, { -120, 160 }, { 120, -160 }, { 0 / 0, 160 }, { 120, 0 / 0 } })
	local _descriptor_24 = Test(TextareaLayoutValidation, "screenScaleFallback", {
		value = TextareaLayoutValidation.screenScaleFallback,
	})
	if _descriptor_24 then
		TextareaLayoutValidation.screenScaleFallback = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_16(TextareaLayoutValidation, "screenScaleFallback", {
		value = TextareaLayoutValidation.screenScaleFallback,
	})
	if _descriptor_25 then
		TextareaLayoutValidation.screenScaleFallback = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_15(TextareaLayoutValidation, "screenScaleFallback", {
		value = TextareaLayoutValidation.screenScaleFallback,
	})
	if _descriptor_26 then
		TextareaLayoutValidation.screenScaleFallback = _descriptor_26.value
	end
	local _decorator_17 = DisplayName("A zero, negative or NaN fallback scale resolves to one so nothing divides by zero")
	local _decorator_18 = Each({ { 0 }, { -2 }, { 0 / 0 } })
	local _descriptor_27 = Test(TextareaLayoutValidation, "screenScaleBadFallback", {
		value = TextareaLayoutValidation.screenScaleBadFallback,
	})
	if _descriptor_27 then
		TextareaLayoutValidation.screenScaleBadFallback = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_18(TextareaLayoutValidation, "screenScaleBadFallback", {
		value = TextareaLayoutValidation.screenScaleBadFallback,
	})
	if _descriptor_28 then
		TextareaLayoutValidation.screenScaleBadFallback = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_17(TextareaLayoutValidation, "screenScaleBadFallback", {
		value = TextareaLayoutValidation.screenScaleBadFallback,
	})
	if _descriptor_29 then
		TextareaLayoutValidation.screenScaleBadFallback = _descriptor_29.value
	end
	local _decorator_19 = DisplayName("With no viewport height the canvas is just the text height plus padding")
	local _descriptor_30 = Test(TextareaLayoutValidation, "canvasNoViewport", {
		value = TextareaLayoutValidation.canvasNoViewport,
	})
	if _descriptor_30 then
		TextareaLayoutValidation.canvasNoViewport = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_19(TextareaLayoutValidation, "canvasNoViewport", {
		value = TextareaLayoutValidation.canvasNoViewport,
	})
	if _descriptor_31 then
		TextareaLayoutValidation.canvasNoViewport = _descriptor_31.value
	end
	local _decorator_20 = DisplayName("A NaN, infinite or negative text height counts as zero and the viewport floor still applies")
	local _decorator_21 = Each({ { 0 / 0 }, { math.huge }, { -math.huge }, { -50 } })
	local _descriptor_32 = Test(TextareaLayoutValidation, "canvasBadText", {
		value = TextareaLayoutValidation.canvasBadText,
	})
	if _descriptor_32 then
		TextareaLayoutValidation.canvasBadText = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_21(TextareaLayoutValidation, "canvasBadText", {
		value = TextareaLayoutValidation.canvasBadText,
	})
	if _descriptor_33 then
		TextareaLayoutValidation.canvasBadText = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_20(TextareaLayoutValidation, "canvasBadText", {
		value = TextareaLayoutValidation.canvasBadText,
	})
	if _descriptor_34 then
		TextareaLayoutValidation.canvasBadText = _descriptor_34.value
	end
	local _decorator_22 = DisplayName("Wrap width is the field width minus left padding, right padding and gutter")
	local _decorator_23 = Each({ { 300, 8, 8, 12, 272 }, { 400, 12, 4, 16, 368 }, { 200, 0, 0, 0, 200 } })
	local _descriptor_35 = Test(TextareaLayoutValidation, "wrapWidth", {
		value = TextareaLayoutValidation.wrapWidth,
	})
	if _descriptor_35 then
		TextareaLayoutValidation.wrapWidth = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_23(TextareaLayoutValidation, "wrapWidth", {
		value = TextareaLayoutValidation.wrapWidth,
	})
	if _descriptor_36 then
		TextareaLayoutValidation.wrapWidth = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_22(TextareaLayoutValidation, "wrapWidth", {
		value = TextareaLayoutValidation.wrapWidth,
	})
	if _descriptor_37 then
		TextareaLayoutValidation.wrapWidth = _descriptor_37.value
	end
	local _decorator_24 = DisplayName("Wrap width stays identical whether the canvas fits the viewport or overflows it")
	local _descriptor_38 = Test(TextareaLayoutValidation, "wrapIgnoresOverflow", {
		value = TextareaLayoutValidation.wrapIgnoresOverflow,
	})
	if _descriptor_38 then
		TextareaLayoutValidation.wrapIgnoresOverflow = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_24(TextareaLayoutValidation, "wrapIgnoresOverflow", {
		value = TextareaLayoutValidation.wrapIgnoresOverflow,
	})
	if _descriptor_39 then
		TextareaLayoutValidation.wrapIgnoresOverflow = _descriptor_39.value
	end
	local _decorator_25 = DisplayName("A negative gutter is treated as zero")
	local _descriptor_40 = Test(TextareaLayoutValidation, "negativeGutter", {
		value = TextareaLayoutValidation.negativeGutter,
	})
	if _descriptor_40 then
		TextareaLayoutValidation.negativeGutter = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_25(TextareaLayoutValidation, "negativeGutter", {
		value = TextareaLayoutValidation.negativeGutter,
	})
	if _descriptor_41 then
		TextareaLayoutValidation.negativeGutter = _descriptor_41.value
	end
	local _decorator_26 = DisplayName("A field narrower than its padding and gutter gives a zero wrap width")
	local _descriptor_42 = Test(TextareaLayoutValidation, "wrapNotNegative", {
		value = TextareaLayoutValidation.wrapNotNegative,
	})
	if _descriptor_42 then
		TextareaLayoutValidation.wrapNotNegative = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_26(TextareaLayoutValidation, "wrapNotNegative", {
		value = TextareaLayoutValidation.wrapNotNegative,
	})
	if _descriptor_43 then
		TextareaLayoutValidation.wrapNotNegative = _descriptor_43.value
	end
	local _decorator_27 = DisplayName("A caret below the view scrolls down until its bottom sits on the viewport bottom")
	local _descriptor_44 = Test(TextareaLayoutValidation, "scrollsDown", {
		value = TextareaLayoutValidation.scrollsDown,
	})
	if _descriptor_44 then
		TextareaLayoutValidation.scrollsDown = _descriptor_44.value
	end
	local _descriptor_45 = _decorator_27(TextareaLayoutValidation, "scrollsDown", {
		value = TextareaLayoutValidation.scrollsDown,
	})
	if _descriptor_45 then
		TextareaLayoutValidation.scrollsDown = _descriptor_45.value
	end
	local _decorator_28 = DisplayName("A caret partly below the view scrolls down just enough to show its bottom")
	local _descriptor_46 = Test(TextareaLayoutValidation, "scrollsDownPartial", {
		value = TextareaLayoutValidation.scrollsDownPartial,
	})
	if _descriptor_46 then
		TextareaLayoutValidation.scrollsDownPartial = _descriptor_46.value
	end
	local _descriptor_47 = _decorator_28(TextareaLayoutValidation, "scrollsDownPartial", {
		value = TextareaLayoutValidation.scrollsDownPartial,
	})
	if _descriptor_47 then
		TextareaLayoutValidation.scrollsDownPartial = _descriptor_47.value
	end
	local _decorator_29 = DisplayName("A caret above the view scrolls up until its top sits on the viewport top")
	local _descriptor_48 = Test(TextareaLayoutValidation, "scrollsUp", {
		value = TextareaLayoutValidation.scrollsUp,
	})
	if _descriptor_48 then
		TextareaLayoutValidation.scrollsUp = _descriptor_48.value
	end
	local _descriptor_49 = _decorator_29(TextareaLayoutValidation, "scrollsUp", {
		value = TextareaLayoutValidation.scrollsUp,
	})
	if _descriptor_49 then
		TextareaLayoutValidation.scrollsUp = _descriptor_49.value
	end
	local _decorator_30 = DisplayName("A caret above the top of the canvas never scrolls to a negative position")
	local _descriptor_50 = Test(TextareaLayoutValidation, "scrollsUpClamped", {
		value = TextareaLayoutValidation.scrollsUpClamped,
	})
	if _descriptor_50 then
		TextareaLayoutValidation.scrollsUpClamped = _descriptor_50.value
	end
	local _descriptor_51 = _decorator_30(TextareaLayoutValidation, "scrollsUpClamped", {
		value = TextareaLayoutValidation.scrollsUpClamped,
	})
	if _descriptor_51 then
		TextareaLayoutValidation.scrollsUpClamped = _descriptor_51.value
	end
	local _decorator_31 = DisplayName("A caret already inside the view leaves the scroll position unchanged")
	local _decorator_32 = Each({ { 20, 40, 0 }, { 120, 140, 100 }, { 100, 200, 100 } })
	local _descriptor_52 = Test(TextareaLayoutValidation, "visibleUnchanged", {
		value = TextareaLayoutValidation.visibleUnchanged,
	})
	if _descriptor_52 then
		TextareaLayoutValidation.visibleUnchanged = _descriptor_52.value
	end
	local _descriptor_53 = _decorator_32(TextareaLayoutValidation, "visibleUnchanged", {
		value = TextareaLayoutValidation.visibleUnchanged,
	})
	if _descriptor_53 then
		TextareaLayoutValidation.visibleUnchanged = _descriptor_53.value
	end
	local _descriptor_54 = _decorator_31(TextareaLayoutValidation, "visibleUnchanged", {
		value = TextareaLayoutValidation.visibleUnchanged,
	})
	if _descriptor_54 then
		TextareaLayoutValidation.visibleUnchanged = _descriptor_54.value
	end
	local _decorator_33 = DisplayName("A line taller than the viewport aligns to its top rather than its bottom")
	local _descriptor_55 = Test(TextareaLayoutValidation, "tallLineTop", {
		value = TextareaLayoutValidation.tallLineTop,
	})
	if _descriptor_55 then
		TextareaLayoutValidation.tallLineTop = _descriptor_55.value
	end
	local _descriptor_56 = _decorator_33(TextareaLayoutValidation, "tallLineTop", {
		value = TextareaLayoutValidation.tallLineTop,
	})
	if _descriptor_56 then
		TextareaLayoutValidation.tallLineTop = _descriptor_56.value
	end
	local _decorator_34 = DisplayName("A cursor position below one gives no caret text")
	local _decorator_35 = Each({ { 0 }, { -1 } })
	local _descriptor_57 = Test(TextareaLayoutValidation, "caretUndefined", {
		value = TextareaLayoutValidation.caretUndefined,
	})
	if _descriptor_57 then
		TextareaLayoutValidation.caretUndefined = _descriptor_57.value
	end
	local _descriptor_58 = _decorator_35(TextareaLayoutValidation, "caretUndefined", {
		value = TextareaLayoutValidation.caretUndefined,
	})
	if _descriptor_58 then
		TextareaLayoutValidation.caretUndefined = _descriptor_58.value
	end
	local _descriptor_59 = _decorator_34(TextareaLayoutValidation, "caretUndefined", {
		value = TextareaLayoutValidation.caretUndefined,
	})
	if _descriptor_59 then
		TextareaLayoutValidation.caretUndefined = _descriptor_59.value
	end
	local _decorator_36 = DisplayName("The caret text is the bytes before the cursor position")
	local _descriptor_60 = Test(TextareaLayoutValidation, "caretPrefix", {
		value = TextareaLayoutValidation.caretPrefix,
	})
	if _descriptor_60 then
		TextareaLayoutValidation.caretPrefix = _descriptor_60.value
	end
	local _descriptor_61 = _decorator_36(TextareaLayoutValidation, "caretPrefix", {
		value = TextareaLayoutValidation.caretPrefix,
	})
	if _descriptor_61 then
		TextareaLayoutValidation.caretPrefix = _descriptor_61.value
	end
	local _decorator_37 = DisplayName("A caret at the very start measures a single space so there is still a line")
	local _descriptor_62 = Test(TextareaLayoutValidation, "caretAtStart", {
		value = TextareaLayoutValidation.caretAtStart,
	})
	if _descriptor_62 then
		TextareaLayoutValidation.caretAtStart = _descriptor_62.value
	end
	local _descriptor_63 = _decorator_37(TextareaLayoutValidation, "caretAtStart", {
		value = TextareaLayoutValidation.caretAtStart,
	})
	if _descriptor_63 then
		TextareaLayoutValidation.caretAtStart = _descriptor_63.value
	end
	local _decorator_38 = DisplayName("A caret right after a newline gets a trailing space so the new line is measured")
	local _descriptor_64 = Test(TextareaLayoutValidation, "caretAfterNewline", {
		value = TextareaLayoutValidation.caretAfterNewline,
	})
	if _descriptor_64 then
		TextareaLayoutValidation.caretAfterNewline = _descriptor_64.value
	end
	local _descriptor_65 = _decorator_38(TextareaLayoutValidation, "caretAfterNewline", {
		value = TextareaLayoutValidation.caretAfterNewline,
	})
	if _descriptor_65 then
		TextareaLayoutValidation.caretAfterNewline = _descriptor_65.value
	end
	local _decorator_39 = DisplayName("Byte slicing keeps a multibyte character whole when the cursor sits after it")
	local _descriptor_66 = Test(TextareaLayoutValidation, "caretMultibyte", {
		value = TextareaLayoutValidation.caretMultibyte,
	})
	if _descriptor_66 then
		TextareaLayoutValidation.caretMultibyte = _descriptor_66.value
	end
	local _descriptor_67 = _decorator_39(TextareaLayoutValidation, "caretMultibyte", {
		value = TextareaLayoutValidation.caretMultibyte,
	})
	if _descriptor_67 then
		TextareaLayoutValidation.caretMultibyte = _descriptor_67.value
	end
	local _decorator_40 = DisplayName("A cursor past the end of the text gives the whole text")
	local _descriptor_68 = Test(TextareaLayoutValidation, "caretPastEnd", {
		value = TextareaLayoutValidation.caretPastEnd,
	})
	if _descriptor_68 then
		TextareaLayoutValidation.caretPastEnd = _descriptor_68.value
	end
	local _descriptor_69 = _decorator_40(TextareaLayoutValidation, "caretPastEnd", {
		value = TextareaLayoutValidation.caretPastEnd,
	})
	if _descriptor_69 then
		TextareaLayoutValidation.caretPastEnd = _descriptor_69.value
	end
	local _decorator_41 = DisplayName("Length counts code points, not bytes, for accented and emoji text")
	local _decorator_42 = Each({ { "hello", 5 }, { `h{E_ACUTE}llo`, 5 }, { `{GRINNING}{GRINNING}`, 2 }, { "", 0 } })
	local _descriptor_70 = Test(TextareaLayoutValidation, "lengthCodePoints", {
		value = TextareaLayoutValidation.lengthCodePoints,
	})
	if _descriptor_70 then
		TextareaLayoutValidation.lengthCodePoints = _descriptor_70.value
	end
	local _descriptor_71 = _decorator_42(TextareaLayoutValidation, "lengthCodePoints", {
		value = TextareaLayoutValidation.lengthCodePoints,
	})
	if _descriptor_71 then
		TextareaLayoutValidation.lengthCodePoints = _descriptor_71.value
	end
	local _descriptor_72 = _decorator_41(TextareaLayoutValidation, "lengthCodePoints", {
		value = TextareaLayoutValidation.lengthCodePoints,
	})
	if _descriptor_72 then
		TextareaLayoutValidation.lengthCodePoints = _descriptor_72.value
	end
	local _decorator_43 = DisplayName("Invalid UTF-8 falls back to the byte count")
	local _descriptor_73 = Test(TextareaLayoutValidation, "lengthInvalid", {
		value = TextareaLayoutValidation.lengthInvalid,
	})
	if _descriptor_73 then
		TextareaLayoutValidation.lengthInvalid = _descriptor_73.value
	end
	local _descriptor_74 = _decorator_43(TextareaLayoutValidation, "lengthInvalid", {
		value = TextareaLayoutValidation.lengthInvalid,
	})
	if _descriptor_74 then
		TextareaLayoutValidation.lengthInvalid = _descriptor_74.value
	end
	local _decorator_44 = DisplayName("Without a maxLength the text is returned untouched")
	local _descriptor_75 = Test(TextareaLayoutValidation, "trimNoLimit", {
		value = TextareaLayoutValidation.trimNoLimit,
	})
	if _descriptor_75 then
		TextareaLayoutValidation.trimNoLimit = _descriptor_75.value
	end
	local _descriptor_76 = _decorator_44(TextareaLayoutValidation, "trimNoLimit", {
		value = TextareaLayoutValidation.trimNoLimit,
	})
	if _descriptor_76 then
		TextareaLayoutValidation.trimNoLimit = _descriptor_76.value
	end
	local _decorator_45 = DisplayName("Text within the limit is returned untouched")
	local _decorator_46 = Each({ { 5 }, { 6 }, { 100 } })
	local _descriptor_77 = Test(TextareaLayoutValidation, "trimWithin", {
		value = TextareaLayoutValidation.trimWithin,
	})
	if _descriptor_77 then
		TextareaLayoutValidation.trimWithin = _descriptor_77.value
	end
	local _descriptor_78 = _decorator_46(TextareaLayoutValidation, "trimWithin", {
		value = TextareaLayoutValidation.trimWithin,
	})
	if _descriptor_78 then
		TextareaLayoutValidation.trimWithin = _descriptor_78.value
	end
	local _descriptor_79 = _decorator_45(TextareaLayoutValidation, "trimWithin", {
		value = TextareaLayoutValidation.trimWithin,
	})
	if _descriptor_79 then
		TextareaLayoutValidation.trimWithin = _descriptor_79.value
	end
	local _decorator_47 = DisplayName("Text over the limit is cut to the first maxLength code points")
	local _descriptor_80 = Test(TextareaLayoutValidation, "trimCuts", {
		value = TextareaLayoutValidation.trimCuts,
	})
	if _descriptor_80 then
		TextareaLayoutValidation.trimCuts = _descriptor_80.value
	end
	local _descriptor_81 = _decorator_47(TextareaLayoutValidation, "trimCuts", {
		value = TextareaLayoutValidation.trimCuts,
	})
	if _descriptor_81 then
		TextareaLayoutValidation.trimCuts = _descriptor_81.value
	end
	local _decorator_48 = DisplayName("Cutting multibyte text lands on a code-point boundary and never splits a character")
	local _descriptor_82 = Test(TextareaLayoutValidation, "trimMultibyte", {
		value = TextareaLayoutValidation.trimMultibyte,
	})
	if _descriptor_82 then
		TextareaLayoutValidation.trimMultibyte = _descriptor_82.value
	end
	local _descriptor_83 = _decorator_48(TextareaLayoutValidation, "trimMultibyte", {
		value = TextareaLayoutValidation.trimMultibyte,
	})
	if _descriptor_83 then
		TextareaLayoutValidation.trimMultibyte = _descriptor_83.value
	end
	local _decorator_49 = DisplayName("A zero limit gives empty text and a fractional limit is floored")
	local _descriptor_84 = Test(TextareaLayoutValidation, "trimLimitEdges", {
		value = TextareaLayoutValidation.trimLimitEdges,
	})
	if _descriptor_84 then
		TextareaLayoutValidation.trimLimitEdges = _descriptor_84.value
	end
	local _descriptor_85 = _decorator_49(TextareaLayoutValidation, "trimLimitEdges", {
		value = TextareaLayoutValidation.trimLimitEdges,
	})
	if _descriptor_85 then
		TextareaLayoutValidation.trimLimitEdges = _descriptor_85.value
	end
	local _decorator_50 = DisplayName("Without a maxLength the counter is the length grouped with commas")
	local _decorator_51 = Each({ { 0, "0" }, { 77, "77" }, { 999, "999" }, { 1000, "1,000" }, { 1234567, "1,234,567" } })
	local _descriptor_86 = Test(TextareaLayoutValidation, "countPlain", {
		value = TextareaLayoutValidation.countPlain,
	})
	if _descriptor_86 then
		TextareaLayoutValidation.countPlain = _descriptor_86.value
	end
	local _descriptor_87 = _decorator_51(TextareaLayoutValidation, "countPlain", {
		value = TextareaLayoutValidation.countPlain,
	})
	if _descriptor_87 then
		TextareaLayoutValidation.countPlain = _descriptor_87.value
	end
	local _descriptor_88 = _decorator_50(TextareaLayoutValidation, "countPlain", {
		value = TextareaLayoutValidation.countPlain,
	})
	if _descriptor_88 then
		TextareaLayoutValidation.countPlain = _descriptor_88.value
	end
	local _decorator_52 = DisplayName("With a maxLength the counter shows length slash limit, both grouped")
	local _decorator_53 = Each({ { 77, 1500, "77 / 1,500" }, { 1500, 1500, "1,500 / 1,500" }, { 0, 100, "0 / 100" } })
	local _descriptor_89 = Test(TextareaLayoutValidation, "countWithLimit", {
		value = TextareaLayoutValidation.countWithLimit,
	})
	if _descriptor_89 then
		TextareaLayoutValidation.countWithLimit = _descriptor_89.value
	end
	local _descriptor_90 = _decorator_53(TextareaLayoutValidation, "countWithLimit", {
		value = TextareaLayoutValidation.countWithLimit,
	})
	if _descriptor_90 then
		TextareaLayoutValidation.countWithLimit = _descriptor_90.value
	end
	local _descriptor_91 = _decorator_52(TextareaLayoutValidation, "countWithLimit", {
		value = TextareaLayoutValidation.countWithLimit,
	})
	if _descriptor_91 then
		TextareaLayoutValidation.countWithLimit = _descriptor_91.value
	end
	TextareaLayoutValidation = Tag("Lune")(TextareaLayoutValidation) or TextareaLayoutValidation
end
return TextareaLayoutValidation
