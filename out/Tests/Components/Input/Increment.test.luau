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
local Increment = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Increment").Increment
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
	function IncrementMountValidation:seedsFromValue()
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
	function IncrementMountValidation:uncontrolledIgnoresProp()
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
	function IncrementMountValidation:controlledFollowsProp()
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
	function IncrementMountValidation:typingSkipsClamp()
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
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_1 = DisplayName("The TextBox shows the initial value prop as its text on first mount")
	local _descriptor = Test(IncrementMountValidation, "seedsFromValue", {
		value = IncrementMountValidation.seedsFromValue,
	})
	if _descriptor then
		IncrementMountValidation.seedsFromValue = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(IncrementMountValidation, "seedsFromValue", {
		value = IncrementMountValidation.seedsFromValue,
	})
	if _descriptor_1 then
		IncrementMountValidation.seedsFromValue = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(IncrementMountValidation, "seedsFromValue", {
		value = IncrementMountValidation.seedsFromValue,
	})
	if _descriptor_2 then
		IncrementMountValidation.seedsFromValue = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_3 = DisplayName("Re-rendering with a new value prop does not change the text when uncontrolled")
	local _descriptor_3 = Test(IncrementMountValidation, "uncontrolledIgnoresProp", {
		value = IncrementMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_3 then
		IncrementMountValidation.uncontrolledIgnoresProp = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(IncrementMountValidation, "uncontrolledIgnoresProp", {
		value = IncrementMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_4 then
		IncrementMountValidation.uncontrolledIgnoresProp = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(IncrementMountValidation, "uncontrolledIgnoresProp", {
		value = IncrementMountValidation.uncontrolledIgnoresProp,
	})
	if _descriptor_5 then
		IncrementMountValidation.uncontrolledIgnoresProp = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_5 = DisplayName("Re-rendering with a new value prop updates the text when controlled")
	local _descriptor_6 = Test(IncrementMountValidation, "controlledFollowsProp", {
		value = IncrementMountValidation.controlledFollowsProp,
	})
	if _descriptor_6 then
		IncrementMountValidation.controlledFollowsProp = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(IncrementMountValidation, "controlledFollowsProp", {
		value = IncrementMountValidation.controlledFollowsProp,
	})
	if _descriptor_7 then
		IncrementMountValidation.controlledFollowsProp = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(IncrementMountValidation, "controlledFollowsProp", {
		value = IncrementMountValidation.controlledFollowsProp,
	})
	if _descriptor_8 then
		IncrementMountValidation.controlledFollowsProp = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_7 = DisplayName("Typing a number above max fires onChange with the raw number and leaves the text unclamped while editing")
	local _descriptor_9 = Test(IncrementMountValidation, "typingSkipsClamp", {
		value = IncrementMountValidation.typingSkipsClamp,
	})
	if _descriptor_9 then
		IncrementMountValidation.typingSkipsClamp = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(IncrementMountValidation, "typingSkipsClamp", {
		value = IncrementMountValidation.typingSkipsClamp,
	})
	if _descriptor_10 then
		IncrementMountValidation.typingSkipsClamp = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(IncrementMountValidation, "typingSkipsClamp", {
		value = IncrementMountValidation.typingSkipsClamp,
	})
	if _descriptor_11 then
		IncrementMountValidation.typingSkipsClamp = _descriptor_11.value
	end
	IncrementMountValidation = Tag("Studio")(IncrementMountValidation) or IncrementMountValidation
end
return IncrementMountValidation
