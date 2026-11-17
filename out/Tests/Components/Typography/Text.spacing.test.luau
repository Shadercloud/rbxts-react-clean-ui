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
local Text = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Typography", "Text").Text
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local rect = _layout.rect
local settleFrames = _layout.settleFrames
local waitForDescendant = _layout.waitForDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local SEPARATOR = "|"
local ASCII_TEXT = "Hello"
local SPACING = 3
local GRINNING_FACE = "\u{1F600}"
local FLAG = "\u{1F1EF}\u{1F1F5}"
local FAMILY = "\u{1F468}\u{200D}\u{1F469}\u{200D}\u{1F467}"
local HEBREW = "\u{5E9}\u{5DC}\u{5D5}\u{5DD}"
local ARABIC = "\u{645}\u{631}\u{62D}\u{628}\u{627}"
local DEVANAGARI = "\u{928}\u{92E}\u{938}\u{94D}\u{924}\u{947}"
local function waitForRoot(host)
	return waitForDescendant(host, "Text", function()
		return true
	end)
end
local function characterLabels(frame)
	local found = {}
	for _, child in frame:GetChildren() do
		if child:IsA("TextLabel") then
			table.insert(found, child)
		end
	end
	table.sort(found, function(a, b)
		return a.LayoutOrder < b.LayoutOrder
	end)
	return found
end
local function letterSpacingLayout(frame)
	local layout = frame:FindFirstChild("LetterSpacing")
	Assert:notUndefined(layout, `Expected a LetterSpacing layout directly under {frame:GetFullName()}`)
	Assert["true"](Assert, layout:IsA("UIListLayout"), `Expected LetterSpacing to be a UIListLayout, got {layout.ClassName}`)
	return layout
