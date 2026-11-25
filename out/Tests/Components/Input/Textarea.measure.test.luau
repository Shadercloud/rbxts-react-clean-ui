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
local Each = _binding.Each
local Textarea = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea").Textarea
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 400
local FIELD_HEIGHT = 160
local SAMPLE_FRAMES = 10
local SETTLE_FRAMES = 10
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
local function sample(sampler)
	local box = sampler.box
	local _canvas = box
	if _canvas ~= nil then
		_canvas = _canvas.Parent
	end
	local canvas = _canvas
	if box == nil or canvas == nil or not canvas:IsA("TextButton") or sampler.frame > SAMPLE_FRAMES then
		return nil
	end
	local frame = box:FindFirstAncestorWhichIsA("ScrollingFrame")
	local _samples = sampler.samples
	local _object = {
		frame = sampler.frame,
		boxY = box.Size.Y.Offset,
		canvasY = canvas.Size.Y.Offset,
		top = box.Position.Y.Offset,
	}
	local _left = "screenCanvasY"
	local _result = frame
	if _result ~= nil then
		_result = _result.AbsoluteCanvasSize.Y
	end
	local _condition = _result
	if _condition == nil then
		_condition = 0
	end
	_object[_left] = _condition
	table.insert(_samples, _object)
end
local function withSampler(fn)
	local connections = {}
	local sampler
	sampler = {
		frame = 0,
		samples = {},
		box = nil,
		ref = function(instance)
			if instance == nil or sampler.box ~= nil then
				return nil
			end
			sampler.box = instance
			sample(sampler)
			local _arg0 = RunService.Heartbeat:Connect(function()
				sampler.frame += 1
				sample(sampler)
			end)
			table.insert(connections, _arg0)
		end,
	}
	TS.try(function()
		fn(sampler)
	end, nil, function()
		for _, connection in connections do
			connection:Disconnect()
		end
	end)
end
local function describeSample(entry)
	return `f{entry.frame}: TextBox {entry.boxY}, Canvas {entry.canvasY}, top {entry.top}, AbsoluteCanvasSize {entry.screenCanvasY}`
end
local TextareaFirstMeasureValidation
do
	TextareaFirstMeasureValidation = setmetatable({}, {
		__tostring = function()
			return "TextareaFirstMeasureValidation"
		end,
	})
	TextareaFirstMeasureValidation.__index = TextareaFirstMeasureValidation
	function TextareaFirstMeasureValidation.new(...)
		local self = setmetatable({}, TextareaFirstMeasureValidation)
		return self:constructor(...) or self
	end
	function TextareaFirstMeasureValidation:constructor()
	end
	function TextareaFirstMeasureValidation:noEarlyDoubling(lineCount)
		local value = if lineCount > 0 then lines(lineCount) else ""
		withSampler(function(sampler)
			withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Textarea, {
				ref = sampler.ref,
				value = value,
				height = FIELD_HEIGHT,
			}), function(mounted)
				local root = waitForGuiObject(mounted.host, "Textarea")
				local frame = root:FindFirstChildWhichIsA("ScrollingFrame", true)
				Assert:notUndefined(frame, `Expected a ScrollingFrame under {root:GetFullName()}`)
				if lineCount == 40 then
					waitForLayout(function()
						return if frame.AbsoluteWindowSize.Y > 0 and frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y then true else nil
					end, "Timed out waiting for 40 lines to overflow the field")
				end
				settleFrames(SETTLE_FRAMES)
				local canvas = findDescendant(frame, "Canvas")
				local finalCanvas = canvas.Size.Y.Offset
				local finalScreenCanvas = frame.AbsoluteCanvasSize.Y
				Assert["true"](Assert, #sampler.samples > SAMPLE_FRAMES, `Expected a sample on every Heartbeat, got {#sampler.samples}`)
				if lineCount == 40 then
					Assert["true"](Assert, finalCanvas > FIELD_HEIGHT, `Expected 40 lines to give a canvas taller than {FIELD_HEIGHT}, got {finalCanvas}`)
				else
					Assert:equal(finalCanvas, FIELD_HEIGHT, `Expected a fitting value to leave the canvas at the view height {FIELD_HEIGHT}, got {finalCanvas}`)
				end
				for _, entry in sampler.samples do
					Assert["true"](Assert, entry.boxY <= entry.canvasY - entry.top, `Expected the TextBox to stay within the canvas ({describeSample(entry)})`)
					Assert["true"](Assert, entry.canvasY <= finalCanvas, `Expected the canvas never to exceed the final {finalCanvas} ({describeSample(entry)})`)
					Assert["true"](Assert, entry.screenCanvasY <= finalScreenCanvas + SIZE_TOLERANCE, `Expected AbsoluteCanvasSize never to exceed the final {finalScreenCanvas} ({describeSample(entry)})`)
					if lineCount == 0 then
						Assert:equal(entry.canvasY, FIELD_HEIGHT, `Expected an empty field to keep the view-height canvas ({describeSample(entry)})`)
					end
				end
			end)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("On every frame after mount the TextBox is at most canvas minus top padding and the canvas never overshoots")
	local _decorator_2 = Each({ { 40 }, { 1 }, { 0 } })
	local _descriptor = Test(TextareaFirstMeasureValidation, "noEarlyDoubling", {
		value = TextareaFirstMeasureValidation.noEarlyDoubling,
	})
	if _descriptor then
		TextareaFirstMeasureValidation.noEarlyDoubling = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextareaFirstMeasureValidation, "noEarlyDoubling", {
		value = TextareaFirstMeasureValidation.noEarlyDoubling,
	})
	if _descriptor_1 then
		TextareaFirstMeasureValidation.noEarlyDoubling = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextareaFirstMeasureValidation, "noEarlyDoubling", {
		value = TextareaFirstMeasureValidation.noEarlyDoubling,
	})
	if _descriptor_2 then
		TextareaFirstMeasureValidation.noEarlyDoubling = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextareaFirstMeasureValidation, "noEarlyDoubling", {
		value = TextareaFirstMeasureValidation.noEarlyDoubling,
	})
	if _descriptor_3 then
		TextareaFirstMeasureValidation.noEarlyDoubling = _descriptor_3.value
	end
	TextareaFirstMeasureValidation = Tag("Studio")(TextareaFirstMeasureValidation) or TextareaFirstMeasureValidation
end
return TextareaFirstMeasureValidation
