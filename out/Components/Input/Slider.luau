-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CustomInputService = TS.import(script, script.Parent.Parent.Parent, "Helpers").CustomInputService
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local BoxShadow = TS.import(script, script.Parent.Parent, "Decorator").BoxShadow
local Slider = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext).components.slider
	local containerRef = React.useRef()
	local isDraggingRef = React.useRef(false)
	local activeHandleRef = React.useRef()
	local getInitialValue = function()
		local _condition = props["min-value"]
		if _condition == nil then
			_condition = 0
		end
		local minValue = _condition
		local maxValue = props["max-value"]
		if props.range then
			local _value = props.value
			return if typeof(_value) == "Vector2" then props.value else Vector2.new(minValue, maxValue)
		end
		local _value = props.value
		return if type(_value) == "number" then props.value else minValue
	end
	local value, setValue = React.useState(getInitialValue)
	local dragging, setDragging = React.useState(false)
	local hoveredHandle, setHoveredHandle = React.useState()
	local propsRef = React.useRef(props)
	propsRef.current = props
	local currentValue = React.useMemo(function()
		if props.controlled then
			if props.range then
				local _value = props.value
				local _result
				if typeof(_value) == "Vector2" then
					_result = props.value
				else
					local _condition = props["min-value"]
					if _condition == nil then
						_condition = 0
					end
					_result = Vector2.new(_condition, props["max-value"])
				end
				return _result
			end
			local _value = props.value
			local _result
			if type(_value) == "number" then
				_result = props.value
			else
				local _condition = props["min-value"]
				if _condition == nil then
					_condition = 0
				end
				_result = _condition
			end
			return _result
		end
		return value
	end, { props.controlled, props.range, props.value, props["min-value"], props["max-value"], value })
	local currentValueRef = React.useRef(currentValue)
	currentValueRef.current = currentValue
	local updateValue = React.useCallback(function(nextValue)
		if not propsRef.current.controlled then
			currentValueRef.current = nextValue
		end
		setValue(nextValue)
	end, {})
	--[[
		*
		         * Converts an input position into a single slider value.
		         
	]]
	local getNumberFromInput = React.useCallback(function(input)
		local container = containerRef.current
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
		local currentProps = propsRef.current
		local _condition = currentProps["min-value"]
		if _condition == nil then
			_condition = 0
		end
		local minValue = _condition
		local maxValue = currentProps["max-value"]
		local nextValue = minValue + percentage * (maxValue - minValue)
		local step = currentProps.step
		if step ~= nil and step > 0 then
			--[[
				
				                     * Offset snapping from minValue so ranges such as
				                     * min=5, step=2 produce 5, 7, 9, etc.
				                     
			]]
			nextValue = minValue + math.round((nextValue - minValue) / step) * step
			-- Remove floating-point artifacts.
			local parts = string.split(tostring(step), ".")
			local decimals = if #parts > 1 then #parts[2] else 0
			local scale = 10 ^ decimals
			nextValue = math.round(nextValue * scale) / scale
		end
		return math.clamp(nextValue, minValue, maxValue)
	end, {})
	--[[
		*
		         * Converts a single input value into either a number or Vector2,
		         * depending on whether range mode is enabled.
		         
	]]
	local getValueFromInput = React.useCallback(function(input)
		local inputValue = getNumberFromInput(input)
		if inputValue == nil then
			return nil
		end
		local currentProps = propsRef.current
		if not currentProps.range then
			return inputValue
		end
		local _current = currentValueRef.current
		local _result
		if typeof(_current) == "Vector2" then
			_result = currentValueRef.current
		else
			local _condition = currentProps["min-value"]
			if _condition == nil then
				_condition = 0
			end
			_result = Vector2.new(_condition, currentProps["max-value"])
		end
		local rangeValue = _result
		if activeHandleRef.current == 0 then
			return Vector2.new(math.min(inputValue, rangeValue.Y), rangeValue.Y)
		end
		if activeHandleRef.current == 1 then
			return Vector2.new(rangeValue.X, math.max(inputValue, rangeValue.X))
		end
		return rangeValue
	end, { getNumberFromInput })
	local beginDragging = React.useCallback(function(handle, input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return nil
		end
		activeHandleRef.current = handle
		isDraggingRef.current = true
		local nextValue = getValueFromInput(input)
		setDragging(true)
		if nextValue ~= nil then
			updateValue(nextValue)
			local _result = propsRef.current.onDragged
			if _result ~= nil then
				_result(nextValue)
			end
		end
	end, { getValueFromInput, updateValue })
	React.useEffect(function()
		local inputChangedListener = CustomInputService.InputChanged:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
				return nil
			end
			if not isDraggingRef.current then
				return nil
			end
			local nextValue = getValueFromInput(input)
			if nextValue == nil then
				return nil
			end
			updateValue(nextValue)
			local _result = propsRef.current.onDragged
			if _result ~= nil then
				_result(nextValue)
			end
		end)
		local inputEndedListener = CustomInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
				return nil
			end
			if not isDraggingRef.current then
				return nil
			end
			--[[
				
				                         * Stop processing movement immediately, before
				                         * React gets around to updating the state.
				                         
			]]
			isDraggingRef.current = false
			local nextValue = getValueFromInput(input)
			activeHandleRef.current = nil
			setDragging(false)
			setHoveredHandle(nil)
			if nextValue ~= nil then
				updateValue(nextValue)
				local _result = propsRef.current.onChanged
				if _result ~= nil then
					_result(nextValue)
				end
			end
		end)
		return function()
			isDraggingRef.current = false
			activeHandleRef.current = nil
			inputChangedListener:Disconnect()
			inputEndedListener:Disconnect()
		end
	end, { getValueFromInput, updateValue })
	local height = SizeHelper:toUDim(theme.height)
	local _condition = props["min-value"]
	if _condition == nil then
		_condition = 0
	end
	local minValue = _condition
	local maxValue = props["max-value"]
	local valueRange = maxValue - minValue
	local firstValue
	local secondValue
	if props.range and typeof(currentValue) == "Vector2" then
		firstValue = currentValue.X
		secondValue = currentValue.Y
	else
		firstValue = if type(currentValue) == "number" then currentValue else currentValue.X
	end
	local getPosition = function(sliderValue)
		if valueRange <= 0 then
			return 0
		end
		return math.clamp((sliderValue - minValue) / valueRange, 0, 1)
	end
	local firstPosition = getPosition(firstValue)
	local secondPosition = if secondValue ~= nil then getPosition(secondValue) else nil
	local padding = SizeHelper:toUDim(theme.bar.padding)
	local handles = { {
		index = 0,
		position = firstPosition,
	} }
	if props.range and secondPosition ~= nil then
		local _arg0 = {
			index = 1,
			position = secondPosition,
		}
		table.insert(handles, _arg0)
	end
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Slider"
	end
	_attributes.key = _condition_1
	_attributes.ref = ref
	_attributes.Archivable = props.Archivable
	_attributes.Tag = props.Tag
	_attributes.Active = props.Active
	_attributes.AnchorPoint = SizeHelper:GetAnchor(props)
	_attributes.BackgroundColor3 = props.BackgroundColor3
	local _condition_2 = props.BackgroundTransparency
	if _condition_2 == nil then
		_condition_2 = 1
	end
	_attributes.BackgroundTransparency = _condition_2
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.Interactable = props.Interactable
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.Position = SizeHelper:GetPosition(props)
	_attributes.Rotation = props.Rotation
	_attributes.Selectable = props.Selectable
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.SelectionOrder = props.SelectionOrder
	_attributes.Size = SizeHelper:GetSize(props, UDim2.new(UDim.new(1, 0), height))
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Visible = props.Visible
	_attributes.ZIndex = props.ZIndex
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.Style = props.Style
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	local _exp = React.createElement("frame", {
		key = "Bar",
		Size = UDim2.new(UDim.new(1, 0), SizeHelper:toUDim(theme.bar.height)),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = theme.bar.backgroundTransparency,
		BackgroundColor3 = theme.bar.backgroundColor,
	}, React.createElement("uistroke", {
		key = "Stroke",
		Thickness = theme.bar.borderThickness,
		Color = theme.bar.borderColor,
	}), React.createElement("uicorner", {
		key = "Corners",
		CornerRadius = SizeHelper:toUDim(theme.bar.cornerRadius),
	}))
	local _attributes_1 = {
		key = "HandleContainer",
		ref = containerRef,
	}
	local _exp_1 = UDim2.fromScale(1, 1)
	local _uDim2 = UDim2.new(padding + padding, UDim.new(0, 0))
	_attributes_1.Size = _exp_1 - _uDim2
	_attributes_1.BackgroundTransparency = 1
	_attributes_1.Position = UDim2.fromScale(0.5, 0.5)
	_attributes_1.AnchorPoint = Vector2.new(0.5, 0.5)
	local _condition_3 = props.highlight ~= nil
	if _condition_3 then
		local _attributes_2 = {
			key = "Highlight",
			BackgroundColor3 = theme.bar.highlight.backgroundColor,
			BackgroundTransparency = theme.bar.highlight.backgroundTransparency,
		}
		local _result
		if props.highlight == "start" then
			local _exp_2 = UDim2.fromScale(0, 0.5)
			local _uDim2_1 = UDim2.new(padding, UDim.new(0, 0))
			_result = _exp_2 - _uDim2_1
		else
			local _result_1
			if props.highlight == "end" then
				local _exp_2 = UDim2.fromScale(1, 0.5)
				local _uDim2_1 = UDim2.new(padding, UDim.new(0, 0))
				_result_1 = _exp_2 + _uDim2_1
			else
				_result_1 = UDim2.fromScale(firstPosition, 0.5)
			end
			_result = _result_1
		end
		_attributes_2.Position = _result
		_attributes_2.AnchorPoint = if props.highlight == "end" then Vector2.new(1, 0.5) else Vector2.new(0, 0.5)
		local _result_1
		if props.highlight == "start" then
			local _uDim2_1 = UDim2.new(UDim.new(firstPosition, 0), SizeHelper:toUDim(theme.bar.height))
			local _uDim2_2 = UDim2.new(padding, UDim.new(0, 0))
			_result_1 = _uDim2_1 + _uDim2_2
		else
			local _result_2
			if props.highlight == "end" then
				local _condition_4 = secondPosition
				if _condition_4 == nil then
					_condition_4 = firstPosition
				end
				local _uDim2_1 = UDim2.new(UDim.new(1 - _condition_4, 0), SizeHelper:toUDim(theme.bar.height))
				local _uDim2_2 = UDim2.new(padding, UDim.new(0, 0))
				_result_2 = _uDim2_1 + _uDim2_2
			else
				local _condition_4 = secondPosition
				if _condition_4 == nil then
					_condition_4 = 0
				end
				_result_2 = UDim2.new(UDim.new(_condition_4 - firstPosition, 0), SizeHelper:toUDim(theme.bar.height))
			end
			_result_1 = _result_2
		end
		_attributes_2.Size = _result_1
		_condition_3 = (React.createElement("frame", _attributes_2, React.createElement("uistroke", {
			key = "Stroke",
			Thickness = theme.bar.borderThickness,
			Color = theme.bar.highlight.borderColor,
		}), React.createElement("uicorner", {
			key = "Corners",
			CornerRadius = SizeHelper:toUDim(theme.bar.cornerRadius),
		})))
	end
	-- ▼ ReadonlyArray.map ▼
	local _newValue = table.create(#handles)
	local _callback = function(_param)
		local index = _param.index
		local position = _param.position
		local _exp_2 = React.createElement("uistroke", {
			key = "Stroke",
			Thickness = theme.handle.borderThickness,
			Color = theme.handle.borderColor,
		})
		local _exp_3 = React.createElement("uicorner", {
			key = "Corners",
			CornerRadius = SizeHelper:toUDim(theme.handle.cornerRadius),
		})
		local _exp_4 = (hoveredHandle == index or (dragging and activeHandleRef.current == index)) and (React.createElement(BoxShadow, {
			["box-shadow"] = theme.handle.boxShadow,
		}))
		local _attributes_2 = {
			key = "AspectRatio",
		}
		local _condition_4 = theme.handle.aspectRatio
		if _condition_4 == nil then
			_condition_4 = 1
		end
		_attributes_2.AspectRatio = _condition_4
		_attributes_2.DominantAxis = Enum.DominantAxis.Height
		_attributes_2.AspectType = Enum.AspectType.ScaleWithParentSize
		return React.createElement("frame", {
			key = `Handle-{index}`,
			Position = UDim2.fromScale(position, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.fromScale(0, 1),
			BackgroundTransparency = theme.handle.backgroundTransparency,
			BackgroundColor3 = theme.handle.backgroundColor,
			BorderSizePixel = 0,
			Event = {
				InputBegan = function(_instance, input)
					beginDragging(index, input)
				end,
				MouseEnter = function()
					setHoveredHandle(index)
				end,
				MouseLeave = function()
					setHoveredHandle(function(currentHoveredHandle)
						return if currentHoveredHandle == index then nil else currentHoveredHandle
					end)
				end,
			},
		}, _exp_2, _exp_3, _exp_4, React.createElement("uiaspectratioconstraint", _attributes_2))
	end
	for _k, _v in handles do
		_newValue[_k] = _callback(_v, _k - 1, handles)
	end
	-- ▲ ReadonlyArray.map ▲
	return React.createElement("frame", _attributes, _exp, React.createElement("frame", _attributes_1, _condition_3, _newValue))
end)
return {
	Slider = Slider,
}
