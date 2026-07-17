-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Button = TS.import(script, script.Parent.Parent, "Input").Button
local NavigationContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").NavigationContext
local function MenuItem(props)
	local context = React.useContext(NavigationContext)
	return React.createElement(Button, {
		text = if not context.collapsed then props.title else nil,
		icon = props.icon,
		Event = props.Event,
		group = true,
	})
end
return {
	MenuItem = MenuItem,
}
