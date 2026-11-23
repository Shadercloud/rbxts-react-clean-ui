-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local _ = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local ElementHelper = _.ElementHelper
local GuiHelper = _.GuiHelper
local _Providers = TS.import(script, script.Parent.Parent.Parent, "Providers")
local DraggableRegistryKey = _Providers.DraggableRegistryKey
local DroppableRegistryKey = _Providers.DroppableRegistryKey
local GlobalRegistry = _Providers.GlobalRegistry
local RegistryContext = _Providers.RegistryContext
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local DragStateContext = _Contexts.DragStateContext
local DraggableContext = _Contexts.DraggableContext
local OverlayConsumer = _Contexts.OverlayConsumer
local useUiScale = _Contexts.useUiScale
local createPortal = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox")).createPortal
local Corners = TS.import(script, script.Parent.Parent, "Decorator").Corners
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local CustomInputService = _Helpers.CustomInputService
local toDesignPixels = _Helpers.toDesignPixels
local OverlayScaleFrame = TS.import(script, script.Parent, "UiScaleRoot.frame").OverlayScaleFrame
local DEFAULT_INPUT_TYPES = { Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch }
local PREVIEW_DRAG_STATE = {
	preview = true,
	dragging = true,
}
local function toPoint(input)
	return Vector2.new(input.Position.X, input.Position.Y)
end
local function createDragEventInfo(input, dragInformation, id)
	return {
		inputType = dragInformation.inputType,
		input = input,
		position = toPoint(input),
		id = id,
	}
end
local function isInteractiveDescendantAtInput(handle, input)
	local point = toPoint(input)
	local _exp = handle:GetDescendants()
	-- ▼ ReadonlyArray.some ▼
	local _result = false
	local _callback = function(descendant)
		return (descendant:IsA("GuiButton") or descendant:IsA("TextBox")) and GuiHelper:isGuiObjectHitAtPoint(descendant, point)
	end
	for _k, _v in _exp do
		if _callback(_v, _k - 1, _exp) then
			_result = true
			break
		end
	end
	-- ▲ ReadonlyArray.some ▲
	return _result
end
local function DragHandle(_param)
	local children = _param.children
	local draggable = React.useContext(DraggableContext)
	local dragState = React.useContext(DragStateContext)
	local _arg0 = draggable ~= nil
	assert(_arg0, "Draggable.Handle must be used inside a Draggable component")
	local inert = dragState.preview
	React.useEffect(function()
		if inert then
			return nil
		end
		local inputChangedListener = CustomInputService.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				draggable.updateDrag(input)
			end
		end)
		local inputEndedListener = CustomInputService.InputEnded:Connect(function(input)
			draggable.endDrag(input)
		end)
		return function()
			inputChangedListener:Disconnect()
			inputEndedListener:Disconnect()
		end
	end, { draggable, inert })
	if inert then
		return React.cloneElement(children, {
			Active = true,
		})
	end
	return ElementHelper:cloneWithEvents(children, {
		Active = true,
	}, {
		InputBegan = function(instance, input)
			if not isInteractiveDescendantAtInput(instance, input) then
				draggable.beginDrag(input, instance)
			end
		end,
	})
