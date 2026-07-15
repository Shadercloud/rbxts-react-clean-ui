-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Theme = TS.import(script, script.Parent.Parent, "Theme")
local ThemeProvider = _Theme.ThemeProvider
local DarkTheme = _Theme.DarkTheme
local DefaultTheme = _Theme.DefaultTheme
local Choose = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Choose
local controls = {
	Theme = Choose({ "Default", "Dark" }),
}
local function createStory(render)
	return {
		react = React,
		reactRoblox = ReactRoblox,
		controls = controls,
		story = function(props)
			local theme = if props.controls.Theme == "Dark" then DarkTheme else DefaultTheme
			return React.createElement(ThemeProvider, {
				theme = theme,
			}, render(props))
		end,
	}
end
return {
	createStory = createStory,
}
