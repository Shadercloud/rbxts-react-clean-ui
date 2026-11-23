-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local IgnorePreferredTextSizeContext = React.createContext(false)
local function useIgnorePreferredTextSize()
	return React.useContext(IgnorePreferredTextSizeContext)
end
return {
	useIgnorePreferredTextSize = useIgnorePreferredTextSize,
	IgnorePreferredTextSizeContext = IgnorePreferredTextSizeContext,
}
