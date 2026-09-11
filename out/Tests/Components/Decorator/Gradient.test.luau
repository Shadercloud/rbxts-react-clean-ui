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
local Gradient = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Decorator", "Gradient").Gradient
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local RED = Color3.fromRGB(255, 0, 0)
local GREEN = Color3.fromRGB(0, 255, 0)
local BLUE = Color3.fromRGB(0, 0, 255)
local WHITE = Color3.fromRGB(255, 255, 255)
local function targetWith(decorator)
	return React.createElement("frame", {
		key = "Target",
		Size = UDim2.fromOffset(200, 100),
		BackgroundTransparency = 0,
	}, decorator)
end
local function assertColorKeypoints(sequence, expected, label)
	local keypoints = sequence.Keypoints
	Assert:equal(#keypoints, #expected, `{label}: expected {#expected} colour keypoints, got {#keypoints}`)
	for index = 0, #expected - 1 do
		local _binding_1 = expected[index + 1]
		local time = _binding_1[1]
		local color = _binding_1[2]
		Assert:approximately(keypoints[index + 1].Time, time, 1e-6)
		Assert:equal(keypoints[index + 1].Value, color, `{label}: keypoint {index} colour mismatch`)
	end
end
local GradientMountValidation
do
	GradientMountValidation = setmetatable({}, {
		__tostring = function()
			return "GradientMountValidation"
		end,
	})
	GradientMountValidation.__index = GradientMountValidation
	function GradientMountValidation.new(...)
		local self = setmetatable({}, GradientMountValidation)
		return self:constructor(...) or self
	end
	function GradientMountValidation:constructor()
	end
	function GradientMountValidation:colorsAndRotation()
		withMounted(300, 200, targetWith(React.createElement(Gradient, {
			value = {
				colors = { RED, BLUE },
				rotation = 45,
			},
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local gradient = findDescendant(target, "Gradient")
			Assert:equal(gradient.ClassName, "UIGradient")
			Assert:equal(gradient.Parent, target, "Expected the UIGradient to be a direct child of the decorated frame")
			Assert:equal(gradient.Rotation, 45)
			assertColorKeypoints(gradient.Color, { { 0, RED }, { 1, BLUE } }, "two colours")
		end)
	end
	function GradientMountValidation:stopsTransparencyAndName()
		withMounted(300, 200, targetWith(React.createElement(Gradient, {
			name = "Fade",
			value = {
				colors = { RED, GREEN, BLUE },
				stops = { 0, 0.25, 1 },
				transparency = 0.5,
			},
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local gradient = findDescendant(target, "Fade")
			assertColorKeypoints(gradient.Color, { { 0, RED }, { 0.25, GREEN }, { 1, BLUE } }, "three colours with stops")
			local transparency = gradient.Transparency.Keypoints
			for index = 0, #transparency - 1 do
				Assert:approximately(transparency[index + 1].Value, 0.5, 1e-6)
			end
			Assert:undefined(target:FindFirstChild("Gradient"), "Expected the default Gradient name not to be used when name is set")
		end)
	end
	function GradientMountValidation:noValueEmitsNothing()
		withMounted(300, 200, targetWith(React.createElement(Gradient)), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UIGradient"), "Expected no UIGradient when value is omitted")
		end)
	end
	function GradientMountValidation:colorlessValueEmitsNothing(label, value)
		withMounted(300, 200, targetWith(React.createElement(Gradient, {
			value = value,
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			Assert:undefined(target:FindFirstChildWhichIsA("UIGradient"), `{label}: expected no UIGradient`)
		end)
	end
	function GradientMountValidation:outOfOrderStopsMount()
		withMounted(300, 200, targetWith(React.createElement(Gradient, {
			value = {
				colors = { RED, GREEN, BLUE, WHITE },
				stops = { 0, 0.7, 0.3, 1 },
			},
		})), function(mounted)
			local target = waitForGuiObject(mounted.host, "Target")
			local gradient = findDescendant(target, "Gradient")
			assertColorKeypoints(gradient.Color, { { 0, RED }, { 0.3, BLUE }, { 0.7, GREEN }, { 1, WHITE } }, "out-of-order stops")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Two colours and a rotation emit a UIGradient named Gradient with evenly spaced keypoints and that Rotation")
	local _descriptor = Test(GradientMountValidation, "colorsAndRotation", {
		value = GradientMountValidation.colorsAndRotation,
	})
	if _descriptor then
		GradientMountValidation.colorsAndRotation = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(GradientMountValidation, "colorsAndRotation", {
		value = GradientMountValidation.colorsAndRotation,
	})
	if _descriptor_1 then
		GradientMountValidation.colorsAndRotation = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(GradientMountValidation, "colorsAndRotation", {
		value = GradientMountValidation.colorsAndRotation,
	})
	if _descriptor_2 then
		GradientMountValidation.colorsAndRotation = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Explicit stops position the middle keypoint, a numeric transparency becomes a flat NumberSequence, and name renames the instance")
	local _descriptor_3 = Test(GradientMountValidation, "stopsTransparencyAndName", {
		value = GradientMountValidation.stopsTransparencyAndName,
	})
	if _descriptor_3 then
		GradientMountValidation.stopsTransparencyAndName = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(GradientMountValidation, "stopsTransparencyAndName", {
		value = GradientMountValidation.stopsTransparencyAndName,
	})
	if _descriptor_4 then
		GradientMountValidation.stopsTransparencyAndName = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(GradientMountValidation, "stopsTransparencyAndName", {
		value = GradientMountValidation.stopsTransparencyAndName,
	})
	if _descriptor_5 then
		GradientMountValidation.stopsTransparencyAndName = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Omitting the value prop emits no UIGradient at all")
	local _descriptor_6 = Test(GradientMountValidation, "noValueEmitsNothing", {
		value = GradientMountValidation.noValueEmitsNothing,
	})
	if _descriptor_6 then
		GradientMountValidation.noValueEmitsNothing = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(GradientMountValidation, "noValueEmitsNothing", {
		value = GradientMountValidation.noValueEmitsNothing,
	})
	if _descriptor_7 then
		GradientMountValidation.noValueEmitsNothing = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(GradientMountValidation, "noValueEmitsNothing", {
		value = GradientMountValidation.noValueEmitsNothing,
	})
	if _descriptor_8 then
		GradientMountValidation.noValueEmitsNothing = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { "rotation only", {
		rotation = 45,
	} }, { "empty colour array", {
		colors = {},
	} } })
	local _decorator_8 = DisplayName("A value with no usable colours still renders the surrounding tree and emits no UIGradient")
	local _descriptor_9 = Test(GradientMountValidation, "colorlessValueEmitsNothing", {
		value = GradientMountValidation.colorlessValueEmitsNothing,
	})
	if _descriptor_9 then
		GradientMountValidation.colorlessValueEmitsNothing = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_8(GradientMountValidation, "colorlessValueEmitsNothing", {
		value = GradientMountValidation.colorlessValueEmitsNothing,
	})
	if _descriptor_10 then
		GradientMountValidation.colorlessValueEmitsNothing = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_7(GradientMountValidation, "colorlessValueEmitsNothing", {
		value = GradientMountValidation.colorlessValueEmitsNothing,
	})
	if _descriptor_11 then
		GradientMountValidation.colorlessValueEmitsNothing = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(GradientMountValidation, "colorlessValueEmitsNothing", {
		value = GradientMountValidation.colorlessValueEmitsNothing,
	})
	if _descriptor_12 then
		GradientMountValidation.colorlessValueEmitsNothing = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Out-of-order interior stops mount a UIGradient whose keypoints are sorted by position")
	local _descriptor_13 = Test(GradientMountValidation, "outOfOrderStopsMount", {
		value = GradientMountValidation.outOfOrderStopsMount,
	})
	if _descriptor_13 then
		GradientMountValidation.outOfOrderStopsMount = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(GradientMountValidation, "outOfOrderStopsMount", {
		value = GradientMountValidation.outOfOrderStopsMount,
	})
	if _descriptor_14 then
		GradientMountValidation.outOfOrderStopsMount = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(GradientMountValidation, "outOfOrderStopsMount", {
		value = GradientMountValidation.outOfOrderStopsMount,
	})
	if _descriptor_15 then
		GradientMountValidation.outOfOrderStopsMount = _descriptor_15.value
	end
	GradientMountValidation = Tag("Studio")(GradientMountValidation) or GradientMountValidation
end
return GradientMountValidation
