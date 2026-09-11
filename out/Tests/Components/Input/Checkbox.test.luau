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
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAllDescendantsContained = _layout.assertAllDescendantsContained
local assertNonZeroSize = _layout.assertNonZeroSize
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local function waitForCheckbox(host)
	return waitForGuiObject(host, "Checkbox")
end
local function findIcon(checkbox)
	return findDescendant(checkbox, "CheckboxIcon")
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
	function CheckboxMountValidation:seedsFromChecked(variant, checked)
		local onChangeValues = {}
		withMounted(200, 200, React.createElement(Checkbox, {
			checked = checked,
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		}), function(mounted)
			local checkbox = waitForCheckbox(mounted.host)
			local icon = findIcon(checkbox)
			Assert:deepEqual(onChangeValues, { checked })
			Assert:equal(icon.Image ~= "", checked, `{variant}: expected CheckboxIcon.Image to be {if checked then "set" else "empty"}, got "{icon.Image}"`)
		end)
	end
	function CheckboxMountValidation:labelToggles()
		local labelActivated = Instance.new("BindableEvent")
		local onChangeValues = {}
		TS.try(function()
			withMounted(200, 200, React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = true,
					labelActivated = labelActivated,
				},
			}, React.createElement(Checkbox, {
				onChange = function(value)
					local _value = value
					table.insert(onChangeValues, _value)
				end,
			})), function(mounted)
				local checkbox = waitForCheckbox(mounted.host)
				local icon = findIcon(checkbox)
				Assert:deepEqual(onChangeValues, { false })
				Assert:equal(icon.Image, "", "Expected no icon image before the label is activated")
				labelActivated:Fire()
				waitForLayout(function()
					return if #onChangeValues >= 2 then true else nil
				end, "Timed out waiting for onChange to fire after labelActivated")
				Assert:deepEqual(onChangeValues, { false, true })
				Assert["true"](Assert, icon.Image ~= "", "Expected the check icon to render once toggled on")
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
	local _decorator_4 = DisplayName("Mounting fires onChange exactly once with the seeded checked value, and only the checked state shows an icon image")
	local _descriptor_3 = Test(CheckboxMountValidation, "seedsFromChecked", {
		value = CheckboxMountValidation.seedsFromChecked,
	})
	if _descriptor_3 then
		CheckboxMountValidation.seedsFromChecked = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(CheckboxMountValidation, "seedsFromChecked", {
		value = CheckboxMountValidation.seedsFromChecked,
	})
	if _descriptor_4 then
		CheckboxMountValidation.seedsFromChecked = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(CheckboxMountValidation, "seedsFromChecked", {
		value = CheckboxMountValidation.seedsFromChecked,
	})
	if _descriptor_5 then
		CheckboxMountValidation.seedsFromChecked = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(CheckboxMountValidation, "seedsFromChecked", {
		value = CheckboxMountValidation.seedsFromChecked,
	})
	if _descriptor_6 then
		CheckboxMountValidation.seedsFromChecked = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Firing the Fieldset labelActivated event toggles the checkbox on, firing onChange with true and showing the check icon")
	local _descriptor_7 = Test(CheckboxMountValidation, "labelToggles", {
		value = CheckboxMountValidation.labelToggles,
	})
	if _descriptor_7 then
		CheckboxMountValidation.labelToggles = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(CheckboxMountValidation, "labelToggles", {
		value = CheckboxMountValidation.labelToggles,
	})
	if _descriptor_8 then
		CheckboxMountValidation.labelToggles = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(CheckboxMountValidation, "labelToggles", {
		value = CheckboxMountValidation.labelToggles,
	})
	if _descriptor_9 then
		CheckboxMountValidation.labelToggles = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = Each({ { "xs" }, { "xl" } })
	local _decorator_9 = DisplayName("The scale prop sizes the icon to the theme's iconSize entry for that scale")
	local _descriptor_10 = Test(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_10 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_9(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_11 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_12 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(CheckboxMountValidation, "scaleSizesIcon", {
		value = CheckboxMountValidation.scaleSizesIcon,
	})
	if _descriptor_13 then
		CheckboxMountValidation.scaleSizesIcon = _descriptor_13.value
	end
	CheckboxMountValidation = Tag("Studio")(CheckboxMountValidation) or CheckboxMountValidation
end
return CheckboxMountValidation
