import React from "@rbxts/react";
import { CssSize } from "../../Interfaces/";
import { SizeHelper } from "../../Helpers/";

interface CornerProps {
    radius?: CssSize
}

export function Corners(props: CornerProps) {
    if (props.radius === undefined)
        return undefined
    return (
        <uicorner
            CornerRadius={SizeHelper.toUDim(props.radius)}
        />
    );
}