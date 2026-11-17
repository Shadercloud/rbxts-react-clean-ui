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
local Select = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Input", "Select").Select
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local activateButton = TS.import(script, script.Parent.Parent.Parent, "Helpers", "fiber").activateButton
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local findDescendant = _layout.findDescendant
local settleFrames = _layout.settleFrames
local waitForGuiObject = _layout.waitForGuiObject
local withMounted = _layout.withMounted
local SEPARATOR = "|"
local OPTIONS = { "École", "Été", "CAFÉ", "Москва", "Alpha", "Beta" }
local function searchableSelect()
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#OPTIONS)
	local _callback = function(text)
		return React.createElement(Select.Option, {
			key = text,
			text = text,
		})
	end
	for _k, _v in OPTIONS do
		_newValue[_k] = _callback(_v, _k - 1, OPTIONS)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement(OverlayProvider, nil, React.createElement(Select, {
		searchable = true,
	}, _newValue))
end
local function openDropdown(mounted)
	local selectRoot = waitForGuiObject(mounted.host, "Select")
	waitForGuiObject(mounted.host, "OverlayProvider")
	activateButton(mounted, waitForGuiObject(selectRoot, "SelectButton"))
	return waitForGuiObject(mounted.host, "SelectDropdown")
end
local function searchBox(dropdown)
	return findDescendant(waitForGuiObject(dropdown, "SearchInput"), "TextBox")
