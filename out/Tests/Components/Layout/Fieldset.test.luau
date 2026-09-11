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
local Fieldset = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Fieldset").Fieldset
local VStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "VStack").VStack
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedLeft = _layout.assertAlignedLeft
local assertAlignedRight = _layout.assertAlignedRight
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertSizeApprox = _layout.assertSizeApprox
local assertStackedHorizontally = _layout.assertStackedHorizontally
local findDescendant = _layout.findDescendant
local rect = _layout.rect
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local WIDE_HOST = 600
local HOST_HEIGHT = 200
local CONTROL_WIDTH = 120
local CONTROL_HEIGHT = 32
local function fieldset(props)
	if props == nil then
		props = {}
	end
	return React.createElement("frame", {
		key = "Form",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(VStack, nil, React.createElement(Fieldset, {
		checkbox = props.checkbox,
		wrap = props.wrap,
	}, React.createElement(Fieldset.Label, nil, React.createElement(Text, {
		text = "Label",
	})), React.createElement(Fieldset.Control, nil, React.createElement("frame", {
		key = "ControlContent",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(CONTROL_WIDTH, CONTROL_HEIGHT),
	})))))
end
local function waitForFieldset(host)
	return waitForGuiObject(host, "Fieldset", function(gui)
		return gui.AbsoluteSize.X == WIDE_HOST
	end, `Timed out waiting for the Fieldset to be stretched to the {WIDE_HOST}px host width`)
end
local function findLabelButton(root)
	return findDescendant(root, "FieldsetLabelButton")
end
local function findControlContent(root)
	return findDescendant(root, "ControlContent")
end
local function parentGui(instance)
	local parent = instance.Parent
	Assert:notUndefined(parent, `Expected {instance:GetFullName()} to have a parent`)
	Assert["true"](Assert, parent:IsA("GuiObject"), `Expected the parent of {instance:GetFullName()} to be a GuiObject`)
	return parent
end
local FieldsetMountValidation
do
	FieldsetMountValidation = setmetatable({}, {
		__tostring = function()
			return "FieldsetMountValidation"
		end,
	})
	FieldsetMountValidation.__index = FieldsetMountValidation
	function FieldsetMountValidation.new(...)
		local self = setmetatable({}, FieldsetMountValidation)
		return self:constructor(...) or self
	end
	function FieldsetMountValidation:constructor()
	end
	function FieldsetMountValidation:inlineAtWideWidth()
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), function(mounted)
			local root = waitForFieldset(mounted.host)
			local label = waitForGuiObject(root, "FieldsetLabelButton")
			local control = waitForGuiObject(root, "ControlContent")
			assertAlignedLeft(label, root, 1, "inline fieldset")
			assertStackedHorizontally({ label, control }, "inline fieldset")
		end)
	end
	function FieldsetMountValidation:controlFillsRemainingWidth()
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), function(mounted)
			local root = waitForFieldset(mounted.host)
			waitForGuiObject(root, "ControlContent")
			local labelSlot = parentGui(findLabelButton(root))
			local controlSlot = parentGui(findControlContent(root))
			waitForLayout(function()
				return if rect(controlSlot).right >= rect(root).right - 1 then true else nil
			end, "Timed out waiting for Fieldset.Control's FlexItem to grow to the Fieldset's right edge")
			assertAlignedRight(controlSlot, root, 1, "control slot")
			Assert["true"](Assert, rect(controlSlot).width > rect(labelSlot).width, `Expected the control slot ({rect(controlSlot).width}px) to be wider than the label slot ({rect(labelSlot).width}px)`)
		end)
	end
	function FieldsetMountValidation:checkboxControlKeepsContentWidth()
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset({
			checkbox = true,
		}), function(mounted)
			local root = waitForFieldset(mounted.host)
			waitForGuiObject(root, "ControlContent")
			local controlSlot = parentGui(findControlContent(root))
			assertSizeApprox(controlSlot, CONTROL_WIDTH, nil, 1, "checkbox control slot")
		end)
	end
	function FieldsetMountValidation:wrapFollowsBreakpoint(hostWidth, wrap, expectedWraps)
		withMounted(hostWidth, HOST_HEIGHT, fieldset({
			wrap = wrap,
		}), function(mounted)
			local root = waitForGuiObject(mounted.host, "Fieldset", function(gui)
				return gui.AbsoluteSize.X == hostWidth
			end)
			waitForDescendant(root, "HStack", function(layout)
				return layout.Wraps == expectedWraps
			end, `Timed out waiting for the Fieldset's UIListLayout to report Wraps={expectedWraps} at {hostWidth}px with wrap="{wrap}"`)
		end)
	end
	function FieldsetMountValidation:allContained()
		withMounted(WIDE_HOST, HOST_HEIGHT, fieldset(), function(mounted)
			local root = waitForFieldset(mounted.host)
			waitForGuiObject(root, "ControlContent")
			assertAllDescendantsContained(root, "fieldset")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("At 600px the label and control sit side by side, label first, starting at the Fieldset's left edge")
	local _descriptor = Test(FieldsetMountValidation, "inlineAtWideWidth", {
		value = FieldsetMountValidation.inlineAtWideWidth,
	})
	if _descriptor then
		FieldsetMountValidation.inlineAtWideWidth = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(FieldsetMountValidation, "inlineAtWideWidth", {
		value = FieldsetMountValidation.inlineAtWideWidth,
	})
	if _descriptor_1 then
		FieldsetMountValidation.inlineAtWideWidth = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(FieldsetMountValidation, "inlineAtWideWidth", {
		value = FieldsetMountValidation.inlineAtWideWidth,
	})
	if _descriptor_2 then
		FieldsetMountValidation.inlineAtWideWidth = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("In the default mode Fieldset.Control grows to the Fieldset's right edge while the label keeps its own width")
	local _descriptor_3 = Test(FieldsetMountValidation, "controlFillsRemainingWidth", {
		value = FieldsetMountValidation.controlFillsRemainingWidth,
	})
	if _descriptor_3 then
		FieldsetMountValidation.controlFillsRemainingWidth = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(FieldsetMountValidation, "controlFillsRemainingWidth", {
		value = FieldsetMountValidation.controlFillsRemainingWidth,
	})
	if _descriptor_4 then
		FieldsetMountValidation.controlFillsRemainingWidth = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(FieldsetMountValidation, "controlFillsRemainingWidth", {
		value = FieldsetMountValidation.controlFillsRemainingWidth,
	})
	if _descriptor_5 then
		FieldsetMountValidation.controlFillsRemainingWidth = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("checkbox={true} keeps Fieldset.Control at its content width instead of growing")
	local _descriptor_6 = Test(FieldsetMountValidation, "checkboxControlKeepsContentWidth", {
		value = FieldsetMountValidation.checkboxControlKeepsContentWidth,
	})
	if _descriptor_6 then
		FieldsetMountValidation.checkboxControlKeepsContentWidth = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(FieldsetMountValidation, "checkboxControlKeepsContentWidth", {
		value = FieldsetMountValidation.checkboxControlKeepsContentWidth,
	})
	if _descriptor_7 then
		FieldsetMountValidation.checkboxControlKeepsContentWidth = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(FieldsetMountValidation, "checkboxControlKeepsContentWidth", {
		value = FieldsetMountValidation.checkboxControlKeepsContentWidth,
	})
	if _descriptor_8 then
		FieldsetMountValidation.checkboxControlKeepsContentWidth = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = Each({ { 600, "lg", false }, { 250, "lg", true }, { 250, "xs", false } })
	local _decorator_8 = DisplayName("The HStack's Wraps flag is on only when the Fieldset's breakpoint is at or below the wrap prop")
	local _descriptor_9 = Test(FieldsetMountValidation, "wrapFollowsBreakpoint", {
		value = FieldsetMountValidation.wrapFollowsBreakpoint,
	})
	if _descriptor_9 then
		FieldsetMountValidation.wrapFollowsBreakpoint = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_8(FieldsetMountValidation, "wrapFollowsBreakpoint", {
		value = FieldsetMountValidation.wrapFollowsBreakpoint,
	})
	if _descriptor_10 then
		FieldsetMountValidation.wrapFollowsBreakpoint = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_7(FieldsetMountValidation, "wrapFollowsBreakpoint", {
		value = FieldsetMountValidation.wrapFollowsBreakpoint,
	})
	if _descriptor_11 then
		FieldsetMountValidation.wrapFollowsBreakpoint = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(FieldsetMountValidation, "wrapFollowsBreakpoint", {
		value = FieldsetMountValidation.wrapFollowsBreakpoint,
	})
	if _descriptor_12 then
		FieldsetMountValidation.wrapFollowsBreakpoint = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Every visible descendant of an inline Fieldset stays inside it")
	local _descriptor_13 = Test(FieldsetMountValidation, "allContained", {
		value = FieldsetMountValidation.allContained,
	})
	if _descriptor_13 then
		FieldsetMountValidation.allContained = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(FieldsetMountValidation, "allContained", {
		value = FieldsetMountValidation.allContained,
	})
	if _descriptor_14 then
		FieldsetMountValidation.allContained = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(FieldsetMountValidation, "allContained", {
		value = FieldsetMountValidation.allContained,
	})
	if _descriptor_15 then
		FieldsetMountValidation.allContained = _descriptor_15.value
	end
	FieldsetMountValidation = Tag("Studio")(FieldsetMountValidation) or FieldsetMountValidation
end
return FieldsetMountValidation
