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
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local settleFrames = _layout.settleFrames
local sizeConstraintsOf = _layout.sizeConstraintsOf
local soleSizeConstraint = _layout.soleSizeConstraint
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForWidth = _layout.waitForWidth
local withMounted = _layout.withMounted
local HOST_WIDTH = 300
local HOST_HEIGHT = 150
local TRACK_COLOR = Color3.fromRGB(255, 0, 0)
local BORDER_COLOR = Color3.fromRGB(0, 0, 255)
local function themed(scroller, childHeight, extra)
	return React.createElement(ThemeProvider, {
		theme = extendTheme(DefaultTheme, {
			components = {
				scroller = scroller,
			},
		}),
	}, extra or (React.createElement(Scroller, nil, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, childHeight),
		BackgroundTransparency = 1,
	}))))
end
local function waitForWrapper(host)
	local wrapper = waitForGuiObject(host, "Scroller")
	Assert["true"](Assert, wrapper:IsA("Frame"), `Expected the decorated Scroller root to be a Frame, got {wrapper.ClassName}`)
	return wrapper
end
local function waitForOverflow(wrapper)
	return waitForGuiObject(wrapper, "ScrollingFrame", function(gui)
		return gui.AbsoluteCanvasSize.Y > gui.AbsoluteWindowSize.Y and gui.AbsoluteWindowSize.Y > 0
	end, "Timed out waiting for the decorated ScrollingFrame to overflow")
