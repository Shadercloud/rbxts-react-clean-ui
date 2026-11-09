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
local _HoverButton = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "HoverButton")
local HoverButton = _HoverButton.HoverButton
local HoverButtonContext = _HoverButton.HoverButtonContext
local fireHostEvent = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").fireHostEvent
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local DEFAULT_COLOR = Color3.fromRGB(10, 20, 30)
local FOCUS_COLOR = Color3.fromRGB(200, 40, 40)
local BORDER_COLOR = Color3.fromRGB(40, 120, 220)
local HOVER_BORDER = Color3.fromRGB(240, 200, 40)
local DEFAULT_PROPS = {
	Size = UDim2.fromOffset(120, 40),
	BackgroundColor3 = DEFAULT_COLOR,
	BackgroundTransparency = 0,
}
local function waitForHoverButton(host, name)
	if name == nil then
		name = "HoverButton"
	end
	return waitForGuiObject(host, name)
end
local function strokeOf(button)
	local stroke = button:FindFirstChildWhichIsA("UIStroke")
	Assert:notUndefined(stroke, `Expected {button.Name} to have a direct UIStroke child`)
	return stroke
end
local function SelectionProbe()
	local context = React.useContext(HoverButtonContext)
	local name = if context == nil then "ProbeNoContext" elseif context.isSelected then "ProbeSelected" else "ProbeUnselected"
	return React.createElement("frame", {
		key = name,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(10, 10),
	})
