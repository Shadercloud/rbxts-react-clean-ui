import React from "@rbxts/react";
import { CssRadius } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { SizeHelper } from "../../Helpers/";

interface CornerProps {
    radius?: CssRadius
    name?: string;
}

export function Corners(props: CornerProps) {
    const theme = React.useContext(CleanThemeContext);

    if (props.radius === undefined)
        return undefined

    const radius = SizeHelper.toRadius(theme, props.radius);
    if (radius.Scale === 0 && radius.Offset === 0)
        return undefined

    return (
        <uicorner
            key={props.name ?? "Corners"}
            CornerRadius={radius}
        />
    );
}