-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local ReactRoblox = TS.import(script, TS.getModule(script, "@rbxts", "react-roblox"))
local GuiService = TS.import(script, TS.getModule(script, "@rbxts", "services")).GuiService
local useTween = TS.import(script, TS.getModule(script, "@rbxts", "react-ripple").src).useTween
local _Contexts = TS.import(script, script.Parent.Parent.Parent, "Contexts")
local CleanThemeContext = _Contexts.CleanThemeContext
local ModalCloseContext = _Contexts.ModalCloseContext
local OverlayConsumer = _Contexts.OverlayConsumer
local useModalStack = _Contexts.useModalStack
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
local Draggable = TS.import(script, script.Parent.Parent, "Layout").Draggable
local Card = TS.import(script, script.Parent.Parent, "Surface").Card
local nextModalId = 0
local function generateModalId()
	nextModalId += 1
	return `modal-{nextModalId}`
end
-- GuiService.SelectedObject can only be set to a descendant of a PlayerGui —
-- it throws otherwise (e.g. a ui-labs Studio plugin preview, or any other
-- non-PlayerGui host). Focus is a non-essential enhancement, so failures here
-- are swallowed rather than crashing the whole render.
local function trySetSelectedObject(target)
	pcall(function()
		GuiService.SelectedObject = target
	end)
end
local function getPanelContentSize(automaticSize)
	local autoWidth = automaticSize == Enum.AutomaticSize.X or automaticSize == Enum.AutomaticSize.XY or automaticSize == "X" or automaticSize == "XY"
	local autoHeight = automaticSize == Enum.AutomaticSize.Y or automaticSize == Enum.AutomaticSize.XY or automaticSize == "Y" or automaticSize == "XY"
	return UDim2.fromScale(if autoWidth then 0 else 1, if autoHeight then 0 else 1)
