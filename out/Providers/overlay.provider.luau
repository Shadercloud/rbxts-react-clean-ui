-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useState = _react.useState
local _Contexts = TS.import(script, script.Parent.Parent, "Contexts")
local OverlayContext = _Contexts.OverlayContext
local useUiScale = _Contexts.useUiScale
local function OverlayProvider(props)
	local overlay, setOverlay = useState()
	local scale = useUiScale()
	return React.createElement(OverlayContext.Provider, {
		value = {
			overlay = overlay,
			scale = scale,
		},
	}, props.children, React.createElement("frame", {
		key = "OverlayProvider",
		ref = function(instance)
			setOverlay(instance)
		end,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 100000,
		Active = false,
	}))
end
return {
	OverlayProvider = OverlayProvider,
}
