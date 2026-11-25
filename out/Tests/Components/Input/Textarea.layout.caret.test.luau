-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Each = _binding.Each
local resolveTextareaCaretLineText = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Textarea.layout").resolveTextareaCaretLineText
local E_ACUTE = "\u{E9}"
local O_UMLAUT = "\u{F6}"
local TextareaCaretLineText
do
	TextareaCaretLineText = setmetatable({}, {
		__tostring = function()
			return "TextareaCaretLineText"
		end,
	})
	TextareaCaretLineText.__index = TextareaCaretLineText
	function TextareaCaretLineText.new(...)
		local self = setmetatable({}, TextareaCaretLineText)
		return self:constructor(...) or self
	end
	function TextareaCaretLineText:constructor()
	end
	function TextareaCaretLineText:restOfWord(text, cursor, expected)
		Assert:equal(resolveTextareaCaretLineText(text, cursor), expected)
	end
	function TextareaCaretLineText:lineStart()
		Assert:equal(resolveTextareaCaretLineText("x\nword", 3), "x\n ")
	end
	function TextareaCaretLineText:emptyText()
		Assert:equal(resolveTextareaCaretLineText("", 1), " ")
	end
	function TextareaCaretLineText:belowOne(cursor)
		Assert:undefined(resolveTextareaCaretLineText("aa bbbb", cursor))
	end
	function TextareaCaretLineText:multibyteWord(cursor)
		Assert:equal(resolveTextareaCaretLineText(`h{E_ACUTE}llo w{O_UMLAUT}rld`, cursor), `h{E_ACUTE}llo w{O_UMLAUT}rld`)
	end
	local _decorator = DisplayName("A caret inside a word measures through the end of that word")
	local _decorator_1 = Each({ { "aa bbbb cc", 6, "aa bbbb" }, { "aa bbbb", 4, "aa bbbb" }, { "aa bbbb", 3, "aa" } })
	local _descriptor = Test(TextareaCaretLineText, "restOfWord", {
		value = TextareaCaretLineText.restOfWord,
	})
	if _descriptor then
		TextareaCaretLineText.restOfWord = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(TextareaCaretLineText, "restOfWord", {
		value = TextareaCaretLineText.restOfWord,
	})
	if _descriptor_1 then
		TextareaCaretLineText.restOfWord = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(TextareaCaretLineText, "restOfWord", {
		value = TextareaCaretLineText.restOfWord,
	})
	if _descriptor_2 then
		TextareaCaretLineText.restOfWord = _descriptor_2.value
	end
	local _decorator_2 = DisplayName("A caret at the start of a line adds nothing after the placeholder space")
	local _descriptor_3 = Test(TextareaCaretLineText, "lineStart", {
		value = TextareaCaretLineText.lineStart,
	})
	if _descriptor_3 then
		TextareaCaretLineText.lineStart = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_2(TextareaCaretLineText, "lineStart", {
		value = TextareaCaretLineText.lineStart,
	})
	if _descriptor_4 then
		TextareaCaretLineText.lineStart = _descriptor_4.value
	end
	local _decorator_3 = DisplayName("Empty text with the caret at position one measures a single space")
	local _descriptor_5 = Test(TextareaCaretLineText, "emptyText", {
		value = TextareaCaretLineText.emptyText,
	})
	if _descriptor_5 then
		TextareaCaretLineText.emptyText = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextareaCaretLineText, "emptyText", {
		value = TextareaCaretLineText.emptyText,
	})
	if _descriptor_6 then
		TextareaCaretLineText.emptyText = _descriptor_6.value
	end
	local _decorator_4 = DisplayName("A cursor position below one gives no caret line text")
	local _decorator_5 = Each({ { 0 }, { -1 } })
	local _descriptor_7 = Test(TextareaCaretLineText, "belowOne", {
		value = TextareaCaretLineText.belowOne,
	})
	if _descriptor_7 then
		TextareaCaretLineText.belowOne = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_5(TextareaCaretLineText, "belowOne", {
		value = TextareaCaretLineText.belowOne,
	})
	if _descriptor_8 then
		TextareaCaretLineText.belowOne = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(TextareaCaretLineText, "belowOne", {
		value = TextareaCaretLineText.belowOne,
	})
	if _descriptor_9 then
		TextareaCaretLineText.belowOne = _descriptor_9.value
	end
	local _decorator_6 = DisplayName("A caret inside a multibyte word returns the whole word with its accented bytes intact")
	local _decorator_7 = Each({ { 9 }, { 11 }, { 13 } })
	local _descriptor_10 = Test(TextareaCaretLineText, "multibyteWord", {
		value = TextareaCaretLineText.multibyteWord,
	})
	if _descriptor_10 then
		TextareaCaretLineText.multibyteWord = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_7(TextareaCaretLineText, "multibyteWord", {
		value = TextareaCaretLineText.multibyteWord,
	})
	if _descriptor_11 then
		TextareaCaretLineText.multibyteWord = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_6(TextareaCaretLineText, "multibyteWord", {
		value = TextareaCaretLineText.multibyteWord,
	})
	if _descriptor_12 then
		TextareaCaretLineText.multibyteWord = _descriptor_12.value
	end
	TextareaCaretLineText = Tag("Lune")(TextareaCaretLineText) or TextareaCaretLineText
end
return TextareaCaretLineText
