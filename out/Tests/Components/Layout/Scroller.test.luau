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
local Scroller = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Scroller").Scroller
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers", "spacing.helper").SpacingHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 150
local SCROLLBAR_THICKNESS = 12
local DEFAULT_GUTTER = SCROLLBAR_THICKNESS + SpacingHelper:GetPadding(DefaultTheme, nil)
local function scrollerWithChild(childHeight)
	return React.createElement(Scroller, nil, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, childHeight),
		BackgroundTransparency = 1,
	}))
end
local function stableScroller(childHeight)
	return React.createElement(Scroller, {
		stableGutter = true,
	}, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, childHeight),
		BackgroundTransparency = 1,
	}))
end
local function waitForScroller(host)
	return waitForGuiObject(host, "Scroller")
end
local ScrollerMountValidation
do
	ScrollerMountValidation = setmetatable({}, {
		__tostring = function()
			return "ScrollerMountValidation"
		end,
	})
	ScrollerMountValidation.__index = ScrollerMountValidation
	function ScrollerMountValidation.new(...)
		local self = setmetatable({}, ScrollerMountValidation)
		return self:constructor(...) or self
	end
	function ScrollerMountValidation:constructor()
	end
	function ScrollerMountValidation:fillsHostByDefault()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			assertSizeApprox(scroller, HOST_WIDTH, HOST_HEIGHT, 1, "default size")
			Assert:equal(scroller.AutomaticCanvasSize, Enum.AutomaticSize.Y)
			Assert:equal(scroller.ScrollingDirection, Enum.ScrollingDirection.Y)
		end)
	end
	function ScrollerMountValidation:shortContentContained()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			local content = waitForGuiObject(scroller, "ScrollerContent")
			assertAllDescendantsContained(scroller, "short content")
			Assert["true"](Assert, scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y, `Expected a 50px child not to overflow: canvas {scroller.AbsoluteCanvasSize.Y} vs window {scroller.AbsoluteWindowSize.Y}`)
			assertSizeApprox(content, HOST_WIDTH, nil, 1, "short content width")
		end)
	end
	function ScrollerMountValidation:canvasGrowsWithContent()
		local tallHeight = 400
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(tallHeight), function(mounted)
			local scroller = waitForGuiObject(mounted.host, "Scroller", function(gui)
				return gui.AbsoluteCanvasSize.Y >= tallHeight
			end, `Timed out waiting for the canvas to grow to at least {tallHeight}px`)
			Assert["true"](Assert, scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y, `Expected the canvas ({scroller.AbsoluteCanvasSize.Y}) to exceed the window ({scroller.AbsoluteWindowSize.Y})`)
			local content = waitForGuiObject(scroller, "ScrollerContent", function(gui)
				return gui.AbsoluteSize.X <= scroller.AbsoluteSize.X - SCROLLBAR_THICKNESS
			end, "Timed out waiting for ScrollerContent to reserve width for the scrollbar")
			local child = findDescendant(content, "Content")
			assertContained(child, content, "tall child vs content frame")
		end)
	end
	function ScrollerMountValidation:insetNone(stable)
		local element = if stable then stableScroller(50) else scrollerWithChild(50)
		withMounted(HOST_WIDTH, HOST_HEIGHT, element, function(mounted)
			local scroller = waitForScroller(mounted.host)
			Assert:equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None)
			Assert:equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X)
		end)
	end
	function ScrollerMountValidation:contentWidth(stable, childHeight, reserves)
		local element = if stable then stableScroller(childHeight) else scrollerWithChild(childHeight)
		withMounted(HOST_WIDTH, HOST_HEIGHT, element, function(mounted)
			local scroller = waitForScroller(mounted.host)
			local content = waitForGuiObject(scroller, "ScrollerContent")
			local overflows = childHeight > HOST_HEIGHT
			waitForLayout(function()
				return if (scroller.AbsoluteCanvasSize.Y > scroller.AbsoluteWindowSize.Y) == overflows then true else nil
			end, `Expected the {childHeight}px child {if overflows then "to" else "not to"} overflow`)
			local expected = scroller.AbsoluteSize.X - (if reserves then DEFAULT_GUTTER else 0)
			waitForWidth(content, expected, 0.5)
			settleFrames(3)
			assertSizeApprox(content, expected, nil, 0.5, "content width")
		end)
	end
	function ScrollerMountValidation:gutterCountedOnce()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(400), function(mounted)
			local scroller = waitForGuiObject(mounted.host, "Scroller", function(gui)
				return gui.AbsoluteCanvasSize.Y > gui.AbsoluteWindowSize.Y and gui.AbsoluteWindowSize.Y > 0
			end, "Timed out waiting for the Scroller to overflow")
			local content = waitForGuiObject(scroller, "ScrollerContent")
			waitForWidth(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, 0.5)
			settleFrames(3)
			Assert:equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None)
			Assert:equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X)
			assertSizeApprox(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, nil, 0.5, "single gutter")
		end)
	end
	function ScrollerMountValidation:stableGutterNarrows()
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			local content = waitForGuiObject(scroller, "ScrollerContent")
			Assert:equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.None)
			Assert["true"](Assert, scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y, `Expected 50px of content not to overflow (canvas {scroller.AbsoluteCanvasSize.Y}, window {scroller.AbsoluteWindowSize.Y})`)
			waitForWidth(content, scroller.AbsoluteSize.X - DEFAULT_GUTTER, 0.5)
			assertSizeApprox(content, HOST_WIDTH - DEFAULT_GUTTER, nil, 0.5, "stable gutter width")
		end)
	end
	function ScrollerMountValidation:stableGutterSteady()
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			local content = waitForGuiObject(scroller, "ScrollerContent")
			local shortWidth = content.AbsoluteSize.X
			mounted.update(stableScroller(400))
			waitForLayout(function()
				return if scroller.AbsoluteCanvasSize.Y >= 400 then true else nil
			end, "Timed out waiting for the canvas to grow to 400px")
			waitForLayout(function()
				return if scroller.AbsoluteWindowSize.X > 0 then true else nil
			end, "Expected a laid-out window")
			assertSizeApprox(content, shortWidth, nil, 0.5, "overflowing content width")
		end)
	end
	function ScrollerMountValidation:plainRef()
		local objectRef = React.createRef()
		local callbackInstance
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement("frame", {
			key = "Refs",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, React.createElement(Scroller, {
			name = "ObjectRef",
			ref = objectRef,
		}), React.createElement(Scroller, {
			name = "CallbackRef",
			ref = function(instance)
				callbackInstance = instance
				return callbackInstance
			end,
		})), function(mounted)
			local objectTarget = waitForGuiObject(mounted.host, "ObjectRef")
			local callbackTarget = waitForGuiObject(mounted.host, "CallbackRef")
			Assert["true"](Assert, objectTarget:IsA("ScrollingFrame"))
			Assert:equal(objectRef.current, objectTarget)
			Assert:equal(callbackInstance, callbackTarget)
		end)
	end
	function ScrollerMountValidation:noConstraintWhenUnset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), function(mounted)
			Assert:equal(#sizeConstraintsOf(waitForScroller(mounted.host)), 0)
		end)
	end
	function ScrollerMountValidation:wrapperClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, React.createElement(Scroller, {
			maxWidth = 180,
		}, React.createElement("frame", {
			key = "Content",
			Size = UDim2.new(1, 0, 0, 50),
			BackgroundTransparency = 1,
		})), function(mounted)
			local wrapper = waitForGuiObject(mounted.host, "Scroller")
			Assert["true"](Assert, wrapper:IsA("Frame"), `Expected a maxWidth Scroller root to be a wrapper Frame, got {wrapper.ClassName}`)
			local scroller = waitForGuiObject(wrapper, "ScrollingFrame")
			Assert:equal(scroller.Parent, wrapper)
			Assert:equal(soleSizeConstraint(wrapper).MaxSize.X, 180)
			Assert:equal(#sizeConstraintsOf(scroller), 0)
			Assert:equal(#sizeConstraintsOf(waitForGuiObject(scroller, "ScrollerContent")), 0)
			waitForWidth(wrapper, 180)
			waitForWidth(scroller, 180)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With no size props the Scroller fills its host and auto-sizes its canvas vertically")
	local _descriptor = Test(ScrollerMountValidation, "fillsHostByDefault", {
		value = ScrollerMountValidation.fillsHostByDefault,
	})
	if _descriptor then
		ScrollerMountValidation.fillsHostByDefault = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ScrollerMountValidation, "fillsHostByDefault", {
		value = ScrollerMountValidation.fillsHostByDefault,
	})
	if _descriptor_1 then
		ScrollerMountValidation.fillsHostByDefault = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ScrollerMountValidation, "fillsHostByDefault", {
		value = ScrollerMountValidation.fillsHostByDefault,
	})
	if _descriptor_2 then
		ScrollerMountValidation.fillsHostByDefault = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Content shorter than the window stays inside the frame, does not overflow the canvas and keeps the full width")
	local _descriptor_3 = Test(ScrollerMountValidation, "shortContentContained", {
		value = ScrollerMountValidation.shortContentContained,
	})
	if _descriptor_3 then
		ScrollerMountValidation.shortContentContained = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ScrollerMountValidation, "shortContentContained", {
		value = ScrollerMountValidation.shortContentContained,
	})
	if _descriptor_4 then
		ScrollerMountValidation.shortContentContained = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ScrollerMountValidation, "shortContentContained", {
		value = ScrollerMountValidation.shortContentContained,
	})
	if _descriptor_5 then
		ScrollerMountValidation.shortContentContained = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Content taller than the window grows the canvas past the window and reserves width for the scrollbar")
	local _descriptor_6 = Test(ScrollerMountValidation, "canvasGrowsWithContent", {
		value = ScrollerMountValidation.canvasGrowsWithContent,
	})
	if _descriptor_6 then
		ScrollerMountValidation.canvasGrowsWithContent = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ScrollerMountValidation, "canvasGrowsWithContent", {
		value = ScrollerMountValidation.canvasGrowsWithContent,
	})
	if _descriptor_7 then
		ScrollerMountValidation.canvasGrowsWithContent = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ScrollerMountValidation, "canvasGrowsWithContent", {
		value = ScrollerMountValidation.canvasGrowsWithContent,
	})
	if _descriptor_8 then
		ScrollerMountValidation.canvasGrowsWithContent = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { false }, { true } })
	local _decorator_8 = DisplayName("The native inset is always None, so the canvas is as wide as the ScrollingFrame")
	local _descriptor_9 = Test(ScrollerMountValidation, "insetNone", {
		value = ScrollerMountValidation.insetNone,
	})
	if _descriptor_9 then
		ScrollerMountValidation.insetNone = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_8(ScrollerMountValidation, "insetNone", {
		value = ScrollerMountValidation.insetNone,
	})
	if _descriptor_10 then
		ScrollerMountValidation.insetNone = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_7(ScrollerMountValidation, "insetNone", {
		value = ScrollerMountValidation.insetNone,
	})
	if _descriptor_11 then
		ScrollerMountValidation.insetNone = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(ScrollerMountValidation, "insetNone", {
		value = ScrollerMountValidation.insetNone,
	})
	if _descriptor_12 then
		ScrollerMountValidation.insetNone = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = Each({ { false, 50, false }, { false, 400, true }, { true, 50, true }, { true, 400, true } })
	local _decorator_11 = DisplayName("Content reserves the default gutter with stableGutter or while overflowing, and is full width otherwise")
	local _descriptor_13 = Test(ScrollerMountValidation, "contentWidth", {
		value = ScrollerMountValidation.contentWidth,
	})
	if _descriptor_13 then
		ScrollerMountValidation.contentWidth = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_11(ScrollerMountValidation, "contentWidth", {
		value = ScrollerMountValidation.contentWidth,
	})
	if _descriptor_14 then
		ScrollerMountValidation.contentWidth = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_10(ScrollerMountValidation, "contentWidth", {
		value = ScrollerMountValidation.contentWidth,
	})
	if _descriptor_15 then
		ScrollerMountValidation.contentWidth = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_9(ScrollerMountValidation, "contentWidth", {
		value = ScrollerMountValidation.contentWidth,
	})
	if _descriptor_16 then
		ScrollerMountValidation.contentWidth = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("While overflowing, the gap is taken once from the full canvas width rather than twice")
	local _descriptor_17 = Test(ScrollerMountValidation, "gutterCountedOnce", {
		value = ScrollerMountValidation.gutterCountedOnce,
	})
	if _descriptor_17 then
		ScrollerMountValidation.gutterCountedOnce = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(ScrollerMountValidation, "gutterCountedOnce", {
		value = ScrollerMountValidation.gutterCountedOnce,
	})
	if _descriptor_18 then
		ScrollerMountValidation.gutterCountedOnce = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(ScrollerMountValidation, "gutterCountedOnce", {
		value = ScrollerMountValidation.gutterCountedOnce,
	})
	if _descriptor_19 then
		ScrollerMountValidation.gutterCountedOnce = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("stableGutter narrows short content by exactly one gutter even though the bar is hidden")
	local _descriptor_20 = Test(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_20 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_21 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_22 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("With stableGutter the content width does not change when the content starts to overflow")
	local _descriptor_23 = Test(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_23 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_17(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_24 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_16(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_25 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_25.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("An object ref and a callback ref both receive the root ScrollingFrame of the plain tree")
	local _descriptor_26 = Test(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_26 then
		ScrollerMountValidation.plainRef = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_19(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_27 then
		ScrollerMountValidation.plainRef = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_18(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_28 then
		ScrollerMountValidation.plainRef = _descriptor_28.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_21 = DisplayName("Without min or max props the plain ScrollingFrame has no UISizeConstraint")
	local _descriptor_29 = Test(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_29 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_21(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_30 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_20(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_31 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_31.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("A maxWidth wraps the ScrollingFrame in a Frame that holds the only SizeConstraint and caps the inner window")
	local _descriptor_32 = Test(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_32 then
		ScrollerMountValidation.wrapperClamped = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_23(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_33 then
		ScrollerMountValidation.wrapperClamped = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_22(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_34 then
		ScrollerMountValidation.wrapperClamped = _descriptor_34.value
	end
	ScrollerMountValidation = Tag("Studio")(ScrollerMountValidation) or ScrollerMountValidation
end
return ScrollerMountValidation
