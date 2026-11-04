export type TooltipPlacement = "Top" | "Bottom" | "Left" | "Right" | "Center" | "Auto";

export type TooltipSide = "Top" | "Bottom" | "Left" | "Right" | "Center";

export interface TooltipRect {
    left: number;
    top: number;
    right: number;
    bottom: number;
}

export interface TooltipSize {
    width: number;
    height: number;
}

export interface TooltipPoint {
    x: number;
    y: number;
}

export interface TooltipInsets {
    top: number;
    bottom: number;
    left: number;
    right: number;
}

export interface TooltipPointerLayout {
    anchor: TooltipPoint;
    scale: TooltipPoint;
    offset: TooltipPoint;
    rotation: number;
}

export interface TooltipLayoutInput {
    target: TooltipRect;
    content: TooltipSize;
    bounds: TooltipRect;
    placement?: TooltipPlacement;
    pointerSize: number;
    shadow: TooltipInsets;
    cornerRadius?: number;
}

export interface TooltipLayout {
    side: TooltipSide;
    anchor: TooltipPoint;
    position: TooltipPoint;
    size: TooltipSize;
    padding: TooltipInsets;
    pointer?: TooltipPointerLayout;
}

const AUTO_ORDER: TooltipSide[] = ["Top", "Bottom", "Right", "Left"];

const OPPOSITE: Record<TooltipSide, TooltipSide> = {
    Top: "Bottom",
    Bottom: "Top",
    Left: "Right",
    Right: "Left",
    Center: "Center",
};

function pointerHeightOf(pointerSize: number): number {
    return (1.41421356 * pointerSize) / 2;
}

export function getTooltipSafeArea(overlay: TooltipSize, edgeMargin: number, topbarBottom: number): TooltipRect {
    const left = edgeMargin;
    const top = math.max(0, topbarBottom) + edgeMargin;

    return {
        left,
        top,
        right: math.max(left, overlay.width - edgeMargin),
        bottom: math.max(top, overlay.height - edgeMargin),
    };
}

export function getTooltipPadding(side: TooltipSide, pointerSize: number, shadow: TooltipInsets): TooltipInsets {
    const padding = { ...shadow };

    if (side === "Center" || pointerSize <= 0) {
        return padding;
    }

    const pointerHeight = math.floor(pointerHeightOf(pointerSize));

    switch (side) {
        case "Top":
            padding.bottom = math.max(pointerHeight, shadow.bottom);
            break;
        case "Bottom":
            padding.top = math.max(pointerHeight, shadow.top);
            break;
        case "Left":
            padding.right = math.max(pointerHeight, shadow.right);
            break;
        case "Right":
            padding.left = math.max(pointerHeight, shadow.left);
            break;
    }

    return padding;
}

function getPopupSize(side: TooltipSide, input: TooltipLayoutInput): TooltipSize {
    const padding = getTooltipPadding(side, input.pointerSize, input.shadow);

    return {
        width: input.content.width + padding.left + padding.right,
        height: input.content.height + padding.top + padding.bottom,
    };
}

function getSlack(side: TooltipSide, input: TooltipLayoutInput): number {
    const size = getPopupSize(side, input);
    const { target, bounds } = input;

    switch (side) {
        case "Top":
            return target.top - bounds.top - size.height;
        case "Bottom":
            return bounds.bottom - target.bottom - size.height;
        case "Left":
            return target.left - bounds.left - size.width;
        case "Right":
            return bounds.right - target.right - size.width;
    }

    return 0;
}

function getShift(start: number, length: number, min: number, max: number): number {
    if (length >= max - min || start < min) {
        return min - start;
    }

    if (start + length > max) {
        return max - (start + length);
    }

    return 0;
}

function getCrossShift(side: TooltipSide, input: TooltipLayoutInput): number {
    const size = getPopupSize(side, input);
    const { target, bounds } = input;

    if (side === "Top" || side === "Bottom") {
        const centerX = (target.left + target.right) / 2;
        return math.abs(getShift(centerX - size.width / 2, size.width, bounds.left, bounds.right));
    }

    const centerY = (target.top + target.bottom) / 2;
    return math.abs(getShift(centerY - size.height / 2, size.height, bounds.top, bounds.bottom));
}

