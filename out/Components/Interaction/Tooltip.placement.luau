-- Compiled with roblox-ts v3.0.0
local AUTO_ORDER = { "Top", "Bottom", "Right", "Left" }
local OPPOSITE = {
	Top = "Bottom",
	Bottom = "Top",
	Left = "Right",
	Right = "Left",
	Center = "Center",
}
local function pointerHeightOf(pointerSize)
	return (1.41421356 * pointerSize) / 2
end
local function getTooltipSafeArea(overlay, edgeMargin, topbarBottom)
	local left = edgeMargin
	local top = math.max(0, topbarBottom) + edgeMargin
	return {
		left = left,
		top = top,
		right = math.max(left, overlay.width - edgeMargin),
		bottom = math.max(top, overlay.height - edgeMargin),
	}
end
local function getTooltipPadding(side, pointerSize, shadow)
	local _object = table.clone(shadow)
	setmetatable(_object, nil)
	local padding = _object
	if side == "Center" or pointerSize <= 0 then
		return padding
	end
	local pointerHeight = math.floor(pointerHeightOf(pointerSize))
	repeat
		if side == "Top" then
			padding.bottom = math.max(pointerHeight, shadow.bottom)
			break
		end
		if side == "Bottom" then
			padding.top = math.max(pointerHeight, shadow.top)
			break
		end
		if side == "Left" then
			padding.right = math.max(pointerHeight, shadow.right)
			break
		end
		if side == "Right" then
			padding.left = math.max(pointerHeight, shadow.left)
			break
		end
	until true
	return padding
end
local function getPopupSize(side, input)
	local padding = getTooltipPadding(side, input.pointerSize, input.shadow)
	return {
		width = input.content.width + padding.left + padding.right,
		height = input.content.height + padding.top + padding.bottom,
	}
end
local function getSlack(side, input)
	local size = getPopupSize(side, input)
	local _binding = input
	local target = _binding.target
	local bounds = _binding.bounds
	repeat
		if side == "Top" then
			return target.top - bounds.top - size.height
		end
		if side == "Bottom" then
			return bounds.bottom - target.bottom - size.height
		end
		if side == "Left" then
			return target.left - bounds.left - size.width
		end
		if side == "Right" then
			return bounds.right - target.right - size.width
		end
	until true
	return 0
end
local function getShift(start, length, min, max)
	if length >= max - min or start < min then
		return min - start
	end
	if start + length > max then
		return max - (start + length)
	end
	return 0
end
local function getCrossShift(side, input)
	local size = getPopupSize(side, input)
	local _binding = input
	local target = _binding.target
	local bounds = _binding.bounds
	if side == "Top" or side == "Bottom" then
		local centerX = (target.left + target.right) / 2
		return math.abs(getShift(centerX - size.width / 2, size.width, bounds.left, bounds.right))
	end
	local centerY = (target.top + target.bottom) / 2
	return math.abs(getShift(centerY - size.height / 2, size.height, bounds.top, bounds.bottom))
end
local function resolveTooltipSide(input)
	local placement = input.placement or "Top"
	if placement == "Center" then
		return "Center"
	end
	if placement == "Auto" then
		local best = AUTO_ORDER[1]
		local bestFits = false
		local bestShift = math.huge
		local bestSlack = -math.huge
		for _, side in AUTO_ORDER do
			local slack = getSlack(side, input)
			local fits = slack >= 0
			local shift = getCrossShift(side, input)
			local better = if fits then not bestFits or shift < bestShift or (shift == bestShift and slack > bestSlack) else not bestFits and slack > bestSlack
			if better then
				best = side
				bestFits = fits
				bestShift = shift
				bestSlack = slack
			end
		end
		return best
	end
	local preferredSlack = getSlack(placement, input)
	if preferredSlack >= 0 then
		return placement
	end
	local opposite = OPPOSITE[placement]
	local oppositeSlack = getSlack(opposite, input)
	return if oppositeSlack >= 0 or oppositeSlack > preferredSlack then opposite else placement
end
local function clampPointer(offset, contentLength, cornerRadius, pointerHeight)
	local limit = math.max(0, contentLength / 2 - cornerRadius - pointerHeight)
	return math.clamp(offset, -limit, limit)
