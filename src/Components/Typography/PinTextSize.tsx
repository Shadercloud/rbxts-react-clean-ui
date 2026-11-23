import React from "@rbxts/react";

export interface PinTextSizeProps {
    size?: number;
    enabled?: boolean;
}

export function PinTextSize(props: PinTextSizeProps) {
    if (props.size === undefined || props.enabled === false)
        return undefined;

    const size = math.clamp(props.size, 1, 100);

    return (
        <uitextsizeconstraint
            key="PinTextSize"
            MinTextSize={size}
            MaxTextSize={size}
        />
    );
}
