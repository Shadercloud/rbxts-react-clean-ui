-- Compiled with roblox-ts v3.0.0
local TS = _G[script]
local _lunit = TS.import(script, TS.getModule(script, "@rbxts", "lunit").out)
local Test = _lunit.Test
local Assert = _lunit.Assert
local Tag = _lunit.Tag
local DisplayName = _lunit.DisplayName
local _Tooltip_placement = TS.import(script, script.Parent.Parent.Parent.Parent, "Components", "Interaction", "Tooltip.placement")
local computeTooltipLayout = _Tooltip_placement.computeTooltipLayout
local getTooltipPadding = _Tooltip_placement.getTooltipPadding
local getTooltipSafeArea = _Tooltip_placement.getTooltipSafeArea
local resolveTooltipSide = _Tooltip_placement.resolveTooltipSide
local NO_SHADOW = {
	top = 0,
	bottom = 0,
	left = 0,
	right = 0,
}
local POINTER_SIZE = 10
local POINTER_HEIGHT = (1.41421356 * POINTER_SIZE) / 2
local CORNER_RADIUS = 8
local BOUNDS = getTooltipSafeArea({
	width = 400,
	height = 300,
}, 8, 0)
local function targetAt(left, top, width, height)
	if width == nil then
		width = 30
	end
	if height == nil then
		height = 20
	end
	return {
		left = left,
		top = top,
		right = left + width,
		bottom = top + height,
	}
end
local function input(target, placement, overrides)
	if overrides == nil then
		overrides = {}
	end
	local _object = {
		target = target,
		content = {
			width = 80,
			height = 20,
		},
		bounds = BOUNDS,
		placement = placement,
		pointerSize = POINTER_SIZE,
		shadow = NO_SHADOW,
		cornerRadius = CORNER_RADIUS,
	}
	for _k, _v in overrides do
		_object[_k] = _v
	end
	return _object
end
local function assertNear(actual, expected, label)
	Assert["true"](Assert, math.abs(actual - expected) < 1e-6, `{label}: expected {expected}, got {actual}`)
end
local function assertInside(layoutInput, label)
	local layout = computeTooltipLayout(layoutInput)
	local left = layout.position.x - layout.anchor.x * layout.size.width
	local top = layout.position.y - layout.anchor.y * layout.size.height
	local bounds = layoutInput.bounds
	Assert["true"](Assert, left >= bounds.left - 1e-6 and top >= bounds.top - 1e-6 and left + layout.size.width <= bounds.right + 1e-6 and top + layout.size.height <= bounds.bottom + 1e-6, `{label}: expected popup [{left}, {top}, {layout.size.width}x{layout.size.height}] inside [{bounds.left}, {bounds.top}, {bounds.right}, {bounds.bottom}]`)
