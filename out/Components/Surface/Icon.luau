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
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Icon"
	end
	_attributes.key = _condition_1
	_attributes.BackgroundTransparency = 1
	_attributes.Size = UDim2.fromOffset(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	return React.createElement("frame", _attributes, React.createElement(Icon, {
		Size = props.Size,
		color = props.color,
		icon = props.icon,
		scale = props.scale,
		Rotation = rotation,
	}))
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
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Icon"
	end
	_attributes.key = _condition
	_attributes.AnchorPoint = props.AnchorPoint
	_attributes.Rotation = props.Rotation
	_attributes.Size = props.Size or UDim2.fromOffset(size, size)
	_attributes.Position = props.Position
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Image = if iconId == nil then nil else `rbxassetid://{iconId}`
	local _condition_1 = props.BackgroundTransparency
	if _condition_1 == nil then
		_condition_1 = 1
	end
	_attributes.BackgroundTransparency = _condition_1
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
