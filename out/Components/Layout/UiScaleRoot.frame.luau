-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local OverlayContext = _Contexts.OverlayContext
local useUiScale = _Contexts.useUiScale
local UiScaleFrame = React.forwardRef(function(props, ref)
	return React.createElement("frame", {
		key = props.name,
		ref = ref,
		Size = UDim2.fromScale(1 / props.scale, 1 / props.scale),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = props.ZIndex,
	}, React.createElement("uiscale", {
		key = "UiScale",
		Scale = props.scale,
	}), props.children)
end)
local function useOverlayScale()
	local scale = useUiScale()
	local overlay = React.useContext(OverlayContext)
	local _condition = overlay.scale
	if _condition == nil then
		_condition = 1
	end
	return scale / _condition
end
local function OverlayScaleFrame(props)
	local relativeScale = useOverlayScale()
	if relativeScale == 1 then
		return props.children
	end
	return React.createElement(UiScaleFrame, {
		name = "UiScaleOverlay",
		scale = relativeScale,
		ZIndex = props.ZIndex,
	}, props.children)
end
return {
	useOverlayScale = useOverlayScale,
	OverlayScaleFrame = OverlayScaleFrame,
	UiScaleFrame = UiScaleFrame,
}
