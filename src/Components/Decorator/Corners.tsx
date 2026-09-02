import React from "@rbxts/react";
import { CssSize } from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";

interface CornerProps {
    radius?: CssSize
    name?: string;
}

export function Corners(props: CornerProps) {
    if (props.radius === undefined)
        return undefined

    const radius = SizeHelper.toUDim(props.radius);
    if (radius.Scale === 0 && radius.Offset === 0)
        return undefined

    return (
        <uicorner
            key={props.name ?? "Corners"}
            CornerRadius={radius}
        />
    );
}