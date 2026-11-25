-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local RunService = TS.import(script, TS.getModule(script, "@rbxts", "services")).RunService
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
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 400
local FIELD_HEIGHT = 160
local NUDGE_FRAMES = 4
local WATCH_FRAMES = 10
local OVERFLOW_FRAMES = 30
local USER_SCROLL = 100
local MAX_LENGTH = 100
local OVER_LIMIT_BYTES = 795
local function lines(prefix, count)
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
			local _arg0 = `{prefix} {index}`
			table.insert(parts, _arg0)
		end
	end
	return table.concat(parts, "\n")
end
local SHORT_TEXT = "Hello"
local LONG_TEXT = lines("Line", 40)
local OTHER_LONG_TEXT = lines("Item", 40)
local OVER_LIMIT_TEXT = `{string.rep("abcdefghi\n", 79)}abcde`
local function scrollerOf(box)
	local _result = box
	if _result ~= nil then
		_result = _result:FindFirstAncestorWhichIsA("ScrollingFrame")
	end
	return _result
end
local function withRecorder(fn)
	local connections = {}
	local recorder
	recorder = {
		box = nil,
		start = 0,
		frame = 0,
		samples = {},
		frames = {},
		changes = {},
		ref = function(instance)
			if instance == nil or instance == recorder.box then
				return nil
			end
			recorder.box = instance
			recorder.start = instance.Size.Y.Offset
			recorder.frame = 0
			local _arg0 = instance:GetPropertyChangedSignal("Size"):Connect(function()
				local frame = scrollerOf(instance)
				local _samples = recorder.samples
				local _object = {
					frame = recorder.frame,
					y = instance.Size.Y.Offset,
				}
				local _left = "canvasY"
				local _result = frame
				if _result ~= nil then
					_result = _result.AbsoluteCanvasSize.Y
				end
				local _condition = _result
				if _condition == nil then
					_condition = 0
				end
				_object[_left] = _condition
				local _left_1 = "scrollY"
				local _result_1 = frame
				if _result_1 ~= nil then
					_result_1 = _result_1.CanvasPosition.Y
				end
				local _condition_1 = _result_1
				if _condition_1 == nil then
					_condition_1 = 0
				end
				_object[_left_1] = _condition_1
				table.insert(_samples, _object)
			end)
			table.insert(connections, _arg0)
		end,
		onChange = function(value)
			local _changes = recorder.changes
			local _value = value
			table.insert(_changes, _value)
		end,
		reset = function()
			local _result = recorder.box
			if _result ~= nil then
				_result = _result.Size.Y.Offset
			end
			local _condition = _result
			if _condition == nil then
				_condition = 0
			end
			recorder.start = _condition
			recorder.frame = 0
			table.clear(recorder.samples)
			table.clear(recorder.frames)
			table.clear(recorder.changes)
		end,
	}
	local _arg0 = RunService.Heartbeat:Connect(function()
		recorder.frame += 1
		local frame = scrollerOf(recorder.box)
		if frame ~= nil then
			local _frames = recorder.frames
			local _arg0_1 = {
				frame = recorder.frame,
				canvasY = frame.AbsoluteCanvasSize.Y,
				scrollY = frame.CanvasPosition.Y,
			}
			table.insert(_frames, _arg0_1)
		end
	end)
	table.insert(connections, _arg0)
	TS.try(function()
		fn(recorder)
	end, nil, function()
		for _, connection in connections do
			connection:Disconnect()
		end
	end)
end
local function textarea(recorder, value, controlled, maxLength)
	return React.createElement(Textarea, {
		ref = recorder.ref,
		value = value,
		height = FIELD_HEIGHT,
		controlled = controlled,
		maxLength = maxLength,
		onChange = recorder.onChange,
	})
end
local function describeSamples(recorder)
	local _exp = recorder.samples
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#_exp)
	local _callback = function(sample)
		return `f{sample.frame}:{sample.y}`
	end
	for _k, _v in _exp do
		_newValue[_k] = _callback(_v, _k - 1, _exp)
	end
	-- ▲ ReadonlyArray.map ▲
	local parts = _newValue
	return `start {recorder.start}, Size Y changes [{table.concat(parts, ", ")}]`
end
local function findDips(recorder)
	local dips = {}
	local previous = recorder.start
	for index = 0, #recorder.samples - 1 do
		local sample = recorder.samples[index + 1]
		if sample.y == previous - 1 then
			local _index = index
			table.insert(dips, _index)
		end
		previous = sample.y
	end
	return dips
end
local function currentBox(recorder)
	local box = recorder.box
	Assert:notUndefined(box, "Expected the Textarea ref to receive its TextBox")
	return box
