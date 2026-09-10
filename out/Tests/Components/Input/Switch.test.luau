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
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Switch = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Switch").Switch
local FieldsetContext = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").FieldsetContext
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
	function SwitchMountValidation:seedsFromChecked()
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
	function SwitchMountValidation:defaultsUnchecked()
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
	function SwitchMountValidation:uncontrolledIgnoresProp()
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
	function SwitchMountValidation:labelToggles()
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
	function SwitchMountValidation:disabledIgnoresLabel()
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
	function SwitchMountValidation:disabledTrackInert()
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
	function SwitchMountValidation:defaultName()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Switch))
		task.wait()
		Assert:notUndefined(host:FindFirstChild("Switch"))
		root:unmount()
		host:Destroy()
	end
	function SwitchMountValidation:customName()
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
	local _decorator_1 = DisplayName("Mounting with checked={true} fires onChange exactly once with true")
	local _descriptor = Test(SwitchMountValidation, "seedsFromChecked", {
		value = SwitchMountValidation.seedsFromChecked,
	})
	if _descriptor then
		SwitchMountValidation.seedsFromChecked = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SwitchMountValidation, "seedsFromChecked", {
		value = SwitchMountValidation.seedsFromChecked,
	})
	if _descriptor_1 then
		SwitchMountValidation.seedsFromChecked = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SwitchMountValidation, "seedsFromChecked", {
		value = SwitchMountValidation.seedsFromChecked,
	})
	if _descriptor_2 then
		SwitchMountValidation.seedsFromChecked = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_3 = DisplayName("Mounting without a checked prop fires onChange exactly once with false")
	local _descriptor_3 = Test(SwitchMountValidation, "defaultsUnchecked", {
		value = SwitchMountValidation.defaultsUnchecked,
	})
	if _descriptor_3 then
		SwitchMountValidation.defaultsUnchecked = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(SwitchMountValidation, "defaultsUnchecked", {
		value = SwitchMountValidation.defaultsUnchecked,
	})
	if _descriptor_4 then
		SwitchMountValidation.defaultsUnchecked = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(SwitchMountValidation, "defaultsUnchecked", {
		value = SwitchMountValidation.defaultsUnchecked,
	})
	if _descriptor_5 then
		SwitchMountValidation.defaultsUnchecked = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_5 = DisplayName("Re-rendering with a flipped checked prop does not fire onChange again when uncontrolled")
	local _descriptor_6 = Test(SwitchMountValidation, "uncontrolledIgnoresProp", {
		value = SwitchMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_6 then
		SwitchMountValidation.uncontrolledIgnoresProp = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(SwitchMountValidation, "uncontrolledIgnoresProp", {
		value = SwitchMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_7 then
		SwitchMountValidation.uncontrolledIgnoresProp = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(SwitchMountValidation, "uncontrolledIgnoresProp", {
		value = SwitchMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_8 then
		SwitchMountValidation.uncontrolledIgnoresProp = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_7 = DisplayName("Firing the Fieldset labelActivated event flips the switch and fires onChange with the new state")
	local _descriptor_9 = Test(SwitchMountValidation, "labelToggles", {
		value = SwitchMountValidation.labelToggles,
	})
	if _descriptor_9 then
		SwitchMountValidation.labelToggles = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(SwitchMountValidation, "labelToggles", {
		value = SwitchMountValidation.labelToggles,
	})
	if _descriptor_10 then
		SwitchMountValidation.labelToggles = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(SwitchMountValidation, "labelToggles", {
		value = SwitchMountValidation.labelToggles,
	})
	if _descriptor_11 then
		SwitchMountValidation.labelToggles = _descriptor_11.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_9 = DisplayName("A disabled switch ignores the Fieldset labelActivated event and never fires onChange beyond mount")
	local _descriptor_12 = Test(SwitchMountValidation, "disabledIgnoresLabel", {
		value = SwitchMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_12 then
		SwitchMountValidation.disabledIgnoresLabel = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(SwitchMountValidation, "disabledIgnoresLabel", {
		value = SwitchMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_13 then
		SwitchMountValidation.disabledIgnoresLabel = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(SwitchMountValidation, "disabledIgnoresLabel", {
		value = SwitchMountValidation.disabledIgnoresLabel,
	})
	if _descriptor_14 then
		SwitchMountValidation.disabledIgnoresLabel = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_11 = DisplayName("A disabled switch renders its track ImageButton with Active and Selectable both false")
	local _descriptor_15 = Test(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_15 then
		SwitchMountValidation.disabledTrackInert = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_16 then
		SwitchMountValidation.disabledTrackInert = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(SwitchMountValidation, "disabledTrackInert", {
		value = SwitchMountValidation.disabledTrackInert,
	})
	if _descriptor_17 then
		SwitchMountValidation.disabledTrackInert = _descriptor_17.value
	end
	local _decorator_12 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_13 = DisplayName('The root instance is named \"Switch\" when no name prop is given')
	local _descriptor_18 = Test(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_18 then
		SwitchMountValidation.defaultName = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_13(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_19 then
		SwitchMountValidation.defaultName = _descriptor_19.value
	end
	local _descriptor_20 = _decorator_12(SwitchMountValidation, "defaultName", {
		value = SwitchMountValidation.defaultName,
	})
	if _descriptor_20 then
		SwitchMountValidation.defaultName = _descriptor_20.value
	end
	local _decorator_14 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_15 = DisplayName('Passing a name prop renames the root instance and no \"Switch\" child remains')
	local _descriptor_21 = Test(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_21 then
		SwitchMountValidation.customName = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_15(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_22 then
		SwitchMountValidation.customName = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_14(SwitchMountValidation, "customName", {
		value = SwitchMountValidation.customName,
	})
	if _descriptor_23 then
		SwitchMountValidation.customName = _descriptor_23.value
	end
	SwitchMountValidation = Tag("Studio")(SwitchMountValidation) or SwitchMountValidation
end
return SwitchMountValidation
