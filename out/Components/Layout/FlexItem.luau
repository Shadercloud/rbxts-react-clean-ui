-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local function FlexItem(props)
	return React.createElement("frame", {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
	}, React.createElement("uiflexitem", {
		FlexMode = props.mode or "Grow",
		GrowRatio = props.GrowRatio,
		ShrinkRatio = props.ShrinkRatio,
	}), React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = props.align,
	}), props.children)
end
return {
	FlexItem = FlexItem,
}
