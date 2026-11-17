-- Compiled with roblox-ts v3.0.0
local utf8Length = utf8.len
local COMPLEX_SCRIPT_RANGES = { { 0x0590, 0x0dff }, { 0x0f00, 0x109f }, { 0x1780, 0x18af }, { 0x200e, 0x200f }, { 0x202a, 0x202e }, { 0x2066, 0x2069 }, { 0xfb1d, 0xfdff }, { 0xfe70, 0xfeff }, { 0x10800, 0x11fff }, { 0x1e800, 0x1efff } }
local FIRST_COMPLEX_CODEPOINT = 0x0590
local function isComplexCodepoint(codepoint)
	if codepoint < FIRST_COMPLEX_CODEPOINT then
		return false
	end
	for _, _binding in COMPLEX_SCRIPT_RANGES do
		local first = _binding[1]
		local last = _binding[2]
		if codepoint >= first and codepoint <= last then
			return true
		end
	end
	return false
end
local function lowercaseCodepoint(codepoint)
	if codepoint < 0x80 then
		return if codepoint >= 0x41 and codepoint <= 0x5a then codepoint + 32 else codepoint
	end
	if codepoint >= 0xc0 and codepoint <= 0xde then
		return if codepoint == 0xd7 then codepoint else codepoint + 32
	end
	if codepoint >= 0x100 and codepoint <= 0x17f then
		if codepoint == 0x130 or codepoint == 0x131 or codepoint == 0x138 or codepoint == 0x149 or codepoint == 0x17f then
			return codepoint
		end
		if codepoint == 0x178 then
			return 0xff
		end
		local upperIsOdd = (codepoint >= 0x139 and codepoint <= 0x148) or codepoint >= 0x179
		return if codepoint % 2 == (if upperIsOdd then 1 else 0) then codepoint + 1 else codepoint
	end
	if codepoint >= 0x386 and codepoint <= 0x3ab then
		if codepoint == 0x386 then
			return 0x3ac
		end
		if codepoint >= 0x388 and codepoint <= 0x38a then
			return codepoint + 37
		end
		if codepoint == 0x38c then
			return 0x3cc
		end
		if codepoint == 0x38e or codepoint == 0x38f then
			return codepoint + 63
		end
		if codepoint >= 0x391 and codepoint ~= 0x3a2 then
			return codepoint + 32
		end
		return codepoint
	end
	if codepoint >= 0x400 and codepoint <= 0x40f then
		return codepoint + 80
	end
	if codepoint >= 0x410 and codepoint <= 0x42f then
		return codepoint + 32
	end
	return codepoint
end
local TextHelper
do
	TextHelper = setmetatable({}, {
		__tostring = function()
			return "TextHelper"
		end,
	})
	TextHelper.__index = TextHelper
	function TextHelper.new(...)
		local self = setmetatable({}, TextHelper)
		return self:constructor(...) or self
	end
	function TextHelper:constructor()
	end
	function TextHelper:isValidUtf8(text)
		local _arg0 = utf8Length(text)
		return type(_arg0) == "number"
	end
	function TextHelper:lowercase(text)
		local length = utf8Length(text)
		if not (type(length) == "number") or length == #text then
			return string.lower(text)
		end
		local characters = {}
		for _, codepoint in utf8.codes(text) do
			local _arg0 = utf8.char(lowercaseCodepoint(codepoint))
			table.insert(characters, _arg0)
		end
		return table.concat(characters, "")
	end
	function TextHelper:isComplexScript(text)
		local length = utf8Length(text)
		if not (type(length) == "number") or length == #text then
			return false
		end
		for _, codepoint in utf8.codes(text) do
			if isComplexCodepoint(codepoint) then
				return true
			end
		end
		return false
	end
	function TextHelper:splitGraphemes(text)
		local length = utf8Length(text)
		if not (type(length) == "number") then
			return nil
		end
		local characters = {}
		if length == #text then
			for index = 0, #text - 1 do
				local _text = text
				local _arg0 = index + 1
				local _arg1 = index + 1
				local _arg0_1 = string.sub(_text, _arg0, _arg1)
				table.insert(characters, _arg0_1)
			end
			return characters
		end
		if TextHelper:isComplexScript(text) then
			return nil
		end
		for first, last in utf8.graphemes(text) do
			local _arg0 = string.sub(text, first, last)
			table.insert(characters, _arg0)
		end
		return characters
	end
end
return {
	TextHelper = TextHelper,
}
