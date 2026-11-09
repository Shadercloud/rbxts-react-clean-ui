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
local Scroller = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Scroller").Scroller
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 150
local TALL_HEIGHT = 600
local THRESHOLD = 20
local function newLog()
	return {
		nearEnd = 0,
		positions = {},
		frames = {},
	}
end
local function trackedScroller(log, childHeight)
	return React.createElement(Scroller, {
		nearEndThreshold = THRESHOLD,
		onNearEnd = function()
			local _original = log.nearEnd
			log.nearEnd += 1
			return _original
		end,
		onScroll = function(position, frame)
			local _positions = log.positions
			local _y = position.Y
			table.insert(_positions, _y)
			local _frames = log.frames
			local _frame = frame
			table.insert(_frames, _frame)
		end,
	}, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, childHeight),
		BackgroundTransparency = 1,
	}))
end
local function waitForCanvas(host, height)
	return waitForGuiObject(host, "Scroller", function(gui)
		return gui.AbsoluteCanvasSize.Y >= height and gui.AbsoluteWindowSize.Y > 0
	end, `Timed out waiting for the canvas to reach {height}px`)
end
local function endPosition(scroller)
	return scroller.AbsoluteCanvasSize.Y - scroller.AbsoluteWindowSize.Y
end
local function scrollTo(scroller, y)
	scroller.CanvasPosition = Vector2.new(0, y)
	settleFrames(2)