end
local TooltipPlacementValidation
do
	TooltipPlacementValidation = setmetatable({}, {
		__tostring = function()
			return "TooltipPlacementValidation"
		end,
	})
	TooltipPlacementValidation.__index = TooltipPlacementValidation
	function TooltipPlacementValidation.new(...)
		local self = setmetatable({}, TooltipPlacementValidation)
		return self:constructor(...) or self
	end
	function TooltipPlacementValidation:constructor()
	end
	function TooltipPlacementValidation:keepsPreferred()
		local layout = computeTooltipLayout(input(targetAt(185, 140), "Top"))
		Assert:equal(layout.side, "Top")
		Assert:equal(layout.position.x, 200)
		Assert:equal(layout.position.y, 140)
	end
	function TooltipPlacementValidation:defaultIsTop()
		Assert:equal(resolveTooltipSide(input(targetAt(185, 140), nil)), "Top")
		Assert:equal(resolveTooltipSide(input(targetAt(185, 10), nil)), "Bottom")
	end
	function TooltipPlacementValidation:flipsTopToBottom()
		Assert:equal(computeTooltipLayout(input(targetAt(185, 10), "Top")).side, "Bottom")
	end
	function TooltipPlacementValidation:flipsBottomToTop()
		Assert:equal(computeTooltipLayout(input(targetAt(185, 270), "Bottom")).side, "Top")
	end
	function TooltipPlacementValidation:flipsRightToLeft()
		local layoutInput = input(targetAt(360, 140), "Right")
		Assert:equal(computeTooltipLayout(layoutInput).side, "Left")
		assertInside(layoutInput, "flipped Right tooltip")
	end
	function TooltipPlacementValidation:flipsLeftToRight()
		Assert:equal(computeTooltipLayout(input(targetAt(10, 140), "Left")).side, "Right")
	end
	function TooltipPlacementValidation:bothOverflow()
		local bounds = getTooltipSafeArea({
			width = 400,
			height = 60,
		}, 0, 0)
		local content = {
			width = 80,
			height = 30,
		}
		Assert:equal(resolveTooltipSide(input(targetAt(185, 15), "Top", {
			bounds = bounds,
			content = content,
		})), "Bottom")
		Assert:equal(resolveTooltipSide(input(targetAt(185, 25), "Bottom", {
			bounds = bounds,
			content = content,
		})), "Top")
		Assert:equal(resolveTooltipSide(input(targetAt(185, 20), "Top", {
			bounds = bounds,
			content = content,
		})), "Top")
	end
	function TooltipPlacementValidation:centerNeverFlips()
		local layoutInput = input(targetAt(185, 0), "Center")
		local layout = computeTooltipLayout(layoutInput)
		Assert:equal(layout.side, "Center")
		Assert:undefined(layout.pointer, "Expected Center to have no pointer")
		assertInside(layoutInput, "Center tooltip")
	end
	function TooltipPlacementValidation:shiftsAtEdge()
		local layout = computeTooltipLayout(input(targetAt(30, 140, 20), "Top"))
		Assert:equal(layout.side, "Top")
		Assert:equal(layout.position.x, 48)
		Assert:equal(layout.pointer.offset.x, -8)
	end
	function TooltipPlacementValidation:shiftsAtCorner()
		local layoutInput = input(targetAt(0, 0, 20), "Top")
		local layout = computeTooltipLayout(layoutInput)
		Assert:equal(layout.side, "Bottom")
		Assert["true"](Assert, layout.position.x > 10, "Expected the popup to shift right of the trigger centre")
		assertInside(layoutInput, "corner tooltip")
	end
	function TooltipPlacementValidation:pointerClamped()
		local layout = computeTooltipLayout(input(targetAt(0, 140, 20), "Top"))
		local limit = 80 / 2 - CORNER_RADIUS - POINTER_HEIGHT
		Assert:equal(layout.position.x, 48)
		assertNear(layout.pointer.offset.x, -limit, "clamped pointer offset")
	end
	function TooltipPlacementValidation:pointerNoRoom()
		local layout = computeTooltipLayout(input(targetAt(0, 140, 20), "Top", {
			content = {
				width = 24,
				height = 20,
			},
		}))
		Assert:equal(layout.pointer.offset.x, 0)
	end
	function TooltipPlacementValidation:shiftsVertically()
		local layout = computeTooltipLayout(input(targetAt(185, 20, 30, 6), "Right", {
			content = {
				width = 80,
				height = 60,
			},
			cornerRadius = 0,
		}))
		Assert:equal(layout.side, "Right")
		Assert:equal(layout.position.y, 38)
		Assert:equal(layout.pointer.offset.y, -15)
	end
	function TooltipPlacementValidation:topbarFlips()
		local withBand = getTooltipSafeArea({
			width = 400,
			height = 300,
		}, 8, 58)
		Assert:equal(withBand.top, 66)
		Assert:equal(resolveTooltipSide(input(targetAt(185, 80), "Top")), "Top")
		Assert:equal(resolveTooltipSide(input(targetAt(185, 80), "Top", {
			bounds = withBand,
		})), "Bottom")
	end
	function TooltipPlacementValidation:topbarAboveOverlay()
		Assert:equal(getTooltipSafeArea({
			width = 400,
			height = 300,
		}, 8, -100).top, 8)
	end
	function TooltipPlacementValidation:autoCentred()
		Assert:equal(resolveTooltipSide(input(targetAt(180, 140, 40, 20), "Auto")), "Top")
	end
	function TooltipPlacementValidation:autoMostRoom()
		Assert:equal(resolveTooltipSide(input(targetAt(180, 60, 40, 20), "Auto")), "Bottom")
	end
	function TooltipPlacementValidation:autoTopLeft()
		Assert:equal(resolveTooltipSide(input(targetAt(10, 10, 40, 20), "Auto")), "Right")
	end
	function TooltipPlacementValidation:autoRightEdge()
		Assert:equal(resolveTooltipSide(input(targetAt(360, 140), "Auto")), "Left")
	end
	function TooltipPlacementValidation:autoNoneFit()
		local bounds = getTooltipSafeArea({
			width = 120,
			height = 60,
		}, 0, 0)
		local content = {
			width = 100,
			height = 40,
		}
		Assert:equal(resolveTooltipSide(input(targetAt(40, 5, 40, 20), "Auto", {
			bounds = bounds,
			content = content,
		})), "Bottom")
	end
	function TooltipPlacementValidation:pointerPadding()
		local shadow = {
			top = 2,
			bottom = 10,
			left = 2,
			right = 6,
		}
		Assert:equal(getTooltipPadding("Top", POINTER_SIZE, shadow).bottom, 10)
		Assert:equal(getTooltipPadding("Bottom", POINTER_SIZE, shadow).top, 7)
		Assert:equal(getTooltipPadding("Left", POINTER_SIZE, shadow).right, 7)
		Assert:equal(getTooltipPadding("Center", POINTER_SIZE, shadow).bottom, 10)
	end
	function TooltipPlacementValidation:shadowPointerOffset()
		local shadow = {
			top = 2,
			bottom = 6,
			left = 2,
			right = 6,
		}
		local layout = computeTooltipLayout(input(targetAt(185, 140), "Top", {
			shadow = shadow,
		}))
		Assert:equal(layout.pointer.offset.x, -2)
		Assert:equal(layout.pointer.offset.y, -math.max(math.ceil(POINTER_HEIGHT - 5), 6 - (POINTER_HEIGHT - 5)))
	end
	local _decorator = DisplayName("A Top tooltip that fits above the trigger keeps its side and stays centred on it")
	local _descriptor = Test(TooltipPlacementValidation, "keepsPreferred", {
		value = TooltipPlacementValidation.keepsPreferred,
	})
	if _descriptor then
		TooltipPlacementValidation.keepsPreferred = _descriptor.value
	end
	local _descriptor_1 = _decorator(TooltipPlacementValidation, "keepsPreferred", {
		value = TooltipPlacementValidation.keepsPreferred,
	})
	if _descriptor_1 then
		TooltipPlacementValidation.keepsPreferred = _descriptor_1.value
	end
	local _decorator_1 = DisplayName("Omitting placement behaves like Top, including the flip near the top edge")
	local _descriptor_2 = Test(TooltipPlacementValidation, "defaultIsTop", {
		value = TooltipPlacementValidation.defaultIsTop,
	})
	if _descriptor_2 then
		TooltipPlacementValidation.defaultIsTop = _descriptor_2.value
	end
	local _descriptor_3 = _decorator_1(TooltipPlacementValidation, "defaultIsTop", {
		value = TooltipPlacementValidation.defaultIsTop,
	})
	if _descriptor_3 then
		TooltipPlacementValidation.defaultIsTop = _descriptor_3.value
	end
	local _decorator_2 = DisplayName("A Top tooltip with no room above the trigger opens below it instead")
	local _descriptor_4 = Test(TooltipPlacementValidation, "flipsTopToBottom", {
		value = TooltipPlacementValidation.flipsTopToBottom,
	})
	if _descriptor_4 then
		TooltipPlacementValidation.flipsTopToBottom = _descriptor_4.value
	end
	local _descriptor_5 = _decorator_2(TooltipPlacementValidation, "flipsTopToBottom", {
		value = TooltipPlacementValidation.flipsTopToBottom,
	})
	if _descriptor_5 then
		TooltipPlacementValidation.flipsTopToBottom = _descriptor_5.value
	end
	local _decorator_3 = DisplayName("A Bottom tooltip with no room below the trigger opens above it instead")
	local _descriptor_6 = Test(TooltipPlacementValidation, "flipsBottomToTop", {
		value = TooltipPlacementValidation.flipsBottomToTop,
	})
	if _descriptor_6 then
		TooltipPlacementValidation.flipsBottomToTop = _descriptor_6.value
	end
	local _descriptor_7 = _decorator_3(TooltipPlacementValidation, "flipsBottomToTop", {
		value = TooltipPlacementValidation.flipsBottomToTop,
	})
	if _descriptor_7 then
		TooltipPlacementValidation.flipsBottomToTop = _descriptor_7.value
	end
	local _decorator_4 = DisplayName("A Right tooltip next to the right edge opens to the left and stays inside the safe area")
	local _descriptor_8 = Test(TooltipPlacementValidation, "flipsRightToLeft", {
		value = TooltipPlacementValidation.flipsRightToLeft,
	})
	if _descriptor_8 then
		TooltipPlacementValidation.flipsRightToLeft = _descriptor_8.value
	end
	local _descriptor_9 = _decorator_4(TooltipPlacementValidation, "flipsRightToLeft", {
		value = TooltipPlacementValidation.flipsRightToLeft,
	})
	if _descriptor_9 then
		TooltipPlacementValidation.flipsRightToLeft = _descriptor_9.value
	end
	local _decorator_5 = DisplayName("A Left tooltip next to the left edge opens to the right")
	local _descriptor_10 = Test(TooltipPlacementValidation, "flipsLeftToRight", {
		value = TooltipPlacementValidation.flipsLeftToRight,
	})
	if _descriptor_10 then
		TooltipPlacementValidation.flipsLeftToRight = _descriptor_10.value
	end
	local _descriptor_11 = _decorator_5(TooltipPlacementValidation, "flipsLeftToRight", {
		value = TooltipPlacementValidation.flipsLeftToRight,
	})
	if _descriptor_11 then
		TooltipPlacementValidation.flipsLeftToRight = _descriptor_11.value
	end
	local _decorator_6 = DisplayName("When neither side fits, the side with more room wins, and a tie keeps the preferred side")
	local _descriptor_12 = Test(TooltipPlacementValidation, "bothOverflow", {
		value = TooltipPlacementValidation.bothOverflow,
	})
	if _descriptor_12 then
		TooltipPlacementValidation.bothOverflow = _descriptor_12.value
	end
	local _descriptor_13 = _decorator_6(TooltipPlacementValidation, "bothOverflow", {
		value = TooltipPlacementValidation.bothOverflow,
	})
	if _descriptor_13 then
		TooltipPlacementValidation.bothOverflow = _descriptor_13.value
	end
	local _decorator_7 = DisplayName("Center never flips, even pressed against the top edge, and is still clamped inside the safe area")
	local _descriptor_14 = Test(TooltipPlacementValidation, "centerNeverFlips", {
		value = TooltipPlacementValidation.centerNeverFlips,
	})
	if _descriptor_14 then
		TooltipPlacementValidation.centerNeverFlips = _descriptor_14.value
	end
	local _descriptor_15 = _decorator_7(TooltipPlacementValidation, "centerNeverFlips", {
		value = TooltipPlacementValidation.centerNeverFlips,
	})
	if _descriptor_15 then
		TooltipPlacementValidation.centerNeverFlips = _descriptor_15.value
	end
	local _decorator_8 = DisplayName("A Top tooltip at the left edge shifts right into the safe area and its pointer moves back by the same amount")
	local _descriptor_16 = Test(TooltipPlacementValidation, "shiftsAtEdge", {
		value = TooltipPlacementValidation.shiftsAtEdge,
	})
	if _descriptor_16 then
		TooltipPlacementValidation.shiftsAtEdge = _descriptor_16.value
	end
	local _descriptor_17 = _decorator_8(TooltipPlacementValidation, "shiftsAtEdge", {
		value = TooltipPlacementValidation.shiftsAtEdge,
	})
	if _descriptor_17 then
		TooltipPlacementValidation.shiftsAtEdge = _descriptor_17.value
	end
	local _decorator_9 = DisplayName("At the top-left corner a Top tooltip flips below and shifts right, staying inside the safe area")
	local _descriptor_18 = Test(TooltipPlacementValidation, "shiftsAtCorner", {
		value = TooltipPlacementValidation.shiftsAtCorner,
	})
	if _descriptor_18 then
		TooltipPlacementValidation.shiftsAtCorner = _descriptor_18.value
	end
	local _descriptor_19 = _decorator_9(TooltipPlacementValidation, "shiftsAtCorner", {
		value = TooltipPlacementValidation.shiftsAtCorner,
	})
	if _descriptor_19 then
		TooltipPlacementValidation.shiftsAtCorner = _descriptor_19.value
	end
	local _decorator_10 = DisplayName("A large shift clamps the pointer to the popup's straight edge, clear of the rounded corners")
	local _descriptor_20 = Test(TooltipPlacementValidation, "pointerClamped", {
		value = TooltipPlacementValidation.pointerClamped,
	})
	if _descriptor_20 then
		TooltipPlacementValidation.pointerClamped = _descriptor_20.value
	end
	local _descriptor_21 = _decorator_10(TooltipPlacementValidation, "pointerClamped", {
		value = TooltipPlacementValidation.pointerClamped,
	})
	if _descriptor_21 then
		TooltipPlacementValidation.pointerClamped = _descriptor_21.value
	end
	local _decorator_11 = DisplayName("A popup too narrow for the pointer to move keeps the pointer centred on the content")
	local _descriptor_22 = Test(TooltipPlacementValidation, "pointerNoRoom", {
		value = TooltipPlacementValidation.pointerNoRoom,
	})
	if _descriptor_22 then
		TooltipPlacementValidation.pointerNoRoom = _descriptor_22.value
	end
	local _descriptor_23 = _decorator_11(TooltipPlacementValidation, "pointerNoRoom", {
		value = TooltipPlacementValidation.pointerNoRoom,
	})
	if _descriptor_23 then
		TooltipPlacementValidation.pointerNoRoom = _descriptor_23.value
	end
	local _decorator_12 = DisplayName("Left and Right tooltips shift vertically at the top edge and move their pointer along the side")
	local _descriptor_24 = Test(TooltipPlacementValidation, "shiftsVertically", {
		value = TooltipPlacementValidation.shiftsVertically,
	})
	if _descriptor_24 then
		TooltipPlacementValidation.shiftsVertically = _descriptor_24.value
	end
	local _descriptor_25 = _decorator_12(TooltipPlacementValidation, "shiftsVertically", {
		value = TooltipPlacementValidation.shiftsVertically,
	})
	if _descriptor_25 then
		TooltipPlacementValidation.shiftsVertically = _descriptor_25.value
	end
	local _decorator_13 = DisplayName("The topbar band pushes the safe area down, so a Top tooltip just below the band opens below")
	local _descriptor_26 = Test(TooltipPlacementValidation, "topbarFlips", {
		value = TooltipPlacementValidation.topbarFlips,
	})
	if _descriptor_26 then
		TooltipPlacementValidation.topbarFlips = _descriptor_26.value
	end
	local _descriptor_27 = _decorator_13(TooltipPlacementValidation, "topbarFlips", {
		value = TooltipPlacementValidation.topbarFlips,
	})
	if _descriptor_27 then
		TooltipPlacementValidation.topbarFlips = _descriptor_27.value
	end
	local _decorator_14 = DisplayName("A topbar band above the overlay (negative local bottom) does not move the safe area")
	local _descriptor_28 = Test(TooltipPlacementValidation, "topbarAboveOverlay", {
		value = TooltipPlacementValidation.topbarAboveOverlay,
	})
	if _descriptor_28 then
		TooltipPlacementValidation.topbarAboveOverlay = _descriptor_28.value
	end
	local _descriptor_29 = _decorator_14(TooltipPlacementValidation, "topbarAboveOverlay", {
		value = TooltipPlacementValidation.topbarAboveOverlay,
	})
	if _descriptor_29 then
		TooltipPlacementValidation.topbarAboveOverlay = _descriptor_29.value
	end
	local _decorator_15 = DisplayName("Auto picks Top for a centred trigger, where every side fits without a shift and Top ties Bottom")
	local _descriptor_30 = Test(TooltipPlacementValidation, "autoCentred", {
		value = TooltipPlacementValidation.autoCentred,
	})
	if _descriptor_30 then
		TooltipPlacementValidation.autoCentred = _descriptor_30.value
	end
	local _descriptor_31 = _decorator_15(TooltipPlacementValidation, "autoCentred", {
		value = TooltipPlacementValidation.autoCentred,
	})
	if _descriptor_31 then
		TooltipPlacementValidation.autoCentred = _descriptor_31.value
	end
	local _decorator_16 = DisplayName("Auto prefers the fitting side with the most room when no side needs a shift")
	local _descriptor_32 = Test(TooltipPlacementValidation, "autoMostRoom", {
		value = TooltipPlacementValidation.autoMostRoom,
	})
	if _descriptor_32 then
		TooltipPlacementValidation.autoMostRoom = _descriptor_32.value
	end
	local _descriptor_33 = _decorator_16(TooltipPlacementValidation, "autoMostRoom", {
		value = TooltipPlacementValidation.autoMostRoom,
	})
	if _descriptor_33 then
		TooltipPlacementValidation.autoMostRoom = _descriptor_33.value
	end
	local _decorator_17 = DisplayName("Auto at the top-left corner picks Right, which needs no shift, over Bottom, which comes first in order")
	local _descriptor_34 = Test(TooltipPlacementValidation, "autoTopLeft", {
		value = TooltipPlacementValidation.autoTopLeft,
	})
	if _descriptor_34 then
		TooltipPlacementValidation.autoTopLeft = _descriptor_34.value
	end
	local _descriptor_35 = _decorator_17(TooltipPlacementValidation, "autoTopLeft", {
		value = TooltipPlacementValidation.autoTopLeft,
	})
	if _descriptor_35 then
		TooltipPlacementValidation.autoTopLeft = _descriptor_35.value
	end
	local _decorator_18 = DisplayName("Auto near the right edge picks Left, because Top and Bottom would need a large sideways shift")
	local _descriptor_36 = Test(TooltipPlacementValidation, "autoRightEdge", {
		value = TooltipPlacementValidation.autoRightEdge,
	})
	if _descriptor_36 then
		TooltipPlacementValidation.autoRightEdge = _descriptor_36.value
	end
	local _descriptor_37 = _decorator_18(TooltipPlacementValidation, "autoRightEdge", {
		value = TooltipPlacementValidation.autoRightEdge,
	})
	if _descriptor_37 then
		TooltipPlacementValidation.autoRightEdge = _descriptor_37.value
	end
	local _decorator_19 = DisplayName("Auto with no side that fits takes the side with the most room")
	local _descriptor_38 = Test(TooltipPlacementValidation, "autoNoneFit", {
		value = TooltipPlacementValidation.autoNoneFit,
	})
	if _descriptor_38 then
		TooltipPlacementValidation.autoNoneFit = _descriptor_38.value
	end
	local _descriptor_39 = _decorator_19(TooltipPlacementValidation, "autoNoneFit", {
		value = TooltipPlacementValidation.autoNoneFit,
	})
	if _descriptor_39 then
		TooltipPlacementValidation.autoNoneFit = _descriptor_39.value
	end
	local _decorator_20 = DisplayName("The pointer side gets at least the pointer's height of padding, or the shadow's if that is larger")
	local _descriptor_40 = Test(TooltipPlacementValidation, "pointerPadding", {
		value = TooltipPlacementValidation.pointerPadding,
	})
	if _descriptor_40 then
		TooltipPlacementValidation.pointerPadding = _descriptor_40.value
	end
	local _descriptor_41 = _decorator_20(TooltipPlacementValidation, "pointerPadding", {
		value = TooltipPlacementValidation.pointerPadding,
	})
	if _descriptor_41 then
		TooltipPlacementValidation.pointerPadding = _descriptor_41.value
	end
	local _decorator_21 = DisplayName("An uneven shadow offsets the pointer so it stays centred on the content, as before")
	local _descriptor_42 = Test(TooltipPlacementValidation, "shadowPointerOffset", {
		value = TooltipPlacementValidation.shadowPointerOffset,
	})
	if _descriptor_42 then
		TooltipPlacementValidation.shadowPointerOffset = _descriptor_42.value
	end
	local _descriptor_43 = _decorator_21(TooltipPlacementValidation, "shadowPointerOffset", {
		value = TooltipPlacementValidation.shadowPointerOffset,
	})
	if _descriptor_43 then
		TooltipPlacementValidation.shadowPointerOffset = _descriptor_43.value
	end
	TooltipPlacementValidation = Tag("Lune")(TooltipPlacementValidation) or TooltipPlacementValidation
end
return TooltipPlacementValidation
