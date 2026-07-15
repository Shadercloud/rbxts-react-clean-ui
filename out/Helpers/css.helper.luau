-- Compiled with roblox-ts v3.0.0
local CssHelper
do
	CssHelper = setmetatable({}, {
		__tostring = function()
			return "CssHelper"
		end,
	})
	CssHelper.__index = CssHelper
	function CssHelper.new(...)
		local self = setmetatable({}, CssHelper)
		return self:constructor(...) or self
	end
	function CssHelper:constructor()
	end
	function CssHelper:parseCssShadow(value)
		local _value = value
		if type(_value) == "number" then
			if value == 0 then
				return nil
			end
			local size = self:parseCssSize(value)
			return {
				offset = UDim2.new(size, size),
				blurRadius = UDim.new(0, 0),
				spread = UDim2.new(),
			}
		end
		local _exp = string.split(value, " ")
		-- ▼ ReadonlyArray.filter ▼
		local _newValue = {}
		local _callback = function(part)
			return #part > 0
		end
		local _length = 0
		for _k, _v in _exp do
			if _callback(_v, _k - 1, _exp) == true then
				_length += 1
				_newValue[_length] = _v
			end
		end
		-- ▲ ReadonlyArray.filter ▲
		local parts = _newValue
		local _self = self
		local _condition = parts[1]
		if _condition == nil then
			_condition = "0"
		end
		local x = _self:parseCssSize(_condition)
		local _self_1 = self
		local _condition_1 = parts[2]
		if _condition_1 == nil then
			_condition_1 = parts[1]
			if _condition_1 == nil then
				_condition_1 = "0"
			end
		end
		local y = _self_1:parseCssSize(_condition_1)
		local _self_2 = self
		local _condition_2 = parts[3]
		if _condition_2 == nil then
			_condition_2 = "0"
		end
		local blur = _self_2:parseCssSize(_condition_2)
		local _self_3 = self
		local _condition_3 = parts[4]
		if _condition_3 == nil then
			_condition_3 = "0"
		end
		local spread = _self_3:parseCssSize(_condition_3)
		local isZero = self:isZero(x) and self:isZero(y) and self:isZero(blur) and self:isZero(spread)
		if isZero then
			return nil
		end
		return {
			offset = UDim2.new(x, y),
			blurRadius = blur,
			spread = UDim2.new(spread, spread),
		}
	end
	function CssHelper:isZero(value)
		return value.Scale == 0 and value.Offset == 0
	end
	function CssHelper:parseCssSize(value)
		local _value = value
		if type(_value) == "number" then
			return UDim.new(0, value)
		end
		if string.sub(value, -1) == "%" then
			local _condition = tonumber(string.sub(value, 1, -2))
			if _condition == nil then
				_condition = 0
			end
			local amount = _condition
			return UDim.new(amount / 100, 0)
		end
		if string.sub(value, -2) == "px" then
			local _condition = tonumber(string.sub(value, 1, -3))
			if _condition == nil then
				_condition = 0
			end
			local amount = _condition
			return UDim.new(0, amount)
		end
		local _condition = tonumber(value)
		if _condition == nil then
			_condition = 0
		end
		return UDim.new(0, _condition)
	end
end
return {
	CssHelper = CssHelper,
}
