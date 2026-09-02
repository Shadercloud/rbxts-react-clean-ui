-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local GuiHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").GuiHelper
local _Providers = TS.import(script, script.Parent.Parent.Parent, "Providers")
local DraggableRegistryKey = _Providers.DraggableRegistryKey
local DroppableRegistryKey = _Providers.DroppableRegistryKey
local RegistryContext = _Providers.RegistryContext
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local DraggableContext = _Contexts.DraggableContext
local OverlayConsumer = _Contexts.OverlayConsumer
local createPortal = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox")).createPortal
local Corners = TS.import(script, script.Parent.Parent, "Decorator").Corners
local CustomInputService = TS.import(script, script.Parent.Parent.Parent, "Helpers").CustomInputService
local function DragHandle(_param)
	local children = _param.children
	local draggable = React.useContext(DraggableContext)
	local _arg0 = draggable ~= nil
	assert(_arg0, "Draggable.Handle must be used inside a Draggable component")
	local childEvents = children.props.Event
	React.useEffect(function()
		local inputChangedListener = CustomInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				draggable.updateDrag(input)
			end
		end)
		local inputEndedListener = CustomInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggable.endDrag(input)
			end
		end)
		return function()
			inputChangedListener:Disconnect()
			inputEndedListener:Disconnect()
		end
	end, { draggable })
	local _object = {
		Active = true,
	}
	local _left = "Event"
	local _object_1 = {}
	if childEvents then
		for _k, _v in childEvents do
			_object_1[_k] = _v
		end
	end
	_object_1.InputBegan = function(instance, input)
		local _result = childEvents
		if _result ~= nil then
			_result = _result.InputBegan
			if _result ~= nil then
				_result(instance, input)
			end
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggable.beginDrag(input, instance)
		end
	end
	_object[_left] = _object_1
	return React.cloneElement(children, _object)
