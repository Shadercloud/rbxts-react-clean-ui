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
local Increment = TS.import(script, script.Parent.Parent.Parent, "Components", "Input", "Increment").Increment
local IncrementMountValidation
do
	IncrementMountValidation = setmetatable({}, {
		__tostring = function()
			return "IncrementMountValidation"
		end,
	})
	IncrementMountValidation.__index = IncrementMountValidation
	function IncrementMountValidation.new(...)
		local self = setmetatable({}, IncrementMountValidation)
		return self:constructor(...) or self
	end
	function IncrementMountValidation:constructor()
	end
	function IncrementMountValidation:seedsDisplayedTextFromInitialValueWhenUncontrolled()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Increment, {
			value = 5,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		Assert:equal(textBox.Text, "5")
		root:unmount()
		host:Destroy()
	end
	function IncrementMountValidation:uncontrolledStateIgnoresSubsequentValueProps()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Increment, {
			value = 5,
		}))
		task.wait()
		root:render(React.createElement(Increment, {
			value = 8,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		Assert:equal(textBox.Text, "5")
		root:unmount()
		host:Destroy()
	end
	function IncrementMountValidation:controlledStateReflectsUpdatedValueProp()
		local host = Instance.new("Folder")
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Increment, {
			value = 5,
			controlled = true,
		}))
		task.wait()
		root:render(React.createElement(Increment, {
			value = 8,
			controlled = true,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		Assert:equal(textBox.Text, "8")
		root:unmount()
		host:Destroy()
	end
	function IncrementMountValidation:typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit()
		local host = Instance.new("Folder")
		local latestOnChangeValue
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Increment, {
			value = 5,
			min = 0,
			max = 10,
			onChange = function(value)
				latestOnChangeValue = value
			end,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		textBox.Text = "50"
		task.wait()
		Assert:equal(latestOnChangeValue, 50)
		Assert:equal(textBox.Text, "50")
		root:unmount()
		host:Destroy()
	end
	function IncrementMountValidation:outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange()
		local host = Instance.new("Folder")
		local latestOnChangeValue
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(Increment, {
			value = 5,
			min = 0,
			max = 10,
			onChange = function(value)
				latestOnChangeValue = value
			end,
		}))
		task.wait()
		local textBox = host:FindFirstChildWhichIsA("TextBox", true)
		Assert:notUndefined(textBox)
		textBox.Text = "50"
		task.wait()
		textBox:CaptureFocus()
		textBox:ReleaseFocus(true)
		task.wait()
		Assert:equal(latestOnChangeValue, 10)
		Assert:equal(textBox.Text, "10")
		root:unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor = Test(IncrementMountValidation, "seedsDisplayedTextFromInitialValueWhenUncontrolled", {
		value = IncrementMountValidation.seedsDisplayedTextFromInitialValueWhenUncontrolled,
	})
	if _descriptor then
		IncrementMountValidation.seedsDisplayedTextFromInitialValueWhenUncontrolled = _descriptor.value
	end
	local _descriptor_1 = _decorator(IncrementMountValidation, "seedsDisplayedTextFromInitialValueWhenUncontrolled", {
		value = IncrementMountValidation.seedsDisplayedTextFromInitialValueWhenUncontrolled,
	})
	if _descriptor_1 then
		IncrementMountValidation.seedsDisplayedTextFromInitialValueWhenUncontrolled = _descriptor_1.value
	end
	local _decorator_1 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_2 = Test(IncrementMountValidation, "uncontrolledStateIgnoresSubsequentValueProps", {
		value = IncrementMountValidation.uncontrolledStateIgnoresSubsequentValueProps,
	})
	if _descriptor_2 then
		IncrementMountValidation.uncontrolledStateIgnoresSubsequentValueProps = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(IncrementMountValidation, "uncontrolledStateIgnoresSubsequentValueProps", {
		value = IncrementMountValidation.uncontrolledStateIgnoresSubsequentValueProps,
	})
	if _descriptor_3 then
		IncrementMountValidation.uncontrolledStateIgnoresSubsequentValueProps = _descriptor_3.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_4 = Test(IncrementMountValidation, "controlledStateReflectsUpdatedValueProp", {
		value = IncrementMountValidation.controlledStateReflectsUpdatedValueProp,
	})
	if _descriptor_4 then
		IncrementMountValidation.controlledStateReflectsUpdatedValueProp = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(IncrementMountValidation, "controlledStateReflectsUpdatedValueProp", {
		value = IncrementMountValidation.controlledStateReflectsUpdatedValueProp,
	})
	if _descriptor_5 then
		IncrementMountValidation.controlledStateReflectsUpdatedValueProp = _descriptor_5.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_6 = Test(IncrementMountValidation, "typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit", {
		value = IncrementMountValidation.typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit,
	})
	if _descriptor_6 then
		IncrementMountValidation.typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(IncrementMountValidation, "typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit", {
		value = IncrementMountValidation.typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit,
	})
	if _descriptor_7 then
		IncrementMountValidation.typingAValidNumberForwardsItAsANumberWithoutClampingMidEdit = _descriptor_7.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _descriptor_8 = Test(IncrementMountValidation, "outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange", {
		value = IncrementMountValidation.outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange,
	})
	if _descriptor_8 then
		IncrementMountValidation.outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(IncrementMountValidation, "outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange", {
		value = IncrementMountValidation.outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange,
	})
	if _descriptor_9 then
		IncrementMountValidation.outOfRangeValueIsClampedOnFocusLossAndReportedViaOnChange = _descriptor_9.value
	end
	IncrementMountValidation = Tag("Studio")(IncrementMountValidation) or IncrementMountValidation
end
return IncrementMountValidation