end
local function computeTooltipLayout(input)
	local side = resolveTooltipSide(input)
	local pointerSize = if side == "Center" then 0 else input.pointerSize
	local padding = getTooltipPadding(side, pointerSize, input.shadow)
	local size = getPopupSize(side, input)
	local _binding = input
	local target = _binding.target
	local bounds = _binding.bounds
	local shadow = _binding.shadow
	local centerX = (target.left + target.right) / 2
	local centerY = (target.top + target.bottom) / 2
	local anchor = {
		x = 0.5,
		y = 0.5,
	}
	local point = {
		x = centerX,
		y = centerY,
	}
	repeat
		if side == "Top" then
			anchor = {
				x = 0.5,
				y = 1,
			}
			point = {
				x = centerX,
				y = target.top,
			}
			break
		end
		if side == "Bottom" then
			anchor = {
				x = 0.5,
				y = 0,
			}
			point = {
				x = centerX,
				y = target.bottom,
			}
			break
		end
		if side == "Left" then
			anchor = {
				x = 1,
				y = 0.5,
			}
			point = {
				x = target.left,
				y = centerY,
			}
			break
		end
		if side == "Right" then
			anchor = {
				x = 0,
				y = 0.5,
			}
			point = {
				x = target.right,
				y = centerY,
			}
			break
		end
	until true
	local shiftX = getShift(point.x - anchor.x * size.width, size.width, bounds.left, bounds.right)
	local shiftY = getShift(point.y - anchor.y * size.height, size.height, bounds.top, bounds.bottom)
	local position = {
		x = point.x + shiftX,
		y = point.y + shiftY,
	}
	local layout = {
		side = side,
		anchor = anchor,
		position = position,
		size = size,
		padding = padding,
	}
	if pointerSize <= 0 then
		return layout
	end
	local pointerHeight = pointerHeightOf(pointerSize)
	local pointerDiff = pointerHeight - pointerSize / 2
	local _condition = input.cornerRadius
	if _condition == nil then
		_condition = 0
	end
	local cornerRadius = _condition
	local crossX = (shadow.left - shadow.right) / 2 + clampPointer(-shiftX, input.content.width, cornerRadius, pointerHeight)
	local crossY = (shadow.top - shadow.bottom) / 2 + clampPointer(-shiftY, input.content.height, cornerRadius, pointerHeight)
	repeat
		if side == "Top" then
			layout.pointer = {
				anchor = {
					x = 0.5,
					y = 1,
				},
				scale = {
					x = 0.5,
					y = 1,
				},
				offset = {
					x = crossX,
					y = -math.max(math.ceil(pointerDiff), shadow.bottom - pointerDiff),
				},
				rotation = 45,
			}
			break
		end
		if side == "Bottom" then
			layout.pointer = {
				anchor = {
					x = 0.5,
					y = 0,
				},
				scale = {
					x = 0.5,
					y = 0,
				},
				offset = {
					x = crossX,
					y = math.max(math.ceil(pointerDiff), shadow.top - pointerDiff),
				},
				rotation = -135,
			}
			break
		end
		if side == "Left" then
			layout.pointer = {
				anchor = {
					x = 1,
					y = 0.5,
				},
				scale = {
					x = 1,
					y = 0.5,
				},
				offset = {
					x = -math.max(math.ceil(pointerDiff), shadow.right - pointerDiff),
					y = crossY,
				},
				rotation = -45,
			}
			break
		end
		if side == "Right" then
			layout.pointer = {
				anchor = {
					x = 0,
					y = 0.5,
				},
				scale = {
					x = 0,
					y = 0.5,
				},
				offset = {
					x = math.max(math.ceil(pointerDiff), shadow.left - pointerDiff),
					y = crossY,
				},
				rotation = 135,
			}
			break
		end
	until true
	return layout
end
return {
	getTooltipSafeArea = getTooltipSafeArea,
	getTooltipPadding = getTooltipPadding,
	resolveTooltipSide = resolveTooltipSide,
	computeTooltipLayout = computeTooltipLayout,
}
