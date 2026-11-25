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
local Container = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Container").Container
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _Helpers = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers")
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 500
local HOST_HEIGHT = 800
local COLUMN_WIDTH = 420
local FIELD_HEIGHT = 120
local SHORT_TEXT = "Hello"
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
local function counterLineHeight()
	local _result = DefaultTheme.components.textarea
	if _result ~= nil then
		_result = _result.counter
	end
	local typography = TypographyHelper:getTypography(DefaultTheme, nil, _result)
	local _condition = TypographyHelper:toTextSize(typography.size)
	if _condition == nil then
		_condition = 14
	end
	local _condition_1 = typography.lineHeight
	if _condition_1 == nil then
		_condition_1 = 1
	end
	return resolveTextareaWholePixels(_condition * _condition_1)
end
local function expectedRootHeight(showCount)
	return resolveTextareaWholePixels(FIELD_HEIGHT) + (if showCount then resolveTextareaWholePixels(SpacingHelper:GetPadding(DefaultTheme, "xs")) + counterLineHeight() else 0)
end
local function storyColumn(value, showCount)
	return React.createElement(Container, {
		name = "Column",
		width = COLUMN_WIDTH,
	}, React.createElement(VStack, nil, React.createElement(Text, {
		name = "Before",
		text = `height=\{{FIELD_HEIGHT}\} with long text`,
		LayoutOrder = 1,
	}), React.createElement(Textarea, {
		value = value,
		height = FIELD_HEIGHT,
		showCount = showCount,
		LayoutOrder = 2,
	}), React.createElement(Text, {
		name = "After",
		text = "Trailing caption",
		LayoutOrder = 3,
	})))
end
local function measureColumn(value, showCount, overflows)
	local measured
	withMounted(HOST_WIDTH, HOST_HEIGHT, storyColumn(value, showCount), function(mounted)
		local column = waitForGuiObject(mounted.host, "Column")
		local root = waitForGuiObject(column, "Textarea")
		local field = waitForGuiObject(root, "Field", function(gui)
			return gui.AbsoluteSize.Y == FIELD_HEIGHT
		end, `Timed out waiting for the Textarea Field to be {FIELD_HEIGHT}px tall`)
		local after = waitForGuiObject(column, "After")
		local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
		Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
		waitForLayout(function()
			if not (frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > 0) then
				return nil
			end
			return if (frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y) == overflows then true else nil
		end, `Timed out waiting for the canvas to {if overflows then "overflow" else "fit"} the window (canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y})`)
		settleFrames(5)
		measured = {
			columnHeight = column.AbsoluteSize.Y,
			afterY = after.AbsolutePosition.Y,
			afterGap = after.AbsolutePosition.Y - (root.AbsolutePosition.Y + root.AbsoluteSize.Y),
			rootHeight = root.AbsoluteSize.Y,
			fieldHeight = field.AbsoluteSize.Y,
			listGap = findDescendant(column, "VStack").Padding.Offset,
		}
	end)
	return measured
end
local function textFor(length)
	return if length == "long" then LONG_TEXT else SHORT_TEXT
