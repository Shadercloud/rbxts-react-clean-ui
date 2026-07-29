-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ToastContext = React.createContext(nil)
local function useToast()
	local context = React.useContext(ToastContext)
	local _arg0 = context ~= nil
	assert(_arg0, "ToastProvider is missing.")
	return context
end
return {
	useToast = useToast,
	ToastContext = ToastContext,
}
