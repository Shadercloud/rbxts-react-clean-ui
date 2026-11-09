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
local Checkbox = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Checkbox").Checkbox
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
local DefaultTheme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme").DefaultTheme
local activateButton = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").activateButton
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local function waitForCheckbox(host)
	return waitForGuiObject(host, "Checkbox")
end
local function findIcon(checkbox)
	return findDescendant(checkbox, "CheckboxIcon")
end
local function assertShowsChecked(checkbox, expected, label)
	local icon = findIcon(checkbox)
	Assert:equal(icon.Image ~= "", expected, `{label}: expected CheckboxIcon.Image to be {if expected then "set" else "empty"}, got "{icon.Image}"`)
end
local function recorder(values)
	return function(value)
		local _values = values
		local _value = value
		table.insert(_values, _value)
	end
end
local CheckboxMountValidation
do
	CheckboxMountValidation = setmetatable({}, {
		__tostring = function()
			return "CheckboxMountValidation"
		end,
	})
	CheckboxMountValidation.__index = CheckboxMountValidation
	function CheckboxMountValidation.new(...)
		local self = setmetatable({}, CheckboxMountValidation)
		return self:constructor(...) or self
	end
	function CheckboxMountValidation:constructor()
	end
	function CheckboxMountValidation:mountsContained()
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = true,
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			assertNonZeroSize(checkbox, "checked checkbox")
			assertAllDescendantsContained(checkbox, "checked checkbox")
		end)
	end
	function CheckboxMountValidation:silentControlledMount(variant, checked)
		local values = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = checked,
			onChange = recorder(values),
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			settleFrames(3)
			Assert:deepEqual(values, {}, `{variant}: expected no onChange on mount`)
			assertShowsChecked(checkbox, checked, variant)
		end)
	end
	function CheckboxMountValidation:defaultCheckedSeeds(variant, defaultChecked)
		local values = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			defaultChecked = defaultChecked,
			onChange = recorder(values),
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			settleFrames(3)
			Assert:deepEqual(values, {}, `{variant}: expected no onChange on mount`)
			assertShowsChecked(checkbox, defaultChecked, variant)
		end)
	end
	function CheckboxMountValidation:controlledClickReports()
		local values = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = false,
			onChange = recorder(values),
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			activateButton(mounted, checkbox)
			settleFrames(3)
			Assert:deepEqual(values, { true })
			assertShowsChecked(checkbox, false, "after click, before the prop changes")
			mounted.update(React.createElement(Checkbox, {
				checked = true,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertShowsChecked(checkbox, true, "after the prop changes")
			Assert:deepEqual(values, { true }, "Expected the prop change not to call onChange")
		end)
	end
	function CheckboxMountValidation:propChangeSilent()
		local values = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = false,
			onChange = recorder(values),
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			mounted.update(React.createElement(Checkbox, {
				checked = true,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertShowsChecked(checkbox, true, "checked prop on")
			mounted.update(React.createElement(Checkbox, {
				checked = false,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertShowsChecked(checkbox, false, "checked prop off")
			Assert:deepEqual(values, {})
		end)
	end
	function CheckboxMountValidation:uncontrolledClickToggles()
		local values = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			onChange = recorder(values),
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			activateButton(mounted, checkbox)
			Assert:deepEqual(values, { true })
			assertShowsChecked(checkbox, true, "after first click")
			activateButton(mounted, checkbox)
			Assert:deepEqual(values, { true, false })
			assertShowsChecked(checkbox, false, "after second click")
		end)
	end
	function CheckboxMountValidation:fieldsetLabelToggles()
		local labelActivated = Instance.new("BindableEvent")
		local values = {}
		TS.try(function()
			withMounted(200, 200, React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = true,
					labelActivated = labelActivated,
				},
			}, React.createElement(Checkbox, {
				onChange = recorder(values),
			})), function(mounted)
				local checkbox = waitForCheckbox(mounted.host)
				settleFrames(2)
				Assert:deepEqual(values, {}, "Expected no onChange before the label is activated")
				labelActivated:Fire()
				waitForLayout(function()
					return if #values >= 1 then true else nil
				end, "Timed out waiting for onChange to fire after labelActivated")
				settleFrames(1)
				Assert:deepEqual(values, { true })
				assertShowsChecked(checkbox, true, "after labelActivated")
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	function CheckboxMountValidation:scaleSizesIcon(scale)
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = true,
			scale = scale,
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			local icon = waitForGuiObject(checkbox, "CheckboxIcon")
			local expected = DefaultTheme.iconSize[scale]
			Assert:notUndefined(expected, `Expected DefaultTheme.iconSize to define an entry for scale "{scale}"`)
			assertSizeApprox(icon, expected, expected, 0, `scale={scale} icon`)
			assertAllDescendantsContained(checkbox, `scale={scale} checkbox`)
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("A checked Checkbox auto-sizes around its icon and keeps every visible descendant inside itself")
	local _descriptor = Test(CheckboxMountValidation, "mountsContained", {
		value = CheckboxMountValidation.mountsContained,
	})
	if _descriptor then
		CheckboxMountValidation.mountsContained = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(CheckboxMountValidation, "mountsContained", {
		value = CheckboxMountValidation.mountsContained,
	})
	if _descriptor_1 then
		CheckboxMountValidation.mountsContained = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(CheckboxMountValidation, "mountsContained", {
		value = CheckboxMountValidation.mountsContained,
	})
	if _descriptor_2 then
		CheckboxMountValidation.mountsContained = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "checked", true }, { "unchecked", false } })
	local _decorator_4 = DisplayName("Mounting a controlled Checkbox shows the checked prop and never calls onChange")
	local _descriptor_3 = Test(CheckboxMountValidation, "silentControlledMount", {
		value = CheckboxMountValidation.silentControlledMount,
	})
	if _descriptor_3 then
		CheckboxMountValidation.silentControlledMount = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(CheckboxMountValidation, "silentControlledMount", {
		value = CheckboxMountValidation.silentControlledMount,
	})
	if _descriptor_4 then
		CheckboxMountValidation.silentControlledMount = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(CheckboxMountValidation, "silentControlledMount", {
		value = CheckboxMountValidation.silentControlledMount,
	})
	if _descriptor_5 then
		CheckboxMountValidation.silentControlledMount = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(CheckboxMountValidation, "silentControlledMount", {
		value = CheckboxMountValidation.silentControlledMount,
	})
	if _descriptor_6 then
		CheckboxMountValidation.silentControlledMount = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { "defaultChecked", true }, { "defaultUnchecked", false } })
	local _decorator_7 = DisplayName("An uncontrolled Checkbox starts at defaultChecked without calling onChange")
	local _descriptor_7 = Test(CheckboxMountValidation, "defaultCheckedSeeds", {
		value = CheckboxMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_7 then
		CheckboxMountValidation.defaultCheckedSeeds = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(CheckboxMountValidation, "defaultCheckedSeeds", {
		value = CheckboxMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_8 then
		CheckboxMountValidation.defaultCheckedSeeds = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(CheckboxMountValidation, "defaultCheckedSeeds", {
		value = CheckboxMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_9 then
		CheckboxMountValidation.defaultCheckedSeeds = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(CheckboxMountValidation, "defaultCheckedSeeds", {
		value = CheckboxMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_10 then
		CheckboxMountValidation.defaultCheckedSeeds = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("Clicking a controlled Checkbox reports the flipped value but keeps showing the prop until it changes")
	local _descriptor_11 = Test(CheckboxMountValidation, "controlledClickReports", {
		value = CheckboxMountValidation.controlledClickReports,
	})
	if _descriptor_11 then
		CheckboxMountValidation.controlledClickReports = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_9(CheckboxMountValidation, "controlledClickReports", {
		value = CheckboxMountValidation.controlledClickReports,
	})
	if _descriptor_12 then
		CheckboxMountValidation.controlledClickReports = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_8(CheckboxMountValidation, "controlledClickReports", {
		value = CheckboxMountValidation.controlledClickReports,
	})
	if _descriptor_13 then
		CheckboxMountValidation.controlledClickReports = _descriptor_13.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Flipping a controlled checked prop re-renders the icon without calling onChange")
	local _descriptor_14 = Test(CheckboxMountValidation, "propChangeSilent", {
		value = CheckboxMountValidation.propChangeSilent,
	})
	if _descriptor_14 then
		CheckboxMountValidation.propChangeSilent = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_11(CheckboxMountValidation, "propChangeSilent", {
		value = CheckboxMountValidation.propChangeSilent,
	})
	if _descriptor_15 then
		CheckboxMountValidation.propChangeSilent = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(CheckboxMountValidation, "propChangeSilent", {
		value = CheckboxMountValidation.propChangeSilent,
	})
	if _descriptor_16 then
		CheckboxMountValidation.propChangeSilent = _descriptor_16.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_13 = DisplayName("Clicking an uncontrolled Checkbox flips its own state and reports each new value")
	local _descriptor_17 = Test(CheckboxMountValidation, "uncontrolledClickToggles", {
		value = CheckboxMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_17 then
		CheckboxMountValidation.uncontrolledClickToggles = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_13(CheckboxMountValidation, "uncontrolledClickToggles", {
		value = CheckboxMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_18 then
		CheckboxMountValidation.uncontrolledClickToggles = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_12(CheckboxMountValidation, "uncontrolledClickToggles", {
		value = CheckboxMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_19 then
		CheckboxMountValidation.uncontrolledClickToggles = _descriptor_19.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_15 = DisplayName("Firing the Fieldset labelActivated event toggles an uncontrolled checkbox on and reports true")
	local _descriptor_20 = Test(CheckboxMountValidation, "fieldsetLabelToggles", {
		value = CheckboxMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_20 then
		CheckboxMountValidation.fieldsetLabelToggles = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_15(CheckboxMountValidation, "fieldsetLabelToggles", {
		value = CheckboxMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_21 then
		CheckboxMountValidation.fieldsetLabelToggles = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_14(CheckboxMountValidation, "fieldsetLabelToggles", {
		value = CheckboxMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_22 then
		CheckboxMountValidation.fieldsetLabelToggles = _descriptor_22.value
	end
	local _decorator_16 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_17 = Each({ { "xs" }, { "xl" } })
	local _decorator_18 = DisplayName("The scale prop sizes the icon to the theme's iconSize entry for that scale")
	local _descriptor_23 = Test(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_23 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_18(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_24 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_17(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_25 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_16(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_26 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_26.value
	end
	CheckboxMountValidation = Tag("Studio")(CheckboxMountValidation) or CheckboxMountValidation
end
return CheckboxMountValidation
