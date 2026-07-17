import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";
import { SpacingHelper } from "../../Helpers";

interface VStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    HorizontalFlex?: Enum.UIFlexAlignment;
}

export function VStack(props: VStackProps) {
    const theme = React.useContext(CleanThemeContext);
    const padding = new UDim(0, SpacingHelper.GetPadding(theme, props.spacing))
    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Vertical}
                HorizontalFlex={props.HorizontalFlex ?? Enum.UIFlexAlignment.Fill}
                Padding={padding}
            />
            {props.children}
        </>
    );
}