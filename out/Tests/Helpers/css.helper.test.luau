-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local Decorators = _lunit.Decorators
local CssHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "css.helper").CssHelper
local _binding = Decorators
local Each = _binding.Each
local RED = Color3.fromRGB(255, 0, 0)
local GREEN = Color3.fromRGB(0, 255, 0)
local BLUE = Color3.fromRGB(0, 0, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local BLACK = Color3.fromRGB(0, 0, 0)
local function resolveColor(value)
	local resolved = CssHelper:resolveBackgroundGradient(value)
	Assert:notUndefined(resolved, "Expected a gradient with colours to resolve to UIGradient props")
	Assert:notUndefined(resolved.Color, "Expected the resolved props to carry a Color")
	return resolved.Color
end
local function resolveTransparency(value)
	local resolved = CssHelper:resolveBackgroundGradient(value)
	Assert:notUndefined(resolved, "Expected a gradient with colours to resolve to UIGradient props")
	return resolved.Transparency
end
local function assertColorKeypoints(sequence, expected, label)
	local keypoints = sequence.Keypoints
	Assert:equal(#keypoints, #expected, `{label}: expected {#expected} colour keypoints, got {#keypoints}`)
	for index = 0, #expected - 1 do
		local _binding_1 = expected[index + 1]
		local time = _binding_1[1]
		local color = _binding_1[2]
		Assert:approximately(keypoints[index + 1].Time, time, 1e-6, `{label}: keypoint {index} time mismatch`)
		Assert:equal(keypoints[index + 1].Value, color, `{label}: keypoint {index} colour mismatch`)
	end
end
local CssBackgroundGradientResolution
do
	CssBackgroundGradientResolution = setmetatable({}, {
		__tostring = function()
			return "CssBackgroundGradientResolution"
		end,
	})
	CssBackgroundGradientResolution.__index = CssBackgroundGradientResolution
	function CssBackgroundGradientResolution.new(...)
		local self = setmetatable({}, CssBackgroundGradientResolution)
		return self:constructor(...) or self
	end
	function CssBackgroundGradientResolution:constructor()
	end
	function CssBackgroundGradientResolution:undefinedValue()
		Assert:undefined(CssHelper:resolveBackgroundGradient(nil))
	end
	function CssBackgroundGradientResolution:colorlessValue(label, value)
		Assert:undefined(CssHelper:resolveBackgroundGradient(value), `{label}: expected no UIGradient props`)
	end
	function CssBackgroundGradientResolution:singleColorSolid()
		assertColorKeypoints(resolveColor({
			colors = { GREEN },
			stops = { 0.4 },
		}), { { 0, GREEN }, { 1, GREEN } }, "single colour")
	end
	function CssBackgroundGradientResolution:sequencePassthrough()
		local sequence = ColorSequence.new({ ColorSequenceKeypoint.new(0, RED), ColorSequenceKeypoint.new(0.2, GREEN), ColorSequenceKeypoint.new(1, BLUE) })
		local color = resolveColor({
			colors = sequence,
			stops = { 0, 0.9, 1 },
		})
		Assert:equal(color, sequence)
		assertColorKeypoints(color, { { 0, RED }, { 0.2, GREEN }, { 1, BLUE } }, "passthrough sequence")
	end
	function CssBackgroundGradientResolution:evenSpacing()
		assertColorKeypoints(resolveColor({
			colors = { RED, GREEN, BLUE },
		}), { { 0, RED }, { 0.5, GREEN }, { 1, BLUE } }, "no stops")
	end
	function CssBackgroundGradientResolution:shortStopsFallback()
		assertColorKeypoints(resolveColor({
			colors = { RED, GREEN, BLUE, WHITE },
			stops = { 0, 0.1 },
		}), { { 0, RED }, { 0.1, GREEN }, { 2 / 3, BLUE }, { 1, WHITE } }, "short stops")
	end
	function CssBackgroundGradientResolution:endpointsForced()
		assertColorKeypoints(resolveColor({
			colors = { RED, GREEN, BLUE },
			stops = { 0.3, 0.5, 0.7 },
		}), { { 0, RED }, { 0.5, GREEN }, { 1, BLUE } }, "inset endpoints")
	end
	function CssBackgroundGradientResolution:outOfOrderStops()
		assertColorKeypoints(resolveColor({
			colors = { RED, GREEN, BLUE, WHITE },
			stops = { 0, 0.7, 0.3, 1 },
		}), { { 0, RED }, { 0.3, BLUE }, { 0.7, GREEN }, { 1, WHITE } }, "out-of-order stops")
	end
	function CssBackgroundGradientResolution:sharedStopKeepsOrder(label, colors, stops, expected)
		assertColorKeypoints(resolveColor({
			colors = colors,
			stops = stops,
		}), expected, label)
	end
	function CssBackgroundGradientResolution:clampsStops(label, stops, expected)
		assertColorKeypoints(resolveColor({
			colors = { RED, GREEN, BLUE },
			stops = stops,
		}), expected, label)
	end
	function CssBackgroundGradientResolution:uniformTransparency(input, expected)
		local transparency = resolveTransparency({
			colors = { RED, BLUE },
			transparency = input,
		})
		Assert:notUndefined(transparency, "Expected a numeric transparency to produce a NumberSequence")
		local keypoints = transparency.Keypoints
		Assert:greaterThan(#keypoints, 0)
		for index = 0, #keypoints - 1 do
			Assert:approximately(keypoints[index + 1].Value, expected, 1e-6, `keypoint {index} transparency mismatch`)
		end
	end
	function CssBackgroundGradientResolution:transparencyPassthrough()
		local sequence = NumberSequence.new(0.2, 0.8)
		Assert:equal(resolveTransparency({
			colors = { RED, BLUE },
			transparency = sequence,
		}), sequence)
		Assert:undefined(resolveTransparency({
			colors = { RED, BLUE },
		}))
	end
	function CssBackgroundGradientResolution:rotationAndOffset()
		local offset = Vector2.new(0.25, -0.5)
		local resolved = CssHelper:resolveBackgroundGradient({
			colors = { RED, BLUE },
			rotation = 45,
			offset = offset,
		})
		Assert:notUndefined(resolved)
		Assert:equal(resolved.Rotation, 45)
		Assert:equal(resolved.Offset, offset)
	end
	local _decorator = DisplayName("An undefined value resolves to no UIGradient props")
	local _descriptor = Test(CssBackgroundGradientResolution, "undefinedValue", {
		value = CssBackgroundGradientResolution.undefinedValue,
	})
	if _descriptor then
		CssBackgroundGradientResolution.undefinedValue = _descriptor.value
	end
	local _descriptor_1 = _decorator(CssBackgroundGradientResolution, "undefinedValue", {
		value = CssBackgroundGradientResolution.undefinedValue,
	})
	if _descriptor_1 then
		CssBackgroundGradientResolution.undefinedValue = _descriptor_1.value
	end
	local _decorator_1 = Each({ { "rotation only", {
		rotation = 45,
	} }, { "empty colour array", {
		colors = {},
	} }, { "stops and transparency without colours", {
		stops = { 0, 1 },
		transparency = 0.5,
	} }, { "empty object", {} } })
	local _decorator_2 = DisplayName("A value with no usable colours resolves to undefined without throwing")
	local _descriptor_2 = Test(CssBackgroundGradientResolution, "colorlessValue", {
		value = CssBackgroundGradientResolution.colorlessValue,
	})
	if _descriptor_2 then
		CssBackgroundGradientResolution.colorlessValue = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_2(CssBackgroundGradientResolution, "colorlessValue", {
		value = CssBackgroundGradientResolution.colorlessValue,
	})
	if _descriptor_3 then
		CssBackgroundGradientResolution.colorlessValue = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_1(CssBackgroundGradientResolution, "colorlessValue", {
		value = CssBackgroundGradientResolution.colorlessValue,
	})
	if _descriptor_4 then
		CssBackgroundGradientResolution.colorlessValue = _descriptor_4.value
	end
	local _decorator_3 = DisplayName("A single colour becomes a solid two-keypoint sequence and its stops are ignored")
	local _descriptor_5 = Test(CssBackgroundGradientResolution, "singleColorSolid", {
		value = CssBackgroundGradientResolution.singleColorSolid,
	})
	if _descriptor_5 then
		CssBackgroundGradientResolution.singleColorSolid = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(CssBackgroundGradientResolution, "singleColorSolid", {
		value = CssBackgroundGradientResolution.singleColorSolid,
	})
	if _descriptor_6 then
		CssBackgroundGradientResolution.singleColorSolid = _descriptor_6.value
	end
	local _decorator_4 = DisplayName("A ColorSequence is passed through untouched even when stops are also set")
	local _descriptor_7 = Test(CssBackgroundGradientResolution, "sequencePassthrough", {
		value = CssBackgroundGradientResolution.sequencePassthrough,
	})
	if _descriptor_7 then
		CssBackgroundGradientResolution.sequencePassthrough = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(CssBackgroundGradientResolution, "sequencePassthrough", {
		value = CssBackgroundGradientResolution.sequencePassthrough,
	})
	if _descriptor_8 then
		CssBackgroundGradientResolution.sequencePassthrough = _descriptor_8.value
	end
	local _decorator_5 = DisplayName("Three colours without stops are spaced evenly at 0, 0.5 and 1")
	local _descriptor_9 = Test(CssBackgroundGradientResolution, "evenSpacing", {
		value = CssBackgroundGradientResolution.evenSpacing,
	})
	if _descriptor_9 then
		CssBackgroundGradientResolution.evenSpacing = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(CssBackgroundGradientResolution, "evenSpacing", {
		value = CssBackgroundGradientResolution.evenSpacing,
	})
	if _descriptor_10 then
		CssBackgroundGradientResolution.evenSpacing = _descriptor_10.value
	end
	local _decorator_6 = DisplayName("Colours past the end of a short stops array fall back to even spacing")
	local _descriptor_11 = Test(CssBackgroundGradientResolution, "shortStopsFallback", {
		value = CssBackgroundGradientResolution.shortStopsFallback,
	})
	if _descriptor_11 then
		CssBackgroundGradientResolution.shortStopsFallback = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(CssBackgroundGradientResolution, "shortStopsFallback", {
		value = CssBackgroundGradientResolution.shortStopsFallback,
	})
	if _descriptor_12 then
		CssBackgroundGradientResolution.shortStopsFallback = _descriptor_12.value
	end
	local _decorator_7 = DisplayName("Endpoint stops that are not 0 and 1 are overridden so the sequence still spans 0 to 1")
	local _descriptor_13 = Test(CssBackgroundGradientResolution, "endpointsForced", {
		value = CssBackgroundGradientResolution.endpointsForced,
	})
	if _descriptor_13 then
		CssBackgroundGradientResolution.endpointsForced = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_7(CssBackgroundGradientResolution, "endpointsForced", {
		value = CssBackgroundGradientResolution.endpointsForced,
	})
	if _descriptor_14 then
		CssBackgroundGradientResolution.endpointsForced = _descriptor_14.value
	end
	local _decorator_8 = DisplayName("Out-of-order interior stops resolve without throwing and each colour sits at its own stop")
	local _descriptor_15 = Test(CssBackgroundGradientResolution, "outOfOrderStops", {
		value = CssBackgroundGradientResolution.outOfOrderStops,
	})
	if _descriptor_15 then
		CssBackgroundGradientResolution.outOfOrderStops = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_8(CssBackgroundGradientResolution, "outOfOrderStops", {
		value = CssBackgroundGradientResolution.outOfOrderStops,
	})
	if _descriptor_16 then
		CssBackgroundGradientResolution.outOfOrderStops = _descriptor_16.value
	end
	local _decorator_9 = Each({ { "two interior colours", { RED, GREEN, BLUE, WHITE }, { 0, 0.5, 0.5, 1 }, { { 0, RED }, { 0.5, GREEN }, { 0.5, BLUE }, { 1, WHITE } } }, { "tie after reordering", { RED, WHITE, GREEN, BLUE, BLACK }, { 0, 0.8, 0.4, 0.4, 1 }, { { 0, RED }, { 0.4, GREEN }, { 0.4, BLUE }, { 0.8, WHITE }, { 1, BLACK } } }, { "interior tied with the first", { RED, GREEN, BLUE }, { 0, 0, 1 }, { { 0, RED }, { 0, GREEN }, { 1, BLUE } } }, { "interior tied with the last", { RED, GREEN, BLUE }, { 0, 1, 1 }, { { 0, RED }, { 1, GREEN }, { 1, BLUE } } } })
	local _decorator_10 = DisplayName("Colours sharing a stop keep their array order, giving a hard edge")
	local _descriptor_17 = Test(CssBackgroundGradientResolution, "sharedStopKeepsOrder", {
		value = CssBackgroundGradientResolution.sharedStopKeepsOrder,
	})
	if _descriptor_17 then
		CssBackgroundGradientResolution.sharedStopKeepsOrder = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_10(CssBackgroundGradientResolution, "sharedStopKeepsOrder", {
		value = CssBackgroundGradientResolution.sharedStopKeepsOrder,
	})
	if _descriptor_18 then
		CssBackgroundGradientResolution.sharedStopKeepsOrder = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_9(CssBackgroundGradientResolution, "sharedStopKeepsOrder", {
		value = CssBackgroundGradientResolution.sharedStopKeepsOrder,
	})
	if _descriptor_19 then
		CssBackgroundGradientResolution.sharedStopKeepsOrder = _descriptor_19.value
	end
	local _decorator_11 = Each({ { "above one", { 0, 1.5, 1 }, { { 0, RED }, { 1, GREEN }, { 1, BLUE } } }, { "below zero", { 0, -0.5, 1 }, { { 0, RED }, { 0, GREEN }, { 1, BLUE } } } })
	local _decorator_12 = DisplayName("An interior stop outside 0 to 1 is clamped into range")
	local _descriptor_20 = Test(CssBackgroundGradientResolution, "clampsStops", {
		value = CssBackgroundGradientResolution.clampsStops,
	})
	if _descriptor_20 then
		CssBackgroundGradientResolution.clampsStops = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_12(CssBackgroundGradientResolution, "clampsStops", {
		value = CssBackgroundGradientResolution.clampsStops,
	})
	if _descriptor_21 then
		CssBackgroundGradientResolution.clampsStops = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_11(CssBackgroundGradientResolution, "clampsStops", {
		value = CssBackgroundGradientResolution.clampsStops,
	})
	if _descriptor_22 then
		CssBackgroundGradientResolution.clampsStops = _descriptor_22.value
	end
	local _decorator_13 = Each({ { 1.5, 1 }, { -0.5, 0 }, { 0.25, 0.25 } })
	local _decorator_14 = DisplayName("A numeric transparency is clamped to 0 to 1 and applied uniformly")
	local _descriptor_23 = Test(CssBackgroundGradientResolution, "uniformTransparency", {
		value = CssBackgroundGradientResolution.uniformTransparency,
	})
	if _descriptor_23 then
		CssBackgroundGradientResolution.uniformTransparency = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_14(CssBackgroundGradientResolution, "uniformTransparency", {
		value = CssBackgroundGradientResolution.uniformTransparency,
	})
	if _descriptor_24 then
		CssBackgroundGradientResolution.uniformTransparency = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_13(CssBackgroundGradientResolution, "uniformTransparency", {
		value = CssBackgroundGradientResolution.uniformTransparency,
	})
	if _descriptor_25 then
		CssBackgroundGradientResolution.uniformTransparency = _descriptor_25.value
	end
	local _decorator_15 = DisplayName("A NumberSequence transparency passes through untouched and an omitted one stays unset")
	local _descriptor_26 = Test(CssBackgroundGradientResolution, "transparencyPassthrough", {
		value = CssBackgroundGradientResolution.transparencyPassthrough,
	})
	if _descriptor_26 then
		CssBackgroundGradientResolution.transparencyPassthrough = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_15(CssBackgroundGradientResolution, "transparencyPassthrough", {
		value = CssBackgroundGradientResolution.transparencyPassthrough,
	})
	if _descriptor_27 then
		CssBackgroundGradientResolution.transparencyPassthrough = _descriptor_27.value
	end
	local _decorator_16 = DisplayName("Rotation and offset map straight onto the UIGradient props")
	local _descriptor_28 = Test(CssBackgroundGradientResolution, "rotationAndOffset", {
		value = CssBackgroundGradientResolution.rotationAndOffset,
	})
	if _descriptor_28 then
		CssBackgroundGradientResolution.rotationAndOffset = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_16(CssBackgroundGradientResolution, "rotationAndOffset", {
		value = CssBackgroundGradientResolution.rotationAndOffset,
	})
	if _descriptor_29 then
		CssBackgroundGradientResolution.rotationAndOffset = _descriptor_29.value
	end
	CssBackgroundGradientResolution = Tag("Studio")(CssBackgroundGradientResolution) or CssBackgroundGradientResolution
end
return CssBackgroundGradientResolution
