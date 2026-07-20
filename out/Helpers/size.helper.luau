-- Compiled with roblox-ts v3.0.0
local breakpointOrder = { "xs", "sm", "md", "lg", "xl" }
local SizeHelper
do
	SizeHelper = setmetatable({}, {
		__tostring = function()
			return "SizeHelper"
		end,
	})
	SizeHelper.__index = SizeHelper
	function SizeHelper.new(...)
		local self = setmetatable({}, SizeHelper)
		return self:constructor(...) or self
	end
	function SizeHelper:constructor()
	end
	function SizeHelper:GetSize(props, defaultSize)
		if props.Size then
			return props.Size
		end
		if props.width == nil and props.height == nil and defaultSize ~= nil then
			return defaultSize
		end
		local width
		if props.width ~= nil then
			if props.width == "Auto" then
				width = 0
			elseif self:isBreakpointSize(props.width) then
				width = self:resolveResponsiveValue(props.width, "sm")
			else
				width = props.width
			end
		end
		return UDim2.new(self:toUDim(width), self:toUDim(props.height))
	end
	function SizeHelper:GetPosition(props)
		if props.Position ~= nil then
			return props.Position
		end
		if props.center ~= nil then
			local _center = props.center
			local c = if type(_center) == "boolean" then (if props.center then "50%" else nil) else props.center
			local center = self:toUDim(c)
			return UDim2.new(center, center)
		end
		local x = if props.left ~= nil then self:toUDim(props.left) elseif props.right ~= nil then self:fromFarEdge(props.right) else UDim.new(0, 0)
		local y = if props.top ~= nil then self:toUDim(props.top) elseif props.bottom ~= nil then self:fromFarEdge(props.bottom) else UDim.new(0, 0)
		return UDim2.new(x, y)
	end
	function SizeHelper:GetAnchor(props)
		if props.AnchorPoint ~= nil then
			return props.AnchorPoint
		end
		if props.center ~= nil then
			return Vector2.new(0.5, 0.5)
		end
		local x = if props.left == nil and props.right ~= nil then 1 else 0
		local y = if props.top == nil and props.bottom ~= nil then 1 else 0
		return Vector2.new(x, y)
	end
	function SizeHelper:GetAutoSize(props, defaultValue)
		if props.AutomaticSize ~= nil then
			return props.AutomaticSize
		end
		if props.width == "Auto" then
			return Enum.AutomaticSize.X
		end
		local _condition = props.Size
		if not _condition then
			local _condition_1 = props.width
			if _condition_1 ~= 0 and _condition_1 == _condition_1 and _condition_1 ~= "" and _condition_1 then
				_condition_1 = props.height
			end
			_condition = _condition_1
		end
		if _condition ~= 0 and _condition == _condition and _condition ~= "" and _condition then
			return Enum.AutomaticSize.None
		end
		if props.width == nil and props.height == nil and defaultValue == nil then
			return Enum.AutomaticSize.XY
		end
		local _value = props.width
		if not (_value ~= 0 and _value == _value and _value ~= "" and _value) then
			return Enum.AutomaticSize.X
		end
		return if defaultValue ~= nil then defaultValue else Enum.AutomaticSize.Y
	end
	function SizeHelper:toUDim(size)
		if size == nil then
			return UDim.new(0, 0)
		end
		local _size = size
		if type(_size) == "number" then
			return UDim.new(0, size)
		end
		local text = (string.gsub(string.lower(size), "%s+", ""))
		if string.sub(text, -1) == "%" then
			local value = self:parseNumber(string.sub(text, 1, -2), size)
			return UDim.new(value / 100, 0)
		end
		if string.sub(text, -2) == "px" then
			local value = self:parseNumber(string.sub(text, 1, -3), size)
			return UDim.new(0, value)
		end
		local value = self:parseNumber(text, size)
		return UDim.new(0, value)
	end
	function SizeHelper:parseNumber(text, originalValue)
		local value = tonumber(text)
		local _arg0 = value ~= nil
		local _arg1 = `Invalid size value "{originalValue}". Expected a number, "25px", or "25%".`
		assert(_arg0, _arg1)
		return value
	end
	function SizeHelper:fromFarEdge(size)
		local value = self:toUDim(size)
		return UDim.new(1 - value.Scale, -value.Offset)
	end
	function SizeHelper:isBreakpointSize(value)
		local _value = value
		return type(_value) == "table"
	end
	function SizeHelper:isBreakpointValue(value)
		local _value = value
		if not (type(_value) == "table") then
			return false
		end
		return value.xs ~= nil or value.sm ~= nil or value.md ~= nil or value.lg ~= nil or value.xl ~= nil
	end
	function SizeHelper:resolveResponsiveValue(value, breakpoint)
		if value == nil then
			return nil
		end
		if not self:isBreakpointValue(value) then
			return value
		end
		local _breakpoint = breakpoint
		local breakpointIndex = (table.find(breakpointOrder, _breakpoint) or 0) - 1
		do
			local index = breakpointIndex
			local _shouldIncrement = false
			while true do
				if _shouldIncrement then
					index -= 1
				else
					_shouldIncrement = true
				end
				if not (index >= 0) then
					break
				end
				local candidate = value[breakpointOrder[index + 1]]
				if candidate ~= nil then
					return candidate
				end
			end
		end
		return nil
	end
end
return {
	SizeHelper = SizeHelper,
}
