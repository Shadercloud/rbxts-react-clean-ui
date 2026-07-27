-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local CustomInputService = TS.import(script, script.Parent.Parent.Parent, "Interfaces").CustomInputService
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local BoxShadow = TS.import(script, script.Parent.Parent, "Decorator").BoxShadow
local Slider
do
	local super = Component
	Slider = setmetatable({}, {
		__tostring = function()
			return "Slider"
		end,
		__index = super,
	})
	Slider.__index = Slider
	function Slider.new(...)
		local self = setmetatable({}, Slider)
		return self:constructor(...) or self
	end
	function Slider:constructor(...)
		super.constructor(self, ...)
		self.isDragging = false
		self.containerRef = React.createRef()
		self.state = {
			value = self:getInitialValue(),
			dragging = false,
			hoveredHandle = nil,
		}
	end
	function Slider:getInitialValue()
		local _condition = self.props["min-value"]
		if _condition == nil then
			_condition = 0
		end
		local minValue = _condition
		local maxValue = self.props["max-value"]
		if self.props.range then
			local _value = self.props.value
			return if typeof(_value) == "Vector2" then self.props.value else Vector2.new(minValue, maxValue)
		end
		local _value = self.props.value
		return if type(_value) == "number" then self.props.value else minValue
	end
	function Slider:getCurrentValue()
		if self.props.controlled then
			local value = self.props.value
			if self.props.range then
				local _result
				if typeof(value) == "Vector2" then
					_result = value
				else
					local _condition = self.props["min-value"]
					if _condition == nil then
						_condition = 0
					end
					_result = Vector2.new(_condition, self.props["max-value"])
				end
				return _result
			end
			local _result
			if type(value) == "number" then
				_result = value
			else
				local _condition = self.props["min-value"]
				if _condition == nil then
					_condition = 0
				end
				_result = _condition
			end
			return _result
		end
		return self.state.value
	end
	function Slider:getNumberFromInput(input)
		local container = self.containerRef.current
		if not container then
			return nil
		end
		local containerWidth = container.AbsoluteSize.X
		if containerWidth <= 0 then
			return nil
		end
		local inputX = input.Position.X
		local containerStart = container.AbsolutePosition.X
		local percentage = math.clamp((inputX - containerStart) / containerWidth, 0, 1)
		local _condition = self.props["min-value"]
		if _condition == nil then
			_condition = 0
		end
		local minValue = _condition
		local maxValue = self.props["max-value"]
		local value = minValue + percentage * (maxValue - minValue)
		local step = self.props.step
		if step ~= nil and step > 0 then
			--[[
				
				             * Offset snapping from minValue so ranges such as
				             * min=5, step=2 produce 5, 7, 9, etc.
				             
			]]
			value = minValue + math.round((value - minValue) / step) * step
			-- Remove floating-point artifacts.
			local parts = string.split(tostring(step), ".")
			local decimals = if #parts > 1 then #parts[2] else 0
			local scale = 10 ^ decimals
			value = math.round(value * scale) / scale
		end
		return math.clamp(value, minValue, maxValue)
	end
	function Slider:getValueFromInput(input)
		local inputValue = self:getNumberFromInput(input)
		if inputValue == nil then
			return nil
		end
		if not self.props.range then
			return inputValue
		end
		local currentValue = self:getCurrentValue()
		local _result
		if typeof(currentValue) == "Vector2" then
			_result = currentValue
		else
			local _condition = self.props["min-value"]
			if _condition == nil then
				_condition = 0
			end
			_result = Vector2.new(_condition, self.props["max-value"])
		end
		local rangeValue = _result
		if self.activeHandle == 0 then
			return Vector2.new(math.min(inputValue, rangeValue.Y), rangeValue.Y)
		end
		if self.activeHandle == 1 then
			return Vector2.new(rangeValue.X, math.max(inputValue, rangeValue.X))
		end
		return rangeValue
	end
	function Slider:beginDragging(handle, input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return nil
		end
		self.activeHandle = handle
		self.isDragging = true
		local value = self:getValueFromInput(input)
		local _self = self
		local _object = {
			dragging = true,
		}
		local _left = "value"
		local _condition = value
		if _condition == nil then
			_condition = self.state.value
		end
		_object[_left] = _condition
		_self:setState(_object)
		if value ~= nil then
			local _result = self.props.onDragged
			if _result ~= nil then
				_result(value)
			end
		end
	end
	function Slider:componentDidMount()
		self.inputChangedListener = CustomInputService.InputChanged:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return nil
			end
			if not self.isDragging then
				return nil
			end
			local value = self:getValueFromInput(input)
			if value == nil then
				return nil
			end
			self:setState({
				value = value,
			})
			local _result = self.props.onDragged
			if _result ~= nil then
				_result(value)
			end
		end)
		self.inputEndedListener = CustomInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return nil
			end
			if not self.isDragging then
				return nil
			end
			--[[
				
				                     * Stop processing movement immediately, before
				                     * React gets around to updating the state.
				                     
			]]
			self.isDragging = false
			local value = self:getValueFromInput(input)
			self.activeHandle = nil
			local _self = self
			local _object = {}
			local _left = "value"
			local _condition = value
			if _condition == nil then
				_condition = self.state.value
			end
			_object[_left] = _condition
			_object.dragging = false
			_object.hoveredHandle = React.None
			_self:setState(_object)
			if value ~= nil then
				local _result = self.props.onChanged
				if _result ~= nil then
					_result(value)
				end
			end
		end)
	end
	function Slider:componentWillUnmount()
		self.isDragging = false
		self.activeHandle = nil
		local _result = self.inputChangedListener
		if _result ~= nil then
			_result:Disconnect()
		end
		local _result_1 = self.inputEndedListener
		if _result_1 ~= nil then
			_result_1:Disconnect()
		end
	end
	function Slider:render()
		local theme = self.context.components.slider
		local height = SizeHelper:toUDim(theme.height)
		local _condition = self.props["min-value"]
		if _condition == nil then
			_condition = 0
		end
		local minValue = _condition
		local maxValue = self.props["max-value"]
		local valueRange = maxValue - minValue
		local currentValue = self:getCurrentValue()
		local firstValue
		local secondValue
		if self.props.range and typeof(currentValue) == "Vector2" then
			firstValue = currentValue.X
			secondValue = currentValue.Y
		else
			firstValue = if type(currentValue) == "number" then currentValue else currentValue.X
		end
		local getPosition = function(value)
			if valueRange <= 0 then
				return 0
			end
			return math.clamp((value - minValue) / valueRange, 0, 1)
		end
		local firstPosition = getPosition(firstValue)
		local secondPosition = if secondValue ~= nil then getPosition(secondValue) else nil
		local padding = SizeHelper:toUDim(theme.bar.padding)
		local handles = { {
			index = 0,
			position = firstPosition,
		} }
		if self.props.range and secondPosition ~= nil then
			local _arg0 = {
				index = 1,
				position = secondPosition,
			}
			table.insert(handles, _arg0)
		end
		local _exp = React.createElement("frame", {
			Size = UDim2.new(UDim.new(1, 0), SizeHelper:toUDim(theme.bar.height)),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = theme.bar.backgroundTransparency,
			BackgroundColor3 = theme.bar.backgroundColor,
		}, React.createElement("uistroke", {
			Thickness = theme.bar.borderThickness,
			Color = theme.bar.borderColor,
		}), React.createElement("uicorner", {
			CornerRadius = SizeHelper:toUDim(theme.bar.cornerRadius),
		}))
		local _attributes = {
			ref = self.containerRef,
		}
		local _exp_1 = UDim2.fromScale(1, 1)
		local _uDim2 = UDim2.new(padding + padding, UDim.new(0, 0))
		_attributes.Size = _exp_1 - _uDim2
		_attributes.BackgroundTransparency = 1
		_attributes.Position = UDim2.fromScale(0.5, 0.5)
		_attributes.AnchorPoint = Vector2.new(0.5, 0.5)
		local _condition_1 = self.props.highlight ~= nil
		if _condition_1 then
			local _attributes_1 = {
				BackgroundColor3 = theme.bar.highlight.backgroundColor,
				BackgroundTransparency = theme.bar.highlight.backgroundTransparency,
			}
			local _result
			if self.props.highlight == "start" then
				local _exp_2 = UDim2.fromScale(0, 0.5)
				local _uDim2_1 = UDim2.new(padding, UDim.new(0, 0))
				_result = _exp_2 - _uDim2_1
			else
				local _result_1
				if self.props.highlight == "end" then
					local _exp_2 = UDim2.fromScale(1, 0.5)
					local _uDim2_1 = UDim2.new(padding, UDim.new(0, 0))
					_result_1 = _exp_2 + _uDim2_1
				else
					_result_1 = UDim2.fromScale(firstPosition, 0.5)
				end
				_result = _result_1
			end
			_attributes_1.Position = _result
			_attributes_1.AnchorPoint = if self.props.highlight == "end" then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
			local _result_1
			if self.props.highlight == "start" then
				local _uDim2_1 = UDim2.new(UDim.new(firstPosition, 0), SizeHelper:toUDim(theme.bar.height))
				local _uDim2_2 = UDim2.new(padding, UDim.new(0, 0))
				_result_1 = _uDim2_1 + _uDim2_2
			else
				local _result_2
				if self.props.highlight == "end" then
					local _condition_2 = secondPosition
					if _condition_2 == nil then
						_condition_2 = firstPosition
					end
					local _uDim2_1 = UDim2.new(UDim.new(1 - _condition_2, 0), SizeHelper:toUDim(theme.bar.height))
					local _uDim2_2 = UDim2.new(padding, UDim.new(0, 0))
					_result_2 = _uDim2_1 + _uDim2_2
				else
					local _condition_2 = secondPosition
					if _condition_2 == nil then
						_condition_2 = 0
					end
					_result_2 = UDim2.new(UDim.new(_condition_2 - firstPosition, 0), SizeHelper:toUDim(theme.bar.height))
				end
				_result_1 = _result_2
			end
			_attributes_1.Size = _result_1
			_condition_1 = React.createElement("frame", _attributes_1, React.createElement("uistroke", {
				Thickness = theme.bar.borderThickness,
				Color = theme.bar.highlight.borderColor,
			}), React.createElement("uicorner", {
				CornerRadius = SizeHelper:toUDim(theme.bar.cornerRadius),
			}))
		end
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#handles)
		local _callback = function(_param)
			local index = _param.index
			local position = _param.position
			local _exp_2 = React.createElement("uistroke", {
				Thickness = theme.handle.borderThickness,
				Color = theme.handle.borderColor,
			})
			local _exp_3 = React.createElement("uicorner", {
				CornerRadius = SizeHelper:toUDim(theme.handle.cornerRadius),
			})
			local _exp_4 = (self.state.hoveredHandle == index or (self.state.dragging and self.activeHandle == index)) and (React.createElement(BoxShadow, {
				["box-shadow"] = theme.handle.boxShadow,
			}))
			local _attributes_1 = {}
			local _condition_2 = theme.handle.aspectRation
			if _condition_2 == nil then
				_condition_2 = 1
			end
			_attributes_1.AspectRatio = _condition_2
			_attributes_1.DominantAxis = Enum.DominantAxis.Height
			_attributes_1.AspectType = Enum.AspectType.ScaleWithParentSize
			return React.createElement("frame", {
				key = index,
				Position = UDim2.fromScale(position, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromScale(0, 1),
				BackgroundTransparency = theme.handle.backgroundTransparency,
				BackgroundColor3 = theme.handle.backgroundColor,
				BorderSizePixel = 0,
				Event = {
					InputBegan = function(_instance, input)
						self:beginDragging(index, input)
					end,
					MouseEnter = function()
						self:setState({
							hoveredHandle = index,
						})
					end,
					MouseLeave = function()
						self:setState(function(state)
							return {
								hoveredHandle = if state.hoveredHandle == index then React.None else (if state.hoveredHandle == nil then React.None else state.hoveredHandle),
							}
						end)
					end,
				},
			}, _exp_2, _exp_3, _exp_4, React.createElement("uiaspectratioconstraint", _attributes_1))
		end
		for _k, _v in handles do
			_newValue[_k] = _callback(_v, _k - 1, handles)
		end
		-- ▲ ReadonlyArray.map ▲
		return React.createElement("frame", {
			Size = UDim2.new(UDim.new(1, 0), height),
			BackgroundTransparency = 1,
		}, _exp, React.createElement("frame", _attributes, _condition_1, _newValue))
	end
	Slider.contextType = CleanThemeContext
	Slider = ReactComponent(Slider) or Slider
end
return {
	Slider = Slider,
}
