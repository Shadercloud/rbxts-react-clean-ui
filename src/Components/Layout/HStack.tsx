import React, { Binding } from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";
import { SpacingHelper } from "../../Helpers";

interface HStackProps extends SpacedElementProps {
    children?: React.ReactNode;
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
    Wraps?: boolean;
    HorizontalFlex?: Enum.UIFlexAlignment;
    Event?: React.InstanceEvent<UIListLayout>;
    Change?: React.InstanceChangeEvent<UIListLayout>;
    Padding?: UDim | Binding<UDim>;
}

export function HStack(props: HStackProps) {
    const theme = React.useContext(CleanThemeContext);

    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Horizontal}
                HorizontalFlex={props.HorizontalFlex}
                VerticalAlignment={props.valign}
                Padding={
                    props.Padding ??
                    new UDim(0, math.ceil(SpacingHelper.GetPadding(theme, props.spacing) / 2))
                }
                Wraps={props.Wraps === undefined ? true : props.Wraps}
                Change={props.Change}
                Event={props.Event}
            />
            {props.children}
        </>
    );
}