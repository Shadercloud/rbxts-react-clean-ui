-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local TestRunner = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out).TestRunner
local function runPackageTests()
	return TestRunner.new({ script.Parent }):run()
end
return {
	runPackageTests = runPackageTests,
}