end
local TextareaStackValidation
do
	TextareaStackValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaStackValidation"
		end,
	})
	TextareaStackValidation.__index = TextareaStackValidation
	function TextareaStackValidation.new(...)
		local self = setmetatable({}, TextareaStackValidation)
		return self:constructor(...) or self
	end
	function TextareaStackValidation:constructor()
	end
	function TextareaStackValidation:stackSteady(showCount)
		local short = measureColumn(SHORT_TEXT, showCount, false)
		local long = measureColumn(LONG_TEXT, showCount, true)
		Assert:equal(long.columnHeight, short.columnHeight, `Expected the column to stay {short.columnHeight}px tall with long text, got {long.columnHeight}`)
		Assert:equal(long.afterY, short.afterY, `Expected the trailing caption to stay at Y {short.afterY} with long text, got {long.afterY}`)
	end
	function TextareaStackValidation:rootIsField(length)
		local measured = measureColumn(textFor(length), false, length == "long")
		Assert:equal(measured.fieldHeight, FIELD_HEIGHT, `Expected the field to be {FIELD_HEIGHT}px tall, got {measured.fieldHeight}`)
		Assert:equal(measured.rootHeight, FIELD_HEIGHT, `Expected the root to be {FIELD_HEIGHT}px tall, got {measured.rootHeight}`)
	end
	function TextareaStackValidation:rootAddsCounter(length)
		local measured = measureColumn(textFor(length), true, length == "long")
		local expected = expectedRootHeight(true)
		Assert:equal(measured.fieldHeight, FIELD_HEIGHT, `Expected the field to be {FIELD_HEIGHT}px tall, got {measured.fieldHeight}`)
		Assert["true"](Assert, math.abs(measured.rootHeight - expected) <= 0.5, `Expected the root to be {expected}px tall (field {FIELD_HEIGHT} + gap + counter line), got {measured.rootHeight}`)
	end
	function TextareaStackValidation:captionFollowsRoot(showCount)
		local measured = measureColumn(LONG_TEXT, showCount, true)
		local gap = measured.listGap
		Assert["true"](Assert, gap > 0, `Expected the VStack to have a gap, got {gap}`)
		Assert["true"](Assert, math.abs(measured.afterGap - gap) <= 0.5, `Expected the trailing caption {gap}px below the root, got {measured.afterGap}px`)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("In the story's Container and VStack, forty lines leave the column height and trailing caption where short text puts them")
	local _decorator_2 = Each({ { false }, { true } })
	local _descriptor = Test(TextareaStackValidation, "stackSteady", {
		value = TextareaStackValidation.stackSteady,
	})
	if _descriptor then
		TextareaStackValidation.stackSteady = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextareaStackValidation, "stackSteady", {
		value = TextareaStackValidation.stackSteady,
	})
	if _descriptor_1 then
		TextareaStackValidation.stackSteady = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextareaStackValidation, "stackSteady", {
		value = TextareaStackValidation.stackSteady,
	})
	if _descriptor_2 then
		TextareaStackValidation.stackSteady = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextareaStackValidation, "stackSteady", {
		value = TextareaStackValidation.stackSteady,
	})
	if _descriptor_3 then
		TextareaStackValidation.stackSteady = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Without showCount the root is exactly the 120px field for short and overflowing text")
	local _decorator_5 = Each({ { "short" }, { "long" } })
	local _descriptor_4 = Test(TextareaStackValidation, "rootIsField", {
		value = TextareaStackValidation.rootIsField,
	})
	if _descriptor_4 then
		TextareaStackValidation.rootIsField = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_5(TextareaStackValidation, "rootIsField", {
		value = TextareaStackValidation.rootIsField,
	})
	if _descriptor_5 then
		TextareaStackValidation.rootIsField = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_4(TextareaStackValidation, "rootIsField", {
		value = TextareaStackValidation.rootIsField,
	})
	if _descriptor_6 then
		TextareaStackValidation.rootIsField = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(TextareaStackValidation, "rootIsField", {
		value = TextareaStackValidation.rootIsField,
	})
	if _descriptor_7 then
		TextareaStackValidation.rootIsField = _descriptor_7.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("With showCount the root is the field plus the xs gap and one counter line for short and overflowing text")
	local _decorator_8 = Each({ { "short" }, { "long" } })
	local _descriptor_8 = Test(TextareaStackValidation, "rootAddsCounter", {
		value = TextareaStackValidation.rootAddsCounter,
	})
	if _descriptor_8 then
		TextareaStackValidation.rootAddsCounter = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_8(TextareaStackValidation, "rootAddsCounter", {
		value = TextareaStackValidation.rootAddsCounter,
	})
	if _descriptor_9 then
		TextareaStackValidation.rootAddsCounter = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextareaStackValidation, "rootAddsCounter", {
		value = TextareaStackValidation.rootAddsCounter,
	})
	if _descriptor_10 then
		TextareaStackValidation.rootAddsCounter = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextareaStackValidation, "rootAddsCounter", {
		value = TextareaStackValidation.rootAddsCounter,
	})
	if _descriptor_11 then
		TextareaStackValidation.rootAddsCounter = _descriptor_11.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("The trailing caption starts one VStack gap below the root's bottom edge even when the text overflows")
	local _decorator_11 = Each({ { false }, { true } })
	local _descriptor_12 = Test(TextareaStackValidation, "captionFollowsRoot", {
		value = TextareaStackValidation.captionFollowsRoot,
	})
	if _descriptor_12 then
		TextareaStackValidation.captionFollowsRoot = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_11(TextareaStackValidation, "captionFollowsRoot", {
		value = TextareaStackValidation.captionFollowsRoot,
	})
	if _descriptor_13 then
		TextareaStackValidation.captionFollowsRoot = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(TextareaStackValidation, "captionFollowsRoot", {
		value = TextareaStackValidation.captionFollowsRoot,
	})
	if _descriptor_14 then
		TextareaStackValidation.captionFollowsRoot = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(TextareaStackValidation, "captionFollowsRoot", {
		value = TextareaStackValidation.captionFollowsRoot,
	})
	if _descriptor_15 then
		TextareaStackValidation.captionFollowsRoot = _descriptor_15.value
	end
	TextareaStackValidation = Tag("Studio")(TextareaStackValidation) or TextareaStackValidation
end
return TextareaStackValidation
