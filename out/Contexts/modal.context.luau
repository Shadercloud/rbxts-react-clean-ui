-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ModalStackContext = React.createContext(nil)
local function useModalStack()
	local context = React.useContext(ModalStackContext)
	local _arg0 = context ~= nil
	assert(_arg0, "ModalProvider is missing.")
	return context
end
-- Per-instance, provided by each <Modal> around its own children so a
-- header close button or footer button can close the nearest modal
-- without the consumer threading their own handler down manually.
local ModalCloseContext = React.createContext(nil)
local function useModalClose()
	local context = React.useContext(ModalCloseContext)
	local _arg0 = context ~= nil
	assert(_arg0, "useModalClose must be used inside a Modal.")
	return context
end
return {
	useModalStack = useModalStack,
	useModalClose = useModalClose,
	ModalStackContext = ModalStackContext,
	ModalCloseContext = ModalCloseContext,
}
