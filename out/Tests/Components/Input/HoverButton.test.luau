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
	HoverButtonMountValidation = Tag("Studio")(HoverButtonMountValidation) or HoverButtonMountValidation
end
return HoverButtonMountValidation
