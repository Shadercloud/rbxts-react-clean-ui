import React from "@rbxts/react";
import { useIgnorePreferredTextSize } from "../../Contexts";
import { TypographyHelper } from "../../Helpers";
import { PinTextSize } from "./PinTextSize";

export interface PreferredTextSizePinProps {
    size: Enum.FontSize;
    scaled?: boolean | React.Binding<boolean>;
    minTextSize?: number;
    maxTextSize?: number;
}

export function usePinsPreferredTextSize(scaled: boolean | React.Binding<boolean> | undefined): boolean {
    const ignorePreferredTextSize = useIgnorePreferredTextSize();

    return ignorePreferredTextSize && scaled !== true;
}

export function PreferredTextSizePin(props: PreferredTextSizePinProps) {
    const pinned = usePinsPreferredTextSize(props.scaled);

    if (!pinned)
        return undefined;

    const textSize = TypographyHelper.toTextSize(props.size);

    if (textSize === undefined)
        return undefined;

    const minTextSize = props.minTextSize ?? 1;
    const maxTextSize = props.maxTextSize ?? 100;
    const size = math.clamp(textSize, minTextSize, maxTextSize);

    const scaled = props.scaled;

    if (scaled === undefined || typeIs(scaled, "boolean"))
        return <PinTextSize size={size} />;

    return (
        <uitextsizeconstraint
            key="PinTextSize"
            MinTextSize={scaled.map((value) => value ? minTextSize : size)}
            MaxTextSize={scaled.map((value) => value ? maxTextSize : size)}
        />
    );
}
