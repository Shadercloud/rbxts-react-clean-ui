import React, { Binding } from "@rbxts/react";
import { SpacedElementProps } from "../../Interfaces";
import { CleanThemeContext } from "../../Contexts";
import { SpacingHelper } from "../../Helpers";

interface VStackProps extends SpacedElementProps {
    valign?: Enum.VerticalAlignment | "Center" | "Top" | "Bottom" | React.Binding<Enum.VerticalAlignment> | undefined;
    children?: React.ReactNode;
    HorizontalFlex?: Enum.UIFlexAlignment;
    VerticalFlex?: Enum.UIFlexAlignment;
    VerticalAlignment?: Enum.VerticalAlignment;
    Event?: React.InstanceEvent<UIListLayout>;
    Change?: React.InstanceChangeEvent<UIListLayout>;
    Padding?: UDim | Binding<UDim>;
}

export function VStack(props: VStackProps) {
    const theme = React.useContext(CleanThemeContext);

    return (
        <>
            <uilistlayout
                FillDirection={Enum.FillDirection.Vertical}
                HorizontalFlex={props.HorizontalFlex ?? Enum.UIFlexAlignment.Fill}
                VerticalFlex={props.VerticalFlex}
                VerticalAlignment={props.VerticalAlignment ?? props.valign}
                Padding={
                    props.Padding ??
                    new UDim(0, SpacingHelper.GetPadding(theme, props.spacing))
                }
                SortOrder={Enum.SortOrder.LayoutOrder}
                Change={props.Change}
                Event={props.Event}
            />
            {props.children}
        </>
    );
}