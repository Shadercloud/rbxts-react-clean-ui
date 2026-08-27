import { CssBoxShadow, CssShadow, CssSize, CssQuad, CssDual, CssSliceInset } from "../Interfaces/css.types";
import { CssBackgroundImage } from "../Theme";

interface ParsedShadow {
    offset: UDim2;
    blurRadius: UDim;
    spread: UDim2;
}

interface ParsedQuad {
    top: number;
    right: number;
    bottom: number;
    left: number;
}

interface ParsedSliceInset {
    x1: number;
    y1: number;
    x2: number;
    y2: number;
}

export class CssHelper {
    public static parseCssShadow(value: CssShadow): ParsedShadow | undefined {
        if (typeIs(value, "number")) {
            if (value === 0) {
                return undefined;
            }

            const size = this.parseCssSize(value);

            return {
                offset: new UDim2(size, size),
                blurRadius: new UDim(0, 0),
                spread: new UDim2(),
            };
        }

        const parts = value
            .split(" ")
            .filter((part) => part.size() > 0) as CssSize[];

        const x = this.parseCssSize(parts[0] ?? "0");
        const y = this.parseCssSize(parts[1] ?? parts[0] ?? "0");
        const blur = this.parseCssSize(parts[2] ?? "0");
        const spread = this.parseCssSize(parts[3] ?? "0");

        const isZero =
            this.isZero(x) &&
            this.isZero(y) &&
            this.isZero(blur) &&
            this.isZero(spread);

        if (isZero) {
            return undefined;
        }

        return {
            offset: new UDim2(x, y),
            blurRadius: blur,
            spread: new UDim2(spread, spread),
        };
    }

    private static isZero(value: UDim): boolean {
        return value.Scale === 0 && value.Offset === 0;
    }

    public static parseCssSize(value: CssSize): UDim {
        if (typeIs(value, "number")) {
            return new UDim(0, value);
        }

        if (value.sub(-1) === "%") {
            const amount = tonumber(value.sub(1, -2)) ?? 0;
            return new UDim(amount / 100, 0);
        }

        if (value.sub(-2) === "px") {
            const amount = tonumber(value.sub(1, -3)) ?? 0;
            return new UDim(0, amount);
        }

        return new UDim(0, tonumber(value) ?? 0);
    }

    // CSS quad shorthand ("top right bottom left"), e.g. border-image-slice
    public static parseCssQuad(value: CssQuad): ParsedQuad {
        if (typeIs(value, "number")) {
            const size = this.parseCssSize(value).Offset;
            return { top: size, right: size, bottom: size, left: size };
        }

        const parts = value
            .split(" ")
            .filter((part) => part.size() > 0) as CssSize[];

        const top = this.parseCssSize(parts[0] ?? "0").Offset;
        const right = this.parseCssSize(parts[1] ?? parts[0] ?? "0").Offset;
        const bottom = this.parseCssSize(parts[2] ?? parts[0] ?? "0").Offset;
        const left = this.parseCssSize(parts[3] ?? parts[1] ?? parts[0] ?? "0").Offset;

        return { top, right, bottom, left };
    }

    // strips a trailing "%"/"px" unit suffix (if present) and returns the remaining numeric
    // portion as a raw pixel count — unlike parseCssSize, no Scale/Offset UDim is produced,
    // since SliceCenter's Rect needs plain numbers regardless of what unit (if any) was written
    private static toRawPixels(value: CssSize): number {
        if (typeIs(value, "number")) {
            return value;
        }

        if (value.sub(-1) === "%") {
            return tonumber(value.sub(1, -2)) ?? 0;
        }

        if (value.sub(-2) === "px") {
            return tonumber(value.sub(1, -3)) ?? 0;
        }

        return tonumber(value) ?? 0;
    }

    // Roblox SliceCenter absolute pixel corner shorthand — "A B" (symmetric square
    // corners: Rect(A, A, B, B)) or "A B C D" (Rect(A, B, C, D) directly, i.e.
    // Rect.new(minX, minY, maxX, maxY)) — see CssSliceInset for why this can't be an
    // edge-inset shorthand the way parseCssQuad is for padding/shadow/tileSize
    public static parseCssSliceInset(value: CssSliceInset): ParsedSliceInset {
        const parts = value
            .split(" ")
            .filter((part) => part.size() > 0) as CssSize[];

        const pixels = parts.map((part) => this.toRawPixels(part));

        if (pixels.size() === 2) {
            return { x1: pixels[0], y1: pixels[0], x2: pixels[1], y2: pixels[1] };
        }

        return { x1: pixels[0], y1: pixels[1], x2: pixels[2], y2: pixels[3] };
    }

    // CSS 1-or-2-value shorthand ("x" or "x y"), e.g. background-size / tile-size
    public static parseCssDual(value: CssDual): UDim2 {
        if (typeIs(value, "number")) {
            const size = this.parseCssSize(value);
            return new UDim2(size, size);
        }

        const parts = value.split(" ").filter((part) => part.size() > 0) as CssSize[];
        const x = this.parseCssSize(parts[0] ?? "0");
        const y = this.parseCssSize(parts[1] ?? parts[0] ?? "0");
        return new UDim2(x, y);
    }

    public static ResolveShadow(shadow: CssBoxShadow): React.InstanceProps<UIShadow> {
        const offset = this.parseCssShadow(shadow.shadow);
        return {
            Offset: offset?.offset,
            BlurRadius: offset?.blurRadius,
            Spread: offset?.spread,
            Color: shadow.color,
            Transparency: shadow.transparency
        }
    }

    public static resolveBackgroundImage(value: Partial<CssBackgroundImage> | undefined): {
        Image?: string;
        ImageColor3?: Color3;
        ImageTransparency?: number;
        ScaleType?: CssBackgroundImage["size"];
        SliceCenter?: Rect;
        SliceScale?: number;
        TileSize?: UDim2;
    } {
        if (value === undefined) {
            return {};
        }

        const slice = value.slice !== undefined ? this.parseCssSliceInset(value.slice) : undefined;

        return {
            Image:
                typeIs(value.image, "number")
                    ? `rbxassetid://${value.image}`
                    : value.image,
            ImageColor3: value.tintColor,
            ImageTransparency: value.transparency,
            ScaleType: slice !== undefined ? Enum.ScaleType.Slice : (value.size ?? Enum.ScaleType.Stretch),
            SliceCenter:
                slice !== undefined
                    ? new Rect(slice.x1, slice.y1, slice.x2, slice.y2)
                    : undefined,
            SliceScale: value.sliceScale,
            TileSize: value.tileSize !== undefined ? this.parseCssDual(value.tileSize) : undefined,
        };
    }
}