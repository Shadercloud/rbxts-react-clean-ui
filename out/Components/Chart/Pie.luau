-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _react = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local React = _react
local useState = _react.useState
local GuiService = TS.import(script, TS.getModule(script, "@rbxts", "services")).GuiService
local _Decorator = TS.import(script, script.Parent.Parent, "Decorator")
local BoxShadow = _Decorator.BoxShadow
local Corners = _Decorator.Corners
local Padding = _Decorator.Padding
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local Text = TS.import(script, script.Parent.Parent, "Typography").Text
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local CssHelper = _Helpers.CssHelper
local SpacingHelper = _Helpers.SpacingHelper
local TypographyHelper = _Helpers.TypographyHelper
local function Segment(props)
	local sizeX = if props.section == "Left" or props.section == "Right" then 0.5 else 1
	local sizeY = if props.section == "Left" or props.section == "Right" then 1 else 0.5
	local anchor = Vector2.new(1, 0.5)
	local zeroed = 0
	if props.section == "Right" then
		zeroed = 180
		anchor = Vector2.new(0, 0.5)
	elseif props.section == "Top" then
		zeroed = 90
		anchor = Vector2.new(0.5, 1)
	elseif props.section == "Bottom" then
		zeroed = 270
		anchor = Vector2.new(0.5, 0)
	end
	return React.createElement("frame", {
		Size = UDim2.fromScale(sizeX, sizeY),
		AnchorPoint = anchor,
		Position = UDim2.fromScale(0.5, 0.5),
		ClipsDescendants = true,
		BorderSizePixel = 0,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromHex("#FFFFFF"),
	}, React.createElement("frame", {
		BackgroundColor3 = props.color,
		Size = UDim2.fromScale(if sizeX == 1 then 1 else 2, if sizeY == 1 then 1 else 2),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		Position = UDim2.fromScale(anchor.X, anchor.Y),
	}, React.createElement("uicorner", {
		CornerRadius = UDim.new(0.5, 0),
	}), React.createElement("uigradient", {
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.4999, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 0) }),
		Rotation = zeroed + props.fill * 180,
	})))
end
local function getCirclePosition(normalized, radius)
	if radius == nil then
		radius = 0.3
	end
	local centerX = 0.5
	local centerY = 0.5
	-- Convert 0 → 1 into radians (0 → 2π)
	local angle = normalized * math.pi * 2 + math.pi
	local x = centerX + math.cos(angle) * radius
	local y = centerY + math.sin(angle) * radius
	return UDim2.fromScale(x, y)
