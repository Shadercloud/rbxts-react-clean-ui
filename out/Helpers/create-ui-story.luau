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
local function createStory(StoryComponent)
	return {
		react = React,
		reactRoblox = ReactRoblox,
		controls = controls,
		story = function(props)
			local theme = DefaultTheme
			if props.controls.Theme == "Dark" then
				theme = DarkTheme
			end
			if props.controls.Theme == "Sandstone" then
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
