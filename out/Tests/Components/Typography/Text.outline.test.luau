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
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local SPACED_TEXT = "Hey"
local THEME_COLOR = Color3.new(0.25, 0.5, 0.75)
local PROP_COLOR = Color3.new(0.75, 0.25, 0.5)
local BLACK = Color3.new(0, 0, 0)
local function themed(outline, element)
	local theme = extendTheme(DefaultTheme, {
		typography = {
			body = {
				outline = outline,
			},
		},
	})
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, element)
end
local function strokesOf(instance)
	local found = {}
	for _, child in instance:GetChildren() do
		if child:IsA("UIStroke") then
			table.insert(found, child)
		end
	end
	return found
end
local function soleOutline(instance)
	local found = strokesOf(instance)
	Assert:equal(#found, 1, `Expected exactly one UIStroke directly on {instance:GetFullName()}`)
	Assert:equal(found[1].Name, "Outline", `Expected the UIStroke on {instance.Name} to be named Outline`)
	Assert:equal(found[1].ApplyStrokeMode, Enum.ApplyStrokeMode.Contextual, "Expected a Contextual stroke so it outlines the glyphs")
	return found[1]
end
local function assertOutline(stroke, color, thickness, transparency)
	Assert["true"](Assert, stroke.Color == color, `Expected outline colour {color}, got {stroke.Color}`)
	Assert:equal(stroke.Thickness, thickness, "Unexpected outline thickness")
	Assert:equal(stroke.Transparency, transparency, "Unexpected outline transparency")
end
local function characterLabels(frame)
	local found = {}
	for _, child in frame:GetChildren() do
		if child:IsA("TextLabel") then
			table.insert(found, child)
		end
	end
	return found
end
local function waitForLabel(host)
	return waitForGuiObject(host, "Text")
end
local TextOutline
do
	TextOutline = setmetatable({}, {
		__tostring = function()
			return "TextOutline"
		end,
	})
	TextOutline.__index = TextOutline
	function TextOutline.new(...)
		local self = setmetatable({}, TextOutline)
		return self:constructor(...) or self
	end
	function TextOutline:constructor()
	end
	function TextOutline:plainHasNoChildren()
		withMounted(400, 200, React.createElement(Text, {
			text = "Hello",
		}), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			Assert:equal(#label:GetChildren(), 0, "Expected no UIStroke, UIScale or constraints on a plain label")
		end)
	end
	function TextOutline:spacedHasNoDecorations()
		withMounted(400, 200, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
		}), function(mounted)
			local frame = waitForGuiObject(mounted.host, "Text")
			settleFrames(2)
			local labels = characterLabels(frame)
			Assert:equal(#frame:GetChildren(), #SPACED_TEXT + 1, "Expected one UIListLayout plus one label per character")
			Assert:equal(#labels, #SPACED_TEXT, "Expected one TextLabel per character")
			for _, label in labels do
				Assert:equal(#label:GetChildren(), 0, `Expected character label {label.Name} to have no children`)
			end
		end)
	end
	function TextOutline:trueUsesDefaults()
		withMounted(400, 200, React.createElement(Text, {
			text = "Hello",
			outline = true,
		}), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), BLACK, 1, 0)
		end)
	end
	function TextOutline:objectSetsFields()
		withMounted(400, 200, React.createElement(Text, {
			text = "Hello",
			outline = {
				color = PROP_COLOR,
				thickness = 3,
				transparency = 0.5,
			},
		}), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), PROP_COLOR, 3, 0.5)
		end)
	end
	function TextOutline:partialObjectDefaults()
		withMounted(400, 200, React.createElement(Text, {
			text = "Hello",
			outline = {
				thickness = 2,
			},
		}), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), BLACK, 2, 0)
		end)
	end
	function TextOutline:themeOutlineApplies()
		withMounted(400, 200, themed({
			color = THEME_COLOR,
			thickness = 2,
			transparency = 0.25,
		}, React.createElement(Text, {
			text = "Hello",
		})), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 2, 0.25)
		end)
	end
	function TextOutline:trueUsesTheme()
		withMounted(400, 200, themed({
			color = THEME_COLOR,
			thickness = 2,
			transparency = 0.25,
		}, React.createElement(Text, {
			text = "Hello",
			outline = true,
		})), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 2, 0.25)
		end)
	end
	function TextOutline:objectMergesTheme()
		withMounted(400, 200, themed({
			color = THEME_COLOR,
			thickness = 2,
			transparency = 0.25,
		}, React.createElement(Text, {
			text = "Hello",
			outline = {
				thickness = 4,
			},
		})), function(mounted)
			assertOutline(soleOutline(waitForLabel(mounted.host)), THEME_COLOR, 4, 0.25)
		end)
	end
	function TextOutline:falseBeatsTheme()
		withMounted(400, 200, themed({
			color = THEME_COLOR,
			thickness = 2,
		}, React.createElement(Text, {
			text = "Hello",
			outline = false,
		})), function(mounted)
			local label = waitForLabel(mounted.host)
			settleFrames(2)
			Assert:equal(#strokesOf(label), 0, "Expected outline={false} to suppress the theme outline")
		end)
	end
	function TextOutline:spacedStrokePerCharacter()
		withMounted(400, 200, React.createElement(Text, {
			text = SPACED_TEXT,
			letterSpacing = 2,
			outline = {
				color = PROP_COLOR,
				thickness = 2,
			},
		}), function(mounted)
			local frame = waitForGuiObject(mounted.host, "Text")
			local labels = characterLabels(frame)
			Assert:equal(#labels, #SPACED_TEXT, "Expected one TextLabel per character")
			Assert:equal(#strokesOf(frame), 0, "Expected no UIStroke on the letter-spaced frame itself")
			for _, label in labels do
				assertOutline(soleOutline(label), PROP_COLOR, 2, 0)
			end
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A plain label with none of the new props has no child instances at all")
	local _descriptor = Test(TextOutline, "plainHasNoChildren", {
		value = TextOutline.plainHasNoChildren,
	})
	if _descriptor then
		TextOutline.plainHasNoChildren = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextOutline, "plainHasNoChildren", {
		value = TextOutline.plainHasNoChildren,
	})
	if _descriptor_1 then
		TextOutline.plainHasNoChildren = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextOutline, "plainHasNoChildren", {
		value = TextOutline.plainHasNoChildren,
	})
	if _descriptor_2 then
		TextOutline.plainHasNoChildren = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("A letter-spaced text with none of the new props holds only its list layout and bare character labels")
	local _descriptor_3 = Test(TextOutline, "spacedHasNoDecorations", {
		value = TextOutline.spacedHasNoDecorations,
	})
	if _descriptor_3 then
		TextOutline.spacedHasNoDecorations = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextOutline, "spacedHasNoDecorations", {
		value = TextOutline.spacedHasNoDecorations,
	})
	if _descriptor_4 then
		TextOutline.spacedHasNoDecorations = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextOutline, "spacedHasNoDecorations", {
		value = TextOutline.spacedHasNoDecorations,
	})
	if _descriptor_5 then
		TextOutline.spacedHasNoDecorations = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("outline={true} with no theme outline draws a black 1px opaque stroke")
	local _descriptor_6 = Test(TextOutline, "trueUsesDefaults", {
		value = TextOutline.trueUsesDefaults,
	})
	if _descriptor_6 then
		TextOutline.trueUsesDefaults = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextOutline, "trueUsesDefaults", {
		value = TextOutline.trueUsesDefaults,
	})
	if _descriptor_7 then
		TextOutline.trueUsesDefaults = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextOutline, "trueUsesDefaults", {
		value = TextOutline.trueUsesDefaults,
	})
	if _descriptor_8 then
		TextOutline.trueUsesDefaults = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("An outline object sets the stroke colour, thickness and transparency")
	local _descriptor_9 = Test(TextOutline, "objectSetsFields", {
		value = TextOutline.objectSetsFields,
	})
	if _descriptor_9 then
		TextOutline.objectSetsFields = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextOutline, "objectSetsFields", {
		value = TextOutline.objectSetsFields,
	})
	if _descriptor_10 then
		TextOutline.objectSetsFields = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextOutline, "objectSetsFields", {
		value = TextOutline.objectSetsFields,
	})
	if _descriptor_11 then
		TextOutline.objectSetsFields = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A partial outline object falls back to the defaults for the fields it leaves out")
	local _descriptor_12 = Test(TextOutline, "partialObjectDefaults", {
		value = TextOutline.partialObjectDefaults,
	})
	if _descriptor_12 then
		TextOutline.partialObjectDefaults = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TextOutline, "partialObjectDefaults", {
		value = TextOutline.partialObjectDefaults,
	})
	if _descriptor_13 then
		TextOutline.partialObjectDefaults = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextOutline, "partialObjectDefaults", {
		value = TextOutline.partialObjectDefaults,
	})
	if _descriptor_14 then
		TextOutline.partialObjectDefaults = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("With outline unset, a theme typography.body.outline still draws the stroke")
	local _descriptor_15 = Test(TextOutline, "themeOutlineApplies", {
		value = TextOutline.themeOutlineApplies,
	})
	if _descriptor_15 then
		TextOutline.themeOutlineApplies = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(TextOutline, "themeOutlineApplies", {
		value = TextOutline.themeOutlineApplies,
	})
	if _descriptor_16 then
		TextOutline.themeOutlineApplies = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(TextOutline, "themeOutlineApplies", {
		value = TextOutline.themeOutlineApplies,
	})
	if _descriptor_17 then
		TextOutline.themeOutlineApplies = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("outline={true} under a theme outline uses the theme's fields")
	local _descriptor_18 = Test(TextOutline, "trueUsesTheme", {
		value = TextOutline.trueUsesTheme,
	})
	if _descriptor_18 then
		TextOutline.trueUsesTheme = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(TextOutline, "trueUsesTheme", {
		value = TextOutline.trueUsesTheme,
	})
	if _descriptor_19 then
		TextOutline.trueUsesTheme = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(TextOutline, "trueUsesTheme", {
		value = TextOutline.trueUsesTheme,
	})
	if _descriptor_20 then
		TextOutline.trueUsesTheme = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("An outline object overrides a theme outline field by field and keeps the theme's other fields")
	local _descriptor_21 = Test(TextOutline, "objectMergesTheme", {
		value = TextOutline.objectMergesTheme,
	})
	if _descriptor_21 then
		TextOutline.objectMergesTheme = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(TextOutline, "objectMergesTheme", {
		value = TextOutline.objectMergesTheme,
	})
	if _descriptor_22 then
		TextOutline.objectMergesTheme = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(TextOutline, "objectMergesTheme", {
		value = TextOutline.objectMergesTheme,
	})
	if _descriptor_23 then
		TextOutline.objectMergesTheme = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("outline={false} draws no stroke even when the theme style has one")
	local _descriptor_24 = Test(TextOutline, "falseBeatsTheme", {
		value = TextOutline.falseBeatsTheme,
	})
	if _descriptor_24 then
		TextOutline.falseBeatsTheme = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(TextOutline, "falseBeatsTheme", {
		value = TextOutline.falseBeatsTheme,
	})
	if _descriptor_25 then
		TextOutline.falseBeatsTheme = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(TextOutline, "falseBeatsTheme", {
		value = TextOutline.falseBeatsTheme,
	})
	if _descriptor_26 then
		TextOutline.falseBeatsTheme = _descriptor_26.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("Letter-spaced text draws one Outline stroke on every character label and none on the frame")
	local _descriptor_27 = Test(TextOutline, "spacedStrokePerCharacter", {
		value = TextOutline.spacedStrokePerCharacter,
	})
	if _descriptor_27 then
		TextOutline.spacedStrokePerCharacter = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(TextOutline, "spacedStrokePerCharacter", {
		value = TextOutline.spacedStrokePerCharacter,
	})
	if _descriptor_28 then
		TextOutline.spacedStrokePerCharacter = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(TextOutline, "spacedStrokePerCharacter", {
		value = TextOutline.spacedStrokePerCharacter,
	})
	if _descriptor_29 then
		TextOutline.spacedStrokePerCharacter = _descriptor_29.value
	end
	TextOutline = Tag("Studio")(TextOutline) or TextOutline
end
return TextOutline