end
local ScrollerScrollCallbacks
do
	ScrollerScrollCallbacks = setmetatable({}, {
		__tostring = function()
			return "ScrollerScrollCallbacks"
		end,
	})
	ScrollerScrollCallbacks.__index = ScrollerScrollCallbacks
	function ScrollerScrollCallbacks.new(...)
		local self = setmetatable({}, ScrollerScrollCallbacks)
		return self:constructor(...) or self
	end
	function ScrollerScrollCallbacks:constructor()
	end
	function ScrollerScrollCallbacks:onScrollReports()
		local log = newLog()
		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), function(mounted)
			local scroller = waitForCanvas(mounted.host, TALL_HEIGHT)
			settleFrames(2)
			local before = #log.positions
			scrollTo(scroller, 40)
			Assert["true"](Assert, #log.positions > before, "Expected onScroll to be called after CanvasPosition changed")
			Assert:equal(log.positions[#log.positions], 40)
			Assert:equal(log.frames[#log.frames], scroller)
		end)
	end
	function ScrollerScrollCallbacks:oncePerApproach()
		local log = newLog()
		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), function(mounted)
			local scroller = waitForCanvas(mounted.host, TALL_HEIGHT)
			local finish = endPosition(scroller)
			settleFrames(2)
			Assert:equal(log.nearEnd, 0, "Expected no near-end call while the end is far away")
			scrollTo(scroller, finish - THRESHOLD - 10)
			Assert:equal(log.nearEnd, 0, "Expected no near-end call just outside the threshold")
			scrollTo(scroller, finish - THRESHOLD + 5)
			Assert:equal(log.nearEnd, 1, "Expected one near-end call inside the threshold")
			scrollTo(scroller, finish - 5)
			scrollTo(scroller, finish)
			Assert:equal(log.nearEnd, 1, "Expected no repeat call while staying near the end")
		end)
	end
	function ScrollerScrollCallbacks:rearmsScrollingAway()
		local log = newLog()
		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), function(mounted)
			local scroller = waitForCanvas(mounted.host, TALL_HEIGHT)
			local finish = endPosition(scroller)
			scrollTo(scroller, finish)
			Assert:equal(log.nearEnd, 1)
			scrollTo(scroller, 0)
			Assert:equal(log.nearEnd, 1, "Expected no call while scrolling away")
			scrollTo(scroller, finish)
			Assert:equal(log.nearEnd, 2, "Expected a second call on the second approach")
		end)
	end
	function ScrollerScrollCallbacks:rearmsOnGrowth()
		local log = newLog()
		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, TALL_HEIGHT), function(mounted)
			local scroller = waitForCanvas(mounted.host, TALL_HEIGHT)
			scrollTo(scroller, endPosition(scroller))
			Assert:equal(log.nearEnd, 1)
			mounted.update(trackedScroller(log, TALL_HEIGHT + 5))
			waitForLayout(function()
				return if log.nearEnd >= 2 then true else nil
			end, `Timed out waiting for onNearEnd to fire again after the canvas grew (calls {log.nearEnd}, canvas {scroller.AbsoluteCanvasSize.Y})`)
			settleFrames(3)
			Assert:equal(log.nearEnd, 2, "Expected exactly one extra call for the growth")
		end)
	end
	function ScrollerScrollCallbacks:firesOnMountShort()
		local log = newLog()
		withMounted(HOST_WIDTH, HOST_HEIGHT, trackedScroller(log, 50), function(mounted)
			waitForGuiObject(mounted.host, "Scroller")
			waitForLayout(function()
				return if log.nearEnd >= 1 then true else nil
			end, "Timed out waiting for onNearEnd to fire for short content")
		end)
	end
	function ScrollerScrollCallbacks:negativeThresholdZero()
		local calls = 0
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Scroller, {
			nearEndThreshold = -50,
			onNearEnd = function()
				local _original = calls
				calls += 1
				return _original
			end,
		}, React.createElement("frame", {
			key = "Content",
			Size = UDim2.new(1, 0, 0, TALL_HEIGHT),
			BackgroundTransparency = 1,
		})), function(mounted)
			local scroller = waitForCanvas(mounted.host, TALL_HEIGHT)
			local finish = endPosition(scroller)
			scrollTo(scroller, finish - 1)
			Assert:equal(calls, 0, "Expected no call one pixel before the end")
			scrollTo(scroller, finish)
			Assert:equal(calls, 1, "Expected a call at the very end")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Setting CanvasPosition from code calls onScroll with the new position and the ScrollingFrame")
	local _descriptor = Test(ScrollerScrollCallbacks, "onScrollReports", {
		value = ScrollerScrollCallbacks.onScrollReports,
	})
	if _descriptor then
		ScrollerScrollCallbacks.onScrollReports = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ScrollerScrollCallbacks, "onScrollReports", {
		value = ScrollerScrollCallbacks.onScrollReports,
	})
	if _descriptor_1 then
		ScrollerScrollCallbacks.onScrollReports = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ScrollerScrollCallbacks, "onScrollReports", {
		value = ScrollerScrollCallbacks.onScrollReports,
	})
	if _descriptor_2 then
		ScrollerScrollCallbacks.onScrollReports = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("onNearEnd stays quiet outside the threshold and fires exactly once while the end stays within it")
	local _descriptor_3 = Test(ScrollerScrollCallbacks, "oncePerApproach", {
		value = ScrollerScrollCallbacks.oncePerApproach,
	})
	if _descriptor_3 then
		ScrollerScrollCallbacks.oncePerApproach = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ScrollerScrollCallbacks, "oncePerApproach", {
		value = ScrollerScrollCallbacks.oncePerApproach,
	})
	if _descriptor_4 then
		ScrollerScrollCallbacks.oncePerApproach = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ScrollerScrollCallbacks, "oncePerApproach", {
		value = ScrollerScrollCallbacks.oncePerApproach,
	})
	if _descriptor_5 then
		ScrollerScrollCallbacks.oncePerApproach = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Scrolling back out past the threshold re-arms onNearEnd for the next approach")
	local _descriptor_6 = Test(ScrollerScrollCallbacks, "rearmsScrollingAway", {
		value = ScrollerScrollCallbacks.rearmsScrollingAway,
	})
	if _descriptor_6 then
		ScrollerScrollCallbacks.rearmsScrollingAway = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ScrollerScrollCallbacks, "rearmsScrollingAway", {
		value = ScrollerScrollCallbacks.rearmsScrollingAway,
	})
	if _descriptor_7 then
		ScrollerScrollCallbacks.rearmsScrollingAway = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ScrollerScrollCallbacks, "rearmsScrollingAway", {
		value = ScrollerScrollCallbacks.rearmsScrollingAway,
	})
	if _descriptor_8 then
		ScrollerScrollCallbacks.rearmsScrollingAway = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A canvas that grows while the end is still within the threshold fires onNearEnd again without scrolling")
	local _descriptor_9 = Test(ScrollerScrollCallbacks, "rearmsOnGrowth", {
		value = ScrollerScrollCallbacks.rearmsOnGrowth,
	})
	if _descriptor_9 then
		ScrollerScrollCallbacks.rearmsOnGrowth = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ScrollerScrollCallbacks, "rearmsOnGrowth", {
		value = ScrollerScrollCallbacks.rearmsOnGrowth,
	})
	if _descriptor_10 then
		ScrollerScrollCallbacks.rearmsOnGrowth = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ScrollerScrollCallbacks, "rearmsOnGrowth", {
		value = ScrollerScrollCallbacks.rearmsOnGrowth,
	})
	if _descriptor_11 then
		ScrollerScrollCallbacks.rearmsOnGrowth = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Content that does not overflow counts as the end, so onNearEnd fires on mount")
	local _descriptor_12 = Test(ScrollerScrollCallbacks, "firesOnMountShort", {
		value = ScrollerScrollCallbacks.firesOnMountShort,
	})
	if _descriptor_12 then
		ScrollerScrollCallbacks.firesOnMountShort = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ScrollerScrollCallbacks, "firesOnMountShort", {
		value = ScrollerScrollCallbacks.firesOnMountShort,
	})
	if _descriptor_13 then
		ScrollerScrollCallbacks.firesOnMountShort = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ScrollerScrollCallbacks, "firesOnMountShort", {
		value = ScrollerScrollCallbacks.firesOnMountShort,
	})
	if _descriptor_14 then
		ScrollerScrollCallbacks.firesOnMountShort = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A negative nearEndThreshold behaves like 0 and only fires at the very end")
	local _descriptor_15 = Test(ScrollerScrollCallbacks, "negativeThresholdZero", {
		value = ScrollerScrollCallbacks.negativeThresholdZero,
	})
	if _descriptor_15 then
		ScrollerScrollCallbacks.negativeThresholdZero = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ScrollerScrollCallbacks, "negativeThresholdZero", {
		value = ScrollerScrollCallbacks.negativeThresholdZero,
	})
	if _descriptor_16 then
		ScrollerScrollCallbacks.negativeThresholdZero = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ScrollerScrollCallbacks, "negativeThresholdZero", {
		value = ScrollerScrollCallbacks.negativeThresholdZero,
	})
	if _descriptor_17 then
		ScrollerScrollCallbacks.negativeThresholdZero = _descriptor_17.value
	end
	ScrollerScrollCallbacks = Tag("Studio")(ScrollerScrollCallbacks) or ScrollerScrollCallbacks
end
return ScrollerScrollCallbacks
