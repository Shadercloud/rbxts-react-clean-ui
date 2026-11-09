-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
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
local Input = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Input").Input
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local FIELD_FILL = Color3.fromRGB(41, 88, 150)
local BASE_BORDER = Color3.fromRGB(61, 39, 18)
local HOVER_BORDER = Color3.fromRGB(120, 200, 80)
local FOCUS_BORDER = Color3.fromRGB(242, 166, 90)
local DISABLED_BORDER = Color3.fromRGB(128, 128, 128)
local SHADOW_COLOR = Color3.fromRGB(10, 20, 30)
local LIP_COLOR = Color3.fromRGB(168, 122, 69)
local INK = Color3.fromRGB(0, 0, 0)
local STATE_THEME = extendTheme(DefaultTheme, {
	components = {
		input = {
			borderColor = BASE_BORDER,
			borderThickness = 1,
			backgroundColor = FIELD_FILL,
			backgroundTransparency = 0.5,
			states = {
				hover = {
					borderColor = HOVER_BORDER,
					backgroundTransparency = 0.75,
				},
				focus = {
					borderColor = FOCUS_BORDER,
					borderThickness = 3,
				},
				disabled = {
					borderColor = DISABLED_BORDER,
					backgroundTransparency = 0.25,
				},
			},
		},
	},
})
local function themedInput(theme, disabled)
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, React.createElement(Input, {
		value = "",
		disabled = disabled,
	}))
end
local function inputTheme(overrides, boxShadow)
	return extendTheme(DefaultTheme, {
		components = {
			input = overrides,
			boxShadow = boxShadow,
		},
	})
end
local function waitForInput(host)
	return waitForGuiObject(host, "Input")
end
local function inputStroke(root)
	local stroke = root:FindFirstChild("Stroke")
	Assert:notUndefined(stroke, "Expected a Stroke UIStroke directly under the Input root")
	return stroke
end
local function assertFieldLook(root, borderColor, thickness, transparency, label)
	local stroke = inputStroke(root)
	Assert:equal(stroke.Color, borderColor, `{label}: border colour`)
	Assert:equal(stroke.Thickness, thickness, `{label}: border thickness`)
	Assert:equal(root.BackgroundTransparency, transparency, `{label}: background transparency`)
end
local function focusTextBox(mounted, root)
	fireHostEvent(mounted, findDescendant(root, "TextBox"), "Focused")
end
local function blurTextBox(mounted, root)
	fireHostEvent(mounted, findDescendant(root, "TextBox"), "FocusLost", false, nil)
end
local function waitForMeasuredBand(root, size)
	return waitForGuiObject(root, "InnerShadow", function(band)
		if not band.Visible or band.AbsoluteSize.Y <= 0 then
			return false
		end
		local fade = band:FindFirstChild("Fade")
		local _keypoints = fade
		if _keypoints ~= nil then
			_keypoints = _keypoints.Transparency.Keypoints
		end
		local keypoints = _keypoints
		return keypoints ~= nil and #keypoints == 3 and math.abs(keypoints[2].Time - size / band.AbsoluteSize.Y) < 0.002
	end, "Timed out waiting for the InnerShadow band to measure its height and fade over its size")
end
local function zeroShadow(form)
	return if form == "string" then "0px 0px 0px 0px" else {
		shadow = "0px 0px 0px 0px",
		color = SHADOW_COLOR,
		transparency = 0,
	}
