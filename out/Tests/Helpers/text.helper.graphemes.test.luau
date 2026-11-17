-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local TextHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers", "text.helper").TextHelper
local STUDIO_SKIP_MESSAGE = TS.import(script, script.Parent, "layout").STUDIO_SKIP_MESSAGE
local _binding = Decorators
local Skip = _binding.Skip
local Each = _binding.Each
local SEPARATOR = "|"
local THAI = "\u{E2A}\u{E27}\u{E31}\u{E2A}\u{E14}\u{E35}"
local THAI_CLUSTERS = "\u{E2A}|\u{E27}\u{E31}|\u{E2A}|\u{E14}\u{E35}"
local GRINNING_FACE = "\u{1F600}"
local FLAG = "\u{1F1EF}\u{1F1F5}"
local FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}"
local HEART = "\u{2764}\u{FE0F}"
local WAVE_TONE = "\u{1F44B}\u{1F3FD}"
local TextHelperGraphemes
do
	TextHelperGraphemes = setmetatable({}, {
		__tostring = function()
			return "TextHelperGraphemes"
		end,
	})
	TextHelperGraphemes.__index = TextHelperGraphemes
	function TextHelperGraphemes.new(...)
		local self = setmetatable({}, TextHelperGraphemes)
		return self:constructor(...) or self
	end
	function TextHelperGraphemes:constructor()
	end
	function TextHelperGraphemes:splitsIntoClusters(text, expected)
		local characters = TextHelper:splitGraphemes(text)
		Assert:notUndefined(characters, "Expected the text to be splittable")
		-- ▼ ReadonlyArray.join ▼
		local _sEPARATOR = SEPARATOR
		if _sEPARATOR == nil then
			_sEPARATOR = ", "
		end
		-- ▲ ReadonlyArray.join ▲
		Assert:equal(table.concat(characters, _sEPARATOR), expected, "Unexpected grapheme clusters")
		Assert:equal(#characters, #string.split(expected, SEPARATOR), "Unexpected grapheme count")
		Assert:equal(table.concat(characters, ""), text, "Expected the clusters to concatenate back to the input")
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "Año", "A|ñ|o" }, { "Über", "Ü|b|e|r" }, { "cafe\u{301}", "c|a|f|e\u{301}" }, { "Привет", "П|р|и|в|е|т" }, { "日本語", "日|本|語" }, { "한국어", "한|국|어" }, { THAI, THAI_CLUSTERS }, { GRINNING_FACE, GRINNING_FACE }, { `a{FLAG}b`, `a|{FLAG}|b` }, { `a{FAMILY}b`, `a|{FAMILY}|b` }, { `{HEART}{WAVE_TONE}`, `{HEART}|{WAVE_TONE}` } })
	local _decorator_2 = DisplayName("Non-ASCII text splits into whole grapheme clusters, keeping combining marks and multi-codepoint emoji together")
	local _descriptor = Test(TextHelperGraphemes, "splitsIntoClusters", {
		value = TextHelperGraphemes.splitsIntoClusters,
	})
	if _descriptor then
		TextHelperGraphemes.splitsIntoClusters = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextHelperGraphemes, "splitsIntoClusters", {
		value = TextHelperGraphemes.splitsIntoClusters,
	})
	if _descriptor_1 then
		TextHelperGraphemes.splitsIntoClusters = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextHelperGraphemes, "splitsIntoClusters", {
		value = TextHelperGraphemes.splitsIntoClusters,
	})
	if _descriptor_2 then
		TextHelperGraphemes.splitsIntoClusters = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextHelperGraphemes, "splitsIntoClusters", {
		value = TextHelperGraphemes.splitsIntoClusters,
	})
	if _descriptor_3 then
		TextHelperGraphemes.splitsIntoClusters = _descriptor_3.value
	end
	TextHelperGraphemes = Tag("Studio")(TextHelperGraphemes) or TextHelperGraphemes
end
return TextHelperGraphemes
