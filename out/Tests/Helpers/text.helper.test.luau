-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local TextHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "text.helper").TextHelper
local _binding = Decorators
local Each = _binding.Each
local HEBREW = "\u{5E9}\u{5DC}\u{5D5}\u{5DD}"
local ARABIC = "\u{645}\u{631}\u{62D}\u{628}\u{627}"
local DEVANAGARI = "\u{928}\u{92E}\u{938}\u{94D}\u{924}\u{947}"
local THAI = "\u{E2A}\u{E27}\u{E31}\u{E2A}\u{E14}\u{E35}"
local GRINNING_FACE = "\u{1F600}"
local FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}"
local LONE_CONTINUATION = string.char(0x80)
local TRUNCATED_LEAD = string.char(0xc3)
local INVALID_BYTE = string.char(0xff)
local TextHelperValidation
do
	TextHelperValidation = setmetatable({}, {
		__tostring = function()
			return "TextHelperValidation"
		end,
	})
	TextHelperValidation.__index = TextHelperValidation
	function TextHelperValidation.new(...)
		local self = setmetatable({}, TextHelperValidation)
		return self:constructor(...) or self
	end
	function TextHelperValidation:constructor()
	end
	function TextHelperValidation:asciiMatchesLower(text)
		Assert:equal(TextHelper:lowercase(text), string.lower(text))
	end
	function TextHelperValidation:foldsAccentedLatin(text, expected)
		Assert:equal(TextHelper:lowercase(text), expected)
	end
	function TextHelperValidation:foldsGreek(text, expected)
		Assert:equal(TextHelper:lowercase(text), expected)
	end
	function TextHelperValidation:foldsCyrillic(text, expected)
		Assert:equal(TextHelper:lowercase(text), expected)
	end
	function TextHelperValidation:leavesExceptions(text)
		Assert:equal(TextHelper:lowercase(text), text)
	end
	function TextHelperValidation:invalidLowersAscii()
		local text = `AB{INVALID_BYTE}C`
		Assert:equal(TextHelper:lowercase(text), `ab{INVALID_BYTE}c`)
		Assert:equal(TextHelper:lowercase(text), string.lower(text))
	end
	function TextHelperValidation:complexScripts(text)
		Assert["true"](Assert, TextHelper:isComplexScript(text), `Expected "{text}" to be complex script`)
	end
	function TextHelperValidation:simpleScripts(text)
		Assert["false"](Assert, TextHelper:isComplexScript(text), `Expected "{text}" not to be complex script`)
	end
	function TextHelperValidation:rangeBoundaries(codepoint, expected)
		Assert:equal(TextHelper:isComplexScript(`a{utf8.char(codepoint)}b`), expected, `U+{string.format("%04X", codepoint)}`)
	end
	function TextHelperValidation:validUtf8(text)
		Assert["true"](Assert, TextHelper:isValidUtf8(text))
	end
	function TextHelperValidation:invalidUtf8(text)
		Assert["false"](Assert, TextHelper:isValidUtf8(text))
	end
	function TextHelperValidation:asciiSplitsPerByte(text)
		local characters = TextHelper:splitGraphemes(text)
		Assert:notUndefined(characters, "Expected ASCII text to be splittable")
		Assert:equal(#characters, #text, "Expected one entry per byte")
		for index = 0, #text - 1 do
			local _exp = characters[index + 1]
			local _text = text
			local _arg0 = index + 1
			local _arg1 = index + 1
			Assert:equal(_exp, string.sub(_text, _arg0, _arg1), `Unexpected entry at index {index}`)
		end
	end
	function TextHelperValidation:emptySplitsEmpty()
		local characters = TextHelper:splitGraphemes("")
		Assert:notUndefined(characters, "Expected an empty list, not undefined")
		Assert:equal(#characters, 0)
	end
	function TextHelperValidation:invalidNotSplit(text)
		Assert:undefined(TextHelper:splitGraphemes(text))
	end
	function TextHelperValidation:complexNotSplit(text)
		Assert:undefined(TextHelper:splitGraphemes(text))
	end
	local _decorator = Each({ { "Hello World" }, { "ABC xyz 123 !@#" }, { "already lower" }, { "MiXeD\tCaSe\r\n" }, { "" } })
	local _decorator_1 = DisplayName("Pure ASCII text lowercases byte for byte the same as string.lower")
	local _descriptor = Test(TextHelperValidation, "asciiMatchesLower", {
		value = TextHelperValidation.asciiMatchesLower,
	})
	if _descriptor then
		TextHelperValidation.asciiMatchesLower = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextHelperValidation, "asciiMatchesLower", {
		value = TextHelperValidation.asciiMatchesLower,
	})
	if _descriptor_1 then
		TextHelperValidation.asciiMatchesLower = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextHelperValidation, "asciiMatchesLower", {
		value = TextHelperValidation.asciiMatchesLower,
	})
	if _descriptor_2 then
		TextHelperValidation.asciiMatchesLower = _descriptor_2.value
	end
	local _decorator_2 = Each({ { "ÀÉÎÕÜ", "àéîõü" }, { "École", "école" }, { "ÉCOLE Été", "école été" }, { "Año ÜBER", "año über" }, { "ÞÐÆØ", "þðæø" }, { "ĀĘŁŃŠŽĲ", "āęłńšžĳ" }, { "Ÿ", "ÿ" } })
	local _decorator_3 = DisplayName("Latin-1 and Latin Extended-A capitals fold to their lowercase pair along with any ASCII capitals beside them")
	local _descriptor_3 = Test(TextHelperValidation, "foldsAccentedLatin", {
		value = TextHelperValidation.foldsAccentedLatin,
	})
	if _descriptor_3 then
		TextHelperValidation.foldsAccentedLatin = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(TextHelperValidation, "foldsAccentedLatin", {
		value = TextHelperValidation.foldsAccentedLatin,
	})
	if _descriptor_4 then
		TextHelperValidation.foldsAccentedLatin = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TextHelperValidation, "foldsAccentedLatin", {
		value = TextHelperValidation.foldsAccentedLatin,
	})
	if _descriptor_5 then
		TextHelperValidation.foldsAccentedLatin = _descriptor_5.value
	end
	local _decorator_4 = Each({ { "ΑΒΓΔΩ", "αβγδω" }, { "ΣΟΦΙΑ", "σοφια" }, { "ΆΈΉΊΌΎΏ", "άέήίόύώ" }, { "ΪΫ", "ϊϋ" } })
	local _decorator_5 = DisplayName("Greek capitals, including the accented ones, fold to lowercase")
	local _descriptor_6 = Test(TextHelperValidation, "foldsGreek", {
		value = TextHelperValidation.foldsGreek,
	})
	if _descriptor_6 then
		TextHelperValidation.foldsGreek = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(TextHelperValidation, "foldsGreek", {
		value = TextHelperValidation.foldsGreek,
	})
	if _descriptor_7 then
		TextHelperValidation.foldsGreek = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(TextHelperValidation, "foldsGreek", {
		value = TextHelperValidation.foldsGreek,
	})
	if _descriptor_8 then
		TextHelperValidation.foldsGreek = _descriptor_8.value
	end
	local _decorator_6 = Each({ { "ПРИВЕТ", "привет" }, { "Москва", "москва" }, { "ЁЖЇЄ", "ёжїє" }, { "АЯ", "ая" } })
	local _decorator_7 = DisplayName("Cyrillic capitals U+0400 to U+042F fold to lowercase")
	local _descriptor_9 = Test(TextHelperValidation, "foldsCyrillic", {
		value = TextHelperValidation.foldsCyrillic,
	})
	if _descriptor_9 then
		TextHelperValidation.foldsCyrillic = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(TextHelperValidation, "foldsCyrillic", {
		value = TextHelperValidation.foldsCyrillic,
	})
	if _descriptor_10 then
		TextHelperValidation.foldsCyrillic = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(TextHelperValidation, "foldsCyrillic", {
		value = TextHelperValidation.foldsCyrillic,
	})
	if _descriptor_11 then
		TextHelperValidation.foldsCyrillic = _descriptor_11.value
	end
	local _decorator_8 = Each({ { "×" }, { "İ" }, { "ß" }, { "ı" }, { "àéîõü" }, { "привет" }, { "日本語" }, { "ԱԲԳ" }, { GRINNING_FACE } })
	local _decorator_9 = DisplayName("The multiplication sign, dotted capital I, sharp s, lowercase text and other scripts come back unchanged")
	local _descriptor_12 = Test(TextHelperValidation, "leavesExceptions", {
		value = TextHelperValidation.leavesExceptions,
	})
	if _descriptor_12 then
		TextHelperValidation.leavesExceptions = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(TextHelperValidation, "leavesExceptions", {
		value = TextHelperValidation.leavesExceptions,
	})
	if _descriptor_13 then
		TextHelperValidation.leavesExceptions = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(TextHelperValidation, "leavesExceptions", {
		value = TextHelperValidation.leavesExceptions,
	})
	if _descriptor_14 then
		TextHelperValidation.leavesExceptions = _descriptor_14.value
	end
	local _decorator_10 = DisplayName("Invalid UTF-8 lowercases only its ASCII letters and keeps the invalid bytes, like string.lower")
	local _descriptor_15 = Test(TextHelperValidation, "invalidLowersAscii", {
		value = TextHelperValidation.invalidLowersAscii,
	})
	if _descriptor_15 then
		TextHelperValidation.invalidLowersAscii = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_10(TextHelperValidation, "invalidLowersAscii", {
		value = TextHelperValidation.invalidLowersAscii,
	})
	if _descriptor_16 then
		TextHelperValidation.invalidLowersAscii = _descriptor_16.value
	end
	local _decorator_11 = Each({ { HEBREW }, { ARABIC }, { DEVANAGARI }, { `Hello {HEBREW}` }, { "abc\u{200F}def" }, { "\u{202E}abc" }, { "\u{2066}abc\u{2069}" } })
	local _decorator_12 = DisplayName("Hebrew, Arabic, Devanagari and bidi control characters anywhere in the text make it complex script")
	local _descriptor_17 = Test(TextHelperValidation, "complexScripts", {
		value = TextHelperValidation.complexScripts,
	})
	if _descriptor_17 then
		TextHelperValidation.complexScripts = _descriptor_17.value
	end
	local _descriptor_18 = _decorator_12(TextHelperValidation, "complexScripts", {
		value = TextHelperValidation.complexScripts,
	})
	if _descriptor_18 then
		TextHelperValidation.complexScripts = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_11(TextHelperValidation, "complexScripts", {
		value = TextHelperValidation.complexScripts,
	})
	if _descriptor_19 then
		TextHelperValidation.complexScripts = _descriptor_19.value
	end
	local _decorator_13 = Each({ { "Hello" }, { "" }, { "Año Über" }, { "Привет" }, { "日本語" }, { "한국어" }, { THAI }, { GRINNING_FACE }, { FAMILY }, { "e\u{301}" }, { `ab{INVALID_BYTE}` } })
	local _decorator_14 = DisplayName("ASCII, accented Latin, Cyrillic, CJK, Hangul, Thai, emoji and invalid UTF-8 are not complex script")
	local _descriptor_20 = Test(TextHelperValidation, "simpleScripts", {
		value = TextHelperValidation.simpleScripts,
	})
	if _descriptor_20 then
		TextHelperValidation.simpleScripts = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_14(TextHelperValidation, "simpleScripts", {
		value = TextHelperValidation.simpleScripts,
	})
	if _descriptor_21 then
		TextHelperValidation.simpleScripts = _descriptor_21.value
	end
	local _descriptor_22 = _decorator_13(TextHelperValidation, "simpleScripts", {
		value = TextHelperValidation.simpleScripts,
	})
	if _descriptor_22 then
		TextHelperValidation.simpleScripts = _descriptor_22.value
	end
	local _decorator_15 = Each({ { 0x058f, false }, { 0x0590, true }, { 0x0dff, true }, { 0x0e00, false }, { 0x200d, false }, { 0x200e, true }, { 0x200f, true }, { 0x2010, false }, { 0xfb1c, false }, { 0xfb1d, true }, { 0xfeff, true }, { 0xff00, false }, { 0x107ff, false }, { 0x10800, true }, { 0x1e800, true }, { 0x1f000, false } })
	local _decorator_16 = DisplayName("A single codepoint is complex script exactly when it falls inside one of the documented ranges")
	local _descriptor_23 = Test(TextHelperValidation, "rangeBoundaries", {
		value = TextHelperValidation.rangeBoundaries,
	})
	if _descriptor_23 then
		TextHelperValidation.rangeBoundaries = _descriptor_23.value
	end
	local _descriptor_24 = _decorator_16(TextHelperValidation, "rangeBoundaries", {
		value = TextHelperValidation.rangeBoundaries,
	})
	if _descriptor_24 then
		TextHelperValidation.rangeBoundaries = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_15(TextHelperValidation, "rangeBoundaries", {
		value = TextHelperValidation.rangeBoundaries,
	})
	if _descriptor_25 then
		TextHelperValidation.rangeBoundaries = _descriptor_25.value
	end
	local _decorator_17 = Each({ { "" }, { "Hello" }, { "Año" }, { "Привет" }, { "日本語" }, { HEBREW }, { FAMILY } })
	local _decorator_18 = DisplayName("Well-formed text in any script is valid UTF-8")
	local _descriptor_26 = Test(TextHelperValidation, "validUtf8", {
		value = TextHelperValidation.validUtf8,
	})
	if _descriptor_26 then
		TextHelperValidation.validUtf8 = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_18(TextHelperValidation, "validUtf8", {
		value = TextHelperValidation.validUtf8,
	})
	if _descriptor_27 then
		TextHelperValidation.validUtf8 = _descriptor_27.value
	end
	local _descriptor_28 = _decorator_17(TextHelperValidation, "validUtf8", {
		value = TextHelperValidation.validUtf8,
	})
	if _descriptor_28 then
		TextHelperValidation.validUtf8 = _descriptor_28.value
	end
	local _decorator_19 = Each({ { INVALID_BYTE }, { TRUNCATED_LEAD }, { `a{LONE_CONTINUATION}b` }, { `Hello{TRUNCATED_LEAD}` } })
	local _decorator_20 = DisplayName("A stray byte, a lone continuation byte or a truncated sequence is not valid UTF-8")
	local _descriptor_29 = Test(TextHelperValidation, "invalidUtf8", {
		value = TextHelperValidation.invalidUtf8,
	})
	if _descriptor_29 then
		TextHelperValidation.invalidUtf8 = _descriptor_29.value
	end
	local _descriptor_30 = _decorator_20(TextHelperValidation, "invalidUtf8", {
		value = TextHelperValidation.invalidUtf8,
	})
	if _descriptor_30 then
		TextHelperValidation.invalidUtf8 = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_19(TextHelperValidation, "invalidUtf8", {
		value = TextHelperValidation.invalidUtf8,
	})
	if _descriptor_31 then
		TextHelperValidation.invalidUtf8 = _descriptor_31.value
	end
	local _decorator_21 = Each({ { "Hello" }, { "a b" }, { "x" }, { "\r\n" }, { "Tab\tbed" } })
	local _decorator_22 = DisplayName("Pure ASCII splits into one entry per byte, so a CR LF pair is two entries")
	local _descriptor_32 = Test(TextHelperValidation, "asciiSplitsPerByte", {
		value = TextHelperValidation.asciiSplitsPerByte,
	})
	if _descriptor_32 then
		TextHelperValidation.asciiSplitsPerByte = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_22(TextHelperValidation, "asciiSplitsPerByte", {
		value = TextHelperValidation.asciiSplitsPerByte,
	})
	if _descriptor_33 then
		TextHelperValidation.asciiSplitsPerByte = _descriptor_33.value
	end
	local _descriptor_34 = _decorator_21(TextHelperValidation, "asciiSplitsPerByte", {
		value = TextHelperValidation.asciiSplitsPerByte,
	})
	if _descriptor_34 then
		TextHelperValidation.asciiSplitsPerByte = _descriptor_34.value
	end
	local _decorator_23 = DisplayName("An empty string splits into an empty list rather than undefined")
	local _descriptor_35 = Test(TextHelperValidation, "emptySplitsEmpty", {
		value = TextHelperValidation.emptySplitsEmpty,
	})
	if _descriptor_35 then
		TextHelperValidation.emptySplitsEmpty = _descriptor_35.value
	end
	local _descriptor_36 = _decorator_23(TextHelperValidation, "emptySplitsEmpty", {
		value = TextHelperValidation.emptySplitsEmpty,
	})
	if _descriptor_36 then
		TextHelperValidation.emptySplitsEmpty = _descriptor_36.value
	end
	local _decorator_24 = Each({ { INVALID_BYTE }, { `Hello{TRUNCATED_LEAD}` }, { `a{LONE_CONTINUATION}b` } })
	local _decorator_25 = DisplayName("Invalid UTF-8 cannot be split and returns undefined")
	local _descriptor_37 = Test(TextHelperValidation, "invalidNotSplit", {
		value = TextHelperValidation.invalidNotSplit,
	})
	if _descriptor_37 then
		TextHelperValidation.invalidNotSplit = _descriptor_37.value
	end
	local _descriptor_38 = _decorator_25(TextHelperValidation, "invalidNotSplit", {
		value = TextHelperValidation.invalidNotSplit,
	})
	if _descriptor_38 then
		TextHelperValidation.invalidNotSplit = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_24(TextHelperValidation, "invalidNotSplit", {
		value = TextHelperValidation.invalidNotSplit,
	})
	if _descriptor_39 then
		TextHelperValidation.invalidNotSplit = _descriptor_39.value
	end
	local _decorator_26 = Each({ { HEBREW }, { ARABIC }, { DEVANAGARI }, { `Hello {ARABIC}` }, { "abc\u{200F}def" } })
	local _decorator_27 = DisplayName("Complex-script text is left whole and returns undefined so the caller renders it as one run")
	local _descriptor_40 = Test(TextHelperValidation, "complexNotSplit", {
		value = TextHelperValidation.complexNotSplit,
	})
	if _descriptor_40 then
		TextHelperValidation.complexNotSplit = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_27(TextHelperValidation, "complexNotSplit", {
		value = TextHelperValidation.complexNotSplit,
	})
	if _descriptor_41 then
		TextHelperValidation.complexNotSplit = _descriptor_41.value
	end
	local _descriptor_42 = _decorator_26(TextHelperValidation, "complexNotSplit", {
		value = TextHelperValidation.complexNotSplit,
	})
	if _descriptor_42 then
		TextHelperValidation.complexNotSplit = _descriptor_42.value
	end
	TextHelperValidation = Tag("Lune")(TextHelperValidation) or TextHelperValidation
end
return TextHelperValidation
