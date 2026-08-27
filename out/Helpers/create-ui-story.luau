-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Theme = TS.import(script, script.Parent.Parent, "Theme")
local DarkTheme = _Theme.DarkTheme
local DefaultTheme = _Theme.DefaultTheme
local SandstoneTheme = _Theme.SandstoneTheme
local WoodenTheme = _Theme.WoodenTheme
local Choose = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Choose
local CleanUiProvider = TS.import(script, script.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local THEME_ATTRIBUTE = "UILabsSelectedTheme"
local themeControl = Choose({ "Default", "Dark", "Sandstone", "Wooden" })
local persistedTheme = script:GetAttribute(THEME_ATTRIBUTE)
local function isThemeName(value)
	local _value = value
	local _condition = type(_value) == "string"
	if _condition then
		local _exp = themeControl.List
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		local _callback = function(theme)
			return theme == value
		end
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		_condition = _result
	end
	return _condition
end
if isThemeName(persistedTheme) then
	themeControl.ControlValue = persistedTheme
end
local controls = {
	Theme = themeControl,
}
local function createStory(StoryComponent, additionalControls)
	local _object = {}
	if additionalControls then
		for _k, _v in additionalControls do
			_object[_k] = _v
		end
	end
	for _k, _v in controls do
		_object[_k] = _v
	end
	local storyControls = _object
	return {
		react = React,
		reactRoblox = ReactRoblox,
		controls = storyControls,
		story = function(props)
			local baseProps = props
			script:SetAttribute(THEME_ATTRIBUTE, baseProps.controls.Theme)
			local theme = DefaultTheme
			if baseProps.controls.Theme == "Dark" then
				theme = DarkTheme
			end
			if baseProps.controls.Theme == "Sandstone" then
				theme = SandstoneTheme
			end
			if baseProps.controls.Theme == "Wooden" then
				theme = WoodenTheme
			end
			local _attributes = table.clone(props)
			setmetatable(_attributes, nil)
			return React.createElement(CleanUiProvider, {
				theme = theme,
			}, React.createElement(StoryComponent, _attributes))
		end,
	}
end
return {
	createStory = createStory,
}