end
local InputMountValidation
do
	InputMountValidation = setmetatable({}, {
		__tostring = function()
			return "InputMountValidation"
		end,
	})
	InputMountValidation.__index = InputMountValidation
	function InputMountValidation.new(...)
		local self = setmetatable({}, InputMountValidation)
		return self:constructor(...) or self
	end
	function InputMountValidation:constructor()
	end
	function InputMountValidation:rejectsInvalidChar()
		local host = Instance.new("Folder")
		local latestOnChangeValue = ""
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Input, {
			value = "",
			validation = "Number",
			onChange = function(value)
				latestOnChangeValue = value
			end,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		for _, candidate in { "1", "12", "123", "123A" } do
			textBox.Text = candidate
			task.wait()
		end
		Assert:equal(textBox.Text, "123")
		Assert:equal(latestOnChangeValue, "123")
		root:unmount()
		host:Destroy()
	end
	function InputMountValidation:defaultTransparent()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
		}), function(mounted)
			local root = waitForGuiObject(mounted.host, "Input")
			Assert:equal(root.BackgroundTransparency, 1)
		end)
	end
	function InputMountValidation:themedBackground()
		local theme = extendTheme(DefaultTheme, {
			components = {
				input = {
					backgroundColor = FIELD_FILL,
					backgroundTransparency = 0.25,
				},
			},
		})
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Input, {
			value = "",
		})), function(mounted)
			local root = waitForGuiObject(mounted.host, "Input")
			Assert:equal(root.BackgroundColor3, FIELD_FILL)
			Assert:equal(root.BackgroundTransparency, 0.25)
		end)
	end
	function InputMountValidation:unsetTreeUnchanged()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
		}), function(mounted)
			local root = waitForInput(mounted.host)
			local textBox = findDescendant(root, "TextBox")
			Assert:undefined(root:FindFirstChild("Content"))
			Assert:undefined(root:FindFirstChild("InnerShadow", true))
			Assert:undefined(root:FindFirstChildWhichIsA("UIShadow", true))
			local _result = textBox.Parent
			if _result ~= nil then
				_result = _result.Name
			end
			Assert:equal(_result, "FlexItem")
			local _result_1 = textBox.Parent
			if _result_1 ~= nil then
				_result_1 = _result_1.Parent
			end
			Assert:equal(_result_1, root)
			assertFieldLook(root, DefaultTheme.components.input.borderColor, DefaultTheme.components.input.borderThickness, 1, "unset theme")
		end)
	end
	function InputMountValidation:stringShadow()
		local theme = inputTheme({
			boxShadow = "0px 2px 4px 0px",
		}, {
			color = SHADOW_COLOR,
			transparency = 0.5,
		})
		withMounted(400, 200, themedInput(theme), function(mounted)
			local root = waitForInput(mounted.host)
			local shadow = root:FindFirstChild("BoxShadow")
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Input root")
			Assert:equal(shadow.Color, SHADOW_COLOR)
			Assert:equal(shadow.Transparency, 0.5)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 2))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 4))
		end)
	end
	function InputMountValidation:tableShadow()
		local theme = inputTheme({
			boxShadow = {
				shadow = "0px 1px 0px 0px",
				color = LIP_COLOR,
				transparency = 0,
			},
		}, {
			color = SHADOW_COLOR,
			transparency = 0.5,
		})
		withMounted(400, 200, themedInput(theme), function(mounted)
			local root = waitForInput(mounted.host)
			local shadow = root:FindFirstChild("BoxShadow")
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Input root")
			Assert:equal(shadow.Color, LIP_COLOR)
			Assert:equal(shadow.Transparency, 0)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 1))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 0))
		end)
	end
	function InputMountValidation:zeroShadowNothing(form)
		withMounted(400, 200, themedInput(inputTheme({
			boxShadow = zeroShadow(form),
		})), function(mounted)
			local root = waitForInput(mounted.host)
			Assert:undefined(root:FindFirstChildWhichIsA("UIShadow", true))
		end)
	end
	function InputMountValidation:innerShadowBand()
		local theme = inputTheme({
			borderThickness = 2,
			cornerRadius = 8,
			innerShadow = {
				color = INK,
				transparency = 0.5,
				size = 8,
			},
		})
		withMounted(400, 200, themedInput(theme), function(mounted)
			local root = waitForInput(mounted.host)
			local content = root:FindFirstChild("Content")
			Assert:notUndefined(content, "Expected a Content frame directly under the Input root")
			Assert:equal(content.ZIndex, 2)
			Assert:equal(content.BackgroundTransparency, 1)
			Assert["true"](Assert, findDescendant(root, "TextBox"):IsDescendantOf(content))
			local band = waitForMeasuredBand(root, 8)
			Assert:equal(band.Parent, root)
			Assert["true"](Assert, band.ZIndex < content.ZIndex, `Expected the band ZIndex ({band.ZIndex}) under Content's ({content.ZIndex})`)
			Assert:equal(band.BackgroundColor3, INK)
			Assert:equal(band.BackgroundTransparency, 0)
			Assert:equal(band.Position, UDim2.fromOffset(2, 2))
			Assert:equal(band.Size, UDim2.new(1, -4, 1, -4))
			Assert:equal((band:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 6))
			local fade = band:FindFirstChild("Fade")
			local keypoints = fade.Transparency.Keypoints
			Assert:equal(fade.Rotation, 90)
			Assert:equal(keypoints[1].Time, 0)
			Assert:equal(keypoints[1].Value, 0.5)
			Assert:approximately(keypoints[2].Time, 8 / band.AbsoluteSize.Y, 0.002)
			Assert:equal(keypoints[2].Value, 1)
			Assert:equal(keypoints[3].Value, 1)
		end)
	end
	function InputMountValidation:bandFollowsBorder()
		local theme = inputTheme({
			borderThickness = 2,
			cornerRadius = 8,
			innerShadow = {
				color = INK,
				transparency = 0.5,
				size = 8,
			},
			states = {
				focus = {
					borderThickness = 4,
				},
			},
		})
		withMounted(400, 200, themedInput(theme), function(mounted)
			local root = waitForInput(mounted.host)
			local band = waitForMeasuredBand(root, 8)
			Assert:equal(band.Position, UDim2.fromOffset(2, 2))
			focusTextBox(mounted, root)
			Assert:equal(band.Position, UDim2.fromOffset(4, 4))
			Assert:equal(band.Size, UDim2.new(1, -8, 1, -8))
			Assert:equal((band:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 4))
			Assert:equal(inputStroke(root).Thickness, 4)
		end)
	end
	function InputMountValidation:hoverState()
		withMounted(400, 200, themedInput(STATE_THEME), function(mounted)
			local root = waitForInput(mounted.host)
			assertFieldLook(root, BASE_BORDER, 1, 0.5, "before hover")
			fireHostEvent(mounted, root, "MouseEnter", 0, 0)
			assertFieldLook(root, HOVER_BORDER, 1, 0.75, "hovered")
			Assert:equal(root.BackgroundColor3, FIELD_FILL)
			fireHostEvent(mounted, root, "MouseLeave", 0, 0)
			assertFieldLook(root, BASE_BORDER, 1, 0.5, "after hover")
		end)
	end
	function InputMountValidation:focusState()
		withMounted(400, 200, themedInput(STATE_THEME), function(mounted)
			local root = waitForInput(mounted.host)
			focusTextBox(mounted, root)
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "focused")
			blurTextBox(mounted, root)
			assertFieldLook(root, BASE_BORDER, 1, 0.5, "blurred")
		end)
	end
	function InputMountValidation:disabledState()
		withMounted(400, 200, themedInput(STATE_THEME, true), function(mounted)
			local root = waitForInput(mounted.host)
			assertFieldLook(root, DISABLED_BORDER, 1, 0.25, "disabled")
		end)
	end
	function InputMountValidation:statePriority()
		withMounted(400, 200, themedInput(STATE_THEME), function(mounted)
			local root = waitForInput(mounted.host)
			fireHostEvent(mounted, root, "MouseEnter", 0, 0)
			focusTextBox(mounted, root)
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "hovered and focused")
			mounted.update(themedInput(STATE_THEME, true))
			assertFieldLook(root, DISABLED_BORDER, 1, 0.25, "disabled while hovered and focused")
			mounted.update(themedInput(STATE_THEME, false))
			assertFieldLook(root, FOCUS_BORDER, 3, 0.5, "re-enabled while hovered and focused")
			blurTextBox(mounted, root)
			assertFieldLook(root, HOVER_BORDER, 1, 0.75, "hovered only")
		end)
	end
	function InputMountValidation:disabledNotEditable()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
			disabled = true,
		}), function(mounted)
			local textBox = findDescendant(waitForInput(mounted.host), "TextBox")
			Assert["false"](Assert, textBox.TextEditable)
			Assert["false"](Assert, textBox.Interactable)
		end)
	end
	function InputMountValidation:enabledPassesEditable()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
			TextEditable = false,
		}), function(mounted)
			local textBox = findDescendant(waitForInput(mounted.host), "TextBox")
			Assert["false"](Assert, textBox.TextEditable)
			Assert["true"](Assert, textBox.Interactable)
			mounted.update(React.createElement(Input, {
				value = "",
			}))
			Assert["true"](Assert, textBox.TextEditable)
		end)
	end
	function InputMountValidation:disabledReleasesFocus()
		withMounted(400, 200, React.createElement(Input, {
			value = "",
		}), function(mounted)
			local textBox = findDescendant(waitForInput(mounted.host), "TextBox")
			textBox:CaptureFocus()
			waitForLayout(function()
				return if textBox:IsFocused() then true else nil
			end, "Timed out waiting for CaptureFocus to focus the TextBox")
			mounted.update(React.createElement(Input, {
				value = "",
				disabled = true,
			}))
			waitForLayout(function()
				return if not textBox:IsFocused() then true else nil
			end, "Expected disabling the Input to release the TextBox's focus")
		end)
	end
	function InputMountValidation:disabledIgnoresLabel()
		local labelActivated = Instance.new("BindableEvent")
		local fieldsetInput = function(disabled)
			return React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = false,
					labelActivated = labelActivated,
				},
			}, React.createElement(Input, {
				value = "",
				disabled = disabled,
			}))
		end
		TS.try(function()
			withMounted(400, 200, fieldsetInput(true), function(mounted)
				local textBox = findDescendant(waitForInput(mounted.host), "TextBox")
				labelActivated:Fire()
				settleFrames(5)
				Assert["false"](Assert, textBox:IsFocused(), "Expected a disabled Input to ignore labelActivated")
				mounted.update(fieldsetInput(false))
				labelActivated:Fire()
				waitForLayout(function()
					return if textBox:IsFocused() then true else nil
				end, "Timed out waiting for labelActivated to focus the re-enabled Input")
				textBox:ReleaseFocus()
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_1 = DisplayName("With Number validation, typing a letter reverts the TextBox and onChange to the last numeric text")
	local _descriptor = Test(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor then
		InputMountValidation.rejectsInvalidChar = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor_1 then
		InputMountValidation.rejectsInvalidChar = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(InputMountValidation, "rejectsInvalidChar", {
		value = InputMountValidation.rejectsInvalidChar,
	})
	if _descriptor_2 then
		InputMountValidation.rejectsInvalidChar = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Without theme background keys the root Input ImageLabel stays fully transparent")
	local _descriptor_3 = Test(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_3 then
		InputMountValidation.defaultTransparent = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_4 then
		InputMountValidation.defaultTransparent = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(InputMountValidation, "defaultTransparent", {
		value = InputMountValidation.defaultTransparent,
	})
	if _descriptor_5 then
		InputMountValidation.defaultTransparent = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("theme.components.input backgroundColor and backgroundTransparency fill the root Input ImageLabel")
	local _descriptor_6 = Test(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_6 then
		InputMountValidation.themedBackground = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_7 then
		InputMountValidation.themedBackground = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(InputMountValidation, "themedBackground", {
		value = InputMountValidation.themedBackground,
	})
	if _descriptor_8 then
		InputMountValidation.themedBackground = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Without boxShadow, innerShadow or states the TextBox's FlexItem sits directly under the root with no Content wrapper, shadow or band")
	local _descriptor_9 = Test(InputMountValidation, "unsetTreeUnchanged", {
		value = InputMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_9 then
		InputMountValidation.unsetTreeUnchanged = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(InputMountValidation, "unsetTreeUnchanged", {
		value = InputMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_10 then
		InputMountValidation.unsetTreeUnchanged = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(InputMountValidation, "unsetTreeUnchanged", {
		value = InputMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_11 then
		InputMountValidation.unsetTreeUnchanged = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("A bare CssShadow string draws a root UIShadow with that offset and blur in the global boxShadow colour and transparency")
	local _descriptor_12 = Test(InputMountValidation, "stringShadow", {
		value = InputMountValidation.stringShadow,
	})
	if _descriptor_12 then
		InputMountValidation.stringShadow = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(InputMountValidation, "stringShadow", {
		value = InputMountValidation.stringShadow,
	})
	if _descriptor_13 then
		InputMountValidation.stringShadow = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(InputMountValidation, "stringShadow", {
		value = InputMountValidation.stringShadow,
	})
	if _descriptor_14 then
		InputMountValidation.stringShadow = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A { shadow, color, transparency } boxShadow uses its own colour and transparency instead of the global boxShadow ones")
	local _descriptor_15 = Test(InputMountValidation, "tableShadow", {
		value = InputMountValidation.tableShadow,
	})
	if _descriptor_15 then
		InputMountValidation.tableShadow = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(InputMountValidation, "tableShadow", {
		value = InputMountValidation.tableShadow,
	})
	if _descriptor_16 then
		InputMountValidation.tableShadow = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(InputMountValidation, "tableShadow", {
		value = InputMountValidation.tableShadow,
	})
	if _descriptor_17 then
		InputMountValidation.tableShadow = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = Each({ { "string" }, { "table" } })
	local _decorator_14 = DisplayName("An all-zero boxShadow, as a string or a table, draws no UIShadow at all")
	local _descriptor_18 = Test(InputMountValidation, "zeroShadowNothing", {
		value = InputMountValidation.zeroShadowNothing,
	})
	if _descriptor_18 then
		InputMountValidation.zeroShadowNothing = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_14(InputMountValidation, "zeroShadowNothing", {
		value = InputMountValidation.zeroShadowNothing,
	})
	if _descriptor_19 then
		InputMountValidation.zeroShadowNothing = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_13(InputMountValidation, "zeroShadowNothing", {
		value = InputMountValidation.zeroShadowNothing,
	})
	if _descriptor_20 then
		InputMountValidation.zeroShadowNothing = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_12(InputMountValidation, "zeroShadowNothing", {
		value = InputMountValidation.zeroShadowNothing,
	})
	if _descriptor_21 then
		InputMountValidation.zeroShadowNothing = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("innerShadow adds a coloured InnerShadow band inset by the border and a ZIndex 2 Content wrapper holding the text above it")
	local _descriptor_22 = Test(InputMountValidation, "innerShadowBand", {
		value = InputMountValidation.innerShadowBand,
	})
	if _descriptor_22 then
		InputMountValidation.innerShadowBand = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(InputMountValidation, "innerShadowBand", {
		value = InputMountValidation.innerShadowBand,
	})
	if _descriptor_23 then
		InputMountValidation.innerShadowBand = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(InputMountValidation, "innerShadowBand", {
		value = InputMountValidation.innerShadowBand,
	})
	if _descriptor_24 then
		InputMountValidation.innerShadowBand = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("The InnerShadow inset and corner radius follow the focus state's borderThickness while the TextBox is focused")
	local _descriptor_25 = Test(InputMountValidation, "bandFollowsBorder", {
		value = InputMountValidation.bandFollowsBorder,
	})
	if _descriptor_25 then
		InputMountValidation.bandFollowsBorder = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(InputMountValidation, "bandFollowsBorder", {
		value = InputMountValidation.bandFollowsBorder,
	})
	if _descriptor_26 then
		InputMountValidation.bandFollowsBorder = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(InputMountValidation, "bandFollowsBorder", {
		value = InputMountValidation.bandFollowsBorder,
	})
	if _descriptor_27 then
		InputMountValidation.bandFollowsBorder = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName("MouseEnter applies states.hover's border colour and transparency, keeps the base thickness, and MouseLeave restores the base")
	local _descriptor_28 = Test(InputMountValidation, "hoverState", {
		value = InputMountValidation.hoverState,
	})
	if _descriptor_28 then
		InputMountValidation.hoverState = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_20(InputMountValidation, "hoverState", {
		value = InputMountValidation.hoverState,
	})
	if _descriptor_29 then
		InputMountValidation.hoverState = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_19(InputMountValidation, "hoverState", {
		value = InputMountValidation.hoverState,
	})
	if _descriptor_30 then
		InputMountValidation.hoverState = _descriptor_30.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName("Focusing the TextBox applies states.focus's border and falls back to the base transparency, and FocusLost restores the base")
	local _descriptor_31 = Test(InputMountValidation, "focusState", {
		value = InputMountValidation.focusState,
	})
	if _descriptor_31 then
		InputMountValidation.focusState = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_22(InputMountValidation, "focusState", {
		value = InputMountValidation.focusState,
	})
	if _descriptor_32 then
		InputMountValidation.focusState = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_21(InputMountValidation, "focusState", {
		value = InputMountValidation.focusState,
	})
	if _descriptor_33 then
		InputMountValidation.focusState = _descriptor_33.value
	end
	local _decorator_23 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_24 = DisplayName("The disabled prop applies states.disabled's border colour and transparency over the base thickness")
	local _descriptor_34 = Test(InputMountValidation, "disabledState", {
		value = InputMountValidation.disabledState,
	})
	if _descriptor_34 then
		InputMountValidation.disabledState = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_24(InputMountValidation, "disabledState", {
		value = InputMountValidation.disabledState,
	})
	if _descriptor_35 then
		InputMountValidation.disabledState = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_23(InputMountValidation, "disabledState", {
		value = InputMountValidation.disabledState,
	})
	if _descriptor_36 then
		InputMountValidation.disabledState = _descriptor_36.value
	end
	local _decorator_25 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_26 = DisplayName("Hovered and focused shows only focus with no hover keys cascading, and disabled beats both until it is cleared")
	local _descriptor_37 = Test(InputMountValidation, "statePriority", {
		value = InputMountValidation.statePriority,
	})
	if _descriptor_37 then
		InputMountValidation.statePriority = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_26(InputMountValidation, "statePriority", {
		value = InputMountValidation.statePriority,
	})
	if _descriptor_38 then
		InputMountValidation.statePriority = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_25(InputMountValidation, "statePriority", {
		value = InputMountValidation.statePriority,
	})
	if _descriptor_39 then
		InputMountValidation.statePriority = _descriptor_39.value
	end
	local _decorator_27 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_28 = DisplayName("A disabled Input's TextBox is neither editable nor interactable")
	local _descriptor_40 = Test(InputMountValidation, "disabledNotEditable", {
		value = InputMountValidation.disabledNotEditable,
	})
	if _descriptor_40 then
		InputMountValidation.disabledNotEditable = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_28(InputMountValidation, "disabledNotEditable", {
		value = InputMountValidation.disabledNotEditable,
	})
	if _descriptor_41 then
		InputMountValidation.disabledNotEditable = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_27(InputMountValidation, "disabledNotEditable", {
		value = InputMountValidation.disabledNotEditable,
	})
	if _descriptor_42 then
		InputMountValidation.disabledNotEditable = _descriptor_42.value
	end
	local _decorator_29 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_30 = DisplayName("Without disabled the TextBox stays interactable and an explicit TextEditable={false} still passes through")
	local _descriptor_43 = Test(InputMountValidation, "enabledPassesEditable", {
		value = InputMountValidation.enabledPassesEditable,
	})
	if _descriptor_43 then
		InputMountValidation.enabledPassesEditable = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_30(InputMountValidation, "enabledPassesEditable", {
		value = InputMountValidation.enabledPassesEditable,
	})
	if _descriptor_44 then
		InputMountValidation.enabledPassesEditable = _descriptor_44.value
	end
	local _descriptor_45 = _decorator_29(InputMountValidation, "enabledPassesEditable", {
		value = InputMountValidation.enabledPassesEditable,
	})
	if _descriptor_45 then
		InputMountValidation.enabledPassesEditable = _descriptor_45.value
	end
	local _decorator_31 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_32 = DisplayName("Setting disabled on a focused Input releases the TextBox's focus")
	local _descriptor_46 = Test(InputMountValidation, "disabledReleasesFocus", {
		value = InputMountValidation.disabledReleasesFocus,
	})
	if _descriptor_46 then
		InputMountValidation.disabledReleasesFocus = _descriptor_46.value
	end
	local _descriptor_47 = _decorator_32(InputMountValidation, "disabledReleasesFocus", {
		value = InputMountValidation.disabledReleasesFocus,
	})
	if _descriptor_47 then
		InputMountValidation.disabledReleasesFocus = _descriptor_47.value
	end
	local _descriptor_48 = _decorator_31(InputMountValidation, "disabledReleasesFocus", {
		value = InputMountValidation.disabledReleasesFocus,
	})
	if _descriptor_48 then
		InputMountValidation.disabledReleasesFocus = _descriptor_48.value
	end
	local _decorator_33 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_34 = DisplayName("Fieldset labelActivated does not focus a disabled Input, but does once disabled is cleared")
	local _descriptor_49 = Test(InputMountValidation, "disabledIgnoresLabel", {
		value = InputMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_49 then
		InputMountValidation.disabledIgnoresLabel = _descriptor_49.value
	end
	local _descriptor_50 = _decorator_34(InputMountValidation, "disabledIgnoresLabel", {
		value = InputMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_50 then
		InputMountValidation.disabledIgnoresLabel = _descriptor_50.value
	end
	local _descriptor_51 = _decorator_33(InputMountValidation, "disabledIgnoresLabel", {
		value = InputMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_51 then
		InputMountValidation.disabledIgnoresLabel = _descriptor_51.value
	end
	InputMountValidation = Tag("Studio")(InputMountValidation) or InputMountValidation
end
return InputMountValidation
