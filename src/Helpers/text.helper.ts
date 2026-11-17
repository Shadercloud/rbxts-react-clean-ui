const utf8Length = utf8.len as unknown as (text: string) => number | undefined;

const COMPLEX_SCRIPT_RANGES: ReadonlyArray<readonly [number, number]> = [
    [0x0590, 0x0dff],
    [0x0f00, 0x109f],
    [0x1780, 0x18af],
    [0x200e, 0x200f],
    [0x202a, 0x202e],
    [0x2066, 0x2069],
    [0xfb1d, 0xfdff],
    [0xfe70, 0xfeff],
    [0x10800, 0x11fff],
    [0x1e800, 0x1efff],
];

const FIRST_COMPLEX_CODEPOINT = 0x0590;

function isComplexCodepoint(codepoint: number): boolean {
    if (codepoint < FIRST_COMPLEX_CODEPOINT) {
        return false;
    }

    for (const [first, last] of COMPLEX_SCRIPT_RANGES) {
        if (codepoint >= first && codepoint <= last) {
            return true;
        }
    }

    return false;
}

function lowercaseCodepoint(codepoint: number): number {
    if (codepoint < 0x80) {
        return codepoint >= 0x41 && codepoint <= 0x5a ? codepoint + 32 : codepoint;
    }

    if (codepoint >= 0xc0 && codepoint <= 0xde) {
        return codepoint === 0xd7 ? codepoint : codepoint + 32;
    }

    if (codepoint >= 0x100 && codepoint <= 0x17f) {
        if (codepoint === 0x130 || codepoint === 0x131 || codepoint === 0x138 || codepoint === 0x149 || codepoint === 0x17f) {
            return codepoint;
        }

        if (codepoint === 0x178) {
            return 0xff;
        }

        const upperIsOdd = (codepoint >= 0x139 && codepoint <= 0x148) || codepoint >= 0x179;

        return codepoint % 2 === (upperIsOdd ? 1 : 0) ? codepoint + 1 : codepoint;
    }

    if (codepoint >= 0x386 && codepoint <= 0x3ab) {
        if (codepoint === 0x386) {
            return 0x3ac;
        }

        if (codepoint >= 0x388 && codepoint <= 0x38a) {
            return codepoint + 37;
        }

        if (codepoint === 0x38c) {
            return 0x3cc;
        }

        if (codepoint === 0x38e || codepoint === 0x38f) {
            return codepoint + 63;
        }

        if (codepoint >= 0x391 && codepoint !== 0x3a2) {
            return codepoint + 32;
        }

        return codepoint;
    }

    if (codepoint >= 0x400 && codepoint <= 0x40f) {
        return codepoint + 80;
    }

    if (codepoint >= 0x410 && codepoint <= 0x42f) {
        return codepoint + 32;
    }

    return codepoint;
}

export class TextHelper {
    public static isValidUtf8(text: string): boolean {
        return typeIs(utf8Length(text), "number");
    }

    public static lowercase(text: string): string {
        const length = utf8Length(text);

        if (!typeIs(length, "number") || length === text.size()) {
            return text.lower();
        }

        const characters: string[] = [];

        for (const [, codepoint] of utf8.codes(text)) {
            characters.push(utf8.char(lowercaseCodepoint(codepoint)));
        }

        return characters.join("");
    }

    public static isComplexScript(text: string): boolean {
        const length = utf8Length(text);

        if (!typeIs(length, "number") || length === text.size()) {
            return false;
        }

        for (const [, codepoint] of utf8.codes(text)) {
            if (isComplexCodepoint(codepoint)) {
                return true;
            }
        }

        return false;
    }

    public static splitGraphemes(text: string): string[] | undefined {
        const length = utf8Length(text);

        if (!typeIs(length, "number")) {
            return undefined;
        }

        const characters: string[] = [];

        if (length === text.size()) {
            for (let index = 0; index < text.size(); index++) {
                characters.push(text.sub(index + 1, index + 1));
            }

            return characters;
        }

        if (TextHelper.isComplexScript(text)) {
            return undefined;
        }

        for (const [first, last] of utf8.graphemes(text)) {
            characters.push(text.sub(first, last));
        }

        return characters;
    }
}
