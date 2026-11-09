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
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers", "spacing.helper").SpacingHelper
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 150
local SCROLLBAR_THICKNESS = 12
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
local function gutterWidth(scroller)
	return scroller.AbsoluteWindowSize.X - SCROLLBAR_THICKNESS - SpacingHelper:GetPadding(DefaultTheme, nil)
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
	function ScrollerMountValidation:defaultInset()
		withMounted(HOST_WIDTH, HOST_HEIGHT, scrollerWithChild(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			Assert:equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.ScrollBar)
		end)
	end
	function ScrollerMountValidation:stableGutterNarrows()
		withMounted(HOST_WIDTH, HOST_HEIGHT, stableScroller(50), function(mounted)
			local scroller = waitForScroller(mounted.host)
			local content = waitForGuiObject(scroller, "ScrollerContent")
			Assert:equal(scroller.VerticalScrollBarInset, Enum.ScrollBarInset.Always)
			Assert["true"](Assert, scroller.AbsoluteCanvasSize.Y <= scroller.AbsoluteWindowSize.Y, `Expected 50px of content not to overflow (canvas {scroller.AbsoluteCanvasSize.Y}, window {scroller.AbsoluteWindowSize.Y})`)
			waitForWidth(content, gutterWidth(scroller))
			Assert["true"](Assert, content.AbsoluteSize.X < HOST_WIDTH - SCROLLBAR_THICKNESS, `Expected the content ({content.AbsoluteSize.X}) to leave the gutter free`)
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
	local _decorator_7 = DisplayName("Without stableGutter the scrollbar inset only applies while the bar is shown")
	local _descriptor_9 = Test(ScrollerMountValidation, "defaultInset", {
		value = ScrollerMountValidation.defaultInset,
	})
	if _descriptor_9 then
		ScrollerMountValidation.defaultInset = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ScrollerMountValidation, "defaultInset", {
		value = ScrollerMountValidation.defaultInset,
	})
	if _descriptor_10 then
		ScrollerMountValidation.defaultInset = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ScrollerMountValidation, "defaultInset", {
		value = ScrollerMountValidation.defaultInset,
	})
	if _descriptor_11 then
		ScrollerMountValidation.defaultInset = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("stableGutter always insets the bar and narrows short content as if it overflowed")
	local _descriptor_12 = Test(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_12 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_13 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ScrollerMountValidation, "stableGutterNarrows", {
		value = ScrollerMountValidation.stableGutterNarrows,
	})
	if _descriptor_14 then
		ScrollerMountValidation.stableGutterNarrows = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("With stableGutter the content width does not change when the content starts to overflow")
	local _descriptor_15 = Test(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_15 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_16 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ScrollerMountValidation, "stableGutterSteady", {
		value = ScrollerMountValidation.stableGutterSteady,
	})
	if _descriptor_17 then
		ScrollerMountValidation.stableGutterSteady = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("An object ref and a callback ref both receive the root ScrollingFrame of the plain tree")
	local _descriptor_18 = Test(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_18 then
		ScrollerMountValidation.plainRef = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_19 then
		ScrollerMountValidation.plainRef = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(ScrollerMountValidation, "plainRef", {
		value = ScrollerMountValidation.plainRef,
	})
	if _descriptor_20 then
		ScrollerMountValidation.plainRef = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Without min or max props the plain ScrollingFrame has no UISizeConstraint")
	local _descriptor_21 = Test(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_21 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_22 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(ScrollerMountValidation, "noConstraintWhenUnset", {
		value = ScrollerMountValidation.noConstraintWhenUnset,
	})
	if _descriptor_23 then
		ScrollerMountValidation.noConstraintWhenUnset = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("A maxWidth wraps the ScrollingFrame in a Frame that holds the only SizeConstraint and caps the inner window")
	local _descriptor_24 = Test(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_24 then
		ScrollerMountValidation.wrapperClamped = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_25 then
		ScrollerMountValidation.wrapperClamped = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(ScrollerMountValidation, "wrapperClamped", {
		value = ScrollerMountValidation.wrapperClamped,
	})
	if _descriptor_26 then
		ScrollerMountValidation.wrapperClamped = _descriptor_26.value
	end
	ScrollerMountValidation = Tag("Studio")(ScrollerMountValidation) or ScrollerMountValidation
end
return ScrollerMountValidation
