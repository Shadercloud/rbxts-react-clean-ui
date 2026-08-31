-- Compiled with roblox-ts v3.0.0
local CHARACTER_ALLOW_LIST_PATTERNS = {
	Telephone = "^[%d%+%-%s%(%)]*$",
	Alphanumeric = "^[%w]*$",
	Email = "^[%w@%._%-+]*$",
}
local function resolveValidatedText(validation, candidateText, lastValidText)
	local number = tonumber(candidateText)
	if (validation == "Number" or validation == "Int") and number == nil and candidateText ~= "" and candidateText ~= "-" then
		return lastValidText
	end
	local allowedPattern = CHARACTER_ALLOW_LIST_PATTERNS[validation or "None"]
	if allowedPattern ~= nil and (string.match(candidateText, allowedPattern)) == nil then
		return lastValidText
	end
	return candidateText
end
local function resolveClampedText(validation, text, min, max)
	if validation ~= "Number" and validation ~= "Int" then
		return nil
	end
	local number = tonumber(text)
	if number == nil then
		return nil
	end
	local clamped = number
	if min ~= nil and clamped < min then
		clamped = min
	end
	if max ~= nil and clamped > max then
		clamped = max
	end
	if clamped == number then
		return nil
	end
	return tostring(clamped)
end
return {
	resolveValidatedText = resolveValidatedText,
	resolveClampedText = resolveClampedText,
	CHARACTER_ALLOW_LIST_PATTERNS = CHARACTER_ALLOW_LIST_PATTERNS,
}