end
local function Placeholder(props)
	local theme = React.useContext(CleanThemeContext)
	local _attributes = {
		key = "DraggablePlaceholder",
		BorderSizePixel = 0,
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
	local parentDragState = React.useContext(DragStateContext)
	local uiScale = useUiScale()
	local rootRef = React.useRef()
	local placeholderRef = React.useRef()
	local dragInformationRef = React.useRef()
	local hoveredRef = React.useRef()
	local idRef = React.useRef()
	idRef.current = props.id
	local _condition = props.placeholder
	if _condition == nil then
		_condition = true
	end
	local usePlaceholder = _condition
	local inputTypes = props.inputTypes or DEFAULT_INPUT_TYPES
	local registrationRef = React.useRef()
	local findDroppable = React.useCallback(function(position)
		local result
		for _1, registryEntry in GlobalRegistry.getAll(DroppableRegistryKey) do
			if not GuiHelper:isGuiObjectHitAtPoint(registryEntry.guiObject, position) then
				continue
			end
			if result == nil or GuiHelper:isRenderedAbove(registryEntry.guiObject, result.guiObject) then
				result = registryEntry
			end
		end
		return result
	end, {})
	local beginDrag = React.useCallback(function(input)
		local root = rootRef.current
		local registration = registrationRef.current
		if root == nil or dragInformationRef.current ~= nil then
			return nil
		end
		local _userInputType = input.UserInputType
		if not (table.find(inputTypes, _userInputType) ~= nil) then
			return nil
		end
		local allDraggables = GlobalRegistry.getAll(DraggableRegistryKey)
		-- ▼ ReadonlyArray.some ▼
		local _result = false
		local _callback = function(registration)
			return registration.draggable.isDragging
		end
		for _k, _v in allDraggables do
			if _callback(_v, _k - 1, allDraggables) then
				_result = true
				break
			end
		end
		-- ▲ ReadonlyArray.some ▲
		if _result then
			return nil
		end
		if registration ~= nil then
			registration.draggable.isDragging = true
		end
		local dragInformation = {
			root = root,
			input = input,
			inputType = input.UserInputType,
			keyCode = input.KeyCode,
			inputStart = toPoint(input),
			absolutePositionStart = root.AbsolutePosition,
			positionStart = root.Position,
		}
		dragInformationRef.current = dragInformation
		hoveredRef.current = nil
		local _result_1 = props.onStartDrag
		if _result_1 ~= nil then
			_result_1(createDragEventInfo(input, dragInformation, props.id))
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
	end, { props.onStartDrag, props.id, inputTypes })
	local updateDrag = React.useCallback(function(input)
		local root = rootRef.current
		local dragInformation = dragInformationRef.current
		if root == nil or dragInformation == nil then
			return nil
		end
		local inputPosition = toPoint(input)
		local _inputStart = dragInformation.inputStart
		local delta = inputPosition - _inputStart
		local info = createDragEventInfo(input, dragInformation, props.id)
		local dropRegisteration = findDroppable(inputPosition)
		local hovered = hoveredRef.current
		local _result = hovered
		if _result ~= nil then
			_result = _result.guiObject
		end
		local _result_1 = dropRegisteration
		if _result_1 ~= nil then
			_result_1 = _result_1.guiObject
		end
		if _result ~= _result_1 then
			hoveredRef.current = dropRegisteration
			local _result_2 = hovered
			if _result_2 ~= nil then
				_result_2 = _result_2.dragLeave
				if _result_2 ~= nil then
					_result_2(root, info)
				end
			end
			local _result_3 = dropRegisteration
			if _result_3 ~= nil then
				_result_3 = _result_3.dragEnter
				if _result_3 ~= nil then
					_result_3(root, info)
				end
			end
		end
		local _result_2 = props.onDragged
		if _result_2 ~= nil then
			_result_2(dropRegisteration, info)
		end
		setOverlayPosition(dragInformation.absolutePositionStart + delta)
	end, { findDroppable, props.onDragged, props.id })
	local endDrag = React.useCallback(function(input)
		local root = rootRef.current
		local dragInformation = dragInformationRef.current
		local registration = registrationRef.current
		if root == nil or dragInformation == nil then
			return nil
		end
		if input.UserInputType ~= dragInformation.inputType or input.KeyCode ~= dragInformation.keyCode then
			return nil
		end
		if registration then
			registration.draggable.isDragging = false
		end
		local inputPosition = toPoint(input)
		local info = createDragEventInfo(input, dragInformation, props.id)
		local dropRegisteration = findDroppable(inputPosition)
		local hovered = hoveredRef.current
		dragInformationRef.current = nil
		hoveredRef.current = nil
		local _result = dropRegisteration
		if _result ~= nil then
			_result.drop(root, info)
		end
		local _result_1 = hovered
		if _result_1 ~= nil then
			_result_1 = _result_1.dragLeave
			if _result_1 ~= nil then
				_result_1(root, info)
			end
		end
		local _result_2 = props.onDropped
		if _result_2 ~= nil then
			_result_2(dropRegisteration, info)
		end
		if props.retainPosition then
			local parent = root.Parent
			local _result_3 = parent
			if _result_3 ~= nil then
				_result_3 = _result_3:IsA("GuiObject")
			end
			if _result_3 then
				local _inputStart = dragInformation.inputStart
				local delta = inputPosition - _inputStart
				local finalOverlayPosition = dragInformation.absolutePositionStart + delta
				local _absolutePosition = parent.AbsolutePosition
				local localTopLeft = toDesignPixels(finalOverlayPosition - _absolutePosition, uiScale)
				local _absoluteSize = root.AbsoluteSize
				local _anchorPoint = root.AnchorPoint
				local anchorOffset = toDesignPixels(_absoluteSize * _anchorPoint, uiScale)
				root.Position = UDim2.fromOffset(localTopLeft.X + anchorOffset.X, localTopLeft.Y + anchorOffset.Y)
			end
		end
		setDragging(false)
	end, { findDroppable, props.onDropped, props.retainPosition, props.id, uiScale })
	local contextValue = React.useMemo(function()
		return {
			isDragging = dragInformationRef.current ~= nil,
			beginDrag = beginDrag,
			updateDrag = updateDrag,
			endDrag = endDrag,
		}
	end, { beginDrag, updateDrag, endDrag })
	React.useEffect(function()
		local root = rootRef.current
		if root == nil or parentDragState.preview then
			return nil
		end
		local registration = {
			guiObject = root,
			id = props.id,
			draggable = contextValue,
		}
		registrationRef.current = registration
		local _result = registry
		if _result ~= nil then
			_result.register(root, DraggableRegistryKey, registration)
		end
		GlobalRegistry.register(root, DraggableRegistryKey, registration)
		return function()
			local _result_1 = registry
			if _result_1 ~= nil then
				_result_1.unregister(registration.guiObject, DraggableRegistryKey)
			end
			if GlobalRegistry.get(registration.guiObject, DraggableRegistryKey) == registration then
				GlobalRegistry.unregister(registration.guiObject, DraggableRegistryKey)
			end
			if registrationRef.current == registration then
				registrationRef.current = nil
			end
		end
	end, { registry, props.id, contextValue, parentDragState.preview })
	React.useEffect(function()
		return function()
			local dragInformation = dragInformationRef.current
			local hovered = hoveredRef.current
			hoveredRef.current = nil
			if dragInformation ~= nil and hovered ~= nil then
				local _result = hovered.dragLeave
				if _result ~= nil then
					_result(dragInformation.root, createDragEventInfo(dragInformation.input, dragInformation, idRef.current))
				end
			end
		end
	end, {})
	local dragStateValue = React.useMemo(function()
		return {
			preview = parentDragState.preview,
			dragging = parentDragState.dragging or dragging,
		}
	end, { parentDragState.preview, parentDragState.dragging, dragging })
	local original = React.cloneElement(props.children, {
		ref = rootRef,
		Visible = not dragging,
	})
	local designOverlaySize = toDesignPixels(overlaySize, uiScale)
	local placeholder = (React.createElement(Placeholder, {
		ref = placeholderRef,
		Position = placeholderPosition.Position,
		AnchorPoint = placeholderPosition.AnchorPoint,
		Size = UDim2.fromOffset(designOverlaySize.X, designOverlaySize.Y),
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 0.3,
		LayoutOrder = placeholderPosition.LayoutOrder,
		ZIndex = placeholderPosition.ZIndex,
	}))
	return React.createElement(DraggableContext.Provider, {
		value = contextValue,
	}, React.createElement(DragStateContext.Provider, {
		value = dragStateValue,
	}, usePlaceholder and dragging and placeholder, original), React.createElement(OverlayConsumer, {
		render = function(overlay)
			if not dragging or overlay == nil then
				return nil
			end
			local _absolutePosition = overlay.AbsolutePosition
			local localPosition = toDesignPixels(overlayPosition - _absolutePosition, uiScale)
			local position = UDim2.fromOffset(localPosition.X, localPosition.Y)
			local size = UDim2.fromOffset(designOverlaySize.X, designOverlaySize.Y)
			local preview = if props.renderOverlay ~= nil then (React.createElement("frame", {
				key = "DragOverlay",
				Position = position,
				Size = size,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 100001,
			}, props.renderOverlay())) else React.cloneElement(props.children, {
				Position = position,
				Size = size,
				AnchorPoint = Vector2.zero,
				AutomaticSize = Enum.AutomaticSize.None,
				Visible = true,
				ZIndex = 100001,
			})
			return createPortal(React.createElement(OverlayScaleFrame, {
				ZIndex = 100001,
			}, React.createElement(DragStateContext.Provider, {
				value = PREVIEW_DRAG_STATE,
			}, preview)), overlay)
		end,
	}))
end)
Draggable.Handle = DragHandle
return {
	Draggable = Draggable,
}
