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
local Select = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Select").Select
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
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
	SelectMountValidation = Tag("Studio")(SelectMountValidation) or SelectMountValidation
end
return SelectMountValidation
