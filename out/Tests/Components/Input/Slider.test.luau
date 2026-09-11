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
local Slider = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Slider").Slider
local SizeHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SizeHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedHorizontally = _layout.assertStackedHorizontally
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local function waitForSlider(host)
	return waitForGuiObject(host, "Slider")
end
local function waitForHandleContainer(slider)
	return waitForGuiObject(slider, "HandleContainer")
end
local function waitForHandle(slider, index)
	return waitForGuiObject(slider, `Handle-{index}`)
end
local function assertHandleAtFraction(handle, container, fraction, label)
	local containerRect = rect(container)
	local expectedCenterX = containerRect.left + fraction * containerRect.width
	local actualCenterX = rect(handle).centerX
	Assert["true"](Assert, math.abs(actualCenterX - expectedCenterX) <= 1, `{label}: expected {handle:GetFullName()} centerX {actualCenterX} to be within 1px of {expectedCenterX} (fraction {fraction} of the HandleContainer)`)
end
local SliderMountValidation
do
	SliderMountValidation = setmetatable({}, {
		__tostring = function()
			return "SliderMountValidation"
		end,
	})
	SliderMountValidation.__index = SliderMountValidation
	function SliderMountValidation.new(...)
		local self = setmetatable({}, SliderMountValidation)
		return self:constructor(...) or self
	end
	function SliderMountValidation:constructor()
	end
	function SliderMountValidation:mountsContained()
		withMounted(400, 100, React.createElement(Slider, {
			["max-value"] = 100,
			value = 50,
		}), function(mounted)
			local slider = waitForSlider(mounted.host)
			waitForHandle(slider, 0)
			assertSizeApprox(slider, 400, SizeHelper:toUDim(DefaultTheme.components.slider.height).Offset, 1, "default size")
			assertAllDescendantsContained(slider, "single-value slider")
		end)
	end
	function SliderMountValidation:handleReflectsValue(value, fraction)
		withMounted(400, 100, React.createElement(Slider, {
			["max-value"] = 100,
			value = value,
		}), function(mounted)
			local slider = waitForSlider(mounted.host)
			local container = waitForHandleContainer(slider)
			local handle = waitForHandle(slider, 0)
			assertHandleAtFraction(handle, container, fraction, `value={value}`)
		end)
	end
	function SliderMountValidation:respectsMinValue()
		withMounted(400, 100, React.createElement(Slider, {
			["min-value"] = 20,
			["max-value"] = 60,
			value = 30,
		}), function(mounted)
			local slider = waitForSlider(mounted.host)
			local container = waitForHandleContainer(slider)
			local handle = waitForHandle(slider, 0)
			assertHandleAtFraction(handle, container, 0.25, "min-value=20")
		end)
	end
	function SliderMountValidation:controlledFollowsProp(controlled, expectedFraction)
		withMounted(400, 100, React.createElement(Slider, {
			["max-value"] = 100,
			value = 25,
			controlled = controlled,
		}), function(mounted)
			local slider = waitForSlider(mounted.host)
			local container = waitForHandleContainer(slider)
			local handle = waitForHandle(slider, 0)
			assertHandleAtFraction(handle, container, 0.25, "before re-render")
			mounted.update(React.createElement(Slider, {
				["max-value"] = 100,
				value = 75,
				controlled = controlled,
			}))
			if controlled then
				waitForLayout(function()
					return if handle.Position.X.Scale == 0.75 then true else nil
				end, "Timed out waiting for the controlled handle to move to the new value prop")
			end
			assertHandleAtFraction(handle, container, expectedFraction, `controlled={controlled} after re-render`)
		end)
	end
	function SliderMountValidation:rangeRendersTwoHandles()
		withMounted(400, 100, React.createElement(Slider, {
			["max-value"] = 100,
			range = true,
			value = Vector2.new(20, 80),
			highlight = "middle",
		}), function(mounted)
			local slider = waitForSlider(mounted.host)
			local container = waitForHandleContainer(slider)
			local lower = waitForHandle(slider, 0)
			local upper = waitForHandle(slider, 1)
			local highlight = waitForGuiObject(slider, "Highlight")
			assertHandleAtFraction(lower, container, 0.2, "range lower handle")
			assertHandleAtFraction(upper, container, 0.8, "range upper handle")
			assertStackedHorizontally({ lower, upper }, "range handles")
			local highlightRect = rect(highlight)
			Assert["true"](Assert, math.abs(highlightRect.left - rect(lower).centerX) <= 1 and math.abs(highlightRect.right - rect(upper).centerX) <= 1, `Expected the middle highlight [{highlightRect.left}, {highlightRect.right}] to span from the lower handle centre ({rect(lower).centerX}) to the upper handle centre ({rect(upper).centerX})`)
			assertAllDescendantsContained(slider, "range slider")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A single-value slider fills the host width at the theme height and keeps the bar and handle inside itself")
	local _descriptor = Test(SliderMountValidation, "mountsContained", {
		value = SliderMountValidation.mountsContained,
	})
	if _descriptor then
		SliderMountValidation.mountsContained = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SliderMountValidation, "mountsContained", {
		value = SliderMountValidation.mountsContained,
	})
	if _descriptor_1 then
		SliderMountValidation.mountsContained = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SliderMountValidation, "mountsContained", {
		value = SliderMountValidation.mountsContained,
	})
	if _descriptor_2 then
		SliderMountValidation.mountsContained = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { 0, 0 }, { 50, 0.5 }, { 100, 1 } })
	local _decorator_4 = DisplayName("The handle's centre sits at the value's fraction of the min/max range across the HandleContainer")
	local _descriptor_3 = Test(SliderMountValidation, "handleReflectsValue", {
		value = SliderMountValidation.handleReflectsValue,
	})
	if _descriptor_3 then
		SliderMountValidation.handleReflectsValue = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(SliderMountValidation, "handleReflectsValue", {
		value = SliderMountValidation.handleReflectsValue,
	})
	if _descriptor_4 then
		SliderMountValidation.handleReflectsValue = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(SliderMountValidation, "handleReflectsValue", {
		value = SliderMountValidation.handleReflectsValue,
	})
	if _descriptor_5 then
		SliderMountValidation.handleReflectsValue = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(SliderMountValidation, "handleReflectsValue", {
		value = SliderMountValidation.handleReflectsValue,
	})
	if _descriptor_6 then
		SliderMountValidation.handleReflectsValue = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("min-value offsets the range so the handle fraction is measured from min-value, not zero")
	local _descriptor_7 = Test(SliderMountValidation, "respectsMinValue", {
		value = SliderMountValidation.respectsMinValue,
	})
	if _descriptor_7 then
		SliderMountValidation.respectsMinValue = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(SliderMountValidation, "respectsMinValue", {
		value = SliderMountValidation.respectsMinValue,
	})
	if _descriptor_8 then
		SliderMountValidation.respectsMinValue = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(SliderMountValidation, "respectsMinValue", {
		value = SliderMountValidation.respectsMinValue,
	})
	if _descriptor_9 then
		SliderMountValidation.respectsMinValue = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = Each({ { true, 0.75 }, { false, 0.25 } })
	local _decorator_9 = DisplayName("Re-rendering with a new value moves the handle only when controlled; uncontrolled keeps the seeded value")
	local _descriptor_10 = Test(SliderMountValidation, "controlledFollowsProp", {
		value = SliderMountValidation.controlledFollowsProp,
	})
	if _descriptor_10 then
		SliderMountValidation.controlledFollowsProp = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_9(SliderMountValidation, "controlledFollowsProp", {
		value = SliderMountValidation.controlledFollowsProp,
	})
	if _descriptor_11 then
		SliderMountValidation.controlledFollowsProp = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(SliderMountValidation, "controlledFollowsProp", {
		value = SliderMountValidation.controlledFollowsProp,
	})
	if _descriptor_12 then
		SliderMountValidation.controlledFollowsProp = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(SliderMountValidation, "controlledFollowsProp", {
		value = SliderMountValidation.controlledFollowsProp,
	})
	if _descriptor_13 then
		SliderMountValidation.controlledFollowsProp = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("range={true} renders two ordered handles at the Vector2 bounds, with a middle highlight spanning between them")
	local _descriptor_14 = Test(SliderMountValidation, "rangeRendersTwoHandles", {
		value = SliderMountValidation.rangeRendersTwoHandles,
	})
	if _descriptor_14 then
		SliderMountValidation.rangeRendersTwoHandles = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(SliderMountValidation, "rangeRendersTwoHandles", {
		value = SliderMountValidation.rangeRendersTwoHandles,
	})
	if _descriptor_15 then
		SliderMountValidation.rangeRendersTwoHandles = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(SliderMountValidation, "rangeRendersTwoHandles", {
		value = SliderMountValidation.rangeRendersTwoHandles,
	})
	if _descriptor_16 then
		SliderMountValidation.rangeRendersTwoHandles = _descriptor_16.value
	end
	SliderMountValidation = Tag("Studio")(SliderMountValidation) or SliderMountValidation
end
return SliderMountValidation
