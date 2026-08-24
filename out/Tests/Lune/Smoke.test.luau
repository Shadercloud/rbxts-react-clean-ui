-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Smoke
do
	Smoke = setmetatable({}, {
		__tostring = function()
			return "Smoke"
		end,
	})
	Smoke.__index = Smoke
	function Smoke.new(...)
		local self = setmetatable({}, Smoke)
		return self:constructor(...) or self
	end
	function Smoke:constructor()
	end
	function Smoke:addsTwoNumbers()
		Assert:equal(1 + 1, 2)
	end
	local _descriptor = Test(Smoke, "addsTwoNumbers", {
		value = Smoke.addsTwoNumbers,
	})
	if _descriptor then
		Smoke.addsTwoNumbers = _descriptor.value
	end
end
return Smoke
