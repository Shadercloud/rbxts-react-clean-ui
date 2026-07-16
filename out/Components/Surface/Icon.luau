-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local DefaultIconSet = TS.import(script, script.Parent.Parent.Parent, "Theme").DefaultIconSet
local function Icon(props)
	if not props.icon then
		return nil
	end
	local theme = React.useContext(CleanThemeContext)
	local _condition = theme.icons[props.icon]
	if _condition == nil then
		_condition = DefaultIconSet[props.icon]
	end
	local iconId = _condition
	return React.createElement("imagelabel", {
		Size = UDim2.fromOffset(20, 20),
		Image = `rbxassetid://{iconId}`,
		BackgroundTransparency = 1,
		ImageColor3 = props.color or Color3.fromHex("#FFFFFF"),
	})
end
return {
	Icon = Icon,
}
