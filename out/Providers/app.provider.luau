-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ToastContainer = TS.import(script, script.Parent.Parent, "Components", "Interaction", "Toast").ToastContainer
local RegistryProvider = TS.import(script, script.Parent, "registry.provider").RegistryProvider
local ThemeProvider = TS.import(script, script.Parent, "theme.provider").ThemeProvider
local OverlayProvider = TS.import(script, script.Parent, "overlay.provider").OverlayProvider
local ModalProvider = TS.import(script, script.Parent, "modal.provider").ModalProvider
local ToastProvider = TS.import(script, script.Parent, "toast.provider").ToastProvider
local function CleanUiProvider(_param)
	local children = _param.children
	local theme = _param.theme
	local toasts = _param.toasts
	if toasts == nil then
		toasts = true
	end
	return React.createElement(RegistryProvider, nil, React.createElement(ThemeProvider, {
		theme = theme,
	}, React.createElement(OverlayProvider, nil, React.createElement(ModalProvider, nil, React.createElement(ToastProvider, nil, children, toasts and React.createElement(ToastContainer))))))
end
return {
	CleanUiProvider = CleanUiProvider,
}