end
local ScrollerThemeDecoration
do
	ScrollerThemeDecoration = setmetatable({}, {
		__tostring = function()
			return "ScrollerThemeDecoration"
		end,
	})
	ScrollerThemeDecoration.__index = ScrollerThemeDecoration
	function ScrollerThemeDecoration.new(...)
		local self = setmetatable({}, ScrollerThemeDecoration)
		return self:constructor(...) or self
	end
	function ScrollerThemeDecoration:constructor()
	end
	function ScrollerThemeDecoration:plainTreeUnchanged()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({}, 400), function(mounted)
			local scroller = waitForGuiObject(mounted.host, "Scroller")
			Assert["true"](Assert, scroller:IsA("ScrollingFrame"), `Expected a ScrollingFrame root, got {scroller.ClassName}`)
			Assert:equal(scroller.Parent, mounted.host)
			Assert:equal(scroller.ScrollBarImageTransparency, 0)
			Assert:undefined(mounted.host:FindFirstChild("ScrollerTrack", true))
			Assert:undefined(mounted.host:FindFirstChild("ScrollerThumb", true))
			Assert:undefined(mounted.host:FindFirstChild("ScrollingFrame", true))
		end)
	end
	function ScrollerThemeDecoration:inertKeysPlain()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			trackTransparency = 0.5,
			thumbBorderThickness = 0,
			thumbBorderColor = BORDER_COLOR,
		}, 400), function(mounted)
			local scroller = waitForGuiObject(mounted.host, "Scroller")
			Assert["true"](Assert, scroller:IsA("ScrollingFrame"), `Expected a ScrollingFrame root, got {scroller.ClassName}`)
			Assert:undefined(mounted.host:FindFirstChild("ScrollerTrack", true))
			Assert:undefined(mounted.host:FindFirstChild("ScrollerThumb", true))
		end)
	end
	function ScrollerThemeDecoration:trackWhileOverflowing()
		local theme = {
			trackColor = TRACK_COLOR,
			trackTransparency = 0.25,
		}
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed(theme, 50), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local track = waitForDescendant(wrapper, "ScrollerTrack", function()
				return true
			end)
			settleFrames(3)
			Assert["false"](Assert, track.Visible, "Expected the track to stay hidden while the content fits")
			Assert:equal(track.BackgroundColor3, TRACK_COLOR)
			Assert:equal(track.BackgroundTransparency, 0.25)
			Assert:undefined(wrapper:FindFirstChild("ScrollerThumb"))
			mounted.update(themed(theme, 400))
			waitForOverflow(wrapper)
			waitForDescendant(wrapper, "ScrollerTrack", function(gui)
				return gui.Visible
			end, "Timed out waiting for the track to show once the content overflows")
		end)
	end
	function ScrollerThemeDecoration:customThumb()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thumbBorderThickness = 2,
			thumbBorderColor = BORDER_COLOR,
		}, 400), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForOverflow(wrapper)
			local thumb = waitForDescendant(wrapper, "ScrollerThumb", function(gui)
				return gui.Visible
			end, "Timed out waiting for the custom thumb to show while overflowing")
			local border = thumb:FindFirstChild("ThumbBorder")
			Assert:equal(scroller.ScrollBarImageTransparency, 1)
			Assert:equal(thumb.Parent, wrapper)
			Assert:notUndefined(border, "Expected a ThumbBorder stroke on the thumb")
			Assert["true"](Assert, border:IsA("UIStroke"))
			Assert:equal(border.Thickness, 2)
			Assert:equal(border.Color, BORDER_COLOR)
			Assert:undefined(wrapper:FindFirstChild("ScrollerTrack"))
		end)
	end
	function ScrollerThemeDecoration:thumbHiddenShort()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thumbBorderThickness = 2,
		}, 50), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local thumb = waitForDescendant(wrapper, "ScrollerThumb", function()
				return true
			end)
			settleFrames(3)
			Assert["false"](Assert, thumb.Visible, "Expected no visible custom thumb for short content")
		end)
	end
	function ScrollerThemeDecoration:decoratedRef()
		local ref = React.createRef()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			trackColor = TRACK_COLOR,
		}, 0, React.createElement(Scroller, {
			ref = ref,
		})), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForGuiObject(wrapper, "ScrollingFrame")
			Assert:equal(ref.current, scroller)
			Assert["true"](Assert, ref.current:IsA("ScrollingFrame"))
		end)
	end
	function ScrollerThemeDecoration:decoratedConstraint()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			trackColor = TRACK_COLOR,
		}, 0, React.createElement(Scroller, {
			maxWidth = 180,
		})), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForGuiObject(wrapper, "ScrollingFrame")
			Assert:equal(soleSizeConstraint(wrapper).MaxSize.X, 180)
			Assert:equal(#sizeConstraintsOf(scroller), 0)
			waitForWidth(wrapper, 180)
			waitForWidth(scroller, 180)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With no optional theme keys the root stays the plain ScrollingFrame with the native bar and no overlays")
	local _descriptor = Test(ScrollerThemeDecoration, "plainTreeUnchanged", {
		value = ScrollerThemeDecoration.plainTreeUnchanged,
	})
	if _descriptor then
		ScrollerThemeDecoration.plainTreeUnchanged = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ScrollerThemeDecoration, "plainTreeUnchanged", {
		value = ScrollerThemeDecoration.plainTreeUnchanged,
	})
	if _descriptor_1 then
		ScrollerThemeDecoration.plainTreeUnchanged = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ScrollerThemeDecoration, "plainTreeUnchanged", {
		value = ScrollerThemeDecoration.plainTreeUnchanged,
	})
	if _descriptor_2 then
		ScrollerThemeDecoration.plainTreeUnchanged = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("trackTransparency alone or a zero thumbBorderThickness keeps the plain tree")
	local _descriptor_3 = Test(ScrollerThemeDecoration, "inertKeysPlain", {
		value = ScrollerThemeDecoration.inertKeysPlain,
	})
	if _descriptor_3 then
		ScrollerThemeDecoration.inertKeysPlain = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ScrollerThemeDecoration, "inertKeysPlain", {
		value = ScrollerThemeDecoration.inertKeysPlain,
	})
	if _descriptor_4 then
		ScrollerThemeDecoration.inertKeysPlain = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ScrollerThemeDecoration, "inertKeysPlain", {
		value = ScrollerThemeDecoration.inertKeysPlain,
	})
	if _descriptor_5 then
		ScrollerThemeDecoration.inertKeysPlain = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("A trackColor draws a themed ScrollerTrack that is hidden for short content and shown once it overflows")
	local _descriptor_6 = Test(ScrollerThemeDecoration, "trackWhileOverflowing", {
		value = ScrollerThemeDecoration.trackWhileOverflowing,
	})
	if _descriptor_6 then
		ScrollerThemeDecoration.trackWhileOverflowing = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ScrollerThemeDecoration, "trackWhileOverflowing", {
		value = ScrollerThemeDecoration.trackWhileOverflowing,
	})
	if _descriptor_7 then
		ScrollerThemeDecoration.trackWhileOverflowing = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ScrollerThemeDecoration, "trackWhileOverflowing", {
		value = ScrollerThemeDecoration.trackWhileOverflowing,
	})
	if _descriptor_8 then
		ScrollerThemeDecoration.trackWhileOverflowing = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A positive thumbBorderThickness hides the native thumb and draws ScrollerThumb with a ThumbBorder stroke")
	local _descriptor_9 = Test(ScrollerThemeDecoration, "customThumb", {
		value = ScrollerThemeDecoration.customThumb,
	})
	if _descriptor_9 then
		ScrollerThemeDecoration.customThumb = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ScrollerThemeDecoration, "customThumb", {
		value = ScrollerThemeDecoration.customThumb,
	})
	if _descriptor_10 then
		ScrollerThemeDecoration.customThumb = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ScrollerThemeDecoration, "customThumb", {
		value = ScrollerThemeDecoration.customThumb,
	})
	if _descriptor_11 then
		ScrollerThemeDecoration.customThumb = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("The custom thumb is hidden when the content does not overflow")
	local _descriptor_12 = Test(ScrollerThemeDecoration, "thumbHiddenShort", {
		value = ScrollerThemeDecoration.thumbHiddenShort,
	})
	if _descriptor_12 then
		ScrollerThemeDecoration.thumbHiddenShort = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ScrollerThemeDecoration, "thumbHiddenShort", {
		value = ScrollerThemeDecoration.thumbHiddenShort,
	})
	if _descriptor_13 then
		ScrollerThemeDecoration.thumbHiddenShort = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ScrollerThemeDecoration, "thumbHiddenShort", {
		value = ScrollerThemeDecoration.thumbHiddenShort,
	})
	if _descriptor_14 then
		ScrollerThemeDecoration.thumbHiddenShort = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("In the decorated tree the forwarded ref receives the inner ScrollingFrame, not the wrapper")
	local _descriptor_15 = Test(ScrollerThemeDecoration, "decoratedRef", {
		value = ScrollerThemeDecoration.decoratedRef,
	})
	if _descriptor_15 then
		ScrollerThemeDecoration.decoratedRef = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ScrollerThemeDecoration, "decoratedRef", {
		value = ScrollerThemeDecoration.decoratedRef,
	})
	if _descriptor_16 then
		ScrollerThemeDecoration.decoratedRef = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ScrollerThemeDecoration, "decoratedRef", {
		value = ScrollerThemeDecoration.decoratedRef,
	})
	if _descriptor_17 then
		ScrollerThemeDecoration.decoratedRef = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("In the decorated tree the SizeConstraint moves to the wrapper and the window follows its clamp")
	local _descriptor_18 = Test(ScrollerThemeDecoration, "decoratedConstraint", {
		value = ScrollerThemeDecoration.decoratedConstraint,
	})
	if _descriptor_18 then
		ScrollerThemeDecoration.decoratedConstraint = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(ScrollerThemeDecoration, "decoratedConstraint", {
		value = ScrollerThemeDecoration.decoratedConstraint,
	})
	if _descriptor_19 then
		ScrollerThemeDecoration.decoratedConstraint = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(ScrollerThemeDecoration, "decoratedConstraint", {
		value = ScrollerThemeDecoration.decoratedConstraint,
	})
	if _descriptor_20 then
		ScrollerThemeDecoration.decoratedConstraint = _descriptor_20.value
	end
	ScrollerThemeDecoration = Tag("Studio")(ScrollerThemeDecoration) or ScrollerThemeDecoration
end
return ScrollerThemeDecoration
