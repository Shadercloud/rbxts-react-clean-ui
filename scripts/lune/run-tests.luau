-- Adapted from @rbxts/lunit's `scripts/lunit.luau` (MIT licensed, see
-- node_modules/@rbxts/lunit/LICENSE). Forked locally only to swap in
-- `./lunit-shim` (this repo's fork of @rbxts/lunit's `lune-shim.luau` with a
-- working `TS.getModule`, see lunit-shim.luau for why) in place of the
-- upstream shim -- behavior is otherwise identical, including the reporter
-- (required straight from the vendored package, since it didn't need
-- changes).
--
-- Standalone Lunit runner for Luau/Lune projects.
-- Walks `tests-root` for *.test.luau files, registers each as a test class,
-- and runs them through the compiled Lunit at `lunit-root`. Exits non-zero
-- if any test fails so it composes with CI.
--
-- Usage: lune run scripts/lune/run-tests.luau [tests-root] [lunit-root]
--   tests-root  default: out/Tests
--   lunit-root  default: node_modules/@rbxts/lunit/out

local fs = require("@lune/fs")
local process = require("@lune/process")

local rbxRequire = require("./lunit-shim")
local reporter = require("../../node_modules/@rbxts/lunit/scripts/lune-reporter")

local testsRoot = process.args[1] or "out/Tests"
local lunitRoot = process.args[2] or "node_modules/@rbxts/lunit/out"

local function isTestFile(name)
	return name:match("%.test%.luau$") ~= nil or name:match("%.spec%.luau$") ~= nil
end

local function discover(root, found)
	if not fs.isDir(root) then
		return found
	end
	for _, name in fs.readDir(root) do
		local path = root .. "/" .. name
		if fs.isDir(path) then
			discover(path, found)
		elseif isTestFile(name) then
			table.insert(found, (path:gsub("%.luau$", "")))
		end
	end
	return found
end

local lunit = rbxRequire(lunitRoot)

local classes = {}
for _, modulePath in ipairs(discover(testsRoot, {})) do
	local cls = rbxRequire(modulePath)
	if cls ~= nil then
		table.insert(classes, cls)
	end
end

if #classes == 0 then
	print("No tests found in " .. testsRoot)
	process.exit(1)
end

local result = lunit.TestRunner:fromClasses(classes):run({ reporter = reporter }):expect()
process.exit(if result.numTestsFailed > 0 then 1 else 0)
