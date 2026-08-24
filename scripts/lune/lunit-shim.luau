--!nolint LocalShadow
-- Adapted from @rbxts/lunit's `scripts/lune-shim.luau` (MIT licensed, see
-- node_modules/@rbxts/lunit/LICENSE). Forked locally because the upstream
-- shim's `buildTS()` is a private closure with no extension point, and it
-- does not implement `TS.getModule` at all -- roblox-ts unconditionally
-- compiles any `node_modules` import into a `TS.getModule(script, scope,
-- moduleName)` call (see e.g. `out/Tests/Smoke.test.luau`'s
-- `TS.getModule(script, "@rbxts", "lunit")`), so without this every test
-- file that imports `@rbxts/lunit` crashes under Lune with
-- "attempt to call a nil value".
--
-- Everything below is unchanged from the upstream shim except:
--   1. The `require("./promise")` path, which now points back at the
--      vendored `@rbxts/lunit` package instead of duplicating that file.
--   2. The addition of `TS.getModule` inside `buildTS()`, implemented by
--      walking up `__path` segments (mirroring the `Parent` case already
--      handled by `makeScript`'s metatable) and checking the filesystem for
--      `<ancestor>/node_modules/<scope>/<moduleName>`, mirroring the real
--      Roblox `TS.getModule` (node_modules/roblox-ts/include/RuntimeLib.lua)
--      which walks up Instance ancestors looking for a `node_modules` child.
--
-- Minimal shim that lets Lune run roblox-ts compiled output.
--
-- roblox-ts emits `local TS = _G[script]` and `TS.import(script, fromScript, ...path)`,
-- which expects a Roblox-style `script` Instance and a runtime helper at `_G[script]`.
-- We synthesize both: each module gets a script-like table whose Parent/child
-- indexing maps to filesystem paths, and `_G[scriptObj]` exposes the runtime helpers
-- (import, async, await, try, getModule, Promise, etc).

local fs = require("@lune/fs")
local luau = require("@lune/luau")
local task = require("@lune/task")
local stdio = require("@lune/stdio")
local Promise = require("../../node_modules/@rbxts/lunit/scripts/promise")

local DEFAULT_SCOPE = "@rbxts"

_G.task = task
_G.warn = function(...)
	local parts = { ... }
	for i, v in ipairs(parts) do
		parts[i] = tostring(v)
	end
	stdio.ewrite(stdio.color("yellow") .. table.concat(parts, "\t") .. stdio.color("reset") .. "\n")
end

local cache = {}
local scriptByPath = {}

local function makeScript(path)
	local existing = scriptByPath[path]
	if existing then
		return existing
	end
	local self = { __path = path }
	setmetatable(self, {
		__index = function(_, key)
			if key == "Parent" then
				local cut = string.find(path, "/[^/]*$")
				if not cut then
					return nil
				end
				return makeScript(string.sub(path, 1, cut - 1))
			end
			return makeScript(path .. "/" .. tostring(key))
		end,
		__tostring = function()
			return "Script(" .. path .. ")"
		end,
	})
	scriptByPath[path] = self
	return self
end

local function resolveFile(path)
	local asFile = path .. ".luau"
	if fs.isFile(asFile) then
		return asFile
	end
	local asInit = path .. "/init.luau"
	if fs.isFile(asInit) then
		return asInit
	end
	return nil
end

-- Forward-declared so `import` can recurse.
local loadModule

-- Build the TS runtime helpers. Mirrors RuntimeLib.lua but skips Roblox-only
-- paths (the _G[module] guard) and uses our shim's loader for TS.import.
-- Unlike upstream, `TS.getModule` IS implemented here (see file header).
local function buildTS()
	local TS = { Promise = Promise }

	function TS.import(_caller, module, ...)
		local target = module
		for i = 1, select("#", ...) do
			target = target[(select(i, ...))]
		end
		return loadModule(target)
	end

	-- Walks up `context.__path` (same segment-truncation logic as the
	-- `Parent` case in `makeScript`'s __index) looking for an ancestor
	-- directory containing `node_modules/<scope>/<moduleName>`, exactly
	-- mirroring the real `TS.getModule`'s ancestor walk over Roblox
	-- Instances -- but erroring loudly instead of silently returning nil,
	-- since a nil return here is what caused the original "attempt to call
	-- a nil value" crash further down the chain.
	function TS.getModule(context, scope, moduleName)
		if moduleName == nil then
			moduleName = scope
			scope = DEFAULT_SCOPE
		end

		local current = context.__path
		while true do
			local candidate = (current == "" and "" or current .. "/") .. "node_modules/" .. scope .. "/" .. moduleName
			if fs.isDir(candidate) or resolveFile(candidate) ~= nil then
				return makeScript(candidate)
			end

			if current == "" then
				break
			end

			local cut = string.find(current, "/[^/]*$")
			current = if cut then string.sub(current, 1, cut - 1) else ""
		end

		error(
			string.format(
				'TS.getModule: could not find an ancestor with "node_modules/%s/%s" (starting from "%s")',
				scope,
				moduleName,
				context.__path
			),
			2
		)
	end

	function TS.async(callback)
		return function(...)
			local n = select("#", ...)
			local args = { ... }
			return Promise.new(function(resolve, reject)
				coroutine.wrap(function()
					local ok, result = pcall(callback, table.unpack(args, 1, n))
					if ok then
						resolve(result)
					else
						reject(result)
					end
				end)()
			end)
		end
	end

	function TS.await(p)
		if not Promise.is(p) then
			return p
		end
		local status, value = p:awaitStatus()
		if status == Promise.Status.Resolved then
			return value
		elseif status == Promise.Status.Rejected then
			error(value, 2)
		else
			error("The awaited Promise was cancelled", 2)
		end
	end

	function TS.instanceof(obj, class)
		if type(class) == "table" and type(class.instanceof) == "function" then
			return class.instanceof(obj)
		end
		if type(obj) == "table" then
			obj = getmetatable(obj)
			while obj ~= nil do
				if obj == class then
					return true
				end
				local mt = getmetatable(obj)
				obj = mt and mt.__index or nil
			end
		end
		return false
	end

	TS.TRY_RETURN = 1
	TS.TRY_BREAK = 2
	TS.TRY_CONTINUE = 3

	function TS.try(try, catchFn, finallyFn)
		local trySuccess, exitTypeOrTryError, returns = pcall(try)
		local exitType, tryError
		if trySuccess then
			exitType = exitTypeOrTryError
		else
			tryError = exitTypeOrTryError
		end

		local catchSuccess, catchError = true, nil
		if not trySuccess and catchFn then
			local newExitTypeOrCatchError, newReturns
			catchSuccess, newExitTypeOrCatchError, newReturns = pcall(catchFn, tryError)
			local newExitType
			if catchSuccess then
				newExitType = newExitTypeOrCatchError
			else
				catchError = newExitTypeOrCatchError
			end
			if newExitType then
				exitType, returns = newExitType, newReturns
			end
		end

		if finallyFn then
			local newExitType, newReturns = finallyFn()
			if newExitType then
				exitType, returns = newExitType, newReturns
			end
		end

		if exitType ~= TS.TRY_RETURN and exitType ~= TS.TRY_BREAK and exitType ~= TS.TRY_CONTINUE then
			if not catchSuccess then
				error(catchError, 2)
			end
			if not trySuccess and not catchFn then
				error(tryError, 2)
			end
		end

		return exitType, returns
	end

	function TS.bit_lrsh(a, b)
		return bit32.arshift(a, b)
	end

	return TS
end

function loadModule(scriptObj)
	local path = scriptObj.__path
	local cached = cache[path]
	if cached ~= nil then
		return cached
	end

	local filePath = resolveFile(path)
	if not filePath then
		error("module not found: " .. path, 2)
	end

	-- Provide TS runtime for this module before its chunk runs.
	_G[scriptObj] = buildTS()

	-- Lune's loaded chunks don't inherit globals from the caller, so inject
	-- `script` (per-module) plus the Roblox-flavored globals we've stubbed in _G.
	local source = "local script, task, warn = ..., _G.task, _G.warn\n" .. fs.readFile(filePath)
	local chunk = luau.load(source, { debugName = path })
	local result = chunk(scriptObj)
	cache[path] = result
	return result
end

local function rbxRequire(path)
	return loadModule(makeScript(path))
end

return rbxRequire
