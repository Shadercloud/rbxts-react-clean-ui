-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Environment = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Environment
local CustomInputService = if Environment.IsStory() then Environment.InputListener else UserInputService
return {
	CustomInputService = CustomInputService,
}
