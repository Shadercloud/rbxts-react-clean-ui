import React from "@rbxts/react";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { DefaultIconSet } from "../../Theme";

interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
}

export function Icon(props: IconProps) {

    if (!props.icon) return undefined

    const theme = React.useContext(CleanThemeContext);

    const iconId = theme.icons[props.icon] ?? DefaultIconSet[props.icon]

    const size = theme.iconSize[props.scale ?? theme.default.scale]

    return (
        <imagelabel
            Size={UDim2.fromOffset(size, size)}
            Image={`rbxassetid://${iconId}`}
            BackgroundTransparency={1}
            ImageColor3={props.color ?? Color3.fromHex("#FFFFFF")}
        />
    );
}