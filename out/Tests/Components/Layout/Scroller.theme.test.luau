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
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
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
local BAR_COLOR = Color3.fromRGB(0, 255, 0)
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
local function stableChild(childHeight, spacing)
	return React.createElement(Scroller, {
		stableGutter = true,
		spacing = spacing,
	}, React.createElement("frame", {
		key = "Content",
		Size = UDim2.new(1, 0, 0, childHeight),
		BackgroundTransparency = 1,
	}))
end
local function waitForPlain(host)
	local scroller = waitForGuiObject(host, "Scroller")
	Assert["true"](Assert, scroller:IsA("ScrollingFrame"), `Expected a plain ScrollingFrame root, got {scroller.ClassName}`)
	return scroller
end
local function assertContentWidth(scroller, gutter)
	local content = waitForGuiObject(scroller, "ScrollerContent")
	local expected = scroller.AbsoluteSize.X - gutter
	waitForWidth(content, expected, 0.5)
	settleFrames(3)
	Assert:equal(scroller.AbsoluteCanvasSize.X, scroller.AbsoluteSize.X)
	assertSizeApprox(content, expected, nil, 0.5, `content width with a {gutter}px gutter`)
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
	function ScrollerThemeDecoration:themeThicknessGutter()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			barColor = BAR_COLOR,
			thickness = 8,
			gutter = 12,
		}, 0, stableChild(50)), function(mounted)
			local scroller = waitForPlain(mounted.host)
			Assert:equal(scroller.ScrollBarThickness, 8)
			Assert:equal(scroller.ScrollBarImageColor3, BAR_COLOR)
			assertContentWidth(scroller, 12)
		end)
	end
	function ScrollerThemeDecoration:gutterIgnoresSpacing(spacing)
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thickness = 8,
			gutter = 12,
		}, 0, stableChild(50, spacing)), function(mounted)
			assertContentWidth(waitForPlain(mounted.host), 12)
		end)
	end
	function ScrollerThemeDecoration:defaultFallback()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({}, 0, stableChild(50)), function(mounted)
			local scroller = waitForPlain(mounted.host)
			Assert:equal(scroller.ScrollBarThickness, 12)
			assertContentWidth(scroller, 12 + SpacingHelper:GetPadding(DefaultTheme, nil))
		end)
	end
	function ScrollerThemeDecoration:spacingDrivesGutter(spacing)
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thickness = 8,
		}, 0, stableChild(50, spacing)), function(mounted)
			assertContentWidth(waitForPlain(mounted.host), 8 + SpacingHelper:GetPadding(DefaultTheme, spacing))
		end)
	end
	function ScrollerThemeDecoration:negativeClamped()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thickness = -4,
			gutter = -6,
		}, 0, stableChild(50)), function(mounted)
			local scroller = waitForPlain(mounted.host)
			Assert:equal(scroller.ScrollBarThickness, 0)
			assertContentWidth(scroller, 0)
		end)
	end
	function ScrollerThemeDecoration:sizingKeysPlain()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			barColor = BAR_COLOR,
			thickness = 8,
			gutter = 12,
		}, 400), function(mounted)
			local scroller = waitForPlain(mounted.host)
			Assert:equal(scroller.Parent, mounted.host)
			Assert:undefined(mounted.host:FindFirstChild("ScrollerTrack", true))
			Assert:undefined(mounted.host:FindFirstChild("ScrollerThumb", true))
			Assert:undefined(mounted.host:FindFirstChild("ScrollingFrame", true))
		end)
	end
	function ScrollerThemeDecoration:trackThickness(source)
		local expected = if source == "theme" then 8 else 12
		local theme = if source == "theme" then {
			trackColor = TRACK_COLOR,
			thickness = 8,
		} else {
			trackColor = TRACK_COLOR,
		}
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed(theme, 400), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			local scroller = waitForOverflow(wrapper)
			local track = waitForDescendant(wrapper, "ScrollerTrack", function()
				return true
			end)
			Assert:equal(track.Size.X.Offset, expected)
			Assert:equal(track.Size.X.Scale, 0)
			Assert:equal(scroller.ScrollBarThickness, expected)
		end)
	end
	function ScrollerThemeDecoration:thumbThickness()
		withMounted(HOST_WIDTH, HOST_HEIGHT, themed({
			thumbBorderThickness = 2,
			thickness = 8,
		}, 400), function(mounted)
			local wrapper = waitForWrapper(mounted.host)
			waitForOverflow(wrapper)
			local thumb = waitForDescendant(wrapper, "ScrollerThumb", function(gui)
				return gui.Visible
			end, "Timed out waiting for the custom thumb to show while overflowing")
			Assert:equal(thumb.Size.X.Offset, 8)
			Assert:equal(thumb.Position.X.Scale, 1)
			Assert:equal(thumb.Position.X.Offset, -8)
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
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Theme thickness sizes the native bar and theme gutter sets the reserved gap on its own")
	local _descriptor_21 = Test(ScrollerThemeDecoration, "themeThicknessGutter", {
		value = ScrollerThemeDecoration.themeThicknessGutter,
	})
	if _descriptor_21 then
		ScrollerThemeDecoration.themeThicknessGutter = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(ScrollerThemeDecoration, "themeThicknessGutter", {
		value = ScrollerThemeDecoration.themeThicknessGutter,
	})
	if _descriptor_22 then
		ScrollerThemeDecoration.themeThicknessGutter = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(ScrollerThemeDecoration, "themeThicknessGutter", {
		value = ScrollerThemeDecoration.themeThicknessGutter,
	})
	if _descriptor_23 then
		ScrollerThemeDecoration.themeThicknessGutter = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = Each({ { "xl" }, { "None" } })
	local _decorator_18 = DisplayName("Once the theme sets a gutter, the spacing prop no longer changes the reserved gap")
	local _descriptor_24 = Test(ScrollerThemeDecoration, "gutterIgnoresSpacing", {
		value = ScrollerThemeDecoration.gutterIgnoresSpacing,
	})
	if _descriptor_24 then
		ScrollerThemeDecoration.gutterIgnoresSpacing = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_18(ScrollerThemeDecoration, "gutterIgnoresSpacing", {
		value = ScrollerThemeDecoration.gutterIgnoresSpacing,
	})
	if _descriptor_25 then
		ScrollerThemeDecoration.gutterIgnoresSpacing = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_17(ScrollerThemeDecoration, "gutterIgnoresSpacing", {
		value = ScrollerThemeDecoration.gutterIgnoresSpacing,
	})
	if _descriptor_26 then
		ScrollerThemeDecoration.gutterIgnoresSpacing = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_16(ScrollerThemeDecoration, "gutterIgnoresSpacing", {
		value = ScrollerThemeDecoration.gutterIgnoresSpacing,
	})
	if _descriptor_27 then
		ScrollerThemeDecoration.gutterIgnoresSpacing = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("Without thickness or gutter keys the bar is 12px and the gap is 12px plus the default spacing padding")
	local _descriptor_28 = Test(ScrollerThemeDecoration, "defaultFallback", {
		value = ScrollerThemeDecoration.defaultFallback,
	})
	if _descriptor_28 then
		ScrollerThemeDecoration.defaultFallback = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_20(ScrollerThemeDecoration, "defaultFallback", {
		value = ScrollerThemeDecoration.defaultFallback,
	})
	if _descriptor_29 then
		ScrollerThemeDecoration.defaultFallback = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_19(ScrollerThemeDecoration, "defaultFallback", {
		value = ScrollerThemeDecoration.defaultFallback,
	})
	if _descriptor_30 then
		ScrollerThemeDecoration.defaultFallback = _descriptor_30.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = Each({ { "xl" }, { "None" } })
	local _decorator_23 = DisplayName("Without a theme gutter the spacing prop widens or removes the padding part of the gap")
	local _descriptor_31 = Test(ScrollerThemeDecoration, "spacingDrivesGutter", {
		value = ScrollerThemeDecoration.spacingDrivesGutter,
	})
	if _descriptor_31 then
		ScrollerThemeDecoration.spacingDrivesGutter = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_23(ScrollerThemeDecoration, "spacingDrivesGutter", {
		value = ScrollerThemeDecoration.spacingDrivesGutter,
	})
	if _descriptor_32 then
		ScrollerThemeDecoration.spacingDrivesGutter = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_22(ScrollerThemeDecoration, "spacingDrivesGutter", {
		value = ScrollerThemeDecoration.spacingDrivesGutter,
	})
	if _descriptor_33 then
		ScrollerThemeDecoration.spacingDrivesGutter = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_21(ScrollerThemeDecoration, "spacingDrivesGutter", {
		value = ScrollerThemeDecoration.spacingDrivesGutter,
	})
	if _descriptor_34 then
		ScrollerThemeDecoration.spacingDrivesGutter = _descriptor_34.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = DisplayName("Negative thickness and gutter are treated as zero, leaving no bar and full-width content")
	local _descriptor_35 = Test(ScrollerThemeDecoration, "negativeClamped", {
		value = ScrollerThemeDecoration.negativeClamped,
	})
	if _descriptor_35 then
		ScrollerThemeDecoration.negativeClamped = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_25(ScrollerThemeDecoration, "negativeClamped", {
		value = ScrollerThemeDecoration.negativeClamped,
	})
	if _descriptor_36 then
		ScrollerThemeDecoration.negativeClamped = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_24(ScrollerThemeDecoration, "negativeClamped", {
		value = ScrollerThemeDecoration.negativeClamped,
	})
	if _descriptor_37 then
		ScrollerThemeDecoration.negativeClamped = _descriptor_37.value
	end
	local _decorator_26 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_27 = DisplayName("barColor, thickness and gutter alone keep the plain ScrollingFrame tree with no track or thumb")
	local _descriptor_38 = Test(ScrollerThemeDecoration, "sizingKeysPlain", {
		value = ScrollerThemeDecoration.sizingKeysPlain,
	})
	if _descriptor_38 then
		ScrollerThemeDecoration.sizingKeysPlain = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_27(ScrollerThemeDecoration, "sizingKeysPlain", {
		value = ScrollerThemeDecoration.sizingKeysPlain,
	})
	if _descriptor_39 then
		ScrollerThemeDecoration.sizingKeysPlain = _descriptor_39.value
	end
	local _descriptor_40 = _decorator_26(ScrollerThemeDecoration, "sizingKeysPlain", {
		value = ScrollerThemeDecoration.sizingKeysPlain,
	})
	if _descriptor_40 then
		ScrollerThemeDecoration.sizingKeysPlain = _descriptor_40.value
	end
	local _decorator_28 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_29 = Each({ { "theme" }, { "default" } })
	local _decorator_30 = DisplayName("The decorated ScrollerTrack and native bar are as wide as the theme thickness, or 12px by default")
	local _descriptor_41 = Test(ScrollerThemeDecoration, "trackThickness", {
		value = ScrollerThemeDecoration.trackThickness,
	})
	if _descriptor_41 then
		ScrollerThemeDecoration.trackThickness = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_30(ScrollerThemeDecoration, "trackThickness", {
		value = ScrollerThemeDecoration.trackThickness,
	})
	if _descriptor_42 then
		ScrollerThemeDecoration.trackThickness = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_29(ScrollerThemeDecoration, "trackThickness", {
		value = ScrollerThemeDecoration.trackThickness,
	})
	if _descriptor_43 then
		ScrollerThemeDecoration.trackThickness = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_28(ScrollerThemeDecoration, "trackThickness", {
		value = ScrollerThemeDecoration.trackThickness,
	})
	if _descriptor_44 then
		ScrollerThemeDecoration.trackThickness = _descriptor_44.value
	end
	local _decorator_31 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_32 = DisplayName("The custom ScrollerThumb is as wide as the theme thickness and sits flush with the right edge")
	local _descriptor_45 = Test(ScrollerThemeDecoration, "thumbThickness", {
		value = ScrollerThemeDecoration.thumbThickness,
	})
	if _descriptor_45 then
		ScrollerThemeDecoration.thumbThickness = _descriptor_45.value
	end
	local _descriptor_46 = _decorator_32(ScrollerThemeDecoration, "thumbThickness", {
		value = ScrollerThemeDecoration.thumbThickness,
	})
	if _descriptor_46 then
		ScrollerThemeDecoration.thumbThickness = _descriptor_46.value
	end
	local _descriptor_47 = _decorator_31(ScrollerThemeDecoration, "thumbThickness", {
		value = ScrollerThemeDecoration.thumbThickness,
	})
	if _descriptor_47 then
		ScrollerThemeDecoration.thumbThickness = _descriptor_47.value
	end
	ScrollerThemeDecoration = Tag("Studio")(ScrollerThemeDecoration) or ScrollerThemeDecoration
end
return ScrollerThemeDecoration
