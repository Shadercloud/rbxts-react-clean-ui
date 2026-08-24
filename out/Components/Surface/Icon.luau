-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local DefaultIconSet = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultIconSet
local Icon
local function SpinningIcon(props)
	local _object = {}
	local _left = "duration"
	local _condition = props.speed
	if _condition == nil then
		_condition = 1
	end
	_object[_left] = _condition
	_object.easing = "linear"
	_object.repeats = math.huge
	local rotation, tween = useTween(0, _object)
	React.useEffect(function()
		tween:setGoal(360)
		tween:start()
	end)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.Rotation = rotation
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
	}, React.createElement(Icon, _attributes))
end
function Icon(props)
	local theme = React.useContext(CleanThemeContext)
	local _result
	if props.icon == nil then
		_result = nil
	else
		local _condition = theme.icons[props.icon]
		if _condition == nil then
			_condition = DefaultIconSet[props.icon]
		end
		_result = _condition
	end
	local iconId = _result
	local size = theme.iconSize[props.scale or theme.default.scale]
	if props.spinning then
		local _attributes = table.clone(props)
		setmetatable(_attributes, nil)
		return React.createElement(SpinningIcon, _attributes)
	end
	local _attributes = {
		AnchorPoint = props.AnchorPoint,
		Rotation = props.Rotation,
		Size = props.Size or UDim2.fromOffset(size, size),
		Position = props.Position,
		LayoutOrder = props.LayoutOrder,
		Image = if iconId == nil then nil else `rbxassetid://{iconId}`,
	}
	local _condition = props.BackgroundTransparency
	if _condition == nil then
		_condition = 1
	end
	_attributes.BackgroundTransparency = _condition
	_attributes.ImageColor3 = props.color or theme.colors.intents.primary.default.textColor
	_attributes.ZIndex = props.ZIndex
	_attributes.Visible = props.Visible
	_attributes.Active = props.Active
	_attributes.Archivable = props.Archivable
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.Selectable = props.Selectable
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Tag = props.Tag
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionOrder = props.SelectionOrder
	_attributes.ImageRectOffset = props.ImageRectOffset
	_attributes.ImageRectSize = props.ImageRectSize
	_attributes.ImageTransparency = props.ImageTransparency
	_attributes.ResampleMode = props.ResampleMode
	_attributes.ScaleType = props.ScaleType
	_attributes.SliceCenter = props.SliceCenter
	_attributes.SliceScale = props.SliceScale
	_attributes.TileSize = props.TileSize
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement("imagelabel", _attributes)
end
return {
	Icon = Icon,
}
