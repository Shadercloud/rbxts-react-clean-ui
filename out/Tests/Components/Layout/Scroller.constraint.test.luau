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
local assertSizeApprox = _layout.assertSizeApprox
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 400
local WINDOW_HEIGHT = 200
local CONTENT_HEIGHT = 600
local SCROLLBAR_THICKNESS = 12
local function waitForWrapper(host)
	local wrapper = waitForGuiObject(host, "Scroller")
	Assert["true"](Assert, wrapper:IsA("Frame"), `Expected a min/max Scroller root to be a wrapper Frame, got {wrapper.ClassName}`)
	return wrapper
end
local function waitForOverflow(wrapper)
	return waitForGuiObject(wrapper, "ScrollingFrame", function(gui)
		return gui.AbsoluteWindowSize.Y > 0 and gui.AbsoluteCanvasSize.Y >= CONTENT_HEIGHT
	end, `Timed out waiting for the inner ScrollingFrame canvas to grow to {CONTENT_HEIGHT}px`)
end
local function assertNoConstraintUnder(scroller)
	for _, descendant in scroller:GetDescendants() do
		Assert["false"](Assert, descendant:IsA("UISizeConstraint"), `Expected no UISizeConstraint under the ScrollingFrame, found {descendant:GetFullName()}`)
	end
end
local function assertScrolls(wrapper)
	local scroller = waitForOverflow(wrapper)
	assertNoConstraintUnder(scroller)
	assertSizeApprox(scroller, nil, WINDOW_HEIGHT, 1, "ScrollingFrame window")
	Assert["true"](Assert, scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y, `Expected the canvas ({scroller.AbsoluteCanvasSize.Y}) to exceed the window ({scroller.AbsoluteWindowSize.Y})`)
	waitForGuiObject(scroller, "ScrollerContent", function(gui)
		return gui.AbsoluteSize.X <= scroller.AbsoluteSize.X - SCROLLBAR_THICKNESS
	end, "Timed out waiting for ScrollerContent to reserve width for the scrollbar")
end
local function tallScroller(props)
	return React.createElement(Scroller, {
		height = props.height,
		minHeight = props.minHeight,
		maxHeight = props.maxHeight,
	}, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, CONTENT_HEIGHT),
		BackgroundTransparency = 1,
	}))
