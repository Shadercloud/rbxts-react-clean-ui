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
local Select = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Select").Select
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
local SpacingHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SpacingHelper
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _fiber = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber")
local activateButton = _fiber.activateButton
local fireHostEvent = _fiber.fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertCenteredIn = _layout.assertCenteredIn
local assertNonZeroSize = _layout.assertNonZeroSize
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local waitForRemoval = _layout.waitForRemoval
local withMounted = _layout.withMounted
local OPTIONS = { "Alpha", "Beta", "Gamma" }
local function selectWithOptions(props)
	if props == nil then
		props = {}
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#OPTIONS)
	local _callback = function(text)
		return React.createElement(Select.Option, {
			key = text,
			text = text,
		})
	end
	for _k, _v in OPTIONS do
		_newValue[_k] = _callback(_v, _k - 1, OPTIONS)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(Select, {
		selected = props.selected,
	}, _newValue)
end
local FIELD_FILL = Color3.fromRGB(41, 88, 150)
local FIELD_TEXT = Color3.fromRGB(255, 247, 207)
local CARET_COLOR = Color3.fromRGB(200, 60, 90)
local BASE_BORDER = Color3.fromRGB(61, 39, 18)
local HOVER_BORDER = Color3.fromRGB(120, 200, 80)
local FOCUS_BORDER = Color3.fromRGB(242, 166, 90)
local DISABLED_BORDER = Color3.fromRGB(128, 128, 128)
local SHADOW_COLOR = Color3.fromRGB(10, 20, 30)
local LIP_COLOR = Color3.fromRGB(168, 122, 69)
local INK = Color3.fromRGB(0, 0, 0)
local CAP_FILL = Color3.fromRGB(23, 58, 102)
local CAP_BORDER = Color3.fromRGB(90, 50, 20)
local DROP_BORDER = Color3.fromRGB(30, 140, 160)
local STATE_THEME = extendTheme(DefaultTheme, {
	components = {
		select = {
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
local function themedSelect(theme)
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, selectWithOptions())
end
local function waitForSelect(host)
	return waitForGuiObject(host, "Select")
end
local function findSelectedText(selectRoot)
	return findDescendant(selectRoot, "SelectedText")
end
local function selectTheme(overrides, boxShadow)
	return extendTheme(DefaultTheme, {
		components = {
			select = overrides,
			boxShadow = boxShadow,
		},
	})
end
local function overlaySelect(theme, props)
	if props == nil then
		props = {}
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#OPTIONS)
	local _callback = function(text)
		return React.createElement(Select.Option, {
			key = text,
			text = text,
		})
	end
	for _k, _v in OPTIONS do
		_newValue[_k] = _callback(_v, _k - 1, OPTIONS)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(ThemeProvider, {
		theme = theme,
	}, React.createElement(OverlayProvider, nil, React.createElement(Select, {
		disabled = props.disabled,
		BackgroundTransparency = props.BackgroundTransparency,
	}, _newValue)))
end
local function selectButton(selectRoot)
	return waitForGuiObject(selectRoot, "SelectButton")
end
local function fieldStroke(selectRoot)
	local stroke = selectButton(selectRoot):FindFirstChild("Stroke")
	Assert:notUndefined(stroke, "Expected a Stroke UIStroke directly under SelectButton")
	return stroke
end
local function assertFieldLook(selectRoot, borderColor, thickness, transparency, label)
	local stroke = fieldStroke(selectRoot)
	Assert:equal(stroke.Color, borderColor, `{label}: border colour`)
	Assert:equal(stroke.Thickness, thickness, `{label}: border thickness`)
	Assert:equal(selectRoot.BackgroundTransparency, transparency, `{label}: background transparency`)
end
local function openDropdown(mounted, selectRoot)
	waitForGuiObject(mounted.host, "OverlayProvider")
	activateButton(mounted, selectButton(selectRoot))
	return waitForGuiObject(mounted.host, "SelectDropdown")
end
local function zeroShadow(form)
	return if form == "string" then "0px 0px 0px 0px" else {
		shadow = "0px 0px 0px 0px",
		color = SHADOW_COLOR,
		transparency = 0,
	}
end
local function fieldPaddingY(theme)
	local padding = SpacingHelper:GetResolvedPadding(theme, {})
	return padding.top + padding.bottom
end
local function capInset(theme)
	return fieldPaddingY(theme) - 2 * theme.components.select.borderThickness
end
local function caretColorTheme(source)
	if source == "caret" then
		return selectTheme({
			iconColor = FIELD_TEXT,
			caret = {
				size = 24,
				iconColor = CARET_COLOR,
			},
		})
	end
	if source == "select" then
		return selectTheme({
			iconColor = FIELD_TEXT,
			caret = {
				size = 24,
			},
		})
	end
	return selectTheme({
		caret = {
			size = 24,
		},
	})
end
local function expectedCaretColor(source)
	if source == "caret" then
		return CARET_COLOR
	end
	if source == "select" then
		return FIELD_TEXT
	end
	return DefaultTheme.colors.intents.primary.default.textColor
end
local SelectMountValidation
do
	SelectMountValidation = setmetatable({}, {
		__tostring = function()
			return "SelectMountValidation"
		end,
	})
	SelectMountValidation.__index = SelectMountValidation
	function SelectMountValidation.new(...)
		local self = setmetatable({}, SelectMountValidation)
		return self:constructor(...) or self
	end
	function SelectMountValidation:constructor()
	end
	function SelectMountValidation:mountsContained()
		withMounted(400, 200, selectWithOptions(), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			assertNonZeroSize(selectRoot, "closed selectRoot")
			Assert:equal(findSelectedText(selectRoot).Text, "Alpha")
			assertAllDescendantsContained(selectRoot, "closed selectRoot")
		end)
	end
	function SelectMountValidation:seedsFromSelected()
		withMounted(400, 200, selectWithOptions({
			selected = 2,
		}), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(findSelectedText(selectRoot).Text, "Gamma")
		end)
	end
	function SelectMountValidation:noOptionsFallback()
		withMounted(400, 200, React.createElement(Select), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(findSelectedText(selectRoot).Text, "No Options")
		end)
	end
	function SelectMountValidation:labelTogglesDropdown()
		local labelActivated = Instance.new("BindableEvent")
		TS.try(function()
			withMounted(400, 400, React.createElement(OverlayProvider, nil, React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = false,
					labelActivated = labelActivated,
				},
			}, selectWithOptions())), function(mounted)
				local selectRoot = waitForSelect(mounted.host)
				local control = waitForGuiObject(selectRoot, "SelectButton")
				waitForGuiObject(mounted.host, "OverlayProvider")
				Assert:undefined(mounted.host:FindFirstChild("SelectDropdown", true))
				labelActivated:Fire()
				local dropdown = waitForGuiObject(mounted.host, "SelectDropdown")
				local controlRect = rect(control)
				local dropdownRect = rect(dropdown)
				Assert["true"](Assert, math.abs(dropdownRect.top - controlRect.bottom) <= 1, `Expected the dropdown top ({dropdownRect.top}) to sit at the control's bottom edge ({controlRect.bottom})`)
				Assert["true"](Assert, math.abs(dropdownRect.width - controlRect.width) <= 1, `Expected the dropdown width ({dropdownRect.width}) to match the control width ({controlRect.width})`)
				waitForLayout(function()
					local _exp = dropdown:GetDescendants()
					-- ▼ ReadonlyArray.filter ▼
					local _newValue = {}
					local _callback = function(d)
						return d.Name == "Option" and d:IsA("GuiObject")
					end
					local _length = 0
					for _k, _v in _exp do
						if _callback(_v, _k - 1, _exp) == true then
							_length += 1
							_newValue[_length] = _v
						end
					end
					-- ▲ ReadonlyArray.filter ▲
					local options = _newValue
					local _condition = #options == #OPTIONS
					if _condition then
						-- ▼ ReadonlyArray.every ▼
						local _result = true
						local _callback_1 = function(o)
							return o.AbsoluteSize.Y > 0
						end
						for _k, _v in options do
							if not _callback_1(_v, _k - 1, options) then
								_result = false
								break
							end
						end
						-- ▲ ReadonlyArray.every ▲
						_condition = _result
					end
					return if _condition then true else nil
				end, `Timed out waiting for {#OPTIONS} laid-out options inside the dropdown`)
				assertAllDescendantsContained(dropdown, "open dropdown")
				labelActivated:Fire()
				waitForLayout(function()
					return if mounted.host:FindFirstChild("SelectDropdown", true) == nil then true else nil
				end, "Timed out waiting for the dropdown to close after a second labelActivated")
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	function SelectMountValidation:defaultTransparent()
		withMounted(400, 200, selectWithOptions(), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(selectRoot.BackgroundTransparency, 1)
			Assert:undefined(selectRoot:FindFirstChild("Corners"))
		end)
	end
	function SelectMountValidation:themedBackground()
		local theme = extendTheme(DefaultTheme, {
			components = {
				select = {
					backgroundColor = FIELD_FILL,
					backgroundTransparency = 0.5,
					cornerRadius = 6,
				},
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(selectRoot.BackgroundColor3, FIELD_FILL)
			Assert:equal(selectRoot.BackgroundTransparency, 0.5)
			local corners = selectRoot:FindFirstChild("Corners")
			Assert:notUndefined(corners, "Expected a Corners UICorner directly under the Select root")
			Assert:equal(corners.CornerRadius, UDim.new(0, 6))
		end)
	end
	function SelectMountValidation:instanceTransparencyWins()
		local theme = extendTheme(DefaultTheme, {
			components = {
				select = {
					backgroundColor = FIELD_FILL,
					backgroundTransparency = 0,
				},
			},
		})
		withMounted(400, 200, React.createElement(ThemeProvider, {
			theme = theme,
		}, React.createElement(Select, {
			BackgroundTransparency = 1,
		}, React.createElement(Select.Option, {
			text = "Alpha",
		}))), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(selectRoot.BackgroundTransparency, 1)
			Assert:notUndefined(selectRoot:FindFirstChild("Corners"))
		end)
	end
	function SelectMountValidation:themedTextAndCaret()
		local theme = extendTheme(DefaultTheme, {
			components = {
				select = {
					textColor = FIELD_TEXT,
					iconColor = CARET_COLOR,
				},
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:equal(findSelectedText(selectRoot).TextColor3, FIELD_TEXT)
			Assert:equal(findDescendant(selectRoot, "SelectCaret").ImageColor3, CARET_COLOR)
		end)
	end
	function SelectMountValidation:defaultTextAndCaret()
		withMounted(400, 200, selectWithOptions(), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local fallback = DefaultTheme.colors.intents.primary.default.textColor
			Assert:equal(findSelectedText(selectRoot).TextColor3, fallback)
			Assert:equal(findDescendant(selectRoot, "SelectCaret").ImageColor3, fallback)
		end)
	end
	function SelectMountValidation:unsetTreeUnchanged()
		withMounted(400, 400, overlaySelect(DefaultTheme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local button = selectButton(selectRoot)
			local caret = findDescendant(selectRoot, "SelectCaret")
			Assert:undefined(selectRoot:FindFirstChildWhichIsA("UIShadow", true))
			Assert:undefined(selectRoot:FindFirstChild("InnerShadow", true))
			Assert:undefined(selectRoot:FindFirstChild("SelectCaretCap", true))
			Assert:equal(caret.Parent, button)
			Assert:equal(button.ZIndex, 1)
			local dropdown = openDropdown(mounted, selectRoot)
			local stroke = dropdown:FindFirstChild("Stroke")
			Assert:undefined(dropdown:FindFirstChildWhichIsA("UIShadow", true))
			Assert:equal(stroke.Thickness, DefaultTheme.components.select.borderThickness)
			Assert:equal(stroke.Color, DefaultTheme.components.select.borderColor)
			Assert:equal((dropdown:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 8))
			Assert:approximately(rect(dropdown).top, rect(button).bottom, 1)
		end)
	end
	function SelectMountValidation:stringShadow()
		local theme = selectTheme({
			boxShadow = "0px 2px 4px 0px",
		}, {
			color = SHADOW_COLOR,
			transparency = 0.5,
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local shadow = waitForSelect(mounted.host):FindFirstChild("BoxShadow")
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Select root")
			Assert:equal(shadow.Color, SHADOW_COLOR)
			Assert:equal(shadow.Transparency, 0.5)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 2))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 4))
		end)
	end
	function SelectMountValidation:tableShadow()
		local theme = selectTheme({
			boxShadow = {
				shadow = "0px 1px 0px 0px",
				color = LIP_COLOR,
				transparency = 0,
			},
		}, {
			color = SHADOW_COLOR,
			transparency = 0.5,
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local shadow = waitForSelect(mounted.host):FindFirstChild("BoxShadow")
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under the Select root")
			Assert:equal(shadow.Color, LIP_COLOR)
			Assert:equal(shadow.Transparency, 0)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 1))
		end)
	end
	function SelectMountValidation:zeroShadowNothing(form)
		withMounted(400, 200, themedSelect(selectTheme({
			boxShadow = zeroShadow(form),
		})), function(mounted)
			Assert:undefined(waitForSelect(mounted.host):FindFirstChildWhichIsA("UIShadow", true))
		end)
	end
	function SelectMountValidation:innerShadowBand()
		local theme = selectTheme({
			borderThickness = 2,
			cornerRadius = 8,
			innerShadow = {
				color = INK,
				transparency = 0.5,
				size = 8,
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local button = selectButton(selectRoot)
			local band = waitForGuiObject(selectRoot, "InnerShadow", function(frame)
				return frame.Visible and frame.AbsoluteSize.Y > 0
			end)
			Assert:equal(band.Parent, selectRoot)
			Assert:equal(button.ZIndex, 2)
			Assert["true"](Assert, band.ZIndex < button.ZIndex, `Expected the band ZIndex ({band.ZIndex}) under SelectButton's ({button.ZIndex})`)
			Assert:equal(band.BackgroundColor3, INK)
			Assert:equal(band.Position, UDim2.fromOffset(2, 2))
			Assert:equal(band.Size, UDim2.new(1, -4, 1, -4))
			Assert:equal((band:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 6))
			local fade = band:FindFirstChild("Fade")
			Assert:equal(fade.Rotation, 90)
			Assert:equal(fade.Transparency.Keypoints[1].Value, 0.5)
			waitForLayout(function()
				local keypoints = fade.Transparency.Keypoints
				return if #keypoints == 3 and math.abs(keypoints[2].Time - 8 / band.AbsoluteSize.Y) < 0.002 then true else nil
			end, `Timed out waiting for the fade keypoint at 8 / {band.AbsoluteSize.Y}`)
		end)
	end
	function SelectMountValidation:hoverState()
		withMounted(400, 400, overlaySelect(STATE_THEME), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local button = selectButton(selectRoot)
			assertFieldLook(selectRoot, BASE_BORDER, 1, 0.5, "before hover")
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			assertFieldLook(selectRoot, HOVER_BORDER, 1, 0.75, "hovered")
			Assert:equal(selectRoot.BackgroundColor3, FIELD_FILL)
			fireHostEvent(mounted, button, "MouseLeave", 0, 0)
			assertFieldLook(selectRoot, BASE_BORDER, 1, 0.5, "after hover")
		end)
	end
	function SelectMountValidation:focusState()
		withMounted(400, 400, overlaySelect(STATE_THEME), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local button = selectButton(selectRoot)
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			openDropdown(mounted, selectRoot)
			assertFieldLook(selectRoot, FOCUS_BORDER, 3, 0.5, "open and hovered")
			activateButton(mounted, button)
			waitForRemoval(mounted.host, "SelectDropdown")
			assertFieldLook(selectRoot, HOVER_BORDER, 1, 0.75, "closed and hovered")
		end)
	end
	function SelectMountValidation:disabledState()
		withMounted(400, 400, overlaySelect(STATE_THEME, {
			disabled = true,
		}), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			fireHostEvent(mounted, selectButton(selectRoot), "MouseEnter", 0, 0)
			assertFieldLook(selectRoot, DISABLED_BORDER, 1, 0.25, "disabled and hovered")
			mounted.update(overlaySelect(STATE_THEME, {
				disabled = true,
				BackgroundTransparency = 1,
			}))
			Assert:equal(selectRoot.BackgroundTransparency, 1)
		end)
	end
	function SelectMountValidation:cornersFollowState()
		local theme = selectTheme({
			backgroundColor = FIELD_FILL,
			cornerRadius = 6,
			states = {
				disabled = {
					backgroundTransparency = 0.5,
				},
			},
		})
		withMounted(400, 400, overlaySelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			Assert:undefined(selectRoot:FindFirstChild("Corners"))
			mounted.update(overlaySelect(theme, {
				disabled = true,
			}))
			Assert:equal(selectRoot.BackgroundTransparency, 0.5)
			local _result = (selectRoot:FindFirstChild("Corners"))
			if _result ~= nil then
				_result = _result.CornerRadius
			end
			Assert:equal(_result, UDim.new(0, 6))
		end)
	end
	function SelectMountValidation:disabledCannotOpen()
		local labelActivated = Instance.new("BindableEvent")
		local fieldsetSelect = function(disabled)
			return React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = false,
					labelActivated = labelActivated,
				},
			}, overlaySelect(DefaultTheme, {
				disabled = disabled,
			}))
		end
		TS.try(function()
			withMounted(400, 400, fieldsetSelect(true), function(mounted)
				local selectRoot = waitForSelect(mounted.host)
				waitForGuiObject(mounted.host, "OverlayProvider")
				activateButton(mounted, selectButton(selectRoot))
				labelActivated:Fire()
				settleFrames(5)
				Assert:undefined(mounted.host:FindFirstChild("SelectDropdown", true), "Expected a disabled Select to stay closed")
				mounted.update(fieldsetSelect(false))
				labelActivated:Fire()
				waitForGuiObject(mounted.host, "SelectDropdown")
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	function SelectMountValidation:disabledClosesOpen()
		withMounted(400, 400, overlaySelect(STATE_THEME), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			openDropdown(mounted, selectRoot)
			mounted.update(overlaySelect(STATE_THEME, {
				disabled = true,
			}))
			waitForRemoval(mounted.host, "SelectDropdown")
			assertFieldLook(selectRoot, DISABLED_BORDER, 1, 0.25, "disabled after open")
		end)
	end
	function SelectMountValidation:caretCap()
		local theme = selectTheme({
			caret = {
				size = 30,
				backgroundColor = CAP_FILL,
				borderColor = CAP_BORDER,
				borderThickness = 2,
				cornerRadius = 6,
				iconColor = CARET_COLOR,
				margin = "0px -6px 0px 0px",
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local slot = waitForGuiObject(selectRoot, "SelectCaretCap")
			local cap = slot:FindFirstChild("Cap")
			local icon = waitForGuiObject(cap, "SelectCaret")
			local stroke = cap:FindFirstChild("Stroke")
			Assert:equal(slot.Size, UDim2.fromOffset(24, math.max(0, 30 - capInset(theme))))
			Assert:equal(cap.Size, UDim2.fromOffset(30, 30))
			Assert:equal(cap.Position, UDim2.new(0, 0, 0.5, 0))
			Assert:equal(cap.BackgroundColor3, CAP_FILL)
			Assert:equal(cap.BackgroundTransparency, 0)
			Assert:equal(stroke.Thickness, 2)
			Assert:equal(stroke.Color, CAP_BORDER)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner)
			Assert:equal((cap:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 6))
			Assert:equal(icon.Parent, cap)
			Assert:equal(icon.ImageColor3, CARET_COLOR)
			Assert:approximately(rect(cap).right, rect(slot).right + 6, 1)
			assertCenteredIn(icon, cap, "both", 1, "caret icon")
		end)
	end
	function SelectMountValidation:caretMarginQuad()
		local theme = selectTheme({
			caret = {
				size = 20,
				margin = "4px 2px 6px 8px",
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local slot = waitForGuiObject(waitForSelect(mounted.host), "SelectCaretCap")
			local cap = slot:FindFirstChild("Cap")
			Assert:equal(slot.Size, UDim2.fromOffset(30, math.max(0, 30 - capInset(theme))))
			Assert:equal(cap.Size, UDim2.fromOffset(20, 20))
			Assert:equal(cap.AnchorPoint, Vector2.new(0, 0.5))
			Assert:equal(cap.Position, UDim2.new(0, 8, 0.5, -1))
		end)
	end
	function SelectMountValidation:caretDefaults()
		local theme = selectTheme({
			caret = {},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local cap = waitForGuiObject(waitForSelect(mounted.host), "Cap")
			local slot = cap.Parent
			local _condition = DefaultTheme.iconSize[DefaultTheme.default.scale]
			if _condition == nil then
				_condition = 0
			end
			local size = _condition
			Assert:equal(slot.Name, "SelectCaretCap")
			Assert:equal(slot.Size, UDim2.fromOffset(size, math.max(0, size - capInset(theme))))
			Assert:equal(cap.Size, UDim2.fromOffset(size, size))
			Assert:equal(cap.BackgroundTransparency, 1)
			Assert:undefined(cap:FindFirstChild("Stroke"))
			Assert:undefined(cap:FindFirstChild("Corners"))
			Assert:undefined(cap:FindFirstChildWhichIsA("UIGradient"))
		end)
	end
	function SelectMountValidation:caretCapNoGrow()
		local theme = selectTheme({
			caret = {
				size = 30,
				backgroundColor = CAP_FILL,
				borderColor = CAP_BORDER,
				borderThickness = 2,
				cornerRadius = 6,
				margin = "0px -6px 0px 0px",
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local button = selectButton(selectRoot)
			local cap = waitForGuiObject(selectRoot, "Cap")
			local text = waitForGuiObject(selectRoot, "SelectedText")
			local expected = waitForLayout(function()
				local height = fieldPaddingY(theme) + text.AbsoluteSize.Y
				return if math.abs(selectRoot.AbsoluteSize.Y - height) <= 1 then height else nil
			end, `Timed out waiting for the capped Select ({selectRoot.AbsoluteSize.Y}px) to equal the text line ({text.AbsoluteSize.Y}px) plus {fieldPaddingY(theme)}px padding`)
			Assert:approximately(button.AbsoluteSize.Y, expected, 1)
			assertCenteredIn(text, button, "y", 1, "SelectedText")
			assertCenteredIn(cap, button, "y", 1, "caret Cap")
		end)
	end
	function SelectMountValidation:caretFill(kind, expected)
		local theme = if kind == "gradient" then selectTheme({
			caret = {
				backgroundGradient = {
					colors = { CAP_FILL, INK },
				},
			},
		}) else selectTheme({
			caret = {
				backgroundColor = CAP_FILL,
				backgroundTransparency = 0.5,
			},
		})
		withMounted(400, 200, themedSelect(theme), function(mounted)
			local cap = waitForGuiObject(waitForSelect(mounted.host), "Cap")
			Assert:equal(cap.BackgroundTransparency, expected)
			Assert:equal(cap:FindFirstChild("Gradient") ~= nil, kind == "gradient")
		end)
	end
	function SelectMountValidation:caretIconFallback(source)
		withMounted(400, 200, themedSelect(caretColorTheme(source)), function(mounted)
			local icon = waitForGuiObject(waitForSelect(mounted.host), "SelectCaret")
			local _result = icon.Parent
			if _result ~= nil then
				_result = _result.Name
			end
			Assert:equal(_result, "Cap")
			Assert:equal(icon.ImageColor3, expectedCaretColor(source))
		end)
	end
	function SelectMountValidation:dropDownOverrides()
		local theme = selectTheme({
			borderColor = BASE_BORDER,
			borderThickness = 1,
			cornerRadius = 8,
			dropDown = {
				cornerRadius = 4,
				borderColor = DROP_BORDER,
				borderThickness = 3,
				boxShadow = {
					shadow = "0px 6px 14px 0px",
					color = SHADOW_COLOR,
					transparency = 0.5,
				},
				gap = 6,
			},
		})
		withMounted(400, 400, overlaySelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local dropdown = openDropdown(mounted, selectRoot)
			local stroke = dropdown:FindFirstChild("Stroke")
			local shadow = dropdown:FindFirstChild("BoxShadow")
			Assert:equal(stroke.Thickness, 3)
			Assert:equal(stroke.Color, DROP_BORDER)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer)
			Assert:equal((dropdown:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 4))
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under SelectDropdown")
			Assert:equal(shadow.Color, SHADOW_COLOR)
			Assert:equal(shadow.Transparency, 0.5)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 6))
			Assert:equal(shadow.BlurRadius, UDim.new(0, 14))
			Assert:approximately(rect(dropdown).top, rect(selectButton(selectRoot)).bottom + 6, 1)
			Assert:equal(fieldStroke(selectRoot).Color, BASE_BORDER)
			Assert:equal((selectButton(selectRoot):FindFirstChild("Corners")).CornerRadius, UDim.new(0, 8))
		end)
	end
	function SelectMountValidation:dropDownFallback()
		local theme = selectTheme({
			borderColor = BASE_BORDER,
			borderThickness = 2,
			cornerRadius = 5,
			dropDown = {
				boxShadow = "0px 4px 8px 0px",
			},
		}, {
			color = SHADOW_COLOR,
			transparency = 0.5,
		})
		withMounted(400, 400, overlaySelect(theme), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local dropdown = openDropdown(mounted, selectRoot)
			local stroke = dropdown:FindFirstChild("Stroke")
			local shadow = dropdown:FindFirstChild("BoxShadow")
			Assert:equal(stroke.Thickness, 2)
			Assert:equal(stroke.Color, BASE_BORDER)
			Assert:equal((dropdown:FindFirstChild("Corners")).CornerRadius, UDim.new(0, 5))
			Assert:notUndefined(shadow, "Expected a BoxShadow UIShadow directly under SelectDropdown")
			Assert:equal(shadow.Color, SHADOW_COLOR)
			Assert:equal(shadow.Offset, UDim2.fromOffset(0, 4))
			Assert:approximately(rect(dropdown).top, rect(selectButton(selectRoot)).bottom, 1)
		end)
	end
	function SelectMountValidation:dropDownGap(gap)
		withMounted(400, 400, overlaySelect(selectTheme({
			dropDown = {
				gap = gap,
			},
		})), function(mounted)
			local selectRoot = waitForSelect(mounted.host)
			local dropdown = openDropdown(mounted, selectRoot)
			Assert:approximately(rect(dropdown).top - rect(selectButton(selectRoot)).bottom, gap, 1)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("With three options and no selected prop, the closed control shows the first option and stays self-contained")
	local _descriptor = Test(SelectMountValidation, "mountsContained", {
		value = SelectMountValidation.mountsContained,
	})
	if _descriptor then
		SelectMountValidation.mountsContained = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SelectMountValidation, "mountsContained", {
		value = SelectMountValidation.mountsContained,
	})
	if _descriptor_1 then
		SelectMountValidation.mountsContained = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SelectMountValidation, "mountsContained", {
		value = SelectMountValidation.mountsContained,
	})
	if _descriptor_2 then
		SelectMountValidation.mountsContained = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("selected={2} seeds the closed control with the third option's text")
	local _descriptor_3 = Test(SelectMountValidation, "seedsFromSelected", {
		value = SelectMountValidation.seedsFromSelected,
	})
	if _descriptor_3 then
		SelectMountValidation.seedsFromSelected = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(SelectMountValidation, "seedsFromSelected", {
		value = SelectMountValidation.seedsFromSelected,
	})
	if _descriptor_4 then
		SelectMountValidation.seedsFromSelected = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(SelectMountValidation, "seedsFromSelected", {
		value = SelectMountValidation.seedsFromSelected,
	})
	if _descriptor_5 then
		SelectMountValidation.seedsFromSelected = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName('With no Select.Option children the closed control falls back to \"No Options\"')
	local _descriptor_6 = Test(SelectMountValidation, "noOptionsFallback", {
		value = SelectMountValidation.noOptionsFallback,
	})
	if _descriptor_6 then
		SelectMountValidation.noOptionsFallback = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(SelectMountValidation, "noOptionsFallback", {
		value = SelectMountValidation.noOptionsFallback,
	})
	if _descriptor_7 then
		SelectMountValidation.noOptionsFallback = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(SelectMountValidation, "noOptionsFallback", {
		value = SelectMountValidation.noOptionsFallback,
	})
	if _descriptor_8 then
		SelectMountValidation.noOptionsFallback = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("Firing the Fieldset labelActivated event opens the dropdown directly below the control with every option inside it, and firing again closes it")
	local _descriptor_9 = Test(SelectMountValidation, "labelTogglesDropdown", {
		value = SelectMountValidation.labelTogglesDropdown,
	})
	if _descriptor_9 then
		SelectMountValidation.labelTogglesDropdown = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(SelectMountValidation, "labelTogglesDropdown", {
		value = SelectMountValidation.labelTogglesDropdown,
	})
	if _descriptor_10 then
		SelectMountValidation.labelTogglesDropdown = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(SelectMountValidation, "labelTogglesDropdown", {
		value = SelectMountValidation.labelTogglesDropdown,
	})
	if _descriptor_11 then
		SelectMountValidation.labelTogglesDropdown = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Without theme background keys the Select root stays transparent and carries no root Corners")
	local _descriptor_12 = Test(SelectMountValidation, "defaultTransparent", {
		value = SelectMountValidation.defaultTransparent,
	})
	if _descriptor_12 then
		SelectMountValidation.defaultTransparent = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(SelectMountValidation, "defaultTransparent", {
		value = SelectMountValidation.defaultTransparent,
	})
	if _descriptor_13 then
		SelectMountValidation.defaultTransparent = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(SelectMountValidation, "defaultTransparent", {
		value = SelectMountValidation.defaultTransparent,
	})
	if _descriptor_14 then
		SelectMountValidation.defaultTransparent = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("A themed backgroundColor with backgroundTransparency below 1 fills the root and rounds it with the theme cornerRadius")
	local _descriptor_15 = Test(SelectMountValidation, "themedBackground", {
		value = SelectMountValidation.themedBackground,
	})
	if _descriptor_15 then
		SelectMountValidation.themedBackground = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(SelectMountValidation, "themedBackground", {
		value = SelectMountValidation.themedBackground,
	})
	if _descriptor_16 then
		SelectMountValidation.themedBackground = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(SelectMountValidation, "themedBackground", {
		value = SelectMountValidation.themedBackground,
	})
	if _descriptor_17 then
		SelectMountValidation.themedBackground = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("An instance BackgroundTransparency beats the theme fill while the root Corners still follows the theme transparency")
	local _descriptor_18 = Test(SelectMountValidation, "instanceTransparencyWins", {
		value = SelectMountValidation.instanceTransparencyWins,
	})
	if _descriptor_18 then
		SelectMountValidation.instanceTransparencyWins = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(SelectMountValidation, "instanceTransparencyWins", {
		value = SelectMountValidation.instanceTransparencyWins,
	})
	if _descriptor_19 then
		SelectMountValidation.instanceTransparencyWins = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(SelectMountValidation, "instanceTransparencyWins", {
		value = SelectMountValidation.instanceTransparencyWins,
	})
	if _descriptor_20 then
		SelectMountValidation.instanceTransparencyWins = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("select.textColor colours SelectedText and select.iconColor colours the SelectCaret image")
	local _descriptor_21 = Test(SelectMountValidation, "themedTextAndCaret", {
		value = SelectMountValidation.themedTextAndCaret,
	})
	if _descriptor_21 then
		SelectMountValidation.themedTextAndCaret = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(SelectMountValidation, "themedTextAndCaret", {
		value = SelectMountValidation.themedTextAndCaret,
	})
	if _descriptor_22 then
		SelectMountValidation.themedTextAndCaret = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(SelectMountValidation, "themedTextAndCaret", {
		value = SelectMountValidation.themedTextAndCaret,
	})
	if _descriptor_23 then
		SelectMountValidation.themedTextAndCaret = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("Without select.textColor or iconColor both fall back to the primary intent's default textColor")
	local _descriptor_24 = Test(SelectMountValidation, "defaultTextAndCaret", {
		value = SelectMountValidation.defaultTextAndCaret,
	})
	if _descriptor_24 then
		SelectMountValidation.defaultTextAndCaret = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(SelectMountValidation, "defaultTextAndCaret", {
		value = SelectMountValidation.defaultTextAndCaret,
	})
	if _descriptor_25 then
		SelectMountValidation.defaultTextAndCaret = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(SelectMountValidation, "defaultTextAndCaret", {
		value = SelectMountValidation.defaultTextAndCaret,
	})
	if _descriptor_26 then
		SelectMountValidation.defaultTextAndCaret = _descriptor_26.value
	end
	local _decorator_18 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_19 = DisplayName("Without the new theme keys the field has no shadow or band, a bare SelectCaret icon, and the dropdown opens flush with the field's border and radius")
	local _descriptor_27 = Test(SelectMountValidation, "unsetTreeUnchanged", {
		value = SelectMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_27 then
		SelectMountValidation.unsetTreeUnchanged = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_19(SelectMountValidation, "unsetTreeUnchanged", {
		value = SelectMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_28 then
		SelectMountValidation.unsetTreeUnchanged = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_18(SelectMountValidation, "unsetTreeUnchanged", {
		value = SelectMountValidation.unsetTreeUnchanged,
	})
	if _descriptor_29 then
		SelectMountValidation.unsetTreeUnchanged = _descriptor_29.value
	end
	local _decorator_20 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_21 = DisplayName("A bare CssShadow string draws a root UIShadow with that offset and blur in the global boxShadow colour and transparency")
	local _descriptor_30 = Test(SelectMountValidation, "stringShadow", {
		value = SelectMountValidation.stringShadow,
	})
	if _descriptor_30 then
		SelectMountValidation.stringShadow = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_21(SelectMountValidation, "stringShadow", {
		value = SelectMountValidation.stringShadow,
	})
	if _descriptor_31 then
		SelectMountValidation.stringShadow = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_20(SelectMountValidation, "stringShadow", {
		value = SelectMountValidation.stringShadow,
	})
	if _descriptor_32 then
		SelectMountValidation.stringShadow = _descriptor_32.value
	end
	local _decorator_22 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_23 = DisplayName("A { shadow, color, transparency } boxShadow uses its own colour and transparency instead of the global boxShadow ones")
	local _descriptor_33 = Test(SelectMountValidation, "tableShadow", {
		value = SelectMountValidation.tableShadow,
	})
	if _descriptor_33 then
		SelectMountValidation.tableShadow = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_23(SelectMountValidation, "tableShadow", {
		value = SelectMountValidation.tableShadow,
	})
	if _descriptor_34 then
		SelectMountValidation.tableShadow = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_22(SelectMountValidation, "tableShadow", {
		value = SelectMountValidation.tableShadow,
	})
	if _descriptor_35 then
		SelectMountValidation.tableShadow = _descriptor_35.value
	end
	local _decorator_24 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_25 = Each({ { "string" }, { "table" } })
	local _decorator_26 = DisplayName("An all-zero boxShadow, as a string or a table, draws no UIShadow on the Select root")
	local _descriptor_36 = Test(SelectMountValidation, "zeroShadowNothing", {
		value = SelectMountValidation.zeroShadowNothing,
	})
	if _descriptor_36 then
		SelectMountValidation.zeroShadowNothing = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_26(SelectMountValidation, "zeroShadowNothing", {
		value = SelectMountValidation.zeroShadowNothing,
	})
	if _descriptor_37 then
		SelectMountValidation.zeroShadowNothing = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_25(SelectMountValidation, "zeroShadowNothing", {
		value = SelectMountValidation.zeroShadowNothing,
	})
	if _descriptor_38 then
		SelectMountValidation.zeroShadowNothing = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_24(SelectMountValidation, "zeroShadowNothing", {
		value = SelectMountValidation.zeroShadowNothing,
	})
	if _descriptor_39 then
		SelectMountValidation.zeroShadowNothing = _descriptor_39.value
	end
	local _decorator_27 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_28 = DisplayName("innerShadow puts a coloured InnerShadow band on the root, inset by the border, under a ZIndex 2 SelectButton")
	local _descriptor_40 = Test(SelectMountValidation, "innerShadowBand", {
		value = SelectMountValidation.innerShadowBand,
	})
	if _descriptor_40 then
		SelectMountValidation.innerShadowBand = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_28(SelectMountValidation, "innerShadowBand", {
		value = SelectMountValidation.innerShadowBand,
	})
	if _descriptor_41 then
		SelectMountValidation.innerShadowBand = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_27(SelectMountValidation, "innerShadowBand", {
		value = SelectMountValidation.innerShadowBand,
	})
	if _descriptor_42 then
		SelectMountValidation.innerShadowBand = _descriptor_42.value
	end
	local _decorator_29 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_30 = DisplayName("MouseEnter on SelectButton applies states.hover's border colour and transparency over the base thickness, and MouseLeave restores the base")
	local _descriptor_43 = Test(SelectMountValidation, "hoverState", {
		value = SelectMountValidation.hoverState,
	})
	if _descriptor_43 then
		SelectMountValidation.hoverState = _descriptor_43.value
	end
	local _descriptor_44 = _decorator_30(SelectMountValidation, "hoverState", {
		value = SelectMountValidation.hoverState,
	})
	if _descriptor_44 then
		SelectMountValidation.hoverState = _descriptor_44.value
	end
	local _descriptor_45 = _decorator_29(SelectMountValidation, "hoverState", {
		value = SelectMountValidation.hoverState,
	})
	if _descriptor_45 then
		SelectMountValidation.hoverState = _descriptor_45.value
	end
	local _decorator_31 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_32 = DisplayName("Opening the dropdown while hovered applies only states.focus, and closing it returns to the hover look")
	local _descriptor_46 = Test(SelectMountValidation, "focusState", {
		value = SelectMountValidation.focusState,
	})
	if _descriptor_46 then
		SelectMountValidation.focusState = _descriptor_46.value
	end
	local _descriptor_47 = _decorator_32(SelectMountValidation, "focusState", {
		value = SelectMountValidation.focusState,
	})
	if _descriptor_47 then
		SelectMountValidation.focusState = _descriptor_47.value
	end
	local _descriptor_48 = _decorator_31(SelectMountValidation, "focusState", {
		value = SelectMountValidation.focusState,
	})
	if _descriptor_48 then
		SelectMountValidation.focusState = _descriptor_48.value
	end
	local _decorator_33 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_34 = DisplayName("The disabled prop applies states.disabled even while hovered, and an instance BackgroundTransparency still beats it")
	local _descriptor_49 = Test(SelectMountValidation, "disabledState", {
		value = SelectMountValidation.disabledState,
	})
	if _descriptor_49 then
		SelectMountValidation.disabledState = _descriptor_49.value
	end
	local _descriptor_50 = _decorator_34(SelectMountValidation, "disabledState", {
		value = SelectMountValidation.disabledState,
	})
	if _descriptor_50 then
		SelectMountValidation.disabledState = _descriptor_50.value
	end
	local _descriptor_51 = _decorator_33(SelectMountValidation, "disabledState", {
		value = SelectMountValidation.disabledState,
	})
	if _descriptor_51 then
		SelectMountValidation.disabledState = _descriptor_51.value
	end
	local _decorator_35 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_36 = DisplayName("The root Corners appears only while a state brings the theme transparency below 1")
	local _descriptor_52 = Test(SelectMountValidation, "cornersFollowState", {
		value = SelectMountValidation.cornersFollowState,
	})
	if _descriptor_52 then
		SelectMountValidation.cornersFollowState = _descriptor_52.value
	end
	local _descriptor_53 = _decorator_36(SelectMountValidation, "cornersFollowState", {
		value = SelectMountValidation.cornersFollowState,
	})
	if _descriptor_53 then
		SelectMountValidation.cornersFollowState = _descriptor_53.value
	end
	local _descriptor_54 = _decorator_35(SelectMountValidation, "cornersFollowState", {
		value = SelectMountValidation.cornersFollowState,
	})
	if _descriptor_54 then
		SelectMountValidation.cornersFollowState = _descriptor_54.value
	end
	local _decorator_37 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_38 = DisplayName("A disabled Select ignores both a click and Fieldset labelActivated, and opens again once re-enabled")
	local _descriptor_55 = Test(SelectMountValidation, "disabledCannotOpen", {
		value = SelectMountValidation.disabledCannotOpen,
	})
	if _descriptor_55 then
		SelectMountValidation.disabledCannotOpen = _descriptor_55.value
	end
	local _descriptor_56 = _decorator_38(SelectMountValidation, "disabledCannotOpen", {
		value = SelectMountValidation.disabledCannotOpen,
	})
	if _descriptor_56 then
		SelectMountValidation.disabledCannotOpen = _descriptor_56.value
	end
	local _descriptor_57 = _decorator_37(SelectMountValidation, "disabledCannotOpen", {
		value = SelectMountValidation.disabledCannotOpen,
	})
	if _descriptor_57 then
		SelectMountValidation.disabledCannotOpen = _descriptor_57.value
	end
	local _decorator_39 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_40 = DisplayName("Setting disabled while the dropdown is open closes it and shows the disabled look")
	local _descriptor_58 = Test(SelectMountValidation, "disabledClosesOpen", {
		value = SelectMountValidation.disabledClosesOpen,
	})
	if _descriptor_58 then
		SelectMountValidation.disabledClosesOpen = _descriptor_58.value
	end
	local _descriptor_59 = _decorator_40(SelectMountValidation, "disabledClosesOpen", {
		value = SelectMountValidation.disabledClosesOpen,
	})
	if _descriptor_59 then
		SelectMountValidation.disabledClosesOpen = _descriptor_59.value
	end
	local _descriptor_60 = _decorator_39(SelectMountValidation, "disabledClosesOpen", {
		value = SelectMountValidation.disabledClosesOpen,
	})
	if _descriptor_60 then
		SelectMountValidation.disabledClosesOpen = _descriptor_60.value
	end
	local _decorator_41 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_42 = DisplayName("A styled caret draws a filled, stroked, rounded Cap box around a centred SelectCaret, overlapping 6px past its slot on a -6px right margin")
	local _descriptor_61 = Test(SelectMountValidation, "caretCap", {
		value = SelectMountValidation.caretCap,
	})
	if _descriptor_61 then
		SelectMountValidation.caretCap = _descriptor_61.value
	end
	local _descriptor_62 = _decorator_42(SelectMountValidation, "caretCap", {
		value = SelectMountValidation.caretCap,
	})
	if _descriptor_62 then
		SelectMountValidation.caretCap = _descriptor_62.value
	end
	local _descriptor_63 = _decorator_41(SelectMountValidation, "caretCap", {
		value = SelectMountValidation.caretCap,
	})
	if _descriptor_63 then
		SelectMountValidation.caretCap = _descriptor_63.value
	end
	local _decorator_43 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_44 = DisplayName("A four-value caret margin widens the slot by left+right, sets its height to top+bottom less the padding inset, and shifts the centred Cap by left and half of top-bottom")
	local _descriptor_64 = Test(SelectMountValidation, "caretMarginQuad", {
		value = SelectMountValidation.caretMarginQuad,
	})
	if _descriptor_64 then
		SelectMountValidation.caretMarginQuad = _descriptor_64.value
	end
	local _descriptor_65 = _decorator_44(SelectMountValidation, "caretMarginQuad", {
		value = SelectMountValidation.caretMarginQuad,
	})
	if _descriptor_65 then
		SelectMountValidation.caretMarginQuad = _descriptor_65.value
	end
	local _descriptor_66 = _decorator_43(SelectMountValidation, "caretMarginQuad", {
		value = SelectMountValidation.caretMarginQuad,
	})
	if _descriptor_66 then
		SelectMountValidation.caretMarginQuad = _descriptor_66.value
	end
	local _decorator_45 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_46 = DisplayName("An empty caret object gives a transparent theme-icon-sized Cap with no stroke, corners or gradient")
	local _descriptor_67 = Test(SelectMountValidation, "caretDefaults", {
		value = SelectMountValidation.caretDefaults,
	})
	if _descriptor_67 then
		SelectMountValidation.caretDefaults = _descriptor_67.value
	end
	local _descriptor_68 = _decorator_46(SelectMountValidation, "caretDefaults", {
		value = SelectMountValidation.caretDefaults,
	})
	if _descriptor_68 then
		SelectMountValidation.caretDefaults = _descriptor_68.value
	end
	local _descriptor_69 = _decorator_45(SelectMountValidation, "caretDefaults", {
		value = SelectMountValidation.caretDefaults,
	})
	if _descriptor_69 then
		SelectMountValidation.caretDefaults = _descriptor_69.value
	end
	local _decorator_47 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_48 = DisplayName("A 30px stroked cap that fits inside the padded field keeps the Select at the text line plus padding, with SelectedText centred in the field")
	local _descriptor_70 = Test(SelectMountValidation, "caretCapNoGrow", {
		value = SelectMountValidation.caretCapNoGrow,
	})
	if _descriptor_70 then
		SelectMountValidation.caretCapNoGrow = _descriptor_70.value
	end
	local _descriptor_71 = _decorator_48(SelectMountValidation, "caretCapNoGrow", {
		value = SelectMountValidation.caretCapNoGrow,
	})
	if _descriptor_71 then
		SelectMountValidation.caretCapNoGrow = _descriptor_71.value
	end
	local _descriptor_72 = _decorator_47(SelectMountValidation, "caretCapNoGrow", {
		value = SelectMountValidation.caretCapNoGrow,
	})
	if _descriptor_72 then
		SelectMountValidation.caretCapNoGrow = _descriptor_72.value
	end
	local _decorator_49 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_50 = Each({ { "gradient", 0 }, { "explicit", 0.5 } })
	local _decorator_51 = DisplayName("A caret backgroundGradient alone makes the Cap opaque with a Gradient, and an explicit backgroundTransparency overrides the fill")
	local _descriptor_73 = Test(SelectMountValidation, "caretFill", {
		value = SelectMountValidation.caretFill,
	})
	if _descriptor_73 then
		SelectMountValidation.caretFill = _descriptor_73.value
	end
	local _descriptor_74 = _decorator_51(SelectMountValidation, "caretFill", {
		value = SelectMountValidation.caretFill,
	})
	if _descriptor_74 then
		SelectMountValidation.caretFill = _descriptor_74.value
	end
	local _descriptor_75 = _decorator_50(SelectMountValidation, "caretFill", {
		value = SelectMountValidation.caretFill,
	})
	if _descriptor_75 then
		SelectMountValidation.caretFill = _descriptor_75.value
	end
	local _descriptor_76 = _decorator_49(SelectMountValidation, "caretFill", {
		value = SelectMountValidation.caretFill,
	})
	if _descriptor_76 then
		SelectMountValidation.caretFill = _descriptor_76.value
	end
	local _decorator_52 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_53 = Each({ { "caret" }, { "select" }, { "none" } })
	local _decorator_54 = DisplayName("The capped SelectCaret colour falls back from caret.iconColor to select.iconColor to the primary default textColor")
	local _descriptor_77 = Test(SelectMountValidation, "caretIconFallback", {
		value = SelectMountValidation.caretIconFallback,
	})
	if _descriptor_77 then
		SelectMountValidation.caretIconFallback = _descriptor_77.value
	end
	local _descriptor_78 = _decorator_54(SelectMountValidation, "caretIconFallback", {
		value = SelectMountValidation.caretIconFallback,
	})
	if _descriptor_78 then
		SelectMountValidation.caretIconFallback = _descriptor_78.value
	end
	local _descriptor_79 = _decorator_53(SelectMountValidation, "caretIconFallback", {
		value = SelectMountValidation.caretIconFallback,
	})
	if _descriptor_79 then
		SelectMountValidation.caretIconFallback = _descriptor_79.value
	end
	local _descriptor_80 = _decorator_52(SelectMountValidation, "caretIconFallback", {
		value = SelectMountValidation.caretIconFallback,
	})
	if _descriptor_80 then
		SelectMountValidation.caretIconFallback = _descriptor_80.value
	end
	local _decorator_55 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_56 = DisplayName("dropDown overrides the dropdown's radius, Outer border and shadow and opens it gap px below the field, leaving the field stroke alone")
	local _descriptor_81 = Test(SelectMountValidation, "dropDownOverrides", {
		value = SelectMountValidation.dropDownOverrides,
	})
	if _descriptor_81 then
		SelectMountValidation.dropDownOverrides = _descriptor_81.value
	end
	local _descriptor_82 = _decorator_56(SelectMountValidation, "dropDownOverrides", {
		value = SelectMountValidation.dropDownOverrides,
	})
	if _descriptor_82 then
		SelectMountValidation.dropDownOverrides = _descriptor_82.value
	end
	local _descriptor_83 = _decorator_55(SelectMountValidation, "dropDownOverrides", {
		value = SelectMountValidation.dropDownOverrides,
	})
	if _descriptor_83 then
		SelectMountValidation.dropDownOverrides = _descriptor_83.value
	end
	local _decorator_57 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_58 = DisplayName("A dropDown with only a string boxShadow keeps the field's radius and border, a flush gap, and the global shadow colour")
	local _descriptor_84 = Test(SelectMountValidation, "dropDownFallback", {
		value = SelectMountValidation.dropDownFallback,
	})
	if _descriptor_84 then
		SelectMountValidation.dropDownFallback = _descriptor_84.value
	end
	local _descriptor_85 = _decorator_58(SelectMountValidation, "dropDownFallback", {
		value = SelectMountValidation.dropDownFallback,
	})
	if _descriptor_85 then
		SelectMountValidation.dropDownFallback = _descriptor_85.value
	end
	local _descriptor_86 = _decorator_57(SelectMountValidation, "dropDownFallback", {
		value = SelectMountValidation.dropDownFallback,
	})
	if _descriptor_86 then
		SelectMountValidation.dropDownFallback = _descriptor_86.value
	end
	local _decorator_59 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_60 = Each({ { 4 }, { 12 } })
	local _decorator_61 = DisplayName("dropDown.gap offsets the dropdown's top edge exactly that many pixels below the field's bottom edge")
	local _descriptor_87 = Test(SelectMountValidation, "dropDownGap", {
		value = SelectMountValidation.dropDownGap,
	})
	if _descriptor_87 then
		SelectMountValidation.dropDownGap = _descriptor_87.value
	end
	local _descriptor_88 = _decorator_61(SelectMountValidation, "dropDownGap", {
		value = SelectMountValidation.dropDownGap,
	})
	if _descriptor_88 then
		SelectMountValidation.dropDownGap = _descriptor_88.value
	end
	local _descriptor_89 = _decorator_60(SelectMountValidation, "dropDownGap", {
		value = SelectMountValidation.dropDownGap,
	})
	if _descriptor_89 then
		SelectMountValidation.dropDownGap = _descriptor_89.value
	end
	local _descriptor_90 = _decorator_59(SelectMountValidation, "dropDownGap", {
		value = SelectMountValidation.dropDownGap,
	})
	if _descriptor_90 then
		SelectMountValidation.dropDownGap = _descriptor_90.value
	end
	SelectMountValidation = Tag("Studio")(SelectMountValidation) or SelectMountValidation
end
return SelectMountValidation