end
local HoverButtonMountValidation
do
	HoverButtonMountValidation = setmetatable({}, {
		__tostring = function()
			return "HoverButtonMountValidation"
		end,
	})
	HoverButtonMountValidation.__index = HoverButtonMountValidation
	function HoverButtonMountValidation.new(...)
		local self = setmetatable({}, HoverButtonMountValidation)
		return self:constructor(...) or self
	end
	function HoverButtonMountValidation:constructor()
	end
	function HoverButtonMountValidation:mountsWithDefaultProps()
		withMounted(400, 200, React.createElement(HoverButton, {
			default = DEFAULT_PROPS,
		}, React.createElement("frame", {
			key = "Child",
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(60, 20),
		})), function(mounted)
			local button = waitForHoverButton(mounted.host)
			assertSizeApprox(button, 120, 40, 0, "default props")
			Assert:equal(button.BackgroundColor3, DEFAULT_COLOR)
			assertAllDescendantsContained(button, "default props")
		end)
	end
	function HoverButtonMountValidation:selectedUsesFocus()
		withMounted(400, 200, React.createElement(HoverButton, {
			default = DEFAULT_PROPS,
			focus = {
				BackgroundColor3 = FOCUS_COLOR,
			},
			isSelected = true,
		}), function(mounted)
			local button = waitForHoverButton(mounted.host)
			Assert:equal(button.BackgroundColor3, FOCUS_COLOR)
			assertSizeApprox(button, 120, 40, 0, "selected")
			mounted.update(React.createElement(HoverButton, {
				default = DEFAULT_PROPS,
				focus = {
					BackgroundColor3 = FOCUS_COLOR,
				},
				isSelected = false,
			}))
			waitForLayout(function()
				return if button.BackgroundColor3 == DEFAULT_COLOR then true else nil
			end, "Timed out waiting for the HoverButton to revert to its default BackgroundColor3 after isSelected was cleared")
		end)
	end
	function HoverButtonMountValidation:contextReportsSelected()
		withMounted(400, 200, React.createElement(HoverButton, {
			default = DEFAULT_PROPS,
		}, React.createElement(SelectionProbe)), function(mounted)
			local button = waitForHoverButton(mounted.host)
			findDescendant(button, "ProbeUnselected")
			mounted.update(React.createElement(HoverButton, {
				default = DEFAULT_PROPS,
				isSelected = true,
			}, React.createElement(SelectionProbe)))
			waitForLayout(function()
				return button:FindFirstChild("ProbeSelected")
			end, "Timed out waiting for the probe to report isSelected=true after re-render")
			Assert:undefined(button:FindFirstChild("ProbeUnselected"))
		end)
	end
	function HoverButtonMountValidation:customName()
		withMounted(400, 200, React.createElement(HoverButton, {
			name = "TabTrigger",
			default = DEFAULT_PROPS,
		}), function(mounted)
			waitForHoverButton(mounted.host, "TabTrigger")
			Assert:undefined(mounted.host:FindFirstChild("HoverButton", true))
		end)
	end
	function HoverButtonMountValidation:noStrokeByDefault()
		withMounted(400, 200, React.createElement(HoverButton, {
			default = DEFAULT_PROPS,
		}), function(mounted)
			local button = waitForHoverButton(mounted.host)
			Assert:undefined(button:FindFirstChildWhichIsA("UIStroke"), "Expected no UIStroke without border props")
		end)
	end
	function HoverButtonMountValidation:topLevelBorder()
		withMounted(400, 200, React.createElement(HoverButton, {
			default = DEFAULT_PROPS,
			borderThickness = 2,
			borderColor = BORDER_COLOR,
			borderTransparency = 0.5,
		}), function(mounted)
			local stroke = strokeOf(waitForHoverButton(mounted.host))
			Assert:equal(stroke.Name, "Stroke")
			Assert:equal(stroke.Thickness, 2)
			Assert:equal(stroke.Color, BORDER_COLOR)
			Assert:equal(stroke.Transparency, 0.5)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Inner)
		end)
	end
	function HoverButtonMountValidation:stateBorderWins()
		local _attributes = {}
		local _object = table.clone(DEFAULT_PROPS)
		setmetatable(_object, nil)
		_object.borderThickness = 3
		_object.borderColor = HOVER_BORDER
		_attributes.default = _object
		_attributes.borderThickness = 1
		_attributes.borderColor = BORDER_COLOR
		_attributes.borderTransparency = 0.25
		_attributes.borderPosition = "outer"
		withMounted(400, 200, React.createElement(HoverButton, _attributes), function(mounted)
			local stroke = strokeOf(waitForHoverButton(mounted.host))
			Assert:equal(stroke.Thickness, 3)
			Assert:equal(stroke.Color, HOVER_BORDER)
			Assert:equal(stroke.Transparency, 0.25)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer)
		end)
	end
	function HoverButtonMountValidation:hoverBorderColor()
		local _attributes = {}
		local _object = table.clone(DEFAULT_PROPS)
		setmetatable(_object, nil)
		_object.borderThickness = 2
		_object.borderColor = BORDER_COLOR
		_attributes.default = _object
		_attributes.hover = {
			borderColor = HOVER_BORDER,
		}
		withMounted(400, 200, React.createElement(HoverButton, _attributes), function(mounted)
			local button = waitForHoverButton(mounted.host)
			Assert:equal(strokeOf(button).Color, BORDER_COLOR)
			fireHostEvent(mounted, button, "MouseEnter", 0, 0)
			waitForLayout(function()
				return if strokeOf(button).Color == HOVER_BORDER then true else nil
			end, "Timed out waiting for the stroke to take the hover borderColor")
			Assert:equal(strokeOf(button).Thickness, 2)
			fireHostEvent(mounted, button, "MouseLeave", 0, 0)
			waitForLayout(function()
				return if strokeOf(button).Color == BORDER_COLOR then true else nil
			end, "Timed out waiting for the stroke to revert to the default borderColor")
		end)
	end
	function HoverButtonMountValidation:focusAddsBorder()
		local element = function(selected)
			return React.createElement(HoverButton, {
				default = DEFAULT_PROPS,
				focus = {
					borderThickness = 4,
					borderPosition = "outer",
				},
				isSelected = selected,
			})
		end
		withMounted(400, 200, element(true), function(mounted)
			local button = waitForHoverButton(mounted.host)
			local stroke = strokeOf(button)
			Assert:equal(stroke.Thickness, 4)
			Assert:equal(stroke.BorderStrokePosition, Enum.BorderStrokePosition.Outer)
			mounted.update(element(false))
			waitForLayout(function()
				return if button:FindFirstChildWhichIsA("UIStroke") == nil then true else nil
			end, "Timed out waiting for the focus-only stroke to be removed after isSelected was cleared")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("The default prop set is forwarded to the root ImageButton and its children stay inside it")
	local _descriptor = Test(HoverButtonMountValidation, "mountsWithDefaultProps", {
		value = HoverButtonMountValidation.mountsWithDefaultProps,
	})
	if _descriptor then
		HoverButtonMountValidation.mountsWithDefaultProps = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(HoverButtonMountValidation, "mountsWithDefaultProps", {
		value = HoverButtonMountValidation.mountsWithDefaultProps,
	})
	if _descriptor_1 then
		HoverButtonMountValidation.mountsWithDefaultProps = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(HoverButtonMountValidation, "mountsWithDefaultProps", {
		value = HoverButtonMountValidation.mountsWithDefaultProps,
	})
	if _descriptor_2 then
		HoverButtonMountValidation.mountsWithDefaultProps = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("isSelected={true} layers the focus props over default, and clearing it falls back to default again")
	local _descriptor_3 = Test(HoverButtonMountValidation, "selectedUsesFocus", {
		value = HoverButtonMountValidation.selectedUsesFocus,
	})
	if _descriptor_3 then
		HoverButtonMountValidation.selectedUsesFocus = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(HoverButtonMountValidation, "selectedUsesFocus", {
		value = HoverButtonMountValidation.selectedUsesFocus,
	})
	if _descriptor_4 then
		HoverButtonMountValidation.selectedUsesFocus = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(HoverButtonMountValidation, "selectedUsesFocus", {
		value = HoverButtonMountValidation.selectedUsesFocus,
	})
	if _descriptor_5 then
		HoverButtonMountValidation.selectedUsesFocus = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Children read the isSelected flag through HoverButtonContext and see it flip on re-render")
	local _descriptor_6 = Test(HoverButtonMountValidation, "contextReportsSelected", {
		value = HoverButtonMountValidation.contextReportsSelected,
	})
	if _descriptor_6 then
		HoverButtonMountValidation.contextReportsSelected = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(HoverButtonMountValidation, "contextReportsSelected", {
		value = HoverButtonMountValidation.contextReportsSelected,
	})
	if _descriptor_7 then
		HoverButtonMountValidation.contextReportsSelected = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(HoverButtonMountValidation, "contextReportsSelected", {
		value = HoverButtonMountValidation.contextReportsSelected,
	})
	if _descriptor_8 then
		HoverButtonMountValidation.contextReportsSelected = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName('Passing a name prop renames the root ImageButton and no \"HoverButton\" child remains')
	local _descriptor_9 = Test(HoverButtonMountValidation, "customName", {
		value = HoverButtonMountValidation.customName,
	})
	if _descriptor_9 then
		HoverButtonMountValidation.customName = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(HoverButtonMountValidation, "customName", {
		value = HoverButtonMountValidation.customName,
	})
	if _descriptor_10 then
		HoverButtonMountValidation.customName = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(HoverButtonMountValidation, "customName", {
		value = HoverButtonMountValidation.customName,
	})
	if _descriptor_11 then
		HoverButtonMountValidation.customName = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("With no border props anywhere the HoverButton renders no UIStroke")
	local _descriptor_12 = Test(HoverButtonMountValidation, "noStrokeByDefault", {
		value = HoverButtonMountValidation.noStrokeByDefault,
	})
	if _descriptor_12 then
		HoverButtonMountValidation.noStrokeByDefault = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(HoverButtonMountValidation, "noStrokeByDefault", {
		value = HoverButtonMountValidation.noStrokeByDefault,
	})
	if _descriptor_13 then
		HoverButtonMountValidation.noStrokeByDefault = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(HoverButtonMountValidation, "noStrokeByDefault", {
		value = HoverButtonMountValidation.noStrokeByDefault,
	})
	if _descriptor_14 then
		HoverButtonMountValidation.noStrokeByDefault = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Top-level border props render a Stroke with that thickness, colour and transparency, drawn inside by default")
	local _descriptor_15 = Test(HoverButtonMountValidation, "topLevelBorder", {
		value = HoverButtonMountValidation.topLevelBorder,
	})
	if _descriptor_15 then
		HoverButtonMountValidation.topLevelBorder = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(HoverButtonMountValidation, "topLevelBorder", {
		value = HoverButtonMountValidation.topLevelBorder,
	})
	if _descriptor_16 then
		HoverButtonMountValidation.topLevelBorder = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(HoverButtonMountValidation, "topLevelBorder", {
		value = HoverButtonMountValidation.topLevelBorder,
	})
	if _descriptor_17 then
		HoverButtonMountValidation.topLevelBorder = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("Border values inside the default state set override the top-level ones field by field")
	local _descriptor_18 = Test(HoverButtonMountValidation, "stateBorderWins", {
		value = HoverButtonMountValidation.stateBorderWins,
	})
	if _descriptor_18 then
		HoverButtonMountValidation.stateBorderWins = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(HoverButtonMountValidation, "stateBorderWins", {
		value = HoverButtonMountValidation.stateBorderWins,
	})
	if _descriptor_19 then
		HoverButtonMountValidation.stateBorderWins = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(HoverButtonMountValidation, "stateBorderWins", {
		value = HoverButtonMountValidation.stateBorderWins,
	})
	if _descriptor_20 then
		HoverButtonMountValidation.stateBorderWins = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("A hover set with only borderColor recolours the stroke on MouseEnter, keeps its thickness, and reverts on MouseLeave")
	local _descriptor_21 = Test(HoverButtonMountValidation, "hoverBorderColor", {
		value = HoverButtonMountValidation.hoverBorderColor,
	})
	if _descriptor_21 then
		HoverButtonMountValidation.hoverBorderColor = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(HoverButtonMountValidation, "hoverBorderColor", {
		value = HoverButtonMountValidation.hoverBorderColor,
	})
	if _descriptor_22 then
		HoverButtonMountValidation.hoverBorderColor = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(HoverButtonMountValidation, "hoverBorderColor", {
		value = HoverButtonMountValidation.hoverBorderColor,
	})
	if _descriptor_23 then
		HoverButtonMountValidation.hoverBorderColor = _descriptor_23.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = DisplayName("A focus set can add a border that only appears while isSelected is true")
	local _descriptor_24 = Test(HoverButtonMountValidation, "focusAddsBorder", {
		value = HoverButtonMountValidation.focusAddsBorder,
	})
	if _descriptor_24 then
		HoverButtonMountValidation.focusAddsBorder = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(HoverButtonMountValidation, "focusAddsBorder", {
		value = HoverButtonMountValidation.focusAddsBorder,
	})
	if _descriptor_25 then
		HoverButtonMountValidation.focusAddsBorder = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(HoverButtonMountValidation, "focusAddsBorder", {
		value = HoverButtonMountValidation.focusAddsBorder,
	})
	if _descriptor_26 then
		HoverButtonMountValidation.focusAddsBorder = _descriptor_26.value
	end
	HoverButtonMountValidation = Tag("Studio")(HoverButtonMountValidation) or HoverButtonMountValidation
end
return HoverButtonMountValidation
