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
local Draggable = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Layout", "Draggable").Draggable
local OverlayProvider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "overlay.provider").OverlayProvider
local _registry_provider = TS.import(script, script.Parent.Parent.Parent.Parent, "Providers", "registry.provider")
local DraggableRegistryKey = _registry_provider.DraggableRegistryKey
local RegistryContext = _registry_provider.RegistryContext
local RegistryProvider = _registry_provider.RegistryProvider
local _layout = TS.import(script, script.Parent.Parent.Parent, "Helpers", "layout")
local STUDIO_SKIP_MESSAGE = _layout.STUDIO_SKIP_MESSAGE
local assertContained = _layout.assertContained
local assertSizeApprox = _layout.assertSizeApprox
local findDescendant = _layout.findDescendant
local waitForGuiObject = _layout.waitForGuiObject
local waitForLayout = _layout.waitForLayout
local withMounted = _layout.withMounted
local DRAG_ID = "item"
local latestRegistry
local function RegistryHarness()
	latestRegistry = React.useContext(RegistryContext)
	return nil
end
local handleEvents
local DragHandle = React.forwardRef(function(props, ref)
	handleEvents = props.Event
	return React.createElement("frame", {
		key = "DragHandle",
		ref = ref,
		Active = props.Active,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 24),
		Event = props.Event,
	})
end)
local function draggableFixture(onStartDrag, onDropped)
	return React.createElement(RegistryProvider, nil, React.createElement(OverlayProvider, nil, React.createElement(RegistryHarness), React.createElement(Draggable, {
		id = DRAG_ID,
		onStartDrag = onStartDrag,
		onDropped = onDropped,
	}, React.createElement("frame", {
		key = "DragItem",
		Size = UDim2.fromOffset(160, 90),
		BackgroundTransparency = 1,
	}, React.createElement(Draggable.Handle, nil, React.createElement(DragHandle))))))
end
local function waitForDragItem(host)
	waitForGuiObject(host, "OverlayProvider")
	return waitForGuiObject(host, "DragItem")
end
local function waitForRegistration(dragItem)
	return waitForLayout(function()
		local _result = latestRegistry
		if _result ~= nil then
			_result = _result.get(dragItem, DraggableRegistryKey)
		end
		return _result
	end, "Timed out waiting for Draggable to register its root in the registry")
end
local function fakeInput(position)
	return {
		Position = Vector3.new(position.X, position.Y, 0),
		UserInputType = Enum.UserInputType.MouseButton1,
	}
