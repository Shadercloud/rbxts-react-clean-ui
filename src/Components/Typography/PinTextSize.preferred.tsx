import React from "@rbxts/react";
import { useIgnorePreferredTextSize, useUiScale } from "../../Contexts";
import { TypographyHelper, toScreenTextSize, toScreenTextSizeRange } from "../../Helpers";

export interface PreferredTextSizePinProps {
    size: Enum.FontSize;
    scaled?: boolean | React.Binding<boolean>;
    minTextSize?: number;
    maxTextSize?: number;
    shrinkScale?: React.Binding<number>;
}

export function usePinsPreferredTextSize(scaled: boolean | React.Binding<boolean> | undefined): boolean {
    const ignorePreferredTextSize = useIgnorePreferredTextSize();

    return ignorePreferredTextSize && scaled !== true;
}

export function usePreferredTextSizePin(
    size: Enum.FontSize,
    scaled: boolean | React.Binding<boolean> | undefined,
    minTextSize?: number,
    maxTextSize?: number,
): number | undefined {
    const pinned = usePinsPreferredTextSize(scaled);
    const uiScale = useUiScale();

    if (!pinned)
        return undefined;

    const textSize = TypographyHelper.toTextSize(size);

    if (textSize === undefined)
        return undefined;

    return toScreenTextSize(math.clamp(textSize, minTextSize ?? 1, maxTextSize ?? 100), uiScale);
}

export function PreferredTextSizePin(props: PreferredTextSizePinProps) {
    const uiScale = useUiScale();
    const size = usePreferredTextSizePin(props.size, props.scaled, props.minTextSize, props.maxTextSize);

    if (size === undefined)
        return undefined;

    const minTextSize = props.minTextSize ?? 1;
    const maxTextSize = props.maxTextSize ?? 100;
    const shrinkScale = props.shrinkScale;

    const pin = (scale: number) => math.max(size * scale, 1);
    const bounds = (textScaled: boolean, scale: number): [number, number] =>
        textScaled ? toScreenTextSizeRange(minTextSize, maxTextSize, uiScale * scale) : [pin(scale), pin(scale)];

    const scaled = props.scaled;

    if (scaled === undefined || typeIs(scaled, "boolean")) {
        const pinned = shrinkScale === undefined ? size : shrinkScale.map(pin);

        return (
            <uitextsizeconstraint
                key="PinTextSize"
                MinTextSize={pinned}
                MaxTextSize={pinned}
            />
        );
    }

    const resolved = shrinkScale === undefined
        ? scaled.map((value) => bounds(value, 1))
        : React.joinBindings({ scaled, shrinkScale }).map((values) => bounds(values.scaled, values.shrinkScale));

    return (
        <uitextsizeconstraint
            key="PinTextSize"
            MinTextSize={resolved.map((range) => range[0])}
            MaxTextSize={resolved.map((range) => range[1])}
        />
    );
}
