-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local DefaultIconSet = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultIconSet
local function Icon(props)
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
	return React.createElement("imagelabel", {
		Size = props.Size or UDim2.fromOffset(size, size),
		Image = if iconId == nil then nil else `rbxassetid://{iconId}`,
		BackgroundTransparency = 1,
		ImageColor3 = props.color or Color3.fromHex("#FFFFFF"),
	})
end
return {
	Icon = Icon,
}
