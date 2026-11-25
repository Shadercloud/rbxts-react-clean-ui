-- Compiled with roblox-ts v3.0.0
local utf8Length = utf8.len
local utf8Offset = utf8.offset
local TEXTAREA_DEFAULT_ROWS = 4
local function finiteOrZero(value)
	return if value == value and value ~= math.huge and value ~= -math.huge then value else 0
end
local function resolveTextareaHeight(height, rows, lineHeight, paddingTop, paddingBottom)
	if height ~= nil then
		return math.max(0, height)
	end
	local lines = math.max(1, math.floor(finiteOrZero(rows)))
	return lines * math.max(0, lineHeight) + paddingTop + paddingBottom
end
local function resolveTextareaScreenScale(screenHeight, designHeight, fallback)
	if screenHeight > 0 and designHeight > 0 then
		return screenHeight / designHeight
	end
	return if fallback > 0 then fallback else 1
end
local function resolveTextareaCanvasHeight(textHeight, paddingTop, paddingBottom, viewportHeight)
	if viewportHeight == nil then
		viewportHeight = 0
	end
	return math.max(math.max(0, finiteOrZero(textHeight)) + paddingTop + paddingBottom, viewportHeight)
end
local function resolveTextareaWrapWidth(fieldWidth, paddingLeft, paddingRight, gutter)
	return math.max(0, fieldWidth - paddingLeft - paddingRight - math.max(0, gutter))
end
local function resolveTextareaCaretScroll(caretTop, caretBottom, canvasY, viewportHeight)
	if caretBottom > canvasY + viewportHeight then
		return math.max(0, math.min(caretTop, caretBottom - viewportHeight))
	end
	if caretTop < canvasY then
		return math.max(0, caretTop)
	end
	return canvasY
end
local function resolveTextareaCaretText(text, cursorPosition)
	if cursorPosition < 1 then
		return nil
	end
	local _text = text
	local _arg1 = math.min(cursorPosition, #text + 1) - 1
	local prefix = string.sub(_text, 1, _arg1)
	if prefix == "" or string.sub(prefix, -1) == "\n" then
		return `{prefix} `
	end
	return prefix
end
local function resolveTextareaLength(text)
	local length = utf8Length(text)
	return if type(length) == "number" then length else #text
end
local function trimTextareaText(text, maxLength)
	if maxLength == nil then
		return text
	end
	local limit = math.max(0, math.floor(finiteOrZero(maxLength)))
	local length = utf8Length(text)
	if not (type(length) == "number") then
		return if #text > limit then string.sub(text, 1, limit) else text
	end
	if length <= limit then
		return text
	end
	local offset = utf8Offset(text, limit + 1)
	local _result
	if type(offset) == "number" then
		local _text = text
		local _arg1 = offset - 1
		_result = string.sub(_text, 1, _arg1)
	else
		_result = text
	end
	return _result
end
local function groupDigits(value)
	local digits = tostring(math.max(0, math.floor(finiteOrZero(value))))
	local result = ""
	local count = 0
	for index = #digits, 1, -1 do
		local _index = index
		local _index_1 = index
		result = string.sub(digits, _index, _index_1) .. result
		count += 1
		if count % 3 == 0 and index > 1 then
			result = `,{result}`
		end
	end
	return result
end
local function formatTextareaCount(length, maxLength)
	if maxLength == nil then
		return groupDigits(length)
	end
	return `{groupDigits(length)} / {groupDigits(maxLength)}`
end
return {
	resolveTextareaHeight = resolveTextareaHeight,
	resolveTextareaScreenScale = resolveTextareaScreenScale,
	resolveTextareaCanvasHeight = resolveTextareaCanvasHeight,
	resolveTextareaWrapWidth = resolveTextareaWrapWidth,
	resolveTextareaCaretScroll = resolveTextareaCaretScroll,
	resolveTextareaCaretText = resolveTextareaCaretText,
	resolveTextareaLength = resolveTextareaLength,
	trimTextareaText = trimTextareaText,
	formatTextareaCount = formatTextareaCount,
	TEXTAREA_DEFAULT_ROWS = TEXTAREA_DEFAULT_ROWS,
}
