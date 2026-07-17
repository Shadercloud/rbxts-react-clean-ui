-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local SizeHelper = TS.import(script, script.Parent.Parent.Parent, "Helpers").SizeHelper
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
	local _attributes = {}
	local _result
	if isScrolling then
		local _exp = -thickness
		local _condition = theme.spacing[theme.default.spacing]
		if _condition == nil then
			_condition = 0
		end
		_result = _exp - _condition
	else
		_result = 0
	end
	_attributes.Size = UDim2.new(1, _result, 0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.Y
	_attributes.BackgroundTransparency = 1
	return React.createElement("scrollingframe", {
		ref = ref,
		AutomaticSize = SizeHelper:GetAutoSize(props, Enum.AutomaticSize.None),
		Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1)),
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageColor3 = theme.components.scroller.barColor,
		CanvasSize = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = thickness,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, React.createElement("frame", _attributes, props.children))
end
return {
	Scroller = Scroller,
}
