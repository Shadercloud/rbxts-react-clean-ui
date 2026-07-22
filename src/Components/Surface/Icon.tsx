import React from "@rbxts/react";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { DefaultIconSet } from "../../Theme";

interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
    Size?: UDim2;
}

export function Icon(props: IconProps) {
    const theme = React.useContext(CleanThemeContext);

    const iconId = props.icon === undefined ? undefined : theme.icons[props.icon] ?? DefaultIconSet[props.icon]

    const size = theme.iconSize[props.scale ?? theme.default.scale]

    return (
        <imagelabel
            Size={props.Size ?? UDim2.fromOffset(size, size)}
            Image={iconId === undefined ? undefined : `rbxassetid://${iconId}`}
            BackgroundTransparency={1}
            ImageColor3={props.color ?? Color3.fromHex("#FFFFFF")}
        />
    );
}