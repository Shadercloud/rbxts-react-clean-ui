-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local Workspace = TS.import(script, TS.getModule(script, "@rbxts", "services")).Workspace
local BreakpointHelper = TS.import(script, script.Parent.Parent, "Helpers", "breakpoint.helper").BreakpointHelper
local SizeHelper = TS.import(script, script.Parent.Parent, "Helpers", "size.helper").SizeHelper
local CleanThemeContext = TS.import(script, script.Parent, "theme.context").CleanThemeContext
local BreakpointContext = React.createContext(nil)
local function getViewportBreakpoint(breakpoints)
	local camera = Workspace.CurrentCamera
	if camera == nil then
		return nil
	end
	return BreakpointHelper:getBreakpoint(camera.ViewportSize.X, breakpoints)
end
local function useBreakpoint()
	local context = React.useContext(BreakpointContext)
	local theme = React.useContext(CleanThemeContext)
	local viewportBreakpoint, setViewportBreakpoint = React.useState(function()
		return (if context == nil then getViewportBreakpoint(theme.breakpoints) else nil) or "xs"
	end)
	React.useEffect(function()
		if context ~= nil then
			return nil
		end
		local viewportConnection
		local update = function()
			local resolved = getViewportBreakpoint(theme.breakpoints)
			if resolved ~= nil then
				setViewportBreakpoint(resolved)
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
	end, { context == nil, theme.breakpoints })
	return if context ~= nil then context.breakpoint else viewportBreakpoint
end
local function useBreakpointValue(value)
	local breakpoint = useBreakpoint()
	return SizeHelper:resolveResponsiveValue(value, breakpoint)
end
return {
	useBreakpoint = useBreakpoint,
	useBreakpointValue = useBreakpointValue,
	BreakpointContext = BreakpointContext,
}
