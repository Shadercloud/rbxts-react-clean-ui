-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local React = TS.import(script, TS.getModule(script, "@rbxts", "react"))
local CleanThemeContext = TS.import(script, script.Parent.Parent.Parent, "Contexts").CleanThemeContext
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
	-- Roblox text instances have no native letter-spacing property, so a nonzero
	-- value is faked by splitting the text into one TextLabel per character laid
	-- out in a UIListLayout row with the spacing as its Padding. This only makes
	-- sense for short, single-line, plain text: RichText is forced off per-character
	-- (markup tags can't survive being split apart), and wrapping/truncation are
	-- moot since each character label auto-sizes to itself and never overflows.
	if letterSpacing ~= nil and letterSpacing ~= 0 and props.text ~= "" then
		local characters = {}
		for index = 0, #props.text - 1 do
			local _text = props.text
			local _arg0 = index + 1
			local _arg1 = index + 1
			local _arg0_1 = string.sub(_text, _arg0, _arg1)
			table.insert(characters, _arg0_1)
		end
		local _attributes = {}
		local _condition_1 = props.name
		if _condition_1 == nil then
			_condition_1 = "Text"
		end
		_attributes.key = _condition_1
		_attributes.Size = UDim2.fromScale(0, 0)
		_attributes.AutomaticSize = Enum.AutomaticSize.XY
		_attributes.AnchorPoint = props.AnchorPoint
		_attributes.BackgroundTransparency = 1
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
				TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor,
				Text = character,
			}
			local _condition_2 = props.LineHeight
			if _condition_2 == nil then
				_condition_2 = style.lineHeight
			end
			_attributes_1.LineHeight = _condition_2
			_attributes_1.FontFace = Font.fromName(style.font.Name, weight)
			_attributes_1.FontSize = style.size
			_attributes_1.RichText = false
			local _condition_3 = props.TextScaled
			if _condition_3 == nil then
				_condition_3 = false
			end
			_attributes_1.TextScaled = _condition_3
			_attributes_1.TextStrokeColor3 = props.TextStrokeColor3
			_attributes_1.TextStrokeTransparency = props.TextStrokeTransparency
			_attributes_1.TextTransparency = props.TextTransparency
			return React.createElement("textlabel", _attributes_1)
		end
		for _k, _v in characters do
			_newValue[_k] = _callback(_v, _k - 1, characters)
		end
		-- ▲ ReadonlyArray.map ▲
		return React.createElement("frame", _attributes, _exp, _newValue)
	end
	local _attributes = {}
	local _condition_1 = props.name
	if _condition_1 == nil then
		_condition_1 = "Text"
	end
	_attributes.key = _condition_1
	_attributes.ref = ref
	_attributes.Size = UDim2.fromScale(0, 0)
	_attributes.AutomaticSize = Enum.AutomaticSize.XY
	_attributes.AnchorPoint = props.AnchorPoint
	local _condition_2 = props.LineHeight
	if _condition_2 == nil then
		_condition_2 = style.lineHeight
	end
	_attributes.LineHeight = _condition_2
	local _condition_3 = props.BackgroundTransparency
	if _condition_3 == nil then
		_condition_3 = 1
	end
	_attributes.BackgroundTransparency = _condition_3
	_attributes.TextXAlignment = props.align or (props.TextXAlignment or Enum.TextXAlignment.Left)
	_attributes.TextColor3 = props.TextColor3 or theme.colors.intents.primary.default.textColor
	_attributes.Text = props.text
	_attributes.Position = props.Position
	_attributes.TextWrap = textwrapped
	_attributes.TextWrapped = textwrapped
	_attributes.FontFace = Font.fromName(style.font.Name, weight)
	_attributes.FontSize = style.size
	local _condition_4 = props.RichText
	if _condition_4 == nil then
		_condition_4 = true
	end
	_attributes.RichText = _condition_4
	local _condition_5 = props.TextScaled
	if _condition_5 == nil then
		_condition_5 = false
	end
	_attributes.TextScaled = _condition_5
	_attributes.ZIndex = props.ZIndex
	_attributes.LayoutOrder = props.LayoutOrder
	_attributes.Visible = props.Visible
	_attributes.Rotation = props.Rotation
	_attributes.Active = props.Active
	_attributes.Archivable = props.Archivable
	_attributes.BackgroundColor3 = props.BackgroundColor3
	_attributes.BorderColor3 = props.BorderColor3
	_attributes.BorderMode = props.BorderMode
	_attributes.BorderSizePixel = props.BorderSizePixel
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
	return React.createElement("textlabel", _attributes, props.children)
end)
return {
	Text = Text,
}