end
local function Pie(props)
	local theme = React.useContext(CleanThemeContext)
	local state, setState = useState({
		hover = -1,
	})
	local changeHover = function(index)
		if state.hover == index then
			return nil
		end
		setState({
			hover = index,
		})
		local _result = props.onChangeSelected
		if _result ~= nil then
			_result(index, if index >= 0 then props.values[index + 1] else nil)
		end
	end
	local segments = {}
	local labels = {}
	local _exp = props.values
	-- ▼ ReadonlyArray.reduce ▼
	local _result = 0
	local _callback = function(sum, obj)
		return sum + obj.value
	end
	for _i = 1, #_exp do
		_result = _callback(_result, _exp[_i], _i - 1, _exp)
	end
	-- ▲ ReadonlyArray.reduce ▲
	local totalValue = _result
	local section = "Top"
	local sectionRemaining = 1
	local totalPercent = 0
	local _exp_1 = props.values
	-- ▼ ReadonlyArray.forEach ▼
	local _callback_1 = function(v, index)
		local percent = v.value / totalValue
		totalPercent += (percent / 2)
		local fill = percent * 2
		local color = v.color or theme.components.pie.colors[index % #theme.components.pie.colors + 1]
		if index == state.hover then
			local _condition = props["hover-darken"]
			if _condition == nil then
				_condition = 0.2
			end
			local d = _condition
			color = color:Lerp((if d < 0 then Color3.new(1, 1, 1) else Color3.new(0, 0, 0)), math.abs(d))
		end
		local _arg0 = React.createElement(Segment, {
			section = section,
			color = color,
			fill = -sectionRemaining,
		})
		table.insert(segments, _arg0)
		sectionRemaining -= fill
		if sectionRemaining <= 0 then
			section = "Bottom"
			if sectionRemaining < 0 then
				local _arg0_1 = React.createElement(Segment, {
					section = section,
					color = color,
					fill = -sectionRemaining,
				})
				table.insert(segments, _arg0_1)
			end
			sectionRemaining = 1 + sectionRemaining
		end
		local _condition = not props["Label-hidden"]
		if _condition then
			_condition = v.label
			if _condition ~= "" and _condition then
				_condition = (not props["label-hover"] or state.hover == index)
			end
		end
		if _condition ~= "" and _condition then
			local label = v.label
			local isTextLabel = type(label) == "string" or label.text ~= nil
			local position = if #props.values == 1 then UDim2.fromScale(0.5, 0.5) else getCirclePosition(totalPercent, props["label-distance"])
			if isTextLabel then
				local text = if type(label) == "string" then label else (label.text)
				local spacing = if type(label) == "string" then props["label-spacing"] else label.spacing
				local background = if not (type(label) == "string") and label.BackgroundColor3 ~= nil then label.BackgroundColor3 else theme.components.pie.labels.backgroundColor or theme.components.box.backgroundColor
				local border = if not (type(label) == "string") and label.BorderColor3 ~= nil then label.BorderColor3 else theme.components.pie.labels.borderColor or theme.components.box.borderColor
				local _attributes = {
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = position,
					BackgroundColor3 = background,
				}
				local _condition_1 = theme.components.pie.labels.backgroundTransparency
				if _condition_1 == nil then
					_condition_1 = theme.components.box.backgroundTransparency
				end
				_attributes.BackgroundTransparency = _condition_1
				local _exp_2 = React.createElement(Text, {
					text = text,
					typography = TypographyHelper:getTypography(theme, "md", theme.components.pie.labels.typography),
				})
				local _attributes_1 = {}
				local _condition_2 = theme.components.pie.labels.cornerRadius
				if _condition_2 == nil then
					_condition_2 = theme.components.box.cornerRadius
				end
				_attributes_1.radius = _condition_2
				local _exp_3 = React.createElement(Corners, _attributes_1)
				local _attributes_2 = {}
				local _condition_3 = theme.components.pie.labels.borderThickness
				if _condition_3 == nil then
					_condition_3 = theme.components.box.borderThickness
				end
				_attributes_2.Thickness = _condition_3
				_attributes_2.BorderStrokePosition = Enum.BorderStrokePosition.Inner
				_attributes_2.Color = border
				local _arg0_1 = React.createElement("frame", _attributes, _exp_2, _exp_3, React.createElement("uistroke", _attributes_2), React.createElement(Padding, {
					resolvedPadding = SpacingHelper:ResolveNumberPadding(SpacingHelper:GetPadding(theme, spacing, theme.components.pie.labels.spacing)),
				}), React.createElement(BoxShadow))
				table.insert(labels, _arg0_1)
			elseif label.content ~= nil then
				local _arg0_1 = React.createElement("frame", {
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = position,
					BackgroundTransparency = 1,
				}, label.content)
				table.insert(labels, _arg0_1)
			end
		end
		totalPercent += (percent / 2)
	end
	for _k, _v in _exp_1 do
		_callback_1(_v, _k - 1, _exp_1)
	end
	-- ▲ ReadonlyArray.forEach ▲
	local shadowPadding
	if theme.components.pie.boxShadow ~= nil then
		local shadowParsed = CssHelper:parseCssShadow(theme.components.pie.boxShadow.shadow)
		if shadowParsed ~= nil then
			local shadowValue = shadowParsed.spread.X.Offset + shadowParsed.blurRadius.Offset
			if shadowValue > 0 then
				local resolvedPadding = SpacingHelper:ResolveNumberPadding(shadowValue)
				resolvedPadding.left = math.max(0, resolvedPadding.left - shadowParsed.offset.X.Offset)
				resolvedPadding.right += shadowParsed.offset.X.Offset
				resolvedPadding.top = math.max(0, resolvedPadding.top - shadowParsed.offset.Y.Offset)
				resolvedPadding.bottom += shadowParsed.offset.Y.Offset
				shadowPadding = React.createElement(Padding, {
					resolvedPadding = resolvedPadding,
				})
			end
		end
	end
	return React.createElement("canvasgroup", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
	}, shadowPadding, React.createElement("frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Event = {
			MouseLeave = function()
				changeHover(-1)
			end,
			InputEnded = function(rbx, input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
					return nil
				end
				if state.hover < 0 then
					return nil
				end
				local _result_1 = props.onClick
				if _result_1 ~= nil then
					_result_1(state.hover, props.values[state.hover + 1])
				end
			end,
			MouseMoved = function(rbx, x, y)
				local offset = GuiService:GetGuiInset()
				local localX = x - rbx.AbsolutePosition.X
				local localY = y - rbx.AbsolutePosition.Y - offset.Y
				local width = rbx.AbsoluteSize.X
				local height = rbx.AbsoluteSize.Y
				local centerX = width / 2
				local centerY = height / 2
				local dx = localX - centerX
				local dy = localY - centerY
				local radius = math.min(width, height) / 2
				local distance = math.sqrt(dx * dx + dy * dy)
				if distance > radius then
					changeHover(-1)
					return nil
				end
				local angle = math.atan2(dy, dx)
				if angle < 0 then
					angle += math.pi * 2
				end
				local normalized = angle / (math.pi * 2)
				normalized = (normalized + 0.5) % 1
				local running = 0
				for i = 0, #props.values - 1 do
					local percent = props.values[i + 1].value / totalValue
					if normalized >= running and normalized <= running + percent then
						changeHover(i)
						return nil
					end
					running += percent
				end
				changeHover(-1)
			end,
		},
	}, segments, labels, theme.components.pie.boxShadow ~= nil and React.createElement(BoxShadow, {
		completeShadow = theme.components.pie.boxShadow,
	}), React.createElement("uicorner", {
		CornerRadius = UDim.new(1, 0),
	})))
end
return {
	Pie = Pie,
}
