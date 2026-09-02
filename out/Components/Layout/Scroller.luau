-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local SpacingHelper = _Helpers.SpacingHelper
local function Scroller(props)
	local theme = React.useContext(CleanThemeContext)
	local thickness = 12
	local isScrolling, setIsScrolling = React.useState(false)
	local ref = React.useRef()
	React.useEffect(function()
		local frame = ref.current
		if not frame then
			return nil
		end
		local updateScrolling = function()
			setIsScrolling(frame.AbsoluteCanvasSize.Y > frame.AbsoluteWindowSize.Y)
		end
		updateScrolling()
		local canvasConn = frame:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(updateScrolling)
		local windowConn = frame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(updateScrolling)
		return function()
			canvasConn:Disconnect()
			windowConn:Disconnect()
		end
	end, {})
	local spacing = SpacingHelper:GetPadding(theme, props.spacing)
	local _attributes = {}
	local _condition = props.name
	if _condition == nil then
		_condition = "Scroller"
	end
	_attributes.key = _condition
	_attributes.ref = ref
	_attributes.AnchorPoint = SizeHelper:GetAnchor(props)
	_attributes.AutomaticSize = SizeHelper:GetAutoSize(props, Enum.AutomaticSize.None)
	_attributes.Position = SizeHelper:GetPosition(props)
	_attributes.Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1))
	_attributes.BorderSizePixel = 0
	_attributes.ScrollingDirection = Enum.ScrollingDirection.Y
	_attributes.ScrollBarImageColor3 = theme.components.scroller.barColor
	_attributes.CanvasSize = UDim2.fromScale(1, 0)
	_attributes.BackgroundTransparency = 1
	_attributes.ScrollBarThickness = thickness
	_attributes.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	_attributes.AutomaticCanvasSize = Enum.AutomaticSize.Y
	return React.createElement("scrollingframe", _attributes, props.AutomaticSizeParent and React.createElement("uilistlayout", {
		key = "AutomaticSizeLayout",
		FillDirection = Enum.FillDirection.Horizontal,
	}), React.createElement("frame", {
		key = "ScrollerContent",
		Size = UDim2.new(1, if isScrolling then -thickness - spacing else 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, props.children))
end
return {
	Scroller = Scroller,
}
