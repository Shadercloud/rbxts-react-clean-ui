-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Button_press = TS.import(script, script.Parent, "Button.press")
local isPointerPress = _Button_press.isPointerPress
local usePressRelease = _Button_press.usePressRelease
local HoverButtonContext = React.createContext(nil)
local function HoverButton(propSet)
	local hovering, setHovering = React.useState(false)
	local trackRelease = usePressRelease(propSet.onRelease)
	local state = if propSet.isSelected then "focus" elseif hovering then "hover" else "default"
	local stateProps = propSet[state]
	local _object = table.clone(propSet.default)
	setmetatable(_object, nil)
	if stateProps then
		for _k, _v in stateProps do
			_object[_k] = _v
		end
	end
	local props = _object
	local _condition = props.borderThickness
	if _condition == nil then
		_condition = propSet.borderThickness
		if _condition == nil then
			_condition = 0
		end
	end
	local borderThickness = _condition
	local borderPosition = props.borderPosition or propSet.borderPosition
	local defaultEvents = propSet.default.Event
	local _stateEvents = stateProps
	if _stateEvents ~= nil then
		_stateEvents = _stateEvents.Event
	end
	local stateEvents = _stateEvents
	local _result = stateEvents
	if _result ~= nil then
		_result = _result.Activated
	end
	local _condition_1 = _result
	if _condition_1 == nil then
		local _result_1 = defaultEvents
		if _result_1 ~= nil then
			_result_1 = _result_1.Activated
		end
		_condition_1 = _result_1
	end
	local activated = _condition_1
	local _result_1 = stateEvents
	if _result_1 ~= nil then
		_result_1 = _result_1.InputBegan
	end
	local _condition_2 = _result_1
	if _condition_2 == nil then
		local _result_2 = defaultEvents
		if _result_2 ~= nil then
			_result_2 = _result_2.InputBegan
		end
		_condition_2 = _result_2
	end
	local inputBegan = _condition_2
	local _attributes = {}
	local _condition_3 = propSet.name
	if _condition_3 == nil then
		_condition_3 = "HoverButton"
	end
	_attributes.key = _condition_3
	_attributes.Active = props.Active
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.Archivable = props.Archivable
	_attributes.AutoButtonColor = props.AutoButtonColor
	_attributes.AutomaticSize = props.AutomaticSize
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BackgroundTransparency = props.BackgroundTransparency
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = if props.BorderSizePixel == nil then 0 else props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Modal = props.Modal
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.Position = props.Position
	_attributes.Rotation = props.Rotation
	_attributes.Selectable = props.Selectable
	_attributes.SelectionBehaviorDown = props.SelectionBehaviorDown
	_attributes.SelectionBehaviorLeft = props.SelectionBehaviorLeft
	_attributes.SelectionBehaviorRight = props.SelectionBehaviorRight
	_attributes.SelectionBehaviorUp = props.SelectionBehaviorUp
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.Size = props.Size
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Visible = props.Visible
	_attributes.ZIndex = props.ZIndex
	_attributes.Image = props.Image
	_attributes.ImageColor3 = props.ImageColor3
	_attributes.ImageRectOffset = props.ImageRectOffset
	_attributes.ImageRectSize = props.ImageRectSize
	_attributes.ImageTransparency = props.ImageTransparency
	_attributes.ResampleMode = props.ResampleMode
	_attributes.ScaleType = props.ScaleType
	_attributes.SliceCenter = props.SliceCenter
	_attributes.SliceScale = props.SliceScale
	_attributes.TileSize = props.TileSize
	local _object_1 = {}
	if defaultEvents then
		for _k, _v in defaultEvents do
			_object_1[_k] = _v
		end
	end
	if stateEvents then
		for _k, _v in stateEvents do
			_object_1[_k] = _v
		end
	end
	_object_1.MouseEnter = function(button, x, y)
		setHovering(true)
		local _result_2 = stateEvents
		if _result_2 ~= nil then
			_result_2 = _result_2.MouseEnter
			if _result_2 ~= nil then
				_result_2(button, x, y)
			end
		end
		if stateEvents ~= defaultEvents then
			local _result_3 = defaultEvents
			if _result_3 ~= nil then
				_result_3 = _result_3.MouseEnter
				if _result_3 ~= nil then
					_result_3(button, x, y)
				end
			end
		end
	end
	_object_1.MouseLeave = function(button, x, y)
		setHovering(false)
		local _result_2 = stateEvents
		if _result_2 ~= nil then
			_result_2 = _result_2.MouseLeave
			if _result_2 ~= nil then
				_result_2(button, x, y)
			end
		end
		if stateEvents ~= defaultEvents then
			local _result_3 = defaultEvents
			if _result_3 ~= nil then
				_result_3 = _result_3.MouseLeave
				if _result_3 ~= nil then
					_result_3(button, x, y)
				end
			end
		end
	end
	for _k, _v in (if propSet.pressOn == "down" then {
		Activated = function(button, inputObject, clickCount)
			if isPointerPress(inputObject) then
				return nil
			end
			local _0 = activated
			if _0 ~= nil then
				_0(button, inputObject, clickCount)
			end
		end,
		InputBegan = function(button, inputObject)
			local _1 = inputBegan
			if _1 ~= nil then
				_1(button, inputObject)
			end
			if props.Active == false or not isPointerPress(inputObject) then
				return nil
			end
			local _2 = activated
			if _2 ~= nil then
				_2(button, inputObject, 1)
			end
			if propSet.onRelease ~= nil then
				trackRelease(button, inputObject)
			end
		end,
	} else {}) do
		_object_1[_k] = _v
	end
	_attributes.Event = _object_1
	_attributes.Change = props.Change
	_attributes.Tag = props.Tag
	local _condition_4 = borderThickness > 0
	if _condition_4 then
		local _attributes_1 = {
			key = "Stroke",
			Thickness = borderThickness,
			Color = props.borderColor or propSet.borderColor,
		}
		local _condition_5 = props.borderTransparency
		if _condition_5 == nil then
			_condition_5 = propSet.borderTransparency
		end
		_attributes_1.Transparency = _condition_5
		_attributes_1.BorderStrokePosition = if borderPosition == "outer" then Enum.BorderStrokePosition.Outer else Enum.BorderStrokePosition.Inner
		_condition_4 = (React.createElement("uistroke", _attributes_1))
	end
	return React.createElement(HoverButtonContext.Provider, {
		value = {
			hover = hovering,
			isSelected = propSet.isSelected == true,
		},
	}, React.createElement("imagebutton", _attributes, _condition_4, propSet.children))
end
return {
	HoverButton = HoverButton,
	HoverButtonContext = HoverButtonContext,
}
