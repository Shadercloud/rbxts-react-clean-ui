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
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertAlignedRight = _layout.assertAlignedRight
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local function waitForIncrementWidth(host, expected)
	return waitForGuiObject(host, "Increment", function(gui)
		return math.abs(gui.AbsoluteSize.X - expected) <= 1 and gui.AbsoluteSize.Y > 0
	end, `Timed out waiting for the Increment root to be {expected}px wide`)
end
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
	function IncrementMountValidation:fixedWidth()
		withMounted(400, 200, React.createElement(Increment, {
			value = 5,
			width = 200,
		}), function(mounted)
			local increment = waitForIncrementWidth(mounted.host, 200)
			local plus = waitForGuiObject(increment, "IncrementButton")
			assertSizeApprox(increment, 200, nil, 1, "width=200 increment")
			assertAlignedRight(plus, increment, 1, "width=200 plus button")
		end)
	end
	function IncrementMountValidation:fullWidthDefault()
		withMounted(400, 200, React.createElement(Increment, {
			value = 5,
		}), function(mounted)
			local increment = waitForIncrementWidth(mounted.host, 400)
			assertSizeApprox(increment, 400, nil, 1, "unset width increment")
		end)
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
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = DisplayName("width={200} pins the stepper to 200px and the plus button still ends at its right edge")
	local _descriptor_12 = Test(IncrementMountValidation, "fixedWidth", {
		value = IncrementMountValidation.fixedWidth,
	})
	if _descriptor_12 then
		IncrementMountValidation.fixedWidth = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(IncrementMountValidation, "fixedWidth", {
		value = IncrementMountValidation.fixedWidth,
	})
	if _descriptor_13 then
		IncrementMountValidation.fixedWidth = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(IncrementMountValidation, "fixedWidth", {
		value = IncrementMountValidation.fixedWidth,
	})
	if _descriptor_14 then
		IncrementMountValidation.fixedWidth = _descriptor_14.value
	end
	local _decorator_10 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_11 = DisplayName("Without width the stepper stretches to the full width of its parent")
	local _descriptor_15 = Test(IncrementMountValidation, "fullWidthDefault", {
		value = IncrementMountValidation.fullWidthDefault,
	})
	if _descriptor_15 then
		IncrementMountValidation.fullWidthDefault = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_11(IncrementMountValidation, "fullWidthDefault", {
		value = IncrementMountValidation.fullWidthDefault,
	})
	if _descriptor_16 then
		IncrementMountValidation.fullWidthDefault = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_10(IncrementMountValidation, "fullWidthDefault", {
		value = IncrementMountValidation.fullWidthDefault,
	})
	if _descriptor_17 then
		IncrementMountValidation.fullWidthDefault = _descriptor_17.value
	end
	IncrementMountValidation = Tag("Studio")(IncrementMountValidation) or IncrementMountValidation
end
return IncrementMountValidation
