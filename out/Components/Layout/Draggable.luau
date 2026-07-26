-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local Component = _react.Component
local ReactComponent = _react.ReactComponent
local useContext = _react.useContext
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
local UserInputService = TS.import(script, TS.getModule(script, "@rbxts", "services")).UserInputService
local Environment = TS.import(script, TS.getModule(script, "@rbxts", "ui-labs").src).Environment
local function DragHandle(_param)
	local children = _param.children
	local draggable = React.useContext(DraggableContext)
	local _arg0 = draggable ~= nil
	assert(_arg0, "Draggable.Handle must be used inside a Draggable component")
	local childEvents = children.props.Event
	local useUserInputService = not Environment.IsStory()
	local inputSignals = if Environment.IsStory() then Environment.InputListener else UserInputService
	React.useEffect(function()
		local inputChangedListener = inputSignals.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
				draggable.updateDrag(input)
			end
		end)
		local inputEndedListener = inputSignals.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				draggable.endDrag(input)
			end
		end)
		return function()
			inputChangedListener:Disconnect()
			inputEndedListener:Disconnect()
		end
	end, { draggable, useUserInputService })
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
	local theme = useContext(CleanThemeContext)
	local _attributes = table.clone(props)
	setmetatable(_attributes, nil)
	_attributes.BackgroundTransparency = theme.components.draggable.placeholder.backgroundTransparency
	_attributes.BackgroundColor3 = theme.components.draggable.placeholder.backgroundColor
	return React.createElement("frame", _attributes, React.createElement("uistroke", {
		Thickness = theme.components.draggable.placeholder.borderThickness,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Color = theme.components.draggable.placeholder.borderColor,
	}), React.createElement(Corners, {
		radius = theme.components.draggable.placeholder.cornerRadius,
	}))
