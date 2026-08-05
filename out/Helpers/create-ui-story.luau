-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Theme = TS.import(script, script.Parent.Parent, "Theme")
local DarkTheme = _Theme.DarkTheme
local DefaultTheme = _Theme.DefaultTheme
local SandstoneTheme = _Theme.SandstoneTheme
local Choose = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Choose
local CleanUiProvider = TS.import(script, script.Parent.Parent, "Providers", "app.provider").CleanUiProvider
local controls = {
	Theme = Choose({ "Default", "Dark", "Sandstone" }),
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
			local theme = DefaultTheme
			if baseProps.controls.Theme == "Dark" then
				theme = DarkTheme
			end
			if baseProps.controls.Theme == "Sandstone" then
				theme = SandstoneTheme
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
