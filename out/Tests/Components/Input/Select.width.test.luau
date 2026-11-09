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
local Select = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Select").Select
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local HOST_WIDTH = 400
local function widthSelect(width)
	return React.createElement(Select, {
		width = width,
	}, React.createElement(Select.Option, {
		text = "Alpha",
	}), React.createElement(Select.Option, {
		text = "Beta",
	}))
end
local function waitForSelectWidth(host, expected)
	return waitForGuiObject(host, "Select", function(gui)
		return math.abs(gui.AbsoluteSize.X - expected) <= 1 and gui.AbsoluteSize.Y > 0
	end, `Timed out waiting for the Select root to be {expected}px wide`)
end
local SelectWidthValidation
do
	SelectWidthValidation = setmetatable({}, {
		__tostring = function()
			return "SelectWidthValidation"
		end,
	})
	SelectWidthValidation.__index = SelectWidthValidation
	function SelectWidthValidation.new(...)
		local self = setmetatable({}, SelectWidthValidation)
		return self:constructor(...) or self
	end
	function SelectWidthValidation:constructor()
	end
	function SelectWidthValidation:fixedWidth()
		withMounted(HOST_WIDTH, 200, widthSelect(200), function(mounted)
			local selectRoot = waitForSelectWidth(mounted.host, 200)
			assertSizeApprox(selectRoot, 200, nil, 1, "width=200 select")
			Assert:equal(selectRoot.AutomaticSize, Enum.AutomaticSize.Y)
		end)
	end
	function SelectWidthValidation:fullWidthDefault()
		withMounted(HOST_WIDTH, 200, widthSelect(), function(mounted)
			local selectRoot = waitForSelectWidth(mounted.host, HOST_WIDTH)
			assertSizeApprox(selectRoot, HOST_WIDTH, nil, 1, "unset width select")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("width={200} pins the closed control to 200px while its height still hugs the content")
	local _descriptor = Test(SelectWidthValidation, "fixedWidth", {
		value = SelectWidthValidation.fixedWidth,
	})
	if _descriptor then
		SelectWidthValidation.fixedWidth = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SelectWidthValidation, "fixedWidth", {
		value = SelectWidthValidation.fixedWidth,
	})
	if _descriptor_1 then
		SelectWidthValidation.fixedWidth = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SelectWidthValidation, "fixedWidth", {
		value = SelectWidthValidation.fixedWidth,
	})
	if _descriptor_2 then
		SelectWidthValidation.fixedWidth = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Without width the closed control stretches to the full width of its parent")
	local _descriptor_3 = Test(SelectWidthValidation, "fullWidthDefault", {
		value = SelectWidthValidation.fullWidthDefault,
	})
	if _descriptor_3 then
		SelectWidthValidation.fullWidthDefault = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(SelectWidthValidation, "fullWidthDefault", {
		value = SelectWidthValidation.fullWidthDefault,
	})
	if _descriptor_4 then
		SelectWidthValidation.fullWidthDefault = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(SelectWidthValidation, "fullWidthDefault", {
		value = SelectWidthValidation.fullWidthDefault,
	})
	if _descriptor_5 then
		SelectWidthValidation.fullWidthDefault = _descriptor_5.value
	end
	SelectWidthValidation = Tag("Studio")(SelectWidthValidation) or SelectWidthValidation
end
return SelectWidthValidation
