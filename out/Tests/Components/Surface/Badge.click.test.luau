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
local ColorHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").ColorHelper
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DarkTheme = _Theme.DarkTheme
local DefaultTheme = _Theme.DefaultTheme
local _fiber = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber")
local activateButton = _fiber.activateButton
local fireHostEvent = _fiber.fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOVER_FILL = Color3.fromRGB(30, 120, 200)
local HOVER_TEXT = Color3.fromRGB(250, 220, 120)
local PRESS_FILL = Color3.fromRGB(150, 40, 60)
local COLOR_TOLERANCE = 1.5 / 255
local function themeFor(label)
	return if label == "dark" then DarkTheme else DefaultTheme
end
local function restingBackground(theme)
	return ColorHelper:getIntentColors(theme, "primary", "default", theme.components.badge.intents).backgroundColor
end
local function shade(color, amount)
	return color:Lerp(if amount < 0 then Color3.new(1, 1, 1) else Color3.new(0, 0, 0), math.abs(amount))
end
local function brightness(color)
	return color.R + color.G + color.B
end
local function assertColorNear(actual, expected, label)
	local near = math.abs(actual.R - expected.R) <= COLOR_TOLERANCE and math.abs(actual.G - expected.G) <= COLOR_TOLERANCE and math.abs(actual.B - expected.B) <= COLOR_TOLERANCE
	Assert["true"](Assert, near, `{label}: expected #{expected:ToHex()}, got #{actual:ToHex()}`)
end
local function clickableBadge(theme, props)
	if props == nil then
		props = {}
	end
	local _attributes = {
		text = "Clickable",
		onClick = function() end,
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, React.createElement(Badge, _attributes))
end
local function waitForBadge(host)
	return waitForGuiObject(host, "Badge")
end
local function badgeButton(badge)
	local button = badge:FindFirstChild("BadgeButton")
	Assert:notUndefined(button, `Expected {badge.Name} to have a direct BadgeButton child`)
	return button