end
local Draggable
do
	local super = Component
	Draggable = setmetatable({}, {
		__tostring = function()
			return "Draggable"
		end,
		__index = super,
	})
	Draggable.__index = Draggable
	function Draggable.new(...)
		local self = setmetatable({}, Draggable)
		return self:constructor(...) or self
	end
	function Draggable:constructor(...)
		super.constructor(self, ...)
		self.state = {
			dragging = false,
			overlayPosition = Vector2.zero,
			overlaySize = Vector2.zero,
			placeholderPosition = UDim2.fromOffset(0, 0),
			placeholderAnchorPoint = Vector2.zero,
			placeholderLayoutOrder = 0,
			placeholderZIndex = 1,
		}
		self.rootRef = React.createRef()
		self.placeholderRef = React.createRef()
		local _condition = self.props.placeholder
		if _condition == nil then
			_condition = true
		end
		self.usePlaceholder = _condition
		self.beginDrag = function(input, handle)
			local root = self.rootRef.current
			if root == nil then
				return nil
			end
			local _allDraggables = self.context
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
			if self.registration ~= nil then
				self.registration.draggable.isDragging = true
			end
			self.dragInformation = {
				input = input,
				inputStart = Vector2.new(input.Position.X, input.Position.Y),
				absolutePositionStart = root.AbsolutePosition,
				positionStart = root.Position,
			}
			local _result_1 = self.props.onStartDrag
			if _result_1 ~= nil then
				_result_1()
			end
			self:setState({
				dragging = true,
				overlayPosition = root.AbsolutePosition,
				overlaySize = root.AbsoluteSize,
				placeholderPosition = root.Position,
				placeholderAnchorPoint = root.AnchorPoint,
				placeholderLayoutOrder = root.LayoutOrder,
				placeholderZIndex = root.ZIndex,
			})
		end
		self.updateDrag = function(input)
			local root = self.rootRef.current
			local drag = self.dragInformation
			if root == nil or drag == nil then
				return nil
			end
			local inputPosition = Vector2.new(input.Position.X, input.Position.Y)
			local _inputStart = drag.inputStart
			local delta = inputPosition - _inputStart
			local overlayPosition = drag.absolutePositionStart + delta
			local dropRegisteration = self:findDroppable(root, Vector2.new(input.Position.X, input.Position.Y))
			local _result = self.props.onDragged
			if _result ~= nil then
				_result(dropRegisteration)
			end
			self:setState({
				overlayPosition = overlayPosition,
			})
		end
		self.endDrag = function(input)
			local root = self.rootRef.current
			local drag = self.dragInformation
			if root == nil or drag == nil then
				return nil
			end
			if self.registration then
				self.registration.draggable.isDragging = false
			end
			local dropRegisteration = self:findDroppable(root, Vector2.new(input.Position.X, input.Position.Y))
			self.dragInformation = nil
			local _result = self.props.onDropped
			if _result ~= nil then
				_result(dropRegisteration)
			end
			if self.props.retainPosition then
				local parent = root.Parent
				local _result_1 = parent
				if _result_1 ~= nil then
					_result_1 = _result_1:IsA("GuiObject")
				end
				if _result_1 then
					local _overlayPosition = self.state.overlayPosition
					local _absolutePosition = parent.AbsolutePosition
					local localTopLeft = _overlayPosition - _absolutePosition
					local _absoluteSize = root.AbsoluteSize
					local _anchorPoint = root.AnchorPoint
					local anchorOffset = _absoluteSize * _anchorPoint
					root.Position = UDim2.fromOffset(localTopLeft.X + anchorOffset.X, localTopLeft.Y + anchorOffset.Y)
				end
			end
			self:setState({
				dragging = false,
			})
		end
		self.contextValue = {
			isDragging = false,
			beginDrag = self.beginDrag,
			updateDrag = self.updateDrag,
			endDrag = self.endDrag,
		}
	end
	function Draggable:componentDidMount()
		local registry = self.context
		local root = self.rootRef.current
		if registry == nil or root == nil then
			return nil
		end
		local registration = {
			guiObject = root,
			id = self.props.id,
			draggable = self.contextValue,
		}
		self.registration = registration
		registry.register(root, DraggableRegistryKey, registration)
	end
	function Draggable:componentWillUnmount()
		local registry = self.context
		local registration = self.registration
		if registry == nil or registration == nil then
			return nil
		end
		registry.unregister(registration.guiObject, DraggableRegistryKey)
		self.registration = nil
	end
	function Draggable:findDroppable(instance, position)
		local result
		local _exp = GuiHelper:getGuiObjectsAtPosition(instance, position)
		-- ▼ ReadonlyArray.forEach ▼
		local _callback = function(guiObject)
			local _registryEntry = self.context
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
	end
	function Draggable:render()
		local original = React.cloneElement(self.props.children, {
			ref = self.rootRef,
			Visible = not self.state.dragging,
		})
		local placeholder = (React.createElement(Placeholder, {
			ref = self.placeholderRef,
			Position = self.state.placeholderPosition,
			AnchorPoint = self.state.placeholderAnchorPoint,
			Size = UDim2.fromOffset(self.state.overlaySize.X, self.state.overlaySize.Y),
			AutomaticSize = Enum.AutomaticSize.None,
			BackgroundTransparency = 0.3,
			LayoutOrder = self.state.placeholderLayoutOrder,
			ZIndex = self.state.placeholderZIndex,
		}))
		return React.createElement(DraggableContext.Provider, {
			value = self.contextValue,
		}, self.usePlaceholder and self.state.dragging and placeholder, original, React.createElement(OverlayConsumer, {
			render = function(overlay)
				if not self.state.dragging or overlay == nil then
					return nil
				end
				local _overlayPosition = self.state.overlayPosition
				local _absolutePosition = overlay.AbsolutePosition
				local localPosition = _overlayPosition - _absolutePosition
				return createPortal(React.cloneElement(self.props.children, {
					Position = UDim2.fromOffset(localPosition.X, localPosition.Y),
					Size = UDim2.fromOffset(self.state.overlaySize.X, self.state.overlaySize.Y),
					AnchorPoint = Vector2.zero,
					AutomaticSize = Enum.AutomaticSize.None,
					Visible = true,
					ZIndex = 100001,
				}), overlay)
			end,
		}))
	end
	Draggable.Handle = DragHandle
	Draggable.contextType = RegistryContext
	Draggable = ReactComponent(Draggable) or Draggable
end
return {
	Draggable = Draggable,
}
