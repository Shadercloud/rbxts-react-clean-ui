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
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
	}, React.createElement(Icon, {
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
	return React.createElement("imagelabel", {
		Rotation = props.Rotation,
		Size = props.Size or UDim2.fromOffset(size, size),
		Image = if iconId == nil then nil else `rbxassetid://{iconId}`,
		BackgroundTransparency = 1,
		ImageColor3 = props.color or Color3.fromHex("#FFFFFF"),
	})
end
return {
	Icon = Icon,
}
