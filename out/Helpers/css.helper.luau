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
		-- The one CSS calc() shape supported: "<percent>% - <px>px" /
		-- "<percent>% + <px>px" (e.g. "100% - 50px") maps directly onto
		-- UDim(scale, offset) — split on the literal " - "/" + " separator
		-- and parse each term with this same function. Anything without
		-- either separator falls through to the single-token parsing below,
		-- unchanged.
		local minusParts = string.split(value, " - ")
		if #minusParts == 2 then
			local scale = self:parseCssSize(minusParts[1]).Scale
			local offset = self:parseCssSize(minusParts[2]).Offset
			return UDim.new(scale, -offset)
		end
		local plusParts = string.split(value, " + ")
		if #plusParts == 2 then
			local scale = self:parseCssSize(plusParts[1]).Scale
			local offset = self:parseCssSize(plusParts[2]).Offset
			return UDim.new(scale, offset)
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
	function CssHelper:parseCssQuad(value)
		local _value = value
		if type(_value) == "number" then
			local size = self:parseCssSize(value).Offset
			return {
				top = size,
				right = size,
				bottom = size,
				left = size,
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
		local top = _self:parseCssSize(_condition).Offset
		local _self_1 = self
		local _condition_1 = parts[2]
		if _condition_1 == nil then
			_condition_1 = parts[1]
			if _condition_1 == nil then
				_condition_1 = "0"
			end
		end
		local right = _self_1:parseCssSize(_condition_1).Offset
		local _self_2 = self
		local _condition_2 = parts[3]
		if _condition_2 == nil then
			_condition_2 = parts[1]
			if _condition_2 == nil then
				_condition_2 = "0"
			end
		end
		local bottom = _self_2:parseCssSize(_condition_2).Offset
		local _self_3 = self
		local _condition_3 = parts[4]
		if _condition_3 == nil then
			_condition_3 = parts[2]
			if _condition_3 == nil then
				_condition_3 = parts[1]
				if _condition_3 == nil then
					_condition_3 = "0"
				end
			end
		end
		local left = _self_3:parseCssSize(_condition_3).Offset
		return {
			top = top,
			right = right,
			bottom = bottom,
			left = left,
		}
	end
	function CssHelper:toRawPixels(value)
		local _value = value
		if type(_value) == "number" then
			return value
		end
		if string.sub(value, -1) == "%" then
			local _condition = tonumber(string.sub(value, 1, -2))
			if _condition == nil then
				_condition = 0
			end
			return _condition
		end
		if string.sub(value, -2) == "px" then
			local _condition = tonumber(string.sub(value, 1, -3))
			if _condition == nil then
				_condition = 0
			end
			return _condition
		end
		local _condition = tonumber(value)
		if _condition == nil then
			_condition = 0
		end
		return _condition
	end
	function CssHelper:parseCssSliceInset(value)
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
		-- ▼ ReadonlyArray.map ▼
		local _newValue_1 = table.create(#parts)
		local _callback_1 = function(part)
			return self:toRawPixels(part)
		end
		for _k, _v in parts do
			_newValue_1[_k] = _callback_1(_v, _k - 1, parts)
		end
		-- ▲ ReadonlyArray.map ▲
		local pixels = _newValue_1
		if #pixels == 2 then
			return {
				x1 = pixels[1],
				y1 = pixels[1],
				x2 = pixels[2],
				y2 = pixels[2],
			}
		end
		return {
			x1 = pixels[1],
			y1 = pixels[2],
			x2 = pixels[3],
			y2 = pixels[4],
		}
	end
	function CssHelper:parseCssDual(value)
		local _value = value
		if type(_value) == "number" then
			local size = self:parseCssSize(value)
			return UDim2.new(size, size)
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
		return UDim2.new(x, y)
	end
	function CssHelper:ResolveShadow(shadow)
		local offset = self:parseCssShadow(shadow.shadow)
		local _object = {}
		local _left = "Offset"
		local _result = offset
		if _result ~= nil then
			_result = _result.offset
		end
		_object[_left] = _result
		local _left_1 = "BlurRadius"
		local _result_1 = offset
		if _result_1 ~= nil then
			_result_1 = _result_1.blurRadius
		end
		_object[_left_1] = _result_1
		local _left_2 = "Spread"
		local _result_2 = offset
		if _result_2 ~= nil then
			_result_2 = _result_2.spread
		end
		_object[_left_2] = _result_2
		_object.Color = shadow.color
		_object.Transparency = shadow.transparency
		return _object
	end
	function CssHelper:resolveBackgroundImage(value)
		if value == nil then
			return {}
		end
		local slice = if value.slice ~= nil then self:parseCssSliceInset(value.slice) else nil
		local _object = {}
		local _left = "Image"
		local _image = value.image
		_object[_left] = if type(_image) == "number" then `rbxassetid://{value.image}` else value.image
		_object.ImageColor3 = value.tintColor
		_object.ImageTransparency = value.transparency
		_object.ScaleType = if slice ~= nil then Enum.ScaleType.Slice else (value.size or Enum.ScaleType.Stretch)
		_object.SliceCenter = if slice ~= nil then Rect.new(slice.x1, slice.y1, slice.x2, slice.y2) else nil
		_object.SliceScale = value.sliceScale
		_object.TileSize = if value.tileSize ~= nil then self:parseCssDual(value.tileSize) else nil
		return _object
	end
	function CssHelper:resolveBackgroundGradient(value)
		if value == nil then
			return nil
		end
		local _colors = value.colors
		local color = if typeof(_colors) == "ColorSequence" then value.colors else self:buildColorSequence(value.colors, value.stops)
		return {
			Color = color,
			Transparency = self:buildTransparencySequence(value.transparency),
			Rotation = value.rotation,
			Offset = value.offset,
		}
	end
	function CssHelper:buildColorSequence(colors, stops)
		if #colors == 1 then
			return ColorSequence.new(colors[1])
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#colors)
		local _callback = function(color, index)
			local _result = stops
			if _result ~= nil then
				_result = _result[index + 1]
			end
			local time = if _result ~= nil then math.clamp(stops[index + 1], 0, 1) else index / (#colors - 1)
			return ColorSequenceKeypoint.new(time, color)
		end
		for _k, _v in colors do
			_newValue[_k] = _callback(_v, _k - 1, colors)
		end
		-- ▲ ReadonlyArray.map ▲
		local keypoints = _newValue
		-- Roblox requires the first keypoint's Time to be exactly 0 and the last exactly 1
		keypoints[1] = ColorSequenceKeypoint.new(0, keypoints[1].Value)
		keypoints[#keypoints] = ColorSequenceKeypoint.new(1, keypoints[#keypoints].Value)
		return ColorSequence.new(keypoints)
	end
	function CssHelper:buildTransparencySequence(value)
		if value == nil then
			return nil
		end
		local _value = value
		if typeof(_value) == "NumberSequence" then
			return value
		end
		return NumberSequence.new(math.clamp(value, 0, 1))
	end
end
return {
	CssHelper = CssHelper,
}
