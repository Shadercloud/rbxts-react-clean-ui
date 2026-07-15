-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent, "Contexts").CleanThemeContext
local function ThemeProvider(props)
	return React.createElement(CleanThemeContext.Provider, {
		value = props.theme,
	}, props.children)
end
return {
	ThemeProvider = ThemeProvider,
}
