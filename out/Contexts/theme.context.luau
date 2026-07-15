-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local DefaultTheme = TS.import(script, script.Parent.Parent, "Theme", "themes", "default.theme").DefaultTheme
local CleanThemeContext = React.createContext(DefaultTheme)
return {
	CleanThemeContext = CleanThemeContext,
}
