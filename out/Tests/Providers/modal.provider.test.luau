-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local DisplayName = _lunit.DisplayName
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local _binding = Decorators
local Skip = _binding.Skip
local ModalProvider = TS.import(script, script.Parent.Parent.Parent, "Providers", "modal.provider").ModalProvider
local useModalStack = TS.import(script, script.Parent.Parent.Parent, "Contexts").useModalStack
local latestStack
local function StackHarness()
	latestStack = useModalStack()
	return nil
end
local function noopLayer(id)
	return {
		id = id,
		closeOnEscape = function()
			return true
		end,
		requestClose = function() end,
	}
end
local ModalStackProviderValidation
do
	ModalStackProviderValidation = setmetatable({}, {
		__tostring = function()
			return "ModalStackProviderValidation"
		end,
	})
	ModalStackProviderValidation.__index = ModalStackProviderValidation
	function ModalStackProviderValidation.new(...)
		local self = setmetatable({}, ModalStackProviderValidation)
		return self:constructor(...) or self
	end
	function ModalStackProviderValidation:constructor()
	end
	function ModalStackProviderValidation:registerOrder()
		local host = Instance.new("Folder")
		latestStack = nil
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(ModalProvider, nil, React.createElement(StackHarness)))
		task.wait()
		Assert:notUndefined(latestStack)
		latestStack.register(noopLayer("a"))
		task.wait()
		latestStack.register(noopLayer("b"))
		task.wait()
		latestStack.register(noopLayer("c"))
		task.wait()
		Assert:equal(latestStack.getLayerIndex("a"), 0)
		Assert:equal(latestStack.getLayerIndex("b"), 1)
		Assert:equal(latestStack.getLayerIndex("c"), 2)
		root:unmount()
		host:Destroy()
	end
	function ModalStackProviderValidation:unknownId()
		local host = Instance.new("Folder")
		latestStack = nil
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(ModalProvider, nil, React.createElement(StackHarness)))
		task.wait()
		Assert:notUndefined(latestStack)
		Assert:equal(latestStack.getLayerIndex("missing"), -1)
		root:unmount()
		host:Destroy()
	end
	function ModalStackProviderValidation:unregisterShift()
		local host = Instance.new("Folder")
		latestStack = nil
		local root = ReactRoblox.createRoot(host)
		root:render(React.createElement(ModalProvider, nil, React.createElement(StackHarness)))
		task.wait()
		latestStack.register(noopLayer("a"))
		task.wait()
		latestStack.register(noopLayer("b"))
		task.wait()
		latestStack.register(noopLayer("c"))
		task.wait()
		latestStack.unregister("a")
		task.wait()
		Assert:equal(latestStack.getLayerIndex("a"), -1)
		Assert:equal(latestStack.getLayerIndex("b"), 0)
		Assert:equal(latestStack.getLayerIndex("c"), 1)
		root:unmount()
		host:Destroy()
	end
	local _decorator = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_1 = DisplayName("Each newly registered layer receives the next index in the stack")
	local _descriptor = Test(ModalStackProviderValidation, "registerOrder", {
		value = ModalStackProviderValidation.registerOrder,
	})
	if _descriptor then
		ModalStackProviderValidation.registerOrder = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(ModalStackProviderValidation, "registerOrder", {
		value = ModalStackProviderValidation.registerOrder,
	})
	if _descriptor_1 then
		ModalStackProviderValidation.registerOrder = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(ModalStackProviderValidation, "registerOrder", {
		value = ModalStackProviderValidation.registerOrder,
	})
	if _descriptor_2 then
		ModalStackProviderValidation.registerOrder = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_3 = DisplayName("Looking up an id that was never registered yields -1")
	local _descriptor_3 = Test(ModalStackProviderValidation, "unknownId", {
		value = ModalStackProviderValidation.unknownId,
	})
	if _descriptor_3 then
		ModalStackProviderValidation.unknownId = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(ModalStackProviderValidation, "unknownId", {
		value = ModalStackProviderValidation.unknownId,
	})
	if _descriptor_4 then
		ModalStackProviderValidation.unknownId = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(ModalStackProviderValidation, "unknownId", {
		value = ModalStackProviderValidation.unknownId,
	})
	if _descriptor_5 then
		ModalStackProviderValidation.unknownId = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), "Requires a real Roblox Instance tree (GetPropertyChangedSignal) - run inside Roblox Studio via the TestRunner, not under Lune.")
	local _decorator_5 = DisplayName("Removing the bottom layer shifts the remaining layers down by one")
	local _descriptor_6 = Test(ModalStackProviderValidation, "unregisterShift", {
		value = ModalStackProviderValidation.unregisterShift,
	})
	if _descriptor_6 then
		ModalStackProviderValidation.unregisterShift = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(ModalStackProviderValidation, "unregisterShift", {
		value = ModalStackProviderValidation.unregisterShift,
	})
	if _descriptor_7 then
		ModalStackProviderValidation.unregisterShift = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(ModalStackProviderValidation, "unregisterShift", {
		value = ModalStackProviderValidation.unregisterShift,
	})
	if _descriptor_8 then
		ModalStackProviderValidation.unregisterShift = _descriptor_8.value
	end
	ModalStackProviderValidation = Tag("Studio")(ModalStackProviderValidation) or ModalStackProviderValidation
end
return ModalStackProviderValidation
