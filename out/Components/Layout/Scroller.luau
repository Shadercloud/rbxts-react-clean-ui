-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local Scroller = React.forwardRef(function(props, forwardedRef)
	local theme = React.useContext(CleanThemeContext)
	local scrollerTheme = theme.components.scroller
	local thickness = 12
	local isScrolling, setIsScrolling = React.useState(false)
	local ref = React.useRef()
	local thumbRef = React.useRef()
	local propsRef = React.useRef(props)
	propsRef.current = props
	local hasTrack = scrollerTheme.trackColor ~= nil
	local _condition = scrollerTheme.thumbBorderThickness
	if _condition == nil then
		_condition = 0
	end
	local thumbBorderThickness = _condition
	local hasCustomThumb = thumbBorderThickness > 0
	local sizeConstraint = SizeHelper:GetSizeConstraint(props)
	local decorated = hasTrack or hasCustomThumb or sizeConstraint ~= nil
	local setFrame = React.useCallback(function(instance)
		ref.current = instance
		local _forwardedRef = forwardedRef
		if type(_forwardedRef) == "function" then
			forwardedRef(instance)
		elseif forwardedRef ~= nil then
			forwardedRef.current = instance
		end
	end, { forwardedRef })
	React.useEffect(function()
		local frame = ref.current
		if not frame then
			return nil
		end
		local nearEndArmed = true
		local lastCanvasHeight = 0
		local updateThumb = function()
			local thumb = thumbRef.current
			if not thumb then
				return nil
			end
			local windowHeight = frame.AbsoluteWindowSize.Y
			local canvasHeight = frame.AbsoluteCanvasSize.Y
			local maxScroll = canvasHeight - windowHeight
			if maxScroll <= 0 or windowHeight <= 0 then
				thumb.Visible = false
				return nil
			end
			local length = math.min(windowHeight, math.max(thickness, (windowHeight * windowHeight) / canvasHeight))
			local progress = math.clamp(frame.CanvasPosition.Y / maxScroll, 0, 1)
			thumb.Size = UDim2.new(0, thickness, 0, length)
			thumb.Position = UDim2.new(1, -thickness, 0, progress * (windowHeight - length))
			thumb.Visible = true
		end
		local updateNearEnd = function()
			local onNearEnd = propsRef.current.onNearEnd
			if onNearEnd == nil then
				return nil
			end
			local canvasHeight = frame.AbsoluteCanvasSize.Y
			if canvasHeight > lastCanvasHeight then
				nearEndArmed = true
			end
			lastCanvasHeight = canvasHeight
			local distance = canvasHeight - frame.AbsoluteWindowSize.Y - frame.CanvasPosition.Y
			local _condition_1 = propsRef.current.nearEndThreshold
			if _condition_1 == nil then
				_condition_1 = 0
			end
			local threshold = math.max(0, _condition_1)
			if distance <= threshold then
				if nearEndArmed then
					nearEndArmed = false
					onNearEnd()
				end
			else
				nearEndArmed = true
			end
		end
		local updateScrolling = function()
			setIsScrolling(frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y)
			updateThumb()
			updateNearEnd()
		end
		local updatePosition = function()
			updateThumb()
			local _result = propsRef.current.onScroll
			if _result ~= nil then
				_result(frame.CanvasPosition, frame)
			end
			updateNearEnd()
		end
		updateScrolling()
		local canvasConn = frame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateScrolling)
		local windowConn = frame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateScrolling)
		local positionConn = frame:GetPropertyChangedSignal("CanvasPosition"):Connect(updatePosition)
		return function()
			canvasConn:Disconnect()
			windowConn:Disconnect()
			positionConn:Disconnect()
		end
	end, { decorated, hasCustomThumb })
	local spacing = SpacingHelper:GetPadding(theme, props.spacing)
	local reserveGutter = props.stableGutter == true or isScrolling
	local _attributes = {}
	local _result
	if decorated then
		_result = "ScrollingFrame"
	else
		local _condition_1 = props.name
		if _condition_1 == nil then
			_condition_1 = "Scroller"
		end
		_result = _condition_1
	end
	_attributes.key = _result
	_attributes.ref = setFrame
	_attributes.AnchorPoint = if decorated then nil else SizeHelper:GetAnchor(props)
	_attributes.AutomaticSize = if decorated then nil else SizeHelper:GetAutoSize(props, Enum.AutomaticSize.None)
	_attributes.Position = if decorated then nil else SizeHelper:GetPosition(props)
	_attributes.Size = if decorated then UDim2.fromScale(1, 1) else SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes.ZIndex = if decorated then 2 else nil
	_attributes.BorderSizePixel = 0
	_attributes.ScrollingDirection = Enum.ScrollingDirection.Y
	_attributes.ScrollBarImageColor3 = scrollerTheme.barColor
	_attributes.ScrollBarImageTransparency = if hasCustomThumb then 1 else nil
	_attributes.CanvasSize = UDim2.fromScale(1, 0)
	_attributes.BackgroundTransparency = 1
	_attributes.ScrollBarThickness = thickness
	_attributes.VerticalScrollBarInset = if props.stableGutter == true then Enum.ScrollBarInset.Always else Enum.ScrollBarInset.ScrollBar
	_attributes.AutomaticCanvasSize = Enum.AutomaticSize.Y
	local scrollingFrame = (React.createElement("scrollingframe", _attributes, props.AutomaticSizeParent and React.createElement("uilistlayout", {
		key = "AutomaticSizeLayout",
		FillDirection = Enum.FillDirection.Horizontal,
	}), React.createElement("frame", {
		key = "ScrollerContent",
		Size = UDim2.new(1, if reserveGutter then -thickness - spacing else 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, props.children)))
	if not decorated then
		return scrollingFrame
	end
	local _attributes_1 = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Scroller"
	end
	_attributes_1.key = _condition_1
	_attributes_1.AnchorPoint = SizeHelper:GetAnchor(props)
	_attributes_1.AutomaticSize = SizeHelper:GetAutoSize(props, Enum.AutomaticSize.None)
	_attributes_1.Position = SizeHelper:GetPosition(props)
	_attributes_1.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes_1.BackgroundTransparency = 1
	_attributes_1.BorderSizePixel = 0
	local _exp = sizeConstraint ~= nil and (React.createElement("uisizeconstraint", {
		key = "SizeConstraint",
		MinSize = sizeConstraint.MinSize,
		MaxSize = sizeConstraint.MaxSize,
	}))
	local _condition_2 = hasTrack
	if _condition_2 then
		local _attributes_2 = {
			key = "ScrollerTrack",
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.fromScale(1, 0),
			Size = UDim2.new(0, thickness, 1, 0),
			ZIndex = 1,
			Visible = isScrolling,
			Active = false,
			BackgroundColor3 = scrollerTheme.trackColor,
		}
		local _condition_3 = scrollerTheme.trackTransparency
		if _condition_3 == nil then
			_condition_3 = 0
		end
		_attributes_2.BackgroundTransparency = _condition_3
		_attributes_2.BorderSizePixel = 0
		_condition_2 = (React.createElement("frame", _attributes_2))
	end
	return React.createElement("frame", _attributes_1, _exp, _condition_2, scrollingFrame, hasCustomThumb and (React.createElement("frame", {
		key = "ScrollerThumb",
		ref = thumbRef,
		ZIndex = 3,
		Active = false,
		BackgroundColor3 = scrollerTheme.barColor,
		BorderSizePixel = 0,
	}, React.createElement("uistroke", {
		key = "ThumbBorder",
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
		Thickness = thumbBorderThickness,
		Color = scrollerTheme.thumbBorderColor,
	}))))
end)
return {
	Scroller = Scroller,
}