export function resolveTooltipSide(input: TooltipLayoutInput): TooltipSide {
    const placement = input.placement ?? "Top";

    if (placement === "Center") {
        return "Center";
    }

    if (placement === "Auto") {
        let best = AUTO_ORDER[0];
        let bestFits = false;
        let bestShift = math.huge;
        let bestSlack = -math.huge;

        for (const side of AUTO_ORDER) {
            const slack = getSlack(side, input);
            const fits = slack >= 0;
            const shift = getCrossShift(side, input);

            const better = fits
                ? !bestFits || shift < bestShift || (shift === bestShift && slack > bestSlack)
                : !bestFits && slack > bestSlack;

            if (better) {
                best = side;
                bestFits = fits;
                bestShift = shift;
                bestSlack = slack;
            }
        }

        return best;
    }

    const preferredSlack = getSlack(placement, input);

    if (preferredSlack >= 0) {
        return placement;
    }

    const opposite = OPPOSITE[placement];
    const oppositeSlack = getSlack(opposite, input);

    return oppositeSlack >= 0 || oppositeSlack > preferredSlack ? opposite : placement;
}

function clampPointer(offset: number, contentLength: number, cornerRadius: number, pointerHeight: number): number {
    const limit = math.max(0, contentLength / 2 - cornerRadius - pointerHeight);

    return math.clamp(offset, -limit, limit);
}

export function computeTooltipLayout(input: TooltipLayoutInput): TooltipLayout {
    const side = resolveTooltipSide(input);
    const pointerSize = side === "Center" ? 0 : input.pointerSize;
    const padding = getTooltipPadding(side, pointerSize, input.shadow);
    const size = getPopupSize(side, input);
    const { target, bounds, shadow } = input;

    const centerX = (target.left + target.right) / 2;
    const centerY = (target.top + target.bottom) / 2;

    let anchor: TooltipPoint = { x: 0.5, y: 0.5 };
    let point: TooltipPoint = { x: centerX, y: centerY };

    switch (side) {
        case "Top":
            anchor = { x: 0.5, y: 1 };
            point = { x: centerX, y: target.top };
            break;
        case "Bottom":
            anchor = { x: 0.5, y: 0 };
            point = { x: centerX, y: target.bottom };
            break;
        case "Left":
            anchor = { x: 1, y: 0.5 };
            point = { x: target.left, y: centerY };
            break;
        case "Right":
            anchor = { x: 0, y: 0.5 };
            point = { x: target.right, y: centerY };
            break;
    }

    const shiftX = getShift(point.x - anchor.x * size.width, size.width, bounds.left, bounds.right);
    const shiftY = getShift(point.y - anchor.y * size.height, size.height, bounds.top, bounds.bottom);
    const position = { x: point.x + shiftX, y: point.y + shiftY };

    const layout: TooltipLayout = { side, anchor, position, size, padding };

    if (pointerSize <= 0) {
        return layout;
    }

    const pointerHeight = pointerHeightOf(pointerSize);
    const pointerDiff = pointerHeight - pointerSize / 2;
    const cornerRadius = input.cornerRadius ?? 0;
    const crossX = (shadow.left - shadow.right) / 2 + clampPointer(-shiftX, input.content.width, cornerRadius, pointerHeight);
    const crossY = (shadow.top - shadow.bottom) / 2 + clampPointer(-shiftY, input.content.height, cornerRadius, pointerHeight);

    switch (side) {
        case "Top":
            layout.pointer = {
                anchor: { x: 0.5, y: 1 },
                scale: { x: 0.5, y: 1 },
                offset: { x: crossX, y: -math.max(math.ceil(pointerDiff), shadow.bottom - pointerDiff) },
                rotation: 45,
            };
            break;
        case "Bottom":
            layout.pointer = {
                anchor: { x: 0.5, y: 0 },
                scale: { x: 0.5, y: 0 },
                offset: { x: crossX, y: math.max(math.ceil(pointerDiff), shadow.top - pointerDiff) },
                rotation: -135,
            };
            break;
        case "Left":
            layout.pointer = {
                anchor: { x: 1, y: 0.5 },
                scale: { x: 1, y: 0.5 },
                offset: { x: -math.max(math.ceil(pointerDiff), shadow.right - pointerDiff), y: crossY },
                rotation: -45,
            };
            break;
        case "Right":
            layout.pointer = {
                anchor: { x: 0, y: 0.5 },
                scale: { x: 0, y: 0.5 },
                offset: { x: math.max(math.ceil(pointerDiff), shadow.left - pointerDiff), y: crossY },
                rotation: 135,
            };
            break;
    }

    return layout;
}
