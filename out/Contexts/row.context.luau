-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local RowContext = React.createContext({
	width = 0,
	padding = UDim.new(0, 0),
	breakpoint = "xl",
	children = 0,
})
return {
	RowContext = RowContext,
}
