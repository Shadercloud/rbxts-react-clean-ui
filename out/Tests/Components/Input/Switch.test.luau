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
local Switch = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Switch").Switch
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
local SizeHelper = TS.import(script, script.Parent.Parent.Parent.Parent, "Helpers").SizeHelper
local ThemeProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "theme.provider").ThemeProvider
local _Theme = TS.import(script, script.Parent.Parent.Parent.Parent, "Theme")
local DefaultTheme = _Theme.DefaultTheme
local extendTheme = _Theme.extendTheme
local activateButton = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").activateButton
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local SNAP_THEME = extendTheme(DefaultTheme, {
	components = {
		switch = {
			animation = {
				duration = 0,
			},
		},
	},
})
local switchTheme = SNAP_THEME.components.switch
local inset = SizeHelper:toUDim(switchTheme.thumb.inset).Offset
local THUMB_OFF_X = inset
local THUMB_ON_X = SizeHelper:toUDim(switchTheme.width).Offset - inset - (SizeHelper:toUDim(switchTheme.height).Offset - inset * 2)
local function snapSwitch(props)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	return React.createElement(ThemeProvider, {
		theme = SNAP_THEME,
	}, React.createElement(Switch, _attributes))
end
local function recorder(values)
	return function(value)
		local _values = values
		local _value = value
		table.insert(_values, _value)
	end
end
local function checkedFor(label)
	return if label == "on" then true elseif label == "off" then false else nil
end
local function waitForSwitch(host, name)
	if name == nil then
		name = "Switch"
	end
	return waitForGuiObject(host, name)
end
local function assertThumb(track, on, label)
	local thumb = track:FindFirstChild("Thumb")
	Assert:notUndefined(thumb, `{label}: expected a Thumb frame inside the track`)
	local expected = if on then THUMB_ON_X else THUMB_OFF_X
	Assert["true"](Assert, math.abs(thumb.Position.X.Offset - expected) <= 0.5, `{label}: expected the thumb {if on then "on" else "off"} at X offset {expected}, got {thumb.Position.X.Offset}`)
