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
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertTextFits = _layout.assertTextFits
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local SHORT_TEXT = "Hello"
local LONG_TEXT = "The quick brown fox jumps over the lazy dog again and again until it wraps."
local NARROW_WIDTH = 120
local function narrowText(text, wrap)
	return React.createElement(Text, {
		text = text,
		TextWrap = wrap,
	}, React.createElement("uisizeconstraint", {
		key = "MaxWidth",
		MaxSize = Vector2.new(NARROW_WIDTH, math.huge),
	}))
end
local function waitForText(host)
	return waitForGuiObject(host, "Text")
end
local TextMountValidation
do
	TextMountValidation = setmetatable({}, {
		__tostring = function()
			return "TextMountValidation"
		end,
	})
	TextMountValidation.__index = TextMountValidation
	function TextMountValidation.new(...)
		local self = setmetatable({}, TextMountValidation)
		return self:constructor(...) or self
	end
	function TextMountValidation:constructor()
	end
	function TextMountValidation:rendersText()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
		}), function(mounted)
			local label = waitForText(mounted.host)
			Assert:equal(label.Text, SHORT_TEXT, "Expected the text prop to be rendered verbatim")
			assertNonZeroSize(label, "short text")
			assertTextFits(label, "short text")
			assertContained(label, mounted.host, "short text")
		end)
	end
	function TextMountValidation:wrapsAtNarrowWidth()
		withMounted(400, 300, narrowText(LONG_TEXT, true), function(mounted)
			local label = waitForGuiObject(mounted.host, "Text", function(gui)
				return gui.AbsoluteSize.X > 0 and gui.TextBounds.Y > gui.TextSize * 1.5
			end, "Timed out waiting for the bounded Text to wrap onto more than one line")
			Assert["true"](Assert, label.TextWrapped, "Expected TextWrapped to be on by default")
			Assert["true"](Assert, rect(label).width <= NARROW_WIDTH + 1, `Expected the wrapped label width {rect(label).width} to stay within {NARROW_WIDTH}px`)
			assertTextFits(label, "wrapped text")
		end)
	end
	function TextMountValidation:noWrapStaysSingleLine()
		withMounted(400, 300, narrowText(LONG_TEXT, false), function(mounted)
			local label = waitForText(mounted.host)
			Assert["false"](Assert, label.TextWrapped, "Expected TextWrap={false} to turn TextWrapped off on the instance")
			Assert["true"](Assert, label.TextBounds.Y <= label.TextSize * 1.5, `Expected a single line of text, got TextBounds.Y={label.TextBounds.Y} for TextSize={label.TextSize}`)
		end)
	end
	function TextMountValidation:growsWithContent()
		withMounted(600, 300, React.createElement(Text, {
			text = SHORT_TEXT,
		}), function(mounted)
			local label = waitForText(mounted.host)
			local shortWidth = rect(label).width
			mounted.update(React.createElement(Text, {
				text = LONG_TEXT,
			}))
			local longWidth = waitForLayout(function()
				return if label.AbsoluteSize.X > shortWidth then label.AbsoluteSize.X else nil
			end, `Timed out waiting for the label to grow past its short-text width of {shortWidth}`)
			Assert:equal(label.Text, LONG_TEXT, "Expected the label to show the updated text")
			Assert["true"](Assert, longWidth > shortWidth, `Expected long text width {longWidth} to exceed short text width {shortWidth}`)
		end)
	end
	function TextMountValidation:themeFontFamily()
		local theme = extendTheme(DefaultTheme, {
			typography = {
				body = {
					font = Enum.Font.Fantasy,
				},
			},
		})
		withMounted(400, 300, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Text, {
			text = SHORT_TEXT,
		})), function(mounted)
			local label = waitForText(mounted.host)
			local suffix = "Balthazar.json"
			local _family = label.FontFace.Family
			local _arg0 = -#suffix
			Assert:equal(string.sub(_family, _arg0), suffix, `Expected FontFace.Family to end with {suffix}, got {label.FontFace.Family}`)
		end)
	end
	function TextMountValidation:spacedRefIsFrame()
		local ref = React.createRef()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
			letterSpacing = 2,
			ref = ref,
		}), function(mounted)
			local root = waitForGuiObject(mounted.host, "Text")
			local current = ref.current
			Assert:notUndefined(current, "Expected the forwarded ref to be assigned for letter-spaced text")
			Assert["true"](Assert, current:IsA("Frame"), `Expected the ref to hold a Frame, got {current.ClassName}`)
			Assert["true"](Assert, current == root, "Expected the ref to hold the mounted root instance")
		end)
	end
	function TextMountValidation:plainRefIsLabel()
		local ref = React.createRef()
		withMounted(400, 300, React.createElement(Text, {
			text = SHORT_TEXT,
			ref = ref,
		}), function(mounted)
			local label = waitForText(mounted.host)
			local current = ref.current
			Assert:notUndefined(current, "Expected the forwarded ref to be assigned for plain text")
			Assert["true"](Assert, current:IsA("TextLabel"), `Expected the ref to hold a TextLabel, got {current.ClassName}`)
			Assert["true"](Assert, current == label, "Expected the ref to hold the mounted label")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Renders the text prop verbatim in an auto-sized TextLabel that fits its content")
	local _descriptor = Test(TextMountValidation, "rendersText", {
		value = TextMountValidation.rendersText,
	})
	if _descriptor then
		TextMountValidation.rendersText = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextMountValidation, "rendersText", {
		value = TextMountValidation.rendersText,
	})
	if _descriptor_1 then
		TextMountValidation.rendersText = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextMountValidation, "rendersText", {
		value = TextMountValidation.rendersText,
	})
	if _descriptor_2 then
		TextMountValidation.rendersText = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Long text bounded to 120px wraps onto multiple lines and still fits its label")
	local _descriptor_3 = Test(TextMountValidation, "wrapsAtNarrowWidth", {
		value = TextMountValidation.wrapsAtNarrowWidth,
	})
	if _descriptor_3 then
		TextMountValidation.wrapsAtNarrowWidth = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextMountValidation, "wrapsAtNarrowWidth", {
		value = TextMountValidation.wrapsAtNarrowWidth,
	})
	if _descriptor_4 then
		TextMountValidation.wrapsAtNarrowWidth = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextMountValidation, "wrapsAtNarrowWidth", {
		value = TextMountValidation.wrapsAtNarrowWidth,
	})
	if _descriptor_5 then
		TextMountValidation.wrapsAtNarrowWidth = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("TextWrap={false} keeps long text on a single line instead of wrapping")
	local _descriptor_6 = Test(TextMountValidation, "noWrapStaysSingleLine", {
		value = TextMountValidation.noWrapStaysSingleLine,
	})
	if _descriptor_6 then
		TextMountValidation.noWrapStaysSingleLine = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextMountValidation, "noWrapStaysSingleLine", {
		value = TextMountValidation.noWrapStaysSingleLine,
	})
	if _descriptor_7 then
		TextMountValidation.noWrapStaysSingleLine = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextMountValidation, "noWrapStaysSingleLine", {
		value = TextMountValidation.noWrapStaysSingleLine,
	})
	if _descriptor_8 then
		TextMountValidation.noWrapStaysSingleLine = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Updating to a longer text prop grows the auto-sized label's width")
	local _descriptor_9 = Test(TextMountValidation, "growsWithContent", {
		value = TextMountValidation.growsWithContent,
	})
	if _descriptor_9 then
		TextMountValidation.growsWithContent = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextMountValidation, "growsWithContent", {
		value = TextMountValidation.growsWithContent,
	})
	if _descriptor_10 then
		TextMountValidation.growsWithContent = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextMountValidation, "growsWithContent", {
		value = TextMountValidation.growsWithContent,
	})
	if _descriptor_11 then
		TextMountValidation.growsWithContent = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A theme body font of Enum.Font.Fantasy renders with the Balthazar family, not a missing Fantasy family")
	local _descriptor_12 = Test(TextMountValidation, "themeFontFamily", {
		value = TextMountValidation.themeFontFamily,
	})
	if _descriptor_12 then
		TextMountValidation.themeFontFamily = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TextMountValidation, "themeFontFamily", {
		value = TextMountValidation.themeFontFamily,
	})
	if _descriptor_13 then
		TextMountValidation.themeFontFamily = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextMountValidation, "themeFontFamily", {
		value = TextMountValidation.themeFontFamily,
	})
	if _descriptor_14 then
		TextMountValidation.themeFontFamily = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A forwarded ref on letter-spaced text receives the root Frame that holds the characters")
	local _descriptor_15 = Test(TextMountValidation, "spacedRefIsFrame", {
		value = TextMountValidation.spacedRefIsFrame,
	})
	if _descriptor_15 then
		TextMountValidation.spacedRefIsFrame = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(TextMountValidation, "spacedRefIsFrame", {
		value = TextMountValidation.spacedRefIsFrame,
	})
	if _descriptor_16 then
		TextMountValidation.spacedRefIsFrame = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(TextMountValidation, "spacedRefIsFrame", {
		value = TextMountValidation.spacedRefIsFrame,
	})
	if _descriptor_17 then
		TextMountValidation.spacedRefIsFrame = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A forwarded ref on plain text receives the rendered TextLabel")
	local _descriptor_18 = Test(TextMountValidation, "plainRefIsLabel", {
		value = TextMountValidation.plainRefIsLabel,
	})
	if _descriptor_18 then
		TextMountValidation.plainRefIsLabel = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(TextMountValidation, "plainRefIsLabel", {
		value = TextMountValidation.plainRefIsLabel,
	})
	if _descriptor_19 then
		TextMountValidation.plainRefIsLabel = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(TextMountValidation, "plainRefIsLabel", {
		value = TextMountValidation.plainRefIsLabel,
	})
	if _descriptor_20 then
		TextMountValidation.plainRefIsLabel = _descriptor_20.value
	end
	TextMountValidation = Tag("Studio")(TextMountValidation) or TextMountValidation
end
return TextMountValidation
