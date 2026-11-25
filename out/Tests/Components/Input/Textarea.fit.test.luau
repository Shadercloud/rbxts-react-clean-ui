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
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SpacingHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 600
local HOST_HEIGHT = 700
local DESIGN_WIDTH = 300
local DESIGN_HEIGHT = 400
local PROBE_HEIGHT = 40
local MIN_LINES = 2
local MAX_LINES = 20
local OVER_MARGIN = 0.05
local SIZE_TOLERANCE = 0.5
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
local function scaledTextarea(scale, value, height)
	return React.createElement("frame", {
		key = "Scaled",
		Size = UDim2.fromOffset(DESIGN_WIDTH, DESIGN_HEIGHT),
		BackgroundTransparency = 1,
	}, React.createElement("uiscale", {
		key = "TestScale",
		Scale = scale,
	}), React.createElement(Textarea, {
		value = value,
		height = height,
		controlled = true,
	}))
end
local function describeScroll(frame)
	return `canvas {frame.AbsoluteCanvasSize.Y}, window {frame.AbsoluteWindowSize.Y}`
end
local function waitForFieldHeight(root, height, scale)
	local expected = height * scale
	return waitForGuiObject(root, "Field", function(gui)
		return math.abs(gui.AbsoluteSize.Y - expected) <= SIZE_TOLERANCE
	end, `Timed out waiting for the Textarea Field to be {expected}px tall at scale {scale}`)
end
local function waitForOverflow(frame, label)
	waitForLayout(function()
		return if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then true else nil
	end, `{label}: timed out waiting for the canvas to overflow`)
end
local function findFit(mounted, field, scale)
	local padding = SpacingHelper:GetResolvedPadding(DefaultTheme, {})
	local measure = findDescendant(field, "TextMeasure")
	local tolerance = 1 / scale
	local previous = -1
	for count = MIN_LINES, MAX_LINES do
		local text = lines(count)
		mounted.update(scaledTextarea(scale, text, PROBE_HEIGHT))
		waitForLayout(function()
			return if measure.Text == text and measure.TextBounds.Y > 0 and measure.TextBounds.Y ~= previous then true else nil
		end, `Scale {scale}: timed out waiting for TextMeasure to measure {count} lines`)
		settleFrames(2)
		previous = measure.TextBounds.Y
		local screenScale = field.AbsoluteSize.Y / PROBE_HEIGHT
		local content = measure.TextBounds.Y / screenScale + padding.top + padding.bottom
		local height = math.ceil(content - tolerance)
		local over = content - height
		local minimum = if tolerance > 1 + 2 * OVER_MARGIN then 1 + OVER_MARGIN else OVER_MARGIN
		if over >= minimum and over <= tolerance - OVER_MARGIN then
			return {
				count = count,
				content = content,
				height = height,
			}
		end
	end
	return Assert:fail(`Scale {scale}: fixture found no line count from {MIN_LINES} to {MAX_LINES} whose content lands strictly inside the tolerance`)
end
local TextareaFitValidation
do
	TextareaFitValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaFitValidation"
		end,
	})
	TextareaFitValidation.__index = TextareaFitValidation
	function TextareaFitValidation.new(...)
		local self = setmetatable({}, TextareaFitValidation)
		return self:constructor(...) or self
	end
	function TextareaFitValidation:constructor()
	end
	function TextareaFitValidation:withinTolerance(scale)
		withMounted(HOST_WIDTH, HOST_HEIGHT, scaledTextarea(scale, lines(1), PROBE_HEIGHT), function(mounted)
			local root = waitForGuiObject(mounted.host, "Textarea")
			local field = waitForFieldHeight(root, PROBE_HEIGHT, scale)
			local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
			Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
			local fit = findFit(mounted, field, scale)
			local label = `Scale {scale}, {fit.count} lines, content {fit.content} in a {fit.height} field`
			mounted.update(scaledTextarea(scale, lines(fit.count), fit.height))
			waitForFieldHeight(root, fit.height, scale)
			settleFrames(5)
			local canvas = findDescendant(frame, "Canvas")
			Assert["true"](Assert, frame.AbsoluteCanvasSize.Y <= frame.AbsoluteWindowSize.Y, `{label}: expected no bar ({describeScroll(frame)})`)
			Assert:equal(canvas.Size.Y.Offset, fit.height, `{label}: expected the Canvas to stay at the field height, got {canvas.Size.Y.Offset}`)
			mounted.update(scaledTextarea(scale, lines(fit.count + 1), fit.height))
			waitForOverflow(frame, `{label}, plus one line`)
			Assert["true"](Assert, frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y, `{label}: expected one more line to overflow ({describeScroll(frame)})`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Content up to one screen pixel taller than the field shows no bar at each UIScale and one more line does")
	local _decorator_2 = Each({ { 0.75 }, { 1 }, { 1.5 } })
	local _descriptor = Test(TextareaFitValidation, "withinTolerance", {
		value = TextareaFitValidation.withinTolerance,
	})
	if _descriptor then
		TextareaFitValidation.withinTolerance = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextareaFitValidation, "withinTolerance", {
		value = TextareaFitValidation.withinTolerance,
	})
	if _descriptor_1 then
		TextareaFitValidation.withinTolerance = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextareaFitValidation, "withinTolerance", {
		value = TextareaFitValidation.withinTolerance,
	})
	if _descriptor_2 then
		TextareaFitValidation.withinTolerance = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextareaFitValidation, "withinTolerance", {
		value = TextareaFitValidation.withinTolerance,
	})
	if _descriptor_3 then
		TextareaFitValidation.withinTolerance = _descriptor_3.value
	end
	TextareaFitValidation = Tag("Studio")(TextareaFitValidation) or TextareaFitValidation
end
return TextareaFitValidation