end
local function Modal(props)
	local theme = React.useContext(CleanThemeContext)
	local stack = useModalStack()
	local idRef = React.useRef()
	if idRef.current == nil then
		idRef.current = generateModalId()
	end
	local id = idRef.current
	local _condition = props.closeOnBackdropClick
	if _condition == nil then
		_condition = true
	end
	local closeOnBackdropClick = _condition
	local _condition_1 = props.closeOnEscape
	if _condition_1 == nil then
		_condition_1 = true
	end
	local closeOnEscape = _condition_1
	local isControlled = props.open ~= nil
	local _condition_2 = props.defaultOpen
	if _condition_2 == nil then
		_condition_2 = false
	end
	local uncontrolledOpen, setUncontrolledOpen = React.useState(_condition_2)
	local _condition_3 = props.open
	if _condition_3 == nil then
		_condition_3 = uncontrolledOpen
	end
	local open = _condition_3
	local shouldRender, setShouldRender = React.useState(open)
	local dismissingRef = React.useRef(false)
	local fadeThreadRef = React.useRef()
	local panelRef = React.useRef()
	local previousSelectionRef = React.useRef()
	local onOpenChangeRef = React.useRef(props.onOpenChange)
	React.useEffect(function()
		onOpenChangeRef.current = props.onOpenChange
	end, { props.onOpenChange })
	local requestClose = React.useCallback(function()
		if not isControlled then
			setUncontrolledOpen(false)
		end
		local _result = onOpenChangeRef.current
		if _result ~= nil then
			_result(false)
		end
	end, { isControlled })
	local requestCloseRef = React.useRef(requestClose)
	React.useEffect(function()
		requestCloseRef.current = requestClose
	end, { requestClose })
	local closeOnEscapeRef = React.useRef(closeOnEscape)
	React.useEffect(function()
		closeOnEscapeRef.current = closeOnEscape
	end, { closeOnEscape })
	local fadeDuration = theme.components.modal.fadeDuration
	local backdropGoalTransparency = theme.components.modal.backdrop.backgroundTransparency
	local backdropTransparency, backdropTween = useTween(1, {
		duration = fadeDuration,
		easing = "quadOut",
	})
	local panelTransparency, panelTween = useTween(1, {
		duration = fadeDuration,
		easing = "quadOut",
	})
	local beginExit = React.useCallback(function()
		if dismissingRef.current then
			return nil
		end
		dismissingRef.current = true
		if fadeDuration <= 0 then
			setShouldRender(false)
			return nil
		end
		fadeThreadRef.current = task.delay(fadeDuration, function()
			fadeThreadRef.current = nil
			setShouldRender(false)
		end)
	end, { fadeDuration })
	-- Public open state vs. animated-unmount state: closing must finish its
	-- fade before the portal actually disappears, so `shouldRender` lags
	-- `open` on the way down (see beginExit above).
	React.useEffect(function()
		if open then
			local fadeThread = fadeThreadRef.current
			if fadeThread ~= nil then
				task.cancel(fadeThread)
				fadeThreadRef.current = nil
			end
			dismissingRef.current = false
			setShouldRender(true)
		elseif shouldRender then
			beginExit()
		end
	end, { open })
	React.useEffect(function()
		if not shouldRender then
			return nil
		end
		backdropTween:setGoal(if open then backdropGoalTransparency else 1)
		panelTween:setGoal(if open then 0 else 1)
	end, { open, shouldRender, backdropGoalTransparency })
	React.useEffect(function()
		return function()
			local fadeThread = fadeThreadRef.current
			if fadeThread ~= nil then
				task.cancel(fadeThread)
			end
		end
	end, {})
	-- Registers with the shared modal stack only while actually visible
	-- (including through the closing fade), so escape only ever targets the
	-- topmost visible modal. closeOnEscape/requestClose are read through
	-- refs kept current every render (see above) so this effect only needs
	-- to run when shouldRender flips.
	React.useEffect(function()
		if not shouldRender then
			return nil
		end
		stack.register({
			id = id,
			closeOnEscape = function()
				return closeOnEscapeRef.current
			end,
			requestClose = function()
				return requestCloseRef.current()
			end,
		})
		return function()
			stack.unregister(id)
		end
	end, { shouldRender })
	-- Scoped per-instance so nested modals restore focus to whatever was
	-- selected right before THEY opened, not a single shared value.
	React.useEffect(function()
		if not shouldRender then
			return nil
		end
		previousSelectionRef.current = GuiService.SelectedObject
		local _result = props.initialFocus
		if _result ~= nil then
			_result = _result.current
		end
		local _condition_4 = _result
		if _condition_4 == nil then
			_condition_4 = panelRef.current
		end
		trySetSelectedObject(_condition_4)
		return function()
			trySetSelectedObject(previousSelectionRef.current)
		end
	end, { shouldRender })
	if not shouldRender then
		return nil
	end
	local layerIndex = stack.getLayerIndex(id)
	local backdropZIndex = theme.components.modal.baseZIndex + layerIndex * theme.components.modal.zIndexStep
	return React.createElement(OverlayConsumer, {
		render = function(overlay)
			if overlay == nil then
				return nil
			end
			local panelChildren = if props.draggable then React.Children.map(props.children, function(child)
				return if React.isValidElement(child) and child.type == Card.Header then React.createElement(Draggable.Handle, nil, child) else child
			end) else props.children
			local _object = table.clone(props)
			setmetatable(_object, nil)
			local _left = "width"
			local _condition_4 = props.width
			if _condition_4 == nil then
				_condition_4 = theme.components.modal.width
			end
			_object[_left] = _condition_4
			local panelSizingProps = _object
			local panelSize = SizeHelper:GetSize(panelSizingProps)
			local panelAutomaticSize = SizeHelper:GetAutoSize(panelSizingProps)
			local panelContentSize = if type(panelAutomaticSize) == "table" and panelAutomaticSize.map ~= nil then panelAutomaticSize:map(getPanelContentSize) else getPanelContentSize(panelAutomaticSize)
			local _attributes = table.clone(props)
			setmetatable(_attributes, nil)
			local _condition_5 = props.name
			if _condition_5 == nil then
				_condition_5 = "Modal"
			end
			_attributes.name = _condition_5
			_attributes.ref = panelRef
			_attributes.Selectable = true
			_attributes.Size = panelContentSize
			_attributes.AutomaticSize = panelAutomaticSize
			_attributes.width = nil
			_attributes.height = nil
			local panel = (React.createElement("imagebutton", {
				key = "ModalPanelInputShield",
				Active = true,
				AnchorPoint = if props.draggable then Vector2.new(0.5, 0.5) else nil,
				AutoButtonColor = false,
				AutomaticSize = panelAutomaticSize,
				BackgroundTransparency = 1,
				ImageTransparency = 1,
				Position = if props.draggable then UDim2.fromScale(0.5, 0.5) else nil,
				Size = panelSize,
				Event = {
					Activated = function() end,
				},
			}, React.createElement(Card, _attributes, panelChildren)))
			return ReactRoblox.createPortal(React.createElement("imagebutton", {
				key = "ModalBackdrop",
				Size = UDim2.fromScale(1, 1),
				AutoButtonColor = false,
				Active = true,
				BackgroundColor3 = theme.components.modal.backdrop.backgroundColor,
				BackgroundTransparency = backdropTransparency,
				ZIndex = backdropZIndex,
				Event = {
					Activated = function()
						if closeOnBackdropClick then
							requestClose()
						end
					end,
				},
			}, React.createElement("canvasgroup", {
				key = "ModalPanel",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				GroupTransparency = panelTransparency,
				ZIndex = 2,
			}, not props.draggable and (React.createElement("uilistlayout", {
				key = "CenterLayout",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			})), React.createElement(ModalCloseContext.Provider, {
				value = requestClose,
			}, if props.draggable then (React.createElement(Draggable, {
				placeholder = false,
				retainPosition = true,
			}, panel)) else panel))), overlay)
		end,
	})
end
return {
	Modal = Modal,
}
