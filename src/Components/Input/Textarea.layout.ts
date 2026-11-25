const utf8Length = utf8.len as unknown as (text: string) => number | undefined;
const utf8Offset = utf8.offset as unknown as (text: string, index: number) => number | undefined;

export const TEXTAREA_DEFAULT_ROWS = 4;

const WHOLE_PIXEL_EPSILON = 0.001;

function finiteOrZero(value: number): number {
    return value === value && value !== math.huge && value !== -math.huge ? value : 0;
}

export function resolveTextareaHeight(
    height: number | undefined,
    rows: number,
    lineHeight: number,
    paddingTop: number,
    paddingBottom: number,
): number {
    if (height !== undefined) {
        return math.max(0, height);
    }

    const lines = math.max(1, math.floor(finiteOrZero(rows)));

    return lines * math.max(0, lineHeight) + paddingTop + paddingBottom;
}

export function resolveTextareaWholePixels(value: number): number {
    return math.max(0, math.ceil(finiteOrZero(value) - WHOLE_PIXEL_EPSILON));
}

export function resolveTextareaScreenScale(screenHeight: number, designHeight: number, fallback: number): number {
    const context = fallback > 0 ? fallback : 1;

    if (screenHeight > 0 && designHeight > 0) {
        if (math.abs(screenHeight - designHeight * context) <= 1) {
            return context;
        }

        return screenHeight / designHeight;
    }

    return context;
}

export function resolveTextareaCanvasHeight(
    textHeight: number,
    paddingTop: number,
    paddingBottom: number,
    viewportHeight = 0,
    screenScale = 1,
): number {
    const content = math.max(0, finiteOrZero(textHeight)) + paddingTop + paddingBottom;
    const tolerance = screenScale > 0 ? 1 / screenScale : 1;

    if (content <= viewportHeight + tolerance) {
        return math.max(viewportHeight, 0);
    }

    return content;
}

export function resolveTextareaWrapWidth(
    fieldWidth: number,
    paddingLeft: number,
    paddingRight: number,
    gutter: number,
): number {
    return math.max(0, fieldWidth - paddingLeft - paddingRight - math.max(0, gutter));
}

export function resolveTextareaCaretScroll(
    caretTop: number,
    caretBottom: number,
    canvasY: number,
    viewportHeight: number,
): number {
    if (caretBottom > canvasY + viewportHeight) {
        return math.max(0, math.min(caretTop, caretBottom - viewportHeight));
    }

    if (caretTop < canvasY) {
        return math.max(0, caretTop);
    }

    return canvasY;
}

export function resolveTextareaCaretText(text: string, cursorPosition: number): string | undefined {
    if (cursorPosition < 1) {
        return undefined;
    }

    const prefix = text.sub(1, math.min(cursorPosition, text.size() + 1) - 1);

    if (prefix === "" || prefix.sub(-1) === "\n") {
        return `${prefix} `;
    }

    return prefix;
}

export function resolveTextareaCaretLineText(text: string, cursorPosition: number): string | undefined {
    const prefix = resolveTextareaCaretText(text, cursorPosition);

    if (prefix === undefined) {
        return undefined;
    }

    const start = math.min(cursorPosition, text.size() + 1);
    const before = text.sub(1, start - 1);

    if (before === "" || before.sub(-1) === "\n") {
        return prefix;
    }

    const [stop] = text.find("%s", start);

    return prefix + text.sub(start, stop !== undefined ? stop - 1 : text.size());
}

export function resolveTextareaLength(text: string): number {
    const length = utf8Length(text);

    return typeIs(length, "number") ? length : text.size();
}

export function trimTextareaText(text: string, maxLength?: number): string {
    if (maxLength === undefined) {
        return text;
    }

    const limit = math.max(0, math.floor(finiteOrZero(maxLength)));
    const length = utf8Length(text);

    if (!typeIs(length, "number")) {
        return text.size() > limit ? text.sub(1, limit) : text;
    }

    if (length <= limit) {
        return text;
    }

    const offset = utf8Offset(text, limit + 1);

    return typeIs(offset, "number") ? text.sub(1, offset - 1) : text;
}

function groupDigits(value: number): string {
    const digits = tostring(math.max(0, math.floor(finiteOrZero(value))));
    let result = "";
    let count = 0;

    for (let index = digits.size(); index >= 1; index--) {
        result = digits.sub(index, index) + result;
        count++;

        if (count % 3 === 0 && index > 1) {
            result = `,${result}`;
        }
    }

    return result;
}

export function formatTextareaCount(length: number, maxLength?: number): string {
    if (maxLength === undefined) {
        return groupDigits(length);
    }

    return `${groupDigits(length)} / ${groupDigits(maxLength)}`;
}
