import { CssBoxShadow, CssShadow, CssSize, CssCalcSize, CssQuad, CssDual, CssSliceInset, CssBackgroundGradient } from "../Interfaces/css.types";
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

    public static parseCssSize(value: CssCalcSize): UDim {
        if (typeIs(value, "number")) {
            return new UDim(0, value);
        }

        const minusParts = value.split(" - ");
        if (minusParts.size() === 2) {
            const scale = this.parseCssSize(minusParts[0] as CssCalcSize).Scale;
            const offset = this.parseCssSize(minusParts[1] as CssCalcSize).Offset;
            return new UDim(scale, -offset);
        }

        const plusParts = value.split(" + ");
        if (plusParts.size() === 2) {
            const scale = this.parseCssSize(plusParts[0] as CssCalcSize).Scale;
            const offset = this.parseCssSize(plusParts[1] as CssCalcSize).Offset;
            return new UDim(scale, offset);
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

    public static resolveBackgroundGradient(value: Partial<CssBackgroundGradient> | undefined): React.InstanceProps<UIGradient> | undefined {
        const colors = value?.colors;

        if (value === undefined || colors === undefined) {
            return undefined;
        }

        if (!typeIs(colors, "ColorSequence") && colors.size() === 0) {
            return undefined;
        }

        const color = typeIs(colors, "ColorSequence")
            ? colors
            : this.buildColorSequence(colors, value.stops);

        return {
            Color: color,
            Transparency: this.buildTransparencySequence(value.transparency),
            Rotation: value.rotation,
            Offset: value.offset,
        };
    }

    private static buildColorSequence(colors: Color3[], stops?: number[]): ColorSequence {
        if (colors.size() === 1) {
            return new ColorSequence(colors[0]);
        }

        const lastIndex = colors.size() - 1;

        const entries = colors.map((color, index) => {
            let time = stops?.[index] !== undefined
                ? math.clamp(stops[index], 0, 1)
                : index / lastIndex;

            if (index === 0) {
                time = 0;
            } else if (index === lastIndex) {
                time = 1;
            }

            return { time, color, index };
        });

        entries.sort((a, b) => {
            if (a.time !== b.time) {
                return a.time < b.time;
            }

            return a.index < b.index;
        });

        return new ColorSequence(entries.map((entry) => new ColorSequenceKeypoint(entry.time, entry.color)));
    }

    private static buildTransparencySequence(value: number | NumberSequence | undefined): NumberSequence | undefined {
        if (value === undefined) {
            return undefined;
        }

        if (typeIs(value, "NumberSequence")) {
            return value;
        }

        return new NumberSequence(math.clamp(value, 0, 1));
    }
}