end
local function Placeholder(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {
		key = "DraggablePlaceholder",
	}
	for _k, _v in props do
		_attributes[_k] = _v
	end
	_attributes.BackgroundTransparency = theme.components.draggable.placeholder.backgroundTransparency
	_attributes.BackgroundColor3 = theme.components.draggable.placeholder.backgroundColor
	return React.createElement("frame", _attributes, React.createElement("uistroke", {
		key = "Stroke",
		Thickness = theme.components.draggable.placeholder.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.draggable.placeholder.borderColor,
	}), React.createElement(Corners, {
		radius = theme.components.draggable.placeholder.cornerRadius,
	}))
end
local Draggable = React.forwardRef(function(props, _ref)
	local dragging, setDragging = React.useState(false)
	local overlayPosition, setOverlayPosition = React.useState(Vector2.zero)
	local overlaySize, setOverlaySize = React.useState(Vector2.zero)
	local placeholderPosition, setPlaceholderPosition = React.useState({
		Position = UDim2.fromOffset(0, 0),
		AnchorPoint = Vector2.zero,
		LayoutOrder = 0,
		ZIndex = 1,
	})
	local registry = React.useContext(RegistryContext)
	local rootRef = React.useRef()
	local placeholderRef = React.useRef()
	local dragInformationRef = React.useRef()
	local _condition = props.placeholder
	if _condition == nil then
		_condition = true
	end
	local usePlaceholder = _condition
	local registrationRef = React.useRef()
	local findDroppable = React.useCallback(function(instance, position)
		local result
		local _exp = GuiHelper:getGuiObjectsAtPosition(instance, position)
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(guiObject)
			local _registryEntry = registry
			if _registryEntry ~= nil then
				_registryEntry = _registryEntry.get(guiObject, DroppableRegistryKey)
			end
			local registryEntry = _registryEntry
			if registryEntry then
				local _result = registryEntry
				if _result ~= nil then
					_result.drop(instance)
				end
				result = registryEntry
			end
		end
		for _k, _v in _exp do
			_callback(_v, _k - 1, _exp)
		end
		-- ▲ ReadonlyArray.forEach ▲
		return result
	end, { registry })
	local beginDrag = React.useCallback(function(input, handle)
		local root = rootRef.current
		local registration = registrationRef.current
		if root == nil then
			return nil
		end
		local _allDraggables = registry
		if _allDraggables ~= nil then
			_allDraggables = _allDraggables.getAll(DraggableRegistryKey)
		end
		local allDraggables = _allDraggables
		local _result = allDraggables
		if _result ~= nil then
			-- ▼ ReadonlyArray.some ▼
			local _result_1 = false
			local _callback = function(registration)
				return registration.draggable.isDragging
			end
			for _k, _v in _result do
				if _callback(_v, _k - 1, _result) then
					_result_1 = true
					break
				end
			end
			-- ▲ ReadonlyArray.some ▲
			_result = _result_1
		end
		if _result then
			return nil
		end
		if registration ~= nil then
			registration.draggable.isDragging = true
		end
		dragInformationRef.current = {
			input = input,
			inputStart = Vector2.new(input.Position.X, input.Position.Y),
			absolutePositionStart = root.AbsolutePosition,
			positionStart = root.Position,
		}
		local _result_1 = props.onStartDrag
		if _result_1 ~= nil then
			_result_1()
		end
		setDragging(true)
		setOverlayPosition(root.AbsolutePosition)
		setOverlaySize(root.AbsoluteSize)
		setPlaceholderPosition({
			Position = root.Position,
			AnchorPoint = root.AnchorPoint,
			LayoutOrder = root.LayoutOrder,
			ZIndex = root.ZIndex,
		})
	end, { registry, props.onStartDrag })
	local updateDrag = React.useCallback(function(input)
		local root = rootRef.current
		local dragInformation = dragInformationRef.current
		if root == nil or dragInformation == nil then
			return nil
		end
		local inputPosition = Vector2.new(input.Position.X, input.Position.Y)
		local _inputStart = dragInformation.inputStart
		local delta = inputPosition - _inputStart
		local dropRegisteration = findDroppable(root, Vector2.new(input.Position.X, input.Position.Y))
		local _result = props.onDragged
		if _result ~= nil then
			_result(dropRegisteration)
		end
		setOverlayPosition(dragInformation.absolutePositionStart + delta)
	end, { findDroppable, props.onDragged })
	local endDrag = React.useCallback(function(input)
		local root = rootRef.current
		local dragInformation = dragInformationRef.current
		local registration = registrationRef.current
		if root == nil or dragInformation == nil then
			return nil
		end
		if registration then
			registration.draggable.isDragging = false
		end
		local dropRegisteration = findDroppable(root, Vector2.new(input.Position.X, input.Position.Y))
		dragInformationRef.current = nil
		local _result = props.onDropped
		if _result ~= nil then
			_result(dropRegisteration)
		end
		if props.retainPosition then
			local parent = root.Parent
			local _result_1 = parent
			if _result_1 ~= nil then
				_result_1 = _result_1:IsA("GuiObject")
			end
			if _result_1 then
				local inputPosition = Vector2.new(input.Position.X, input.Position.Y)
				local _inputStart = dragInformation.inputStart
				local delta = inputPosition - _inputStart
				local finalOverlayPosition = dragInformation.absolutePositionStart + delta
				local _absolutePosition = parent.AbsolutePosition
				local localTopLeft = finalOverlayPosition - _absolutePosition
				local _absoluteSize = root.AbsoluteSize
				local _anchorPoint = root.AnchorPoint
				local anchorOffset = _absoluteSize * _anchorPoint
				root.Position = UDim2.fromOffset(localTopLeft.X + anchorOffset.X, localTopLeft.Y + anchorOffset.Y)
			end
		end
		setDragging(false)
	end, { findDroppable, props.onDropped, props.retainPosition })
	local contextValue = React.useMemo(function()
		return {
			isDragging = false,
			beginDrag = beginDrag,
			updateDrag = updateDrag,
			endDrag = endDrag,
		}
	end, { beginDrag, updateDrag, endDrag })
	React.useEffect(function()
		local root = rootRef.current
		if registry == nil or root == nil then
			return nil
		end
		local registration = {
			guiObject = root,
			id = props.id,
			draggable = contextValue,
		}
		registrationRef.current = registration
		registry.register(root, DraggableRegistryKey, registration)
		return function()
			registry.unregister(registration.guiObject, DraggableRegistryKey)
			if registrationRef.current == registration then
				registrationRef.current = nil
			end
		end
	end, { registry, props.id, contextValue })
	local original = React.cloneElement(props.children, {
		ref = rootRef,
		Visible = not dragging,
	})
	local placeholder = (React.createElement(Placeholder, {
		ref = placeholderRef,
		Position = placeholderPosition.Position,
		AnchorPoint = placeholderPosition.AnchorPoint,
		Size = UDim2.fromOffset(overlaySize.X, overlaySize.Y),
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 0.3,
		LayoutOrder = placeholderPosition.LayoutOrder,
		ZIndex = placeholderPosition.ZIndex,
	}))
	return React.createElement(DraggableContext.Provider, {
		value = contextValue,
	}, usePlaceholder and dragging and placeholder, original, React.createElement(OverlayConsumer, {
		render = function(overlay)
			if not dragging or overlay == nil then
				return nil
			end
			local _absolutePosition = overlay.AbsolutePosition
			local localPosition = overlayPosition - _absolutePosition
			return createPortal(React.cloneElement(props.children, {
				Position = UDim2.fromOffset(localPosition.X, localPosition.Y),
				Size = UDim2.fromOffset(overlaySize.X, overlaySize.Y),
				AnchorPoint = Vector2.zero,
				AutomaticSize = Enum.AutomaticSize.None,
				Visible = true,
				ZIndex = 100001,
			}), overlay)
		end,
	}))
end)
Draggable.Handle = DragHandle
return {
	Draggable = Draggable,
}
