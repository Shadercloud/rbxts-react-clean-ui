-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local Decorators = _lunit.Decorators
local TypographyHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "typography.helper").TypographyHelper
local _binding = Decorators
local Each = _binding.Each
local function fontSizeNamed(name)
	return {
		Name = name,
	}
end
local TypographyToTextSize
do
	TypographyToTextSize = setmetatable({}, {
		__tostring = function()
			return "TypographyToTextSize"
		end,
	})
	TypographyToTextSize.__index = TypographyToTextSize
	function TypographyToTextSize.new(...)
		local self = setmetatable({}, TypographyToTextSize)
		return self:constructor(...) or self
	end
	function TypographyToTextSize:constructor()
	end
	function TypographyToTextSize:parsesPixels(name, expected)
		Assert:equal(TypographyHelper:toTextSize(fontSizeNamed(name)), expected)
	end
	function TypographyToTextSize:unknownIsUndefined(name)
		Assert:undefined(TypographyHelper:toTextSize(fontSizeNamed(name)))
	end
	local _decorator = Each({ { "Size8", 8 }, { "Size10", 10 }, { "Size18", 18 }, { "Size48", 48 }, { "Size96", 96 } })
	local _decorator_1 = DisplayName("A SizeN font size name resolves to N pixels")
	local _descriptor = Test(TypographyToTextSize, "parsesPixels", {
		value = TypographyToTextSize.parsesPixels,
	})
	if _descriptor then
		TypographyToTextSize.parsesPixels = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TypographyToTextSize, "parsesPixels", {
		value = TypographyToTextSize.parsesPixels,
	})
	if _descriptor_1 then
		TypographyToTextSize.parsesPixels = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TypographyToTextSize, "parsesPixels", {
		value = TypographyToTextSize.parsesPixels,
	})
	if _descriptor_2 then
		TypographyToTextSize.parsesPixels = _descriptor_2.value
	end
	local _decorator_2 = Each({ { "Legacy" }, { "Size" }, { "SizeLarge" }, { "Size18px" }, { "XSize18" } })
	local _decorator_3 = DisplayName("A font size name that is not Size followed only by digits has no pixel size")
	local _descriptor_3 = Test(TypographyToTextSize, "unknownIsUndefined", {
		value = TypographyToTextSize.unknownIsUndefined,
	})
	if _descriptor_3 then
		TypographyToTextSize.unknownIsUndefined = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TypographyToTextSize, "unknownIsUndefined", {
		value = TypographyToTextSize.unknownIsUndefined,
	})
	if _descriptor_4 then
		TypographyToTextSize.unknownIsUndefined = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TypographyToTextSize, "unknownIsUndefined", {
		value = TypographyToTextSize.unknownIsUndefined,
	})
	if _descriptor_5 then
		TypographyToTextSize.unknownIsUndefined = _descriptor_5.value
	end
	TypographyToTextSize = Tag("Lune")(TypographyToTextSize) or TypographyToTextSize
end
return TypographyToTextSize
