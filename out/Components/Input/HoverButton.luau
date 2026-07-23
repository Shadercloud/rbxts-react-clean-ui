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
	local _attributes = {
		Active = props.Active,
		AnchorPoint = props.AnchorPoint,
		Archivable = props.Archivable,
		AutoButtonColor = props.AutoButtonColor,
		AutomaticSize = props.AutomaticSize,
		BackgroundColor3 = props.BackgroundColor3,
		BackgroundTransparency = props.BackgroundTransparency,
		BorderColor3 = props.BorderColor3,
		BorderMode = props.BorderMode,
		BorderSizePixel = props.BorderSizePixel,
		ClipsDescendants = props.ClipsDescendants,
		LayoutOrder = props.LayoutOrder,
		NextSelectionDown = props.NextSelectionDown,
		NextSelectionLeft = props.NextSelectionLeft,
		NextSelectionRight = props.NextSelectionRight,
		NextSelectionUp = props.NextSelectionUp,
		Position = props.Position,
		Rotation = props.Rotation,
		Selectable = props.Selectable,
		SelectionBehaviorDown = props.SelectionBehaviorDown,
		SelectionBehaviorLeft = props.SelectionBehaviorLeft,
		SelectionBehaviorRight = props.SelectionBehaviorRight,
		SelectionBehaviorUp = props.SelectionBehaviorUp,
		SelectionGroup = props.SelectionGroup,
		Size = props.Size,
		SizeConstraint = props.SizeConstraint,
		Visible = props.Visible,
		ZIndex = props.ZIndex,
		Image = props.Image,
		ImageColor3 = props.ImageColor3,
		ImageRectOffset = props.ImageRectOffset,
		ImageRectSize = props.ImageRectSize,
		ImageTransparency = props.ImageTransparency,
		ResampleMode = props.ResampleMode,
		ScaleType = props.ScaleType,
		SliceCenter = props.SliceCenter,
		SliceScale = props.SliceScale,
		TileSize = props.TileSize,
	}
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
