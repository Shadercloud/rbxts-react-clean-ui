-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local OverlayContext = React.createContext({})
local function OverlayConsumer(props)
	local overlayContext = React.useContext(OverlayContext)
	local _props = props
	local _result = overlayContext
	if _result ~= nil then
		_result = _result.overlay
	end
	return _props.render(_result)
end
return {
	OverlayConsumer = OverlayConsumer,
	OverlayContext = OverlayContext,
}
