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
local Button = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Button").Button
local HStack = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout").HStack
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertCenteredIn = _layout.assertCenteredIn
local assertSizeApprox = _layout.assertSizeApprox
local rect = _layout.rect
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local FILL_NAMES = { "FillShort", "FillMedium", "FillLong" }
local FILL_LABELS = { "A", "Medium", "A much longer label" }
local function fillRow()
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#FILL_NAMES)
	local _callback = function(name, index)
		return React.createElement(Button, {
			key = name,
			name = name,
			text = FILL_LABELS[index + 1],
			fill = true,
			LayoutOrder = index + 1,
		})
	end
	for _k, _v in FILL_NAMES do
		_newValue[_k] = _callback(_v, _k - 1, FILL_NAMES)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement("frame", {
		key = "Stack",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, React.createElement(HStack, {
		Wraps = false,
	}, _newValue))
end
local ButtonSizingValidation
do
	ButtonSizingValidation = setmetatable({}, {
		__tostring = function()
			return "ButtonSizingValidation"
		end,
	})
	ButtonSizingValidation.__index = ButtonSizingValidation
	function ButtonSizingValidation.new(...)
		local self = setmetatable({}, ButtonSizingValidation)
		return self:constructor(...) or self
	end
	function ButtonSizingValidation:constructor()
	end
	function ButtonSizingValidation:widthSizes(width, expected)
		withMounted(HOST_WIDTH, 200, React.createElement(Button, {
			text = "Save",
			width = width,
		}), function(mounted)
			local button = waitForGuiObject(mounted.host, "Button", function(gui)
				return math.abs(gui.AbsoluteSize.X - expected) <= 1 and gui.AbsoluteSize.Y > 0
			end, `Timed out waiting for the Button to be {expected}px wide`)
			assertSizeApprox(button, expected, nil, 1, `width={width}`)
			Assert:equal(button.AutomaticSize, Enum.AutomaticSize.Y, `width={width}: expected AutomaticSize.Y`)
			Assert:undefined(button:FindFirstChildWhichIsA("UIFlexItem"), `width={width}: expected no UIFlexItem without fill`)
		end)
	end
	function ButtonSizingValidation:widthCentersRow()
		withMounted(HOST_WIDTH, 200, React.createElement(Button, {
			text = "Go",
			width = 240,
		}), function(mounted)
			local button = waitForGuiObject(mounted.host, "Button", function(gui)
				return math.abs(gui.AbsoluteSize.X - 240) <= 1
			end)
			local label = waitForGuiObject(button, "ButtonText")
			assertCenteredIn(label, button, "x", 1, "width=240 label")
		end)
	end
	function ButtonSizingValidation:fillSharesEqually()
		withMounted(HOST_WIDTH, 200, fillRow(), function(mounted)
			local stack = waitForGuiObject(mounted.host, "Stack")
			local buttons = waitForLayout(function()
				local found = {}
				for _, name in FILL_NAMES do
					local button = stack:FindFirstChild(name)
					if button == nil then
						return nil
					end
					table.insert(found, button)
				end
				local first = found[1].AbsoluteSize.X
				-- ▼ ReadonlyArray.every ▼
				local _result = true
				local _callback = function(button)
					return button.AbsoluteSize.X > 0 and math.abs(button.AbsoluteSize.X - first) <= 1
				end
				for _k, _v in found do
					if not _callback(_v, _k - 1, found) then
						_result = false
						break
					end
				end
				-- ▲ ReadonlyArray.every ▲
				local settled = _result
				return if settled then found else nil
			end, "Timed out waiting for the three fill Buttons to settle at equal widths")
			for _, button in buttons do
				local flexItem = button:FindFirstChild("FlexItem")
				Assert:notUndefined(flexItem, `Expected {button.Name} to have a UIFlexItem named FlexItem`)
				Assert:equal(flexItem.FlexMode, Enum.UIFlexMode.Fill, `Expected {button.Name}'s FlexItem to use FlexMode Fill`)
			end
			local last = rect(buttons[#buttons])
			Assert["true"](Assert, math.abs(last.right - rect(stack).right) <= 1, `Expected the fill row to reach the stack's right edge, last button ends at {last.right} vs {rect(stack).right}`)
		end)
	end
	function ButtonSizingValidation:autoUnchanged()
		withMounted(HOST_WIDTH, 200, React.createElement(Button, {
			text = "Save",
		}), function(mounted)
			local button = waitForGuiObject(mounted.host, "Button")
			Assert:equal(button.AutomaticSize, Enum.AutomaticSize.XY)
			Assert:undefined(button:FindFirstChildWhichIsA("UIFlexItem"))
			Assert["true"](Assert, button.AbsoluteSize.X < HOST_WIDTH, "Expected an auto-sized Button to stay narrower than the host")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { 120, 120 }, { "50%", 200 } })
	local _decorator_2 = DisplayName("A width prop fixes the root's width while AutomaticSize.Y keeps the height hugging the content")
	local _descriptor = Test(ButtonSizingValidation, "widthSizes", {
		value = ButtonSizingValidation.widthSizes,
	})
	if _descriptor then
		ButtonSizingValidation.widthSizes = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(ButtonSizingValidation, "widthSizes", {
		value = ButtonSizingValidation.widthSizes,
	})
	if _descriptor_1 then
		ButtonSizingValidation.widthSizes = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(ButtonSizingValidation, "widthSizes", {
		value = ButtonSizingValidation.widthSizes,
	})
	if _descriptor_2 then
		ButtonSizingValidation.widthSizes = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(ButtonSizingValidation, "widthSizes", {
		value = ButtonSizingValidation.widthSizes,
	})
	if _descriptor_3 then
		ButtonSizingValidation.widthSizes = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("With a fixed width the icon and label row is centred horizontally inside the wider button")
	local _descriptor_4 = Test(ButtonSizingValidation, "widthCentersRow", {
		value = ButtonSizingValidation.widthCentersRow,
	})
	if _descriptor_4 then
		ButtonSizingValidation.widthCentersRow = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(ButtonSizingValidation, "widthCentersRow", {
		value = ButtonSizingValidation.widthCentersRow,
	})
	if _descriptor_5 then
		ButtonSizingValidation.widthCentersRow = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(ButtonSizingValidation, "widthCentersRow", {
		value = ButtonSizingValidation.widthCentersRow,
	})
	if _descriptor_6 then
		ButtonSizingValidation.widthCentersRow = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Three fill Buttons with different label lengths share an HStack row at equal widths")
	local _descriptor_7 = Test(ButtonSizingValidation, "fillSharesEqually", {
		value = ButtonSizingValidation.fillSharesEqually,
	})
	if _descriptor_7 then
		ButtonSizingValidation.fillSharesEqually = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(ButtonSizingValidation, "fillSharesEqually", {
		value = ButtonSizingValidation.fillSharesEqually,
	})
	if _descriptor_8 then
		ButtonSizingValidation.fillSharesEqually = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(ButtonSizingValidation, "fillSharesEqually", {
		value = ButtonSizingValidation.fillSharesEqually,
	})
	if _descriptor_9 then
		ButtonSizingValidation.fillSharesEqually = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = DisplayName("Without width or fill the Button keeps AutomaticSize.XY and no UIFlexItem")
	local _descriptor_10 = Test(ButtonSizingValidation, "autoUnchanged", {
		value = ButtonSizingValidation.autoUnchanged,
	})
	if _descriptor_10 then
		ButtonSizingValidation.autoUnchanged = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_8(ButtonSizingValidation, "autoUnchanged", {
		value = ButtonSizingValidation.autoUnchanged,
	})
	if _descriptor_11 then
		ButtonSizingValidation.autoUnchanged = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_7(ButtonSizingValidation, "autoUnchanged", {
		value = ButtonSizingValidation.autoUnchanged,
	})
	if _descriptor_12 then
		ButtonSizingValidation.autoUnchanged = _descriptor_12.value
	end
	ButtonSizingValidation = Tag("Studio")(ButtonSizingValidation) or ButtonSizingValidation
end
return ButtonSizingValidation