end
local SwitchMountValidation
do
	SwitchMountValidation = setmetatable({}, {
		__tostring = function()
			return "SwitchMountValidation"
		end,
	})
	SwitchMountValidation.__index = SwitchMountValidation
	function SwitchMountValidation.new(...)
		local self = setmetatable({}, SwitchMountValidation)
		return self:constructor(...) or self
	end
	function SwitchMountValidation:constructor()
	end
	function SwitchMountValidation:silentMount(label)
		local values = {}
		local checked = checkedFor(label)
		withMounted(200, 100, snapSwitch({
			checked = checked,
			onChange = recorder(values),
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			settleFrames(3)
			Assert:deepEqual(values, {}, `{label}: expected no onChange on mount`)
			assertThumb(track, checked == true, label)
		end)
	end
	function SwitchMountValidation:defaultCheckedSeeds()
		local values = {}
		withMounted(200, 100, snapSwitch({
			defaultChecked = true,
			onChange = recorder(values),
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			settleFrames(3)
			Assert:deepEqual(values, {})
			assertThumb(track, true, "defaultChecked")
		end)
	end
	function SwitchMountValidation:controlledClickReports()
		local values = {}
		withMounted(200, 100, snapSwitch({
			checked = false,
			onChange = recorder(values),
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			activateButton(mounted, track)
			settleFrames(3)
			Assert:deepEqual(values, { true })
			assertThumb(track, false, "after click, before the prop changes")
			mounted.update(snapSwitch({
				checked = true,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertThumb(track, true, "after the prop changes")
			Assert:deepEqual(values, { true }, "Expected the prop change not to call onChange")
		end)
	end
	function SwitchMountValidation:propChangeSilent()
		local values = {}
		withMounted(200, 100, snapSwitch({
			checked = false,
			onChange = recorder(values),
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			mounted.update(snapSwitch({
				checked = true,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertThumb(track, true, "checked prop on")
			mounted.update(snapSwitch({
				checked = false,
				onChange = recorder(values),
			}))
			settleFrames(2)
			assertThumb(track, false, "checked prop off")
			Assert:deepEqual(values, {})
		end)
	end
	function SwitchMountValidation:uncontrolledClickToggles()
		local values = {}
		withMounted(200, 100, snapSwitch({
			onChange = recorder(values),
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			activateButton(mounted, track)
			settleFrames(1)
			Assert:deepEqual(values, { true })
			assertThumb(track, true, "after first click")
			activateButton(mounted, track)
			settleFrames(1)
			Assert:deepEqual(values, { true, false })
			assertThumb(track, false, "after second click")
		end)
	end
	function SwitchMountValidation:fieldsetLabelToggles()
		local labelActivated = Instance.new("BindableEvent")
		local values = {}
		TS.try(function()
			withMounted(200, 100, React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = false,
					labelActivated = labelActivated,
				},
			}, snapSwitch({
				onChange = recorder(values),
			})), function(mounted)
				local track = waitForSwitch(mounted.host)
				settleFrames(2)
				labelActivated:Fire()
				waitForLayout(function()
					return if #values >= 1 then true else nil
				end, "Timed out waiting for onChange to fire after labelActivated")
				settleFrames(1)
				Assert:deepEqual(values, { true })
				assertThumb(track, true, "after labelActivated")
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	function SwitchMountValidation:disabledBlocksToggle()
		local labelActivated = Instance.new("BindableEvent")
		local values = {}
		TS.try(function()
			withMounted(200, 100, React.createElement(FieldsetContext.Provider, {
				value = {
					disabled = false,
					checkbox = false,
					labelActivated = labelActivated,
				},
			}, snapSwitch({
				disabled = true,
				onChange = recorder(values),
			})), function(mounted)
				local track = waitForSwitch(mounted.host)
				activateButton(mounted, track)
				labelActivated:Fire()
				settleFrames(5)
				Assert:deepEqual(values, {})
				assertThumb(track, false, "disabled after click and label")
			end)
		end, nil, function()
			labelActivated:Destroy()
		end)
	end
	function SwitchMountValidation:disabledTrackInert()
		withMounted(200, 100, snapSwitch({
			disabled = true,
		}), function(mounted)
			local track = waitForSwitch(mounted.host)
			Assert["false"](Assert, track.Active)
			Assert["false"](Assert, track.Selectable)
		end)
	end
	function SwitchMountValidation:layoutOrderForwarded()
		withMounted(200, 100, snapSwitch({
			LayoutOrder = 3,
		}), function(mounted)
			Assert:equal(waitForSwitch(mounted.host).LayoutOrder, 3)
			mounted.update(snapSwitch({}))
			Assert:equal(waitForSwitch(mounted.host).LayoutOrder, 0)
		end)
	end
	function SwitchMountValidation:defaultName()
		withMounted(200, 100, snapSwitch({}), function(mounted)
			Assert:notUndefined(mounted.host:FindFirstChild("Switch"))
		end)
	end
	function SwitchMountValidation:customName()
		withMounted(200, 100, snapSwitch({
			name = "MarketingOptIn",
		}), function(mounted)
			waitForSwitch(mounted.host, "MarketingOptIn")
			Assert:undefined(mounted.host:FindFirstChild("Switch"))
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "on" }, { "off" }, { "unset" } })
	local _decorator_2 = DisplayName("Mounting never calls onChange, whether checked is true, false or left unset")
	local _descriptor = Test(SwitchMountValidation, "silentMount", {
		value = SwitchMountValidation.silentMount,
	})
	if _descriptor then
		SwitchMountValidation.silentMount = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(SwitchMountValidation, "silentMount", {
		value = SwitchMountValidation.silentMount,
	})
	if _descriptor_1 then
		SwitchMountValidation.silentMount = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(SwitchMountValidation, "silentMount", {
		value = SwitchMountValidation.silentMount,
	})
	if _descriptor_2 then
		SwitchMountValidation.silentMount = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(SwitchMountValidation, "silentMount", {
		value = SwitchMountValidation.silentMount,
	})
	if _descriptor_3 then
		SwitchMountValidation.silentMount = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("An uncontrolled switch with defaultChecked starts on without calling onChange")
	local _descriptor_4 = Test(SwitchMountValidation, "defaultCheckedSeeds", {
		value = SwitchMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_4 then
		SwitchMountValidation.defaultCheckedSeeds = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(SwitchMountValidation, "defaultCheckedSeeds", {
		value = SwitchMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_5 then
		SwitchMountValidation.defaultCheckedSeeds = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(SwitchMountValidation, "defaultCheckedSeeds", {
		value = SwitchMountValidation.defaultCheckedSeeds,
	})
	if _descriptor_6 then
		SwitchMountValidation.defaultCheckedSeeds = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Clicking a controlled switch reports the flipped value but the thumb waits for the prop to change")
	local _descriptor_7 = Test(SwitchMountValidation, "controlledClickReports", {
		value = SwitchMountValidation.controlledClickReports,
	})
	if _descriptor_7 then
		SwitchMountValidation.controlledClickReports = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(SwitchMountValidation, "controlledClickReports", {
		value = SwitchMountValidation.controlledClickReports,
	})
	if _descriptor_8 then
		SwitchMountValidation.controlledClickReports = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(SwitchMountValidation, "controlledClickReports", {
		value = SwitchMountValidation.controlledClickReports,
	})
	if _descriptor_9 then
		SwitchMountValidation.controlledClickReports = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Flipping a controlled checked prop moves the thumb without calling onChange")
	local _descriptor_10 = Test(SwitchMountValidation, "propChangeSilent", {
		value = SwitchMountValidation.propChangeSilent,
	})
	if _descriptor_10 then
		SwitchMountValidation.propChangeSilent = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(SwitchMountValidation, "propChangeSilent", {
		value = SwitchMountValidation.propChangeSilent,
	})
	if _descriptor_11 then
		SwitchMountValidation.propChangeSilent = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(SwitchMountValidation, "propChangeSilent", {
		value = SwitchMountValidation.propChangeSilent,
	})
	if _descriptor_12 then
		SwitchMountValidation.propChangeSilent = _descriptor_12.value
	end
	local _decorator_9 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_10 = DisplayName("Clicking an uncontrolled switch flips its own state and reports each new value")
	local _descriptor_13 = Test(SwitchMountValidation, "uncontrolledClickToggles", {
		value = SwitchMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_13 then
		SwitchMountValidation.uncontrolledClickToggles = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_10(SwitchMountValidation, "uncontrolledClickToggles", {
		value = SwitchMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_14 then
		SwitchMountValidation.uncontrolledClickToggles = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_9(SwitchMountValidation, "uncontrolledClickToggles", {
		value = SwitchMountValidation.uncontrolledClickToggles,
	})
	if _descriptor_15 then
		SwitchMountValidation.uncontrolledClickToggles = _descriptor_15.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Firing the Fieldset labelActivated event turns an uncontrolled switch on and reports true")
	local _descriptor_16 = Test(SwitchMountValidation, "fieldsetLabelToggles", {
		value = SwitchMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_16 then
		SwitchMountValidation.fieldsetLabelToggles = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_12(SwitchMountValidation, "fieldsetLabelToggles", {
		value = SwitchMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_17 then
		SwitchMountValidation.fieldsetLabelToggles = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_11(SwitchMountValidation, "fieldsetLabelToggles", {
		value = SwitchMountValidation.fieldsetLabelToggles,
	})
	if _descriptor_18 then
		SwitchMountValidation.fieldsetLabelToggles = _descriptor_18.value
	end
	local _decorator_13 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_14 = DisplayName("A disabled switch ignores both a click and the Fieldset labelActivated event")
	local _descriptor_19 = Test(SwitchMountValidation, "disabledBlocksToggle", {
		value = SwitchMountValidation.disabledBlocksToggle,
	})
	if _descriptor_19 then
		SwitchMountValidation.disabledBlocksToggle = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_14(SwitchMountValidation, "disabledBlocksToggle", {
		value = SwitchMountValidation.disabledBlocksToggle,
	})
	if _descriptor_20 then
		SwitchMountValidation.disabledBlocksToggle = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_13(SwitchMountValidation, "disabledBlocksToggle", {
		value = SwitchMountValidation.disabledBlocksToggle,
	})
	if _descriptor_21 then
		SwitchMountValidation.disabledBlocksToggle = _descriptor_21.value
	end
	local _decorator_15 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_16 = DisplayName("A disabled switch renders its track ImageButton with Active and Selectable both false")
	local _descriptor_22 = Test(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_22 then
		SwitchMountValidation.disabledTrackInert = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_16(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_23 then
		SwitchMountValidation.disabledTrackInert = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_15(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_24 then
		SwitchMountValidation.disabledTrackInert = _descriptor_24.value
	end
	local _decorator_17 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_18 = DisplayName("LayoutOrder reaches the root track, and leaving it unset keeps the engine default of 0")
	local _descriptor_25 = Test(SwitchMountValidation, "layoutOrderForwarded", {
		value = SwitchMountValidation.layoutOrderForwarded,
	})
	if _descriptor_25 then
		SwitchMountValidation.layoutOrderForwarded = _descriptor_25.value
	end
	local _descriptor_26 = _decorator_18(SwitchMountValidation, "layoutOrderForwarded", {
		value = SwitchMountValidation.layoutOrderForwarded,
	})
	if _descriptor_26 then
		SwitchMountValidation.layoutOrderForwarded = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_17(SwitchMountValidation, "layoutOrderForwarded", {
		value = SwitchMountValidation.layoutOrderForwarded,
	})
	if _descriptor_27 then
		SwitchMountValidation.layoutOrderForwarded = _descriptor_27.value
	end
	local _decorator_19 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_20 = DisplayName('The root instance is named \"Switch\" when no name prop is given')
	local _descriptor_28 = Test(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_28 then
		SwitchMountValidation.defaultName = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_20(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_29 then
		SwitchMountValidation.defaultName = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_19(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_30 then
		SwitchMountValidation.defaultName = _descriptor_30.value
	end
	local _decorator_21 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_22 = DisplayName('Passing a name prop renames the root instance and no \"Switch\" child remains')
	local _descriptor_31 = Test(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_31 then
		SwitchMountValidation.customName = _descriptor_31.value
	end
	local _descriptor_32 = _decorator_22(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_32 then
		SwitchMountValidation.customName = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_21(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_33 then
		SwitchMountValidation.customName = _descriptor_33.value
	end
	SwitchMountValidation = Tag("Studio")(SwitchMountValidation) or SwitchMountValidation
end
return SwitchMountValidation
