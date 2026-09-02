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
local _binding = Decorators
local Skip = _binding.Skip
local Switch = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Switch").Switch
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
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
	function SwitchMountValidation:seedsCheckedStateFromInitialPropAndFiresOnMountWithIt()
		local host = Instance.new("Folder")
		local onChangeValues = {}
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch, {
			checked = true,
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		}))
		task.wait()
		Assert:deepEqual(onChangeValues, { true })
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted()
		local host = Instance.new("Folder")
		local onChangeValues = {}
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch, {
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		}))
		task.wait()
		Assert:deepEqual(onChangeValues, { false })
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:uncontrolledStateIgnoresSubsequentCheckedProp()
		local host = Instance.new("Folder")
		local onChangeValues = {}
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch, {
			checked = false,
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		}))
		task.wait()
		root:render(React.createElement(Switch, {
			checked = true,
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		}))
		task.wait()
		Assert:deepEqual(onChangeValues, { false })
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange()
		local host = Instance.new("Folder")
		local labelActivated = Instance.new("BindableEvent")
		local onChangeValues = {}
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(FieldsetContext.Provider, {
			value = {
				disabled = false,
				checkbox = false,
				labelActivated = labelActivated,
			},
		}, React.createElement(Switch, {
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		})))
		task.wait()
		labelActivated:Fire()
		do
			local attempt = 0
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					attempt += 1
				else
					_shouldIncrement = true
				end
				if not (attempt < 10 and #onChangeValues < 2) then
					break
				end
				task.wait()
			end
		end
		Assert:deepEqual(onChangeValues, { false, true })
		root:unmount()
		labelActivated:Destroy()
		host:Destroy()
	end
	function SwitchMountValidation:disabledSuppressesTheFieldsetLabelBridgeAndOnChange()
		local host = Instance.new("Folder")
		local labelActivated = Instance.new("BindableEvent")
		local onChangeValues = {}
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(FieldsetContext.Provider, {
			value = {
				disabled = false,
				checkbox = false,
				labelActivated = labelActivated,
			},
		}, React.createElement(Switch, {
			disabled = true,
			onChange = function(value)
				local _value = value
				table.insert(onChangeValues, _value)
			end,
		})))
		task.wait()
		labelActivated:Fire()
		for attempt = 0, 9 do
			task.wait()
		end
		Assert:deepEqual(onChangeValues, { false })
		root:unmount()
		labelActivated:Destroy()
		host:Destroy()
	end
	function SwitchMountValidation:disabledMarksTheTrackNonInteractive()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch, {
			disabled = true,
		}))
		task.wait()
		local track = host:FindFirstChildWhichIsA("ImageButton", true)
		Assert:notUndefined(track)
		Assert["false"](Assert, track.Active)
		Assert["false"](Assert, track.Selectable)
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:defaultsInstanceNameToSwitchWhenNamePropIsOmitted()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("Switch"))
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:namePropOverridesTheRenderedInstanceName()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch, {
			name = "MarketingOptIn",
		}))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("MarketingOptIn"))
		Assert:undefined(host:FindFirstChild("Switch"))
		root:unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor = Test(SwitchMountValidation, "seedsCheckedStateFromInitialPropAndFiresOnMountWithIt", {
		value = SwitchMountValidation.seedsCheckedStateFromInitialPropAndFiresOnMountWithIt,
	})
	if _descriptor then
		SwitchMountValidation.seedsCheckedStateFromInitialPropAndFiresOnMountWithIt = _descriptor.value
	end
	local _descriptor_1 = _decorator(SwitchMountValidation, "seedsCheckedStateFromInitialPropAndFiresOnMountWithIt", {
		value = SwitchMountValidation.seedsCheckedStateFromInitialPropAndFiresOnMountWithIt,
	})
	if _descriptor_1 then
		SwitchMountValidation.seedsCheckedStateFromInitialPropAndFiresOnMountWithIt = _descriptor_1.value
	end
	local _decorator_1 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_2 = Test(SwitchMountValidation, "defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted", {
		value = SwitchMountValidation.defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted,
	})
	if _descriptor_2 then
		SwitchMountValidation.defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(SwitchMountValidation, "defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted", {
		value = SwitchMountValidation.defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted,
	})
	if _descriptor_3 then
		SwitchMountValidation.defaultsToUncheckedAndFiresOnMountWithFalseWhenCheckedPropIsOmitted = _descriptor_3.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_4 = Test(SwitchMountValidation, "uncontrolledStateIgnoresSubsequentCheckedProp", {
		value = SwitchMountValidation.uncontrolledStateIgnoresSubsequentCheckedProp,
	})
	if _descriptor_4 then
		SwitchMountValidation.uncontrolledStateIgnoresSubsequentCheckedProp = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(SwitchMountValidation, "uncontrolledStateIgnoresSubsequentCheckedProp", {
		value = SwitchMountValidation.uncontrolledStateIgnoresSubsequentCheckedProp,
	})
	if _descriptor_5 then
		SwitchMountValidation.uncontrolledStateIgnoresSubsequentCheckedProp = _descriptor_5.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_6 = Test(SwitchMountValidation, "activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange", {
		value = SwitchMountValidation.activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange,
	})
	if _descriptor_6 then
		SwitchMountValidation.activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(SwitchMountValidation, "activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange", {
		value = SwitchMountValidation.activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange,
	})
	if _descriptor_7 then
		SwitchMountValidation.activatingAPairedFieldsetLabelTogglesCheckedAndFiresOnChange = _descriptor_7.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_8 = Test(SwitchMountValidation, "disabledSuppressesTheFieldsetLabelBridgeAndOnChange", {
		value = SwitchMountValidation.disabledSuppressesTheFieldsetLabelBridgeAndOnChange,
	})
	if _descriptor_8 then
		SwitchMountValidation.disabledSuppressesTheFieldsetLabelBridgeAndOnChange = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(SwitchMountValidation, "disabledSuppressesTheFieldsetLabelBridgeAndOnChange", {
		value = SwitchMountValidation.disabledSuppressesTheFieldsetLabelBridgeAndOnChange,
	})
	if _descriptor_9 then
		SwitchMountValidation.disabledSuppressesTheFieldsetLabelBridgeAndOnChange = _descriptor_9.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_10 = Test(SwitchMountValidation, "disabledMarksTheTrackNonInteractive", {
		value = SwitchMountValidation.disabledMarksTheTrackNonInteractive,
	})
	if _descriptor_10 then
		SwitchMountValidation.disabledMarksTheTrackNonInteractive = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(SwitchMountValidation, "disabledMarksTheTrackNonInteractive", {
		value = SwitchMountValidation.disabledMarksTheTrackNonInteractive,
	})
	if _descriptor_11 then
		SwitchMountValidation.disabledMarksTheTrackNonInteractive = _descriptor_11.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_12 = Test(SwitchMountValidation, "defaultsInstanceNameToSwitchWhenNamePropIsOmitted", {
		value = SwitchMountValidation.defaultsInstanceNameToSwitchWhenNamePropIsOmitted,
	})
	if _descriptor_12 then
		SwitchMountValidation.defaultsInstanceNameToSwitchWhenNamePropIsOmitted = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(SwitchMountValidation, "defaultsInstanceNameToSwitchWhenNamePropIsOmitted", {
		value = SwitchMountValidation.defaultsInstanceNameToSwitchWhenNamePropIsOmitted,
	})
	if _descriptor_13 then
		SwitchMountValidation.defaultsInstanceNameToSwitchWhenNamePropIsOmitted = _descriptor_13.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_14 = Test(SwitchMountValidation, "namePropOverridesTheRenderedInstanceName", {
		value = SwitchMountValidation.namePropOverridesTheRenderedInstanceName,
	})
	if _descriptor_14 then
		SwitchMountValidation.namePropOverridesTheRenderedInstanceName = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(SwitchMountValidation, "namePropOverridesTheRenderedInstanceName", {
		value = SwitchMountValidation.namePropOverridesTheRenderedInstanceName,
	})
	if _descriptor_15 then
		SwitchMountValidation.namePropOverridesTheRenderedInstanceName = _descriptor_15.value
	end
	SwitchMountValidation = Tag("Studio")(SwitchMountValidation) or SwitchMountValidation
end
return SwitchMountValidation
