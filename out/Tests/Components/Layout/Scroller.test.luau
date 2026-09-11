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
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
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
	ScrollerMountValidation = Tag("Studio")(ScrollerMountValidation) or ScrollerMountValidation
end
return ScrollerMountValidation
