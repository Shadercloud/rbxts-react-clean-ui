-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local HoverButtonContext = React.createContext(nil)
local function HoverButton(propSet)
	local hovering, setHovering = React.useState(false)
	local state = if propSet.isSelected then "focus" elseif hovering then "hover" else "default"
	local stateProps = propSet[state]
	-- Object spreading into a new object is supported.
	-- It is object rest destructuring that roblox-ts does not support.
	local _object = table.clone(propSet.default)
	setmetatable(_object, nil)
	if stateProps then
		for _k, _v in stateProps do
			_object[_k] = _v
		end
	end
	local props = _object
	local defaultEvents = propSet.default.Event
	local _stateEvents = stateProps
	if _stateEvents ~= nil then
		_stateEvents = _stateEvents.Event
	end
	local stateEvents = _stateEvents
	local _attributes = {}
	local _condition = propSet.name
	if _condition == nil then
		_condition = "HoverButton"
	end
	_attributes.key = _condition
	_attributes.Active = props.Active
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.Archivable = props.Archivable
	_attributes.AutoButtonColor = props.AutoButtonColor
	_attributes.AutomaticSize = props.AutomaticSize
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BackgroundTransparency = props.BackgroundTransparency
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.LayoutOrder = props.LayoutOrder
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
	end
	_object_1.MouseLeave = function(button, x, y)
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
	end
	_attributes.Event = _object_1
	_attributes.Change = props.Change
	_attributes.Tag = props.Tag
	return React.createElement(HoverButtonContext.Provider, {
		value = {
			hover = hovering,
			isSelected = propSet.isSelected == true,
		},
	}, React.createElement("imagebutton", _attributes, propSet.children))
end
return {
	HoverButton = HoverButton,
	HoverButtonContext = HoverButtonContext,
}
