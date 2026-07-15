import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";

interface HStackProps extends SpacedElementProps {
    children?: React.ReactNode;
}

export function HStack(props: HStackProps) {
    const theme = React.useContext(CleanThemeContext);
    const padding = new UDim(0, theme.spacing[props.spacing ?? theme.default.spacing])
    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Horizontal}
                Padding={padding}
                Wraps
            />
            {props.children}
        </>
    );
}