-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _Theme = TS.import(script, script.Parent.Parent, "Theme")
local DarkTheme = _Theme.DarkTheme
local DefaultTheme = _Theme.DefaultTheme
local Choose = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Choose
local _ = TS.import(script, script.Parent.Parent, "Providers")
local OverlayProvider = _.OverlayProvider
local ThemeProvider = _.ThemeProvider
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
			}, React.createElement(OverlayProvider, nil, render(props)))
		end,
	}
end
return {
	createStory = createStory,
}
