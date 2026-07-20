-- Compiled with roblox-ts v3.0.0
local BreakpointHelper
do
	BreakpointHelper = setmetatable({}, {
		__tostring = function()
			return "BreakpointHelper"
		end,
	})
	BreakpointHelper.__index = BreakpointHelper
	function BreakpointHelper.new(...)
		local self = setmetatable({}, BreakpointHelper)
		return self:constructor(...) or self
	end
	function BreakpointHelper:constructor()
	end
	function BreakpointHelper:getValue(breakpoint, value)
		if value == nil then
			return nil
		end
		repeat
			local _fallthrough = false
			if breakpoint == "xl" then
				local _condition = value.xl
				if _condition == nil then
					_condition = value.lg
					if _condition == nil then
						_condition = value.md
						if _condition == nil then
							_condition = value.sm
							if _condition == nil then
								_condition = value.xs
							end
						end
					end
				end
				return _condition
			end
			if breakpoint == "lg" then
				local _condition = value.lg
				if _condition == nil then
					_condition = value.md
					if _condition == nil then
						_condition = value.sm
						if _condition == nil then
							_condition = value.xs
						end
					end
				end
				return _condition
			end
			if breakpoint == "md" then
				local _condition = value.md
				if _condition == nil then
					_condition = value.sm
					if _condition == nil then
						_condition = value.xs
					end
				end
				return _condition
			end
			if breakpoint == "sm" then
				local _condition = value.sm
				if _condition == nil then
					_condition = value.xs
				end
				return _condition
			end
			if breakpoint == "xs" then
			end
			return value.xs
		until true
	end
	function BreakpointHelper:compare(left, operator, right)
		local a = BreakpointHelper.breakpointOrder[left]
		local b = BreakpointHelper.breakpointOrder[right]
		repeat
			local _fallthrough = false
			if operator == ">" then
				return a > b
			end
			if operator == ">=" then
				return a >= b
			end
			if operator == "<" then
				return a < b
			end
			if operator == "<=" then
				return a <= b
			end
			if operator == "!=" then
				return a ~= b
			end
			if operator == "==" then
			end
			return a == b
		until true
	end
	function BreakpointHelper:getBreakpoint(width, breakpoints)
		local active = "xs"
		if breakpoints.sm ~= nil and width >= breakpoints.sm then
			active = "sm"
		end
		if breakpoints.md ~= nil and width >= breakpoints.md then
			active = "md"
		end
		if breakpoints.lg ~= nil and width >= breakpoints.lg then
			active = "lg"
		end
		if breakpoints.xl ~= nil and width >= breakpoints.xl then
			active = "xl"
		end
		return active
	end
	BreakpointHelper.breakpointOrder = {
		xs = 0,
		sm = 1,
		md = 2,
		lg = 3,
		xl = 4,
	}
end
return {
	BreakpointHelper = BreakpointHelper,
}
