import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";

interface VStackProps extends SpacedElementProps {
    children?: React.ReactNode;
}

export function VStack(props: VStackProps) {
    const theme = React.useContext(CleanThemeContext);
    const padding = new UDim(0, theme.spacing[props.spacing ?? theme.default.spacing])
    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Vertical}
                HorizontalFlex={Enum.UIFlexAlignment.Fill}
                Padding={padding}
            />
            {props.children}
        </>
    );
}