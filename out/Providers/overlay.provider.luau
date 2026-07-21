-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useState = _react.useState
local OverlayContext = TS.import(script, script.Parent.Parent, "Contexts").OverlayContext
local function OverlayProvider(props)
	local overlay, setOverlay = useState()
	return React.createElement(OverlayContext.Provider, {
		value = {
			overlay = overlay,
		},
	}, props.children, React.createElement("frame", {
		ref = function(instance)
			setOverlay(instance)
		end,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 100000,
		Active = false,
	}))
end
return {
	OverlayProvider = OverlayProvider,
}