end
local function renderedHeight(box)
	local canvas = box.Parent
	return canvas.Size.Y.Offset - box.Position.Y.Offset
end
local function waitForOverflow(recorder)
	for attempt = 0, OVERFLOW_FRAMES - 1 do
		local frame = scrollerOf(recorder.box)
		if frame ~= nil and frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then
			return frame
		end
		task.wait()
	end
	local frame = scrollerOf(recorder.box)
	local _result = frame
	if _result ~= nil then
		_result = _result.AbsoluteCanvasSize.Y
	end
	local _result_1 = frame
	if _result_1 ~= nil then
		_result_1 = _result_1.AbsoluteWindowSize.Y
	end
	return Assert:fail(`Timed out waiting for the canvas to overflow (canvas {_result}, window {_result_1})`)
end
local function assertNudgedOnce(recorder, label)
	local box = currentBox(recorder)
	local dips = findDips(recorder)
	Assert:equal(#dips, 1, `{label}: expected exactly one 1px dip in the TextBox Size height ({describeSamples(recorder)})`)
	local index = dips[1]
	local dip = recorder.samples[index + 1]
	local before = if index == 0 then recorder.start else recorder.samples[index].y
	local restore = recorder.samples[index + 2]
	local rendered = renderedHeight(box)
	Assert["true"](Assert, dip.frame <= NUDGE_FRAMES, `{label}: expected the dip within {NUDGE_FRAMES} Heartbeats, it came on {dip.frame} ({describeSamples(recorder)})`)
	Assert:notUndefined(restore, `{label}: expected the dip to be restored ({describeSamples(recorder)})`)
	Assert["true"](Assert, restore.frame <= dip.frame + 1, `{label}: expected the restore on the Heartbeat after the dip ({describeSamples(recorder)})`)
	Assert["true"](Assert, restore.y == before or restore.y == rendered, `{label}: expected the restore to return to {before} or the rendered {rendered}, got {restore.y} ({describeSamples(recorder)})`)
	Assert:equal(box.Size.Y.Offset, rendered, `{label}: expected the TextBox to end at the rendered height {rendered}, got {box.Size.Y.Offset}`)
end
local function assertEchoes(recorder, value, label)
	Assert["true"](Assert, #recorder.changes <= 1, `{label}: expected at most one onChange, got {#recorder.changes}`)
	for _, change in recorder.changes do
		Assert["true"](Assert, change == value, `{label}: expected onChange to carry the new {#value}-byte value, got {#change} bytes`)
	end
end
local TextareaNudgeValidation
do
	TextareaNudgeValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaNudgeValidation"
		end,
	})
	TextareaNudgeValidation.__index = TextareaNudgeValidation
	function TextareaNudgeValidation.new(...)
		local self = setmetatable({}, TextareaNudgeValidation)
		return self:constructor(...) or self
	end
	function TextareaNudgeValidation:constructor()
	end
	function TextareaNudgeValidation:nudgeOnMount()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				assertNudgedOnce(recorder, "Mount")
				Assert:equal(#recorder.changes, 0, `Expected no onChange on mount, got {#recorder.changes}`)
			end)
		end)
	end
	function TextareaNudgeValidation:nudgeOnUpdate()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				settleFrames(WATCH_FRAMES)
				recorder.reset()
				mounted.update(textarea(recorder, LONG_TEXT, true))
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				assertNudgedOnce(recorder, "Controlled update")
				assertEchoes(recorder, LONG_TEXT, "Controlled update")
			end)
		end)
	end
	function TextareaNudgeValidation:nudgeOnRemount()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				local first = currentBox(recorder)
				mounted.update(React.createElement("frame", {
					key = "Empty",
					BackgroundTransparency = 1,
				}))
				settleFrames(3)
				recorder.reset()
				mounted.update(textarea(recorder, LONG_TEXT))
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				Assert["true"](Assert, currentBox(recorder) ~= first, "Expected the remount to create a new TextBox")
				assertNudgedOnce(recorder, "Remount")
				Assert:equal(#recorder.changes, 0, `Expected no onChange on remount, got {#recorder.changes}`)
			end)
		end)
	end
	function TextareaNudgeValidation:nudgeKeepsCanvas()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, LONG_TEXT, true), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				local frame = waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				frame.CanvasPosition = Vector2.new(frame.CanvasPosition.X, USER_SCROLL)
				settleFrames(3)
				local canvasY = frame.AbsoluteCanvasSize.Y
				Assert:equal(frame.CanvasPosition.Y, USER_SCROLL, `Expected the test scroll to land at {USER_SCROLL}`)
				recorder.reset()
				mounted.update(textarea(recorder, OTHER_LONG_TEXT, true))
				settleFrames(WATCH_FRAMES)
				assertNudgedOnce(recorder, "Long to long update")
				Assert["true"](Assert, currentBox(recorder).Text == OTHER_LONG_TEXT, "Expected the TextBox to show the updated value")
				for _, sample in recorder.samples do
					Assert:equal(sample.canvasY, canvasY, `Expected the canvas to stay {canvasY} at Size change f{sample.frame}, got {sample.canvasY}`)
					Assert:equal(sample.scrollY, USER_SCROLL, `Expected CanvasPosition.Y to stay {USER_SCROLL} at Size change f{sample.frame}, got {sample.scrollY}`)
				end
				for _, sample in recorder.frames do
					Assert:equal(sample.canvasY, canvasY, `Expected the canvas to stay {canvasY} on Heartbeat {sample.frame}, got {sample.canvasY}`)
					Assert:equal(sample.scrollY, USER_SCROLL, `Expected CanvasPosition.Y to stay {USER_SCROLL} on Heartbeat {sample.frame}, got {sample.scrollY}`)
				end
				assertEchoes(recorder, OTHER_LONG_TEXT, "Long to long update")
			end)
		end)
	end
	function TextareaNudgeValidation:noTrimOnMount()
		Assert:equal(#OVER_LIMIT_TEXT, OVER_LIMIT_BYTES, "Fixture out of date: expected the over-limit value to be 795 bytes")
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, OVER_LIMIT_TEXT, false, MAX_LENGTH), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				local box = currentBox(recorder)
				Assert:equal(#box.Text, OVER_LIMIT_BYTES, `Expected the TextBox to keep all {OVER_LIMIT_BYTES} bytes, got {#box.Text}`)
				Assert:equal(#recorder.changes, 0, `Expected no onChange on mount, got {#recorder.changes}`)
				assertNudgedOnce(recorder, "Over-limit mount")
			end)
		end)
	end
	function TextareaNudgeValidation:noTrimOnUpdate()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true, MAX_LENGTH), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				settleFrames(WATCH_FRAMES)
				recorder.reset()
				mounted.update(textarea(recorder, OVER_LIMIT_TEXT, true, MAX_LENGTH))
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				local box = currentBox(recorder)
				Assert:equal(#box.Text, OVER_LIMIT_BYTES, `Expected the TextBox to keep all {OVER_LIMIT_BYTES} bytes, got {#box.Text}`)
				assertEchoes(recorder, OVER_LIMIT_TEXT, "Over-limit update")
			end)
		end)
	end
	function TextareaNudgeValidation:sameValueOnce()
		withRecorder(function(recorder)
			withMounted(HOST_WIDTH, HOST_HEIGHT, textarea(recorder, SHORT_TEXT, true), function(mounted)
				waitForGuiObject(mounted.host, "Textarea")
				settleFrames(WATCH_FRAMES)
				recorder.reset()
				mounted.update(textarea(recorder, LONG_TEXT, true))
				waitForOverflow(recorder)
				settleFrames(WATCH_FRAMES)
				mounted.update(textarea(recorder, LONG_TEXT, true))
				settleFrames(WATCH_FRAMES)
				mounted.update(textarea(recorder, LONG_TEXT, true))
				settleFrames(WATCH_FRAMES)
				Assert:equal(#findDips(recorder), 1, `Expected one nudge for the repeated value ({describeSamples(recorder)})`)
			end)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Mounting 40 lines unfocused shrinks the TextBox by 1px for one Heartbeat and fires no onChange")
	local _descriptor = Test(TextareaNudgeValidation, "nudgeOnMount", {
		value = TextareaNudgeValidation.nudgeOnMount,
	})
	if _descriptor then
		TextareaNudgeValidation.nudgeOnMount = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaNudgeValidation, "nudgeOnMount", {
		value = TextareaNudgeValidation.nudgeOnMount,
	})
	if _descriptor_1 then
		TextareaNudgeValidation.nudgeOnMount = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaNudgeValidation, "nudgeOnMount", {
		value = TextareaNudgeValidation.nudgeOnMount,
	})
	if _descriptor_2 then
		TextareaNudgeValidation.nudgeOnMount = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A controlled update from one line to 40 while unfocused nudges once with at most one onChange echo")
	local _descriptor_3 = Test(TextareaNudgeValidation, "nudgeOnUpdate", {
		value = TextareaNudgeValidation.nudgeOnUpdate,
	})
	if _descriptor_3 then
		TextareaNudgeValidation.nudgeOnUpdate = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextareaNudgeValidation, "nudgeOnUpdate", {
		value = TextareaNudgeValidation.nudgeOnUpdate,
	})
	if _descriptor_4 then
		TextareaNudgeValidation.nudgeOnUpdate = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextareaNudgeValidation, "nudgeOnUpdate", {
		value = TextareaNudgeValidation.nudgeOnUpdate,
	})
	if _descriptor_5 then
		TextareaNudgeValidation.nudgeOnUpdate = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Remounting with a 40-line initial value nudges the new TextBox once")
	local _descriptor_6 = Test(TextareaNudgeValidation, "nudgeOnRemount", {
		value = TextareaNudgeValidation.nudgeOnRemount,
	})
	if _descriptor_6 then
		TextareaNudgeValidation.nudgeOnRemount = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextareaNudgeValidation, "nudgeOnRemount", {
		value = TextareaNudgeValidation.nudgeOnRemount,
	})
	if _descriptor_7 then
		TextareaNudgeValidation.nudgeOnRemount = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextareaNudgeValidation, "nudgeOnRemount", {
		value = TextareaNudgeValidation.nudgeOnRemount,
	})
	if _descriptor_8 then
		TextareaNudgeValidation.nudgeOnRemount = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Through the nudge the canvas height stays fixed and a CanvasPosition of 100 stays at 100")
	local _descriptor_9 = Test(TextareaNudgeValidation, "nudgeKeepsCanvas", {
		value = TextareaNudgeValidation.nudgeKeepsCanvas,
	})
	if _descriptor_9 then
		TextareaNudgeValidation.nudgeKeepsCanvas = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextareaNudgeValidation, "nudgeKeepsCanvas", {
		value = TextareaNudgeValidation.nudgeKeepsCanvas,
	})
	if _descriptor_10 then
		TextareaNudgeValidation.nudgeKeepsCanvas = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextareaNudgeValidation, "nudgeKeepsCanvas", {
		value = TextareaNudgeValidation.nudgeKeepsCanvas,
	})
	if _descriptor_11 then
		TextareaNudgeValidation.nudgeKeepsCanvas = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A 795-byte initial value with maxLength 100 is shown untrimmed while unfocused")
	local _descriptor_12 = Test(TextareaNudgeValidation, "noTrimOnMount", {
		value = TextareaNudgeValidation.noTrimOnMount,
	})
	if _descriptor_12 then
		TextareaNudgeValidation.noTrimOnMount = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TextareaNudgeValidation, "noTrimOnMount", {
		value = TextareaNudgeValidation.noTrimOnMount,
	})
	if _descriptor_13 then
		TextareaNudgeValidation.noTrimOnMount = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextareaNudgeValidation, "noTrimOnMount", {
		value = TextareaNudgeValidation.noTrimOnMount,
	})
	if _descriptor_14 then
		TextareaNudgeValidation.noTrimOnMount = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A controlled update to 795 bytes with maxLength 100 stays untrimmed and any echo carries all of it")
	local _descriptor_15 = Test(TextareaNudgeValidation, "noTrimOnUpdate", {
		value = TextareaNudgeValidation.noTrimOnUpdate,
	})
	if _descriptor_15 then
		TextareaNudgeValidation.noTrimOnUpdate = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(TextareaNudgeValidation, "noTrimOnUpdate", {
		value = TextareaNudgeValidation.noTrimOnUpdate,
	})
	if _descriptor_16 then
		TextareaNudgeValidation.noTrimOnUpdate = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(TextareaNudgeValidation, "noTrimOnUpdate", {
		value = TextareaNudgeValidation.noTrimOnUpdate,
	})
	if _descriptor_17 then
		TextareaNudgeValidation.noTrimOnUpdate = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("Rendering the same new value again after it was nudged does not nudge a second time")
	local _descriptor_18 = Test(TextareaNudgeValidation, "sameValueOnce", {
		value = TextareaNudgeValidation.sameValueOnce,
	})
	if _descriptor_18 then
		TextareaNudgeValidation.sameValueOnce = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(TextareaNudgeValidation, "sameValueOnce", {
		value = TextareaNudgeValidation.sameValueOnce,
	})
	if _descriptor_19 then
		TextareaNudgeValidation.sameValueOnce = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(TextareaNudgeValidation, "sameValueOnce", {
		value = TextareaNudgeValidation.sameValueOnce,
	})
	if _descriptor_20 then
		TextareaNudgeValidation.sameValueOnce = _descriptor_20.value
	end
	TextareaNudgeValidation = Tag("Studio")(TextareaNudgeValidation) or TextareaNudgeValidation
end
return TextareaNudgeValidation
