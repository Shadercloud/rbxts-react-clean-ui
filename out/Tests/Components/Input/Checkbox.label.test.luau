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
local Checkbox = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Checkbox").Checkbox
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SpacingHelper
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local activateButton = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").activateButton
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local LABEL_TEXT_COLOR = Color3.fromRGB(200, 60, 90)
local LABEL_GAP = 10
local LABEL_THEME = extendTheme(DefaultTheme, {
	components = {
		checkbox = {
			label = {
				gap = LABEL_GAP,
				textColor = LABEL_TEXT_COLOR,
				typography = {
					size = Enum.FontSize.Size24,
				},
			},
		},
	},
})
local function waitForRoot(host, name)
	if name == nil then
		name = "Checkbox"
	end
	return waitForGuiObject(host, name)
end
local function rowLayout(root)
	local layout = root:FindFirstChildWhichIsA("UIListLayout")
	Assert:notUndefined(layout, `Expected {root.Name} to have a direct UIListLayout`)
	return layout
end
local function assertGap(root, expected, label)
	local box = waitForGuiObject(root, "CheckboxBox")
	local labelButton = waitForGuiObject(root, "CheckboxLabel")
	Assert:equal(rowLayout(root).Padding, UDim.new(0, expected), `{label}: UIListLayout.Padding`)
	Assert["true"](Assert, math.abs(rect(labelButton).left - rect(box).right - expected) <= 1, `{label}: expected a {expected}px gap, got {rect(labelButton).left - rect(box).right}px`)
