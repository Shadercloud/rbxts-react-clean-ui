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
local Badge = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Badge").Badge
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local WoodenTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").WoodenTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertTextFits = _layout.assertTextFits
local findDescendantOfClass = _layout.findDescendantOfClass
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function waitForBadge(host, name)
	if name == nil then
		name = "Badge"
	end
	return waitForGuiObject(host, name)
end
local function assertColor(actual, expectedHex, label)
	Assert:equal(string.lower(actual:ToHex()), string.lower(expectedHex), `{label}: expected #{expectedHex}, got #{actual:ToHex()}`)
end
local function assertIntentColors(badge, textHex, backgroundHex, borderHex, label)
	local text = waitForGuiObject(badge, "BadgeText")
	local stroke = findDescendantOfClass(badge, "UIStroke")
	assertColor(badge.BackgroundColor3, backgroundHex, `{label} background`)
	assertColor(stroke.Color, borderHex, `{label} border`)
	assertColor(text.TextColor3, textHex, `{label} text`)
	Assert:equal(badge.BackgroundTransparency, 0, `{label}: expected an opaque background`)
end
local BadgeMountValidation
do
	BadgeMountValidation = setmetatable({}, {
		__tostring = function()
			return "BadgeMountValidation"
		end,
	})
	BadgeMountValidation.__index = BadgeMountValidation
	function BadgeMountValidation.new(...)
		local self = setmetatable({}, BadgeMountValidation)
		return self:constructor(...) or self
	end
	function BadgeMountValidation:constructor()
	end
	function BadgeMountValidation:mountsWithText()
		withMounted(400, 200, React.createElement(Badge, {
			text = "New",
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			local label = waitForGuiObject(badge, "BadgeText")
			Assert:equal(label.Text, "New")
			Assert["false"](Assert, badge.Active, "Expected the Badge root to have Active=false")
			assertNonZeroSize(badge, "badge")
			assertTextFits(label, "badge")
			assertAllDescendantsContained(badge, "badge")
		end)
	end
	function BadgeMountValidation:defaultIntentColors(intent, textHex, backgroundHex, borderHex)
		withMounted(400, 200, React.createElement(Badge, {
			text = "3",
			intent = intent,
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			assertIntentColors(badge, textHex, backgroundHex, borderHex, `default {intent}`)
		end)
	end
	function BadgeMountValidation:woodenPrimary()
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = WoodenTheme,
		}, React.createElement(Badge, {
			text = "Wooden",
			intent = "primary",
		})), function(mounted)
			local badge = waitForBadge(mounted.host)
			assertIntentColors(badge, "FFF7CF", "7A4A20", "3D2712", "wooden primary")
			local stroke = findDescendantOfClass(badge, "UIStroke")
			Assert:equal(stroke.Thickness, 2, "Expected the Wooden badge border to be 2px")
			Assert:equal(badge.Image, "", "Expected a flat Wooden badge to have no background image")
		end)
	end
	function BadgeMountValidation:scaleSetsTextSize(scale, expectedSize)
		withMounted(400, 200, React.createElement(Badge, {
			text = "Scaled",
			scale = scale,
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			local label = waitForGuiObject(badge, "BadgeText")
			Assert:equal(label.TextSize, expectedSize, `Expected scale {scale} to give TextSize {expectedSize}, got {label.TextSize}`)
		end)
	end
	function BadgeMountValidation:largerScaleTaller()
		withMounted(400, 200, React.createElement("frame", {
			key = "Stack",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
		}, React.createElement(Badge, {
			name = "SmallBadge",
			text = "Scaled",
			scale = "xs",
			Position = UDim2.fromOffset(0, 0),
		}), React.createElement(Badge, {
			name = "LargeBadge",
			text = "Scaled",
			scale = "xl",
			Position = UDim2.fromOffset(0, 80),
		})), function(mounted)
			local small = waitForBadge(mounted.host, "SmallBadge")
			local large = waitForBadge(mounted.host, "LargeBadge")
			Assert["true"](Assert, large.AbsoluteSize.Y > small.AbsoluteSize.Y, `Expected the xl badge ({large.AbsoluteSize.Y}px) to be taller than the xs badge ({small.AbsoluteSize.Y}px)`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Renders its label in a content-sized, non-interactive root that contains the text")
	local _descriptor = Test(BadgeMountValidation, "mountsWithText", {
		value = BadgeMountValidation.mountsWithText,
	})
	if _descriptor then
		BadgeMountValidation.mountsWithText = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BadgeMountValidation, "mountsWithText", {
		value = BadgeMountValidation.mountsWithText,
	})
	if _descriptor_1 then
		BadgeMountValidation.mountsWithText = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BadgeMountValidation, "mountsWithText", {
		value = BadgeMountValidation.mountsWithText,
	})
	if _descriptor_2 then
		BadgeMountValidation.mountsWithText = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Default theme intent colours reach the background, UIStroke and text")
	local _decorator_4 = Each({ { "primary", "1D2433", "EEF1F6", "D9DEE8" }, { "success", "FFFFFF", "2E9D63", "237D4D" }, { "danger", "FFFFFF", "D64545", "B53535" } })
	local _descriptor_3 = Test(BadgeMountValidation, "defaultIntentColors", {
		value = BadgeMountValidation.defaultIntentColors,
	})
	if _descriptor_3 then
		BadgeMountValidation.defaultIntentColors = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(BadgeMountValidation, "defaultIntentColors", {
		value = BadgeMountValidation.defaultIntentColors,
	})
	if _descriptor_4 then
		BadgeMountValidation.defaultIntentColors = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(BadgeMountValidation, "defaultIntentColors", {
		value = BadgeMountValidation.defaultIntentColors,
	})
	if _descriptor_5 then
		BadgeMountValidation.defaultIntentColors = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(BadgeMountValidation, "defaultIntentColors", {
		value = BadgeMountValidation.defaultIntentColors,
	})
	if _descriptor_6 then
		BadgeMountValidation.defaultIntentColors = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Wooden primary renders a flat brown background, 2px dark border and cream text")
	local _descriptor_7 = Test(BadgeMountValidation, "woodenPrimary", {
		value = BadgeMountValidation.woodenPrimary,
	})
	if _descriptor_7 then
		BadgeMountValidation.woodenPrimary = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(BadgeMountValidation, "woodenPrimary", {
		value = BadgeMountValidation.woodenPrimary,
	})
	if _descriptor_8 then
		BadgeMountValidation.woodenPrimary = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(BadgeMountValidation, "woodenPrimary", {
		value = BadgeMountValidation.woodenPrimary,
	})
	if _descriptor_9 then
		BadgeMountValidation.woodenPrimary = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Each scale applies the default theme's per-scale badge text size")
	local _decorator_9 = Each({ { "xs", 10 }, { "sm", 12 }, { "md", 14 }, { "lg", 18 }, { "xl", 24 } })
	local _descriptor_10 = Test(BadgeMountValidation, "scaleSetsTextSize", {
		value = BadgeMountValidation.scaleSetsTextSize,
	})
	if _descriptor_10 then
		BadgeMountValidation.scaleSetsTextSize = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_9(BadgeMountValidation, "scaleSetsTextSize", {
		value = BadgeMountValidation.scaleSetsTextSize,
	})
	if _descriptor_11 then
		BadgeMountValidation.scaleSetsTextSize = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(BadgeMountValidation, "scaleSetsTextSize", {
		value = BadgeMountValidation.scaleSetsTextSize,
	})
	if _descriptor_12 then
		BadgeMountValidation.scaleSetsTextSize = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(BadgeMountValidation, "scaleSetsTextSize", {
		value = BadgeMountValidation.scaleSetsTextSize,
	})
	if _descriptor_13 then
		BadgeMountValidation.scaleSetsTextSize = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A larger scale renders a taller badge than a smaller one")
	local _descriptor_14 = Test(BadgeMountValidation, "largerScaleTaller", {
		value = BadgeMountValidation.largerScaleTaller,
	})
	if _descriptor_14 then
		BadgeMountValidation.largerScaleTaller = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(BadgeMountValidation, "largerScaleTaller", {
		value = BadgeMountValidation.largerScaleTaller,
	})
	if _descriptor_15 then
		BadgeMountValidation.largerScaleTaller = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(BadgeMountValidation, "largerScaleTaller", {
		value = BadgeMountValidation.largerScaleTaller,
	})
	if _descriptor_16 then
		BadgeMountValidation.largerScaleTaller = _descriptor_16.value
	end
	BadgeMountValidation = Tag("Studio")(BadgeMountValidation) or BadgeMountValidation
end
return BadgeMountValidation
