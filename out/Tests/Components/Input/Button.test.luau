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
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Button").Button
local _Layout = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout")
local Group = _Layout.Group
local HStack = _Layout.HStack
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local WoodenTheme = _Theme.WoodenTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertStackedHorizontally = _layout.assertStackedHorizontally
local assertTextFits = _layout.assertTextFits
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local WOODEN_SECONDARY_TEXT = Color3.fromHex("#D3CBA3")
local WOODEN_SECONDARY_BORDER = Color3.fromHex("#3D2712")
local WOODEN_SECONDARY_TOP = Color3.fromHex("#7A4A20")
local WOODEN_SECONDARY_BOTTOM = Color3.fromHex("#5C3A18")
local function waitForButton(host, name)
	if name == nil then
		name = "Button"
	end
	return waitForGuiObject(host, name)
end
local function rootPadding(button)
	local padding = button:FindFirstChildWhichIsA("UIPadding")
	Assert:notUndefined(padding, `Expected {button.Name} to have a direct UIPadding child`)
	return padding
end
local function assertSides(padding, top, bottom, left, right, label)
	Assert:equal(padding.PaddingTop, UDim.new(0, top), `{label}: PaddingTop`)
	Assert:equal(padding.PaddingBottom, UDim.new(0, bottom), `{label}: PaddingBottom`)
	Assert:equal(padding.PaddingLeft, UDim.new(0, left), `{label}: PaddingLeft`)
	Assert:equal(padding.PaddingRight, UDim.new(0, right), `{label}: PaddingRight`)
