-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local toDesignPixels = TS.import(script, script.Parent.Parent, "Helpers", "uiscale.helper").toDesignPixels
local UiScaleContext = React.createContext(1)
local function useUiScale()
	return React.useContext(UiScaleContext)
end
local function getViewportSize()
	local _result = Workspace.CurrentCamera
	if _result ~= nil then
		_result = _result.ViewportSize
	end
	return _result
end
local function useDesignViewportSize()
	local scale = useUiScale()
	local viewportSize, setViewportSize = React.useState(function()
		return getViewportSize() or Vector2.zero
	end)
	React.useEffect(function()
		local viewportConnection
		local update = function()
			local resolved = getViewportSize()
			if resolved ~= nil then
				setViewportSize(resolved)
			end
		end
		local bindCamera = function()
			local _result = viewportConnection
			if _result ~= nil then
				_result:Disconnect()
			end
			viewportConnection = nil
			local camera = Workspace.CurrentCamera
			if camera ~= nil then
				viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
			end
			update()
		end
		local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
		bindCamera()
		return function()
			cameraConnection:Disconnect()
			local _result = viewportConnection
			if _result ~= nil then
				_result:Disconnect()
			end
		end
	end, {})
	return toDesignPixels(viewportSize, scale)
end
return {
	useUiScale = useUiScale,
	useDesignViewportSize = useDesignViewportSize,
	UiScaleContext = UiScaleContext,
}
