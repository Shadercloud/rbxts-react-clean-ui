-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Decorators = _lunit.Decorators
local Runtime = _lunit.Runtime
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _binding = Decorators
local Skip = _binding.Skip
local Droppable = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Droppable").Droppable
local _registry_provider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "registry.provider")
local DroppableRegistryKey = _registry_provider.DroppableRegistryKey
local RegistryContext = _registry_provider.RegistryContext
local RegistryProvider = _registry_provider.RegistryProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local DROP_ID = "target"
local latestRegistry
local function RegistryHarness()
	latestRegistry = React.useContext(RegistryContext)
	return nil
end
local function droppableFixture(onDrop)
	return React.createElement(RegistryProvider, nil, React.createElement(RegistryHarness), React.createElement(Droppable, {
		id = DROP_ID,
		onDrop = onDrop,
	}, React.createElement("frame", {
		key = "DropZone",
		Size = UDim2.fromOffset(120, 80),
		BackgroundTransparency = 1,
	})))
end
local function waitForDropZone(host)
	return waitForGuiObject(host, "DropZone")
end
local function waitForRegistration(dropZone)
	return waitForLayout(function()
		local _result = latestRegistry
		if _result ~= nil then
			_result = _result.get(dropZone, DroppableRegistryKey)
		end
		return _result
	end, "Timed out waiting for Droppable to register its child in the registry")
end
local DroppableMountValidation
do
	DroppableMountValidation = setmetatable({}, {
		__tostring = function()
			return "DroppableMountValidation"
		end,
	})
	DroppableMountValidation.__index = DroppableMountValidation
	function DroppableMountValidation.new(...)
		local self = setmetatable({}, DroppableMountValidation)
		return self:constructor(...) or self
	end
	function DroppableMountValidation:constructor()
	end
	function DroppableMountValidation:rendersChildUnwrapped()
		latestRegistry = nil
		withMounted(400, 300, droppableFixture(), function(mounted)
			local dropZone = waitForDropZone(mounted.host)
			Assert:equal(dropZone.Parent, mounted.host, "Expected the drop zone to be a direct child of the host (no wrapper)")
			assertSizeApprox(dropZone, 120, 80, 1, "drop zone")
			assertContained(dropZone, mounted.host, "drop zone vs host")
		end)
	end
	function DroppableMountValidation:registersAndForwardsDrop()
		latestRegistry = nil
		local dropped = {}
		withMounted(400, 300, droppableFixture(function(dragged)
			local _dragged = dragged
			table.insert(dropped, _dragged)
			return #dropped
		end), function(mounted)
			local dropZone = waitForDropZone(mounted.host)
			local registration = waitForRegistration(dropZone)
			Assert:equal(registration.id, DROP_ID)
			Assert:equal(registration.guiObject, dropZone, "Expected the registration to point at the cloned child instance")
			local dragged = Instance.new("Frame")
			registration.drop(dragged)
			Assert:equal(#dropped, 1, "Expected onDrop to fire exactly once")
			Assert:equal(dropped[1], dragged, "Expected onDrop to receive the dragged GuiObject unchanged")
			dragged:Destroy()
		end)
	end
	function DroppableMountValidation:unregistersOnUnmount()
		latestRegistry = nil
		withMounted(400, 300, droppableFixture(), function(mounted)
			local dropZone = waitForDropZone(mounted.host)
			waitForRegistration(dropZone)
			local registry = latestRegistry
			mounted.update(React.createElement(RegistryProvider, nil, React.createElement(RegistryHarness), React.createElement("frame", {
				key = "Placeholder",
				Size = UDim2.fromOffset(10, 10),
				BackgroundTransparency = 1,
			})))
			waitForLayout(function()
				return if registry.get(dropZone, DroppableRegistryKey) == nil then true else nil
			end, "Timed out waiting for the Droppable's registry entry to be removed after unmount")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Renders its child in place with no wrapper, at the child's own size, inside the host")
	local _descriptor = Test(DroppableMountValidation, "rendersChildUnwrapped", {
		value = DroppableMountValidation.rendersChildUnwrapped,
	})
	if _descriptor then
		DroppableMountValidation.rendersChildUnwrapped = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(DroppableMountValidation, "rendersChildUnwrapped", {
		value = DroppableMountValidation.rendersChildUnwrapped,
	})
	if _descriptor_1 then
		DroppableMountValidation.rendersChildUnwrapped = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(DroppableMountValidation, "rendersChildUnwrapped", {
		value = DroppableMountValidation.rendersChildUnwrapped,
	})
	if _descriptor_2 then
		DroppableMountValidation.rendersChildUnwrapped = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Registers its child under DroppableRegistryKey with its id, and the registration's drop() forwards the dragged object to onDrop")
	local _descriptor_3 = Test(DroppableMountValidation, "registersAndForwardsDrop", {
		value = DroppableMountValidation.registersAndForwardsDrop,
	})
	if _descriptor_3 then
		DroppableMountValidation.registersAndForwardsDrop = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(DroppableMountValidation, "registersAndForwardsDrop", {
		value = DroppableMountValidation.registersAndForwardsDrop,
	})
	if _descriptor_4 then
		DroppableMountValidation.registersAndForwardsDrop = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(DroppableMountValidation, "registersAndForwardsDrop", {
		value = DroppableMountValidation.registersAndForwardsDrop,
	})
	if _descriptor_5 then
		DroppableMountValidation.registersAndForwardsDrop = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Unmounting the Droppable removes its registry entry")
	local _descriptor_6 = Test(DroppableMountValidation, "unregistersOnUnmount", {
		value = DroppableMountValidation.unregistersOnUnmount,
	})
	if _descriptor_6 then
		DroppableMountValidation.unregistersOnUnmount = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(DroppableMountValidation, "unregistersOnUnmount", {
		value = DroppableMountValidation.unregistersOnUnmount,
	})
	if _descriptor_7 then
		DroppableMountValidation.unregistersOnUnmount = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(DroppableMountValidation, "unregistersOnUnmount", {
		value = DroppableMountValidation.unregistersOnUnmount,
	})
	if _descriptor_8 then
		DroppableMountValidation.unregistersOnUnmount = _descriptor_8.value
	end
	DroppableMountValidation = Tag("Studio")(DroppableMountValidation) or DroppableMountValidation
end
return DroppableMountValidation