end
local ButtonMountValidation
do
	ButtonMountValidation = setmetatable({}, {
		__tostring = function()
			return "ButtonMountValidation"
		end,
	})
	ButtonMountValidation.__index = ButtonMountValidation
	function ButtonMountValidation.new(...)
		local self = setmetatable({}, ButtonMountValidation)
		return self:constructor(...) or self
	end
	function ButtonMountValidation:constructor()
	end
	function ButtonMountValidation:mountsContained()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save changes",
			icon = "check",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			assertNonZeroSize(button, "icon + text button")
			assertAllDescendantsContained(button, "icon + text button")
			local label = findDescendant(button, "ButtonText")
			Assert:equal(label.Text, "Save changes")
			assertTextFits(label, "icon + text button")
		end)
	end
	function ButtonMountValidation:iconLeadsText()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save changes",
			icon = "check",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			local icon = waitForGuiObject(button, "ButtonIcon")
			local label = waitForGuiObject(button, "ButtonText")
			assertStackedHorizontally({ icon, label }, "icon + text row")
		end)
	end
	function ButtonMountValidation:disabledInert()
		withMounted(400, 200, React.createElement(Button, {
			text = "Submit",
			disabled = true,
		}), function(mounted)
			local button = waitForButton(mounted.host)
			Assert["false"](Assert, button.Active, "Expected a disabled Button's root ImageButton to have Active=false")
			mounted.update(React.createElement(Button, {
				text = "Submit",
			}))
			waitForLayout(function()
				return if button.Active then true else nil
			end, "Timed out waiting for the Button to become Active again after disabled was removed")
		end)
	end
	function ButtonMountValidation:groupAlignsWidths()
		withMounted(400, 200, React.createElement(Group, nil, React.createElement(HStack, nil, React.createElement(Button, {
			name = "ShortButton",
			group = true,
			text = "OK",
		}), React.createElement(Button, {
			name = "LongButton",
			group = true,
			text = "A considerably longer label",
		}))), function(mounted)
			local short = waitForButton(mounted.host, "ShortButton")
			local long = waitForButton(mounted.host, "LongButton")
			waitForLayout(function()
				return if rect(short).width > 0 and rect(short).width == rect(long).width then true else nil
			end, `Timed out waiting for grouped buttons to share a width (short={rect(short).width}, long={rect(long).width})`)
			assertAllDescendantsContained(short, "grouped short button")
			assertAllDescendantsContained(long, "grouped long button")
		end)
	end
	function ButtonMountValidation:woodenSecondary()
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = WoodenTheme,
		}, React.createElement(Button, {
			text = "Cancel",
			intent = "secondary",
		})), function(mounted)
			local button = waitForButton(mounted.host)
			Assert:equal(button.BackgroundTransparency, 0)
			local gradient = button:FindFirstChild("Gradient")
			Assert:notUndefined(gradient, "Expected the secondary Button to carry a Gradient UIGradient")
			local keypoints = gradient.Color.Keypoints
			Assert:equal(keypoints[1].Value, WOODEN_SECONDARY_TOP)
			Assert:equal(keypoints[#keypoints].Value, WOODEN_SECONDARY_BOTTOM)
			Assert:equal(gradient.Rotation, 90)
			local stroke = findDescendant(button, "Stroke")
			Assert:equal(stroke.Thickness, 3)
			Assert:equal(stroke.Color, WOODEN_SECONDARY_BORDER)
			Assert:equal(findDescendant(button, "ButtonText").TextColor3, WOODEN_SECONDARY_TEXT)
		end)
	end
	function ButtonMountValidation:woodenPrimaryUnchanged()
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = WoodenTheme,
		}, React.createElement(Button, {
			text = "Confirm",
		})), function(mounted)
			local button = waitForButton(mounted.host)
			Assert:equal(button.BackgroundTransparency, 1)
			Assert:equal(findDescendant(button, "Stroke").Thickness, 0)
			Assert:undefined(button:FindFirstChild("Gradient"))
		end)
	end
	function ButtonMountValidation:paddingQuadSides()
		withMounted(400, 200, React.createElement(Button, {
			name = "PaddedButton",
			text = "Save",
			padding = "4 12",
		}), function(mounted)
			local button = waitForButton(mounted.host, "PaddedButton")
			assertSides(rootPadding(button), 4, 4, 12, 12, 'padding="4 12"')
		end)
	end
	function ButtonMountValidation:defaultPaddingFromTheme()
		local expected = DefaultTheme.spacing[DefaultTheme.default.spacing]
		Assert:notUndefined(expected, "Expected the default theme to define spacing at its default spacing key")
		withMounted(400, 200, React.createElement(Button, {
			text = "Save",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			assertSides(rootPadding(button), expected, expected, expected, expected, "no padding prop")
		end)
	end
	function ButtonMountValidation:paddingOverridesNone()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save",
			spacing = "None",
			padding = "6",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			assertSides(rootPadding(button), 6, 6, 6, 6, 'spacing="None" padding="6"')
		end)
	end
	function ButtonMountValidation:paddingKeepsOrder()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save changes",
			icon = "check",
			padding = "4 12",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			local icon = waitForGuiObject(button, "ButtonIcon")
			local label = waitForGuiObject(button, "ButtonText")
			Assert:equal(icon.LayoutOrder, 1)
			Assert:equal(label.LayoutOrder, 2)
			assertStackedHorizontally({ icon, label }, "padded icon + text row")
		end)
	end
	function ButtonMountValidation:modalDefaultsOff()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save",
		}), function(mounted)
			local button = waitForButton(mounted.host)
			Assert["false"](Assert, button.Modal, "Expected Modal=false when the modal prop is unset")
		end)
	end
	function ButtonMountValidation:modalForwarded()
		withMounted(400, 200, React.createElement(Button, {
			text = "Save",
			modal = true,
		}), function(mounted)
			local button = waitForButton(mounted.host)
			Assert["true"](Assert, button.Modal, "Expected Modal=true when modal={true} is passed")
		end)
	end
	function ButtonMountValidation:themeRadiusToken(token)
		local theme = extendTheme(DefaultTheme, {
			components = {
				button = {
					cornerRadius = token,
				},
			},
		})
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Button, {
			text = "Save",
		})), function(mounted)
			local button = waitForButton(mounted.host)
			local corner = button:FindFirstChildWhichIsA("UICorner")
			Assert:notUndefined(corner, "Expected the Button to have a direct UICorner child")
			Assert:equal(corner.CornerRadius, UDim.new(0, DefaultTheme.radius[token]), `cornerRadius="{token}"`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With an icon and text, the Button auto-sizes and every visible descendant stays inside it")
	local _descriptor = Test(ButtonMountValidation, "mountsContained", {
		value = ButtonMountValidation.mountsContained,
	})
	if _descriptor then
		ButtonMountValidation.mountsContained = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ButtonMountValidation, "mountsContained", {
		value = ButtonMountValidation.mountsContained,
	})
	if _descriptor_1 then
		ButtonMountValidation.mountsContained = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ButtonMountValidation, "mountsContained", {
		value = ButtonMountValidation.mountsContained,
	})
	if _descriptor_2 then
		ButtonMountValidation.mountsContained = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("The icon renders to the left of the label without overlapping it")
	local _descriptor_3 = Test(ButtonMountValidation, "iconLeadsText", {
		value = ButtonMountValidation.iconLeadsText,
	})
	if _descriptor_3 then
		ButtonMountValidation.iconLeadsText = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ButtonMountValidation, "iconLeadsText", {
		value = ButtonMountValidation.iconLeadsText,
	})
	if _descriptor_4 then
		ButtonMountValidation.iconLeadsText = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ButtonMountValidation, "iconLeadsText", {
		value = ButtonMountValidation.iconLeadsText,
	})
	if _descriptor_5 then
		ButtonMountValidation.iconLeadsText = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("disabled={true} sets the root ImageButton inactive, and re-enabling restores Active")
	local _descriptor_6 = Test(ButtonMountValidation, "disabledInert", {
		value = ButtonMountValidation.disabledInert,
	})
	if _descriptor_6 then
		ButtonMountValidation.disabledInert = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ButtonMountValidation, "disabledInert", {
		value = ButtonMountValidation.disabledInert,
	})
	if _descriptor_7 then
		ButtonMountValidation.disabledInert = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ButtonMountValidation, "disabledInert", {
		value = ButtonMountValidation.disabledInert,
	})
	if _descriptor_8 then
		ButtonMountValidation.disabledInert = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Two grouped Buttons with different label lengths settle on the same width")
	local _descriptor_9 = Test(ButtonMountValidation, "groupAlignsWidths", {
		value = ButtonMountValidation.groupAlignsWidths,
	})
	if _descriptor_9 then
		ButtonMountValidation.groupAlignsWidths = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(ButtonMountValidation, "groupAlignsWidths", {
		value = ButtonMountValidation.groupAlignsWidths,
	})
	if _descriptor_10 then
		ButtonMountValidation.groupAlignsWidths = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(ButtonMountValidation, "groupAlignsWidths", {
		value = ButtonMountValidation.groupAlignsWidths,
	})
	if _descriptor_11 then
		ButtonMountValidation.groupAlignsWidths = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Under WoodenTheme a secondary Button renders an opaque gradient fill, a 3px border stroke and #D3CBA3 text")
	local _descriptor_12 = Test(ButtonMountValidation, "woodenSecondary", {
		value = ButtonMountValidation.woodenSecondary,
	})
	if _descriptor_12 then
		ButtonMountValidation.woodenSecondary = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(ButtonMountValidation, "woodenSecondary", {
		value = ButtonMountValidation.woodenSecondary,
	})
	if _descriptor_13 then
		ButtonMountValidation.woodenSecondary = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(ButtonMountValidation, "woodenSecondary", {
		value = ButtonMountValidation.woodenSecondary,
	})
	if _descriptor_14 then
		ButtonMountValidation.woodenSecondary = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Under WoodenTheme a primary Button keeps its transparent image look with a zero-thickness stroke and no gradient")
	local _descriptor_15 = Test(ButtonMountValidation, "woodenPrimaryUnchanged", {
		value = ButtonMountValidation.woodenPrimaryUnchanged,
	})
	if _descriptor_15 then
		ButtonMountValidation.woodenPrimaryUnchanged = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(ButtonMountValidation, "woodenPrimaryUnchanged", {
		value = ButtonMountValidation.woodenPrimaryUnchanged,
	})
	if _descriptor_16 then
		ButtonMountValidation.woodenPrimaryUnchanged = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(ButtonMountValidation, "woodenPrimaryUnchanged", {
		value = ButtonMountValidation.woodenPrimaryUnchanged,
	})
	if _descriptor_17 then
		ButtonMountValidation.woodenPrimaryUnchanged = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("A two-value padding quad sets top/bottom from the first value and left/right from the second")
	local _descriptor_18 = Test(ButtonMountValidation, "paddingQuadSides", {
		value = ButtonMountValidation.paddingQuadSides,
	})
	if _descriptor_18 then
		ButtonMountValidation.paddingQuadSides = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(ButtonMountValidation, "paddingQuadSides", {
		value = ButtonMountValidation.paddingQuadSides,
	})
	if _descriptor_19 then
		ButtonMountValidation.paddingQuadSides = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(ButtonMountValidation, "paddingQuadSides", {
		value = ButtonMountValidation.paddingQuadSides,
	})
	if _descriptor_20 then
		ButtonMountValidation.paddingQuadSides = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Without padding every side uses the theme spacing at the default spacing key")
	local _descriptor_21 = Test(ButtonMountValidation, "defaultPaddingFromTheme", {
		value = ButtonMountValidation.defaultPaddingFromTheme,
	})
	if _descriptor_21 then
		ButtonMountValidation.defaultPaddingFromTheme = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(ButtonMountValidation, "defaultPaddingFromTheme", {
		value = ButtonMountValidation.defaultPaddingFromTheme,
	})
	if _descriptor_22 then
		ButtonMountValidation.defaultPaddingFromTheme = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(ButtonMountValidation, "defaultPaddingFromTheme", {
		value = ButtonMountValidation.defaultPaddingFromTheme,
	})
	if _descriptor_23 then
		ButtonMountValidation.defaultPaddingFromTheme = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("spacing None does not zero an explicit single-value padding, which applies to all four sides")
	local _descriptor_24 = Test(ButtonMountValidation, "paddingOverridesNone", {
		value = ButtonMountValidation.paddingOverridesNone,
	})
	if _descriptor_24 then
		ButtonMountValidation.paddingOverridesNone = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(ButtonMountValidation, "paddingOverridesNone", {
		value = ButtonMountValidation.paddingOverridesNone,
	})
	if _descriptor_25 then
		ButtonMountValidation.paddingOverridesNone = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(ButtonMountValidation, "paddingOverridesNone", {
		value = ButtonMountValidation.paddingOverridesNone,
	})
	if _descriptor_26 then
		ButtonMountValidation.paddingOverridesNone = _descriptor_26.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("With padding set the icon keeps LayoutOrder 1 and the label LayoutOrder 2, laid out left to right")
	local _descriptor_27 = Test(ButtonMountValidation, "paddingKeepsOrder", {
		value = ButtonMountValidation.paddingKeepsOrder,
	})
	if _descriptor_27 then
		ButtonMountValidation.paddingKeepsOrder = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(ButtonMountValidation, "paddingKeepsOrder", {
		value = ButtonMountValidation.paddingKeepsOrder,
	})
	if _descriptor_28 then
		ButtonMountValidation.paddingKeepsOrder = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(ButtonMountValidation, "paddingKeepsOrder", {
		value = ButtonMountValidation.paddingKeepsOrder,
	})
	if _descriptor_29 then
		ButtonMountValidation.paddingKeepsOrder = _descriptor_29.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_21 = DisplayName("Without the modal prop the root ImageButton leaves Modal false")
	local _descriptor_30 = Test(ButtonMountValidation, "modalDefaultsOff", {
		value = ButtonMountValidation.modalDefaultsOff,
	})
	if _descriptor_30 then
		ButtonMountValidation.modalDefaultsOff = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_21(ButtonMountValidation, "modalDefaultsOff", {
		value = ButtonMountValidation.modalDefaultsOff,
	})
	if _descriptor_31 then
		ButtonMountValidation.modalDefaultsOff = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_20(ButtonMountValidation, "modalDefaultsOff", {
		value = ButtonMountValidation.modalDefaultsOff,
	})
	if _descriptor_32 then
		ButtonMountValidation.modalDefaultsOff = _descriptor_32.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("modal={true} is forwarded to the root ImageButton's native Modal property")
	local _descriptor_33 = Test(ButtonMountValidation, "modalForwarded", {
		value = ButtonMountValidation.modalForwarded,
	})
	if _descriptor_33 then
		ButtonMountValidation.modalForwarded = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_23(ButtonMountValidation, "modalForwarded", {
		value = ButtonMountValidation.modalForwarded,
	})
	if _descriptor_34 then
		ButtonMountValidation.modalForwarded = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_22(ButtonMountValidation, "modalForwarded", {
		value = ButtonMountValidation.modalForwarded,
	})
	if _descriptor_35 then
		ButtonMountValidation.modalForwarded = _descriptor_35.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = Each({ { "sm" }, { "md" }, { "lg" } })
	local _decorator_26 = DisplayName("A theme button cornerRadius token renders the root UICorner at that token's pixel radius")
	local _descriptor_36 = Test(ButtonMountValidation, "themeRadiusToken", {
		value = ButtonMountValidation.themeRadiusToken,
	})
	if _descriptor_36 then
		ButtonMountValidation.themeRadiusToken = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_26(ButtonMountValidation, "themeRadiusToken", {
		value = ButtonMountValidation.themeRadiusToken,
	})
	if _descriptor_37 then
		ButtonMountValidation.themeRadiusToken = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_25(ButtonMountValidation, "themeRadiusToken", {
		value = ButtonMountValidation.themeRadiusToken,
	})
	if _descriptor_38 then
		ButtonMountValidation.themeRadiusToken = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_24(ButtonMountValidation, "themeRadiusToken", {
		value = ButtonMountValidation.themeRadiusToken,
	})
	if _descriptor_39 then
		ButtonMountValidation.themeRadiusToken = _descriptor_39.value
	end
	ButtonMountValidation = Tag("Studio")(ButtonMountValidation) or ButtonMountValidation
end
return ButtonMountValidation
