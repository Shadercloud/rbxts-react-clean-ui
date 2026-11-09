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
local Badge = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Surface", "Badge").Badge
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local FILL = Color3.fromRGB(40, 90, 160)
local TEXT = Color3.fromRGB(250, 220, 120)
local ICON = Color3.fromRGB(200, 60, 90)
local BORDER = Color3.fromRGB(20, 140, 70)
local function waitForBadge(host)
	return waitForGuiObject(host, "Badge")
end
local function directChild(parent, className)
	local found = parent:FindFirstChildWhichIsA(className)
	Assert:notUndefined(found, `Expected {parent.Name} to have a direct {className} child`)
	return found
end
local BadgePropsValidation
do
	BadgePropsValidation = setmetatable({}, {
		__tostring = function()
			return "BadgePropsValidation"
		end,
	})
	BadgePropsValidation.__index = BadgePropsValidation
	function BadgePropsValidation.new(...)
		local self = setmetatable({}, BadgePropsValidation)
		return self:constructor(...) or self
	end
	function BadgePropsValidation:constructor()
	end
	function BadgePropsValidation:treeUnchanged()
		withMounted(400, 200, React.createElement(Badge, {
			text = "New",
			icon = "check",
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			Assert:equal(badge.ClassName, "ImageLabel")
			Assert["false"](Assert, badge.Active)
			Assert["false"](Assert, badge.Selectable)
			Assert:undefined(badge:FindFirstChild("BadgeButton", true), "Expected no BadgeButton without onClick")
			Assert:undefined(badge:FindFirstChildWhichIsA("ImageButton", true), "Expected no ImageButton without onClick")
			directChild(badge, "UIPadding")
			directChild(badge, "UIListLayout")
			directChild(badge, "UIStroke")
			Assert:notUndefined(badge:FindFirstChild("BadgeText"), "Expected BadgeText directly under the root")
			Assert:notUndefined(badge:FindFirstChild("BadgeIcon"), "Expected BadgeIcon directly under the root")
		end)
	end
	function BadgePropsValidation:colourPropsOverride()
		withMounted(400, 200, React.createElement(Badge, {
			text = "Custom",
			icon = "check",
			intent = "success",
			BackgroundColor3 = FILL,
			BackgroundTransparency = 0.25,
			textColor = TEXT,
			iconColor = ICON,
			borderColor = BORDER,
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			local text = waitForGuiObject(badge, "BadgeText")
			local icon = waitForGuiObject(badge, "BadgeIcon")
			Assert:equal(badge.BackgroundColor3, FILL, "background")
			Assert:equal(badge.BackgroundTransparency, 0.25, "background transparency")
			Assert:equal(text.TextColor3, TEXT, "text")
			Assert:equal(icon.ImageColor3, ICON, "icon")
			Assert:equal(directChild(badge, "UIStroke").Color, BORDER, "border")
		end)
	end
	function BadgePropsValidation:iconFollowsText()
		withMounted(400, 200, React.createElement(Badge, {
			text = "Tinted",
			icon = "check",
			intent = "danger",
			textColor = TEXT,
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			local icon = waitForGuiObject(badge, "BadgeIcon")
			Assert:equal(icon.ImageColor3, TEXT)
		end)
	end
	function BadgePropsValidation:paddingOverrides()
		withMounted(400, 200, React.createElement(Badge, {
			text = "Padded",
			padding = "3 9",
		}), function(mounted)
			local padding = directChild(waitForBadge(mounted.host), "UIPadding")
			Assert:equal(padding.PaddingTop, UDim.new(0, 3), "PaddingTop")
			Assert:equal(padding.PaddingBottom, UDim.new(0, 3), "PaddingBottom")
			Assert:equal(padding.PaddingLeft, UDim.new(0, 9), "PaddingLeft")
			Assert:equal(padding.PaddingRight, UDim.new(0, 9), "PaddingRight")
		end)
	end
	function BadgePropsValidation:zeroBorderNoStroke()
		withMounted(400, 200, React.createElement(Badge, {
			text = "Flat",
			borderThickness = 0,
		}), function(mounted)
			local badge = waitForBadge(mounted.host)
			Assert:undefined(badge:FindFirstChildWhichIsA("UIStroke"))
		end)
	end
	function BadgePropsValidation:borderShapeProps()
		withMounted(400, 200, React.createElement(Badge, {
			text = "Ring",
			borderThickness = 3,
			borderTransparency = 0.5,
			borderPosition = "outer",
		}), function(mounted)
			local stroke = directChild(waitForBadge(mounted.host), "UIStroke")
			Assert:equal(stroke.Thickness, 3)
			Assert:equal(stroke.Transparency, 0.5)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Without the new props the root ImageLabel holds the padding, row and text directly, with no BadgeButton")
	local _descriptor = Test(BadgePropsValidation, "treeUnchanged", {
		value = BadgePropsValidation.treeUnchanged,
	})
	if _descriptor then
		BadgePropsValidation.treeUnchanged = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(BadgePropsValidation, "treeUnchanged", {
		value = BadgePropsValidation.treeUnchanged,
	})
	if _descriptor_1 then
		BadgePropsValidation.treeUnchanged = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(BadgePropsValidation, "treeUnchanged", {
		value = BadgePropsValidation.treeUnchanged,
	})
	if _descriptor_2 then
		BadgePropsValidation.treeUnchanged = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Per-instance background, transparency, text, icon and border colours override the intent scheme")
	local _descriptor_3 = Test(BadgePropsValidation, "colourPropsOverride", {
		value = BadgePropsValidation.colourPropsOverride,
	})
	if _descriptor_3 then
		BadgePropsValidation.colourPropsOverride = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(BadgePropsValidation, "colourPropsOverride", {
		value = BadgePropsValidation.colourPropsOverride,
	})
	if _descriptor_4 then
		BadgePropsValidation.colourPropsOverride = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(BadgePropsValidation, "colourPropsOverride", {
		value = BadgePropsValidation.colourPropsOverride,
	})
	if _descriptor_5 then
		BadgePropsValidation.colourPropsOverride = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("With textColor but no iconColor the icon is tinted with the text colour")
	local _descriptor_6 = Test(BadgePropsValidation, "iconFollowsText", {
		value = BadgePropsValidation.iconFollowsText,
	})
	if _descriptor_6 then
		BadgePropsValidation.iconFollowsText = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(BadgePropsValidation, "iconFollowsText", {
		value = BadgePropsValidation.iconFollowsText,
	})
	if _descriptor_7 then
		BadgePropsValidation.iconFollowsText = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(BadgePropsValidation, "iconFollowsText", {
		value = BadgePropsValidation.iconFollowsText,
	})
	if _descriptor_8 then
		BadgePropsValidation.iconFollowsText = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A padding quad replaces the theme's per-scale padding on each side")
	local _descriptor_9 = Test(BadgePropsValidation, "paddingOverrides", {
		value = BadgePropsValidation.paddingOverrides,
	})
	if _descriptor_9 then
		BadgePropsValidation.paddingOverrides = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(BadgePropsValidation, "paddingOverrides", {
		value = BadgePropsValidation.paddingOverrides,
	})
	if _descriptor_10 then
		BadgePropsValidation.paddingOverrides = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(BadgePropsValidation, "paddingOverrides", {
		value = BadgePropsValidation.paddingOverrides,
	})
	if _descriptor_11 then
		BadgePropsValidation.paddingOverrides = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("borderThickness={0} renders no UIStroke at all")
	local _descriptor_12 = Test(BadgePropsValidation, "zeroBorderNoStroke", {
		value = BadgePropsValidation.zeroBorderNoStroke,
	})
	if _descriptor_12 then
		BadgePropsValidation.zeroBorderNoStroke = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(BadgePropsValidation, "zeroBorderNoStroke", {
		value = BadgePropsValidation.zeroBorderNoStroke,
	})
	if _descriptor_13 then
		BadgePropsValidation.zeroBorderNoStroke = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(BadgePropsValidation, "zeroBorderNoStroke", {
		value = BadgePropsValidation.zeroBorderNoStroke,
	})
	if _descriptor_14 then
		BadgePropsValidation.zeroBorderNoStroke = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("borderThickness, borderTransparency and borderPosition outer reach the stroke")
	local _descriptor_15 = Test(BadgePropsValidation, "borderShapeProps", {
		value = BadgePropsValidation.borderShapeProps,
	})
	if _descriptor_15 then
		BadgePropsValidation.borderShapeProps = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(BadgePropsValidation, "borderShapeProps", {
		value = BadgePropsValidation.borderShapeProps,
	})
	if _descriptor_16 then
		BadgePropsValidation.borderShapeProps = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(BadgePropsValidation, "borderShapeProps", {
		value = BadgePropsValidation.borderShapeProps,
	})
	if _descriptor_17 then
		BadgePropsValidation.borderShapeProps = _descriptor_17.value
	end
	BadgePropsValidation = Tag("Studio")(BadgePropsValidation) or BadgePropsValidation
end
return BadgePropsValidation
