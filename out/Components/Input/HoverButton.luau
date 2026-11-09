-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Button_press = TS.import(script, script.Parent, "Button.press")
local isPointerPress = _Button_press.isPointerPress
local usePressRelease = _Button_press.usePressRelease
local HoverButtonContext = React.createContext(nil)
local function mergeEvents(base, extra)
	if extra == nil then
		return base
	end
	local _object = table.clone(base)
	setmetatable(_object, nil)
	local merged = _object
	for name, handler in pairs(extra) do
		local original = merged[name]
		merged[name] = if original == nil then handler else function(...)
			local args = { ... }
			original(unpack(args))
			handler(unpack(args))
		end
	end
	return merged
end
local HoverButton = React.forwardRef(function(propSet, ref)
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
	local topEvents = propSet.Event
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
	local events = mergeEvents(_object_1, topEvents)
	local activated = events.Activated
	local inputBegan = events.InputBegan
	local _attributes = {}
	local _condition_1 = propSet.name
	if _condition_1 == nil then
		_condition_1 = "HoverButton"
	end
	_attributes.key = _condition_1
	_attributes.ref = ref
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
	local _object_2 = table.clone(events)
	setmetatable(_object_2, nil)
	_object_2.MouseEnter = function(button, x, y)
		setHovering(true)
		local _result = stateEvents
		if _result ~= nil then
			_result = _result.MouseEnter
			if _result ~= nil then
				_result(button, x, y)
			end
		end
		if stateEvents ~= defaultEvents then
			local _result_1 = defaultEvents
			if _result_1 ~= nil then
				_result_1 = _result_1.MouseEnter
				if _result_1 ~= nil then
					_result_1(button, x, y)
				end
			end
		end
		local _result_1 = topEvents
		if _result_1 ~= nil then
			_result_1 = _result_1.MouseEnter
			if _result_1 ~= nil then
				_result_1(button, x, y)
			end
		end
	end
	_object_2.MouseLeave = function(button, x, y)
		setHovering(false)
		local _result = stateEvents
		if _result ~= nil then
			_result = _result.MouseLeave
			if _result ~= nil then
				_result(button, x, y)
			end
		end
		if stateEvents ~= defaultEvents then
			local _result_1 = defaultEvents
			if _result_1 ~= nil then
				_result_1 = _result_1.MouseLeave
				if _result_1 ~= nil then
					_result_1(button, x, y)
				end
			end
		end
		local _result_1 = topEvents
		if _result_1 ~= nil then
			_result_1 = _result_1.MouseLeave
			if _result_1 ~= nil then
				_result_1(button, x, y)
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
		_object_2[_k] = _v
	end
	_attributes.Event = _object_2
	_attributes.Change = props.Change
	_attributes.Tag = props.Tag
	local _condition_2 = borderThickness > 0
	if _condition_2 then
		local _attributes_1 = {
			key = "Stroke",
			Thickness = borderThickness,
			Color = props.borderColor or propSet.borderColor,
		}
		local _condition_3 = props.borderTransparency
		if _condition_3 == nil then
			_condition_3 = propSet.borderTransparency
		end
		_attributes_1.Transparency = _condition_3
		_attributes_1.BorderStrokePosition = if borderPosition == "outer" then Enum.BorderStrokePosition.Outer else Enum.BorderStrokePosition.Inner
		_condition_2 = (React.createElement("uistroke", _attributes_1))
	end
	return React.createElement(HoverButtonContext.Provider, {
		value = {
			hover = hovering,
			isSelected = propSet.isSelected == true,
		},
	}, React.createElement("imagebutton", _attributes, _condition_2, propSet.children))
end)
return {
	HoverButtonContext = HoverButtonContext,
	HoverButton = HoverButton,
}