end
local function sortedJoin(texts)
	local _array = {}
	local _length = #_array
	table.move(texts, 1, #texts, _length + 1, _array)
	local sorted = _array
	table.sort(sorted)
	-- ▼ ReadonlyArray.join ▼
	local _sEPARATOR = SEPARATOR
	if _sEPARATOR == nil then
		_sEPARATOR = ", "
	end
	-- ▲ ReadonlyArray.join ▲
	return table.concat(sorted, _sEPARATOR)
end
local function visibleOptions(dropdown)
	local texts = {}
	for _, descendant in dropdown:GetDescendants() do
		if descendant.Name == "OptionText" and descendant:IsA("TextLabel") then
			local _text = descendant.Text
			table.insert(texts, _text)
		end
	end
	return sortedJoin(texts)
end
local function waitForOptions(dropdown, expected, label)
	local wanted = sortedJoin(if expected == "" then {} else string.split(expected, SEPARATOR))
	for attempt = 0, 29 do
		if visibleOptions(dropdown) == wanted then
			return nil
		end
		task.wait()
	end
	Assert:equal(visibleOptions(dropdown), wanted, `{label}: unexpected options left in the dropdown`)
end
local SelectSearchValidation
do
	SelectSearchValidation = setmetatable({}, {
		__tostring = function()
			return "SelectSearchValidation"
		end,
	})
	SelectSearchValidation.__index = SelectSearchValidation
	function SelectSearchValidation.new(...)
		local self = setmetatable({}, SelectSearchValidation)
		return self:constructor(...) or self
	end
	function SelectSearchValidation:constructor()
	end
	function SelectSearchValidation:emptyQueryListsAll()
		withMounted(400, 500, searchableSelect(), function(mounted)
			local dropdown = openDropdown(mounted)
			Assert:equal(searchBox(dropdown).Text, "")
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			waitForOptions(dropdown, table.concat(OPTIONS, _sEPARATOR), "empty query")
		end)
	end
	function SelectSearchValidation:nonAsciiIgnoresCase(query, expected)
		withMounted(400, 500, searchableSelect(), function(mounted)
			local dropdown = openDropdown(mounted)
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			waitForOptions(dropdown, table.concat(OPTIONS, _sEPARATOR), "before typing")
			searchBox(dropdown).Text = query
			waitForOptions(dropdown, expected, `query "{query}"`)
		end)
	end
	function SelectSearchValidation:asciiIgnoresCase(query, expected)
		withMounted(400, 500, searchableSelect(), function(mounted)
			local dropdown = openDropdown(mounted)
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			waitForOptions(dropdown, table.concat(OPTIONS, _sEPARATOR), "before typing")
			searchBox(dropdown).Text = query
			waitForOptions(dropdown, expected, `query "{query}"`)
		end)
	end
	function SelectSearchValidation:noMatchShowsNoResults(query)
		withMounted(400, 500, searchableSelect(), function(mounted)
			local dropdown = openDropdown(mounted)
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			waitForOptions(dropdown, table.concat(OPTIONS, _sEPARATOR), "before typing")
			searchBox(dropdown).Text = query
			waitForOptions(dropdown, "", `query "{query}"`)
			local noResults = waitForGuiObject(dropdown, "NoResultsText")
			Assert:equal(noResults.Text, "No Results")
		end)
	end
	function SelectSearchValidation:clearingRestoresAll()
		withMounted(400, 500, searchableSelect(), function(mounted)
			local dropdown = openDropdown(mounted)
			local textBox = searchBox(dropdown)
			textBox.Text = "é"
			waitForOptions(dropdown, "École|Été|CAFÉ", 'query \"é\"')
			settleFrames(2)
			textBox.Text = ""
			-- ▼ ReadonlyArray.join ▼
			local _sEPARATOR = SEPARATOR
			if _sEPARATOR == nil then
				_sEPARATOR = ", "
			end
			-- ▲ ReadonlyArray.join ▲
			waitForOptions(dropdown, table.concat(OPTIONS, _sEPARATOR), "cleared query")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("An empty search box lists every option")
	local _descriptor = Test(SelectSearchValidation, "emptyQueryListsAll", {
		value = SelectSearchValidation.emptyQueryListsAll,
	})
	if _descriptor then
		SelectSearchValidation.emptyQueryListsAll = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(SelectSearchValidation, "emptyQueryListsAll", {
		value = SelectSearchValidation.emptyQueryListsAll,
	})
	if _descriptor_1 then
		SelectSearchValidation.emptyQueryListsAll = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(SelectSearchValidation, "emptyQueryListsAll", {
		value = SelectSearchValidation.emptyQueryListsAll,
	})
	if _descriptor_2 then
		SelectSearchValidation.emptyQueryListsAll = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = Each({ { "é", "École|Été|CAFÉ" }, { "É", "École|Été|CAFÉ" }, { "école", "École" }, { "ÉCOLE", "École" }, { "моск", "Москва" }, { "МОСКВА", "Москва" } })
	local _decorator_4 = DisplayName("An accented or Cyrillic query matches options regardless of the case of either side")
	local _descriptor_3 = Test(SelectSearchValidation, "nonAsciiIgnoresCase", {
		value = SelectSearchValidation.nonAsciiIgnoresCase,
	})
	if _descriptor_3 then
		SelectSearchValidation.nonAsciiIgnoresCase = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_4(SelectSearchValidation, "nonAsciiIgnoresCase", {
		value = SelectSearchValidation.nonAsciiIgnoresCase,
	})
	if _descriptor_4 then
		SelectSearchValidation.nonAsciiIgnoresCase = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_3(SelectSearchValidation, "nonAsciiIgnoresCase", {
		value = SelectSearchValidation.nonAsciiIgnoresCase,
	})
	if _descriptor_5 then
		SelectSearchValidation.nonAsciiIgnoresCase = _descriptor_5.value
	end
	local _descriptor_6 = _decorator_2(SelectSearchValidation, "nonAsciiIgnoresCase", {
		value = SelectSearchValidation.nonAsciiIgnoresCase,
	})
	if _descriptor_6 then
		SelectSearchValidation.nonAsciiIgnoresCase = _descriptor_6.value
	end
	local _decorator_5 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_6 = Each({ { "al", "Alpha" }, { "BET", "Beta" }, { "a", "CAFÉ|Alpha|Beta" }, { "CAF", "CAFÉ" } })
	local _decorator_7 = DisplayName("An ASCII query still matches case-insensitively as a substring, and does not match look-alike Cyrillic letters")
	local _descriptor_7 = Test(SelectSearchValidation, "asciiIgnoresCase", {
		value = SelectSearchValidation.asciiIgnoresCase,
	})
	if _descriptor_7 then
		SelectSearchValidation.asciiIgnoresCase = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_7(SelectSearchValidation, "asciiIgnoresCase", {
		value = SelectSearchValidation.asciiIgnoresCase,
	})
	if _descriptor_8 then
		SelectSearchValidation.asciiIgnoresCase = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_6(SelectSearchValidation, "asciiIgnoresCase", {
		value = SelectSearchValidation.asciiIgnoresCase,
	})
	if _descriptor_9 then
		SelectSearchValidation.asciiIgnoresCase = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_5(SelectSearchValidation, "asciiIgnoresCase", {
		value = SelectSearchValidation.asciiIgnoresCase,
	})
	if _descriptor_10 then
		SelectSearchValidation.asciiIgnoresCase = _descriptor_10.value
	end
	local _decorator_8 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_9 = Each({ { "zz" }, { "ж" }, { "ñ" } })
	local _decorator_10 = DisplayName("A query no option contains shows the No Results text instead of any option")
	local _descriptor_11 = Test(SelectSearchValidation, "noMatchShowsNoResults", {
		value = SelectSearchValidation.noMatchShowsNoResults,
	})
	if _descriptor_11 then
		SelectSearchValidation.noMatchShowsNoResults = _descriptor_11.value
	end
	local _descriptor_12 = _decorator_10(SelectSearchValidation, "noMatchShowsNoResults", {
		value = SelectSearchValidation.noMatchShowsNoResults,
	})
	if _descriptor_12 then
		SelectSearchValidation.noMatchShowsNoResults = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_9(SelectSearchValidation, "noMatchShowsNoResults", {
		value = SelectSearchValidation.noMatchShowsNoResults,
	})
	if _descriptor_13 then
		SelectSearchValidation.noMatchShowsNoResults = _descriptor_13.value
	end
	local _descriptor_14 = _decorator_8(SelectSearchValidation, "noMatchShowsNoResults", {
		value = SelectSearchValidation.noMatchShowsNoResults,
	})
	if _descriptor_14 then
		SelectSearchValidation.noMatchShowsNoResults = _descriptor_14.value
	end
	local _decorator_11 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_12 = DisplayName("Clearing an accented query brings every option back")
	local _descriptor_15 = Test(SelectSearchValidation, "clearingRestoresAll", {
		value = SelectSearchValidation.clearingRestoresAll,
	})
	if _descriptor_15 then
		SelectSearchValidation.clearingRestoresAll = _descriptor_15.value
	end
	local _descriptor_16 = _decorator_12(SelectSearchValidation, "clearingRestoresAll", {
		value = SelectSearchValidation.clearingRestoresAll,
	})
	if _descriptor_16 then
		SelectSearchValidation.clearingRestoresAll = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_11(SelectSearchValidation, "clearingRestoresAll", {
		value = SelectSearchValidation.clearingRestoresAll,
	})
	if _descriptor_17 then
		SelectSearchValidation.clearingRestoresAll = _descriptor_17.value
	end
	SelectSearchValidation = Tag("Studio")(SelectSearchValidation) or SelectSearchValidation
end
return SelectSearchValidation