end
local CheckboxLabelValidation
do
	CheckboxLabelValidation = setmetatable({}, {
		__tostring = function()
			return "CheckboxLabelValidation"
		end,
	})
	CheckboxLabelValidation.__index = CheckboxLabelValidation
	function CheckboxLabelValidation.new(...)
		local self = setmetatable({}, CheckboxLabelValidation)
		return self:constructor(...) or self
	end
	function CheckboxLabelValidation:constructor()
	end
	function CheckboxLabelValidation:labelTree()
		withMounted(400, 200, React.createElement(Checkbox, {
			label = "Accept terms",
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			local box = waitForGuiObject(root, "CheckboxBox")
			local labelButton = waitForGuiObject(root, "CheckboxLabel")
			local text = waitForGuiObject(labelButton, "CheckboxLabelText")
			local layout = rowLayout(root)
			Assert:equal(root.ClassName, "Frame")
			Assert:equal(root.BackgroundTransparency, 1)
			Assert:equal(root.AutomaticSize, Enum.AutomaticSize.XY)
			Assert:equal(box.Parent, root, "Expected CheckboxBox directly under the root")
			Assert:equal(labelButton.Parent, root, "Expected CheckboxLabel directly under the root")
			Assert:notUndefined(box:FindFirstChild("CheckboxIcon", true), "Expected the icon inside CheckboxBox")
			Assert["false"](Assert, labelButton.Selectable, "Expected CheckboxLabel not to be gamepad-selectable")
			Assert:equal(labelButton.BackgroundTransparency, 1)
			Assert:equal(text.Text, "Accept terms")
			Assert["false"](Assert, text.TextWrapped, "Expected the label text not to wrap")
			Assert:equal(layout.FillDirection, Enum.FillDirection.Horizontal)
			Assert:equal(layout.VerticalAlignment, Enum.VerticalAlignment.Center)
			Assert["false"](Assert, layout.Wraps)
			assertStackedHorizontally({ box, labelButton }, "box then label")
			assertAllDescendantsContained(root, "labelled checkbox")
		end)
	end
	function CheckboxLabelValidation:noLabelTree()
		withMounted(400, 200, React.createElement(Checkbox), function(mounted)
			local root = waitForGuiObject(mounted.host, "Checkbox")
			Assert:equal(root.ClassName, "ImageButton")
			Assert:undefined(mounted.host:FindFirstChild("CheckboxBox", true))
			Assert:undefined(mounted.host:FindFirstChild("CheckboxLabel", true))
		end)
	end
	function CheckboxLabelValidation:namedLabelRoot()
		withMounted(400, 200, React.createElement(Checkbox, {
			name = "Terms",
			label = "Accept terms",
		}), function(mounted)
			local root = waitForRoot(mounted.host, "Terms")
			Assert:equal(root.ClassName, "Frame")
			Assert:notUndefined(root:FindFirstChild("CheckboxBox"))
			Assert:undefined(mounted.host:FindFirstChild("Checkbox", true))
		end)
	end
	function CheckboxLabelValidation:labelClickToggles()
		local values = {}
		withMounted(400, 200, React.createElement(Checkbox, {
			label = "Accept terms",
			onChange = function(value)
				local _value = value
				table.insert(values, _value)
			end,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			local labelButton = waitForGuiObject(root, "CheckboxLabel")
			local icon = findDescendant(root, "CheckboxIcon")
			activateButton(mounted, labelButton)
			Assert:deepEqual(values, { true })
			Assert["true"](Assert, icon.Image ~= "", "Expected the check icon after clicking the label")
			activateButton(mounted, waitForGuiObject(root, "CheckboxBox"))
			Assert:deepEqual(values, { true, false })
			Assert:equal(icon.Image, "", "Expected no icon after clicking the box again")
		end)
	end
	function CheckboxLabelValidation:defaultLabelStyle()
		local expectedGap = math.ceil(SpacingHelper:GetPadding(DefaultTheme, nil, DefaultTheme.components.checkbox.spacing) / 2)
		local expectedSize = DefaultTheme.typography[DefaultTheme.typeScaleMap[DefaultTheme.default.scale]].size
		withMounted(400, 200, React.createElement(Checkbox, {
			label = "Accept terms",
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			local text = waitForGuiObject(root, "CheckboxLabelText")
			assertGap(root, expectedGap, "default gap")
			Assert:equal(text.FontSize, expectedSize, "default label FontSize")
			Assert:equal(text.TextColor3, DefaultTheme.colors.intents.primary.default.textColor, "default label colour")
		end)
	end
	function CheckboxLabelValidation:themedLabelStyle()
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = LABEL_THEME,
		}, React.createElement(Checkbox, {
			label = "Accept terms",
		})), function(mounted)
			local root = waitForRoot(mounted.host)
			local text = waitForGuiObject(root, "CheckboxLabelText")
			assertGap(root, LABEL_GAP, "themed gap")
			Assert:equal(text.FontSize, Enum.FontSize.Size24, "themed label FontSize")
			Assert:equal(text.TextColor3, LABEL_TEXT_COLOR, "themed label colour")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With a label the root is a transparent Frame holding CheckboxBox then CheckboxLabel in a row")
	local _descriptor = Test(CheckboxLabelValidation, "labelTree", {
		value = CheckboxLabelValidation.labelTree,
	})
	if _descriptor then
		CheckboxLabelValidation.labelTree = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(CheckboxLabelValidation, "labelTree", {
		value = CheckboxLabelValidation.labelTree,
	})
	if _descriptor_1 then
		CheckboxLabelValidation.labelTree = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(CheckboxLabelValidation, "labelTree", {
		value = CheckboxLabelValidation.labelTree,
	})
	if _descriptor_2 then
		CheckboxLabelValidation.labelTree = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Without a label the root is the box ImageButton itself, with no CheckboxBox or CheckboxLabel")
	local _descriptor_3 = Test(CheckboxLabelValidation, "noLabelTree", {
		value = CheckboxLabelValidation.noLabelTree,
	})
	if _descriptor_3 then
		CheckboxLabelValidation.noLabelTree = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(CheckboxLabelValidation, "noLabelTree", {
		value = CheckboxLabelValidation.noLabelTree,
	})
	if _descriptor_4 then
		CheckboxLabelValidation.noLabelTree = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(CheckboxLabelValidation, "noLabelTree", {
		value = CheckboxLabelValidation.noLabelTree,
	})
	if _descriptor_5 then
		CheckboxLabelValidation.noLabelTree = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("The name prop names the label-mode root Frame while the box keeps the CheckboxBox name")
	local _descriptor_6 = Test(CheckboxLabelValidation, "namedLabelRoot", {
		value = CheckboxLabelValidation.namedLabelRoot,
	})
	if _descriptor_6 then
		CheckboxLabelValidation.namedLabelRoot = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(CheckboxLabelValidation, "namedLabelRoot", {
		value = CheckboxLabelValidation.namedLabelRoot,
	})
	if _descriptor_7 then
		CheckboxLabelValidation.namedLabelRoot = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(CheckboxLabelValidation, "namedLabelRoot", {
		value = CheckboxLabelValidation.namedLabelRoot,
	})
	if _descriptor_8 then
		CheckboxLabelValidation.namedLabelRoot = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Clicking the label text toggles the checkbox exactly like clicking the box")
	local _descriptor_9 = Test(CheckboxLabelValidation, "labelClickToggles", {
		value = CheckboxLabelValidation.labelClickToggles,
	})
	if _descriptor_9 then
		CheckboxLabelValidation.labelClickToggles = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(CheckboxLabelValidation, "labelClickToggles", {
		value = CheckboxLabelValidation.labelClickToggles,
	})
	if _descriptor_10 then
		CheckboxLabelValidation.labelClickToggles = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(CheckboxLabelValidation, "labelClickToggles", {
		value = CheckboxLabelValidation.labelClickToggles,
	})
	if _descriptor_11 then
		CheckboxLabelValidation.labelClickToggles = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Unthemed, the gap is half the checkbox spacing rounded up and the text uses the scale's typography and default colour")
	local _descriptor_12 = Test(CheckboxLabelValidation, "defaultLabelStyle", {
		value = CheckboxLabelValidation.defaultLabelStyle,
	})
	if _descriptor_12 then
		CheckboxLabelValidation.defaultLabelStyle = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(CheckboxLabelValidation, "defaultLabelStyle", {
		value = CheckboxLabelValidation.defaultLabelStyle,
	})
	if _descriptor_13 then
		CheckboxLabelValidation.defaultLabelStyle = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(CheckboxLabelValidation, "defaultLabelStyle", {
		value = CheckboxLabelValidation.defaultLabelStyle,
	})
	if _descriptor_14 then
		CheckboxLabelValidation.defaultLabelStyle = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("checkbox.label gap, textColor and typography from the theme reach the row and the label text")
	local _descriptor_15 = Test(CheckboxLabelValidation, "themedLabelStyle", {
		value = CheckboxLabelValidation.themedLabelStyle,
	})
	if _descriptor_15 then
		CheckboxLabelValidation.themedLabelStyle = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(CheckboxLabelValidation, "themedLabelStyle", {
		value = CheckboxLabelValidation.themedLabelStyle,
	})
	if _descriptor_16 then
		CheckboxLabelValidation.themedLabelStyle = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(CheckboxLabelValidation, "themedLabelStyle", {
		value = CheckboxLabelValidation.themedLabelStyle,
	})
	if _descriptor_17 then
		CheckboxLabelValidation.themedLabelStyle = _descriptor_17.value
	end
	CheckboxLabelValidation = Tag("Studio")(CheckboxLabelValidation) or CheckboxLabelValidation
end
return CheckboxLabelValidation
