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
	return React.createElement("scrollingframe", {
		ref = ref,
		AnchorPoint = SizeHelper:GetAnchor(props),
		AutomaticSize = SizeHelper:GetAutoSize(props, Enum.AutomaticSize.None),
		Position = SizeHelper:GetPosition(props),
		Size = SizeHelper:GetSize(props, UDim2.fromScale(1, 1)),
		BorderSizePixel = 0,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarImageColor3 = theme.components.scroller.barColor,
		CanvasSize = UDim2.fromScale(1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = thickness,
		VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
	}, React.createElement("uilistlayout", {
		FillDirection = Enum.FillDirection.Horizontal,
	}), React.createElement("frame", {
		Size = UDim2.new(1, if isScrolling then -thickness - spacing else 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
	}, props.children))
end
return {
	Scroller = Scroller,
}