end
local ScrollerSizeConstraint
do
	ScrollerSizeConstraint = setmetatable({}, {
		__tostring = function()
			return "ScrollerSizeConstraint"
		end,
	})
	ScrollerSizeConstraint.__index = ScrollerSizeConstraint
	function ScrollerSizeConstraint.new(...)
		local self = setmetatable({}, ScrollerSizeConstraint)
		return self:constructor(...) or self
	end
	function ScrollerSizeConstraint:constructor()
	end
	function ScrollerSizeConstraint:maxHeightScrolls()
		withMounted(HOST_WIDTH, HOST_HEIGHT, tallScroller({
			height = WINDOW_HEIGHT,
			maxHeight = WINDOW_HEIGHT,
		}), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			Assert:equal(soleSizeConstraint(wrapper).MaxSize.Y, WINDOW_HEIGHT)
			assertScrolls(wrapper)
		end)
	end
	function ScrollerSizeConstraint:minHeightScrolls()
		withMounted(HOST_WIDTH, HOST_HEIGHT, tallScroller({
			height = 120,
			minHeight = WINDOW_HEIGHT,
		}), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			Assert:equal(soleSizeConstraint(wrapper).MinSize.Y, WINDOW_HEIGHT)
			assertScrolls(wrapper)
		end)
	end
	function ScrollerSizeConstraint:noChromeWithoutTheme()
		withMounted(HOST_WIDTH, HOST_HEIGHT, tallScroller({
			height = WINDOW_HEIGHT,
			maxHeight = WINDOW_HEIGHT,
		}), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForOverflow(wrapper)
			Assert:equal(scroller.Parent, wrapper)
			Assert:equal(scroller.ScrollBarImageTransparency, 0)
			Assert:undefined(wrapper:FindFirstChild("ScrollerTrack"))
			Assert:undefined(wrapper:FindFirstChild("ScrollerThumb"))
		end)
	end
	function ScrollerSizeConstraint:constrainedRef()
		local ref = React.createRef()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Scroller, {
			ref = ref,
			maxHeight = WINDOW_HEIGHT,
		}), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForGuiObject(wrapper, "ScrollingFrame")
			Assert:equal(ref.current, scroller)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A maxHeight on a plain-theme Scroller clamps the wrapper while tall content still overflows and scrolls")
	local _descriptor = Test(ScrollerSizeConstraint, "maxHeightScrolls", {
		value = ScrollerSizeConstraint.maxHeightScrolls,
	})
	if _descriptor then
		ScrollerSizeConstraint.maxHeightScrolls = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ScrollerSizeConstraint, "maxHeightScrolls", {
		value = ScrollerSizeConstraint.maxHeightScrolls,
	})
	if _descriptor_1 then
		ScrollerSizeConstraint.maxHeightScrolls = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ScrollerSizeConstraint, "maxHeightScrolls", {
		value = ScrollerSizeConstraint.maxHeightScrolls,
	})
	if _descriptor_2 then
		ScrollerSizeConstraint.maxHeightScrolls = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A minHeight raises the wrapper to its floor and tall content inside still overflows and scrolls")
	local _descriptor_3 = Test(ScrollerSizeConstraint, "minHeightScrolls", {
		value = ScrollerSizeConstraint.minHeightScrolls,
	})
	if _descriptor_3 then
		ScrollerSizeConstraint.minHeightScrolls = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ScrollerSizeConstraint, "minHeightScrolls", {
		value = ScrollerSizeConstraint.minHeightScrolls,
	})
	if _descriptor_4 then
		ScrollerSizeConstraint.minHeightScrolls = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ScrollerSizeConstraint, "minHeightScrolls", {
		value = ScrollerSizeConstraint.minHeightScrolls,
	})
	if _descriptor_5 then
		ScrollerSizeConstraint.minHeightScrolls = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A min or max prop alone wraps the plain theme without drawing ScrollerTrack or ScrollerThumb")
	local _descriptor_6 = Test(ScrollerSizeConstraint, "noChromeWithoutTheme", {
		value = ScrollerSizeConstraint.noChromeWithoutTheme,
	})
	if _descriptor_6 then
		ScrollerSizeConstraint.noChromeWithoutTheme = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ScrollerSizeConstraint, "noChromeWithoutTheme", {
		value = ScrollerSizeConstraint.noChromeWithoutTheme,
	})
	if _descriptor_7 then
		ScrollerSizeConstraint.noChromeWithoutTheme = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ScrollerSizeConstraint, "noChromeWithoutTheme", {
		value = ScrollerSizeConstraint.noChromeWithoutTheme,
	})
	if _descriptor_8 then
		ScrollerSizeConstraint.noChromeWithoutTheme = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("With a min or max prop the forwarded ref receives the inner ScrollingFrame, not the wrapper Frame")
	local _descriptor_9 = Test(ScrollerSizeConstraint, "constrainedRef", {
		value = ScrollerSizeConstraint.constrainedRef,
	})
	if _descriptor_9 then
		ScrollerSizeConstraint.constrainedRef = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ScrollerSizeConstraint, "constrainedRef", {
		value = ScrollerSizeConstraint.constrainedRef,
	})
	if _descriptor_10 then
		ScrollerSizeConstraint.constrainedRef = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ScrollerSizeConstraint, "constrainedRef", {
		value = ScrollerSizeConstraint.constrainedRef,
	})
	if _descriptor_11 then
		ScrollerSizeConstraint.constrainedRef = _descriptor_11.value
	end
	ScrollerSizeConstraint = Tag("Studio")(ScrollerSizeConstraint) or ScrollerSizeConstraint
end
return ScrollerSizeConstraint
