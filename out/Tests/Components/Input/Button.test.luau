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
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Button").Button
local _Layout = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout")
local Group = _Layout.Group
local HStack = _Layout.HStack
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
local function waitForButton(host, name)
	if name == nil then
		name = "Button"
	end
	return waitForGuiObject(host, name)
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
	ButtonMountValidation = Tag("Studio")(ButtonMountValidation) or ButtonMountValidation
end
return ButtonMountValidation