end
local DraggableMountValidation
do
	DraggableMountValidation = setmetatable({}, {
		__tostring = function()
			return "DraggableMountValidation"
		end,
	})
	DraggableMountValidation.__index = DraggableMountValidation
	function DraggableMountValidation.new(...)
		local self = setmetatable({}, DraggableMountValidation)
		return self:constructor(...) or self
	end
	function DraggableMountValidation:constructor()
	end
	function DraggableMountValidation:rendersChildInPlace()
		latestRegistry = nil
		handleEvents = nil
		withMounted(400, 300, draggableFixture(), function(mounted)
			local dragItem = waitForDragItem(mounted.host)
			Assert:equal(dragItem.Parent, mounted.host, "Expected the dragged element to be a direct child of the host (no wrapper)")
			Assert["true"](Assert, dragItem.Visible, "Expected the original to be visible while not dragging")
			Assert:undefined(mounted.host:FindFirstChild("DraggablePlaceholder", true), "Expected no placeholder while not dragging")
			assertSizeApprox(dragItem, 160, 90, 1, "drag item")
			assertContained(dragItem, mounted.host, "drag item vs host")
		end)
	end
	function DraggableMountValidation:handleIsActive()
		latestRegistry = nil
		handleEvents = nil
		withMounted(400, 300, draggableFixture(), function(mounted)
			local dragItem = waitForDragItem(mounted.host)
			local handle = findDescendant(dragItem, "DragHandle")
			Assert:equal(handle.Parent, dragItem, "Expected the handle to stay a direct child of the drag item")
			Assert["true"](Assert, handle.Active, "Expected Draggable.Handle to clone its child with Active=true")
			Assert["false"](Assert, dragItem.Active, "Expected the root element's own Active to be left at its default")
			local events = waitForLayout(function()
				return handleEvents
			end, "Timed out waiting for Draggable.Handle to inject its Event table")
			Assert:notUndefined(events.InputBegan, "Expected Draggable.Handle to inject an InputBegan handler")
			assertContained(handle, dragItem, "handle vs drag item")
		end)
	end
	function DraggableMountValidation:registersInRegistry()
		latestRegistry = nil
		handleEvents = nil
		withMounted(400, 300, draggableFixture(), function(mounted)
			local dragItem = waitForDragItem(mounted.host)
			local registration = waitForRegistration(dragItem)
			Assert:equal(registration.id, DRAG_ID)
			Assert:equal(registration.guiObject, dragItem, "Expected the registration to point at the cloned root instance")
			Assert["false"](Assert, registration.draggable.isDragging, "Expected a freshly mounted Draggable not to report itself as dragging")
		end)
	end
	function DraggableMountValidation:dragLifecycle()
		latestRegistry = nil
		handleEvents = nil
		local startCount = 0
		local dropCount = 0
		withMounted(400, 300, draggableFixture(function()
			startCount += 1
		end, function()
			dropCount += 1
		end), function(mounted)
			local dragItem = waitForDragItem(mounted.host)
			local registration = waitForRegistration(dragItem)
			local handle = findDescendant(dragItem, "DragHandle")
			local events = waitForLayout(function()
				return handleEvents
			end, "Timed out waiting for Draggable.Handle to inject its Event table")
			local overlay = findDescendant(mounted.host, "OverlayProvider")
			local _absolutePosition = handle.AbsolutePosition
			local _arg0 = handle.AbsoluteSize / 2
			local pressPoint = _absolutePosition + _arg0
			events.InputBegan(handle, fakeInput(pressPoint))
			Assert:equal(startCount, 1, "Expected onStartDrag to fire once when the drag begins")
			Assert["true"](Assert, registration.draggable.isDragging, "Expected the registration to report an active drag")
			local placeholder = waitForGuiObject(mounted.host, "DraggablePlaceholder")
			waitForLayout(function()
				return if not dragItem.Visible then true else nil
			end, "Timed out waiting for the original to hide while dragging")
			local preview = waitForLayout(function()
				return overlay:FindFirstChild("DragItem")
			end, "Timed out waiting for the drag preview to be portalled into the overlay")
			Assert:equal(placeholder.Parent, mounted.host, "Expected the placeholder to sit where the original does")
			assertSizeApprox(placeholder, 160, 90, 1, "placeholder")
			Assert["true"](Assert, preview.Visible, "Expected the preview clone to be visible")
			assertSizeApprox(preview, 160, 90, 1, "drag preview")
			local _draggable = registration.draggable
			local _vector2 = Vector2.new(30, 20)
			_draggable.endDrag(fakeInput(pressPoint + _vector2))
			Assert:equal(dropCount, 1, "Expected onDropped to fire once when the drag ends")
			Assert["false"](Assert, registration.draggable.isDragging, "Expected the registration to report the drag as over")
			waitForLayout(function()
				return if dragItem.Visible then true else nil
			end, "Timed out waiting for the original to reappear after the drop")
			waitForLayout(function()
				return if mounted.host:FindFirstChild("DraggablePlaceholder", true) == nil then true else nil
			end, "Timed out waiting for the placeholder to be removed after the drop")
			waitForLayout(function()
				return if overlay:FindFirstChild("DragItem") == nil then true else nil
			end, "Timed out waiting for the preview to leave the overlay after the drop")
			Assert:equal(dragItem.Position, UDim2.fromOffset(0, 0), "Expected the original to keep its Position without retainPosition")
		end)
	end
	local _decorator = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_1 = DisplayName("Idle, the child renders in place with no wrapper or placeholder, visible, at its own size, inside the host")
	local _descriptor = Test(DraggableMountValidation, "rendersChildInPlace", {
		value = DraggableMountValidation.rendersChildInPlace,
	})
	if _descriptor then
		DraggableMountValidation.rendersChildInPlace = _descriptor.value
	end
	local _descriptor_1 = _decorator_1(DraggableMountValidation, "rendersChildInPlace", {
		value = DraggableMountValidation.rendersChildInPlace,
	})
	if _descriptor_1 then
		DraggableMountValidation.rendersChildInPlace = _descriptor_1.value
	end
	local _descriptor_2 = _decorator(DraggableMountValidation, "rendersChildInPlace", {
		value = DraggableMountValidation.rendersChildInPlace,
	})
	if _descriptor_2 then
		DraggableMountValidation.rendersChildInPlace = _descriptor_2.value
	end
	local _decorator_2 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_3 = DisplayName("Draggable.Handle marks its child Active and injects an InputBegan handler, without touching the root element")
	local _descriptor_3 = Test(DraggableMountValidation, "handleIsActive", {
		value = DraggableMountValidation.handleIsActive,
	})
	if _descriptor_3 then
		DraggableMountValidation.handleIsActive = _descriptor_3.value
	end
	local _descriptor_4 = _decorator_3(DraggableMountValidation, "handleIsActive", {
		value = DraggableMountValidation.handleIsActive,
	})
	if _descriptor_4 then
		DraggableMountValidation.handleIsActive = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(DraggableMountValidation, "handleIsActive", {
		value = DraggableMountValidation.handleIsActive,
	})
	if _descriptor_5 then
		DraggableMountValidation.handleIsActive = _descriptor_5.value
	end
	local _decorator_4 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_5 = DisplayName("Registers its root under DraggableRegistryKey with its id and an idle (not dragging) draggable")
	local _descriptor_6 = Test(DraggableMountValidation, "registersInRegistry", {
		value = DraggableMountValidation.registersInRegistry,
	})
	if _descriptor_6 then
		DraggableMountValidation.registersInRegistry = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_5(DraggableMountValidation, "registersInRegistry", {
		value = DraggableMountValidation.registersInRegistry,
	})
	if _descriptor_7 then
		DraggableMountValidation.registersInRegistry = _descriptor_7.value
	end
	local _descriptor_8 = _decorator_4(DraggableMountValidation, "registersInRegistry", {
		value = DraggableMountValidation.registersInRegistry,
	})
	if _descriptor_8 then
		DraggableMountValidation.registersInRegistry = _descriptor_8.value
	end
	local _decorator_6 = Skip(not Runtime.isRoblox(), STUDIO_SKIP_MESSAGE)
	local _decorator_7 = DisplayName("A press on the handle starts a drag (placeholder shown, original hidden, preview in the overlay) and releasing ends it")
	local _descriptor_9 = Test(DraggableMountValidation, "dragLifecycle", {
		value = DraggableMountValidation.dragLifecycle,
	})
	if _descriptor_9 then
		DraggableMountValidation.dragLifecycle = _descriptor_9.value
	end
	local _descriptor_10 = _decorator_7(DraggableMountValidation, "dragLifecycle", {
		value = DraggableMountValidation.dragLifecycle,
	})
	if _descriptor_10 then
		DraggableMountValidation.dragLifecycle = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_6(DraggableMountValidation, "dragLifecycle", {
		value = DraggableMountValidation.dragLifecycle,
	})
	if _descriptor_11 then
		DraggableMountValidation.dragLifecycle = _descriptor_11.value
	end
	DraggableMountValidation = Tag("Studio")(DraggableMountValidation) or DraggableMountValidation
end
return DraggableMountValidation
