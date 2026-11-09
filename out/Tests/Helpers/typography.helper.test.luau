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
local function assertFamilyEndsWith(face, suffix, label)
	local _family = face.Family
	local _arg0 = -#suffix
	Assert:equal(string.sub(_family, _arg0), suffix, `{label}: expected Family to end with {suffix}, got {face.Family}`)
end
local TypographyFontFace
do
	TypographyFontFace = setmetatable({}, {
		__tostring = function()
			return "TypographyFontFace"
		end,
	})
	TypographyFontFace.__index = TypographyFontFace
	function TypographyFontFace.new(...)
		local self = setmetatable({}, TypographyFontFace)
		return self:constructor(...) or self
	end
	function TypographyFontFace:constructor()
	end
	function TypographyFontFace:legacyFamily(font, suffix)
		assertFamilyEndsWith(TypographyHelper:toFontFace(font), suffix, font.Name)
	end
	function TypographyFontFace:matchesFromName(font, weight)
		local face = TypographyHelper:toFontFace(font, weight)
		local expected = Font.fromName(font.Name, weight)
		Assert:equal(face.Family, expected.Family, `{font.Name}: Family mismatch`)
		Assert:equal(face.Weight, expected.Weight, `{font.Name}: Weight mismatch`)
	end
	function TypographyFontFace:keepsBold()
		local face = TypographyHelper:toFontFace(Enum.Font.Fantasy, Enum.FontWeight.Bold)
		Assert:equal(face.Weight, Enum.FontWeight.Bold)
	end
	function TypographyFontFace:overridesBakedWeight()
		local face = TypographyHelper:toFontFace(Enum.Font.SourceSansBold, Enum.FontWeight.Regular)
		Assert:equal(face.Weight, Enum.FontWeight.Regular)
	end
	function TypographyFontFace:defaultWeightAndStyle()
		local face = TypographyHelper:toFontFace(Enum.Font.Fantasy)
		Assert:equal(face.Weight, Enum.FontWeight.Regular)
		Assert:equal(face.Style, Enum.FontStyle.Normal)
	end
	function TypographyFontFace:unknownFallsBack()
		local ok, result = pcall(function()
			return TypographyHelper:toFontFace(Enum.Font.Unknown)
		end)
		Assert["true"](Assert, ok, `Expected toFontFace(Unknown) not to throw, got {result}`)
		Assert:equal(typeof(result), "Font", `Expected a Font, got {typeof(result)}`)
	end
	local _decorator = Each({ { Enum.Font.Fantasy, "Balthazar.json" }, { Enum.Font.Garamond, "Guru.json" }, { Enum.Font.Bodoni, "AccanthisADFStd.json" }, { Enum.Font.Antique, "RomanAntique.json" } })
	local _decorator_1 = DisplayName("Legacy enums whose name differs from their family resolve to the real family file")
	local _descriptor = Test(TypographyFontFace, "legacyFamily", {
		value = TypographyFontFace.legacyFamily,
	})
	if _descriptor then
		TypographyFontFace.legacyFamily = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TypographyFontFace, "legacyFamily", {
		value = TypographyFontFace.legacyFamily,
	})
	if _descriptor_1 then
		TypographyFontFace.legacyFamily = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TypographyFontFace, "legacyFamily", {
		value = TypographyFontFace.legacyFamily,
	})
	if _descriptor_2 then
		TypographyFontFace.legacyFamily = _descriptor_2.value
	end
	local _decorator_2 = Each({ { Enum.Font.Merriweather, Enum.FontWeight.Regular }, { Enum.Font.Fondamento, Enum.FontWeight.Bold }, { Enum.Font.BuilderSans, Enum.FontWeight.Medium } })
	local _decorator_3 = DisplayName("Enums whose name already matches their family produce the same Family and Weight as Font.fromName")
	local _descriptor_3 = Test(TypographyFontFace, "matchesFromName", {
		value = TypographyFontFace.matchesFromName,
	})
	if _descriptor_3 then
		TypographyFontFace.matchesFromName = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TypographyFontFace, "matchesFromName", {
		value = TypographyFontFace.matchesFromName,
	})
	if _descriptor_4 then
		TypographyFontFace.matchesFromName = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TypographyFontFace, "matchesFromName", {
		value = TypographyFontFace.matchesFromName,
	})
	if _descriptor_5 then
		TypographyFontFace.matchesFromName = _descriptor_5.value
	end
	local _decorator_4 = DisplayName("A requested Bold weight is kept on the resolved face")
	local _descriptor_6 = Test(TypographyFontFace, "keepsBold", {
		value = TypographyFontFace.keepsBold,
	})
	if _descriptor_6 then
		TypographyFontFace.keepsBold = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_4(TypographyFontFace, "keepsBold", {
		value = TypographyFontFace.keepsBold,
	})
	if _descriptor_7 then
		TypographyFontFace.keepsBold = _descriptor_7.value
	end
	local _decorator_5 = DisplayName("A requested Regular weight overrides the Bold baked into SourceSansBold")
	local _descriptor_8 = Test(TypographyFontFace, "overridesBakedWeight", {
		value = TypographyFontFace.overridesBakedWeight,
	})
	if _descriptor_8 then
		TypographyFontFace.overridesBakedWeight = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TypographyFontFace, "overridesBakedWeight", {
		value = TypographyFontFace.overridesBakedWeight,
	})
	if _descriptor_9 then
		TypographyFontFace.overridesBakedWeight = _descriptor_9.value
	end
	local _decorator_6 = DisplayName("Omitting weight and style gives a Regular, Normal face")
	local _descriptor_10 = Test(TypographyFontFace, "defaultWeightAndStyle", {
		value = TypographyFontFace.defaultWeightAndStyle,
	})
	if _descriptor_10 then
		TypographyFontFace.defaultWeightAndStyle = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TypographyFontFace, "defaultWeightAndStyle", {
		value = TypographyFontFace.defaultWeightAndStyle,
	})
	if _descriptor_11 then
		TypographyFontFace.defaultWeightAndStyle = _descriptor_11.value
	end
	local _decorator_7 = DisplayName("Enum.Font.Unknown falls back without throwing and still returns a Font")
	local _descriptor_12 = Test(TypographyFontFace, "unknownFallsBack", {
		value = TypographyFontFace.unknownFallsBack,
	})
	if _descriptor_12 then
		TypographyFontFace.unknownFallsBack = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(TypographyFontFace, "unknownFallsBack", {
		value = TypographyFontFace.unknownFallsBack,
	})
	if _descriptor_13 then
		TypographyFontFace.unknownFallsBack = _descriptor_13.value
	end
	TypographyFontFace = Tag("Studio")(TypographyFontFace) or TypographyFontFace
end
return TypographyFontFace
