-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
local _Helpers = TS.import(script, script.Parent.Parent.Parent, "Helpers")
local SizeHelper = _Helpers.SizeHelper
local TypographyHelper = _Helpers.TypographyHelper
local SHRINK_SEARCH_STEPS = 24
local SHRINK_FILL_TOLERANCE = 0.5
local SHRINK_SCALE_PRECISION = 0.001
local function getContentWidth(parent)
	local width = parent.AbsoluteSize.X
	local padding = parent:FindFirstChildWhichIsA("UIPadding")
	if padding == nil then
		return width
	end
	return width - padding.PaddingLeft.Scale * width - padding.PaddingLeft.Offset - padding.PaddingRight.Scale * width - padding.PaddingRight.Offset
end
local Text = React.forwardRef(function(props, ref)
	local theme = React.useContext(CleanThemeContext)
	local style = props.typography or theme.typography[props.variant or "body"]
	local weight = if props.weight == "bold" then Enum.FontWeight.Bold else props.weight or style.weight or Enum.FontWeight.Regular
	local textwrapped = props.TextWrap ~= false and props.TextWrapped ~= false
	local _condition = props.letterSpacing
	if _condition == nil then
		_condition = style.letterSpacing
	end
	local letterSpacing = _condition
	local letterSpaced = letterSpacing ~= nil and letterSpacing ~= 0 and props.text ~= ""
	local rootRef = React.useRef()
	local shrinkScale, setShrinkScale = React.useBinding(1)
	local setLabel = React.useCallback(function(instance)
		rootRef.current = instance
		local _ref = ref
		if type(_ref) == "function" then
			ref(instance)
		elseif ref ~= nil then
			ref.current = instance
		end
	end, { ref })
	local setFrame = React.useCallback(function(instance)
		rootRef.current = instance
	end, {})
	local shrinkToFit = props.shrinkToFit == true
	local _condition_1 = props.shrinkMinScale
	if _condition_1 == nil then
		_condition_1 = 0
	end
	local shrinkMinScale = math.clamp(_condition_1, 0, 1)
	local shrinkWidth = if shrinkToFit and props.maxWidth ~= nil then SizeHelper:toUDim(props.maxWidth).Offset else nil
	React.useEffect(function()
		local root = rootRef.current
		if not shrinkToFit or root == nil then
			setShrinkScale(1)
			return nil
		end
		local parentConnection
		local searching = false
		local settledAvailable
		local settledScale
		local settledWidth
		local update = function()
			if searching then
				return nil
			end
			local parent = root.Parent
			local _condition_2 = shrinkWidth
			if _condition_2 == nil then
				_condition_2 = (if parent ~= nil and parent:IsA("GuiBase2d") then getContentWidth(parent) else nil)
			end
			local available = _condition_2
			local scale = shrinkScale:getValue()
			local width = root.AbsoluteSize.X
			if width <= 0 or available == nil or available <= 0 then
				return nil
			end
			if available == settledAvailable and scale == settledScale and width == settledWidth then
				return nil
			end
			searching = true
			local fitScale
			local overflowScale
			for step = 0, SHRINK_SEARCH_STEPS - 1 do
				local fits = width <= available
				if fits then
					fitScale = if fitScale == nil then scale else math.max(fitScale, scale)
					if scale >= 1 or available - width <= SHRINK_FILL_TOLERANCE then
						break
					end
				else
					overflowScale = if overflowScale == nil then scale else math.min(overflowScale, scale)
					if scale <= shrinkMinScale then
						break
					end
				end
				local nextScale = if width > 0 then math.clamp(scale * available / width, shrinkMinScale, 1) else 1
				local _condition_3 = fitScale
				if _condition_3 == nil then
					_condition_3 = shrinkMinScale
				end
				local low = _condition_3
				local _condition_4 = overflowScale
				if _condition_4 == nil then
					_condition_4 = 1
				end
				local high = _condition_4
				if (fitScale ~= nil and nextScale <= fitScale) or (overflowScale ~= nil and nextScale >= overflowScale) then
					nextScale = (low + high) / 2
				end
				if fitScale ~= nil and overflowScale ~= nil and overflowScale - fitScale <= SHRINK_SCALE_PRECISION then
					break
				end
				if math.abs(nextScale - scale) <= SHRINK_SCALE_PRECISION / 10 then
					break
				end
				scale = nextScale
				setShrinkScale(scale)
				width = root.AbsoluteSize.X
			end
			if width > available and fitScale ~= nil and fitScale ~= scale then
				scale = fitScale
				setShrinkScale(scale)
				width = root.AbsoluteSize.X
			end
			settledAvailable = available
			settledScale = scale
			settledWidth = width
			searching = false
		end
		local bindParent = function()
			local _result = parentConnection
			if _result ~= nil then
				_result:Disconnect()
			end
			parentConnection = nil
			local parent = root.Parent
			if shrinkWidth == nil and parent ~= nil and parent:IsA("GuiBase2d") then
				parentConnection = parent:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
			end
			update()
		end
		bindParent()
		local sizeConnection = root:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
		local ancestryConnection = root.AncestryChanged:Connect(bindParent)
		return function()
			sizeConnection:Disconnect()
			ancestryConnection:Disconnect()
			local _result = parentConnection
			if _result ~= nil then
				_result:Disconnect()
			end
		end
	end, { shrinkToFit, letterSpaced, shrinkWidth, shrinkMinScale })
	local sizeConstraint = SizeHelper:GetSizeConstraint({
		minWidth = props.minWidth,
		maxWidth = if shrinkToFit then nil else props.maxWidth,
		minHeight = props.minHeight,
		maxHeight = props.maxHeight,
	})
	local _outline = props.outline
	local outlineProp = if type(_outline) == "table" then props.outline else nil
	local hasOutline = props.outline ~= false and (props.outline ~= nil or style.outline ~= nil)
	local hasTextSizeConstraint = props.minTextSize ~= nil or props.maxTextSize ~= nil
	local _condition_2 = props.minTextSize
	if _condition_2 == nil then
		_condition_2 = 1
	end
	local minTextSize = math.clamp(_condition_2, 1, 100)
	local _condition_3 = props.maxTextSize
	if _condition_3 == nil then
		_condition_3 = 100
	end
	local maxTextSize = math.clamp(_condition_3, minTextSize, 100)
	local renderTextDecorations = function()
		local _condition_4 = hasOutline
		if _condition_4 then
			local _attributes = {
				key = "Outline",
				ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
			}
			local _result = outlineProp
			if _result ~= nil then
				_result = _result.color
			end
			local _condition_5 = _result
			if _condition_5 == nil then
				local _result_1 = style.outline
				if _result_1 ~= nil then
					_result_1 = _result_1.color
				end
				_condition_5 = _result_1
				if _condition_5 == nil then
					_condition_5 = Color3.new(0, 0, 0)
				end
			end
			_attributes.Color = _condition_5
			local _result_1 = outlineProp
			if _result_1 ~= nil then
				_result_1 = _result_1.thickness
			end
			local _condition_6 = _result_1
			if _condition_6 == nil then
				local _result_2 = style.outline
				if _result_2 ~= nil then
					_result_2 = _result_2.thickness
				end
				_condition_6 = _result_2
				if _condition_6 == nil then
					_condition_6 = 1
				end
			end
			_attributes.Thickness = _condition_6
			local _result_2 = outlineProp
			if _result_2 ~= nil then
				_result_2 = _result_2.transparency
			end
			local _condition_7 = _result_2
			if _condition_7 == nil then
				local _result_3 = style.outline
				if _result_3 ~= nil then
					_result_3 = _result_3.transparency
				end
				_condition_7 = _result_3
				if _condition_7 == nil then
					_condition_7 = 0
				end
			end
			_attributes.Transparency = _condition_7
			_condition_4 = (React.createElement("uistroke", _attributes))
		end
		return React.createElement(React.Fragment, nil, _condition_4, hasTextSizeConstraint and (React.createElement("uitextsizeconstraint", {
			key = "TextSizeConstraint",
			MinTextSize = minTextSize,
			MaxTextSize = maxTextSize,
		})))
	end
	local renderBoxDecorations = function()
		return React.createElement(React.Fragment, nil, sizeConstraint ~= nil and (React.createElement("uisizeconstraint", {
			key = "SizeConstraint",
			MinSize = sizeConstraint.MinSize,
			MaxSize = sizeConstraint.MaxSize,
		})), shrinkToFit and (React.createElement("uiscale", {
			key = "ShrinkScale",
			Scale = shrinkScale,
		})))
	end
	if letterSpacing ~= nil and letterSpaced then
		local characters = {}
		for index = 0, #props.text - 1 do
			local _text = props.text
			local _arg0 = index + 1
			local _arg1 = index + 1
			local _arg0_1 = string.sub(_text, _arg0, _arg1)
			table.insert(characters, _arg0_1)
		end
		local _attributes = {}
		local _condition_4 = props.name
		if _condition_4 == nil then
			_condition_4 = "Text"
		end
		_attributes.key = _condition_4
		_attributes.ref = setFrame
		_attributes.Size = UDim2.fromScale(0, 0)
		_attributes.AutomaticSize = Enum.AutomaticSize.XY
		_attributes.AnchorPoint = props.AnchorPoint
		_attributes.BackgroundTransparency = 1
		_attributes.BorderSizePixel = 0
		_attributes.Position = props.Position
		_attributes.ZIndex = props.ZIndex
		_attributes.LayoutOrder = props.LayoutOrder
		_attributes.Visible = props.Visible
		_attributes.Rotation = props.Rotation
		local _exp = React.createElement("uilistlayout", {
			key = "LetterSpacing",
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, letterSpacing),
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = props.align or Enum.HorizontalAlignment.Left,
		})
		-- ▼ ReadonlyArray.map ▼
		local _newValue = table.create(#characters)
		local _callback = function(character, index)
			local _attributes_1 = {
				key = index,
				LayoutOrder = index,
				Size = UDim2.fromScale(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor,
				Text = character,
			}
			local _condition_5 = props.LineHeight
			if _condition_5 == nil then
				_condition_5 = style.lineHeight
			end
			_attributes_1.LineHeight = _condition_5
			_attributes_1.FontFace = TypographyHelper:toFontFace(style.font, weight)
			_attributes_1.FontSize = style.size
			_attributes_1.RichText = false
			local _condition_6 = props.TextScaled
			if _condition_6 == nil then
				_condition_6 = false
			end
			_attributes_1.TextScaled = _condition_6
			_attributes_1.TextStrokeColor3 = props.TextStrokeColor3
			_attributes_1.TextStrokeTransparency = props.TextStrokeTransparency
			_attributes_1.TextTransparency = props.TextTransparency
			return React.createElement("textlabel", _attributes_1, renderTextDecorations())
		end
		for _k, _v in characters do
			_newValue[_k] = _callback(_v, _k - 1, characters)
		end
		-- ▲ ReadonlyArray.map ▲
		return React.createElement("frame", _attributes, _exp, _newValue, renderBoxDecorations())
	end
	local _attributes = {}
	local _condition_4 = props.name
	if _condition_4 == nil then
		_condition_4 = "Text"
	end
	_attributes.key = _condition_4
	_attributes.ref = setLabel
	_attributes.Size = props.Size or UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = props.AutomaticSize or Enum.AutomaticSize.XY
	_attributes.AnchorPoint = props.AnchorPoint
	local _condition_5 = props.LineHeight
	if _condition_5 == nil then
		_condition_5 = style.lineHeight
	end
	_attributes.LineHeight = _condition_5
	local _condition_6 = props.BackgroundTransparency
	if _condition_6 == nil then
		_condition_6 = 1
	end
	_attributes.BackgroundTransparency = _condition_6
	_attributes.TextXAlignment = props.align or (props.TextXAlignment or Enum.TextXAlignment.Left)
	_attributes.TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor
	_attributes.Text = props.text
	_attributes.Position = props.Position
	_attributes.TextWrap = textwrapped
	_attributes.TextWrapped = textwrapped
	_attributes.FontFace = TypographyHelper:toFontFace(style.font, weight)
	_attributes.FontSize = style.size
	local _condition_7 = props.RichText
	if _condition_7 == nil then
		_condition_7 = true
	end
	_attributes.RichText = _condition_7
	local _condition_8 = props.TextScaled
	if _condition_8 == nil then
		_condition_8 = false
	end
	_attributes.TextScaled = _condition_8
	_attributes.ZIndex = props.ZIndex
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Visible = props.Visible
	_attributes.Rotation = props.Rotation
	_attributes.Active = props.Active
	_attributes.Archivable = props.Archivable
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = if props.BorderSizePixel == nil then 0 else props.BorderSizePixel
	_attributes.ClipsDescendants = props.ClipsDescendants
	_attributes.Selectable = props.Selectable
	_attributes.SelectionImageObject = props.SelectionImageObject
	_attributes.SizeConstraint = props.SizeConstraint
	_attributes.Tag = props.Tag
	_attributes.AutoLocalize = props.AutoLocalize
	_attributes.RootLocalizationTable = props.RootLocalizationTable
	_attributes.NextSelectionDown = props.NextSelectionDown
	_attributes.NextSelectionLeft = props.NextSelectionLeft
	_attributes.NextSelectionRight = props.NextSelectionRight
	_attributes.NextSelectionUp = props.NextSelectionUp
	_attributes.SelectionGroup = props.SelectionGroup
	_attributes.SelectionOrder = props.SelectionOrder
	_attributes.TextStrokeColor3 = props.TextStrokeColor3
	_attributes.TextStrokeTransparency = props.TextStrokeTransparency
	_attributes.TextTransparency = props.TextTransparency
	_attributes.TextTruncate = props.TextTruncate
	_attributes.Change = props.Change
	_attributes.Event = props.Event
	return React.createElement("textlabel", _attributes, renderTextDecorations(), renderBoxDecorations(), props.children)
end)
return {
	Text = Text,
}
