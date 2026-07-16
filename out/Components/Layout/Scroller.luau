-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local function Scroller(props)
	local theme = React.useContext(CleanThemeContext)
	local thickness = 12
	return React.createElement("scrollingframe", {
		Size = UDim2.fromScale(1, 1),
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageColor3 = theme.components.scroller.barColor,
		CanvasSize = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = thickness,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, React.createElement("frame", {
		Size = UDim2.new(1, -thickness, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, props.children))
end
return {
	Scroller = Scroller,
}
