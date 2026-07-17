import React from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";
import { SpacingHelper } from "../../Helpers";

interface HStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
}

export function HStack(props: HStackProps) {
    const theme = React.useContext(CleanThemeContext);
    const padding = new UDim(0, math.ceil(SpacingHelper.GetPadding(theme, props.spacing) / 2))
    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Horizontal}
                VerticalAlignment={props.valign}
                Padding={padding}
                Wraps
            />
            {props.children}
        </>
    );
}