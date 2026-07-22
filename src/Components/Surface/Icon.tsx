import React, { Binding } from "@rbxts/react";
import { useTween } from "@rbxts/react-ripple";
import { IconElementProps, ScalableElementProps } from "../../Interfaces/";
import { CleanThemeContext } from "../../Contexts/";
import { DefaultIconSet } from "../../Theme";

export interface IconProps extends IconElementProps, ScalableElementProps {
    color?: Color3;
    Size?: UDim2;
    spinning?: boolean;
    speed?: number;
    Rotation?: number | Binding<number>;
}

function SpinningIcon(props: IconProps) {
    const [rotation, tween] = useTween(0, {
        duration: props.speed ?? 1,
        easing: "linear",
        repeats: math.huge,
    });

    React.useEffect(() => {
        tween.setGoal(360);
        tween.start()

    });
    return <frame BackgroundTransparency={1} Size={UDim2.fromOffset(0, 0)} AutomaticSize={Enum.AutomaticSize.XY}>
        <Icon Size={props.Size} color={props.color} icon={props.icon} scale={props.scale} Rotation={rotation} />
    </frame>
}

export function Icon(props: IconProps) {
    const theme = React.useContext(CleanThemeContext);

    const iconId =
        props.icon === undefined
            ? undefined
            : theme.icons[props.icon] ?? DefaultIconSet[props.icon];

    const size = theme.iconSize[props.scale ?? theme.default.scale];
    if (props.spinning)
        return <SpinningIcon {...props} />

    return (
        <imagelabel
            Rotation={props.Rotation}
            Size={props.Size ?? UDim2.fromOffset(size, size)}
            Image={
                iconId === undefined
                    ? undefined
                    : `rbxassetid://${iconId}`
            }
            BackgroundTransparency={1}
            ImageColor3={props.color ?? Color3.fromHex("#FFFFFF")}
        />
    );
}