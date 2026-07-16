import React from "@rbxts/react";
import { IconElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { DefaultIconSet } from "../../Theme";

interface IconProps extends IconElementProps {
    color?: Color3;
}

export function Icon(props: IconProps) {

    if (!props.icon) return undefined

    const theme = React.useContext(CleanThemeContext);

    const iconId = theme.icons[props.icon] ?? DefaultIconSet[props.icon]

    return (
        <imagelabel
            Size={UDim2.fromOffset(20, 20)}
            Image={`rbxassetid://${iconId}`}
            BackgroundTransparency={1}
            ImageColor3={props.color ?? Color3.fromHex("#FFFFFF")}
        />
    );
}