end
local TextLetterSpacing
do
	TextLetterSpacing = setmetatable({}, {
		__tostring = function()
			return "TextLetterSpacing"
		end,
	})
	TextLetterSpacing.__index = TextLetterSpacing
	function TextLetterSpacing.new(...)
		local self = setmetatable({}, TextLetterSpacing)
		return self:constructor(...) or self
	end
	function TextLetterSpacing:constructor()
	end
	function TextLetterSpacing:labelPerGrapheme(text, expected)
		local clusters = string.split(expected, SEPARATOR)
		withMounted(400, 200, React.createElement(Text, {
			text = text,
			letterSpacing = SPACING,
		}), function(mounted)
			local frame = waitForRoot(mounted.host)
			settleFrames(2)
			Assert["true"](Assert, frame:IsA("Frame"), `Expected a Frame root for splittable text, got {frame.ClassName}`)
			letterSpacingLayout(frame)
			local labels = characterLabels(frame)
			-- ▼ ReadonlyArray.map ▼
			local _newValue = table.create(#labels)
			local _callback = function(label)
				return label.Text
			end
			for _k, _v in labels do
				_newValue[_k] = _callback(_v, _k - 1, labels)
			end
			-- ▲ ReadonlyArray.map ▲
			local texts = _newValue
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			Assert:equal(table.concat(texts, _sEPARATOR), expected, "Expected each label to hold exactly one whole grapheme")
			Assert:equal(#labels, #clusters, "Expected one TextLabel per grapheme")
			Assert:equal(table.concat(texts, ""), text, "Expected the labels in LayoutOrder to concatenate back to the input")
			Assert:equal(#frame:GetChildren(), #clusters + 1, "Expected only the list layout plus the character labels")
			for index = 0, #labels - 1 do
				Assert:equal(labels[index + 1].Name, `{index}`, "Expected each label to be named by its zero-based index")
				Assert:equal(labels[index + 1].LayoutOrder, index, `Unexpected LayoutOrder on label {index}`)
			end
		end)
	end
	function TextLetterSpacing:asciiStructureUnchanged()
		withMounted(400, 200, React.createElement(Text, {
			text = ASCII_TEXT,
			letterSpacing = SPACING,
		}), function(mounted)
			local frame = waitForGuiObject(mounted.host, "Text")
			settleFrames(2)
			Assert["true"](Assert, frame:IsA("Frame"), `Expected a Frame root, got {frame.ClassName}`)
			local layout = letterSpacingLayout(frame)
			Assert:equal(layout.Padding.Offset, SPACING, "Expected the list padding to be the letterSpacing")
			Assert:equal(layout.Padding.Scale, 0, "Expected a pixel-only list padding")
			Assert:equal(layout.FillDirection, Enum.FillDirection.Horizontal)
			Assert:equal(layout.SortOrder, Enum.SortOrder.LayoutOrder)
			local labels = characterLabels(frame)
			Assert:equal(#labels, #ASCII_TEXT, "Expected one TextLabel per byte")
			Assert:equal(#frame:GetChildren(), #ASCII_TEXT + 1, "Expected only the list layout plus the character labels")
			for index = 0, #labels - 1 do
				local label = labels[index + 1]
				Assert:equal(label.Name, `{index}`, "Expected each label to be named by its zero-based index")
				Assert:equal(label.LayoutOrder, index, `Unexpected LayoutOrder on label {index}`)
				local _exp = label.Text
				local _arg0 = index + 1
				local _arg1 = index + 1
				Assert:equal(_exp, string.sub(ASCII_TEXT, _arg0, _arg1), `Unexpected character on label {index}`)
				Assert:equal(#label.Text, 1, `Expected label {index} to hold a single character`)
			end
		end)
	end
	function TextLetterSpacing:asciiGapMatchesSpacing()
		withMounted(400, 200, React.createElement(Text, {
			text = ASCII_TEXT,
			letterSpacing = SPACING,
		}), function(mounted)
			local frame = waitForGuiObject(mounted.host, "Text")
			local labels = waitForLayout(function()
				local found = characterLabels(frame)
				local _condition = #found == #ASCII_TEXT
				if _condition then
					-- ▼ ReadonlyArray.every ▼
					local _result = true
					local _callback = function(label)
						return label.AbsoluteSize.X > 0
					end
					for _k, _v in found do
						if not _callback(_v, _k - 1, found) then
							_result = false
							break
						end
					end
					-- ▲ ReadonlyArray.every ▲
					_condition = _result
				end
				return if _condition then found else nil
			end, "Timed out waiting for every character label to be laid out")
			for index = 1, #labels - 1 do
				local gap = rect(labels[index + 1]).left - rect(labels[index]).right
				Assert["true"](Assert, math.abs(gap - SPACING) <= 0.5, `Expected a {SPACING}px gap between labels {index - 1} and {index}, got {gap}`)
			end
		end)
	end
	function TextLetterSpacing:complexScriptStaysWhole(text)
		withMounted(400, 200, React.createElement(Text, {
			text = text,
			letterSpacing = SPACING,
		}), function(mounted)
			local root = waitForRoot(mounted.host)
			settleFrames(2)
			Assert["true"](Assert, root:IsA("TextLabel"), `Expected a single TextLabel root for complex-script text, got {root.ClassName}`)
			Assert:equal(root.Text, text, "Expected the root label to hold the whole string")
			Assert:undefined(root:FindFirstChild("LetterSpacing"), "Expected no LetterSpacing layout on the fallback label")
			Assert:equal(#characterLabels(root), 0, "Expected no per-character labels")
			local _exp = mounted.host:GetDescendants()
			-- ▼ ReadonlyArray.filter ▼
			local _newValue = {}
			local _callback = function(descendant)
				return descendant:IsA("TextLabel")
			end
			local _length = 0
			for _k, _v in _exp do
				if _callback(_v, _k - 1, _exp) == true then
					_length += 1
					_newValue[_length] = _v
				end
			end
			-- ▲ ReadonlyArray.filter ▲
			Assert:equal(#_newValue, 1, "Expected exactly one TextLabel in the whole mount")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = Each({ { "Año", "A|ñ|o" }, { "Über", "Ü|b|e|r" }, { "cafe\u{301}", "c|a|f|e\u{301}" }, { "Привет", "П|р|и|в|е|т" }, { "日本語", "日|本|語" }, { GRINNING_FACE, GRINNING_FACE }, { `a{FLAG}b`, `a|{FLAG}|b` }, { `a{FAMILY}b`, `a|{FAMILY}|b` } })
	local _decorator_2 = DisplayName("Letter-spaced non-English text renders one label per whole grapheme, in order, that together spell the input")
	local _descriptor = Test(TextLetterSpacing, "labelPerGrapheme", {
		value = TextLetterSpacing.labelPerGrapheme,
	})
	if _descriptor then
		TextLetterSpacing.labelPerGrapheme = _descriptor.value
	end
	local _descriptor_1 = _decorator_2(TextLetterSpacing, "labelPerGrapheme", {
		value = TextLetterSpacing.labelPerGrapheme,
	})
	if _descriptor_1 then
		TextLetterSpacing.labelPerGrapheme = _descriptor_1.value
	end
	local _descriptor_2 = _decorator_1(TextLetterSpacing, "labelPerGrapheme", {
		value = TextLetterSpacing.labelPerGrapheme,
	})
	if _descriptor_2 then
		TextLetterSpacing.labelPerGrapheme = _descriptor_2.value
	end
	local _descriptor_3 = _decorator(TextLetterSpacing, "labelPerGrapheme", {
		value = TextLetterSpacing.labelPerGrapheme,
	})
	if _descriptor_3 then
		TextLetterSpacing.labelPerGrapheme = _descriptor_3.value
	end
	local _decorator_3 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_4 = DisplayName("Letter-spaced ASCII keeps one single-character label per byte, named and ordered by index, under the LetterSpacing layout")
	local _descriptor_4 = Test(TextLetterSpacing, "asciiStructureUnchanged", {
		value = TextLetterSpacing.asciiStructureUnchanged,
	})
	if _descriptor_4 then
		TextLetterSpacing.asciiStructureUnchanged = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_4(TextLetterSpacing, "asciiStructureUnchanged", {
		value = TextLetterSpacing.asciiStructureUnchanged,
	})
	if _descriptor_5 then
		TextLetterSpacing.asciiStructureUnchanged = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_3(TextLetterSpacing, "asciiStructureUnchanged", {
		value = TextLetterSpacing.asciiStructureUnchanged,
	})
	if _descriptor_6 then
		TextLetterSpacing.asciiStructureUnchanged = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = DisplayName("Consecutive ASCII character labels sit left to right exactly the letterSpacing apart")
	local _descriptor_7 = Test(TextLetterSpacing, "asciiGapMatchesSpacing", {
		value = TextLetterSpacing.asciiGapMatchesSpacing,
	})
	if _descriptor_7 then
		TextLetterSpacing.asciiGapMatchesSpacing = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_6(TextLetterSpacing, "asciiGapMatchesSpacing", {
		value = TextLetterSpacing.asciiGapMatchesSpacing,
	})
	if _descriptor_8 then
		TextLetterSpacing.asciiGapMatchesSpacing = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_5(TextLetterSpacing, "asciiGapMatchesSpacing", {
		value = TextLetterSpacing.asciiGapMatchesSpacing,
	})
	if _descriptor_9 then
		TextLetterSpacing.asciiGapMatchesSpacing = _descriptor_9.value
	end
	local _decorator_7 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_8 = Each({ { ARABIC }, { HEBREW }, { DEVANAGARI }, { `Hello {ARABIC}` }, { "abc\u{200F}def" } })
	local _decorator_9 = DisplayName("Letter-spaced Arabic, Hebrew, Devanagari or bidi-controlled text falls back to one root TextLabel holding the whole string")
	local _descriptor_10 = Test(TextLetterSpacing, "complexScriptStaysWhole", {
		value = TextLetterSpacing.complexScriptStaysWhole,
	})
	if _descriptor_10 then
		TextLetterSpacing.complexScriptStaysWhole = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_9(TextLetterSpacing, "complexScriptStaysWhole", {
		value = TextLetterSpacing.complexScriptStaysWhole,
	})
	if _descriptor_11 then
		TextLetterSpacing.complexScriptStaysWhole = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_8(TextLetterSpacing, "complexScriptStaysWhole", {
		value = TextLetterSpacing.complexScriptStaysWhole,
	})
	if _descriptor_12 then
		TextLetterSpacing.complexScriptStaysWhole = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_7(TextLetterSpacing, "complexScriptStaysWhole", {
		value = TextLetterSpacing.complexScriptStaysWhole,
	})
	if _descriptor_13 then
		TextLetterSpacing.complexScriptStaysWhole = _descriptor_13.value
	end
	TextLetterSpacing = Tag("Studio")(TextLetterSpacing) or TextLetterSpacing
end
return TextLetterSpacing