end
local BadgeClickValidation
do
	BadgeClickValidation = setmetatable({}, {
		__tostring = function()
			return "BadgeClickValidation"
		end,
	})
	BadgeClickValidation.__index = BadgeClickValidation
	function BadgeClickValidation.new(...)
		local self = setmetatable({}, BadgeClickValidation)
		return self:constructor(...) or self
	end
	function BadgeClickValidation:constructor()
	end
	function BadgeClickValidation:clickableTree()
		withMounted(400, 200, clickableBadge(DefaultTheme), function(mounted)
			local badge = waitForBadge(mounted.host)
			local button = badgeButton(badge)
			waitForGuiObject(button, "BadgeText")
			Assert:equal(badge.ClassName, "ImageLabel", "Expected the root to stay an ImageLabel")
			Assert:equal(button.BackgroundTransparency, 1)
			Assert["false"](Assert, button.AutoButtonColor)
			Assert:notUndefined(button:FindFirstChildWhichIsA("UIPadding"), "Expected the UIPadding inside BadgeButton")
			Assert:undefined(badge:FindFirstChildWhichIsA("UIPadding"), "Expected no UIPadding directly on the root")
			Assert:notUndefined(badge:FindFirstChildWhichIsA("UIStroke"), "Expected the stroke to stay on the root")
			assertSizeApprox(badge, button.AbsoluteSize.X, button.AbsoluteSize.Y, 1, "root vs BadgeButton")
			Assert["true"](Assert, badge.AbsoluteSize.X < 400, "Expected a clickable Badge to stay content-sized")
		end)
	end
	function BadgeClickValidation:activatedCallsOnClick()
		local clicks = 0
		withMounted(400, 200, clickableBadge(DefaultTheme, {
			onClick = function()
				clicks += 1
			end,
		}), function(mounted)
			local button = badgeButton(waitForBadge(mounted.host))
			activateButton(mounted, button)
			Assert:equal(clicks, 1)
			activateButton(mounted, button)
			Assert:equal(clicks, 2)
		end)
	end
	function BadgeClickValidation:themeShading(label)
		local theme = themeFor(label)
		local resting = restingBackground(theme)
		local _condition = theme.components.badge.hoverDarken
		if _condition == nil then
			_condition = 0
		end
		local hoverDarken = _condition
		local _condition_1 = theme.components.badge.pressDarken
		if _condition_1 == nil then
			_condition_1 = hoverDarken
		end
		local pressDarken = _condition_1
		withMounted(400, 200, clickableBadge(theme), function(mounted)
			local badge = waitForBadge(mounted.host)
			local button = badgeButton(badge)
			assertColorNear(badge.BackgroundColor3, resting, `{label} resting`)
			fireHostEvent(mounted, button, "MouseEnter")
			assertColorNear(badge.BackgroundColor3, shade(resting, hoverDarken), `{label} hovered`)
			fireHostEvent(mounted, button, "MouseButton1Down")
			assertColorNear(badge.BackgroundColor3, shade(resting, pressDarken), `{label} pressed`)
			fireHostEvent(mounted, button, "MouseLeave")
			assertColorNear(badge.BackgroundColor3, resting, `{label} after leave`)
		end)
	end
	function BadgeClickValidation:darkLightens()
		local resting = restingBackground(DarkTheme)
		withMounted(400, 200, clickableBadge(DarkTheme), function(mounted)
			local badge = waitForBadge(mounted.host)
			fireHostEvent(mounted, badgeButton(badge), "MouseEnter")
			Assert["true"](Assert, brightness(badge.BackgroundColor3) > brightness(resting), `Expected hovered #{badge.BackgroundColor3:ToHex()} to be lighter than resting #{resting:ToHex()}`)
		end)
	end
	function BadgeClickValidation:stateStylesWin()
		withMounted(400, 200, clickableBadge(DefaultTheme, {
			hoverStyle = {
				backgroundColor = HOVER_FILL,
				textColor = HOVER_TEXT,
			},
			pressStyle = {
				backgroundColor = PRESS_FILL,
			},
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			local button = badgeButton(badge)
			local text = waitForGuiObject(button, "BadgeText")
			fireHostEvent(mounted, button, "MouseEnter")
			Assert:equal(badge.BackgroundColor3, HOVER_FILL, "hovered background")
			Assert:equal(text.TextColor3, HOVER_TEXT, "hovered text")
			fireHostEvent(mounted, button, "MouseButton1Down")
			Assert:equal(badge.BackgroundColor3, PRESS_FILL, "pressed background")
			Assert:equal(text.TextColor3, HOVER_TEXT, "pressed text falls back to hoverStyle")
			fireHostEvent(mounted, button, "MouseButton1Up")
			Assert:equal(badge.BackgroundColor3, HOVER_FILL, "released background")
		end)
	end
	function BadgeClickValidation:removingClickResets()
		local resting = restingBackground(DefaultTheme)
		withMounted(400, 200, clickableBadge(DefaultTheme), function(mounted)
			local badge = waitForBadge(mounted.host)
			fireHostEvent(mounted, badgeButton(badge), "MouseEnter")
			mounted.update(React.createElement(ThemeProvider, {
				theme = DefaultTheme,
			}, React.createElement(Badge, {
				text = "Clickable",
			})))
			settleFrames(2)
			assertColorNear(badge.BackgroundColor3, resting, "without onClick")
			mounted.update(clickableBadge(DefaultTheme))
			assertColorNear(waitForBadge(mounted.host).BackgroundColor3, resting, "onClick re-added")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("onClick moves the padding and row into a transparent BadgeButton while the root still hugs it")
	local _descriptor = Test(BadgeClickValidation, "clickableTree", {
		value = BadgeClickValidation.clickableTree,
	})
	if _descriptor then
		BadgeClickValidation.clickableTree = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BadgeClickValidation, "clickableTree", {
		value = BadgeClickValidation.clickableTree,
	})
	if _descriptor_1 then
		BadgeClickValidation.clickableTree = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BadgeClickValidation, "clickableTree", {
		value = BadgeClickValidation.clickableTree,
	})
	if _descriptor_2 then
		BadgeClickValidation.clickableTree = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Activating BadgeButton calls onClick once per activation")
	local _descriptor_3 = Test(BadgeClickValidation, "activatedCallsOnClick", {
		value = BadgeClickValidation.activatedCallsOnClick,
	})
	if _descriptor_3 then
		BadgeClickValidation.activatedCallsOnClick = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(BadgeClickValidation, "activatedCallsOnClick", {
		value = BadgeClickValidation.activatedCallsOnClick,
	})
	if _descriptor_4 then
		BadgeClickValidation.activatedCallsOnClick = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(BadgeClickValidation, "activatedCallsOnClick", {
		value = BadgeClickValidation.activatedCallsOnClick,
	})
	if _descriptor_5 then
		BadgeClickValidation.activatedCallsOnClick = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = Each({ { "default" }, { "dark" } })
	local _decorator_6 = DisplayName("Hover shades the resting background by hoverDarken and press by pressDarken, then leaving restores it")
	local _descriptor_6 = Test(BadgeClickValidation, "themeShading", {
		value = BadgeClickValidation.themeShading,
	})
	if _descriptor_6 then
		BadgeClickValidation.themeShading = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_6(BadgeClickValidation, "themeShading", {
		value = BadgeClickValidation.themeShading,
	})
	if _descriptor_7 then
		BadgeClickValidation.themeShading = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(BadgeClickValidation, "themeShading", {
		value = BadgeClickValidation.themeShading,
	})
	if _descriptor_8 then
		BadgeClickValidation.themeShading = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(BadgeClickValidation, "themeShading", {
		value = BadgeClickValidation.themeShading,
	})
	if _descriptor_9 then
		BadgeClickValidation.themeShading = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Under DarkTheme hovering lightens the badge instead of darkening it")
	local _descriptor_10 = Test(BadgeClickValidation, "darkLightens", {
		value = BadgeClickValidation.darkLightens,
	})
	if _descriptor_10 then
		BadgeClickValidation.darkLightens = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(BadgeClickValidation, "darkLightens", {
		value = BadgeClickValidation.darkLightens,
	})
	if _descriptor_11 then
		BadgeClickValidation.darkLightens = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(BadgeClickValidation, "darkLightens", {
		value = BadgeClickValidation.darkLightens,
	})
	if _descriptor_12 then
		BadgeClickValidation.darkLightens = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("hoverStyle and pressStyle colours replace the shading, and pressed falls back to hoverStyle fields")
	local _descriptor_13 = Test(BadgeClickValidation, "stateStylesWin", {
		value = BadgeClickValidation.stateStylesWin,
	})
	if _descriptor_13 then
		BadgeClickValidation.stateStylesWin = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(BadgeClickValidation, "stateStylesWin", {
		value = BadgeClickValidation.stateStylesWin,
	})
	if _descriptor_14 then
		BadgeClickValidation.stateStylesWin = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(BadgeClickValidation, "stateStylesWin", {
		value = BadgeClickValidation.stateStylesWin,
	})
	if _descriptor_15 then
		BadgeClickValidation.stateStylesWin = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Removing onClick while hovered drops the hover look, and re-adding it does not bring it back")
	local _descriptor_16 = Test(BadgeClickValidation, "removingClickResets", {
		value = BadgeClickValidation.removingClickResets,
	})
	if _descriptor_16 then
		BadgeClickValidation.removingClickResets = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(BadgeClickValidation, "removingClickResets", {
		value = BadgeClickValidation.removingClickResets,
	})
	if _descriptor_17 then
		BadgeClickValidation.removingClickResets = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(BadgeClickValidation, "removingClickResets", {
		value = BadgeClickValidation.removingClickResets,
	})
	if _descriptor_18 then
		BadgeClickValidation.removingClickResets = _descriptor_18.value
	end
	BadgeClickValidation = Tag("Studio")(BadgeClickValidation) or BadgeClickValidation
end
return BadgeClickValidation
