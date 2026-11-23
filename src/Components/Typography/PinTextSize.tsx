import React from "@rbxts/react";
import { useUiScale } from "../../Contexts";
import { toScreenTextSize } from "../../Helpers";

export interface PinTextSizeProps {
    size?: number;
    enabled?: boolean;
}

export function PinTextSize(props: PinTextSizeProps) {
    const uiScale = useUiScale();

    if (props.size === undefined || props.enabled === false)
        return undefined;

    const size = toScreenTextSize(props.size, uiScale);

    if (size === undefined)
        return undefined;

    return (
        <uitextsizeconstraint
            key="PinTextSize"
            MinTextSize={size}
            MaxTextSize={size}
        />
    );
}
