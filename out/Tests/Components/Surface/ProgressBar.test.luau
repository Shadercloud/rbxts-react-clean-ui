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
local ProgressBar = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "ProgressBar").ProgressBar
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedVertically = _layout.assertStackedVertically
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local DEFAULT_TRACK_HEIGHT = 16
local function waitForTrack(host)
	return waitForGuiObject(host, "ProgressBar")
end
local function waitForFillWidth(track, expectedWidth, tolerance)
	local fill = findDescendant(track, "Fill")
	waitForLayout(function()
		return if math.abs(fill.AbsoluteSize.X - expectedWidth) <= tolerance then true else nil
	end, `Timed out waiting for the Fill width {fill.AbsoluteSize.X} to settle within {tolerance} of {expectedWidth}`)
	return fill
end
local ProgressBarMountValidation
do
	ProgressBarMountValidation = setmetatable({}, {
		__tostring = function()
			return "ProgressBarMountValidation"
		end,
	})
	ProgressBarMountValidation.__index = ProgressBarMountValidation
	function ProgressBarMountValidation.new(...)
		local self = setmetatable({}, ProgressBarMountValidation)
		return self:constructor(...) or self
	end
	function ProgressBarMountValidation:constructor()
	end
	function ProgressBarMountValidation:fillFraction(variant, value, max, fraction)
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = value,
			max = max,
		}), function(mounted)
			local track = waitForTrack(mounted.host)
			local trackRect = rect(track)
			local fill = waitForFillWidth(track, trackRect.width * fraction, 1)
			assertSizeApprox(fill, trackRect.width * fraction, trackRect.height, 1, `{variant} fill`)
		end)
	end
	function ProgressBarMountValidation:defaultTrackSize()
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 50,
		}), function(mounted)
			local track = waitForTrack(mounted.host)
			assertSizeApprox(track, 400, DEFAULT_TRACK_HEIGHT, 1, "default track")
			assertContained(track, mounted.host, "default track")
		end)
	end
	function ProgressBarMountValidation:widthOnlyKeepsHeight()
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 50,
			width = "50%",
		}), function(mounted)
			local track = waitForTrack(mounted.host)
			assertSizeApprox(track, 200, DEFAULT_TRACK_HEIGHT, 1, "width-only track")
		end)
	end
	function ProgressBarMountValidation:heightOnlyFullWidth()
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 50,
			height = 24,
		}), function(mounted)
			local track = waitForTrack(mounted.host)
			assertSizeApprox(track, 400, 24, 1, "height-only track")
		end)
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 50,
			height = 24,
			label = "Loading",
		}), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "ProgressBar")
			local track = waitForGuiObject(wrapper, "ProgressBar")
			assertSizeApprox(wrapper, 400, nil, 1, "height-only header wrapper")
			assertSizeApprox(track, 400, 24, 1, "height-only labelled track")
		end)
	end
	function ProgressBarMountValidation:fillContained()
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 75,
			striped = false,
		}), function(mounted)
			local track = waitForTrack(mounted.host)
			local fill = waitForFillWidth(track, rect(track).width * 0.75, 1)
			Assert["true"](Assert, track.ClipsDescendants, "Expected the track to clip its descendants by default")
			assertContained(fill, track, "fill vs track")
			assertAllDescendantsContained(track, "progress bar")
		end)
	end
	function ProgressBarMountValidation:headerLabelAndValue()
		withMounted(400, 100, React.createElement(ProgressBar, {
			value = 1,
			max = 3,
			label = "Loading",
			showValue = true,
		}), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "ProgressBar")
			local track = waitForGuiObject(wrapper, "ProgressBar")
			local header = findDescendant(wrapper, "ProgressBarHeader")
			local label = findDescendant(header, "ProgressBarLabel")
			local valueText = findDescendant(header, "ProgressBarValue")
			Assert:equal(label.Text, "Loading", "Expected the label prop to be rendered verbatim")
			Assert:equal(valueText.Text, "33%", "Expected the default formatter to render math.round(value / max * 100)%")
			assertStackedVertically({ header, track }, "header above track")
			assertContained(header, wrapper, "header vs wrapper")
			assertContained(track, wrapper, "track vs wrapper")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "half", 50, 100, 0.5 }, { "empty", 0, 100, 0 }, { "full", 100, 100, 1 }, { "custom max", 25, 50, 0.5 }, { "clamped above max", 150, 100, 1 }, { "clamped below zero", -20, 100, 0 } })
	local _decorator_2 = DisplayName("The Fill's width is value/max of the track width, clamped to the 0..1 range")
	local _descriptor = Test(ProgressBarMountValidation, "fillFraction", {
		value = ProgressBarMountValidation.fillFraction,
	})
	if _descriptor then
		ProgressBarMountValidation.fillFraction = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(ProgressBarMountValidation, "fillFraction", {
		value = ProgressBarMountValidation.fillFraction,
	})
	if _descriptor_1 then
		ProgressBarMountValidation.fillFraction = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(ProgressBarMountValidation, "fillFraction", {
		value = ProgressBarMountValidation.fillFraction,
	})
	if _descriptor_2 then
		ProgressBarMountValidation.fillFraction = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(ProgressBarMountValidation, "fillFraction", {
		value = ProgressBarMountValidation.fillFraction,
	})
	if _descriptor_3 then
		ProgressBarMountValidation.fillFraction = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Without a header the track spans the host width at the theme's md height")
	local _descriptor_4 = Test(ProgressBarMountValidation, "defaultTrackSize", {
		value = ProgressBarMountValidation.defaultTrackSize,
	})
	if _descriptor_4 then
		ProgressBarMountValidation.defaultTrackSize = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(ProgressBarMountValidation, "defaultTrackSize", {
		value = ProgressBarMountValidation.defaultTrackSize,
	})
	if _descriptor_5 then
		ProgressBarMountValidation.defaultTrackSize = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(ProgressBarMountValidation, "defaultTrackSize", {
		value = ProgressBarMountValidation.defaultTrackSize,
	})
	if _descriptor_6 then
		ProgressBarMountValidation.defaultTrackSize = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Setting only width keeps the theme's md track height instead of collapsing to 0px")
	local _descriptor_7 = Test(ProgressBarMountValidation, "widthOnlyKeepsHeight", {
		value = ProgressBarMountValidation.widthOnlyKeepsHeight,
	})
	if _descriptor_7 then
		ProgressBarMountValidation.widthOnlyKeepsHeight = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(ProgressBarMountValidation, "widthOnlyKeepsHeight", {
		value = ProgressBarMountValidation.widthOnlyKeepsHeight,
	})
	if _descriptor_8 then
		ProgressBarMountValidation.widthOnlyKeepsHeight = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(ProgressBarMountValidation, "widthOnlyKeepsHeight", {
		value = ProgressBarMountValidation.widthOnlyKeepsHeight,
	})
	if _descriptor_9 then
		ProgressBarMountValidation.widthOnlyKeepsHeight = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Setting only height keeps the full host width, with or without a header row")
	local _descriptor_10 = Test(ProgressBarMountValidation, "heightOnlyFullWidth", {
		value = ProgressBarMountValidation.heightOnlyFullWidth,
	})
	if _descriptor_10 then
		ProgressBarMountValidation.heightOnlyFullWidth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(ProgressBarMountValidation, "heightOnlyFullWidth", {
		value = ProgressBarMountValidation.heightOnlyFullWidth,
	})
	if _descriptor_11 then
		ProgressBarMountValidation.heightOnlyFullWidth = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(ProgressBarMountValidation, "heightOnlyFullWidth", {
		value = ProgressBarMountValidation.heightOnlyFullWidth,
	})
	if _descriptor_12 then
		ProgressBarMountValidation.heightOnlyFullWidth = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("The Fill and everything under it stay inside the clipping track")
	local _descriptor_13 = Test(ProgressBarMountValidation, "fillContained", {
		value = ProgressBarMountValidation.fillContained,
	})
	if _descriptor_13 then
		ProgressBarMountValidation.fillContained = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(ProgressBarMountValidation, "fillContained", {
		value = ProgressBarMountValidation.fillContained,
	})
	if _descriptor_14 then
		ProgressBarMountValidation.fillContained = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(ProgressBarMountValidation, "fillContained", {
		value = ProgressBarMountValidation.fillContained,
	})
	if _descriptor_15 then
		ProgressBarMountValidation.fillContained = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("label and showValue render a header with the label text and a rounded percentage above the track")
	local _descriptor_16 = Test(ProgressBarMountValidation, "headerLabelAndValue", {
		value = ProgressBarMountValidation.headerLabelAndValue,
	})
	if _descriptor_16 then
		ProgressBarMountValidation.headerLabelAndValue = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(ProgressBarMountValidation, "headerLabelAndValue", {
		value = ProgressBarMountValidation.headerLabelAndValue,
	})
	if _descriptor_17 then
		ProgressBarMountValidation.headerLabelAndValue = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(ProgressBarMountValidation, "headerLabelAndValue", {
		value = ProgressBarMountValidation.headerLabelAndValue,
	})
	if _descriptor_18 then
		ProgressBarMountValidation.headerLabelAndValue = _descriptor_18.value
	end
	ProgressBarMountValidation = Tag("Studio")(ProgressBarMountValidation) or ProgressBarMountValidation
end
return ProgressBarMountValidation
